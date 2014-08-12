#!/bin/bash

set -ex

. /etc/profile.d/rbenv.sh

BASEDIR=`pwd`

echo "BASEDIR: "${BASEDIR}
OUTPUT_SOLO=${BASEDIR}/solo.rb
[ -d /tmp/chef-solo ] || mkdir -p /tmp/chef-solo
cat<<EOF>$OUTPUT_SOLO
file_cache_path "/tmp/chef-solo"
cookbook_path ["${BASEDIR}/cookbooks","${BASEDIR}/site-cookbooks"]
data_bag_path "${BASEDIR}/data_bags"
role_path "${BASEDIR}/roles"
encrypted_data_bag_secret "${BASEDIR}/data_bag_key"
EOF

bundle install --path ./.bundle/gems --binstubs ./.bundle/bin
rbenv rehash

berks install --path ./cookbooks
rbenv rehash

