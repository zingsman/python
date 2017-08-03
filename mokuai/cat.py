#!/bin/python
# filename:cat.py
import sys
def readfile(filename):
	filename=raw_input('Input filename:')
	while True:
		f=file(filename)
		line=f.readline() #yihang yihang du
		if len(line) == 0:+
			print 'file becamed Null'
			break
		else:
			print line,
	f.close()
# Scripts starts from here
if len(sys.argv) < 2:
	print 'No action specifed.'
	sys.exit()
if sys.argv[1].startswith('--'):
	option=sys.argv[1][2:]
	# fetch sys.argv[1] but without the first two characters
	if option == 'version':
		print 'Version 1.2'
	elif option == 'help':
		print '''\
		Any number of files can be specified.
		Options include:
		--version : Prints the version number
		--help : Display this help'''
	else:
		print 'Unknown option.'
else:
	for a in sys.argv[1:]:
		readfile(filename)