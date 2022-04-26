#!/usr/bin/env bash
# Rough local equivalent of .github/workflows/test.yml
# 🤞 Crossing fingers that this script will not become out of sync with the workflow file
set -eo pipefail

output=$(PREPARE_SCRIPT=test/prepare.st POSTPARE_SCRIPT=test/postpare.st src/create_image.sh | tee /dev/tty)
bundlePath=$(echo "$output" | sed -n 's/.*::set-output name=bundle-path::\(.*\)/\1/p')
test/extract.sh "$bundlePath"
output/image/squeak.sh "$(realpath test/test.st)"
