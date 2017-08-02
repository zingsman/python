#!/bin/python
#filename: class_objvar.py
class Person:
	name='pengke'
	age=25
	def change_name(self,name):
		self.name=name
		print 'my name is ',self.name
	def change_age(self,age):
		self.age=age
		print 'my age is ',self.age

a=Person()
print 'source data is:',a.name,a.age
a.change_name('xiaoming')
print a.name
a.change_age(100)
print a.age
