#!/bin/bash
set -e

sudo_askpass() {
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass "$@"
  else
    sudo "$@"
  fi
}

cleanup() {
  set +e
  sudo_askpass rm -rf "$CLT_PLACEHOLDER" "$SUDO_ASKPASS" "$SUDO_ASKPASS_DIR"
  sudo --reset-timestamp
  if [ -z "$STRAP_SUCCESS" ]; then
    if [ -n "$STRAP_STEP" ]; then
      echo "!!! $STRAP_STEP FAILED" >&2
    else
      echo "!!! FAILED" >&2
    fi
    if [ -z "$STRAP_DEBUG" ]; then
      echo "!!! Run '$0 --debug' for debugging output." >&2
      echo "!!! If you're stuck: file an issue with debugging output at:" >&2
      echo "!!!   $STRAP_ISSUES_URL" >&2
    fi
  fi
}

trap "cleanup" EXIT

if [ -n "$STRAP_DEBUG" ]; then
  set -x
else
  STRAP_QUIET_FLAG="-q"
  Q="$STRAP_QUIET_FLAG"
fi

STDIN_FILE_DESCRIPTOR="0"
[ -t "$STDIN_FILE_DESCRIPTOR" ] && STRAP_INTERACTIVE="1"

STRAP_GIT_NAME='<your name>'
STRAP_GIT_EMAIL='<your email>'
STRAP_GITHUB_USER='<your github username>'
# STRAP_GITHUB_TOKEN=''

# We want to always prompt for sudo password at least once rather than doing
# root stuff unexpectedly.
sudo --reset-timestamp

# functions for turning off debug for use when handling the user password
clear_debug() {
  set +x
}

reset_debug() {
  if [ -n "$STRAP_DEBUG" ]; then
    set -x
  fi
}

# Initialise (or reinitialise) sudo to save unhelpful prompts later.
sudo_init() {
  if [ -z "$STRAP_INTERACTIVE" ]; then
    return
  fi

  # If TouchID for sudo is setup: use that instead.
  if grep -q pam_tid /etc/pam.d/sudo; then
    return
  fi

  local SUDO_PASSWORD SUDO_PASSWORD_SCRIPT

  if ! sudo --validate --non-interactive &>/dev/null; then
    while true; do
      read -rsp "--> Enter your password (for sudo access):" SUDO_PASSWORD
      echo
      if sudo --validate --stdin 2>/dev/null <<<"$SUDO_PASSWORD"; then
        break
      fi

      unset SUDO_PASSWORD
      echo "!!! Wrong password!" >&2
    done

    clear_debug
    SUDO_PASSWORD_SCRIPT="$(
      cat <<BASH
#!/bin/bash
echo "$SUDO_PASSWORD"
BASH
    )"
    unset SUDO_PASSWORD
    SUDO_ASKPASS_DIR="$(mktemp -d)"
    SUDO_ASKPASS="$(mktemp "$SUDO_ASKPASS_DIR"/strap-askpass-XXXXXXXX)"
    chmod 700 "$SUDO_ASKPASS_DIR" "$SUDO_ASKPASS"
    bash -c "cat > '$SUDO_ASKPASS'" <<<"$SUDO_PASSWORD_SCRIPT"
    unset SUDO_PASSWORD_SCRIPT
    reset_debug

    export SUDO_ASKPASS
  fi
}

sudo_refresh() {
  clear_debug
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass --validate
  else
    sudo_init
  fi
  reset_debug
}

abort() {
  STRAP_STEP=""
  echo "!!! $*" >&2
  exit 1
}

log() {
  STRAP_STEP="$*"
  sudo_refresh
  echo "--> $*"
}

logn() {
  STRAP_STEP="$*"
  sudo_refresh
  printf -- "--> %s " "$*"
}

logk() {
  STRAP_STEP=""
  echo "OK"
}

logskip() {
  STRAP_STEP=""
  echo "SKIPPED"
  echo "$*"
}

escape() {
  printf '%s' "${1//\'/\'}"
}

# Prevent sleeping during script execution, as long as the machine is on AC power
caffeinate -s -w $$ &

