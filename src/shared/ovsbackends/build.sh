#! /bin/bash
set -eux
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

OVSBACKENDS_VERSION=0.0.1
OVSBACKENDS_DIR=../../../../ovsbackends.git

. ../definitions.sh
. ../../helper-functions.sh

echo ">+>+> Cleaning up from previous build"
rm -rf ${OVSBACKENDS_DIR}
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> getting $OVSBACKENDS_VERSION"
git clone ssh://hg@bitbucket.org/openvstorage/ceph ${OVSBACKENDS_DIR}
#pushd ${OVSBACKENDS_DIR}
#git checkout ${OVSBACKENDS_VERSION}
#popd
echo "<+<+< Done unpacking $OVSBACKENDS_VERSION"

#echo ">+>+> patching $OVSBACKENDS_VERSION"
#PATCH_DIR="${PWD}/../../shared/ovsbackends"
#pushd ${OVSBACKENDS_DIR}
#popd
#echo "<+<+< Done patching $OVSBACKENDS_VERSION"


pushd ${OVSBACKENDS_DIR}/automake_ovsbackends/

echo ">+>+> autoreconf $OVSBACKENDS_VERSION"
./build.sh
echo "<+<+< Done autoreconf $OVSBACKENDS_VERSION"

echo ">+>+> Configuring $OVSBACKENDS_VERSION"
CXXFLAGS="$CXX_COMPILER_FLAGS" \
    CXX=$CXX_COMPILER  \
    ./configure \
    --prefix=$PREFIX \
    --disable-shared
echo "<+<+< Done configuring $OVSBACKENDS_VERSION"

echo ">+>+> Building $OVSBACKENDS_VERSION"
${MAKE_PARALLEL_COMMAND}
echo "<+<+< Done building $OVSBACKENDS_VERSION"

echo ">+>+> Installing $OVSBACKENDS_VERSION"
${MAKE_INSTALL_COMMAND} PREFIX=${PREFIX}
echo "<+<+< Done installing $OVSBACKENDS_VERSION"

popd

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

# don't cleanup, re-used when running tests!
#echo ">+>+> Cleaning $OVSBACKENDS_VERSION"
#rm -rf ${OVSBACKENDS_DIR}
#echo "<+<+< Done Cleaning $OVSBACKENDS_VERSION"

