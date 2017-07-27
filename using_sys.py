#!/bin/python
# filename using_sys.py
## 注意：sys.argv是提出命令行的参数。$0是文件名，$1..$n 是第1到n个参数
# 这里跟 shell 脚本一样：  sh pengke.sh hello word  其中hello和word是第一第二个参数
import sys
print 'The command line arguments are:'
for i in sys.argv:
	print i
print '\n\nThe PYTHONPATH is', sys.path, '\n'