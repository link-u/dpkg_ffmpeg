#! /bin/bash

env --chdir=./ffmpeg dpkg-buildpackage -j10 -uc -us
