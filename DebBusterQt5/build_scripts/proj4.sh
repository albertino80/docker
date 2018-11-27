#!/bin/bash

#ho dovuto installare
#sudo apt-get install autotools-dev
#sudo apt-get install automake
#sudo apt-get install libtool

SRC_PATH=/app/libs/proj.4
API_POSTFIX=api23

#ANDROID_ARCH="arch-x86"
#ANDROID_ARCH="arch-x86_64"
#ANDROID_ARCH="arch-arm"
ANDROID_ARCH="linux64"

if [ $ANDROID_ARCH = "linux64" ]
then
	echo "Linux compilation"
	INSTALLATION_PATH=$SRC_PATH/bin/$ANDROID_ARCH
else
	echo "Cross compilation"
	INSTALLATION_PATH=$SRC_PATH/bin/$ANDROID_ARCH/$API_POSTFIX

	if [ $ANDROID_ARCH = "arch-x86" ]
	then
		CROSS_COMPILE="i686-linux-android"
		TC_PATH=$HOME/android-tc/x86_$API_POSTFIX
	fi

	if [ $ANDROID_ARCH = "arch-x86_64" ]
	then
		CROSS_COMPILE="x86_64-linux-android"
		TC_PATH=$HOME/android-tc/x86_64_$API_POSTFIX
	fi

	if [ $ANDROID_ARCH = "arch-arm" ]
	then
		CROSS_COMPILE="arm-linux-androideabi"
		TC_PATH=$HOME/android-tc/arm_$API_POSTFIX
	fi


	export PATH=$PATH:$TC_PATH/bin

	export CC=$CROSS_COMPILE-gcc
	export CPP=$CROSS_COMPILE-cpp
	export CXX=$CROSS_COMPILE-g++
	export AR=$CROSS_COMPILE-ar
	export AS=$CROSS_COMPILE-as
	export LD=$CROSS_COMPILE-ld
	export RANLIB=$CROSS_COMPILE-ranlib
	export NM=$CROSS_COMPILE-nm
	export CFLAGS="-fPIC"
fi

mkdir $SRC_PATH/bin -p
mkdir $INSTALLATION_PATH -p

cd $SRC_PATH

echo $INSTALLATION_PATH

#read -p "Press enter to continue"

./autogen.sh

#read -p "Press enter to continue"

if [ $ANDROID_ARCH = "linux64" ]
then
	./configure --prefix=$INSTALLATION_PATH
else
	./configure --host=$CROSS_COMPILE --prefix=$INSTALLATION_PATH
fi

#read -p "Configured, press enter to continue"

make clean
make
make install
make clean

