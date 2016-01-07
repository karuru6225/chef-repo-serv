#!/bin/sh
set -ex

curl -sL https://www.chef.io/chef/install.sh | bash -s -- -P chefdk
chef gem i knife-solo
