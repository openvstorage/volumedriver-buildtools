#!/bin/bash

# this script is executed at each startup of the container
# NOTE: for jenkins, make sure to trigger a rebuild of the docker image 
#       when making changes to this file! 

set -e
set -x

# hack to make sure we have access to files in the jenkins home directory 
# the UID of jenkins in the container should match our UID on the host

if [ ${UID} -ne 1001 ]
then
  sed -i "s/:1001:/:${UID}:/" /etc/passwd
  chown ${UID} /home/jenkins /home/jenkins/.ssh
fi

# update arakoon package to latest/greatest
# NOTE: alba is not installed on FC22

dnf upgrade -y arakoon

# finally execute the command the user requested
exec "$@"