# Check and, if necessary, enable sudo authentication using TouchID.
# Don't care about non-alphanumeric filenames when doing a specific match
# shellcheck disable=SC2010
if ls /usr/lib/pam | grep $Q "pam_tid.so"; then
  logn "Configuring sudo authentication using TouchID:"
  PAM_FILE="/etc/pam.d/sudo"
  FIRST_LINE="# sudo: auth account password session"
  if grep $Q pam_tid.so "$PAM_FILE"; then
    logk
  elif ! head -n1 "$PAM_FILE" | grep $Q "$FIRST_LINE"; then
    logskip "$PAM_FILE is not in the expected format!"
  else
    TOUCHID_LINE="auth       sufficient     pam_tid.so"
    sudo_askpass sed -i .bak -e \
      "s/$FIRST_LINE/$FIRST_LINE\n$TOUCHID_LINE/" \
      "$PAM_FILE"
    sudo_askpass rm "$PAM_FILE.bak"
    logk
  fi
fi

# Set some basic security settings.
logn "Configuring security settings:"
sudo_askpass defaults write com.apple.Safari \
  com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled \
  -bool false
sudo_askpass defaults write com.apple.Safari \
  com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles \
  -bool false
sudo_askpass defaults write com.apple.screensaver askForPassword -int 1
sudo_askpass defaults write com.apple.screensaver askForPasswordDelay -int 0
sudo_askpass defaults write /Library/Preferences/com.apple.alf globalstate -int 1
sudo_askpass launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist 2>/dev/null

if [ -n "$STRAP_GIT_NAME" ] && [ -n "$STRAP_GIT_EMAIL" ]; then
  LOGIN_TEXT=$(escape "Found this computer? Please contact $STRAP_GIT_NAME at $STRAP_GIT_EMAIL.")
  echo "$LOGIN_TEXT" | grep -q '[()]' && LOGIN_TEXT="'$LOGIN_TEXT'"
  sudo_askpass defaults write /Library/Preferences/com.apple.loginwindow \
    LoginwindowText \
    "$LOGIN_TEXT"
fi
logk

# Check and enable full-disk encryption.
logn "Checking full-disk encryption status:"
if fdesetup status | grep $Q -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
  logk
elif [ -n "$STRAP_CI" ]; then
  echo "SKIPPED (for CI)"
elif [ -n "$STRAP_INTERACTIVE" ]; then
  echo
  log "Enabling full-disk encryption on next reboot:"
  sudo_askpass fdesetup enable -user "$USER" \
    | tee ~/Desktop/"FileVault Recovery Key.txt"
  logk
else
  echo
  abort "Run 'sudo fdesetup enable -user \"$USER\"' to enable full-disk encryption."
fi

# Install the Xcode Command Line Tools.
if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
  log "Installing the Xcode Command Line Tools:"
  CLT_PLACEHOLDER="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  sudo_askpass touch "$CLT_PLACEHOLDER"

  CLT_PACKAGE=$(softwareupdate -l \
    | grep -B 1 "Command Line Tools" \
    | awk -F"*" '/^ *\*/ {print $2}' \
    | sed -e 's/^ *Label: //' -e 's/^ *//' \
    | sort -V \
    | tail -n1)
  sudo_askpass softwareupdate -i "$CLT_PACKAGE"
  sudo_askpass rm -f "$CLT_PLACEHOLDER"
  if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
    if [ -n "$STRAP_INTERACTIVE" ]; then
      echo
      logn "Requesting user install of Xcode Command Line Tools:"
      xcode-select --install
    else
      echo
      abort "Run 'xcode-select --install' to install the Xcode Command Line Tools."
    fi
  fi
  logk
fi

# Check if the Xcode license is agreed to and agree if not.
xcode_license() {
  if /usr/bin/xcrun clang 2>&1 | grep $Q license; then
    if [ -n "$STRAP_INTERACTIVE" ]; then
      logn "Asking for Xcode license confirmation:"
      sudo_askpass xcodebuild -license
      logk
    else
      abort "Run 'sudo xcodebuild -license' to agree to the Xcode license."
    fi
  fi
}
xcode_license

# Check and install any remaining software updates.
logn "Checking for software updates:"
if softwareupdate -l 2>&1 | grep $Q "No new software available."; then
  logk
else
  echo
  log "Installing software updates:"
  if [ -z "$STRAP_CI" ]; then
    sudo_askpass softwareupdate --install --all
    xcode_license
    logk
  else
    echo "SKIPPED (for CI)"
  fi
fi

# Install HomeBrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Brew install from BrewFile
sh "brew bundle"

STRAP_SUCCESS="1"
log "Your system is now Strap'd!"
