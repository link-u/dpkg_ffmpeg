#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))
ffmpeg_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && cd ffmpeg && pwd))

## HEAD のコミットID と HEAD の時のタグを取得
git_ref="$(git -C ffmpeg tag --points-at $(git -C ffmpeg rev-parse HEAD))"

## ディストリビューションのコードネームの取得
code_name="$(lsb_release -cs)"

## changelog の作成
cp "${root_dir}/scripts/changelog_template" "${ffmpeg_dir}/debian/changelog"
sed -i -r "s/%DATE%/$(LC_ALL=C TZ=JST-9 date '+%a, %d %b %Y %H:%M:%S %z')/g" "${ffmpeg_dir}/debian/changelog"
if [ "${git_ref:0:1}" = "v" ]; then
  sed -i -r "s/%VERSION%/${git_ref:1}.$(TZ=JST-9 date +%Y%m%d)+${code_name}/g" "${ffmpeg_dir}/debian/changelog"
else
  ## ffmpeg のgit tagを使ってバージョン名をつける
  git_commit="$(git rev-parse HEAD)"
  git_ref="$(git tag --points-at ${git_commit})"
  sed -i -r "s/%VERSION%/${nginx_src_dir:6}-$(TZ=JST-9 date +%Y%m%d.%H%M%S).${git_commit:0:7}+${code_name}/g" "${ffmpeg_dir}/debian/changelog"
fi
