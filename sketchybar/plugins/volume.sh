#!/bin/bash

WIDTH=100
HIDE_DELAY=2
STATE_FILE="/tmp/sketchybar-volume-hide.state"

schedule_hide() {
  local token
  token="$(date +%s)-$$-$RANDOM"
  echo "$token" > "$STATE_FILE"

  (
    sleep "$HIDE_DELAY"
    [ "$(cat "$STATE_FILE" 2>/dev/null)" = "$token" ] || exit 0
    sketchybar --animate tanh 30 --set "$NAME" slider.width=0
  ) >/dev/null 2>&1 &
}

volume_change() {
  source "$CONFIG_DIR/icons.sh"
  case $INFO in
    [6-9][0-9]|100) ICON=$VOLUME_100
    ;;
    [3-5][0-9]) ICON=$VOLUME_66
    ;;
    [1-2][0-9]) ICON=$VOLUME_33
    ;;
    [1-9]) ICON=$VOLUME_10
    ;;
    0) ICON=$VOLUME_0
    ;;
    *) ICON=$VOLUME_100
  esac

  sketchybar --set volume_icon label="$ICON" \
             --set "$NAME" slider.percentage="$INFO" \
             --animate tanh 30 --set "$NAME" slider.width=$WIDTH
  schedule_hide
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE"
}

mouse_entered() {
  sketchybar --set "$NAME" slider.knob.drawing=on
}

mouse_exited() {
  sketchybar --set "$NAME" slider.knob.drawing=off
}

case "$SENDER" in
  "volume_change") volume_change
  ;;
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") mouse_entered
  ;;
  "mouse.exited") mouse_exited
  ;;
esac
