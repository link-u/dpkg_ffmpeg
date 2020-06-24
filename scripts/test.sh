#! /bin/bash -eux	

set -eux	

## git リポジトリ上の root のパスを取得	
root_dir=$(cd ${scripts_dir} && cd .. && pwd)	
cd ${root_dir}	

apt install -y artifact/*.deb	
apt show ffmpeg-tools	
which ffmpeg	
which ffprobe	

ffmpeg -version	
ffmpeg --help full
