#! /bin/bash
set -eux

. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}


FUSE_VERSION=fuse-2.9.3
FUSE_DIR=$FUSE_VERSION
FUSE_PACKAGE=$FUSE_VERSION.tar.gz
FUSE_BUILD_DIR=fuse_build
FUSE_URL=http://downloads.sourceforge.net/project/fuse/fuse-2.X/2.9.3/$FUSE_PACKAGE


. ../definitions.sh
. ../../helper-functions.sh

get_package_or_die $FUSE_PACKAGE $FUSE_URL


echo ">+>+> Cleaning up from previous build"
rm -rf $FUSE_DIR $FUSE_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"


echo ">+>+> Unpacking $FUSE_PACKAGE"
tar -xzf $SOURCES_DIR/$FUSE_PACKAGE
echo "<+<+< Done unpacking $FUSE_PACKAGE"

echo ">+>+> Patching $FUSE_PACKAGE"
pushd $FUSE_DIR
patch -p1 < ../fuse-disable-symbol-versions.patch
patch -p1 < ../fuse-unlink-directories-with-unlinked-open-files.patch
patch -p1 < ../fuse-introduce-a-means-to-control-the-threads-employed-by.patch

popd
echo "<+<+< Done patching $FUSE_PACKAGE"


mkdir $FUSE_BUILD_DIR
pushd $FUSE_BUILD_DIR

echo ">+>+> Configuring $FUSE_VERSION"
CFLAGS="$C_COMPILER_FLAGS" CC=$C_COMPILER ../$FUSE_DIR/configure \
    --prefix=$PREFIX \
    --enable-static \
    --disable-util \
    --disable-silent-rules \
    --disable-example \
    --disable-shared
echo "<+<+< Done configuring $FUSE_VERSION"


echo ">+>+> Building $FUSE_VERSION"
make -j ${BUILD_NUM_PROCESSES-2}
echo "<+<+< Done building $FUSE_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $FUSE_VERSION"
make install
echo "<+<+< Done installing $FUSE_VERSION"


echo ">+>+>+ Cleaning up"
popd
rm -rf $FUSE_DIR $FUSE_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
