#!/usr/bin/env sh
set -e
PATH=$PATH:$PWD/bin
GOPATH=$PWD

SRC=${PWD}/src/github.com/SUSE/cf-plugin-backup
TAG=$(git -C ${SRC} describe --tags --long | awk -F - '{ print $1 }' )
NAME=$(basename $(git -C ${SRC} config --get remote.origin.url) .git)

# Assemble configuration data for `out` to git-release resource.
echo > release/name ${TAG}
echo > release/tag  ${TAG}
echo > release/body "${NAME}: Release ${TAG}"

# Build the tarballs for the release
make -C ${SRC} build dist

# Show configuration in log
echo Release information:
for path in release/*
do
    printf "%s: " "${path#**/}"
    cat $path
done

 #Unpack the tarballs into the release.
mkdir release/assets
for path in ${SRC}/*.tgz
do
    echo Processing ${path} ...

    rm -rf tmp
    mkdir  tmp
    ( cd tmp ; tar xfz $path )

    # tmp/cf-plugin-backup/README.txt
    # tmp/cf-plugin-backup/License.md
    # tmp/cf-plugin-backup/cf-plugin-backup.*

    mv tmp/cf-plugin-backup tmp/ar
    # tmp/ar/README.txt
    # tmp/ar/LICENSE.md
    # tmp/ar/cf-plugin-backup*

    mv    tmp/ar/cf-plugin-backup* tmp/
    mv    tmp/ar/*     release/assets/
    rmdir tmp/ar
    # tmp/cf-plugin-backup*

    vbase=$(basename ${path} .tgz)
    new=$(cd tmp ; ls cf-plugin-backup* | sed -e "s|cf-plugin-backup|${vbase}|")
    # Replace the generic part of the name with a name containing
    # version and platform information. Any platform specific
    # extension of the filename (example: .exe) is preserved.

    # Place binary into release
    mv tmp/cf-* release/assets/${new}

    # And calculate the adjunct checksum
    ( cd release/assets ; sha256sum ${new} ) > release/assets/$(basename ${new} .exe).SHA256

    rm -rf tmp
done

# Collect the release into a single tarball for S3 side load.
tar -C release -czf - . > cf-plugin-backup/cf-plugin-backup-${TAG}-release.tgz

# Show assembly in log
echo Assembled:
ls -lR release

# Show assembly in log
echo Assembled:
ls -lR cf-plugin-backup
