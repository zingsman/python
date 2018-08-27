import os
recon=[]
with open('C:\\Users\\ke.peng\\Desktop\\test\\recon_date') as f:
    for lines in f:
        recon.append(lines.replace('\n',''))
with open('C:\\Users\\ke.peng\\Desktop\\test\\02201801021503370035_20180627.txt') as all_f:
    for line in all_f:
        all_recon=line.replace('\n','').split('|')
        for i in recon:
           if i in all_recon:
                print(i,all_recon[-2])


