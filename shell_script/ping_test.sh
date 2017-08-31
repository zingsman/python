#/bin/bash
ip='192.168.54.'
for a in $(seq 1 23)
do
	ping -c 1 -w 3 $ip$a &> /dev/null
	if [ $? == 0 ];then
	echo "$ip$a is OK!"
	else
	echo -e "\e[1;31m $ip$a is NO! \e[0m"
	fi
done
