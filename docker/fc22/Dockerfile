FROM fedora:22

# last update: 20151203 10:06
#  -- change previous line to trigger rebuild of docker image on jenkins; eg. when docker-entrypoint.sh changes

# add extra packages

RUN echo '%_install_langs C' >> /etc/rpm/macros && \
    dnf -y update && \
    dnf -y install sudo wget iproute \
                   gcc gcc-c++ clang boost-devel \
                   flex bison gawk check pkgconfig autoconf libtool bc gettext \
                   unzip doxygen dkms debhelper pylint git mercurial cmake lcov \
                   openssl-devel python-devel libxml2-devel librabbitmq-devel  \
                   libaio-devel krb5-devel c-ares-devel check-devel valgrind-devel \
                   librdmacm-devel loki-lib-devel protobuf-devel lttng-ust-devel \
                   cppzmq-devel tokyocabinet-devel bzip2-devel protobuf-compiler \
                   gflags-devel snappy-devel omniORB-devel omniORB-servers python-omniORB \
                   redis hiredis-devel libgcrypt-devel libgcrypt \
                   python-nose libcurl-devel lz4-devel \
                   rpm rpm-build fuse protobuf-python fakeroot debhelper \
                   supervisor rpcbind && \
    dnf clean all && \
    rm -rf /usr/share/doc/*

# add jenkins user -- this is required for git to work
# note: jenkins has uid 1001 & gid 1002 on our build hosts, this needs to be reflected in here!

ENV UID 1001

RUN groupadd -g 1002 jenkins && \
    useradd jenkins -s /bin/bash -g jenkins -m -u ${UID} -g 1002 -d /home/jenkins && \
    echo "jenkins ALL=NOPASSWD: ALL" >/etc/sudoers.d/jenkins

RUN echo -e '[ovs]\nname=ovs\nbaseurl=http://yum.openvstorage.org/CentOS/7/x86_64/dists/eugene-updates \nenabled=1' > /etc/yum.repos.d/ovs.repo && \
    dnf -y update && \
    dnf install -y --nogpgcheck arakoon &&\
    dnf clean all

## skip alba for now... (only needed for volumedriver-dynlibs-dev-rtchecked-alba)
#    dnf install -y --nogpgcheck alba && \

RUN echo 'BatchMode yes' >>/etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

RUN chmod 666 /dev/fuse

# some tests need jenkins to be part of at least 3 groups; make it so...
RUN usermod -a -G adm   jenkins && \
    usermod -a -G users jenkins

# /etc/lsb-release is not present any more;
# systemd provides /etc/os-release but internal names have changed,
# add a hardcoded one for now

RUN echo -e "DISTRIB_ID=Fedora\nDISTRIB_RELEASE=22" > /etc/lsb-release

ADD supervisord.conf /etc/supervisord.conf
ADD docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord" ]
