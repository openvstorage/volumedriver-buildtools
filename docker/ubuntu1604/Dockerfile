FROM ubuntu:16.04

# note: jenkins has uid 1001 & gid 1002 on our build hosts, this needs to be reflected in here!

ENV UID 1001

# add required packages

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get dist-upgrade -y && \
    apt-get install -y gcc g++ valgrind \
                       libboost1.58-all-dev \
                       build-essential sudo libgcrypt20-dev libgcrypt20 \
                       flex bison gawk check pkg-config \
                       autoconf libtool realpath bc gettext lcov \
                       unzip doxygen dkms debhelper pylint git cmake \
                       wget libssl-dev libpython2.7-dev libpython3.5-dev libxml2-dev \
                       libcurl4-openssl-dev libc6-dbg liblz4-dev \
                       librabbitmq-dev libaio-dev libkrb5-dev libc-ares-dev \
                       libunwind8 libgoogle-glog-dev \
		       software-properties-common && \
    apt-get -y autoremove --purge && apt-get clean

# for volumedriver-core
RUN apt-get update -qq && \
    apt-get install -y pkg-create-dbgsym elfutils \
                       libloki-dev libprotobuf-dev liblttng-ust-dev libzmq3-dev \
                       libtokyocabinet-dev libbz2-dev protobuf-compiler \
                       libgflags-dev libsnappy-dev \
                       redis-server libhiredis-dev libhiredis-dbg \
                       libomniorb4-dev omniidl omniidl-python omniorb-nameserver \
                       librdmacm-dev libibverbs-dev liburiparser-dev \
                       python-nose python3-nose fuse \
                       python-protobuf python3-pip \
                       supervisor rpcbind && \
     apt-get -y autoremove --purge && apt-get clean

# No ubuntu package for it!?
RUN pip3 install python3-protobuf

RUN groupadd -g 1002 jenkins && \
    useradd jenkins -s /bin/bash -g jenkins -m -u ${UID} -g 1002 -d /home/jenkins && \
    echo "jenkins ALL=NOPASSWD: ALL" >/etc/sudoers.d/jenkins

# volumedriver-core tests use arakoon & alba
# (note: apt-get install -y --allow-unauthenticated arakoon alba does not yet work on 16.04)
# volumedriver-core needs accelio library to build
RUN echo "deb http://apt.openvstorage.com unstable main" > /etc/apt/sources.list.d/ovsaptrepo.list && \
    apt-get update -qq && \
    apt-get install -y --allow-unauthenticated \
    	    libxio0 libxio0-dbg libxio0-dbgsym \
    	    libxio-dev libxio-dev-dbgsym && \
    apt-get install -y libev4 && \
    cd /root && apt-get download --allow-unauthenticated arakoon && \
    dpkg -i --ignore-depends=libgflags2,libsnappy1 arakoon_*_amd64.deb && \
    rm arakoon_*_amd64.deb && \
    apt-get clean

RUN echo 'BatchMode yes' >>/etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

# some tests need jenkins to be part of at least 3 groups; make it so...
RUN usermod -a -G lp jenkins && \
    usermod -a -G games jenkins && \
    usermod -a -G floppy jenkins

# configure clang and friends
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" && \
    apt-get update -qq && \
    apt-get install -y clang-5.0 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-5.0 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-5.0 100 && \
    update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-5.0 100 && \
    update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-5.0 100

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord" ]
