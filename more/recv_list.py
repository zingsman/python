#/usr/bin/python
#Filename: recv_list.py
def powersum(power,*args):
	total=0
	for i in args:
		total += pow(i,power)
	return total
print powersum(2,3,4,5)
print powersum(2,100)
s=range(1,100)
print s