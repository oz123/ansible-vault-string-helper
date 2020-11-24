#!/bin/bash

cat << EOF > merf.yml
signaling:
  session:
    hash_key: bla
EOF

echo 123456 > secret.txt


cat << EOF > ansible.cfg
[defaults]
vault_password_file=secret.txt
EOF

$1 --encrypt merf.yml signaling.session.hash_key glory
$1 --decrypt merf.yml signaling.session.hash_key > output

grep -q glory output || ( echo the test failed && exit 1 )

rm output ansible.cfg merf.yml secret.txt








