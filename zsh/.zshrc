# Enable vi mode
bindkey -v

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
unsetopt AUTO_REMOVE_SLASH
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt EXTENDED_HISTORY

ulimit -n 65536

function fzf-find-file-and-edit() {
  local file=$(
    fzf --query="$1" --no-multi --select-1 --exit-0 \
        --preview 'bat --style=numbers --color=always {} 2> /dev/null | head -500'
  )
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

ORBSTACK_COMPLETIONS="/Applications/OrbStack.app/Contents/Resources/completions/zsh"
if [[ -d "$ORBSTACK_COMPLETIONS" ]]; then
  fpath=("$ORBSTACK_COMPLETIONS" $fpath)
fi

fpath=("$ZSHAREDIR/site-functions" $fpath)
autoload -U compinit; compinit -C
zmodload zsh/complist
autoload -Uz edit-command-line; zle -N edit-command-line

[[ -f "$ZSHAREDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "$ZSHAREDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$ZSHAREDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] &&
  source "$ZSHAREDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
[[ -f "$ZSHAREDIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source "$ZSHAREDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ $- == *i* ]] && source "$ZSHAREDIR/fzf/completion.zsh" 2> /dev/null
[[ -f "$ZSHAREDIR/fzf/key-bindings.zsh" ]] && source "$ZSHAREDIR/fzf/key-bindings.zsh"

zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

source $ZDOTDIR/keymap.zsh
source $ZDOTDIR/function.zsh
