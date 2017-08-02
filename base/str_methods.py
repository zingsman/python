#!/bin/python
# filename srt_methonds.py
# help : use 'help(str)'
name='Swaroop' # THis is a string object
if name.startswith('Swa'):
	print 'Yes,the string starts with "Swa"'
if 'a' in name:
	print 'Yes,The string contains "a"'
# find 'war' in then end one ? -1 means no  find string
if name.find('war') != -1 :
#	print name.find('oo')
	print 'Yes,it contains the string "war"'
delimiter = '_*_'
mylist = ['Brazil','Russia','India','China']
#print delimiter.join('mylist')
print delimiter.join(mylist)