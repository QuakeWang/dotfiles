#!/bin/bash

# replace with your path
readonly MY_PATH="$HOME/workspaces/dotfiles"

## update all config

## btop
cp "$HOME/.config/btop/"* "$MY_PATH/btop"

## fastfetch
cp "$HOME/.config/fastfetch/"* "$MY_PATH/fastfetch"

## kitty
cp "$HOME/.config/kitty/"* "$MY_PATH/kitty"

## neovim
cp -r "$HOME/.config/nvim/"* "$MY_PATH/nvim/"

## sketchybar
cp -rf "$HOME/.config/sketchybar" "$MY_PATH/"

## skhd
cp -rf "$HOME/.config/skhd" "$MY_PATH/"

## starship
cp -rf "$HOME/.config/starship.toml" "$MY_PATH/starship/"

## yabai
cp -rf "$HOME/.config/yabai" "$MY_PATH/"
