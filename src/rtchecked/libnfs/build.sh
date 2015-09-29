#! /bin/bash
set -eux


. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

LIBNFS_VERSION=libnfs-1.9.2
LIBNFS_DIR=$LIBNFS_VERSION
LIBNFS_PACKAGE=$LIBNFS_VERSION.tar.gz
LIBNFS_BUILD_DIR=build
LIBNFS_URL=https://sites.google.com/site/libnfstarballs/li/${LIBNFS_PACKAGE}

. ../definitions.sh
. ../../helper-functions.sh

get_package_or_die $LIBNFS_PACKAGE $LIBNFS_URL

echo ">+>+> Cleaning up from previous build"
rm -rf $LIBNFS_DIR $LIBNFS_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> Unpacking $LIBNFS_PACKAGE"
tar -xzf $SOURCES_DIR/$LIBNFS_PACKAGE
echo "<+<+< Done unpacking $LIBNFS_PACKAGE"

echo ">+>+> Patching $LIBNFS_VERSION"
pushd $LIBNFS_DIR

popd
echo "<+<+< Done patching $LIBNFS_VERSION"

mkdir $LIBNFS_BUILD_DIR
pushd $LIBNFS_BUILD_DIR


# curl does difficult about c preprocessor defs in the CFLAGS var
# here we have to add --enable-debug and --disable-optimize when needed
echo ">+>+> Configuring $LIBNFS_VERSION"
CFLAGS="$C_COMPILER_EXTRA_FLAGS $C_COMPILER_OPTIMIZE_FLAGS" \
    CPPFLAGS=$CPP_EXPORTED_FLAGS \
    CC=$C_COMPILER ../$LIBNFS_DIR/configure \
    --prefix=$PREFIX \
    --disable-silent-rules \
    --with-sysroot=$PREFIX \
    --enable-static \
    --disable-shared \
    --with-pic \
    --enable-examples

echo "<+<+< Done configuring $LIBNFS_VERSION"


echo ">+>+> Building $LIBNFS_VERSION"
make -j ${BUILD_NUM_PROCESSES-2}
echo "<+<+< Done building $LIBNFS_VERSION"

echo ">+>+> Installing $LIBNFS_VERSION"
make install
echo "<+<+< Done installing $LIBNFS_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+>+ Cleaning up"
popd
rm -rf $LIBNFS_DIR $LIBNFS_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
