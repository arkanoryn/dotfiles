#!/bin/bash

# Define the layout file and possible layouts
layout_file="$HOME/.config/aerospace/.layout_config.conf"
current_layout=$(cat "$layout_file")

# Toggle layout
if [ "$current_layout" = "accordion" ]; then
  new_layout="h_tiles"
else
  new_layout="accordion"
fi

# Loop through workspaces 1 to 4
for id in {1..4}; do
  aerospace workspace "$id"
  aerospace flatten-workspace-tree
  aerospace layout "$new_layout"
done

# Update layout file
echo "$new_layout" >"$layout_file"
