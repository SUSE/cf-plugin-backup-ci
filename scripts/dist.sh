#!/usr/bin/env sh
set -e
PATH=$PATH:$PWD/bin
GOPATH=$PWD
make -C src/github.com/SUSE/cf-plugin-backup build
make -C src/github.com/SUSE/cf-plugin-backup dist
cp src/github.com/SUSE/cf-plugin-backup/*.tgz cf-plugin-backup/
