#!/bin/bash

TARGET_APP="${1:-$NAME}"
APP_LINE="$(lsappinfo -all list | grep -F -m1 -- "$TARGET_APP" || true)"

if [ -n "$APP_LINE" ]; then
	LABEL="$(echo "$APP_LINE" | sed -nE 's/.*"StatusLabel"=\{ "label"="?([^"}]*)"? \}.*/\1/p')"
	if [ -z "$LABEL" ]; then
		LABEL=0
	fi
else
	LABEL="?"
fi

sketchybar --set "$NAME" label="$LABEL"
