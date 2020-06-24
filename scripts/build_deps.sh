#! /bin/bash -eux

set -eux

## Install deps

apt-get -y install python3-pip
pip3 install meson ninja

apt-get install -y build-essential yasm
apt-get install -y autoconf automake libtool pkg-config
apt-get install -y libfontconfig1-dev fontconfig

## install latest cmake

apt-get -y install apt-transport-https ca-certificates gnupg software-properties-common wget
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
apt-get update

apt-get -y install cmake

##

root_dir=$(readlink -f $(cd $(dirname $(readlink -f $0)) && cd .. && pwd))
cd ${root_dir}

### x265 ######################################################################

pushd x265

## setup build dir
rm -Rfv _build
mkdir _build
cd _build

## configure
cmake ../source\
    -DBUILD_SHARED_LIBS=OFF \
	-DENABLE_CCACHE=0 \
	-DENABLE_DOCS=0 \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_TESTS=0

make -j
make install

popd

### libogg ####################################################################

pushd libogg

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install

popd

### libvorbis #################################################################

pushd libvorbis

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install

popd

### freetype2 #################################################################

pushd freetype2

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static --disable-freetype-config
make -j
make install

popd

### fribidi ###################################################################

pushd fribidi

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

### libfdk-aac ################################################################

pushd libfdk-aac

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
