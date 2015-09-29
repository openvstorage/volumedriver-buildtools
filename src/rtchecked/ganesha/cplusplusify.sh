#! /bin/bash
set -eux

mv $1 $1.backup
cat <<EOF > $1
#ifdef __cplusplus
extern "C"
{
#endif
EOF

cat $1.backup >> $1

cat <<EOF >> $1
#ifdef __cplusplus
}
#endif
EOF
