#/bin/bash
#该脚步功能是日志分析，针对安全和服务进行日志分析，并邮件发给系统管理员
#
#  1.  该脚本需要建立工作目录 /usr/local/pengke/logfile  只需将脚本复制到该目录下 ，修改成可执行权限
#	所属用户和组都是root
#  2. 修改重要的叁数项目：
#    下面这三个项目请自行修改成您所需要的
#        email=.....     管理员邮件地址
#        basedir=..	 存放各日志的目录
#        outputall=...	 是否输出详细信息，一般管理员只需看简要信息即可
#
#  3. 可以将该脚本放到计划任务里面，每天自动分析日志，并将结果反馈给系统管理员
#    vi /etc/crontab 并且在其中新增一行：
#        10 0 * * * root /usr/local/pengke/logfile/logfile.sh > /dev/null 2>&1

#  脚本开始：
#email="18408276935@139.com"
email="root@localhost"          #输入管理员邮箱，若需要多个地址，用逗号隔开，不要有空白
basedir="/usr/local/pengke/logfile"    # 这个是 logfile.sh 这个脚本放置的目录
outputall="no"				#是否输出详细信息

#以下是脚本内容，由于好的习惯是应该用英文注释。我将中文改成了英文
#
#    0. 设定一些基本的变数内容与检验 basedir 是否存在
PATH=/usr/lib64/qt-3.3/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/home/app/bin
# PATH 变量由于需要放入计划任务中，最好重新声明，不如总会有未知错误
LANG=en
export PATH LANG 
localhostname=`hostname` 	#默认系统名为：	localhost.localdomain

# 修改使用者邮件位址！   由于默认主机名不是localhost，所以我们需要处理
temp=`echo $email | cut -d '@' -f2`
if [ "$temp" == "localhost" ]; then
        email=`echo $email | cut -d '@' -f1`\@"$localhostname"
fi

# 检查 awk 与 sed 与 egrep 是否存在
which awk > /dev/null 2>&1
if [ "$?" != "0" ]; then
        echo -e "        没有 awk 这个工具命令，本脚步 $0 将停止工作！\n\
        请先安装 awk 这个程式在您的系统中" |\
        mail -s "重要讯息回应" $email
        exit
fi
which sed > /dev/null 2>&1
if [ "$?" != "0" ]; then
        echo -e "        没有 sed 这个工具命令，本脚本 $0 将停止工作！\n\
        请先安装 sed 这个程式在您的系统中" |\
        mail -s "重要讯息回应" $email
        exit
fi
which egrep > /dev/null 2>&1
if [ "$?" != "0" ]; then
        echo -e "        没有 egrep 这个工具命令，本脚本 $0 将停止工作！\n\
        请先安装 egrep 这个程式在您的系统中" |\
        mail -s "重要讯息回应" $email
        exit
fi

# 测验 syslog 是否有启动！
temp=`ps aux | grep rsyslog| grep -v grep`
if [ "$temp" == "" ]; then
        echo -e "        没有 rsyslog 这个 daemon ，本脚本 $0 将停止工作！\n\
        请先启动 rsyslog 这个 daemon 在您的系统中" |\
        mail -s "重要讯息回应" $email
        exit
fi

# 测验暂存目录是否存在！
if [ ! -d "$basedir" ]; then
        echo -e "        没有 $basedir 这个目录，本程式 $0 将停止工作！\n\
        请先建立 $basedir 这个目录在您的系统中" |\
        mail -s "重要讯息回应" $email
        exit
fi

#####################################################################
# 0.1 设定版本相关信息，以及相关的 log files 内容表格！
lastdate="2017-03-27"
versions="Version 1.0-4"
hosthome=`hostname`
logfile="$basedir/logfile.mail"
declare -i datenu=`date +%k`     #这里是对时间的控制，超过早上6点，就是分析今天日志，不然就分析昨天的
if [ "$datenu" -le "6" ]; then
        date --date='1 day ago' +%b' '%e  > "$basedir/dattime"
else
        date +%b' '%e  > "$basedir/dattime"
fi
y="`cat $basedir/dattime`"

# 0.1.0 侦测 rsyslog.conf 这个档案是否存在  
if [ ! -f "/etc/rsyslog.conf" ]; then 
        echo -e "                重要！您的 /etc/syslog.conf 并不存在，\n\  
                所以这支 script $0 找不到登录日志相关信息，请先确定 /etc/syslog.conf 存在\n\  
                如果确定系统存在 rsyslog.conf ，不过目录并不在 /etc 底下\n\  
                可以使用连结的方式来连结到 /etc/ 底下：\n\n\  
                ln -s /full/path/rsyslog.conf /etc/rsyslog.conf \n " |\  
                mail -s "重要讯息回应" $email  
        exit 1  
fi  
 
# 0.1.1 secure file     检查许多功能是否记录到日志
log=`grep 'authpriv' /etc/rsyslog.conf | awk '{print $2}' | tail -n 1`
if [ "$log" == "" ]; then  
        echo "Sorry, You do not have the login logfile.... Stop $0" |\  
        mail -s "Important Messages" $email  
        exit  
fi  
cat $log | grep "$y" > "$basedir/securelog"  #将各种日志今天/昨天日志弄到另一个地方，y是控制时间
					#将/var/log/secure 今天的安全日志弄出来	
