#! /bin/bash
set -eux
export VOLUMEDRIVER_BUILD_CONFIGURATION=`pwd`/ovs-jenkins-build-configuration.sh

# export RECIPE=
./build.sh
. ../BUILDTOOLS_VERSION.sh
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?}

tar -c -z -P -f volumedriver-buildtools-${BUILDTOOLS_VERSION?}.tar.gz ${PREFIX?}
