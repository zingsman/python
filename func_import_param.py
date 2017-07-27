#/bin/python
#filename func_import_param.py

def func(a, b=5, c=10):
    print 'a is', a, 'and b is', b, 'and c is', c
func(3, 7)
func(25, c=24)
func(c=50, a=100)
#注意，在函数定义里面，没有默认变量的形参，在调用函数时候，必须赋值
