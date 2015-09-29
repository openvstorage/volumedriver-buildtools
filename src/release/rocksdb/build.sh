#! /bin/bash
set -eux
# Patches have been checked
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

ROCKSDB_VERSION=3.11
ROCKSDB_DIR=rocksdb-$ROCKSDB_VERSION
# The tarball on github has this name ...
ROCKSDB_REMOTE_PACKAGE=v${ROCKSDB_VERSION}.tar.gz
# ... while we want to be able to make sense of our local cache
ROCKSDB_PACKAGE=rocksdb-${ROCKSDB_VERSION}.tar.gz
ROCKSDB_BUILD_DIR=build
ROCKSDB_URL=https://github.com/facebook/rocksdb/archive/$ROCKSDB_REMOTE_PACKAGE

. ../definitions.sh
. ../../helper-functions.sh

get_package_or_die ${ROCKSDB_PACKAGE} $ROCKSDB_URL

echo ">+>+> Cleaning up from previous build"
rm -rf $ROCKSDB_DIR $ROCKSDB_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"


echo ">+>+> Unpacking $ROCKSDB_VERSION"
tar -xzf $SOURCES_DIR/$ROCKSDB_PACKAGE
echo "<+<+< Done unpacking $ROCKSDB_VERSION"


# echo ">+>+> Patching $ROCKSDB_VERSION"
# pushd $ROCKSDB_DIR
# popd
# echo "<+<+< Done patching $ROCKSDB_VERSION"

# #mkdir $ROCKSDB_BUILD_DIR
pushd ${ROCKSDB_DIR}

echo ">+>+> Configuring $ROCKSDB_VERSION"
# CXXFLAGS="${CXX_COMPILER_FLAGS?}" CXX=$CXX_COMPILER ../$ROCKSDB_DIR/configure \
#     --prefix=$PREFIX \
#     --enable-static \
#     --with-boost=$PREFIX \
#     --disable-ewarning \
#     --enable-debug \
#     --enable-threads \
#     --disable-shared
echo "<+<+< Done configuring $ROCKSDB_VERSION"


echo ">+>+> Building $ROCKSDB_VERSION"
rm -rf ${PREFIX}/include/rocksdb
INSTALL_PATH=${PREFIX} CXXFLAGS="${CXX_COMPILER_FLAGS?}" CXX=$CXX_COMPILER PORTABLE=1 make static_lib -j ${BUILD_NUM_PROCESSES-2}
echo "<+<+< Done building $ROCKSDB_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $ROCKSDB_VERSION"
cp librocksdb.a ${PREFIX}/lib
rm -rf ${PREFIX}/include/rocksdb
cp -r include/rocksdb ${PREFIX}/include/rocksdb
echo "<+<+< Done installing $ROCKSDB_VERSION"

echo ">+>+>+ Cleaning up"
popd
rm -rf $ROCKSDB_DIR $ROCKSDB_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
