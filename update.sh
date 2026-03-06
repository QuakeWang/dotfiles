#!/usr/bin/env bash

set -euo pipefail

readonly MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

copy_config_dir() {
  local name="$1"
  if [[ -d "$HOME/.config/$name" ]]; then
    mkdir -p "$MY_PATH/$name"
    cp -Rf "$HOME/.config/$name/." "$MY_PATH/$name"
    echo "Updated $name"
  else
    echo "Skip $name (not found in ~/.config)"
  fi
}

copy_config_dir btop
copy_config_dir fastfetch
copy_config_dir kitty
copy_config_dir nvim
copy_config_dir sketchybar
copy_config_dir skhd
copy_config_dir yazi
copy_config_dir zsh
copy_config_dir yabai

mkdir -p "$MY_PATH/starship"
if [[ -f "$HOME/.config/starship.toml" ]]; then
  cp -f "$HOME/.config/starship.toml" "$MY_PATH/starship/starship.toml"
  echo "Updated starship"
else
  echo "Skip starship (not found in ~/.config)"
fi

mkdir -p "$MY_PATH/bat/themes"
if [[ -d "$HOME/.config/bat/themes" ]]; then
  cp -Rf "$HOME/.config/bat/themes/." "$MY_PATH/bat/themes"
  echo "Updated bat"
else
  echo "Skip bat (not found in ~/.config/bat/themes)"
fi

if [[ -f "$HOME/Library/Application Support/Code/User/settings.json" ]]; then
  mkdir -p "$MY_PATH/vscode"
  cp -f "$HOME/Library/Application Support/Code/User/settings.json" "$MY_PATH/vscode/setting.json"
  echo "Updated vscode settings"
else
  echo "Skip vscode settings (not found)"
fi
