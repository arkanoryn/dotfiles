#!/usr/bin/env bash

tmp_path="${HOME}/.tmp"
logfile_path="${tmp_path}/log.txt"
qmk_path="${HOME}/Code/qmk"

echo "Creating a log file in #{logfile_path}..."
mkdir "${tmp_path}"
touch "${logfile_path}"
echo "$(date +"%Y-%m-%d %H:%M:%S")" >"${logfile_path}"

. ./setup_scripts/arch_default.sh

. ./setup_scripts/hyprland.sh

. ./setup_scripts/apps.sh
