name='hello,word'
test='a b ec	d'
print 'TEST: %s and %s' %(name,test)
print 'str.capitalize :',name.capitalize()
a=name.center(15)
print 'str.center :',a,'length is:', len(a)
print 'str.replace wit A:',test.replace(' ','A')
# string.count(sub, beg=0, end=len(string))
sub='o'
print 'srt.count result times:',name.count(sub, 0, len(name))
print 'str.endswith result is :', name.endswith('d',0,len(name))
print 'str.expandtabs is :',test.expandtabs()
print 'str.find "w" is:',name.find('w')
# isalnum(...)
# all string is number and zimu?
print 'str.isalnum is:',name.isalnum()
#all string is zimu(alpha)?
print 'str.isalpha is:',name.isalpha()
# have reshu de  fuhao  result false , forexple: '' and space
print 'str.isdigit is:',name.isdigit()
# if all string is xiaoxie zimu
print 'str.islower is:',name.islower()
print 'more use "help(str)"'
