#!/bin/python
#Fliename using_pickling.py
import cPickle as p
#import pickle as p
shoplistfile='shoplist.data'
# this object starge's  filename
shoplist=['apple','mango','carrot']
f=file(shoplistfile,'w')
p.dump(shoplist,f) #dump the object to a file
f.close()
del shoplist
f=file(shoplistfile)
storedlist = p.load(f)
print storedlist