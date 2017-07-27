#!/usr/bin/python
# Filename: func_docstrings.py
# 就是一些帮助文档。使用help(函数名)可以调出来查看
def printMax(x, y):
	'''Prints the maximum of two numbers.

	The two values must be integers.'''
# convert to integers, if possible	
	x = int(x) 
	y = int(y)
	if x > y:
		print x, 'is maximum'
	else:
		print y, 'is maximum'
printMax(3, 5)
print printMax.__doc__