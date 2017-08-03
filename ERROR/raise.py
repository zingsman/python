#!/bin/python
#Filename: raise.py
class ShortException(Exception):
	''' A user-defined exception class.'''
	def __init__(self,length,atleast):
		Exception.__init__(self)
		self.length=length
		self.atleast=atleast
try:
	s=raw_input('Enther something-->')
	if len(s) < 3 :
		raise ShortException(len(s),3)
		# Other work can continue as usual here
except EOFError:
	print '\nWhy did you do an EOF on me ?'
except ShortException,x:
	print 'ShortException: The input was of length %d,\
	was excepting at least %d ' % (x.length,x.atleast)
else:
	print "No exception was raised."