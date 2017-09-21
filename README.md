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
