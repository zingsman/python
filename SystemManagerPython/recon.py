fp = open('C:\\Users\\ke.peng\\Desktop\\test\\recon_date','r')
fp1 = open('C:\\Users\\ke.peng\\Desktop\\test\\02201801021503370035_20180628.txt','r')
recon = []
line = fp.readline().replace('\r','').replace('\n','')
line1 = fp.readline().replace('\r','').replace('\n','')
while line:
    recon.append(line)
    line = fp.readline().replace('\r', '').replace('\n', '')
while line1:
    for i in recon:
        if i in line1:
            print(line1.split('|')[16],line1.split('|')[4])
    line1 = fp1.readline().replace('\r', '').replace('\n', '')