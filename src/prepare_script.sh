#!/usr/bin/env bash
set -e

# HACK: Modify squeak.sh because it currently misses several features that are not available for the All-in-One bundles.
# See: https://github.com/squeak-smalltalk/squeak-app/pull/17#issuecomment-876753284
# Ported features:
# - ${VMOPTIONS}
# - detect_sound()
# - "$@"
# shellcheck disable=SC1004
# shellcheck disable=SC2016
sed -i 's!\(exec\)\( "${VM}"\)\( "${IMAGE}"\)!\
detect_sound() {\
    if pulseaudio --check 2>/dev/null ; then\
        if "${VM}" --help 2>/dev/null | grep -q vm-sound-pulse ; then\
	    VMOPTIONS="${VMOPTIONS} -vm-sound-pulse"\
        else\
            VMOPTIONS="${VMOPTIONS} -vm-sound-oss"\
            if padsp true 2>/dev/null; then\
                SOUNDSERVER=padsp\
            fi\
        fi\
    fi\
}\
detect_sound\
\
\1 ${SOUNDSERVER}\2 ${VMOPTIONS}\3 "$@"!' "$1"
