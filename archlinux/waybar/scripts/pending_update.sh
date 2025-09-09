#!/usr/bin/env bash

outdated_packages="{\"text\": \"󱨩\", \"tooltip\": \"Updates available.\"}"
no_outdated_packages="{\"text\": \"\", \"tooltip\": \"Archlinux up-to-date.\"}"

if pacman -Qu &>/dev/null; then
  echo $outdated_packages
  exit
elif command -v yay &>/dev/null; then
  if yay -Qu &>/dev/null; then
    echo $outdated_packages
    exit
  fi
else
  echo $no_outdated_packages
  exit
fi
