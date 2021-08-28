#!/usr/bin/env bash
set -e

# Read & validate inputs
if [[ "$PREPARE_SCRIPT" ]]; then
    prepareScript="$(realpath "$PREPARE_SCRIPT")"
fi
if [[ "$POSTPARE_SCRIPT" ]]; then
    postpareScript="$(realpath "$POSTPARE_SCRIPT")"
fi

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
echo ::set-output name=bundle-path::"$buildAio"

# Prepare VM execution
export script_dir
script_dir="$(realpath "$(dirname "$0")")"
cd allInOne
# Make squeak.sh capable of passing arguments to the image
# HACK: Modify squeak.sh because arguments are currently not available for the All-in-One bundles
# See: https://github.com/squeak-smalltalk/squeak-app/pull/17#issuecomment-876753284
sed -i '$s/$/ "$@"/' squeak.sh
if [[ "$CI" == true ]]; then
    # Add -headless flag to the VM configuration
    # shellcheck disable=SC2016
    sed -i 's/\(exec "${VM}"\)\( "${IMAGE}"\)/\1 -headless\2/' squeak.sh
fi

# Prepare image
./squeak.sh "$script_dir/prepareImage.st" "$prepareScript" "$postpareScript"

# Clean up caches
shopt -s globstar
rm -rf ./**/{{package,github}-cache/,\#tmp\#*}

# Write changes back to zip
zip \
    -u -r \
    -x squeak.sh \  # See HACK above
    "../$buildAio" .