# 0.1.2 maillog file  
log=`grep 'mail\.\*' /etc/rsyslog.conf | awk '{print $2}' | tr -d '-'`  
if [ "$log" == "" ]; then                 # tr 能够删除指定字符串 
        echo "Sorry, You do not have the mail logfile.... Stop $0" |\  
        mail -s "Important Messages" $email  
        exit  
fi  
cat $log                | grep "$y" > "$basedir/maillog"   

# 0.1.3 messages file  
cat /var/log/messages   | grep "$y" > "$basedir/messageslog"  
  
# The following lines are detecting your PC live?  
  timeset1=`uptime | grep day`  
  timeset2=`uptime | grep min`  
  if [ "$timeset1" == "" ]; then  
        if [ "$timeset2" == "" ]; then  
                UPtime=`uptime | awk '{print $3}'`  
        else  
                UPtime=`uptime | awk '{print $3 " " $4}'`  
        fi  
  else  
        if [ "$timeset2" == "" ]; then  
                UPtime=`uptime | awk '{print $3 " " $4 " " $5}'`  
        else  
                UPtime=`uptime | awk '{print $3 " " $4 " " $5 " " $6}'`  
        fi  
  fi

#####################################################################  
# 1. 建立欢迎画面通知，以及系统的资料汇整！  
echo "################################################"  > $logfile  
echo "欢迎使用本脚本来分析你的日志信息"                 >> $logfile  
echo "本脚本目前版本为： $versions"                     >> $logfile  
echo "最後更新日期为： $lastdate"                       >> $logfile  
echo "若在您的系统中发现本脚本有问题, 欢迎与我联络！"   >> $logfile  
echo "我的邮箱: pengke2345@163.com"                      >> $logfile  
echo "################################################" >> $logfile  
echo "  "                                               >> $logfile  
echo "=============== 系统汇总 =======================" >> $logfile  
echo "核心版本  : `awk '{print $1 " " $2 " " $3 " " $4}' /proc/version`" >> $logfile  
echo -e "CPU 资讯  :\n`grep "model name" /proc/cpuinfo | awk '{print $4 " " $5 " " $6}'`" >> $logfile  
grep 'cpu MHz' /proc/cpuinfo | awk '{print "          : " $4 " MHz"}'          >> $logfile  
echo "主机名称  : `hostname`"                                 >> $logfile  
echo "统计日期  : `date +%Y/%B/%d' '%H:%M:%S' '\(' '%A' '\)`"  >> $logfile  
echo "分析的日期: `cat $basedir/dattime`"                >> $logfile  
echo "已开机期间: `echo $UPtime`"                         >> $logfile  
echo " "                                                >> $logfile  
echo "主机启用的 port 有："                                 >> $logfile 
netstat -tnl | grep '0.0.0.0:' | awk '{print $4}' | cut -d ':' -f2 | sort -n | uniq | \
	awk '{print "          : " $1}' | tee $basedir/netstat.tmp >> $logfile

# 检查 telnet 23 这个埠号
temp=`grep ' 23$' $basedir/netstat.tmp`
if [ "$temp" != "" ]; then
        echo '** 注意：您的主机有启动 telnet 这个危险的服务，除非必要，否则请关闭他！ **'  >> $logfile
fi
echo " "                                                >> $logfile
echo "主机分区使用情况："                               >> $logfile
df -h                                                   >> $logfile

#####################################################################
# 2 SSH 的安全登录资料的功能函数 (Function) 这其中包含 su 指令！
funcssh () {
        echo " "                                        >> $logfile
        echo "================= SSH 的安全登录日志汇总 =======================">> $logfile
        sshright=`cat $basedir/securelog |grep 'sshd.*Accept' | wc -l | \
                awk '{print $1}'`
        if [ "$sshright" != "0" ]; then
                echo "一共成功登入的次数： $sshright" | \
                        awk '{printf("%-26s %3d\n",$1,$2)}'        >> $logfile
                echo "帐号   来源位址 次数 "| \
                        awk '{printf("%-10s %-15s %-4s\n", $1, $2, $3)}'>> $logfile
                cat $basedir/securelog | grep 'sshd.*Accept' | \
                        sed 's/^.*for//g' | cut -d ' ' -f2,4 > "$basedir/securelogssh"
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-25s %3d\n", course, Number[course])}' \
                        $basedir/securelogssh | \
                        awk '{printf("%-10s %-15s %3d\n", $1, $2, $3)}'>> $logfile
                echo " "                                          >> $logfile
        fi
        ssherror=`cat $basedir/securelog | grep "sshd.*Fail" | wc -l | \
                awk '{print $1}'`
        if [ "$ssherror" != "0" ]; then
                echo "一共错误登入的次数: $ssherror" | \
                        awk '{printf( "%-26s %3d\n", $1, $2)}' >> $logfile
                echo "帐号   来源位址 次数 "| \
                        awk '{printf("%-10s %-15s %-4s\n", $1, $2, $3)}'>> $logfile
                cat $basedir/securelog | grep "sshd.*Fail" | \
                        sed 's/^.*for//g' | cut -d ' ' -f2,4 \
                        >  "$basedir/securelogsshno"
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-25s %3d\n", course, Number[course])}' \
                        $basedir/securelogsshno | \
                        awk '{printf("%-10s %-15s %3d\n", $1, $2, $3)}' >> $logfile
                echo " "                           >> $logfile
        fi
        cat $basedir/securelog | grep "su"|grep "open"|grep "root"| \
                sed 's/^.*by//g' |awk '{print $1}'|sort   >  $basedir/securesu
        sshsu=`wc -l $basedir/securesu | awk '{print $1}'`
        if [ "$sshsu" != "0" ]; then
                echo "以 su 转换成 root 的使用者及次数"                >> $logfile
                echo "帐号   次数 "| \
                        awk '{printf("%-26s %-4s\n", $1, $2)}'      >> $logfile
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-25s %3d\n", course, Number[course])}' \
                        $basedir/securesu | \
                        awk '{printf("%-25s %3d\n", $1, $2)}'       >> $logfile
                echo " "                                    >> $logfile
        fi
        if [ "$sshright" == "0" ] && [ "$ssherror" == "0" ]; then
                echo "今日没有使用 SSH 的纪录"              >> $logfile
                echo " "                                     >> $logfile
        fi
}

