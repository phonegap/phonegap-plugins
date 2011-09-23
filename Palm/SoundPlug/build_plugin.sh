#!/bin/bash
export SRC="SoundPlug.cpp"
export OUTFILE="soundplug_plugin"

export PalmPDK=/opt/PalmPDK

PATH=$PATH:${PalmPDK}/arm-gcc/bin:${PalmPDK}/i686-gcc/bin

CC="arm-none-linux-gnueabi-gcc"
LIBDIR="${PalmPDK}/device/lib"
SYSROOT="${PalmPDK}/arm-gcc/sysroot"
DEVICEOPTS="-mcpu=arm1136jf-s -mfpu=vfp -mfloat-abi=softfp"

if [ "$1" == "emulator" ]; then
	CC="i686-nptl-linux-gnu-gcc"
	LIBDIR="${PalmPDK}/emulator/lib"
	SYSROOT="${PalmPDK}/i686-gcc/sys-root"
	DEVICEOPTS=""
fi

CPPFLAGS="-I${PalmPDK}/include -I${PalmPDK}/include/SDL --sysroot=$SYSROOT"
LDFLAGS="-L${LIBDIR} -Wl,--allow-shlib-undefined"

$CC $DEVICEOPTS $CPPFLAGS $LDFLAGS -lSDL -lSDL_mixer -lpdl -s -o $OUTFILE $SRC
