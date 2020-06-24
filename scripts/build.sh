#! /bin/bash -eux

set -eux

root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))

pkg-config --list-all

echo "building ffmpeg"
cd ${root_dir}/ffmpeg
fakeroot debian/rules clean
fakeroot debian/rules configure
mkdir -p debian/tmp
chroot debian/tmp fakeroot debian/rules build
fakeroot debian/rules binary
