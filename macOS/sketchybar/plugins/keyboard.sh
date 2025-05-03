#!/usr/bin/env bash

QWERTY_KEYMAP="qwerty"
GRAPHITE_KEYMAP="graphite"
DEFAULT_KEYMAP=$QWERTY_KEYMAP

AEROSPACE_DIR="$HOME/.config/aerospace/"
KEYMAP_FILE="$HOME/.config/sketchybar/keymap.conf"

update_keymap_config() {
  echo "$1" >"$KEYMAP_FILE"
}

fetch_current_keymap() {
  if [ -e "$KEYMAP_FILE" ]; then
    cat "$KEYMAP_FILE"
  else
    echo "$DEFAULT_KEYMAP"
  fi
}

swap_keymaps() {
  # Swap the configuration for aerospace
  cp "$AEROSPACE_DIR"aerospace-"$1".toml "$AEROSPACE_DIR"aerospace.toml
}

notify_sketchybar_with_keyboard_state() {
  sketchybar --trigger keyboard_state_update KEYBOARD_STATE="$1"
}

###
# MAIN STARTS HERE
###

if [ "$1" = "state" ]; then
  notify_sketchybar_with_keyboard_state "$(fetch_current_keymap)"
fi

if [ "$1" = "swapped" ]; then
  current_keymap=$(fetch_current_keymap)

  if [ "$current_keymap" = "$QWERTY_KEYMAP" ]; then
    new_keymap="$GRAPHITE_KEYMAP"
  elif [ "$current_keymap" = "$GRAPHITE_KEYMAP" ]; then
    new_keymap="$QWERTY_KEYMAP"
  else
    new_keymap="$DEFAULT_KEYMAP"
  fi

  swap_keymaps "$new_keymap"
  update_keymap_config "$new_keymap"
  aerospace reload-config
  notify_sketchybar_with_keyboard_state $new_keymap
fi
