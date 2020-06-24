#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
ffmpeg_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && cd ffmpeg && pwd))

cd ${ffmpeg_dir}

## 最新のコミットをタグ含め取得
git fetch origin --all

## HEAD のコミットID と HEAD の時のタグを取得
git_describe="$(git describe --tags)"

## ディストリビューションのコードネームの取得
code_name="$(lsb_release -cs)"

## changelog の修正
sed -i -r "s/%DATE%/$(LC_ALL=C TZ=JST-9 date '+%a, %d %b %Y %H:%M:%S %z')/g" "debian/changelog"
sed -i -r "s/%VERSION%/${git_describe:1}.$(TZ=JST-9 date +%Y%m%d)+${code_name}/g" "debian/changelog"
