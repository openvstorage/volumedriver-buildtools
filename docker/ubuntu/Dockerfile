FROM ubuntu:14.04

# last update: 20160428
#  -- change previous line to trigger rebuild of docker image on jenkins; eg. when docker-entrypoint.sh changes

# add jenkins user -- this is required for git to work
# note: jenkins has uid 1001 & gid 1002 on our build hosts, this needs to be reflected in here!

ENV UID 1001

RUN groupadd -g 1002 jenkins && \
    useradd jenkins -s /bin/bash -g jenkins -m -u ${UID} -g 1002 -d /home/jenkins && \
    echo "jenkins ALL=NOPASSWD: ALL" >/etc/sudoers.d/jenkins

# add required packages

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    add-apt-repository -y ppa:afrank/boost && \
    apt-get update && \
    apt-get install -y gcc-4.9 g++-4.9 libstdc++-4.9-dev clang-3.5 \
                       libboost1.57-all-dev \
                       build-essential \
                       flex bison gawk check pkg-config \
                       autoconf libtool realpath bc gettext lcov \
                       unzip doxygen dkms debhelper pylint git cmake \
                       wget libssl-dev libpython2.7-dev libxml2-dev \
                       libcurl4-openssl-dev libc6-dbg liblz4-devel \
                       librabbitmq-dev libaio-dev libkrb5-dev libc-ares-dev && \
    apt-get -y autoremove --purge && apt-get clean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 99 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 99 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.5 99 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.5 99 && \
    update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-3.5 99

# for volumedriver-core
RUN apt-get update && \
    apt-get install -y mercurial rpm pkg-create-dbgsym elfutils \
                       libloki-dev libprotobuf-dev liblttng-ust-dev libzmq3-dev \
                       libtokyocabinet-dev libbz2-dev protobuf-compiler \
                       libgflags-dev libsnappy-dev \
                       redis-server libhiredis-dev libhiredis-dbg \
                        libomniorb4-dev omniidl omniidl-python omniorb-nameserver \
                       librdmacm-dev libibverbs-dev python-nose fuse \
                       python-protobuf \
                       supervisor rpcbind && \
     apt-get -y autoremove --purge && apt-get clean

# install newer valgrind as the older3.10.0-svn version in ubuntu has the tendency
# to hang
RUN VALVERSION="3.11.0" && \
    wget -q -O /tmp/valgrind-${VALVERSION}.tar.bz2 \
    http://valgrind.org/downloads/valgrind-${VALVERSION}.tar.bz2 && \
    cd /tmp && \
    tar xjf valgrind-${VALVERSION}.tar.bz2 && \
    cd valgrind-${VALVERSION} && \
    ./configure --prefix=/usr && \
    make -j 2 && \
    sudo make install && \
    cd /tmp && \
    rm -rf /tmp/valgrind-${VALVERSION} && \
    rm /tmp/valgrind-${VALVERSION}.tar.bz2

# volumedriver-core tests use arakoon & alba
# volumedriver-core need accelio library to build
RUN echo "deb http://apt.openvstorage.org unstable main" > /etc/apt/sources.list.d/ovsaptrepo.list && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated arakoon alba && \
    apt-get install -y --allow-unauthenticated libxio0 libxio-dev && \
    apt-get clean

RUN echo 'BatchMode yes' >>/etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

# some tests need jenkins to be part of at least 3 groups; make it so...
RUN usermod -a -G fuse jenkins && \
    usermod -a -G sudo jenkins && \
    usermod -a -G adm  jenkins

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord" ]
