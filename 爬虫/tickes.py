#coding: utf-8
"""命令行火车票查看器

Usage:
    tickets [-gdtkz] <from> <to> <date>

Options:
    -h,--help   显示帮助菜单
    -g          高铁
    -d          动车
    -t          特快
    -k          快速
    -z          直达

Example:
    tickets 北京 上海 2016-10-10
    tickets -dg 成都 南京 2016-10-10
"""
from docopt import docopt
import sys
from stations import stations
import requests
from prettytable import PrettyTable
from colorama import init,Fore

init()

class TrainsCollection:

    header = '车次 车站 时间 历时 一等 二等 高级软卧 软卧 硬卧 硬座 无座'.split()

    def __init__(self, available_trains,available_place,options):
        """查询到的火车班次集合

        :param available_trains: 一个列表, 包含可获得的火车班次, 每个
                                 火车班次是一个字典
        :param options: 查询的选项, 如高铁, 动车, etc...
        """
        self.available_trains = available_trains
        self.available_place = available_place
        self.options = options
    @property
    def trains(self):
        for raw_train in self.available_trains:
            raw_train_list = raw_train.split('|')
            #print(raw_train_list)
            train_no = raw_train_list[3]
            #print(train_no)
            initial = train_no[0].lower()
            #print(initial)
            duration = raw_train_list[10]
            if  (initial in self.options) or (self.options == "") :
                train = [
                    train_no,        
                    '\n'.join([Fore.LIGHTGREEN_EX + self.available_place[raw_train_list[6]] + Fore.RESET,
                               Fore.LIGHTRED_EX + self.available_place[raw_train_list[7]] + Fore.RESET]),
                    '\n'.join([Fore.LIGHTGREEN_EX + raw_train_list[8] + Fore.RESET,
                               Fore.LIGHTRED_EX + raw_train_list[9] + Fore.RESET]),
                    duration,
                    raw_train_list[-4] if raw_train_list[-4] else '--',
                    raw_train_list[-5] if raw_train_list[-5] else '--',
                    raw_train_list[-14] if raw_train_list[-14] else '--',
                    raw_train_list[-12] if raw_train_list[-12] else '--',
                    raw_train_list[-7] if raw_train_list[-7] else '--',
                    raw_train_list[-6] if raw_train_list[-6] else '--',
                    raw_train_list[-9] if raw_train_list[-9] else '--',
                ]
                #print(train[:])
                yield train

    def pretty_print(self):
        pt = PrettyTable()
        pt._set_field_names(self.header)
        for train in self.trains:
            pt.add_row(train)
        print(pt)


def cli():
    """command-line interface"""
    arguments = docopt(__doc__) #__doc__是出去当前对象的帮助文档
    #	print(arguments)#是返回一个字典
    from_station = stations.get(arguments['<from>'])
    to_station = stations.get(arguments['<to>'])
    date = arguments['<date>']
    url = 'https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date={}&leftTicketDTO.from_station={}&leftTicketDTO.to_station={}&purpose_codes=ADULT'.format(date, from_station, to_station)
    options= ''.join([key for key, value in arguments.items() if value is True])
    # 获取参数
    # 添加verify=False 参数不验证证书
    r=requests.get(url, verify=False)
    #print(r.json())
    #r = requests.get(url);
    available_trains = r.json()['data']['result']
    available_place = r.json()['data']['map']
    #print(available_trains[:])
    #a=''.join(available_trains[:])
    #print(a.split("|"))
    #Trainsconllection(available_trains, options).pretty_print()
    TrainsCollection(available_trains,available_place,options).pretty_print()
if __name__ == '__main__':
    cli()