#####################################################################
# 3 POP3 的登录资料的功能函数 (Function) ！
funcpop3 () {
        echo "================= POP3 的登录档资讯汇整 ======================"  >> $logfile
        pop3right=`cat $basedir/maillog|grep "pop3.*Login user" |  wc -l | \
                awk '{print $1}'`
        if [ "$pop3right" != "0" ]; then
                echo "POP3登入次数: $pop3right" | \
                        awk '{printf( "%-40s %4d\n", $1, $2)}'           >> $logfile
                echo "帐号   来源位址 次数 "|  \
                        awk '{printf("%-15s %-25s %-4s\n", $1, $2, $3)}' >> $logfile
                cat $basedir/maillog | grep "pop3.*Login user" |\
                        sed 's/^.*user=//g' | awk '{print $1}' \
                        > $basedir/maillogpop-1
                cat $basedir/maillog | grep "pop3.*Login user" |\
                        sed 's/^.*host=//g' | sed 's/^.*\[//g' |\
                        sed 's/\].*$//g' | awk '{print $1}' \
                        > $basedir/maillogpop-2
                paste $basedir/maillogpop-1 $basedir/maillogpop-2 \
                        > $basedir/maillogpop
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-35s %4d\n", course, Number[course])}' \
                        $basedir/maillogpop   | \
                        awk '{printf("%-15s %-25s %3d\n", $1, $2, $3)}'>> $logfile
                echo " "                                              >> $logfile
        fi
        pop3error=`cat $basedir/messageslog|grep "pop3.*Login fail"| \
                 wc -l |  awk '{print $1}'`
        if [ "$pop3error" != "0" ]; then
                echo "POP3错误登入次数: $pop3error" | \
                        awk '{printf( "%-40s %4d\n", $1, $2)}'        >> $logfile
                echo "帐号   来源位址 次数 "|  \
                        awk '{printf("%-15s %-25s %-4s\n", $1, $2, $3)}'>> $logfile
                cat $basedir/messageslog | grep "pop3.*Login fail" |\
                        sed 's/^.*user=//g' | awk '{print $1}' \
                        > $basedir/maillogpopno-1
                cat $basedir/messageslog | grep "pop3.*Login fail" |\
                        sed 's/^.*host=//g' | sed 's/^.*\[//g' |\
                        sed 's/\].*$//g' | awk '{print $1}' \
                        > $basedir/maillogpopno-2
                paste $basedir/maillogpopno-1 $basedir/maillogpopno-2 \
                        > $basedir/maillogpopno
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-35s %4d\n", course, Number[course])}' \
                        $basedir/maillogpopno | \
                        awk '{printf("%-15s %-25s %3d\n", $1, $2, $3)}'   >> $logfile
                        echo " "                                     >> $logfile
        fi
        if [ "$pop3error" == "0" ] && [ "$pop3right" == "0" ]; then
                echo "今日没有使用 POP3 的纪录"                     >> $logfile
                echo " "                                             >> $logfile
        fi
}


