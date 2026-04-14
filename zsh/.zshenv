# Zsh root
ZDOTDIR="$HOME/.config/zsh"
: "${ZSHAREDIR:=$HOME/.local/share/zsh}"

# Zsh related
HISTFILE=$ZDOTDIR/.history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1  # makes the switch between modes quicker
HISTORY_SUBSTRING_SEARCH_PREFIXED=1  # enables prefixed search for zsh-history-substring-search

# Software specific
export EDITOR="nvim"
export VISUAL="nvim"

export BAT_THEME="Catppuccin Mocha"
export HOMEBREW_NO_ANALYTICS=1
export PNPM_HOME="$HOME/Library/pnpm"

export LESSKEYIN="$HOME/.config/less/.lesskey"
export LESSHISTFILE="$HOME/.config/less/.lesshst"

export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
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

typeset -U path PATH

path=(
  # Keep user-managed npm globals ahead of Homebrew so the active CLI matches
  # ~/.npmrc's configured prefix and stale brew binaries cannot shadow them.
  "$HOME/.local/bin"
  "$PNPM_HOME"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  "$HOME/.nix-profile/bin"
  "/etc/profiles/per-user/$USER/bin"
  "/run/current-system/sw/bin"
  "/nix/var/nix/profiles/default/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  $path
)

REGION_ZSH_FILE="$ZDOTDIR/regions/${DOTFILES_REGION:-default}.zsh"
[[ -f "$REGION_ZSH_FILE" ]] && source "$REGION_ZSH_FILE"

LOCAL_ZSH_COMMON_FILE="$HOME/.config/zsh-local/common.zsh"
[[ -f "$LOCAL_ZSH_COMMON_FILE" ]] && source "$LOCAL_ZSH_COMMON_FILE"
