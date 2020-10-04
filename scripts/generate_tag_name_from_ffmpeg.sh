#! /bin/bash -eu

set -eu

function __readlink_f() {
  local target="$1"
  local filepath
  while test -n "$target"; do
    filepath="$target"
    cd $(dirname "$filepath")
    target=$(readlink "$filepath")
  done
  /bin/echo "$(pwd -P)/$(basename "${filepath}")"
}

SCRIPT_PATH=$(cd $(dirname $(__readlink_f $0)) && pwd)
cd ${SCRIPT_PATH}
cd ..

tag=$(git -C ffmpeg describe --tags)
# https://riptutorial.com/sed/topic/9436/bsd-macos-sed-vs--gnu-sed-vs--the-posix-sed-specification
# +と?はBSD版では使えない（POSIX標準ではない）
tag=$(echo "v${tag:1}" | sed "s_^\(v[0-9\.]\{1,\}\(-dev\)\{0,1\}\)_\1-git$(date "+%Y%m%d")_")
echo "${tag}"
