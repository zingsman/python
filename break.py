#/usr/bin/python
#filename: break.py
while 1 :
	s=raw_input('please input a char:')
	if s=='quit':
		break
	print 'this char length is :',len(s)
print 'Done!'