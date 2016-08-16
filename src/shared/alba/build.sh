#! /bin/bash
set -eux
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

ALBA_VERSION=bf6493039383cfd467239dc4e8a95bc940da7f67
ALBA_DIR=../../../../alba.git

. ../definitions.sh
. ../../helper-functions.sh

echo ">+>+> Cleaning up from previous build"
rm -rf ${ALBA_DIR}
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> getting $ALBA_VERSION"
git clone https://github.com/openvstorage/alba ${ALBA_DIR}
pushd ${ALBA_DIR}
git checkout ${ALBA_VERSION}
popd
echo "<+<+< Done unpacking $ALBA_VERSION"

echo ">+>+> patching $ALBA_VERSION"
PATCH_DIR="${PWD}/../../shared/alba"
pushd ${ALBA_DIR}
popd
echo "<+<+< Done patching $ALBA_VERSION"


pushd ${ALBA_DIR}/cpp/automake_client/

echo ">+>+> autoreconf $ALBA_VERSION"
./build.sh
echo "<+<+< Done autoreconf $ALBA_VERSION"

echo ">+>+> Configuring $ALBA_VERSION"
CXXFLAGS="$CXX_COMPILER_FLAGS" \
    CXX=$CXX_COMPILER  \
    ./configure \
    --prefix=$PREFIX \
    --disable-shared
echo "<+<+< Done configuring $ALBA_VERSION"

echo ">+>+> Building $ALBA_VERSION"
${MAKE_PARALLEL_COMMAND}
echo "<+<+< Done building $ALBA_VERSION"

echo ">+>+> Installing $ALBA_VERSION"
${MAKE_INSTALL_COMMAND} PREFIX=${PREFIX}
echo "<+<+< Done installing $ALBA_VERSION"

popd

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

# don't cleanup, re-used when running tests!
#echo ">+>+> Cleaning $ALBA_VERSION"
#rm -rf ${ALBA_DIR}
#echo "<+<+< Done Cleaning $ALBA_VERSION"



# Local Variables: **
# compile-command: "time ./build.sh" **
# End: **
