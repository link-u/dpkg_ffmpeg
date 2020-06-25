#! /bin/bash -eux

set -eux

## Install deps

apt-get -y install python3-pip
pip3 install meson ninja

apt-get install -y build-essential yasm nasm
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

### libvpx ####################################################################

pushd libvpx

./configure --prefix="/usr" --disable-shared --enable-static --disable-docs --disable-tools --disable-examples
make -j
make install
make clean

pkg-config vpx --static --cflags --libs

popd

### libopus ###################################################################

pushd libopus

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install
make clean

pkg-config opus --static --cflags --libs

popd

### x264 ######################################################################

pushd x264

./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install
make clean

pkg-config x264 --static --cflags --libs

popd

### x265 ######################################################################

pushd x265

## setup build dir
rm -Rfv _build
mkdir _build
cd _build

## configure
cmake ../source\
    -DBUILD_SHARED_LIBS=OFF \
    -DENABLE_SHARED=OFF \
	-DENABLE_CCACHE=0 \
	-DENABLE_DOCS=0 \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_TESTS=0

make -j
make install
make clean

pkg-config x265 --static --cflags --libs

popd

### libogg ####################################################################

pushd libogg

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install
make clean

pkg-config ogg --static --cflags --libs

popd

### libvorbis #################################################################

pushd libvorbis

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install
make clean

pkg-config vorbis --static --cflags --libs
pkg-config vorbisenc --static --cflags --libs
pkg-config vorbisfile --static --cflags --libs

popd

### freetype2 #################################################################

pushd freetype2

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static --disable-freetype-config
make -j
make install
make clean

pkg-config freetype2 --static --cflags --libs

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
ninja clean

pkg-config fribidi --static --cflags --libs

popd

### libass ####################################################################

pushd libass

## build
./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install
make clean

pkg-config fribidi --static --cflags --libs

popd

### libfdk-aac ################################################################

pushd libfdk-aac

./autogen.sh
./configure --prefix="/usr" --disable-shared --enable-static
make -j
make install
make clean

pkg-config fdk-aac --static --cflags --libs

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
make clean

pkg-config aom --static --cflags --libs

popd
