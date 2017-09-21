# Docker container with NodeJS v8+ running on Alpine Linux

This docker container is intended as the base for running nodejs applications like our [node-server](https://github.com/peter-mount/node-server) micro webserver.

It is available for the amd64, arm32v6 (Raspberry PI) and arm64v8 processor architectures.

## Build Status

| Architecture | Image | Tags | Build Status |
| :----------: | ----- | ---- | ------------ | 
| amd64 | [area51/node](https://hub.docker.com/r/area51/node/) | latest 8.2.1 | ![Build Status](https://img.shields.io/docker/build/area51/node.svg)
| amd64 | [area51/amd64-node](https://hub.docker.com/r/area51/node-amd64/) | latest 8.2.1 | [![Build Status](http://jenkins.area51.onl/buildStatus/icon?job=Public/node-amd64)](http://jenkins.area51.onl/job/Public/job/node-amd64/)
| arm32v6 | [area51/arm32v6-node](https://hub.docker.com/r/area51/node-arm32v6/) | latest 8.2.1 | [![Build Status](http://jenkins.area51.onl/buildStatus/icon?job=Public/node-arm32v6)](http://jenkins.area51.onl/job/Public/job/node-arm32v6/)
| arm64v8 | [area51/arm64v8-node](https://hub.docker.com/r/area51/node-arm64v8/) | latest 8.2.1 |  [![Build Status](http://jenkins.area51.onl/buildStatus/icon?job=Public/node-arm64v8)](http://jenkins.area51.onl/job/Public/job/node-arm64v8/)
| Raspberry PI | [area51/rpi-node](https://hub.docker.com/r/area51/node-arm32v6/) | latest 8.2.1 | [![Build Status](http://jenkins.area51.onl/buildStatus/icon?job=Public/node-arm32v6)](http://jenkins.area51.onl/job/Public/job/node-arm32v6/)

## Building

As of Sept 21 2017 this project uses a single Dockerfile for all architectures so the only prerequisites are:
1. Architecture has a base alpine image available, named arch/alpine
1. The docker host being used is version 1.17+ and has the experimental extensions enabled - see below.

### experimental extension: --squash

This is optional but using this will halve the final image size. If your docker server does not have the experimental extensions enabled then remove the --squash option in the build commands.

### Build for amd64 (default)

As amd64 is the default platform you can run the build as you would for any other image:

    docker build -t my-node:latest --squash .

### Build for any architecture

To build on another architecture, simply add --build-arg ARCHITECTURE= to the build command with the supported architecture name. For example:

1. amd64 for 64bit AMD/Intel machines
1. arm32v6 for 32bit ARM6 machines including all Raspberry PI's
1. arm64v8 for 64bit ARM8 machines, used by some cloud providers

The only limitation here is that the docker server in use must be of that architecture and there must be an alpine image available, e.g. amd64/alpine:latest, arm64v8/alpine:latest etc

e.g.

    docker build -t area51/amd64-node:8.2.1 \
      --build-arg ARCHITECTURE=amd64 \
      --squash .

### Build for a specific version of node

You can choose any version of node to build by adding --build-arg VERSION= to the build command with the required version number.

e.g.

    docker build -t area51/amd64-node:8.2.1 \
      --build-arg VERSION=8.2.1 \
      --squash .

### Jenkins build

This is the commands I use in the Jenkins builds (formatting just to make it easier to read here)

    #docker build -t area51/arm64v8-node:8.2.1 --pull --force-rm=true arm64v8
    docker build \
      -t area51/amd64-node:8.2.1 \
      --pull \
      --force-rm=true \
      --build-arg ARCHITECTURE=amd64 \
      --build-arg VERSION=8.2.1 \
      --squash .
    docker push area51/amd64-node:8.2.1
    docker tag area51/amd64-node:8.2.1 area51/amd64-node:latest
    docker push area51/amd64-node:latest
