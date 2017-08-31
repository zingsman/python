#/bin/bash
LANG=en_US.UTF-8
cpu_used=$(top -n 1 | grep '%Cpu' | cut -d ',' -f4 | cut -d ' ' -f2)
disk_used=`df -h|awk -F'[ %]+' 'NR==2{print $5}'`
free_use=$(free | awk 'NR==2{print $4}')
logfile=/tmp/jiankong.log
date_time=`date +%Y%m%d-%H:%M:%S`
mail_ctr='no'
echo "脚步执行时间：$date_time" > /tmp/jiankong.log

#注意expr 返回值，满足返回1，会将1传给$?,$?显示0和$?返回值是2回事，但结果是一样的
expr $cpu_used \< 20 &> /dev/null
if [ $? -eq 0 ];then
	mail_ctr='yes'	
	echo "剩余CPU情况：$cpu_used%" >>$logfile
fi

if [ $disk_used -ge 80 ];then
	mail_ctr='yes'
	echo "磁盘分区已使用率：$disk_used%" >>$logfile
fi

if [ $free_use -le 300000 ];then
	mail_ctr='yes'
	free_all=$(free | awk 'NR==2{print $2}')
	echo "内存共: $free_all k,内存剩余：$free_use k" >>$logfile
fi

if [ $mail_ctr == 'yes' ];then
	mail -s "监控报警" 18408276935@139.com <$logfile
fi
