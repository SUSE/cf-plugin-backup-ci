#!/usr/bin/env sh
set -e
PATH=$PATH:$PWD/bin
GOPATH=$PWD
make -C src/github.com/hpcloud/cf-plugin-backup linux_dist
cp src/github.com/hpcloud/cf-plugin-backup/*.tgz cf-plugin-backup/
