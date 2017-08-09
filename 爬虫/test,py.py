#!usr/bin/python
header = '车|次 车|站 时|间 历|时 一等 二等 高级软卧 软卧 硬卧 硬座 无座'.split()
b = '车|次 车|站 时|间 历|时'.split()
print(header)
print(b)
for a in b:
	c=a.split("|")
	print(c)