#!/bin/bash

YABAI_BIN="${YABAI_BIN:-$(command -v yabai 2>/dev/null || true)}"
[ -n "$YABAI_BIN" ] || exit 0

update() {
  source "$CONFIG_DIR/colors.sh"
  COLOR=$BACKGROUND_2
  if [ "$SELECTED" = "true" ]; then
    COLOR=$GREY
  fi
  sketchybar --set $NAME icon.highlight=$SELECTED \
                         label.highlight=$SELECTED \
                         background.border_color=$COLOR
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    "$YABAI_BIN" -m space --destroy "$SID"
    sketchybar --trigger windows_on_spaces --trigger space_change
  else
    "$YABAI_BIN" -m space --focus "$SID" 2>/dev/null
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
