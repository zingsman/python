#!/bin/python
# filename using_name.py
import using_name
if __name__ == '__main__':
	print 'This program is being run by itself'
#	print '__name__ is:',__name__
else :
	print 'I\'m beging imported from another module'
#	print '__name__ is:',__name__  #这行有就报错
# 解释：__name__ 在这里，这是python函数的一个内置变量。有2种情况
# 第一种： 当该函数是 主动 import xx 时候，这是__name__ 的值就是__main__
# 第二种： 当该函数是 被 import 时候，这是__name__的值就是此模块的名字。 没有后缀名

# 该文件已经有莫名的编码问题，请看 using_name.py
