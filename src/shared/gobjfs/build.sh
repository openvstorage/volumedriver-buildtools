#! /bin/bash
set -eux
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

. ../definitions.sh
. ../../helper-functions.sh

GOBJFS_VERSION=e11d3d1
GOBJFS_DIR=${SOURCES_DIR}/gobjfs.git
BUILD_DIR=build

echo ">+>+> Cleaning up from previous build"
rm -rf ${GOBJFS_DIR} ${BUILD_DIR}
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> getting $GOBJFS_VERSION"
git clone https://github.com/openvstorage/gobjfs ${GOBJFS_DIR}
pushd ${GOBJFS_DIR}
git checkout ${GOBJFS_VERSION}
popd
echo "<+<+< Done unpacking $GOBJFS_VERSION"

echo ">+>+> patching $GOBJFS_VERSION"
PATCH_DIR="${PWD}/../../shared/gobjfs"
pushd ${GOBJFS_DIR}
patch -p1 < ${PATCH_DIR}/cmake-disable-tests.patch
popd
echo "<+<+< Done patching $GOBJFS_VERSION"

mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}

echo ">+>+> Invoking cmake for gobjfs $GOBJFS_VERSION"
cmake \
    -DCMAKE_C_COMPILER="${C_COMPILER}" \
    -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
    -DCMAKE_C_FLAGS="${C_COMPILER_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${CXX_COMPILER_FLAGS}" \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    ${GOBJFS_DIR}
echo "<+<+< Done with cmake for gobjfs $GOBJFS_VERSION"

echo ">+>+> Building $GOBJFS_VERSION"
${MAKE_PARALLEL_COMMAND}
echo "<+<+< Done building $GOBJFS_VERSION"

echo ">+>+> Installing $GOBJFS_VERSION"
${MAKE_INSTALL_COMMAND} PREFIX=${PREFIX}
rm -f ${PREFIX}/lib/libgobjfs*.so
echo "<+<+< Done installing $GOBJFS_VERSION"

popd

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

# don't cleanup, re-used when running tests!
#echo ">+>+> Cleaning $GOBJFS_VERSION"
rm -rf ${GOBJFS_DIR} ${BUILD_DIR}
#echo "<+<+< Done Cleaning $GOBJFS_VERSION"



# Local Variables: **
# compile-command: "time ./build.sh" **
# End: **
