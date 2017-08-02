#!/bin/python
# filename: class_init_myself.py
class Person():
	def __init__(self,name):
		self.name=name
		self.age=18
	def Sayhi(self):
		print 'Hello,my name is',self.name,'my age:',self.age

a = Person('pengke')
a.Sayhi()
		