#! /bin/bash -eux

set -eux

## git リポジトリ上の root のパスを取得
scripts_dir=$(cd $(dirname $(readlink -f $0)) && pwd)
root_dir=$(cd ${scripts_dir} && cd .. && pwd)
cd ${root_dir}

apt install -y ./artifact/*.deb
apt show ffmpeg-tools
which ffmpeg
which ffprobe

ffmpeg -version
ffmpeg --help full > /dev/null 2>&1

ldd $(which ffmpeg)
ldd $(which ffprobe)