#####################################################################
# 4 Wu-FTP 的登录资料的功能函数 (Function) ！
#ftp服务器日志有很多种类型，生不生成该类型日志需要配置
funcwuftp () {
        echo "================= FTP 的登录档资讯汇整 =======================" >> $logfile
        wuftpright=`cat $basedir/messageslog|grep "FTP LOGIN" | wc -l | \
                awk '{print $1}'`
        if [ "$wuftpright" != "0" ]; then
                echo "Wu-FTP-成功登入次数: $wuftpright" | \
                        awk '{printf( "%-41s %3d\n", $1, $2)}'     >> $logfile
                echo "帐号   来源位址 次数 "| \
                        awk '{printf("%-15s %-25s %-4s\n", $1, $2, $3)}'  >> $logfile
                cat $basedir/messageslog | grep "FTP LOGIN" | \
                        sed 's/^.*,//g' | awk '{print $1}' \
                        > $basedir/messageswuftp-1
                cat $basedir/messageslog | grep "FTP LOGIN" | \
                        sed 's/^.*FROM//g' | awk '{print $1}' \
                        > $basedir/messageswuftp-2
                paste $basedir/messageswuftp-1 $basedir/messageswuftp-2 \
                        > $basedir/messageswuftp
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-35s %3d\n", course, Number[course])}' \
                        $basedir/messageswuftp | \
                        awk '{printf("%-15s %-25s %3d\n", $1, $2, $3)}' >> $logfile
                echo " "                                        >> $logfile
        fi
        wuftperror=`cat  $basedir/messageslog|grep "ftp.*auth.*fail" |\
                wc -l| awk '{print $1}'`
        if [ "$wuftperror" != "0" ]; then
                echo "Wu-FTP-错误登入次数: $wuftperror" | \
                        awk '{printf( "%-41s %3d\n", $1, $2)}'  >> $logfile
                cat $basedir/messageslog |grep "ftp.*auth.*fail" | \
                        sed 's/^.*\buser=//g' | awk '{print $1}' \
                        > $basedir/messageswuftpno.1.tmp
                awk -v mon=`date +%b` '{ if( $1 != mon ) print $1; 
                        if( $1 == mon ) print "UnknowUser" }' \
                        $basedir/messageswuftpno.1.tmp  \
                        > $basedir/messageswuftpno.1
                cat $basedir/messageslog |grep "ftp.*auth.*fail" | \
                        sed 's/^.*rhost=//g' | awk '{print $1}' \
                        > $basedir/messageswuftpno.2
                paste $basedir/messageswuftpno.1 $basedir/messageswuftpno.2 \
                        > $basedir/messageswuftpno
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-35s %3d\n", course, Number[course])}' \
                        $basedir/messageswuftpno | \
                        awk '{printf("%-15s %-25s %3d\n", $1, $2, $3)}' >> $logfile
                echo " "                                    >> $logfile
        fi
        if [ "$wuftpright" == "0" ] && [ "$wuftperror" == "0" ]; then
                echo "今日没有使用 Wu FTP 的纪录"           >> $logfile
                echo " "                                    >> $logfile
        fi
}

#####################################################################
# 6 Sendmail 的登录资料的功能函数 (Function) ！若你服务器没有邮件服务器，就没有该日志
funcsendmail () {
        echo "================= Sednamil 的登录档资讯汇整 ==================" >> $logfile
        auth=no
        [ -f /usr/lib/sasl/Sendmail.conf ]  && auth=yes
        [ -f /usr/lib/sasl2/Sendmail.conf ] && auth=yes
        if [ "$auth" == "yes" ]; then
                echo "您的主机有进行 SASL 身份认证的功能"        >> $logfile
        else
                echo "您的主机没有进行 SASL 身份认证的功能"       >> $logfile
        fi
        echo " "                                         >> $logfile
        sendmailright=`cat $basedir/maillog|grep "sendmail.*from.*class" | \
                 wc -l | awk '{print $1}'`
        if [ "$sendmailright" != "0" ]; then
                echo "SMTP共受信次数: $sendmailright " | \
                        awk '{printf( "%-21s %10d\n", $1, $2)}'   >> $logfile
                cat $basedir/maillog |grep "sendmail.*from.*class" |\
                        sed 's/^.*size=//g' | awk -F ',' '{print $1}' \
                        > $basedir/maillogsendmailall
                mailsize=`awk '{ smtp = smtp + $1 } END {print smtp/1024}' \
                        $basedir/maillogsendmailall`
                echo "共收受信件的容量大小: $mailsize KBytes" | \
                        awk '{printf( "%-20s %10d %-8s\n",$1, $2, $3)}'>> $logfile
                echo " "                                             >> $logfile
        fi
        echo " " > $basedir/maillogsendmaillocal-1
        echo " " > $basedir/maillogsendmaillocal-2
        echo " " > $basedir/maillogsendmaillocal-3
        cat $basedir/maillog |grep "sendmail.*from.*mech=LOGIN" | \
                sed 's/^.*from=//g' |  awk -F ',' '{print $1}' \
                >> $basedir/maillogsendmaillocal-1
        cat $basedir/maillog |grep "sendmail.*from.*mech=LOGIN" | \
                sed 's/^.*relay=//g' |  awk '{print $1}' |\
                awk '{print $1 ","}' \
                >> $basedir/maillogsendmaillocal-2
        cat $basedir/maillog |grep "sendmail.*from.*mech=LOGIN" | \
                sed 's/^.*size=//g' |  awk -F ',' '{print $1}' \
                >> $basedir/maillogsendmaillocal-3
        cat $basedir/maillog |grep "sendmail.*from.*localhost" | \
                sed 's/^.*from=//g' |  awk -F ',' '{print $1}' \
                >> $basedir/maillogsendmaillocal-1
        cat $basedir/maillog |grep "sendmail.*from.*localhost" | \
                sed 's/^.*relay=//g' |  awk '{print $1 ","}' \
                >> $basedir/maillogsendmaillocal-2
        cat $basedir/maillog |grep "sendmail.*from.*localhost" | \
                sed 's/^.*size=//g' |  awk -F ',' '{print $1}' \
                >> $basedir/maillogsendmaillocal-3
        paste $basedir/maillogsendmaillocal-1  \
                $basedir/maillogsendmaillocal-2 \
                > $basedir/maillogsendmaillocal-4
        paste $basedir/maillogsendmaillocal-4  \
                $basedir/maillogsendmaillocal-3 \
                > $basedir/maillogsendmaillocal
        declare -i sendmaillocal=`cat $basedir/maillogsendmaillocal| \
                wc -l| awk '{print $1}'`
        sendmaillocal=$sendmaillocal-1
        if [ "$sendmaillocal" != "0" ]; then
                echo "SMTP本机登入次数: $sendmaillocal" | \
                        awk '{printf( "%-21s %10d\n", $1, $2)}'   >> $logfile
                mailsize=`awk '{ smtp = smtp + $1 } END {print smtp/1024}' \
                        $basedir/maillogsendmaillocal-3`
                echo "共收受信件的容量大小: $mailsize KBytes" | \
                        awk '{printf( "%-20s %10d %-8s\n",$1, $2, $3)}'  >> $logfile
                echo " "                                            >> $logfile
                echo "帐号   来源位址 次数 信件容量(KBytes)"| \
                awk '{printf("%-35s %-35s %-6s %-10s\n", $1, $2, $3, $4)}'>> $logfile
                awk '{FS=","}{if(NR>=2) for( i=1; i<2; i++ ) (sizes[$i]=sizes[$i]+$2/1024) && Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-80s %-10s %-10s\n", course, Number[course], sizes[course])}' \
                        $basedir/maillogsendmaillocal | \
                        awk '{printf("%-35s %-35s %4d %10d\n", $1, $2, $3, $4)}' >> $logfile
                echo " "                            >> $logfile
        fi
        if [ -x /usr/bin/mailq ] ; then
                mailq > $basedir/mailq
                declare -i mailq=`wc -l $basedir/mailq | awk '{print $1}'`
                if [ "$mailq" -ge "3" ] ; then
                        echo "放在邮件伫列当中的信件资讯"     >> $logfile
                        cat $basedir/mailq                       >> $logfile
                        echo " "                             >> $logfile
                fi
        fi
        sendmailerror=`cat $basedir/maillog | grep "sendmail.*reject=" | wc -l | \
                awk '{print $1}'`
        if [ "$sendmailerror" != "0" ]; then
                echo "错误的邮件资讯：提供系馆管理员处理用"           >> $logfile
                cat $basedir/maillog | grep "sendmail.*reject="       >> $logfile
                echo " "                                            >> $logfile
        fi
        if [ "$sendmailright" == "0" ] && [ "$sendmaillocal" == "0" ] \
                && [ "$sendmailerror" == "0" ]; then
                echo "今日没有 sendmail 的相关资讯"                >> $logfile
                echo " "                                          >> $logfile
        fi
}

