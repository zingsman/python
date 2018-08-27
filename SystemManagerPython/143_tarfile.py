import fnmatch
import os
import tarfile
import datetime

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

def main():
    patterns = ['*.log','*.txt']
    filename='C:\\Users\\ke.peng\\Desktop\\test'
    now=datetime.datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
    tar_name="test_{}".format(now)
    with tarfile.open(tar_name,'w:gz') as f:
        for i in find_specific_files(filename,patterns):
            f.add(i)
if __name__ == '__main__':
    main()