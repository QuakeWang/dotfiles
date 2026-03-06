#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step() {
  local title="$*"
  local width=$(( ${#title} + 6 ))
  local line
  line=$(printf '%*s' "$width" '' | tr ' ' '#')

  echo
  echo "$line"
  printf '## %s ##\n' "$title"
  echo "$line"
  echo
}

install_formula() {
  local pkg="$1"
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    echo "'$pkg' is already installed, you're set."
  else
    brew install "$pkg"
  fi
}

install_cask() {
  local pkg="$1"
  if brew list --cask "$pkg" >/dev/null 2>&1; then
    echo "'$pkg' is already installed, you're set."
  else
    brew install --cask "$pkg"
  fi
}

sync_repo() {
  local url="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only >/dev/null 2>&1 || true
  else
    mkdir -p "$(dirname "$dest")"
    git clone --depth 1 "$url" "$dest"
  fi
}

step "Installing xcode command line tools if not already installed"
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode CLI tools not found. Installing them..."
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
  softwareupdate -i "$PROD" -v
else
  echo "'xcode command line tools' is already installed, you're set."
fi

step "Installing brew if not already installed"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_BIN="$(command -v brew || true)"
if [[ -z "$BREW_BIN" && -x /opt/homebrew/bin/brew ]]; then
  BREW_BIN="/opt/homebrew/bin/brew"
elif [[ -z "$BREW_BIN" && -x /usr/local/bin/brew ]]; then
  BREW_BIN="/usr/local/bin/brew"
fi

if [[ -z "$BREW_BIN" ]]; then
  echo "Homebrew installation failed or brew is not in PATH." >&2
  exit 1
fi

eval "$("$BREW_BIN" shellenv)"

step "Installing dependencies/apps/sketchybar if not already installed"
brew tap FelixKratz/formulae
install_formula sketchybar

step "Installing dependencies/apps/borders if not already installed"
install_formula borders

step "Tapping koekeishiya repo"
brew tap koekeishiya/formulae

step "Installing dependencies/apps/yabai if not already installed"
install_formula yabai

step "Installing dependencies/apps/skhd if not already installed"
install_formula skhd

step "Installing dependencies/apps/kitty if not already installed"
install_cask kitty

step "Installing base terminal and shell tooling"
install_formula jq
install_formula btop
install_formula wget
install_formula starship
install_formula neovim
install_formula fastfetch
install_formula yazi
install_formula bat
install_formula eza
install_formula dust
install_formula lazygit
install_formula fzf
install_formula zoxide
install_formula atuin
install_formula ripgrep
install_formula fd
install_formula the_silver_searcher
install_formula zsh-autosuggestions
install_formula zsh-syntax-highlighting
install_formula zsh-completions

step "Installing zsh plugin repositories into ~/.local/share/zsh"
sync_repo "https://github.com/zsh-users/zsh-autosuggestions.git" "$HOME/.local/share/zsh/zsh-autosuggestions"
sync_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.local/share/zsh/zsh-syntax-highlighting"
sync_repo "https://github.com/zsh-users/zsh-completions.git" "$HOME/.local/share/zsh/zsh-completions"

step "Installing fonts"
brew tap homebrew/cask-fonts
install_cask font-hack-nerd-font
install_cask font-sf-mono
install_cask font-fira-code
install_cask font-symbols-only-nerd-font
install_cask sf-symbols

step "Moving everything to the right place"
for dir in btop fastfetch kitty nvim sketchybar skhd yabai yazi; do
  mkdir -p "$HOME/.config/$dir"
  cp -Rf "$DOTFILES_DIR/$dir/." "$HOME/.config/$dir"
  echo "Moved $dir"
done

mkdir -p "$HOME/.config/zsh"
cp -Rf "$DOTFILES_DIR/zsh/." "$HOME/.config/zsh"
echo "Moved zsh"

mkdir -p "$HOME/.config/bat/themes"
cp -Rf "$DOTFILES_DIR/bat/themes/." "$HOME/.config/bat/themes"
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null 2>&1 || true
fi
echo "Moved bat"

cp "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
echo "Moved starship"

VS_CODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VS_CODE_USER_DIR"
cp "$DOTFILES_DIR/vscode/setting.json" "$VS_CODE_USER_DIR/settings.json"
echo "Moved vscode settings"

step "Bootstrapping zsh startup"
if [[ -e "$HOME/.zshenv" && ! -L "$HOME/.zshenv" ]]; then
  backup="$HOME/.zshenv.backup.$(date +%Y%m%d-%H%M%S)"
  cp "$HOME/.zshenv" "$backup"
  echo "Backed up existing ~/.zshenv to $backup"
fi
ln -sfn "$HOME/.config/zsh/.zshenv" "$HOME/.zshenv"
echo "Linked ~/.zshenv -> ~/.config/zsh/.zshenv"

step "Hiding Dock and menu bar"
read -r -p "Is your dock currently hidden? (y/n) " dock_hide
if [[ "$dock_hide" == "n" ]]; then
  osascript -e 'tell application "System Events" to set the autohide of the dock preferences to true'
fi

read -r -p "Is your menu bar currently hidden? (y/n) " menu_hide
if [[ "$menu_hide" == "n" ]]; then
  osascript -e 'tell application "System Events" to tell dock preferences to set autohide menu bar to true'
fi

step "Starting services"
yabai --start-service || true
skhd --start-service || true
brew services start sketchybar || true
brew services start borders || true

step "All done"
echo "Restart terminal (or run: exec zsh -l) to use the new zsh config."
