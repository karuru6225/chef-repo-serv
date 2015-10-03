#!bin/bash

find / -name '*DS_Store*' -exec rm -f {} \; > /dev/null 2>&1

