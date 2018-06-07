#!/bin/python
import os
import sys
import stat
argv_list = sys.argv[:]
if len(argv_list) != 2 :
    print('argvs error! exitting...')
    exit()
    
filename = os.path.join(os.getcwd(),argv_list[1])
if os.path.exists(filename):
    if os.access(filename,os.R_OK):
        with open(filename) as f:
            print(f.read())
    else:
        os.chmod(filename, stat.S_IRUSR)
        print('change your file! exit...')
else:
    print('your file no exist! exit...')
