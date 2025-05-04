#!/bin/sh

uname="$(uname -s)"

if [ "$uname" = "Linux" ]; then
  /usr/bin/fish --login --interactive
elif [ "$uname" = "Darwin" ]; then
  /opt/homebrew/bin/fish
fi
