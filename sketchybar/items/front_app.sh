#!/bin/bash

front_app=(
  icon.drawing=off
  label.font="$FONT:Black:12.0"
  associated_display=active
  script="$PLUGIN_DIR/yabai.sh"
)

sketchybar --add event front_app_update        \
           --add item front_app left           \
           --set front_app "${front_app[@]}"   \
           --subscribe front_app front_app_switched \
                                 front_app_update
