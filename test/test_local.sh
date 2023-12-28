#!/usr/bin/env bash
# Rough local equivalent of .github/workflows/test.yml
# 🤞 Crossing fingers that this script will not become out of sync with the workflow file
set -eo pipefail

if [[ -z "$SQUEAK_VERSION" ]]; then
	versions=(trunk 6.0 5.3)
else
	versions=("$SQUEAK_VERSION")
fi
if [[ -z "$SQUEAK_BITNESS" ]]; then
	bitnesses=(64)
else
	bitnesses=("$SQUEAK_BITNESS")
fi

for version in "${versions[@]}"; do
	for bitness in "${bitnesses[@]}"; do
		echo "Testing Squeak $version $bitness"
		output=$(SQUEAK_VERSION="$version" SQUEAK_BITNESS="$bitness" PREPARE_SCRIPT=test/prepare.st POSTPARE_SCRIPT=test/postpare.st GITHUB_OUTPUT=/dev/stdout src/create_image.sh | tee /dev/tty)
		bundlePath=$(echo "$output" | sed -n 's/.*bundle-path=\(.*\)/\1/p')
		test/extract.sh "$bundlePath"
		output/image/squeak.sh "$(realpath test/test.st)" -- "$version" "$bitness"
		rm -rf output/image
	done
done
