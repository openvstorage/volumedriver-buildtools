#! /bin/bash
set -eux

TAR_IT_UP=${1:-yes}

#export RECIPE="buildtools libnfs"

#export FORCE_COMPILER_REBUILD="no"
#export FORCE_CLANG_REBUILD="no"
export VOLUMEDRIVER_BUILD_CONFIGURATION=`pwd`/jenkins-build-configuration-ubuntu16.04-python3.sh

./build.sh
. ../BUILDTOOLS_VERSION.sh
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?}

if [ "x$TAR_IT_UP" != "xno" ]
then
    tar cjf ${WORKSPACE}/buildtools.tar.bz2 ${PREFIX}
fi

# Local Variables: **
# compile-command: "time ./build.sh" **
# End: **
