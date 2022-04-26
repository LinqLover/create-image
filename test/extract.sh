#!/usr/bin/env bash
set -eo pipefail
output="output"

error() {
    >&2 echo "$@"
    exit 1
}

test -n "$1" || error "invalid archive file"

extracted="$output/image"
mkdir -p "$extracted"
unzip "$1" -d "$extracted"

ls "$extracted"
test -f "$extracted/squeak.bat"
test -f "$extracted/squeak.sh"

echo "extracted image to $extracted"
