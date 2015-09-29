#! /bin/bash
set -eux
# Patches have been checked
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}


SIMPLEAMPQCLIENT_VERSION=2.4.0
SIMPLEAMPQCLIENT_DIR=SimpleAmqpClient-$SIMPLEAMPQCLIENT_VERSION
SIMPLEAMPQCLIENT_PACKAGE=v$SIMPLEAMPQCLIENT_VERSION.zip
SIMPLEAMPQCLIENT_BUILD_DIR=build
SIMPLEAMPQCLIENT_URL=https://github.com/alanxz/SimpleAmqpClient/archive/$SIMPLEAMPQCLIENT_PACKAGE

. ../definitions.sh
. ../../helper-functions.sh

get_package_or_die $SIMPLEAMPQCLIENT_PACKAGE $SIMPLEAMPQCLIENT_URL

echo ">+>+> Cleaning up from previous build"
rm -rf $SIMPLEAMPQCLIENT_DIR $SIMPLEAMPQCLIENT_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"


echo ">+>+> Unpacking $SIMPLEAMPQCLIENT_VERSION"
unzip $SOURCES_DIR/$SIMPLEAMPQCLIENT_PACKAGE
echo "<+<+< Done unpacking $SIMPLEAMPQCLIENT_VERSION"


echo ">+>+> Patching $SIMPLEAMPQCLIENT_VERSION"
pushd $SIMPLEAMPQCLIENT_DIR
popd
echo "<+<+< Done patching $SIMPLEAMPQCLIENT_VERSION"

mkdir -p $SIMPLEAMPQCLIENT_BUILD_DIR
pushd $SIMPLEAMPQCLIENT_BUILD_DIR


echo "WARNING not compiled with -std=gnu++0x "
echo ">+>+> Configuring $SIMPLEAMPQCLIENT_VERSION"
CXXFLAGS="${CXX_COMPILER_FLAGS?}" \
    CXX=$CXX_COMPILER \
    cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DBUILD_SHARED_LIBS=OFF \
    -DBOOST_ROOT=$PREFIX \
    -DBUILD_STATIC_LIBS=ON \
    ../$SIMPLEAMPQCLIENT_DIR/
echo "<+<+< Done configuring $SIMPLEAMPQCLIENT_VERSION"


echo ">+>+> Building $SIMPLEAMPQCLIENT_VERSION"
make -j ${BUILD_NUM_PROCESSES-2} VERBOSE=1
echo "<+<+< Done building $SIMPLEAMPQCLIENT_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $SIMPLEAMPQCLIENT_VERSION"
make install
echo "<+<+< Done installing $SIMPLEAMPQCLIENT_VERSION"


echo ">+>+>+ Cleaning up"
popd
rm -rf $SIMPLEAMPQCLIENT_DIR $SIMPLEAMPQCLIENT_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
