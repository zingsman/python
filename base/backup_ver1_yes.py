# filename backup_ver1.pu
import os
import time
import sys
source = ['C:\\Users\\pengke\\Desktop\python_test','C:\\Users\\pengke\\Desktop\\Test01']
target_dir = 'G:\\python_back\\'
#print dir(time)
target=target_dir+time.strftime('%Y%m%d%H%M%S')+'.zip'
#zip_command = "zip -qr '%s' %s" % (target, ' '.join(source))
print 'backup des:',target
#print 'backup source: %s %s' % (source[0], source[1])
print 'backup source:', ''.join(source)
#command_7z = "E:\\soft_install\\7-Zip\\7z.exe a %s %s" % (target,''.join(source)) #yuan wenjian zhi you yige  mulu
command_7z = "E:\\soft_install\\7-Zip\\7z.exe a %s %s" % (target,' '.join(source))
print command_7z
print os.system(command_7z)
if os.system(command_7z) == 0:
     print('Successful backup to'), target
else:
     print('Backup FAILED')
