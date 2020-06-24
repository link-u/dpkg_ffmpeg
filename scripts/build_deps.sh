#! /bin/bash -eux

set -eux

SCRIPT_PATH=$(readlink -f $(cd $(dirname $(readlink -f $0)) && pwd))
cd ${SCRIPT_PATH}/..

pushd libaom
rm -Rfv build
mkdir _build
cd _build
cmake -S ../ -B ./ \
    -DBUILD_SHARED_LIBS=OFF \
	-DENABLE_CCACHE=0 \
	-DENABLE_DOCS=0 \
	-DCONFIG_AV1_ENCODER=1 \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_TESTS=0
make -j
make install
popd
