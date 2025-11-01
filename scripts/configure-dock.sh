#!/usr/bin/env bash

# ==============================================================================
# Dock Configuration Script
# ==============================================================================
# This script removes unwanted apps from the macOS Dock, adds new apps,
# and arranges them in a specific order.
#
# Usage:
#   ./scripts/configure-dock.sh           # Apply changes
#   ./scripts/configure-dock.sh --dry-run # Preview changes without applying
#
# Requirements:
#   - macOS
#   - dockutil (install via: brew install dockutil)
#
# Compatibility:
#   Supports macOS versions with different app names:
#   - macOS 26+: "Apps" (was "Launchpad"), "Games" (was "Game Center")
#   - macOS 15 and earlier: "Launchpad", "Game Center"
# ==============================================================================

# set -e disabled to allow script to continue when apps are not found
# We handle errors explicitly in add_app function

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dry run mode
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${BLUE}Running in DRY RUN mode - no changes will be applied${NC}\n"
fi

# ==============================================================================
# Helper Functions
# ==============================================================================

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

get_macos_version() {
    local version=$(sw_vers -productVersion 2>/dev/null || echo "0")
    echo "${version%%.*}"  # Extract major version
}

get_app_name() {
    local app="$1"
    local macos_version="$2"
    
    # macOS 26+ renamed these apps
    if [[ "$macos_version" -ge 26 ]]; then
        case "$app" in
            "Launchpad")
                echo "Apps"
                ;;
            "Game Center")
                echo "Games"
                ;;
            *)
                echo "$app"
                ;;
        esac
    else
        echo "$app"
    fi
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    if ! command -v dockutil &> /dev/null; then
        log_error "dockutil is not installed"
        echo ""
        echo "Please install dockutil using Homebrew:"
        echo "  brew install dockutil"
        echo ""
        exit 1
    fi
    
    log_success "dockutil is installed"
}

find_app_path() {
    local app_name="$1"
    local app_path=""
    
    # Common application paths
    local search_paths=(
        "/Applications/${app_name}.app"
        "/System/Applications/${app_name}.app"
        "/Applications/Utilities/${app_name}.app"
        "/System/Applications/Utilities/${app_name}.app"
    )
    
    for path in "${search_paths[@]}"; do
        if [[ -d "$path" ]]; then
            app_path="$path"
            break
        fi
    done
    
    echo "$app_path"
}

remove_app() {
    local app_name="$1"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Would remove: $app_name"
        return
    fi
    
    # Try to remove the app (suppress error if it's not in the Dock)
    if dockutil --remove "$app_name" --no-restart 2>/dev/null; then
        log_success "Removed: $app_name"
    else
        log_warning "Not in Dock: $app_name"
    fi
}

add_app() {
    local app_name="$1"
    local position="$2"
    local app_path
    
    app_path=$(find_app_path "$app_name")
    
    if [[ -z "$app_path" ]]; then
        log_warning "App not found, skipping: $app_name"
        return 1
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Would add at position $position: $app_name ($app_path)"
        return 0
    fi
    
    # Remove first if it exists to avoid duplicates
    dockutil --remove "$app_name" --no-restart 2>/dev/null || true
    
    # Add the app at the specified position
    if dockutil --add "$app_path" --position "$position" --no-restart 2>/dev/null; then
        log_success "Added at position $position: $app_name"
        return 0
    else
        log_error "Failed to add: $app_name"
        return 1
    fi
}

# ==============================================================================
# Main Script
# ==============================================================================

echo "======================================================================"
echo "  macOS Dock Configuration"
echo "======================================================================"
echo ""

check_prerequisites
echo ""

# ------------------------------------------------------------------------------
# Step 1: Remove unwanted apps
# ------------------------------------------------------------------------------
log_info "Removing unwanted apps from Dock..."
echo ""

apps_to_remove=(
    "Safari"
    "Messages"
    "Mail"
    "Maps"
    "Photos"
    "FaceTime"
    "Phone"
    "Calendar"
    "Contacts"
    "Reminders"
    "Notes"
    "TV"
    "Keynote"
    "Numbers"
    "Pages"
    "Launchpad"        # macOS 15 and earlier
    "Apps"             # macOS 26+ (renamed from Launchpad)
    "Game Center"      # macOS 15 and earlier
    "Games"            # macOS 26+ (renamed from Game Center)
    "App Store"
    "iPhone Mirroring"
)

for app in "${apps_to_remove[@]}"; do
    remove_app "$app"
done

echo ""

# ------------------------------------------------------------------------------
# Step 2: Add and order apps
# ------------------------------------------------------------------------------
log_info "Adding and ordering apps in Dock..."
echo ""

# Detect macOS version for app name compatibility
MACOS_VERSION=$(get_macos_version)

# Define apps in desired order
# Position starts at 1
declare -a dock_apps=(
    "Finder"
    "$(get_app_name "Launchpad" "$MACOS_VERSION")"
    "System Settings"
    "Arc"
    "Warp"
    "Cursor"
    "GitKraken"
    "Docker"
    "Slack"
    "Microsoft Teams"
    "1Password"
    "Music"
)

position=1
for app in "${dock_apps[@]}"; do
    # Finder is usually always present, so we skip adding it
    if [[ "$app" == "Finder" ]]; then
        log_info "Skipping Finder (always present)"
        ((position++))
        continue
    fi
    
    # Only increment position if app was successfully added
    if add_app "$app" "$position"; then
        ((position++))
    fi
done

echo ""

# ------------------------------------------------------------------------------
# Step 3: Restart Dock
# ------------------------------------------------------------------------------
if [[ "$DRY_RUN" == false ]]; then
    log_info "Restarting Dock to apply changes..."
    killall Dock
    log_success "Dock restarted successfully"
else
    log_info "Dry run complete - no changes were applied"
fi

echo ""
echo "======================================================================"
echo "  Dock configuration complete!"
echo "======================================================================"