#####################################################################
# 7 postfix 的登录资料的功能函数 (Function) ！
#功能：是否加密认证，邮件占用空间大小，收信次数。客户端收信，邮箱登录信息，延迟发邮件和接受登
funcpost () {
        echo "================= Postfix 的登录档资讯汇整 ===================" >> $logfile
        auth=no
        [ -f /usr/lib/sasl/smtpd.conf ]  && auth=yes
        [ -f /usr/lib/sasl2/smtpd.conf ] && auth=yes
        if [ "$auth" == "yes" ]; then
                echo "您的主机有进行 SASL 身份认证的功能"         >> $logfile
        else
                echo "您的主机没有进行 SASL 身份认证的功能"      >> $logfile
        fi
        echo " "                                              >> $logfile
        postall=`cat $basedir/maillog | grep 'postfix.*qmgr.*from.*size' | \
                wc -l | awk '{print $1}'`
        if [ "$postall" != "0" ]; then
                echo "SMTP共收信次数: $postall " | \
                        awk '{printf( "%-21s %10d\n", $1, $2)}'       >> $logfile
                mailsize=`cat $basedir/maillog | \
                        grep 'postfix.*qmgr.*from.*size' | \
                        sed 's/^.*size=//g' | awk -F ',' '{print $1}' | \
                        awk '{ smtp = smtp + $1 } END {print smtp/1024}'`
                echo "共收受信件的容量大小: $mailsize KBytes" | \
                        awk '{printf( "%-20s %10d %-8s\n",$1, $2, $3)}'>> $logfile
                echo " "                                  >> $logfile
        fi
        cat $basedir/maillog | grep "postfix.*qmgr.*from.*size" |\
                sed 's/^.*\]://g' | sed 's/:.*$//g' | awk '{print $1}' \
                > $basedir/postid
        cat $basedir/maillog | grep "postfix.*smtpd.*client=" \
                > $basedir/postlog-host
        cat $basedir/maillog | grep "postfix.*qmgr.*from.*size" \
                > $basedir/postlog-email-size
        cat $basedir/maillog | grep "postfix.*smtpd.*LOGIN" \
                > $basedir/postlog-auth
        cat $basedir/maillog | grep "postfix.*smtp\[.*to.*relay.*sent" \
                > $basedir/postlog-send
        cat $basedir/maillog | grep "postfix.*smtp\[.*to.*relay" |\
                grep -v 'sent' > $basedir/postlog-nosend
        touch $basedir/postid
        postid=`cat $basedir/postid`
        [ -f $basedir/postlog.1 ] && rm $basedir/postlog.1
        for mailid in $postid
        do
                posthost=`cat $basedir/postlog-host| grep "$mailid" |\
                        sed 's/^.*: client//g'|sed 's/^.*\[//g' |\
                        sed 's/\].*//g' | head -n 1`
                        if [ "$posthost" == "" ]; then
                                posthost="unknow"
                        fi
                postemail=`cat $basedir/postlog-email-size |\
                        grep "$mailid" |\
                        sed 's/^.*from=<//g' | sed 's/>.*$//g' |\
                        head -n 1`
                        if [ "$postemail" == "" ]; then
                                postemail="unknow"
                        fi
                postsend=`cat $basedir/postlog-send |\
                        grep "$mailid"|head -n 1`
                postnosend=`cat $basedir/postlog-nosend |\
                        grep "$mailid"|head -n 1`
                        if [ "$postsend" == "" ] && [ "$postnosend" == "" ]; then
                                postsend="local"
                        elif [ "$postsend" == "" ] && [ "$postnosend" != "" ]; then
                                postsend="deffer"
                        else
                                postsend="send"
                        fi
                postauth=`cat $basedir/postlog-auth |\
                        grep "$mailid" |head -n 1`
                        if [ "$postauth" == "" ]; then
                                postauth="noauth"
                        else
                                postauth="auth"
                        fi
                postauthname=`cat $basedir/postlog-auth |\
                        grep "$mailid" | sed 's/^.*username=//g'|\
                        head -n 1`
                        if [ "$postauthname" == "" ]; then
                                postauthname="noauth"
                        fi
                postsize=`cat $basedir/postlog-email-size |\
                        grep "$mailid" |\
                        sed 's/^.*size=//g' | sed 's/,.*$//g' |\
                        head -n 1`
                        if [ "$postsize" == "" ]; then
                                postsize="0"
                        fi
                echo $posthost $postemail $postsend $postauth $postauthname "," $postsize \
                        >> $basedir/postlog.1
        done
        cat $basedir/postlog.1 | sort | uniq > $basedir/postlog
        touch $basedir/postlog
        # 1. 认证者寄信
        postfix_auth="0"
        if [ "$auth" == "yes" ]; then
                cat $basedir/postlog | egrep '\bauth\b' |\
                        awk '{FS=","}{if(NR>=2) for( i=1; i<2; i++ ) (sizes[$i]=sizes[$i]+$2/1024) && Number[$i]++ };
                        END{ for( course in Number )
                        printf( "%-80s %-10s %-10s\n", course, Number[course], sizes[course])}'\
                        > $basedir/postfix-auth
                postfix_auth=`cat $basedir/postfix-auth | grep 'send' |\
                        wc -l| awk '{print $1}'`
                if [ "$postfix_auth" != "0" ]; then
                        echo "经过认证者寄出本机(转信)"        >> $logfile
                        echo "帐号   来源位址 次数 信件容量(KBytes)"| \
                        awk '{printf("%-25s %-20s %-6s %-10s\n", $1, $2, $3, $4)}'  >> $logfile
                        cat $basedir/postfix-auth | grep 'send' |\
                        awk '{printf("%-25s %-20s %4d %10d\n", $5, $1, $6, $7)}' |\
                                                         >> $logfile
                        echo " "                                       >> $logfile
                fi
                postfix_auth=`cat $basedir/postfix-auth | grep 'local' |\
                        wc -l| awk '{print $1}'`
                if [ "$postfix_auth" != "0" ]; then
                        echo "经过认证者寄入本机"                   >> $logfile
                        echo "帐号   来源位址 次数 信件容量(KBytes)"| \
                        awk '{printf("%-25s %-20s %-6s %-10s\n", $1, $2, $3, $4)}'  >> $logfile
                        cat $basedir/postfix-auth | grep 'local' |\
                        awk '{printf("%-25s %-20s %4d %10d\n", $5, $1, $6, $7)}' |\
                                                         >> $logfile
                        echo " "                                     >> $logfile
                fi
        fi
        # 2.延迟寄出的信件 deferred
        cat $basedir/maillog | grep 'deferred' | awk '{print $6 }' | \
                sort | uniq -c > $basedir/postfix-defer
        defer=`cat $basedir/postfix-defer | awk '{print $1}'`
        if [ "$defer" != "" ]; then
        declare -i I
        I=0
        for II in $defer
        do
                I=$I+1
                defernum[$I]=$II
        done
        defer=`cat $basedir/postfix-defer | awk '{print $2}'`
        I=0
        echo "信件延迟寄出的问题分析"                          >> $logfile
        echo "来源帐号" "目标帐号" "次数" "信件容量(bytes)" | \
        awk '{printf("%-32s %-32s %4s %16s\n",$1,$2,$3,$4)}'       >> $logfile
        for II in $defer
        do
                I=$I+1
                defertmp=`cat $basedir/maillog | grep $II | grep 'from' |\
                         head -n 1`
                deferfrom=`echo $defertmp | sed 's/^.*from\=//g' | \
                        sed 's/,.*$//g' | sed 's/<//g' | sed 's/>//g'`
                defersize[$I]=`echo $defertmp | sed 's/^.*size\=//g' |\
                        sed 's/,.*$//g'`
                defertmp=`cat $basedir/maillog | grep $II | grep 'to' | \
                        grep defer |head -n 1`
                deferto=`echo $defertmp | sed 's/^.*to\=//g' | \
                        sed 's/,.*$//g' | sed 's/<//g' | sed 's/>//g'`
                deferreason=`echo $defertmp | cut -d '(' -f2 | sed 's/)//g'`
                echo $deferfrom $deferto ${defernum[$I]} ${defersize[$I]}| \
                awk '{printf("%-32s %-32s %4d %5d\n",$1,$2,$3,$4/1024)}' >> $logfile
                echo "    延迟原因 ==> " $deferreason             >> $logfile
        done
        echo " "                                                  >> $logfile
        fi
        # 3. 十大信件
        postfix_10=`cat $basedir/postlog | wc -l | awk '{print $1}'`
        if [ "$postfix_10" != "0" ]; then 
                echo "十封最大容量的邮件"                          >> $logfile
                echo "帐号   来源位址 邮件进出 信件容量(KBytes)"| \
                awk '{printf("%-35s %-20s %-8s %-10s\n", $1, $2, $3, $4)}' >> $logfile
                cat $basedir/postlog |\
                awk '{printf("%-35s %-20s %-8s %10d\n", $2, $1, $3, $7/1024)}' |\
                head -n 10                           >> $logfile
                echo " "                                          >> $logfile
        fi
        if [ -x /usr/bin/mailq ] ; then
                mailq > $basedir/mailq
                declare -i mailq=`wc -l $basedir/mailq | awk '{print $1}'`
                if [ "$mailq" -ge "3" ] ; then
                        echo "放在邮件伫列当中的信件资讯"             >> $logfile
                        cat $basedir/mailq                        >> $logfile
                        echo " "                                 >> $logfile
                fi
        fi
        if [ "$postfix_auth" == "0" ] && [ "$postfix_local" == "0" ] && [ "$postfix_10" == "0" ];then
                echo "今日没有 Postfix 的相关资讯"            >> $logfile
        fi
        cat $basedir/maillog | grep 'postfix.*smtpd.*reject.*deni*' \
                > $basedir/postfix-nodeny
        postfix_nodeny=`wc -l $basedir/postfix-nodeny | awk '{print $1}'`
        if [ "$postfix_nodeny" != "0" ]; then
                echo "被拒绝寄出的邮件资料"                        >> $logfile
                sed 's/^.* from //g' $basedir/postfix-nodeny | \
                        sed 's/://g' | sort| \
                        awk '{print "From: "$1 "\n"  "To:   "$3 "\n"}'  >> $logfile
                echo " "                                            >> $logfile
        fi
        cat $basedir/maillog | grep 'postfix.*smtpd.*SASL.*authen.*fail' \
                > $basedir/postfix-noauth
        postfix_noauth=`wc -l $basedir/postfix-noauth| awk '{print $1}'`
        if [ "$postfix_noauth" != "0" ]; then
                echo "认证失败的纪录资料"                       >> $logfile
                cat $basedir/postfix-noauth                     >> $logfile
                echo " "                                          >> $logfile
        fi
        cat $basedir/maillog | egrep "(discard|reject: h|reject: b)" \
                > $basedir/postfix-filtering
        postfix_filtering=`wc -l $basedir/postfix-filtering | awk '{print $1}'`
        if [ "$postfix_filtering" != "0" ]; then
                echo "寄入本机时由於不合规则而被过滤掉的邮件"        >> $logfile
                echo "被过滤掉的邮件数量 : $postfix_filtering "      >> $logfile
                sed 's/^.*discard: //g' $basedir/postfix-filtering|\
                        sed 's/proto.*$//g'|sed 's/from=.* to/to/g'|\
                        sed 's/ from /\~/g'|sed 's/ to=/\~/g'|\
                        awk '{FS="~"}{print "From: "$2 "\n" "To:   "$3 "\n" "Mode: "$1 "\n"}'\
                                                                   >> $logfile
                echo " "                                           >> $logfile
        fi
}

