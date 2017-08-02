#!/bin/python
# filename: simple_CLASS.py
class human:
	"""docstring for human"""
	def SayHi(self):     # self can not use agrv
		print 'Hello Word!'

a=human()
print a
a.SayHi()
#help(human)