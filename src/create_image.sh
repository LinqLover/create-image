#!/usr/bin/env bash
set -eo pipefail

# Read & validate inputs
if [[ -z "$SQUEAK_VERSION" ]]; then
    echo "SQUEAK_VERSION is not set"
    exit 1
fi
squeakVersion="$SQUEAK_VERSION"
squeakBitness=64
if [[ "$SQUEAK_BITNESS" ]]; then
    if [[ "$SQUEAK_BITNESS" != 32 && "$SQUEAK_BITNESS" != 64 ]]; then
        echo "SQUEAK_BITNESS must be 32 or 64"
        exit 1
    fi
    squeakBitness="$SQUEAK_BITNESS"
fi
if [[ "$squeakBitness" == 32 ]]; then
    echo "WARNING: 32bit may not be supported on GitHub Actions"
fi
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
files_server="http://files.squeak.org/$squeakVersion"
files_index="files.html"
wget -O "$files_index" "$files_server"
build="$(grep -P -o "(?<=a href=\")Squeak[^<>]*?-${squeakBitness}bit(?=\/\")" "$files_index" | tail -1)"
buildAio="$build-All-in-One.zip"
dir="$build-All-in-One/"
wget "$files_server/$build/$buildAio"
unzip \
    -d "$dir" "$buildAio" \
    -x '*.mo'  # skip superfluous localization files (optimization)
echo "bundle-path=$(realpath "$buildAio")" >> "$GITHUB_OUTPUT"

# Prepare image
cd "$dir"
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
