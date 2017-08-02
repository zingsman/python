#/bin/python
#filename func_param.py
def PrintMax(a,b):
	if a==b:
		print 'a=b:',a,'=',b
	elif a>b:
		print 'a>b:',a,'>',b
	else :
		print 'a<b:',a,'<',b
		

PrintMax(87,98)
x=3
y=1
PrintMax(x,y)
