#!/bin/sh -ex

# 1. assigns key with keycode $1 to:
#   - Escape when pressed by itself 
#   - Super_L when pressed in combination with another key
# 2. assigns Super_L to mod3
esc_mod3() {
	if command -v xcape > /dev/null 2>&1; then
		modifier='Super_L'
		xmodmap -e "keycode $1 = $modifier"

		awk_cmd="$( printf '/%s/ {print $1}' "$modifier" )"
		assigned_mod=$(xmodmap -pm | awk "$awk_cmd")
		[ -n "$assigned_mod" ] && xmodmap -e "remove $assigned_mod = $modifier"

		xmodmap -e "add Mod3 = $modifier"
		xmodmap -e "keycode any = Escape"
		xcape -e "$modifier=Escape"
		unset modifier awk_cmd assigned_mod
	else
		echo Error: requires program xcape
	fi
}

# 1. assigns key with keycode $1 to:
#   - space when pressed by itself 
#   - Control_R when pressed in combination with another key
space_ctrl() {
	if command -v xcape > /dev/null 2>&1; then
		modifier='Control_R'
		xmodmap -e "keycode $1 = $modifier"

		awk_cmd=$( printf '/%s/ {print $1}' "$modifier" )
		assigned_mod=$(xmodmap -pm | awk "$awk_cmd")
		[ -n "$assigned_mod" ] && xmodmap -e "remove $assigned_mod = $modifier"

		xmodmap -e "add Control = $modifier"
		xmodmap -e "keycode any = space"
		xcape -e "$modifier=space"
		unset modifier awk_cmd assigned_mod
	else
		echo Error: requires program xcape
	fi
}

#space_ctrl 65

## keycode for caps lock on C720 Chromebook
#esc_mod3 133

## keycode for caps lock on CTRL keyboard
#esc_mod3 66
