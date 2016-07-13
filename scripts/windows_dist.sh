#!/usr/bin/env sh
set -e
PATH=$PATH:$PWD/bin
GOPATH=$PWD
make -C src/github.com/hpcloud/cf-plugin-backup windows_dist
cp src/github.com/hpcloud/cf-plugin-backup/*.tgz cf-plugin-backup/