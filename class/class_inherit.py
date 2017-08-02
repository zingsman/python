#!/bin/python
#Filename: class_inherit.py
class schoolMamber:
	'''represents any school member.'''
	def __init__(self,name,age):
		self.name=name
		self.age=age
		print 'Initialized SchoolMember: %s' % self.name
	def tell(self):
		print 'Name: %s Age: %d'% (self.name,self.age) ,
class teacher(schoolMamber):
	'''represents teacher member'''
	def __init__(self,name,age,salary):
		schoolMamber.__init__(self,name,age)
		self.salary=salary
		print '(Initialized Teacher: %s)' % self.name
	def tell(self):
		schoolMamber.tell(self)
		print '"Salary":%d'% self.salary
class student(schoolMamber):
	def __init__(self,name,age,mark):
		schoolMamber.__init__(self,name,age)
		self.mark=mark
		print '(Initialized Teacher: %s)' % self.name
	def tell(self):
		schoolMamber.tell(self)
		print '"Mark:"',self.mark

T=teacher('helaoshi',54,50000)
S=student('pengke',20,78)
members=[T,S]
for member in members:
	member.tell()

