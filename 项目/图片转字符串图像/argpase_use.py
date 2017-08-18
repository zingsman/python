import argparse
parser = argparse.ArgumentParser()
#1. parse.parse_args()
#2. parse.add_argument("echo")
#4. parser.add_argument("echo",help="echo the string you use here")
parser.add_argument("echo",help="display a square of a given number",type=int)
#5. parser.add_argument("-v","--verbosity",help="increase output verbosity",action="store_true")
#6. parser.add_argument("-v","--verbosity",help="increase output verbosity",type=int,choices=[2,1,0],action="count")
parser.add_argument("-v","--verbosity",help="increase output verbosity",action="count",default=0)
#action="count" 是用来统计参数出现的参数,指定了参数v就是True/1 否则就是none
# 这里下面 if中 args.verbosity 就是次数了
#注意看了下面
args=parser.parse_args()
test=args.echo**2
if args.verbosity == 2:
	print("the echo of {} equals {}".format(args.echo,test))
elif args.verbosity == 1:
	print("the echo {}^2={}".format(args.echo,test))
else:
	print(test)