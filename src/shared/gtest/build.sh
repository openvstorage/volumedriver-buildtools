#! /bin/bash
set -eux
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

. ../definitions.sh
. ../../helper-functions.sh

GTEST_VERSION=release-1.7.0
GTEST_DIR=${SOURCES_DIR}/googletest.git
BUILD_DIR=build

echo ">+>+> Cleaning up from previous build"
rm -rf ${GTEST_DIR} ${BUILD_DIR}
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> getting $GTEST_VERSION"
git clone https://github.com/google/googletest ${GTEST_DIR}
pushd ${GTEST_DIR}
git checkout ${GTEST_VERSION}
popd
echo "<+<+< Done unpacking $GTEST_VERSION"

echo ">+>+> patching $GTEST_VERSION"
PATCH_DIR="${PWD}/../../shared/gtest"
pushd ${GTEST_DIR}
popd
echo "<+<+< Done patching $GTEST_VERSION"

echo ">+>+> Removing old gtest version"
rm -rf ${PREFIX}/include/gtest
echo "<+<+< Done removing old gtest version"

mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}

echo ">+>+> Invoking cmake for gtest $GTEST_VERSION"
cmake \
    -DCMAKE_C_COMPILER="${C_COMPILER}" \
    -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
    -DCMAKE_C_FLAGS="${C_COMPILER_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${CXX_COMPILER_FLAGS}" \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    ${GTEST_DIR}
echo "<+<+< Done with cmake for gtest $GTEST_VERSION"

echo ">+>+> Building $GTEST_VERSION"
${MAKE_PARALLEL_COMMAND}
echo "<+<+< Done building $GTEST_VERSION"

echo ">+>+> Installing $GTEST_VERSION"
rm -f ${PREFIX}/lib/libgtest*.a
rm -rf ${PREFIX}/include/gtest
cp libgtest.a ${PREFIX}/lib/
cp -a ${GTEST_DIR}/include/gtest ${PREFIX}/include/
echo "<+<+< Done installing $GTEST_VERSION"

popd

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

# don't cleanup, re-used when running tests!
#echo ">+>+> Cleaning $GTEST_VERSION"
rm -rf ${GTEST_DIR} ${BUILD_DIR}
#echo "<+<+< Done Cleaning $GTEST_VERSION"



# Local Variables: **
# compile-command: "time ./build.sh" **
# End: **
