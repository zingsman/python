#!/usr/bin/python
# filename using_dict.py

# 'aabb' is adress books
aabb= {
	'zhangsan':'zhangsan@zingsman.com',
	'lisi' : 'lisi@qq.com',
	'zhaoer' : 'zhaoer@163.com',
	'pppeng' : 'ppeng@zingsman.com',
	}
print 'This dict length is',len(aabb)
print "zhangsan's address is " , aabb['zhangsan']
# in []  you have not to '' ,yes  yes 
# add a new dict key and value
aabb["pengke"]='pengke@qq.com'
print 'All dict are:',aabb
#del a key/value 
del aabb["zhangsan"]
print 'All dict are:', aabb
print 'Length is',len(aabb)
for name,address in aabb.items():
	print 'Contact %s \'s email address %s' % (name,address)
if aabb.has_key('pengke'):
#if 'pengke' in aabb:
	print 'Pengke\'s email address is ', aabb['pengke']