#####################################################################
# 8 Proftp 的登录资料的功能函数 (Function) ！
funcproftp () {
        echo "================= Proftp 的登录档资讯汇整 ====================" >> $logfile
        proftpright=`cat $basedir/securelog |grep "proftp.*USER.*Login succes" |\
                 wc -l |  awk '{print $1}'`
        if [ "$proftpright" != "0" ]; then
                echo "Pro-FTP-成功登入次数: $proftpright" | \
                        awk '{printf( "\%-41s \%3d\n", $1, $2)}'     >> $logfile
                echo "帐号   来源位址 次数 "| \
                        awk '{printf("\%-15s \%-25s \%-4s\n", $1, $2, $3)}'>> $logfile
                cat $basedir/securelog | grep "proftp.*USER.*Login succes" | \
                        sed 's/^.*USER//g' | sed 's/:.*$//g' |\
                        awk '{print $1}'  > $basedir/securelogproftp-1
                cat $basedir/securelog | grep "proftp.*USER.*Login succes" | \
                        sed 's/^.*\[//g' | sed 's/^.*\[//g' |\
                        sed 's/\].*$//g' | awk '{print $1}' \
                        > $basedir/securelogproftp-2
                paste $basedir/securelogproftp-1 $basedir/securelogproftp-2 \
                        > $basedir/securelogproftp
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "\%-35s \%3d\n", course, Number[course])}' \
                        $basedir/securelogproftp | \
                        awk '{printf("\%-15s \%-25s \%3d\n", $1, $2, $3)}'  >> $logfile
                echo " "                                 >> $logfile
        fi
        proftperr1=`cat $basedir/securelog |grep "proftp.*USER.*Login fail" |\
                 wc -l |  awk '{print $1}'`
        if [ "$proftperr1" != "0" ]; then
                echo "Pro-FTP-错误登入次数: $proftperr1" | \
                        awk '{printf( "\%-41s \%3d\n", $1, $2)}'  >> $logfile
                echo "帐号   来源位址 次数 "| \
                        awk '{printf("\%-15s \%-25s \%-4s\n", $1, $2, $3)}'  >> $logfile
                cat $basedir/securelog | grep "proftp.*USER.*Login fail" | \
                        sed 's/^.*USER//g' | \
                        awk '{print $1}'  > $basedir/securelogproftpe1-1
                cat $basedir/securelog | grep "proftp.*USER.*Login fail" | \
                        sed 's/^.*\[//g' | sed 's/^.*\[//g' |\
                        sed 's/\].*$//g' | awk '{print $1}' \
                        > $basedir/securelogproftpe1-2
                paste $basedir/securelogproftpe1-1 $basedir/securelogproftpe1-2 \
                        > $basedir/securelogproftpe1
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "\%-35s \%3d\n", course, Number[course])}' \
                        $basedir/securelogproftpe1 | \
                        awk '{printf("\%-15s \%-25s \%3d\n", $1, $2, $3)}' >> $logfile
                echo " "                                             >> $logfile
        fi
        proftperr2=`cat $basedir/securelog |grep "proftp.*USER.*no such user" |\
                 wc -l |  awk '{print $1}'`
        if [ "$proftperr2" != "0" ]; then
                echo "Pro-FTP-错误登入次数: $proftperr2" | \
                        awk '{printf( "\%-41s \%3d\n", $1, $2)}'   >> $logfile
                echo "帐号   来源位址 次数 "| \
                        awk '{printf("\%-15s \%-25s \%-4s\n", $1, $2, $3)}'  >> $logfile
                cat $basedir/securelog | grep "proftp.*USER.*no such user" | \
                        sed 's/^.*USER//g' | sed 's/:.*$//g' |\
                        awk '{print $1}'  > $basedir/securelogproftpe2-1
                cat $basedir/securelog | grep "proftp.*USER.*no such user" | \
                        sed 's/^.*\[//g' | sed 's/^.*\[//g' |\
                        sed 's/\].*$//g' | awk '{print $1}' \
                        > $basedir/securelogproftpe2-2
                paste $basedir/securelogproftpe2-1 $basedir/securelogproftpe2-2 \
                        > $basedir/securelogproftpe2
                /bin/awk '{ for( i=0; i<1; i++ ) Number[$i]++ };
                        END{ for( course in Number )
                        printf( "\%-35s \%3d\n", course, Number[course])}' \
                        $basedir/securelogproftpe2  | \
                        awk '{printf("\%-15s \%-25s \%3d\n", $1, $2, $3)}' >> $logfile
                echo " "                                             >> $logfile
        fi
        if [ "$proftpright" == "0" ] && [ "$proftperr1" == "0" ] && [ "$proftperr2" == "0" ]; then
                echo "今日没有 Proftp 的相关资讯"               >> $logfile
                echo " "                                      >> $logfile
        fi
}


