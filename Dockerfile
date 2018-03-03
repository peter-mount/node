# Docker file used for our multi-architecture builds
#
# To build run:
#
# VERSION=8.2.1
# ARCH=$(uname -m | sed -e "s/aarch64/arm64v8/" -e "s/x86_64/amd64/")
# docker build -t ${ARCH}-node:${VERSION} -f Dockerfile.1 --build-arg ARCHITECTURE=${ARCH} --build-arg VERSION=${VERSION} .
#
# =============================================================================
# IMPORTANT: This will build a large ~120MB image unlike the old build at ~60MB.
# This is due to COPY creating a layer that cannot be removed when we copy
# the files over from the build image.
# For this to build a small ~60MB image, you need to enable experimental mode
# and add --squash to the build line.
# =============================================================================

# Current version as of Jan 4 2018
ARG VERSION=8.9.4

# ================================================================================
# Now download and compile the sources
# ================================================================================

FROM area51/alpine-dev as download
ARG VERSION

# Where to store our file list
ARG FILE_LIST=/file.list

# Download node sources
RUN cd /tmp &&\
    echo Downloading version ${VERSION} &&\
    echo curl -o node.tar.gz -sSL https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz && \
    curl -o node.tar.gz -sSL https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz && \
    ls -l node.tar.gz && \
    tar -zxf node.tar.gz

FROM download as configure

RUN cd /tmp/node-v${VERSION} && \
    export GYP_DEFINES="linux_use_gold_flags=0" && \
    ./configure --prefix=/usr ${CONFIG_FLAGS}

FROM configure as mksnapshot

RUN cd /tmp/node-v${VERSION} && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
    paxctl -cm out/Release/mksnapshot

FROM mksnapshot as make
RUN cd /tmp/node-v${VERSION} && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make -j${NPROC}

FROM make as install
RUN cd /tmp/node-v${VERSION} && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make install >${FILE_LIST} && \
    paxctl -cm /usr/bin/node

# Build a tar file of the installed files
RUN cd / &&\
    grep installing ${FILE_LIST} | cut -f2 -d' ' >manifest &&\
    grep symlinking ${FILE_LIST} | cut -f4 -d' ' >>manifest &&\
    tar -cvf node.tar -T manifest

# ================================================================================
# Now build the final image
# ================================================================================

FROM alpine as final
MAINTAINER Peter Mount <peter@retep.org>

# Required libraries
RUN apk add --no-cache \
      curl \
      git \
      libgcc \
      libstdc++

COPY --from=builder /node.tar /tmp/node.tar
RUN tar xvf /tmp/node.tar &&\
    rm -rf /tmp/*
