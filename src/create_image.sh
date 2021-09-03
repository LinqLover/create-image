#!/usr/bin/env bash
set -e

# Read & validate inputs
if [[ "$PREPARE_SCRIPT" ]]; then
    prepareScript="$(realpath "$PREPARE_SCRIPT")"
fi
if [[ "$POSTPARE_SCRIPT" ]]; then
    postpareScript="$(realpath "$POSTPARE_SCRIPT")"
fi

script_dir="$(realpath "$(dirname "$0")")"
cd "$script_dir"
fileinScript="$(realpath "prepareImage.st")"
mkdir ../output && cd ../output

# Download and extract latest Trunk release
files_server="http://files.squeak.org/trunk"
files_index="files.html"
wget -O "$files_index" "$files_server"
build="$(grep -P -o '(?<=a href=")Squeak[^<>]*?-64bit(?=\/")' "$files_index" | tail -1)"
buildAio="$build-All-in-One.zip"
wget "$files_server/$build/$buildAio"
unzip \
    -d allInOne/ "$buildAio" \
    -x '*.mo'  # skip superfluous localization files (optimization)
echo ::set-output name=bundle-path::"$(realpath "$buildAio")"

# Prepare VM execution
cd allInOne
"$script_dir/prepare_script.sh" squeak.sh

# Prepare image
./squeak.sh "$fileinScript" "$prepareScript" "$postpareScript"

# Clean up caches
shopt -s globstar
rm -rf ./**/{{package,github}-cache/,\#tmp\#*}

# Write changes back to zip
zip \
    -u -r \
    "../$buildAio" . \
    -x squeak.sh  # See HACK above
