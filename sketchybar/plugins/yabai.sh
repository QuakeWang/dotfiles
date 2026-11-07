#!/bin/bash

ICON_MAP_SCRIPT="$CONFIG_DIR/plugins/icon_map.sh"
ICON_CACHE_FILE="/tmp/sketchybar-icon-map.cache"
SPACE_LABEL_CACHE_FILE="/tmp/sketchybar-space-label.cache"
YABAI_BIN="${YABAI_BIN:-$(command -v yabai 2>/dev/null || true)}"
JQ_BIN="${JQ_BIN:-$(command -v jq 2>/dev/null || true)}"

[ -n "$YABAI_BIN" ] || exit 0
[ -n "$JQ_BIN" ] || exit 0

yabai_query() {
  local out
  local attempt

  for attempt in 1 2 3 4 5; do
    out="$("$YABAI_BIN" -m query "$@" 2>/dev/null)" && [ -n "$out" ] && {
      printf '%s' "$out"
      return 0
    }
    sleep 0.05
  done

  return 1
}

clear_space_items() {
  # Ensure space items are visible but clear app-icon labels
  sketchybar --set spaces_bracket drawing=on \
             --set '/space\..*/' drawing=on \
             --set '/space\..*/' background.drawing=on \
             --set '/space\..*/' label=" " \
             --set '/space\..*/' label.drawing=off
}

apply_cached_space_labels() {
  local args
  local has_spaces=false
  local space
  local label

  [ -f "$SPACE_LABEL_CACHE_FILE" ] || return 1

  args=(--set spaces_bracket drawing=off
        --set '/space\..*/' drawing=off
        --set '/space\..*/' label=" "
        --set '/space\..*/' label.drawing=off
        --set '/space\..*/' background.drawing=off
        --animate sin 10)

  while IFS=$'\t' read -r space label
  do
    [ -z "$space" ] && continue
    ensure_space_item "$space"
    args+=(--set "space.$space" label="${label:- }" label.drawing=on)
    args+=(--set "space.$space" drawing=on background.drawing=on)
    has_spaces=true
  done < "$SPACE_LABEL_CACHE_FILE"

  [ "$has_spaces" = true ] && args+=(--set spaces_bracket drawing=on) || return 1
  sketchybar -m "${args[@]}"
  return 0
}

should_ignore_app() {
  case "$1" in
    "DesktopLauncher"|"KeyboardHolder"|"Loader"|"MonitorControl"|"Raycast"|"UU Booster"|"cursor激活器"|"iShotHelper"|"OpenVPN Connect")
      return 0
      ;;
  esac

  return 1
}

window_state() {
  source "$CONFIG_DIR/colors.sh"
  source "$CONFIG_DIR/icons.sh"

  WINDOW_META="$(yabai_query --windows --window | "$JQ_BIN" -r '[."stack-index",."is-floating",."has-fullscreen-zoom",."has-parent-zoom"] | @tsv')"
  IFS=$'\t' read -r STACK_INDEX IS_FLOATING HAS_FULLSCREEN HAS_PARENT <<< "$WINDOW_META"

  STACK_INDEX="${STACK_INDEX:-0}"
  COLOR=$BAR_BORDER_COLOR
  ICON=""
  LABEL=""

  if [ "$IS_FLOATING" = "true" ]; then
    ICON+=$YABAI_FLOAT
    COLOR=$MAGENTA
  elif [ "$HAS_FULLSCREEN" = "true" ]; then
    ICON+=$YABAI_FULLSCREEN_ZOOM
    COLOR=$GREEN
  elif [ "$HAS_PARENT" = "true" ]; then
    ICON+=$YABAI_PARENT_ZOOM
    COLOR=$BLUE
  elif [[ "$STACK_INDEX" -gt 0 ]]; then
    LAST_STACK_INDEX=$(yabai_query --windows --window stack.last | "$JQ_BIN" '.["stack-index"]')
    ICON+=$YABAI_STACK
    LABEL="$(printf "[%s/%s]" "$STACK_INDEX" "$LAST_STACK_INDEX")"
    COLOR=$RED
  fi

  args=(--animate sin 10 --bar border_color=$COLOR
                         --set $NAME icon.color=$COLOR)

  [ -z "$LABEL" ] && args+=(label.width=0) \
                  || args+=(label="$LABEL" label.width=40)

  [ -z "$ICON" ] && args+=(icon.width=0) \
                 || args+=(icon="$ICON" icon.width=30)

  sketchybar -m "${args[@]}"
}

valid_front_app() {
  case "$1" in
    ""|"loginwindow"|"Window Server"|"ControlCenter"|"NotificationCenter")
      return 1
      ;;
  esac

  return 0
}

front_app() {
  local app="$INFO"

  if ! valid_front_app "$app"; then
    app="$(yabai_query --windows --window | "$JQ_BIN" -r '.app // empty' 2>/dev/null)"
  fi

  if ! valid_front_app "$app"; then
    app="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)"
  fi

  valid_front_app "$app" || return
  sketchybar --set "$NAME" label="$app"
}

