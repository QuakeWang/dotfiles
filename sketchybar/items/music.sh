#!/bin/bash

music=(
	background.padding_right=0
	background.padding_left=4
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	script="$PLUGIN_DIR/music.sh"
	click_script="open -a /Applications/QQ音乐.app"
)

sketchybar --add alias 'QQ音乐' right \
	--set 'music' "${music[@]}"
