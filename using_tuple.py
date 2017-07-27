#!/bin/python
# filename using_tuple.py
zoo=('dog','cat','big')
print 'this is tuple,name is zoo,it has',len(zoo),'animals!'
print 'this zoo animals are:',zoo
new_zoo=('wolf','elephant','penguin',zoo)
print 'Number of animals in the new zoo is ',len(new_zoo)
print 'All animals in new zoo are',new_zoo
print 'All nimals brought from old zoo are',new_zoo[3]
print 'Last animal brought from old zoo is',new_zoo[3][2]