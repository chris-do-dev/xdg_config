# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/chris/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/chris/.fzf/bin"
fi

eval "$(fzf --zsh)"