load_icon_cache() {
  app_cache_keys=()
  app_cache_vals=()

  if [ ! -f "$ICON_CACHE_FILE" ] || [ "$ICON_MAP_SCRIPT" -nt "$ICON_CACHE_FILE" ]; then
    : > "$ICON_CACHE_FILE"
    return
  fi

  while IFS=$'\t' read -r cache_app cache_icon
  do
    local i
    local exists=false

    [ -z "$cache_app" ] && continue
    for i in "${!app_cache_keys[@]}"; do
      if [ "${app_cache_keys[$i]}" = "$cache_app" ]; then
        exists=true
        break
      fi
    done

    if [ "$exists" = false ]; then
      app_cache_keys+=("$cache_app")
      app_cache_vals+=("$cache_icon")
    fi
  done < "$ICON_CACHE_FILE"

  : > "$ICON_CACHE_FILE"
  for i in "${!app_cache_keys[@]}"; do
    printf '%s\t%s\n' "${app_cache_keys[$i]}" "${app_cache_vals[$i]}" >> "$ICON_CACHE_FILE"
  done
}

ICON_RESULT=""
icon_for_app() {
  local app="$1"
  local i

  for i in "${!app_cache_keys[@]}"; do
    if [ "${app_cache_keys[$i]}" = "$app" ]; then
      ICON_RESULT="${app_cache_vals[$i]}"
      return
    fi
  done

  local icon
  icon="$($ICON_MAP_SCRIPT "$app")"
  [ -z "$icon" ] && icon=":default:"

  app_cache_keys+=("$app")
  app_cache_vals+=("$icon")
  printf '%s\t%s\n' "$app" "$icon" >> "$ICON_CACHE_FILE"
  ICON_RESULT="$icon"
}

ensure_space_item() {
  local sid="$1"

  if sketchybar --query "space.$sid" >/dev/null 2>&1; then
    return
  fi

  source "$CONFIG_DIR/colors.sh"

  sketchybar --add space "space.$sid" left \
             --set "space.$sid" associated_space="$sid" \
                               icon="$sid" \
                               icon.padding_left=10 \
                               icon.padding_right=10 \
                               padding_left=2 \
                               padding_right=2 \
                               label.padding_right=20 \
                               icon.highlight_color="$RED" \
                               label.color="$GREY" \
                               label.highlight_color="$WHITE" \
                               label.font="sketchybar-app-font:Regular:16.0" \
                               label.y_offset=-1 \
                               drawing=off \
                               background.color="$BACKGROUND_1" \
                               background.border_color="$BACKGROUND_2" \
                               background.drawing=off \
                               label=" " \
                               label.drawing=off \
                               script="$CONFIG_DIR/plugins/space.sh" \
             --subscribe "space.$sid" mouse.clicked
}

list_spaces() {
  local spaces
  local spaces_json

  spaces_json="$(yabai_query --spaces)" || return 1
  spaces="$(printf '%s' "$spaces_json" | "$JQ_BIN" -r '.[].index' 2>/dev/null)"
  if [ -n "$spaces" ]; then
    printf '%s\n' "$spaces"
    return
  fi

  return 1
}

windows_on_spaces () {
  local args
  local has_spaces=false
  local space_indexes
  local windows_json
  local space_windows_json
  local cache_buffer=""

  space_indexes="$(list_spaces)"
  windows_json="$(yabai_query --windows)"

  if [ -z "$space_indexes" ] || [ -z "$windows_json" ]; then
    apply_cached_space_labels && return
    clear_space_items
    return
  fi

  args=(--set spaces_bracket drawing=off
        --set '/space\..*/' drawing=off
        --set '/space\..*/' label=" "
        --set '/space\..*/' label.drawing=off
        --set '/space\..*/' background.drawing=off
        --animate sin 10)

  load_icon_cache

  while IFS= read -r space
  do
    [ -z "$space" ] && continue
    ensure_space_item "$space"
    has_spaces=true

    icon_strip=" "
    space_windows_json="$(yabai_query --windows --space "$space")"
    [ -z "$space_windows_json" ] && space_windows_json="$windows_json"

    apps="$(printf '%s' "$space_windows_json" | "$JQ_BIN" -r --argjson sid "$space" '.[]
      | select(.space == $sid or .space == null)
      | select(.app != null and .app != "")
      | select(."is-minimized" == false and ."is-hidden" == false and ."is-sticky" == false)
      | .app' 2>/dev/null)"
    if [ -n "$apps" ]; then
      while IFS= read -r app_name
      do
        [ -z "$app_name" ] && continue
        should_ignore_app "$app_name" && continue

        icon_for_app "$app_name"
        case " $icon_strip " in
          *" $ICON_RESULT "*) ;;
          *) icon_strip="$icon_strip $ICON_RESULT" ;;
        esac
      done <<< "$apps"
    fi

    args+=(--set "space.$space" label="$icon_strip" label.drawing=on)
    args+=(--set "space.$space" drawing=on background.drawing=on)
    cache_buffer+="$space"$'\t'"$icon_strip"$'\n'
  done <<< "$space_indexes"

  [ "$has_spaces" = true ] && args+=(--set spaces_bracket drawing=on)

  sketchybar -m "${args[@]}"
  [ -n "$cache_buffer" ] && printf '%s' "$cache_buffer" > "$SPACE_LABEL_CACHE_FILE"
}

mouse_clicked() {
  "$YABAI_BIN" -m window --toggle float
  window_state
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "forced")
    [ "$NAME" = "front_app" ] && front_app
    exit 0
  ;;
  "front_app_switched" | "front_app_update") front_app
  ;;
  "window_focus") window_state
  ;;
  "windows_on_spaces" | "space_change") windows_on_spaces
  ;;
esac
