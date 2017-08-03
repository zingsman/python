#!/bin/python
import os
if os.path.exists('test.xlsx'):
	print 'yes.file exists'
else:
	print 'no! file no exists' 
f=file('test.xlsx')
line=f.readline()
while True :
	if line==0:
		print 'line is zero'
		break
	print line,
