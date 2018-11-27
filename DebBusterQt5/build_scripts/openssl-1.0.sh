#!/bin/bash

#ho dovuto installare:
#sudo apt-get install libz-dev

HOME_PATH=/app/libs
SRC_PATH=$HOME_PATH/openssl-1.0.2n
API_POSTFIX=api23

#ANDROID_ARCH="arch-x86"
#ANDROID_ARCH="arch-x86_64"
#ANDROID_ARCH="arch-arm"
ANDROID_ARCH="linux64"

if [ $ANDROID_ARCH = "linux64" ]
then
	echo "Linux compilation"
	INSTALLATION_PATH=$SRC_PATH-bin/$ANDROID_ARCH
	ZLIB_PATH=$HOME_PATH/zlib-1.2.11/bin/$ANDROID_ARCH
else
	echo "Cross compilation"
	INSTALLATION_PATH=$SRC_PATH-bin/$ANDROID_ARCH/$API_POSTFIX
	ZLIB_PATH=$HOME_PATH/zlib-1.2.11/bin/$ANDROID_ARCH/$API_POSTFIX

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

#read -p "Press enter to continue"

cd $SRC_PATH

if [ $ANDROID_ARCH = "linux64" ]
then
	./Configure shared zlib-dynamic --prefix=$INSTALLATION_PATH --openssldir=$INSTALLATION_PATH linux-x86_64
#	read -p "Configured, press enter to continue"
	make clean
	make build_libs
else
	./Configure shared zlib-dynamic --prefix=$INSTALLATION_PATH --openssldir=$INSTALLATION_PATH android
#	read -p "Configured, press enter to continue"
	make clean
	make CALC_VERSIONS="SHLIB_COMPAT=; SHLIB_SOVER=" build_libs
	#dovrò copiare a mano i files senza la versione, perché me li genera comunque con il numeretto in coda (ex:libcrypto.so.1.0.0 diventerà libcrypto.so)
fi

make install
make clean

#cd ../build_scripts
