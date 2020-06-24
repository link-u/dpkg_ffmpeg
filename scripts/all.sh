#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
scripts_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && pwd))
root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))

## debian ディレクトリをコピー
env --chdir="${root_dir}" \
  cp -r debian ffmpeg
### changelogファイルの修正
bash "${scripts_dir}/create_changelog.sh"

## ビルド時に必要なパッケージのインストール
env --chdir="${root_dir}/ffmpeg" \
  mk-build-deps --install --remove \
  --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' \
  debian/control

## deb ファイルのビルド
bash "${scripts_dir}/build_deps.sh"

## deb ファイルのビルド
bash "${scripts_dir}/build.sh"
