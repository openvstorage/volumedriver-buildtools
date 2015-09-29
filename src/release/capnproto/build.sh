#! /bin/bash
set -eux

. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}


CAPNPROTO_VERSION=capnproto-c++-0.5.3
CAPNPROTO_DIR=$CAPNPROTO_VERSION
CAPNPROTO_PACKAGE=$CAPNPROTO_VERSION.tar.gz
CAPNPROTO_BUILD_DIR=build
CAPNPROTO_URL=https://capnproto.org/${CAPNPROTO_PACKAGE}


. ../definitions.sh
. ../../helper-functions.sh

get_package_or_die $CAPNPROTO_PACKAGE $CAPNPROTO_URL


echo ">+>+> Cleaning up from previous build"
rm -rf $CAPNPROTO_DIR $CAPNPROTO_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"


echo ">+>+> Unpacking $CAPNPROTO_PACKAGE"
tar -xzf $SOURCES_DIR/$CAPNPROTO_PACKAGE
echo "<+<+< Done unpacking $CAPNPROTO_PACKAGE"

echo ">+>+> Patching $CAPNPROTO_PACKAGE"
pushd $CAPNPROTO_DIR
popd
echo "<+<+< Done patching $CAPNPROTO_PACKAGE"


mkdir -p $CAPNPROTO_BUILD_DIR
pushd $CAPNPROTO_BUILD_DIR

echo ">+>+> Configuring $CAPNPROTO_VERSION"
CXXFLAGS="${CXX_COMPILER_FLAGS?}" \
	CXX=$CXX_COMPILER \
	CFLAGS="$C_COMPILER_FLAGS" \
	CC=$C_COMPILER ../$CAPNPROTO_DIR/configure \
    --prefix=$PREFIX \
    --enable-static \
    --disable-silent-rules \
    --enable-static \
    --disable-shared \
    --with-pic=yes \
    --with-sysroot=${PREFIX}

echo "<+<+< Done configuring $CAPNPROTO_VERSION"

echo ">+>+> Building $CAPNPROTO_VERSION"
make -j ${BUILD_NUM_PROCESSES-2}
echo "<+<+< Done building $CAPNPROTO_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $CAPNPROTO_VERSION"
make install
echo "<+<+< Done installing $CAPNPROTO_VERSION"

echo ">+>+>+ Cleaning up"
popd
rm -rf $CAPNPROTO_DIR $CAPNPROTO_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
