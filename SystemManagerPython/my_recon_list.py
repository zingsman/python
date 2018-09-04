#我的对账脚本
import os,re
import difflib
a = difflib.Differ()
msxf_data = []
qudao_data = []
with open('C:\\Users\\ke.peng\\Desktop\\test\\msjr_data.txt') as f:
    for msxf in  f:
        msxf_data.append(msxf.replace('\n',''))

with open('C:\\Users\\ke.peng\\Desktop\\test\\qudao_data.txt') as f:
    for qudao in  f:
        qudao_data.append(qudao.replace('\n',''))
with open('C:\\Users\\ke.peng\\Desktop\\test\\recon_result.txt','w') as f:
    f.write('备注:"+"代表渠道有，马上没有,"-"代表马上有,渠道没有' + 2*'\n')
    f.write('\n'.join(a.compare(msxf_data,qudao_data)))
    print('Recon complete! write to "C:\\Users\\ke.peng\\Desktop\\test\\recon_result.txt"')

