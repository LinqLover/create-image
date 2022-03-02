#!/usr/bin/env bash
set -e

# HACK: Fix squeak.sh command line for running script files
# See: https://github.com/squeak-smalltalk/squeak-app/pull/25
# shellcheck disable=SC2016
perl -0777pi -e 's!(?s)(?<=# separate vm and script arguments)\n.*?(?=(?:\r*\n){2})!\
while [[ -n "\$1" ]] ; do\
    case "\$1" in\
         *.image) break;;\
         *.st|*.cs) STARGS="\${STARGS} \$1";;\
	 --) break;;\
         *) VMARGS="\${VMARGS} \$1";;\
    esac\
    shift\
done\
while [[ -n "\$1" ]]; do\
    case "\$1" in\
         *.image) IMAGE="\$1";;\
	 *) STARGS="\${STARGS} \$1" ;;\
    esac\
    shift\
done\
!gm' "$1"
