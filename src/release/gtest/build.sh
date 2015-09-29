#! /bin/bash
set -eux
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

GTEST_VERSION=gtest-1.4.0
GTEST_DIR=$GTEST_VERSION
GTEST_PACKAGE=$GTEST_VERSION.tar.bz2
GTEST_BUILD_DIR=gtest_build
GTEST_URL=https://googletest.googlecode.com/files/$GTEST_PACKAGE

. ../definitions.sh || exit
. ../../helper-functions.sh || exit

get_package_or_die $GTEST_PACKAGE $GTEST_URL



echo ">+>+> Cleaning up from previous build"
rm -rf $GTEST_DIR $GTEST_BUILD_DIR
echo ">+>+> Done cleaning up from previous build"


echo ">+>+> Unpacking $GTEST_PACKAGE"
tar -xjf $SOURCES_DIR/$GTEST_PACKAGE || exit
echo ">+>+> Done unpacking $GTEST_PACKAGE"

echo ">+>+> Patching $GTEST_VERSION"
pushd $GTEST_DIR
patch -p1 < ../gtest.patch0 || exit
patch -p1 < ../gtest.patch1 || exit
patch -p1 < ../gtest.patch2 || exit
popd
echo "<+<+< Done patching $GTEST_VERSION"


mkdir $GTEST_BUILD_DIR
pushd $GTEST_BUILD_DIR

echo ">+>+> Configuring $GTEST_VERSION"
#_EXTRA_FLAGS $CXX_COMPILER_DEBUG_FLAGS
CXXFLAGS="${CXX_COMPILER_FLAGS}" CXX=${CXX_COMPILER?} ../$GTEST_DIR/configure \
    --prefix=$PREFIX \
    --enable-static \
    --disable-shared  || exit
echo ">+>+> Done configuring $GTEST_VERSION"

echo ">+>+> Making $GTEST_VERSION"
${MAKE_PARALLEL_COMMAND?} || exit
echo "<+<+< Done making $GTEST_VERSION"


BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $GTEST_VERSION"
${MAKE_INSTALL_COMMAND?} || exit
echo "<+<+< Done installing $GTEST_VERSION"


echo ">+>+> Cleaning up"
popd
rm -rf $GTEST_DIR $GTEST_BUILD_DIR
echo ">+>+> Done cleaning up"

# Local Variables: **
# compile-command: "./build-gtest.sh" **
# End: **