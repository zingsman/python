import os
import socket
from datetime import datetime
import jinja2
import yagmail
import psutil
import time

EMAIL_USER = '18408276935@139.com'
EMAIL_PASSWORD = 'pengke'
RECIPIENTS = ['11946769@qq.com','18408276935@139.com']

def render(tpl_path,**kwargs):
    path,filename = os.path.split(tpl_path)
    return jinja2.Environment(loader=jinja2.FileSystemLoader(path or './')).get_template(filename).render(**kwargs)

def bytes2human(n):
    symbols = ('K','M','G','T','P','E','Z','Y')
    prefix = {}
    for i,s in enumerate(symbols):
        prefix[s] = 1 << (i+1) * 10
    for s in reversed(symbols):
        if n >= prefix[s]:
            value = float(n) / prefix[s]
            return '%.1f%s' % (value, s)
    return '%sB' % n
def get_cpu_info():
    cpu_count = psutil.cpu_count()
    cpu_percent = psutil.cpu_percent(interval=1)
    return dict(cpu_count=cpu_count,cpu_percent=cpu_percent)
def get_memory_info():
    memory_data = psutil.virtual_memory()

    memory_total = bytes2human(memory_data.total)
    memory_percent = memory_data.percent
    memory_free = bytes2human(memory_data.free)
    memory_used = bytes2human(memory_data.used)
    return dict(memory_total=memory_total,memory_used=memory_used,memory_percent=memory_percent,memory_free=memory_free)
def get_disk_info():
    disk_usage = psutil.disk_usage('/')

    disk_total = bytes2human(disk_usage.total)
    disk_percent = disk_usage.percent
    disk_free = bytes2human(disk_usage.free)
    disk_used = bytes2human(disk_usage.used)
    return dict(disk_total=disk_total,disk_percent=disk_percent,disk_free=disk_free,disk_used=disk_used)
def get_boot_info():
    boot_time = datetime.fromtimestamp(psutil.boot_time()).strftime("%Y-%m-%d %H:%M:%S")
    return dict(boot_time=boot_time)
def get_monitor_data():
    data= {}
    data.update(get_boot_info())
    data.update(get_cpu_info())
    data.update(get_memory_info())
    data.update(get_disk_info())
    return data
def main():
    data = get_monitor_data()
    hostname = socket.gethostbyname(socket.gethostname())
    data.update(dict(hostname=hostname))
    current_time = datetime.fromtimestamp(time.time()).strftime("%Y-%m-%d %H:%M:%S")
    data.update(dict(current_time=current_time))

    print(data)
    content = render('monitor.html',**data)
    print(content)

    with open('C:\\Users\\ke.peng\\Desktop\\html.html','a') as f:
        f.write(content)

#    with yagmail.SMTP(user=EMAIL_USER,password=EMAIL_PASSWORD,host='smtp.139.com',port=25) as yag:
#        for recipient in RECIPIENTS:
#            yag.send(recipient,'监控信息'.encode('utf-8'),content.encode('utf-8'))
if __name__ == '__main__':
    main()