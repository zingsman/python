#!/usr/bin/python
# filename while.py
number = 23
result = True
while result:
	guess=int(raw_input('please input a integer:'))
	if guess==number:
		print 'yes!ok!good!!!'
		result=False
	elif guess<number:
		print 'no! too less'
	else:
		print 'no! too big'
else:
	print 'this is a while loop over'
print 'Done'
