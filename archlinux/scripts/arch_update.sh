#!/usr/bin/env bash

echo "Updating Archlinux..."

echo "Updating pacman packages..."
sudo pacman -Suy

echo "Updating yay packages..."
yay -Syu --devel
