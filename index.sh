#!/bin/sh
echo -ne '\033c\033]0;GMTK2024\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/index.x86_64" "$@"
