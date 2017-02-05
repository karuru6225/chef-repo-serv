#!/bin/bash

usage_exit() {
	echo "Usage: $0 [-u] [-y|-n] [-h] -j {chef node file} -l {debug|info|warn|error|fatal}" 1>&2
		echo "-u update cookbooks"
		echo "-y don't confirm actually run"
		echo "-n only why-run"
		echo "-h show this help"
		echo "-j {node file}"
		echo "-l {loglevel}"
		exit 1
}

BERKS=/opt/chefdk/bin/berks
CHEF=/opt/chefdk/bin/chef-solo


YES=0
UPDATE=0
NO=0
NODE=''
LEVEL=''

while getopts yuhj:l:n OPT
do
	case $OPT in
	y)	YES=1
		;;
	u)	UPDATE=1
		;;
	h)	usage_exit
		;;
	j)	NODE=$OPTARG
		;;
	l)	LEVEL=$OPTARG
		;;
	n)	NO=1
		;;
	esac
done

if [ "$NODE" = "" ]; then
	usage_exit
fi

cd "`dirname $0`/../"
if [ ! -d 'cookbooks' ]; then
	${BERKS} vendor cookbooks 
fi

if [ $UPDATE = "1" ];
then
	${BERKS} update && ${BERKS} vendor cookbooks 
fi

if [ ! $YES = "1" ]; then
	if [ "$LEVEL" = "" ]; then
		${CHEF} -c .chef/knife.rb -j "${NODE}" --why-run
	else
		${CHEF} -c .chef/knife.rb -j "${NODE}" --why-run --log_level $LEVEL
	fi
fi

if [ $NO = "1" ];then
	exit 0
fi

if [ ! $YES = "1" ]; then
	echo -n "run? (y/N): "
	read INPUT
fi

if [ "${INPUT}" = "y" -o "${INPUT}" = "Y" -o $YES = "1" ]; then
	if [ "$LEVEL" = "" ]; then
		${CHEF} -c .chef/knife.rb -j "${NODE}"
	else
		${CHEF} -c .chef/knife.rb -j "${NODE}" --log_level $LEVEL
	fi
fi

