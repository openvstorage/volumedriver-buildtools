FROM centos:7

# last update: 20160226 10:10
#  -- change previous line to trigger rebuild of docker image on jenkins; eg. when docker-entrypoint.sh changes

# add extra packages

RUN echo '%_install_langs C' >> /etc/rpm/macros && \
    yum -y install epel-release && \
    echo -e '[ovs]\nname=ovs\nbaseurl=http://yum.openvstorage.org/CentOS/7/x86_64/dists/unstable\nenabled=1\ngpgcheck=0' > /etc/yum.repos.d/ovs.repo && \
    yum -y update && \
    yum -y install sudo wget iproute \
                   gcc gcc-c++ clang boost-devel make \
                   flex bison gawk check pkgconfig autoconf libtool bc gettext gettext-devel \
                   unzip doxygen dkms pylint git mercurial cmake3 lcov \
                   openssl-devel python-devel libxml2-devel librabbitmq-devel  \
                   libaio-devel krb5-devel c-ares-devel check-devel valgrind-devel \
                   librdmacm-devel loki-lib-devel protobuf-devel lttng-ust-devel \
                   cppzmq-devel tokyocabinet-devel bzip2-devel protobuf-compiler \
                   gflags-devel snappy-devel omniORB-devel omniORB-servers python-omniORB \
                   redis hiredis-devel lz4-devel \
                   python-nose libcurl-devel \
                   rpm rpm-build fuse protobuf-python fakeroot libxio-devel \
                   uriparser-devel supervisor rpcbind libunwind glog-devel && \
    yum clean all && \
    ln -s /usr/bin/cmake3 /usr/bin/cmake && \
    rm -rf /usr/share/doc/*

# libunwind is desired by glog which in turn is (at the moment?) used by gobjfs
RUN ln -s /usr/lib64/libunwind.so.8 /usr/lib64/libunwind.so

# add jenkins user -- this is required for git to work
# note: jenkins has uid 1001 & gid 1002 on our build hosts, this needs to be reflected in here!

ENV UID 1001

RUN groupadd -g 1002 jenkins && \
    useradd jenkins -s /bin/bash -g jenkins -m -u ${UID} -g 1002 -d /home/jenkins && \
    echo "jenkins ALL=NOPASSWD: ALL" >/etc/sudoers.d/jenkins

RUN yum install -y --nogpgcheck arakoon && \
    yum clean all

## skip alba for now... (only needed for volumedriver-dynlibs-dev-rtchecked-alba)
#    yum install -y --nogpgcheck alba && \

RUN echo 'BatchMode yes' >>/etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

RUN chmod 666 /dev/fuse

# some tests need jenkins to be part of at least 3 groups; make it so...
RUN usermod -a -G adm   jenkins && \
    usermod -a -G users jenkins

# /etc/lsb-release is not present any more;
# systemd provides /etc/os-release but internal names have changed,
# add a hardcoded one for now

RUN echo -e "DISTRIB_ID=CentOS\nDISTRIB_RELEASE=7" > /etc/lsb-release

ADD supervisord.conf /etc/supervisord.conf
ADD docker-entrypoint.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord" ]
