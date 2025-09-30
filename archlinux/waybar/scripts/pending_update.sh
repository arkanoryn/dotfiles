#!/usr/bin/env bash

outdated_packages="{\"text\": \"󱨩\", \"tooltip\": \"Updates available.\"}"
no_outdated_packages="{\"text\": \"\", \"tooltip\": \"Archlinux up-to-date.\"}"

if pacman -Qu &>/dev/null; then
  echo $outdated_packages
  exit
# elif command -v paru &>/dev/null; then
#   if paru -Qu &>/dev/null; then
#     echo $outdated_packages
#     exit
#   fi
else
  echo $no_outdated_packages
  exit
fi
