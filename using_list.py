#!/bin/python
# filename using_list.py
mylist = ['apple','mango','carrot','banana']
print 'I\'m will buy',len(mylist),'fruits'
print 'They are:',
for i in mylist:
	print i,
print '\nI also add a fruit is: rice.'
mylist.append('rice')
print 'My will buy list is now',mylist

print 'friut list will been sorted:'
mylist.sort()
print 'they sorted list is :',mylist
print 'Now! I will buy first fruit is:',mylist[0]
del mylist[0]
print 'buy success! Now! my list is:',mylist
