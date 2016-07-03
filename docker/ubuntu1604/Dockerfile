FROM ubuntu:16.04

# note: jenkins has uid 1001 & gid 1002 on our build hosts, this needs to be reflected in here!

ENV UID 1001

# add required packages

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get dist-upgrade -y && \
    apt-get install -y gcc g++ clang-3.8 valgrind \
                       libboost1.58-all-dev \
                       build-essential sudo \
                       flex bison gawk check pkg-config \
                       autoconf libtool realpath bc gettext lcov \
                       unzip doxygen dkms debhelper pylint git cmake \
                       wget libssl-dev libpython2.7-dev libxml2-dev \
                       libcurl4-openssl-dev libc6-dbg liblz4-dev \
                       librabbitmq-dev libaio-dev libkrb5-dev libc-ares-dev \
                       libunwind8 libgoogle-glog-dev && \
    apt-get -y autoremove --purge && apt-get clean

# for volumedriver-core
RUN apt-get update -qq && \
    apt-get install -y pkg-create-dbgsym elfutils \
                       libloki-dev libprotobuf-dev liblttng-ust-dev libzmq3-dev \
                       libtokyocabinet-dev libbz2-dev protobuf-compiler \
                       libgflags-dev libsnappy-dev \
                       redis-server libhiredis-dev libhiredis-dbg \
                        libomniorb4-dev omniidl omniidl-python omniorb-nameserver \
                       librdmacm-dev libibverbs-dev python-nose fuse \
                       python-protobuf \
                       supervisor rpcbind && \
     apt-get -y autoremove --purge && apt-get clean

RUN groupadd -g 1002 jenkins && \
    useradd jenkins -s /bin/bash -g jenkins -m -u ${UID} -g 1002 -d /home/jenkins && \
    echo "jenkins ALL=NOPASSWD: ALL" >/etc/sudoers.d/jenkins

# volumedriver-core tests use arakoon & alba
# (note: apt-get install -y --allow-unauthenticated arakoon alba does not yet work on 16.04)
# volumedriver-core needs accelio library to build
RUN echo "deb http://apt.openvstorage.org unstable main" > /etc/apt/sources.list.d/ovsaptrepo.list && \
    apt-get update -qq && \
    apt-get install -y --allow-unauthenticated libxio0 libxio-dev && \
    apt-get install -y libev4 && \
    cd /root && apt-get download --allow-unauthenticated arakoon alba && \
    dpkg -i --ignore-depends=libgflags2,libsnappy1 alba_*_amd64.deb arakoon_*_amd64.deb && \
    rm alba_*_amd64.deb arakoon_*_amd64.deb && \
    apt-get clean

RUN echo 'BatchMode yes' >>/etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

# some tests need jenkins to be part of at least 3 groups; make it so...
RUN usermod -a -G lp jenkins && \
    usermod -a -G games jenkins && \
    usermod -a -G floppy jenkins

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord" ]
