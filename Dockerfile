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

# The default arguments
ARG ARCHITECTURE=amd64
ARG VERSION=8.2.1

FROM ${ARCHITECTURE}/alpine as builder

ARG ARCHITECTURE
ARG VERSION

ARG FILE_LIST=/file.list

# Setup build environment
RUN apk add --no-cache \
        curl \
        make \
        gcc \
        g++ \
        python \
        linux-headers \
        paxctl \
        libgcc \
        libstdc++

# Download node sources
RUN cd /tmp &&\
    echo Downloading version ${VERSION} &&\
    echo curl -o node.tar.gz -sSL https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz && \
    curl -o node.tar.gz -sSL https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz && \
    ls -l node.tar.gz && \
    tar -zxf node.tar.gz

    # Build & install node, write install files to FILE_LIST
RUN cd /tmp/node-v${VERSION} && \
    export GYP_DEFINES="linux_use_gold_flags=0" && \
    ./configure --prefix=/usr ${CONFIG_FLAGS} && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
    paxctl -cm out/Release/mksnapshot && \
    make -j${NPROC} && \
    make install >${FILE_LIST} && \
    paxctl -cm /usr/bin/node

# Build a tar file of the installed files
RUN cd / &&\
    grep installing ${FILE_LIST} | cut -f2 -d' ' >manifest &&\
    grep symlinking ${FILE_LIST} | cut -f4 -d' ' >>manifest &&\
    tar -cvf node.tar -T manifest

# Now build the final image
ARG ARCHITECTURE
FROM ${ARCHITECTURE}/alpine
MAINTAINER Peter Mount <peter@retep.org>

# Required libraries
RUN apk add --no-cache \
      libgcc \
      libstdc++

COPY --from=builder /node.tar /tmp/node.tar
RUN tar xvf /tmp/node.tar &&\
    rm -rf /tmp/*
