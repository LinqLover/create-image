#!/usr/bin/env bash
set -e

# HACK: Modify squeak.sh because arguments are currently not available for the All-in-One bundles
# See: https://github.com/squeak-smalltalk/squeak-app/pull/17#issuecomment-876753284
sed -i '$s/$/ "$@"/' "$1"

if [[ "$CI" == true ]]; then
    # Add -headless flag to the VM configuration
    # shellcheck disable=SC2016
    sed -i 's/\(exec "${VM}"\)\( "${IMAGE}"\)/\1 -headless\2/' "$1"
fi
