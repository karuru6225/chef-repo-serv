#!/bin/bash

set -ex

. /etc/profile.d/rbenv.sh
berks install --path ./cookbooks