#####################################################################
# 10 开始测试需要进行的模组！
input=`grep "22" $basedir/netstat.tmp`
if [ "$input" != "" ]; then
        funcssh
fi
input=`grep "21" $basedir/netstat.tmp`
if [ "$input" != "" ]; then
        funcwuftp
        funcproftp
fi
input=`grep "110" $basedir/netstat.tmp`
if [ "$input" != "" ]; then
        funcpop3
fi
input=`grep "25" $basedir/netstat.tmp`
if [ "$input" != "" ]; then
        sendmailtest=`ps aux|grep sendmail| grep -v 'grep'`
        if [ "$sendmailtest" != "" ] ;  then
                funcsendmail
        else
                funcpost
        fi
        procmail=`/bin/ls /var/log| grep procmail| head -n 1`
        if [ "$procmail" != "" ] ; then
                funcprocmail
        fi
fi


#####################################################################
# 11. 全部的资讯列出给人瞧一瞧！
if [ "$outputall" == "yes" ] || [ "$outputall" == "YES" ] ; then
        echo "  "                                           >> $logfile
        echo "================= 全部的登录档资讯汇整 =======================">> $logfile
        echo "1. 重要的日志分析文件 ( Secure file )"         >> $logfile
        echo " "                                             >> $logfile
        echo "2. 使用 last 这个指令输出的结果"               >> $logfile
        last -20                                             >> $logfile
        echo " "                                             >> $logfile
        echo "3. 将特重要的 /var/log/messages 列出来瞧瞧！"  >> $logfile
        cat $basedir/messageslog | egrep -vi '\bcrond\['     >> $logfile
fi
# At last! we send this mail to you!
mail -s "$hosthome 的登录档分析结果" $email < $logfile


