#!/bin/bash

set -eux
. ../../BUILDTOOLS_VERSION.sh
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}

. ../definitions.sh


echo ">+>+> Generating thirdparty pkg-config file"

# XXX: is passing the CXX_*_FLAGS as Cflags a good idea
# Y42: no... counterquestion .. is passing subcomponents as "requires a good idea?"
cat <<EOF > ${PREFIX}/lib/pkgconfig/buildtools.pc

prefix=${PREFIX}
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${exec_prefix}/lib
python_version=${PYTHON_VERSION}
boost_python_library_name=${BOOST_PYTHON_LIBRARY_NAME:-"boost_python"}

Name: volumedriver-buildtools
Description: VolumeDriver thirdparty software
Version: ${BUILDTOOLS_VERSION?}
Cflags: -I\${includedir} ${CPP_EXPORTED_FLAGS?}
Libs: -L\${libdir} -llttng-ust -llttng-ust-tracepoint -lurcu-cds -lurcu-bp -luriparser -lalbaproxy -lxio -lcapnp-rpc -lkj-async -lcapnp -lkj  -lprotobuf -lomniORB4 -lomnithread -lcurl -lgtest -l\${boost_python_library_name} -lpython\${python_version} -larakoon-1.0 -lSimpleAmqpClient -lrabbitmq -lwebstor -lcurl -lssl -lcrypto -lxml2 -lboost_random -lboost_log -lboost_thread -lboost_serialization -lboost_regex -lboost_program_options -lboost_chrono -lboost_filesystem -lboost_date_time -lboost_system -lgcrypt -lcares -lzmq -ltokyocabinet -lrocksdb -llz4 -lsnappy -lbz2 -lz -ldl
EOF

echo "<+<+< Done generating thirdparty pkg-config file"

echo ">+>+> Copying build configuration to ${PREFIX}"
cp ${VOLUMEDRIVER_BUILD_CONFIGURATION?} ${PREFIX?}/this_build_configuration
echo ">+>+> Done copying build configuration to ${PREFIX}"

# Local Variables: **
# compile-command: "time ./build.sh" **
# End: **
