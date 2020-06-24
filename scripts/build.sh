#! /bin/bash -eux

set -eux

root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))

echo "building ffmpeg"
cd ${root_dir}/ffmpeg
fakeroot debian/rules clean
fakeroot debian/rules configure
fakeroot debian/rules build
fakeroot debian/rules binary
