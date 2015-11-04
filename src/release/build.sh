#! /bin/bash
# This is where we document and define global build variables
set -xeu

. ../helper-functions.sh
. ../BUILDTOOLS_VERSION.sh
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}
check_buildtools_version

#order is important here ladies and gentlemen"
PACKAGES="crakoon fuse gtest webstor simpleamqpclient ganesha libnfs rocksdb capnproto alba ovsbackends buildtools"

PACKAGES_TO_BUILD=${RECIPE:-"$PACKAGES"}

echo "building packages: $PACKAGES_TO_BUILD"
build_packages "$PACKAGES_TO_BUILD"

# Local Variables: **
# compile-command: "time ./build.sh" **
# End: **
