# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnosterzak"

plugins=(
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# check the dnf plugins commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dnf


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

$HOME/bins/stcat.sh # fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
eval "$(zoxide init zsh)"

alias cd=z
alias v=nvim .
alias know=tldr
alias sdi="sudo dnf install"
eval "$(starship init zsh)"


ff() {
  local selected
  selected=$(fzf -m --preview="bat --style=numbers --color=always --line-range :500 {}" "$@")

  [[ -z "$selected" ]] && return  # Nothing selected, exit

  # Split multi-selection into array
  local items=("${(f)selected}")

  for item in "${items[@]}"; do
    if [[ -f "$item" ]]; then
      nvim "$item"
    else
      xdg-open "$item" &>/dev/null & disown  # Background to keep terminal responsive
    fi
  done
}


export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Created by `pipx` on 2025-12-26 12:15:14
export PATH="$PATH:/home/alamin/.local/bin"

export PATH=$PATH:/home/alamin/.spicetify
export PATH=$PATH:~/.spicetify

# Load secrets
[[ -f ~/$HOME/my-dotfiles/env/secrets.env ]] && source ~/$HOME/my-dotfiles/env/secrets.env
