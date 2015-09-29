#! /bin/bash
set -eux

find -name "*.h" -exec ./cplusplusify.sh '{}' \;

