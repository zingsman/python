# filename backup_ver1.pu
import os
import time
source=[r'C:\Users\pengke\Desktop\python_test',r'C:\Users\pengke\Desktop\Test01']
print source[1]
target_dir=r'G:\python_back'
#print dir(time)
target=target_dir+time.strftime('%Y%m%d%H%M%S')+'rar'
#rar_command = "rar a '%s' %s " % (target,''.join(source))
zip_command = "zip -qr '%s' %s" % (target, ' '.join(source))
if os.system(rar_command) == 0:  
    print('Successful backup to'), target  
else:  
    print('Backup FAILED')  