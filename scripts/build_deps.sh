#! /bin/bash -eux

set -eux

root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))
cd ${root_dir}

pushd libaom

## setup build dir
rm -Rfv .build
mkdir .build
cd .build

## configure
cmake ..\
    -DBUILD_SHARED_LIBS=OFF \
	-DENABLE_CCACHE=0 \
	-DENABLE_DOCS=0 \
	-DCONFIG_AV1_ENCODER=1 \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_TESTS=0 \

## build and install
make -j
make install
popd
