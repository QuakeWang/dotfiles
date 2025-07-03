zsh_start_time=$(date +%s.%N)

ZDOTDIR=$HOME/.config/zsh
ZSHAREDIR=$HOME/.local/share/zsh

HISTFILE=$ZDOTDIR/.history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1

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

export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="Catppuccin Mocha"
export HOMEBREW_NO_ANALYTICS=1
export LESSKEYIN=$HOME/.config/less/.lesskey
export LESSHISTFILE=$HOME/.config/less/.lesshst

export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS="
  --height 50% --layout=reverse --border --cycle
  --preview-window=right:60%:wrap
  --color=bg:#1e1e2e,bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,fg+:#cdd6f4,header:#f38ba8,info:#cba6f7
  --color=pointer:#f5e0dc,marker:#f5e0dc,prompt:#cba6f7
  --color=border:#6c7086,gutter:#1e1e2e
  --prompt='❯ ' --pointer='❯' --marker='❯'
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || 
             ([[ -d {} ]] && (ls -la --color=always {} | less)) || 
             echo {} 2> /dev/null | head -200'
"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window=down:3:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
"
export FZF_CTRL_T_OPTS="
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || 
             ([[ -d {} ]] && (ls -la --color=always {} | less)) || 
             echo {} 2> /dev/null | head -200'
  --bind 'ctrl-/:change-preview-window(down|hidden|right)'
"

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
/Users/wangerxi/opt/apache-maven-3.8.8/bin:\
/usr/local/mysql/bin:\
/opt/homebrew/opt/llvm@16/bin:\
/opt/homebrew/opt/bison/bin:\
/opt/homebrew/opt/texinfo/bin:\
/Users/wangerxi/workspaces/selectdb/doris/bin:\
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

# Load Starship prompt before our custom prompt additions
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
source ~/.config/smart-suggestion/smart-suggestion.plugin.zsh

# Load keymaps with mode indicators
source $ZDOTDIR/keymap.zsh
source $ZDOTDIR/function.zsh

# Replace previous fzf-find-file-and-edit binding with our new zsh-edit function

zsh_end_time=$(date +%s.%N)
zsh_total_duration=$(echo "$zsh_end_time - $zsh_start_time" | bc)
echo "ZSH startup time: ${zsh_total_duration} seconds"