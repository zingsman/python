#!/bin/python
#Filename=using_file.py
poem='''\
Programming is fun
When the work is done
if you wanna make your work also fun:
	use Python!
	and funk
'''
#peng=file('test.txt','w') # if file no exist and it will creat new file
f=file('poem.txt','a') # open for wrinting
f.write(poem) # wrint text to file. at end ,add
f.writelines("so ga  ba ge")
f.close() # close the file
f=file('poem.txt')
#if no mode is specified, 'r'ead mode is assumed by default
while True:
	line=f.readline()
	#line=f.read(3)
	if len(line) == 0:
		break
	print line, # readline duquyihang bing fanhui huanghangfuhao ,bu jia , you ge konghanfu
	# Notice comma to avoid automatic newline added by Python
f.close() # close the file
