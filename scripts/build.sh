#! /bin/bash -eux

set -eux

SCRIPT_PATH=$(readlink -f $(cd $(dirname $(readlink -f $0)) && pwd))
cd ${SCRIPT_PATH}/../ffmpeg

fakeroot debian/rules clean
fakeroot debian/rules configure
fakeroot debian/rules binary
