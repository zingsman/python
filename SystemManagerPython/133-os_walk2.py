#_*_ conding: UTF-8 _*_
import os
import fnmatch

def file_match(filename,patterns):
    for pattern in patterns:
        if fnmatch.fnmatch(filename,pattern):
            return True
    return False


def find_specific_files(root,patterns=['*'],exclude_dirs=[]):
    for root,dirnames,filenames in os.walk(root):
        for filename in filenames:
            if file_match(filename,patterns):
                yield os.path.join(root,filename)
                for d in exclude_dirs:
                    if d in dirnames:
                        dirnames.remove(d)
patterns=['*.log', '*.txt']
exclude_dirs=[]
#---1,找到某文件夹特殊的文件。排出某些目录
#exclude_dirs=['0517支付2.4.4发布'] #C:\\users\\ke.peng\\Desktop\\杂文档\\0517支付2.4.4发布
#for item in find_specific_files("C:\\users\\ke.peng\\Desktop\\杂文档",patterns,exclude_dirs):
#    print(item)

#---2.找到某目录大小最大10个文件
files = {name:os.path.getsize(name) for name in find_specific_files("C:\\users\\ke.peng\\Desktop\\杂文档",patterns,exclude_dirs)}
print(files.items())
result = sorted(files.items(),key=lambda d: d[1],reverse=True)[:10]
for i,t in enumerate(result,1):
    print(i,t[0],t[1])