#/usr/bin/python
#filename: continue.py
while 1 :
	s=raw_input('please input chars:')
	if s=='quit':
		break
	elif len(s)<=3:
		print 'your chars too less!'
		continue
	print "your chars length are :",len(s)
print 'Done!'