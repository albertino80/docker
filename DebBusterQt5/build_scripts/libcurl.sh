#!/bin/bash

HOME_PATH=/app/libs
SRC_PATH=$HOME_PATH/curl-7.58.0
API_POSTFIX=api23

#ANDROID_ARCH="arch-x86"
#ANDROID_ARCH="arch-x86_64"
#ANDROID_ARCH="arch-arm"
ANDROID_ARCH="linux64"

if [ $ANDROID_ARCH = "linux64" ]
then
	echo "Linux compilation"
	INSTALLATION_PATH=$SRC_PATH/bin/$ANDROID_ARCH
	OPENSSL_PATH=$HOME_PATH/openssl-1.0.2n-bin/$ANDROID_ARCH
	ZLIB_PATH=$HOME_PATH/zlib-1.2.11/bin/$ANDROID_ARCH
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ZLIB_PATH/lib:$OPENSSL_PATH/lib
else
	echo "Cross compilation"
	INSTALLATION_PATH=$SRC_PATH/bin/$ANDROID_ARCH/$API_POSTFIX
	OPENSSL_PATH=$HOME_PATH/openssl-1.0.2n-bin/$ANDROID_ARCH/$API_POSTFIX
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

	export CPPFLAGS="-I$ZLIB_PATH/include -I$OPENSSL_PATH/include"
	export LDFLAGS="-L$ZLIB_PATH/lib -L$OPENSSL_PATH/lib"
	export LIBS="-lssl -lcrypto"
fi

mkdir $SRC_PATH/bin -p
mkdir $INSTALLATION_PATH -p

cd $SRC_PATH

echo $INSTALLATION_PATH

#read -p "Press enter to continue"

if [ $ANDROID_ARCH = "linux64" ]
then
	./configure --prefix=$INSTALLATION_PATH --with-ssl=$OPENSSL_PATH --with-zlib=$ZLIB_PATH --disable-ftp --disable-gopher --disable-file --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-proxy --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-gnutls --without-libidn --without-librtmp --disable-dict
#	read -p "Configured Press enter to continue"
else
	./configure --host=$CROSS_COMPILE --prefix=$INSTALLATION_PATH --with-ssl=$OPENSSL_PATH --with-zlib=$ZLIB_PATH --disable-ftp --disable-gopher --disable-file --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-proxy --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-gnutls --without-libidn --without-librtmp --disable-dict
#	read -p "Configured Press enter to continue"
fi

make clean
make
make install
make clean

