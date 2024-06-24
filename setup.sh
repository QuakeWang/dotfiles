#!/bin/bash

# install yabai
brew install koekeishiya/formulae/yabai

# install starship
brew install starship

# install sketchybar
brew tap FelixKratz/formulae
brew install sketchybar

# install skhd
brew install koekeishiya/formulae/skhd

# install dependencies
brew install --cask sf-symbols
brew install jq
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.19/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# clone config
git clone git@github.com:QuakeWang/dotfiles.git  ~/.config

# start yabai
yabai --start-service

# start skhd
skhd --start-service

# start sketchybar
brew services start sketchybar