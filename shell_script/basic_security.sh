#/bin/bash
echo -e "------------my_basic_securitylog_$(date +%Y_%m_%d_%T)-------------" >> /root/Script/my_log/basic_security.log

echo -e "\e[1;31m 0 backup import system file\e[0m" | tee -a /root/Script/my_log/basic_security.log
#备份系统重要的文件,备份目录为/back/basic_security/ 目录下
[ ! -d "/backup/basic_security/etc" ] && mkdir -p /backup/basic_security/etc  
cp -p /etc/sysctl.conf /backup/basic_security/etc/sysctl.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/login.defs /backup/basic_security/etc/login.defs.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/passwd /backup/basic_security/etc/passwd.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/shadow /backup/basic_security/etc/shadow.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/group /backup/basic_security/etc/group.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/gshadow /backup/basic_security/etc/gshadow.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/pam.d/system-auth /backup/basic_security/etc/pam.d_system-auth.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/profile /backup/basic_security/etc/profile.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/bashrc /backup/basic_security/etc/bashrc.confbak_$(date +%Y_%m_%d_%T) && \
cp -p /etc/inittab /backup/basic_security/etc/inittab.confbak_$(date +%Y_%m_%d_%T) 
if [[ $? != 0 ]]
then
	echo "Warning! backup failure,you can view log:/root/Script/my_log/basic_security.log and please manally do it."
	exit 1
fi

echo -e "\e[1;31m 1 password complexity\e[0m" | tee -a /root/Script/my_log/basic_security.log
#设置口令策略符合复杂度要求

sed  -i 's/^password.*requisite.*pam_cracklib\.so.*/password    requisite    pam_cracklib.so try_first_pass retry=3 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 minclass=2 minlen=6/g' /etc/pam.d/system-auth

echo -e "\e[1;31m 2 password valid time\e[0m" | tee -a /root/Script/my_log/basic_security.log
#检查口令生存周期要求
sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN'$'\t''8/'  /etc/login.defs && \
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS'$'\t''90/' /etc/login.defs

echo -e "\e[1;31m 3 password lock policy\e[0m" | tee -a /root/Script/my_log/basic_security.log
#检查口令锁定策略
sed -i '2i\auth required pam_tally2.so deny=6 onerr=fail no_magic_root unlock_time=120' /etc/pam.d/system-auth

echo -e "\e[1;31m 4 password try times\e[0m" | tee -a /root/Script/my_log/basic_security.log
#检查口令重复次数限制
sed -i 's/^password.*sufficient.*pam_unix\.so.*/& remember=5/g'  /etc/pam.d/system-auth

echo -e "\e[1;31m 5 system service down\e[0m" | tee -a /root/Script/my_log/basic_security.log
#关闭不必要的服务，linux桌面版最小安装，启用的服务都是最少的。不过也有一些需要关闭
#若有不需要的服务，只需在这里添加即可

#servicename="amanda chargen chargen-udp cups cups-lpd daytime daytime-udp echo echo-udp eklogin ekrb5-telnet finger gssftp imap imaps ipop2 ipop3 klogin krb5-telnet kshell ktalk ntalk rexec rlogin rsh rsync talk tcpmux-server telnet tftp time-dgram time-stream uucp \
#sendmail lp rpc snmpdx keyserv nscd volmgt uucp dmi autoinstall"

servicename="cups cups-lpd"
for i in $servicename
do
	chkconfig $i off &>> /root/Script/my_log/basic_security.log
	service $i stop &>> /root/Script/my_log/basic_security.log
done

echo -e "\e[1;31m 6 secure log record\e[0m" | tee -a /root/Script/my_log/basic_security.log
#检查是否记录su日志和检查是否记录安全事件日志
#把认证（等级）的记录日志到其他文件--默认这些已经记录了。
#若有需要，管理员想单独记在文件目录中。可能会需要配置日志轮替
#sed -i '$a authpriv.*   /var/log/authlog' /etc/rsyslog.conf
#sed -i '$a *.err;auth.info        /var/adm/messages'  /etc/rsyslog.conf
#/etc/init.d/rsyslog restart

echo -e "\e[1;31m 7 ban 'ctrl+alt+delete' \e[0m" | tee -a /root/Script/my_log/basic_security.log
#禁止ctrl+alt+del,因为这个组合键能使系统重启
#centos 5 版本
#sed -i "s/^ca::ctrlaltdel/#ca::ctrlaltdel/" /etc/inittab
#centos 6 版本
sed -i 's/^exec \/sbin\/shutdown -r now "Control-Alt-Delete pressed"/#exec \/sbin\/shutdown -r now "Control-Alt-Delete pressed"/' /etc/init/control-alt-delete.conf

echo -e "\e[1;31m 8 ntp_service \e[0m" | tee -a /root/Script/my_log/basic_security.log
#由于服务器ntp服务一般来说是有的，但是ntp服务地址不一样，由于在广州，我选择桂林ntp服务器
sed -i '$a server 202.193.158.37' /etc/ntp.conf
/etc/init.d/ntpd restart &>> /root/Script/my_log/basic_security.log
sed -i '$a 10 3 * * * root /usr/sbin/ntpdate 202.193.158.37 && /sbin/hwclock -w' /etc/crontab

echo -e "\e[1;31m 9 remote logs \e[0m" | tee -a /root/Script/my_log/basic_security.log
#远程日志,更改日志设置
sed -i '$a #authpriv.*   @192.168.10.152' /etc/rsyslog.conf
#/etc/init.d/rsyslog restart 

echo -e "\e[1;31m 10 locking account \e[0m" | tee -a /root/Script/my_log/basic_security.log
#因为一些系统账号是不会登录的,我的系统账号比较干净。
#accountname="uucp noboby games rpm smmsp nfsnobody"
#for i in $accountname
#do
#	passwd -l $i
#done

echo -e "\e[1;31m 11 login timeout \e[0m" | tee -a /root/Script/my_log/basic_security.log
#设置登录超时，自动t退出
echo -e "TMOUT=180\nexport TMOUT" >> /etc/profile
source /etc/profile

echo -e "\e[1;31m 12 default permission \e[0m" | tee -a /root/Script/my_log/basic_security.log
#将默认权限022改成027
sed -i 's/umask.*/umask 027/g' /etc/profile
sed -i 's/umask.*/umask 027/g' /etc/bashrc

echo -e "\e[1;31m 13 ban redirects \e[0m" | tee -a /root/Script/my_log/basic_security.log
#禁止icmp重定向、禁止ip路由转发
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf && sysctl -p &>>/root/Script/my_log/basic_security.log
# exec sysctl.conf enable

echo -e "\e[1;31m 14 sync \e[0m" | tee -a /root/Script/my_log/basic_security.log
#root用户为管理用户，在登出前或关机前将内存数据写入硬盘中
sed -i '$a sync' /root/.bash_logout
