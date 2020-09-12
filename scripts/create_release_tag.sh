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
git tag ${tag}
git push origin ${tag}
