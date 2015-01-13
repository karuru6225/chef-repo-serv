VAL="`df -P -h /dev/mapper/VG* | grep -e 'mapper' | awk '{ if(int($4) < 100 && $4 ~ /[0-9]*G/){ print $0; } }' | grep -e '[0-9]*G'`"

if [ "${VAL}" != "" ]; then
	echo "${VAL}" | mail -s '警告: 残り容量が100Gを下回るHDDが発生しました' root
fi

