#! /bin/bash -eux

set -eux

root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))
cd ${root_dir}

### libfdk-aac ################################################################

pushd libfdk-aac

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install

popd

### fribidi ###################################################################

pushd fribidi

apt-get -y install python3-pip
pip3 install meson ninja

## setup build dir
rm -Rfv _build
mkdir _build
cd _build

meson --prefix=/usr .. -Ddocs=false -Ddefault_library=static
ninja
ninja install

popd

### libass ####################################################################

pushd libass

## build
./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install

popd

### libaom ####################################################################

pushd libaom

## setup build dir
rm -Rfv _build
mkdir _build
cd _build

## configure
cmake ..\
    -DBUILD_SHARED_LIBS=OFF \
	-DENABLE_CCACHE=0 \
	-DENABLE_DOCS=0 \
	-DCONFIG_AV1_ENCODER=1 \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_TESTS=0

## build and install
make -j
make install
popd
