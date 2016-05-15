COMPILER_DEBUG_LEVEL=${COMPILER_DEBUG_LEVEL:-gdwarf-3}
CPP_EXPORTED_FLAGS="-D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -DBOOST_LOG_DYN_LINK -DBOOST_SPIRIT_THREADSAFE -DBOOST_DATE_TIME_NO_LIB -DBOOST_DATE_TIME_POSIX_TIME_STD_CONFIG -D_FILE_OFFSET_BITS=64 -I/usr/include/python2.7"

C_COMPILER=/usr/bin/gcc-4.9
C_COMPILER_EXTRA_FLAGS="-fPIC -I${PREFIX}/include"
C_COMPILER_OPTIMIZE_FLAGS="-ggdb3 -O0 -${COMPILER_DEBUG_LEVEL?}"
C_COMPILER_FLAGS="${C_COMPILER_EXTRA_FLAGS?} ${C_COMPILER_OPTIMIZE_FLAGS?} ${CPP_EXPORTED_FLAGS?}"

CXX_COMPILER=/usr/bin/g++-4.9
CXX_COMPILER_EXTRA_FLAGS="-std=gnu++14 -fPIC -I${PREFIX}/include"
CXX_COMPILER_OPTIMIZE_FLAGS="-ggdb3 -O0 -${COMPILER_DEBUG_LEVEL?}"
CXX_COMPILER_FLAGS="${CXX_COMPILER_EXTRA_FLAGS?} ${CXX_COMPILER_OPTIMIZE_FLAGS?} ${CPP_EXPORTED_FLAGS?}"

MAKE_COMMAND=make
MAKE_INSTALL_COMMAND="${MAKE_COMMAND} install"
MAKE_PARALLEL_COMMAND="${MAKE_COMMAND} -j ${BUILD_NUM_PROCESSES-2}"

if [ ! -x ${C_COMPILER} ]
then
  GCC_MAJOR=$(echo __GNUC__ | gcc -E -x c - | tail -n 1)
  GCC_MINOR=$(echo __GNUC_MINOR__ | gcc -E -x c - | tail -n 1)
  if [ ${GCC_MAJOR} -gt 4 ] || [ ${GCC_MAJOR} -eq 4 -a ${GCC_MINOR} -ge 9 ]
  then
    C_COMPILER=/usr/bin/gcc
  else
    echo 'gcc compiler too old, need at least 4.9+ installed'
    exit 1
  fi
fi


if [ ! -x ${CXX_COMPILER} ]
then
  GCC_MAJOR=$(echo __GNUC__ | g++ -E -x c - | tail -n 1)
  GCC_MINOR=$(echo __GNUC_MINOR__ | g++ -E -x c - | tail -n 1)
  if [ ${GCC_MAJOR} -gt 4 ] || [ ${GCC_MAJOR} -eq 4 -a ${GCC_MINOR} -ge 9 ]
  then
    CXX_COMPILER=/usr/bin/g++
  else
    echo 'g++ compiler too old, need at least 4.9+ installed'
    exit 1
  fi
fi

