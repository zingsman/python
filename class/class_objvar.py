#!/bin/python
#filename: class_objvar.py
class Person:
	count=0
	def __init__(self,name):
		'''Pepresents a person'''
		self.name=name
		print 'Initializes the person\'s',self.name
		Person.count +=1
	def __del__(self):
		'''I'm dying'''
		print '%s says bye' %self.name
		Person.count -= 1
		if Person.count == 0 :
			print 'I am the last one'
		else:
			print 'There are still %d Peoples' % Person.count 
	def sayHi(self):
		'''Greeting by the person.
		Really, that's all it does.'''
		print 'Hi, my name is %s.' % self.name
	def howMany(self):
		'''Prints the current population.'''
		if Person.count == 1:
			print 'I am the only person here.'
		else:
			print 'We have %d persons here.' % Person.count

swaroop = Person('Swaroop')
swaroop.sayHi()
swaroop.howMany()

kalam = Person('Abdul Kalam')
kalam.sayHi()
kalam.howMany()

swaroop.sayHi()
swaroop.howMany()