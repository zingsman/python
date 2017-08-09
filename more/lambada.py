#!/usr/bin/python
#filename:lambda.py
def make_repeater(n):
	return lambda s:s*n

twice=make_repeater(2)
print twice('word')
print twice(5)

a= map(lambda x:x*5,[y for y in range(10)])
print a
b= map(lambda a:a+1,[1,2,3])
print b