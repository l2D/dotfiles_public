

## Functions

function mkcd() {
  # Create a directory and change into it
  mkdir -p "$1" && cd "$1"
}

function lt() {
    # Usage: lt [depth] [path] [additional_tree_options]
    # If first arg is a number, treat it as depth, otherwise as path
    local depth=1
    local path="."
    local start_arg=1
    
    # Check if first argument is a number (depth)
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        depth="$1"
        start_arg=2
    fi
    
    # Check if we have a path argument
    if [[ -n "$2" && "$1" =~ ^[0-9]+$ ]] || [[ -n "$1" && ! "$1" =~ ^[0-9]+$ ]]; then
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            path="$2"
            start_arg=3
        else
            path="$1"
            start_arg=2
        fi
    fi
    
    /opt/homebrew/bin/tree -L "$depth" -C -I 'node_modules|.git|.idea|.vscode|dist|build|coverage|vendor' "$path" "${@:$start_arg}"
}

function extract() {
  # Extract files based on their extension
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1" ;;
      *.tar.gz)    tar xvzf "$1" ;;
      *.bz2)       bunzip2 "$1" ;;
      *.rar)       unrar x "$1" ;;
      *.gz)        gunzip "$1" ;;
      *.tar)       tar xvf "$1" ;;
      *.tbz2)      tar xvjf "$1" ;;
      *.tgz)       tar xvzf "$1" ;;
      *.zip)       unzip "$1" ;;
      *)           echo "Cannot extract '$1' - unknown file type." ;;
    esac
  else
    echo "'$1' is not a valid file."
  fi
}

function copy_to_clipboard() {
  # Copy the output of a command to the clipboard
  if command -v pbcopy &> /dev/null; then
    "$@" | pbcopy
  elif command -v xclip &> /dev/null; then
    "$@" | xclip -selection clipboard
  else
    echo "No clipboard utility found."
  fi
}