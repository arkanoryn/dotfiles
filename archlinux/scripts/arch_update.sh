#!/usr/bin/env bash

echo "Updating Archlinux..."

echo "Updating pacman packages..."
sudo pacman -Suy

echo "Updating paru packages..."
paru -Syu --devel
