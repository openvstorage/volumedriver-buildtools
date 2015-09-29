#! /bin/bash
set -eux
# this file should be run in order to get all the supported systems ready to start building the tools

sudo apt-get install -y software-properties-common

# add some extra repo's for newest versions
## gcc-4.9
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
## boost-1.57
sudo add-apt-repository -y ppa:afrank/boost

sudo apt-get update

sudo apt-get install -y build-essential gcc-4.9 g++-4.9 libstdc++-4.9-dev
sudo apt-get install -y libboost1.57-all-dev

# some packages that need to be installed (possibly incomplete)
sudo apt-get install -y flex bison gawk check pkg-config autoconf libtool realpath bc gettext unzip doxygen dkms \
                        debhelper pylint git

sudo apt-get install -y libbz2-dev zlib1g-dev libssl-dev libpython2.7-dev libfuse-dev libxml2-dev libcapnp-dev \
                        libxmlrpc-c++8-dev libxmlrpc-core-c3-dev liburcu-dev libprotobuf-dev protobuf-compiler \
                        libtokyocabinet-dev libgflags-dev libsnappy-dev libblkid-dev libloki-dev\
                        lttng-tools liblttng-ust-dev \
                        libomnithread3-dev libomniorb4-dev libhiredis-dev librabbitmq-dev

# sudo apt-get -y install python-dev realpath dpkg-dev dkms debhelper pylint subversion python-nose python-rrdtool libaio1 libaio-dev libcap-dev libkrb5-dev libpam0g-dev git cmake unzip lzip

#for ganesha and nfs -- the libtirpc1 is there to create /etc/netconfig there might be a better way
sudo apt-get -y install rpcbind libtirpc1

# for cocaine
#sudo apt-get -y install build-essential libltdl-dev libev-dev libmsgpack-dev libboost-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libssl-dev uuid-dev libarchive-dev binutils-dev libcgroup-dev

# only for testing
sudo apt-get -y install python-protobuf

# building rpm packages
sudo apt-get -y install rpm
