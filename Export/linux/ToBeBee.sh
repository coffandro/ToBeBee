#!/bin/sh
echo -ne '\033c\033]0;To be bee\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/ToBeBee.x86_64" "$@"
