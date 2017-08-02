#!/bin/python
# filename: function01.py
def sayhello():
    print 'Hello Word!'
a=int(raw_input('please inpult sayhello times:'))
for i in range(1,a+1):
	sayhello()
print 'Done!'
