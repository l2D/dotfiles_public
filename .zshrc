# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
eval "$(mise activate zsh)"

# Load custom aliases and functions
if [[ -f ~/.config/zsh/aliases.zsh ]]; then
  source ~/.config/zsh/aliases.zsh
fi

if [[ -f ~/.config/zsh/functions.zsh ]]; then
  source ~/.config/zsh/functions.zsh
fi

# Load plugins
if [[ -f ~/.config/zsh/plugins.zsh ]]; then
  source ~/.config/zsh/plugins.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
