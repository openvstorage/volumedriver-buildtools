#! /bin/bash
set -eux
# Patches have been checked
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

. /etc/lsb-release

GANESHA_VERSION=nfs-ganesha-2.1.0-0.1.1-Source
GANESHA_DIR=nfs-ganesha-2.1.0-0.1.1-Source
GANESHA_PACKAGE=$GANESHA_VERSION.tar.gz
GANESHA_BUILD_DIR=build
GANESHA_URL=http://downloads.sourceforge.net/project/nfs-ganesha/nfs-ganesha/2.1.0/${GANESHA_PACKAGE}

. ../definitions.sh
. ../../helper-functions.sh

get_package_or_die $GANESHA_PACKAGE $GANESHA_URL

echo ">+>+> Cleaning up from previous build"
rm -rf $GANESHA_DIR
rm -rf $GANESHA_BUILD_DIR
echo "<+<+< Done cleaning up from previous build"


echo ">+>+> Unpacking $GANESHA_VERSION"
tar -xzf $SOURCES_DIR/$GANESHA_PACKAGE
echo "<+<+< Done unpacking $GANESHA_VERSION"


echo ">+>+> Patching $GANESHA_VERSION"
pushd $GANESHA_DIR
patch -p1 < ../first.patch
patch -p1 < ../fsal_pseudo_nameleak.patch
patch -p1 < ../config_parsing_initleak.patch
patch -p1 < ../thrdpool_shutdown.patch
#patch -p1 < ../drop-renamed-inodes-from-cache.patch
patch -p2 < ../0001-Only-kill-entry-in-cache_inode_refresh_attrs-if-erro.patch

if [ ${DISTRIB_RELEASE} != "12.04" ]
then
    patch -p1 < ../fix-krb5-detection-on-ubuntu-14-04.patch
fi

patch -p1 < ../static_inline.patch

popd
echo "<+<+< Done patching $GANESHA_VERSION"

mkdir -p $GANESHA_BUILD_DIR
pushd $GANESHA_BUILD_DIR

case `lsb_release -sr` in
    rolling)
	LIBCAP=/lib/libcap.so
	;;
    11.10)
	LIBCAP=/lib/libcap.a
	;;
    *)
	LIBCAP=/lib/x86_64-linux-gnu/libcap.a
	;;
esac

echo "WARNING not compiled with -std=gnu++0x "
echo ">+>+> Configuring $GANESHA_VERSION"
CFLAGS="${C_COMPILER_FLAGS?}" \
    CC=$C_COMPILER \
    cmake \
    -DALLOCATOR=libc \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Debug \
    -DLIBCAP=${LIBCAP} \
    -DUSE_9P=OFF \
    ../$GANESHA_DIR/
echo "<+<+< Done configuring $GANESHA_VERSION"

echo ">+>+> Building $GANESHA_VERSION with 1 process, not using BUILD_NUM_PROCESSES"
make -j 1 VERBOSE=1
echo "<+<+< Done building $GANESHA_VERSION"

BUILD_SIZE=`du -sh`
echo "Build used $BUILD_SIZE disk space"

echo ">+>+> Installing $GANESHA_VERSION"
make install
echo "<+<+< Done installing $GANESHA_VERSION"

# hacked version of our development system install

echo ">+>+> HACKED INSTALL OF DEVELOPMENT ENV FOR GANESHA"
popd
GANESHA_INCLUDE_DIR=${PREFIX}/include/ganesha

mkdir -p ${GANESHA_INCLUDE_DIR}
mkdir -p ${GANESHA_INCLUDE_DIR}/ganesha
#some massaging of config to remove the #define VERSION which clashes with autotools
grep -v " VERSION " ${GANESHA_BUILD_DIR}/include/config.h > ${GANESHA_INCLUDE_DIR}/ganesha/config.h
pushd ${GANESHA_DIR}/include
find -name "*.h" -exec cp --parents '{}' ${GANESHA_INCLUDE_DIR}/ganesha \;
popd
cp -R ${GANESHA_DIR}/libntirpc/ntirpc ${GANESHA_INCLUDE_DIR}

cp ganesha-c++.patch ${PREFIX}/include
pushd ${GANESHA_INCLUDE_DIR}
patch -p1 < ../ganesha-c++.patch
popd
rm ${PREFIX}/include/ganesha-c++.patch

echo "<+<+< Done HACKED INSTALL OF DEVELOPMENT ENV FOR GANESHA"

# echo ">+>+>+ Building ganesha debian package"
# pushd build-debian
# ./package.sh
# popd
# echo "<+<+<+ Building ganesha debian package"

echo ">+>+>+ Cleaning up"
rm -rf $GANESHA_DIR $GANESHA_BUILD_DIR
echo "<+<+< Done cleaning up"

# Local Variables: **
# compile-command: "./build.sh" **
# End: **
