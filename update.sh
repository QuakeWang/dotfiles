#!/bin/bash

# replace with your path
readonly MY_PATH="$HOME/workspaces/GitHub/dotfiles"

## update all config

## kitty
cp "$HOME/.config/kitty/"* "$MY_PATH/kitty"

## neovim
cp -r "$HOME/.config/nvim/"* "$MY_PATH/nvim/"

## sketchybar
cp -rf "$HOME/.config/sketchybar" "$MY_PATH/"

## skhd
cp -rf "$HOME/.config/skhd" "$MY_PATH/"

## starship
cp -rf "$HOME/.config/starship.toml" "$MY_PATH/"

## yabai
cp -rf "$HOME/.config/yabai" "$MY_PATH/"
