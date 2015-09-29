#! /bin/bash

set -eux
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

WEBSTOR_VERSION=webstor-1.0b.1.8
WEBSTOR_DIR=webstor
WEBSTOR_PACKAGE=../../$WEBSTOR_DIR
WEBSTOR_BUILD_DIR=build

. ../definitions.sh
. ../../helper-functions.sh



echo ">+>+> Cleaning up from previous build"
rm -rf $WEBSTOR_DIR $WEBSTOR_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"



# by linking here you get links to the real code!
mkdir webstor

pushd webstor
ln -sf ../$WEBSTOR_PACKAGE/* .
popd



# echo ">+>+> Unpacking $WEBSTOR_PACKAGE"
# tar  -xzf ../../$WEBSTOR_PACKAGE
# echo "<+<+< Done unpacking $WEBSTOR_PACKAGE"

# pushd $WEBSTOR_DIR
# echo ">+>+> Patching the most primitive buildsystem in the world"
# patch -p1 < ../webstor.patch0
# echo "<+<+< Done patching the most primitive buildsystem in the world"

# these directories are made to avoid automake soiling the code base.
pushd $WEBSTOR_DIR
rm -rf m4
mkdir m4
mkdir autom4te.cache
autoreconf -isv
popd

mkdir -p $WEBSTOR_BUILD_DIR
pushd $WEBSTOR_BUILD_DIR

echo ">+>+> Configuring $WEBSTOR_VERSION"
CXXFLAGS="${CXX_COMPILER_FLAGS}" \
    CXX=$CXX_COMPILER \
    CPPFLAGS="-I${PREFIX}/include -I/usr/include/libxml2" \
    LDFLAGS=-L${PREFIX}/lib \
    ../$WEBSTOR_DIR/configure --prefix=$PREFIX \
    --enable-static \
    --disable-shared

echo ">+>+> Building $WEBSTOR_VERSION"
make -j ${BUILD_NUM_PROCESSES-2}
echo "<+<+< Done building $WEBSTOR_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $WEBSTOR_VERSION"
make install
echo "<+<+< Done installing $WEBSTOR_VERSION"

echo ">+>+>+ Cleaning up"
popd
rm -rf  $WEBSTOR_BUILD_DIR $WEBSTOR_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
