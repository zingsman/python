import prettytable
## 按行添加数据
pt = prettytable.PrettyTable()
pt.field_names = ["City name", "Area", "Population", "Annual Rainfall"]
pt.add_row(["Adelaide",1295, 1158259, 600.5])
pt.add_row(["Brisbane",5905, 1857594, 1146.4])
pt.add_row(["Darwin", 112, 120900, 1714.7])
pt.add_row(["Hobart", 1357, 205556,783.2])
print(pt)
pt.add_column("index",[1,2,3,4])
print(pt)
## 使用不同的输出风格
pt.set_style(prettytable.MSWORD_FRIENDLY)
print('--- style：MSWORD_FRIENDLY -----')
print(pt)
pt.set_style(prettytable.PLAIN_COLUMNS)
print('--- style：PLAIN_COLUMNS -----')
print(pt)
pt.set_style(prettytable.DEFAULT)
print('--- style：DEFAULT -----')
print(pt)
## 不打印，获取表格字符串
s=pt.get_string()
print(s)
## 可以只获取指定列或行
s = pt.get_string(fields=["City name", "Population"],start=1,end=4)
print(s)
