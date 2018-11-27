# Use an official Debian distro as a parent image
FROM debian:buster-slim

# Set the working directory to /app
WORKDIR /app

RUN mkdir -p libs/build_scripts

# Install any needed packages
RUN apt-get update && apt-get -y \
    install \
    build-essential \
    autoconf \
    automake \
    module-assistant \
    git \
    libpq-dev \
    qt5-default \
    libtool \
    libsqlite3-dev \
    sqlite3 \
    wget \
    libz-dev

RUN cd libs && \
    git clone https://github.com/skystrife/cpptoml.git && \
    git clone https://github.com/fmtlib/fmt && \
    git clone https://github.com/mity/md4c.git && \
    git clone https://github.com/OSGeo/proj.4.git && \
    git clone https://github.com/Tencent/rapidjson.git && \
    git clone https://github.com/gabime/spdlog.git && \
    git clone https://github.com/madler/zlib zlib-1.2.11 && \
    git clone https://github.com/libgeos/geos.git && \
    wget https://curl.haxx.se/download/curl-7.58.0.tar.gz && \
    tar -xzf "curl-7.58.0.tar.gz" && \
    rm "curl-7.58.0.tar.gz" &&  \
    wget https://www.openssl.org/source/openssl-1.0.2n.tar.gz && \
    tar -xzf "openssl-1.0.2n.tar.gz" && \
    rm "openssl-1.0.2n.tar.gz"

#COPY ./build_scripts libs/build_scripts

COPY ./build_scripts/zlib.sh libs/build_scripts/zlib.sh
RUN cd libs/build_scripts && chmod +x zlib.sh
COPY ./build_scripts/proj4.sh libs/build_scripts/proj4.sh
RUN cd libs/build_scripts && chmod +x proj4.sh

#enable execution
#RUN cd libs/build_scripts && \
#    chmod +x zlib.sh proj4.sh openssl-1.0.sh libcurl.sh geos.sh

#compile
RUN cd libs/build_scripts && ./zlib.sh
RUN cd libs/build_scripts && ./proj4.sh

COPY ./build_scripts/openssl-1.0.sh libs/build_scripts/openssl-1.0.sh
RUN cd libs/build_scripts && chmod +x openssl-1.0.sh
RUN cd libs/build_scripts && ./openssl-1.0.sh

COPY ./build_scripts/geos.sh libs/build_scripts/geos.sh
RUN cd libs/build_scripts && chmod +x geos.sh
RUN cd libs/build_scripts && ./geos.sh

COPY ./build_scripts/libcurl.sh libs/build_scripts/libcurl.sh 
RUN chmod +x libs/build_scripts/libcurl.sh
RUN cd libs/build_scripts && ./libcurl.sh

RUN apt-get purge -y libsqlite3-dev sqlite3
RUN apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p libs_release && \
    mkdir -p libs_release/md4c && \
    cp -r libs/md4c/md2html/ libs_release/md4c/md2html/ && \
    cp -r libs/md4c/md4c/ libs_release/md4c/md4c/ && \
    mkdir -p libs_release/fmt && \
    cp -r libs/fmt/include/ libs_release/fmt/include/ && \
    cp -r libs/fmt/src/ libs_release/fmt/src/ && \
    mkdir -p libs_release/curl-7.58.0 && \
    cp -r libs/curl-7.58.0/include/ libs_release/curl-7.58.0/include/ && \
    cp -r libs/curl-7.58.0/bin/ libs_release/curl-7.58.0/bin/ && \
    mkdir -p libs_release/rapidjson && \
    cp -r libs/rapidjson/include/ libs_release/rapidjson/include/ && \
    mkdir -p libs_release/cpptoml && \
    cp -r libs/cpptoml/include/ libs_release/cpptoml/include/ && \
    mkdir -p libs_release/spdlog && \
    cp -r libs/spdlog/include/ libs_release/spdlog/include/ && \
    mkdir -p libs_release/geos/bin/linux64 && \
    cp -r libs/geos/bin/linux64/ libs_release/geos/bin/ && \
    mkdir -p libs_release/zlib-1.2.11/bin/linux64 && \
    cp -r libs/zlib-1.2.11/bin/linux64/ libs_release/zlib-1.2.11/bin/ && \
    mkdir -p libs_release/openssl-1.0.2n-bin/linux64 && \
    cp -r libs/openssl-1.0.2n-bin/linux64/ libs_release/openssl-1.0.2n-bin/ && \
    mkdir -p libs_release/proj.4/bin/linux64 && \
    cp -r libs/proj.4/bin/linux64/ libs_release/proj.4/bin/ && \
    rm -r libs && \
    mv libs_release libs



