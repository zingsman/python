#!/bin/python
# name: if.py
number = 23
guess = int(raw_input('Enter an integer:'))
if guess == number:
    print 'yes!'
    print 'your can not no one prizes'
elif guess > number:
    print "no1", guess
else:
    print "no2", guess
print 'Done!'
