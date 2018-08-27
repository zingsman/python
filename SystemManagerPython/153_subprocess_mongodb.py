import os,shutil,tarfile,subprocess
def excute_cmd(cmd):    # 执行mongo/bin/mongod --fork --logpath mongodata/mongod.log --dbpath mongodate 命令
    p=subprocess.Popen(cmd,
                       shell=True,
                       stdin=subprocess.PIPE,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
    stdout,stderr=p.communicate()
    if p.returncode !=0:
        return p.returncode,stderr
    return p.returncode,stdout
def uppackage_mongodb(package,package_dir):
    uppackage_dir = os.path.splitext(package)[0]  #将包名以'.'切分,保留名字，默认解压后目录没有后缀名
    if os.path.exists(uppackage_dir):   #如果包名存在的目录直接删除
        shutil.rmtree(uppackage_dir)
    if os.path.exists(package_dir): #如果包目录存在直接删除
        shutil.rmtree(package_dir)
    t=tarfile.open(package,'r:gz')  #解压MongoDB的压缩包
    t.extractall('.')   #在当前目录提取压缩包的所有文件
    shutil.move(uppackage_dir,package_dir)  #将解压后的目录移动到自己定义的包目录。
def create_datedir(data_dir):
    if os.path.exists(data_dir):    #如果存在数据目录，直接删除
        shutil.rmtree(data_dir)
    os.mkdir(data_dir)  #创建数据库目录
def format_mongodb_command(package_dir,data_dir,logfile):   #生成mongodb命令启动的参数
    mongod=os.path.join(package_dir,'bin','mongod')
    mongod_format="""{0} --fork --dbpath {1} --logpath{2}"""
    return mongod_format.format(mongod,data_dir,logfile)

def start_mongodb(cmd):
    returncode,out=excute_cmd(cmd)
    if returncode !=0:
        raise SystemExit('execute {0} error :{1}'.format(cmd,out))
    else:
        print("execute command ({0}) successful".format(cmd))
def main():
    package='mongodb-linux-x86_64-3.0.6.tgz'  #mongodb的压缩包
    cur_dir=os.path.abspath('.')    #输出当前工作目录
    package_dir=os.path.join(cur_dir,'mongo')  #输出包目录为./mongo
    date_dir=os.path.join(cur_dir,'mongodate')  #输出MongoDB的数据目录./mongodate
    logfile=os.path.join(date_dir,'mongod.log') #输出MongoDB的日志入了./mongod.log

    if not os.path.exists(package): #如果软件包不存在，退出程序
        raise SystemExit("{0} not found".format(package))

    uppackage_mongodb(package,package_dir) #将包名  和包的目录传给创建目录的函数
    create_datedir(date_dir)    #创建MongoDB的数据库目录
    start_mongodb(format_mongodb_command(package_dir,date_dir,logfile)) #启动MongoDB
    # 启动命令：./mongo/bin/mongod --fork --logpath mongodata/mongod.log --dbpath ./mongodate
if __name__ == '__main__':
    main()