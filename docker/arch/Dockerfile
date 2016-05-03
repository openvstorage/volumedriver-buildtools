FROM pritunl/archlinux:2016-04-16

# note: jenkins has uid 1001 & gid 1002 on our build hosts, this needs to be reflected in here!

ENV UID 1001

RUN groupadd -g 1002 jenkins && \
    useradd jenkins -s /bin/bash -g jenkins -m -u ${UID} -g 1002 -d /home/jenkins 

# add required packages

RUN pacman -Sy --noconfirm gcc clang valgrind \
                           boost boost-libs \
                           sudo base-devel \
                           flex bison gawk check pkg-config \
                           autoconf libtool bc gettext \
                           unzip doxygen git cmake \
                           wget openssl python2 libxml2 \
                           curl lsb-release \
                           rabbitmq libaio krb5 c-ares \
                           python2-pylint libcap lz4 \
                           \
                           # next are for volumedriver-core
                           \
                           elfutils \
                           protobuf zeromq \
                           bzip2 protobuf \
                           gflags snappy \
                           redis hiredis \
                           python2-nose fuse \
                           python2-protobuf \
                           \
                           # for running tests inside docker \
                           \
                           supervisor rpcbind \
                           \
                           # for jenkins plugin \
                           \
                           iproute2 

## extra packages not available in the default repo 
## makepkg refuses running as root, so switch to jenkins first

RUN echo 'jenkins ALL=NOPASSWD: ALL' >/etc/sudoers.d/jenkins

WORKDIR /tmp
USER jenkins

RUN git clone https://aur.archlinux.org/librabbitmq-c.git && \
    cd librabbitmq-c && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf librabbitmq-c && \
    \
    git clone https://aur.archlinux.org/loki-lib.git && \
    cd loki-lib && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf loki-lib && \
    \
    git clone https://aur.archlinux.org/lttng-ust.git && \ 
    cd lttng-ust && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf lttng-ust && \
    \
    git clone https://aur.archlinux.org/tokyocabinet.git && \
    cd tokyocabinet && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf tokyocabinet && \
    \
    git clone https://aur.archlinux.org/omniorb.git && \
    cd omniorb && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf omniorb && \
    \
    git clone https://aur.archlinux.org/omniorbpy.git && \
    cd omniorbpy && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf omniorbpy && \
    \
    git clone https://aur.archlinux.org/libibverbs.git && \
    cd libibverbs && \
    sed -i -e '/^url=/s/(//' -e '/^url=/s/)//' PKGBUILD && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf libibverbs && \
    \
    git clone https://aur.archlinux.org/librdmacm.git && \
    cd librdmacm && \
    sed -i -e '/^url=/s/(//' -e '/^url=/s/)//' PKGBUILD && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf librdmacm

USER root
WORKDIR /root

# some extra symlinks as included tests expect python2 variants as default 
RUN cd /usr/bin && \
    ln -s nosetests2 nosetests && \
    ln -s pylint2 pylint

# volumedriver-core tests use arakoon & alba
# volumedriver-core needs accelio library to build
#RUN echo "deb http://packages.cloudfounders.com/apt/ unstable/" > /etc/apt/sources.list.d/ovsaptrepo.list && \
#    apt-get update -qq && \
#    apt-get install -y --allow-unauthenticated arakoon alba && \
#    apt-get install -y --allow-unauthenticated libxio0 libxio-dev && \
#    apt-get clean

#RUN echo 'BatchMode yes' >>/etc/ssh/ssh_config && \
#    echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

# some tests need jenkins to be part of at least 3 groups; make it so...
# RUN usermod -a -G fuse jenkins && \
#     usermod -a -G sudo jenkins && \
#     usermod -a -G adm  jenkins

ADD supervisord.conf /etc/supervisord.conf
ADD docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord" ]
