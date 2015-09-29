#! /bin/bash
set -o pipefail
function get_package_or_die {
     __a=$#
    if (( __a != 2 && __a != 3 ))
    then
	echo "Script requires 2 or 3 arguments"
	echo "First required argument is the package name: " $1
	echo "Second required argument is the package url: " $2
	echo "Third optional argument is FORCE when you want to force getting the package: " $3
	exit
    fi

    [ -d ${SOURCES_DIR?} ] || mkdir -p ${SOURCES_DIR?}
    [ -d ${SOURCES_DIR?} ] || exit

    pushd ${SOURCES_DIR?"SOURCES_DIR needs to be set for this to work"}
    if [[ "x${3:-no}" == "xFORCE" ]]
    then
	rm $1
    fi

    if [ -f $1 ]
    then
       	echo "Not getting $1 again"
    else
	echo ">+>+> Getting package $1"
	wget --no-check-certificate -O $1 $2 || (rm $1 && exit 1)
	echo "<+<+< Done getting package $1"
    fi
    popd
}

function check_buildtools_version {
    if [ -f ${PREFIX?}/lib/pkgconfig/buildtools.pc ]
    then
	OLD_BUILDTOOLS_VERSION=`PKG_CONFIG_PATH=${PREFIX?}/lib/pkgconfig pkg-config --modversion buildtools`
	if [ "x$BUILDTOOLS_VERSION" != "x$OLD_BUILDTOOLS_VERSION" ]
	then
	    echo "New version of buildtools is different from the one that is installed in prefix, exiting"
	    exit 1
	fi

    fi
}

function build_package {
    echo "Building package ${1?script takes as argument a package name}"
    pushd $1
    time ./build.sh 2>&1 | (tee -a $2)
    popd
}

function build_packages
{

#    ERROR_LOG=$(mktemp -p `pwd` -t build-error-XXXXXX.log)
    BUILD_LOG=$(mktemp -p `pwd` -t build-XXXXXX.log)

    echo "Build log is in $BUILD_LOG"
#    echo "Build errors are ing $ERROR_LOG"

    for i in $1
    do
	build_package $i $BUILD_LOG
    done

    #if we get here the build was successful and we can remove the logs
    rm $BUILD_LOG
}
# Local Variables: **
# End: **
