#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "$0")")" || exit 9

REPOSITORY=github.com/l2dy/speedtest
DESTINATION=${PWD}/bin

# Target OS
GOOS=linux

# Build x86-64 binary
GOARCH=amd64
docker run -it --rm -v ${DESTINATION}:/data \
    -e GOOS=$GOOS \
    -e GOARCH=$GOARCH \
    golang:latest \
    bash -c "\
      go get $REPOSITORY && \
      cd /go/src/${REPOSITORY} && \
      go build -o /data/speedtest-${GOOS}-${GOARCH}"

# Build static binary for ARM devices (like OpenWRT)
GOARCH=arm
docker run -it --rm -v ${DESTINATION}:/data \
    -e GOOS=$GOOS \
    -e GOARCH=$GOARCH \
    golang:alpine \
    ash -c "\
      apk add --no-cache git && \
      go get $REPOSITORY && \
      cd /go/src/${REPOSITORY} && \
      go build -o /data/speedtest-${GOOS}-${GOARCH}-static"
