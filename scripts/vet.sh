#!/usr/bin/env sh
set -e
GOPATH=$PWD
make -C src/github.com/hpcloud/cf-plugin-backup vet
