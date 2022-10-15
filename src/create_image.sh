#!/usr/bin/env bash
set -eo pipefail

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
mkdir -p ../output && cd ../output

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
echo "bundle_path=$(realpath "$buildAio")" >> "$GITHUB_OUTPUT"

# Prepare image
cd allInOne
if [[ "$CI" == true ]]; then
    VMOPTIONS="-headless"
fi
./squeak.sh $VMOPTIONS "$fileinScript" "$prepareScript" "$postpareScript"

# Clean up caches
shopt -s globstar
rm -rf ./**/{{package,github}-cache/,\#tmp\#*}

# Write changes back to zip
zip \
    -u -r \
    "../$buildAio" .
# TODO optimize: Ignore *.mo files here again (-x does not work)
