# Zsh root
ZDOTDIR=$HOME/.config/zsh
ZSHAREDIR=$HOME/.local/share/zsh

# Zsh related
HISTFILE=$ZDOTDIR/.history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1  # makes the switch between modes quicker
HISTORY_SUBSTRING_SEARCH_PREFIXED=1  # enables prefixed search for zsh-history-substring-search

# Temporary variables
__TREE_IGNORE="-I '.git' -I '*.py[co]' -I '__pycache__' $__TREE_IGNORE"
__FD_COMMAND="-L -H --no-ignore-vcs ${__TREE_IGNORE//-I/-E} $__FD_COMMAND"

# Software specific
export EDITOR="nvim"
export VISUAL="nvim"

export BAT_THEME="Catppuccin Mocha"
export HOMEBREW_NO_ANALYTICS=1
export PNPM_HOME=$HOME/Library/pnpm

export LESSKEYIN=$HOME/.config/less/.lesskey
export LESSHISTFILE=$HOME/.config/less/.lesshst

export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS="
  --height 50% --layout=reverse --border --cycle
  --preview-window=right:60%:wrap
  --bind=ctrl-h:backward-char,ctrl-l:forward-char,ctrl-j:down,ctrl-k:up
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

# Clean up
unset __TREE_IGNORE
unset __FD_COMMAND
