#! /bin/bash
set -eux
# CRAKOON was completely ported from 3rdparty
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

. /etc/lsb-release

CRAKOON_BRANCH=1.3
CRAKOON_REVISION=d291248400
CRAKOON_VERSION=crakoon-${CRAKOON_BRANCH}-${CRAKOON_REVISION}
CRAKOON_DIR=${CRAKOON_VERSION}.git
CRAKOON_BUILD_DIR=build
CRAKOON_GIT_URL=https://github.com/Incubaid/crakoon.git

. ../definitions.sh || exit
. ../../helper-functions.sh || exit

echo ">+>+> Cleaning up from previous build"
rm -rf $CRAKOON_DIR $CRAKOON_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"

echo ">+>+> Getting ${CRAKOON_VERSION}"
git clone ${CRAKOON_GIT_URL} ${CRAKOON_DIR}
pushd ${CRAKOON_DIR}
git reset --hard ${CRAKOON_REVISION}
popd

echo ">+>+> Done getting ${CRAKOON_VERSION}"

echo ">+>+> Patching ${CRAKOON_VERSION}"
pushd ${CRAKOON_DIR}

[ ${DISTRIB_ID} == "Ubuntu" ] && \
    [ ${DISTRIB_RELEASE%.*} -lt 14 ] && \
    patch -p1 < ../crakoon-configure-ac-remove-am-proc-ar.patch

patch -p1 < ../poll_handle_EINTR.patch
popd
echo ">+>+> Done patching ${CRAKOON_VERSION}"

echo ">+>+> Configuring $CRAKOON_VERSION"
pushd ${CRAKOON_DIR}
autoreconf -isv
popd

mkdir $CRAKOON_BUILD_DIR
pushd $CRAKOON_BUILD_DIR

# NOTE: adding -O1 to COMPILER flags as crakoon uses FORTIFY_SOURCE 
#       which requires/mandates optimization
# from the gcc compiler manpage: "If you use multiple -O options, with or without 
#                                 level numbers, the last such option is the one 
#                                 that is effective."

CFLAGS="$C_COMPILER_FLAGS -O1" CC=$C_COMPILER \
    CXXFLAGS="$CXX_COMPILER_FLAGS -O1" \
    CXX=$CXX_COMPILER \
    ../$CRAKOON_DIR/configure \
    --prefix=$PREFIX \
    --with-pic \
    --disable-shared  || exit
echo "<+<+< Done configuring $CRAKOON_VERSION"

echo ">+>+> Building $CRAKOON_VERSION"
${MAKE_PARALLEL_COMMAND?} || exit
echo "<+<+< Done building $CRAKOON_VERSION"

echo ">+>+> Installing $CRAKOON_VERSION"
${MAKE_INSTALL_COMMAND?} || exit
echo "<+<+< Done installing $CRAKOON_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"


echo ">+>+>+ Cleaning up"
popd
rm -rf $CRAKOON_DIR $CRAKOON_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
