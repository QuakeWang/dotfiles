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

export PATH=$HOME/.atuin/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/Library/pnpm:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/go/bin:$PATH
if [[ "$(uname -sm)" = "Darwin arm64" ]]; then export PATH=/opt/homebrew/bin:$PATH; fi

JAVA_HOME=/Users/wangerxi/opt/jdk-17.0.12.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:\
~/opt/apache-maven-3.8.8/bin:\
/usr/local/mysql/bin:\
/opt/homebrew/opt/llvm@16/bin:\
/opt/homebrew/opt/bison/bin:\
/opt/homebrew/opt/texinfo/bin:\
$HOME/Library/Python/3.13/bin:$PATH

export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
. "$HOME/.cargo/env"

export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

autoload -U compinit; compinit
zmodload zsh/complist
autoload -Uz edit-command-line; zle -N edit-command-line

source $ZSHAREDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHAREDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=($ZSHAREDIR/zsh-completions/src $fpath)

FZF_BASE=$(brew --prefix)/opt/fzf
[[ $- == *i* ]] && source $FZF_BASE/shell/completion.zsh 2> /dev/null
source $FZF_BASE/shell/key-bindings.zsh

zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
source ~/.config/smart-suggestion/smart-suggestion.plugin.zsh

source $ZDOTDIR/keymap.zsh
source $ZDOTDIR/function.zsh

