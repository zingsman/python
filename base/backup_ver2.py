# filename backup_ver1.pu
import os
import time
import sys
#source = ['C:\\Users\\pengke\\Desktop\python_test','C:\\Users\\pengke\\Desktop\\Test01']
source = 'C:\\Users\\pengke\\Desktop\python_test'
target_dir = 'G:\\python_back\\'
today=target_dir+time.strftime('%Y%m%d')
print today
now=time.strftime('%H%M%S')
if not os.path.exists(today):
	os.mkdir(today)
	print 'successfully created directory:',today
else:
	os.removedirs(today)
	print 'successfully deleted directory:',today
	os.mkdir(today)
	print 'successfully created directory:',today
target=today+'\\'+now
#target=today+os.sep+now # os.sep shi meige xitong de mulu fuhao wondows is \
#zip_command = "zip -qr '%s' %s" % (target, ' '.join(source))
print 'backup des:',target
#print 'backup source: %s %s' % (source[0], source[1])
print 'backup source:', ''.join(source)
command_7z = "E:\\soft_install\\7-Zip\\7z.exe a %s %s" % (target,''.join(source)) #yuan wenjian zhi you yige  mulu
#command_7z = "E:\\soft_install\\7-Zip\\7z.exe a %s %s" % (target,' '.join(source))
print '7z command:',command_7z
if os.system(command_7z) == 0:
     print('Successful backup to'), target
else:
     print('Backup FAILED')
