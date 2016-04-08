#! /bin/bash
set -eux
# FUSE was completely ported from 3rdparty
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

. /etc/lsb-release

FUSE_BRANCH=master
FUSE_REVISION=4600e52e831d05e31fc54e666ff729bcab054017
FUSE_VERSION=fuse-${FUSE_BRANCH}-${FUSE_REVISION}
FUSE_DIR=${FUSE_VERSION}.git
FUSE_BUILD_DIR=build
FUSE_GIT_URL=https://github.com/libfuse/libfuse.git

. ../definitions.sh
. ../../helper-functions.sh

echo ">+>+> Cleaning up from previous build"
rm -rf $FUSE_DIR $FUSE_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> Getting ${FUSE_VERSION}"
git clone ${FUSE_GIT_URL} ${FUSE_DIR}
pushd ${FUSE_DIR}
git reset --hard ${FUSE_REVISION}
popd

echo ">+>+> Done getting ${FUSE_VERSION}"

echo ">+>+> Patching ${FUSE_VERSION}"
pushd ${FUSE_DIR}
# patch -p1 < ../fuse-unlink-directories-with-unlinked-open-files.patch
patch -p1 < ../0001-Allow-users-to-control-the-threads-in-the-fuse-loop.patch
popd

echo ">+>+> Done patching ${FUSE_VERSION}"

echo ">+>+> Configuring $FUSE_VERSION"
pushd ${FUSE_DIR}
mkdir m4
touch config.rpath
autoreconf -isv
popd

mkdir $FUSE_BUILD_DIR
pushd $FUSE_BUILD_DIR

CFLAGS="$C_COMPILER_FLAGS" CC=$C_COMPILER ../$FUSE_DIR/configure \
    --prefix=$PREFIX \
    --enable-static \
    --disable-util \
    --disable-silent-rules \
    --disable-example \
    --disable-shared
echo "<+<+< Done configuring $FUSE_VERSION"

echo ">+>+> Building $FUSE_VERSION"
${MAKE_PARALLEL_COMMAND?}
echo "<+<+< Done building $FUSE_VERSION"

echo ">+>+> Installing $FUSE_VERSION"
${MAKE_INSTALL_COMMAND?}
echo "<+<+< Done installing $FUSE_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"


echo ">+>+>+ Cleaning up"
popd
rm -rf $FUSE_DIR $FUSE_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
