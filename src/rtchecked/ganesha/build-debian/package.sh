#! /bin/bash
set -eux
# Patches have been checked
. ${VOLUMEDRIVER_BUILD_CONFIGURATION?"You need to set the path to the build configuration file"}


cat <<EOF > debian/rules
#!/usr/bin/make -f
# -*- makefile -*-
# Sample debian/rules that uses debhelper.
#
# This file was originally written by Joey Hess and Craig Small.
# As a special exception, when this file is copied by dh-make into a
# dh-make output file, you may use that output file without restriction.
# This special exception was added by Craig Small in version 0.37 of dh-make.
#
# Modified to make a template file for a multi-binary package with separated
# build-arch and build-indep targets  by Bill Allombert 2001

# Uncomment this to turn on verbose mode.
#export DH_VERBOSE=1

%:
	dh \$@
# clean:

# build:

# build-arch:

# build-indep:

# binary:
# 	dh_install --sourcedir=@prefix@
# 	dh_gencontrol
# binary-arch:

# binary-indep:

override_dh_auto_clean:

override_dh_auto_build:

override_dh_auto_install:
	dh_install --sourcedir=${PREFIX}

override_dh_auto_test:

override_dh_install:

override_dh_pysupport:

override_dh_installmime:

override_dh_strip:

EOF

dpkg-buildpackage -us -uc
PACKAGE_DIR=${PREFIX}/var/packages/
mkdir -p ${PACKAGE_DIR}
cp ../*.deb ../*.changes ${PACKAGE_DIR}


# Local Variables: **
# compile-command: "./package.sh" **
# End: **
