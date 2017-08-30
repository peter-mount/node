# Docker container with NodeJS v8+ running on Alpine Linux

It's generally used as the basis for NodeJS based docker containers, e.g. our [node-server](https://github.com/peter-mount/node-server) micro webserver.

The built image is available on Docker Hub for three different architectures:

| Image | Architecture | Build Status | Build Type |
| -------- | :---------------: | ---------------- | ------------- |
| [area51/node](https://hub.docker.com/r/area51/node/) | amd64 | ![Build Status](https://img.shields.io/docker/build/area51/node.svg) | ![Automated](https://img.shields.io/docker/automated/area51/node.svg)
| [area51/arm64v8-node](https://hub.docker.com/r/area51/arm64v8-node/) | arm64v8 | [![Build Status](http://jenkins.area51.onl/buildStatus/icon?job=Public/arm64v8-node)](http://jenkins.area51.onl/job/Public/job/arm64v8-node/) | [![Jenkins](https://img.shields.io/badge/jenkins_build-automated-blue.svg)](http://jenkins.area51.onl/job/Public/job/arm64v8-node/)
| [area51/rpi-node](https://hub.docker.com/r/area51/rpi-node/) | Raspberry PI | [![Build Status](http://jenkins.area51.onl/buildStatus/icon?job=Public/rpi-node)](http://jenkins.area51.onl/job/Public/job/rpi-node/) | [![Jenkins](https://img.shields.io/badge/jenkins_build-automated-blue.svg)](http://jenkins.area51.onl/job/Public/job/rpi-node/)
