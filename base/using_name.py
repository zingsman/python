#!/bin/python
# filename using_name.py
import using_name
if __name__ == '__main__':
	print 'This program is being run by itself'
	print '__name__ is:',__name__
else :
	print 'I\'m beging imported from another module'
	print '__name__ is:',__name__