#! /bin/bash -eux

set -eux

## git リポジトリ上の root のパスを取得
scripts_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && pwd))
root_dir=$(cd ${scripts_dir} && cd .. && pwd)

cd ${root_dir}

## debian ディレクトリをコピー
cp -r debian ffmpeg
### changelogファイルの修正
bash "${scripts_dir}/create_changelog.sh"

## deb ファイルのビルド
bash "${scripts_dir}/build_deps.sh"

## ビルド時に必要なパッケージのインストール
mk-build-deps --install --remove \
  --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' \
  "${root_dir}/ffmpeg/debian/control"

## deb ファイルのビルド
bash "${scripts_dir}/build.sh"
