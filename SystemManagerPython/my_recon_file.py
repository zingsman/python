import os,difflib
def readfile(filename):
    file_data=open(filename,'r')
    text=file_data.read().splitlines()
    file_data.close()
    return text

def main():
    d=difflib.HtmlDiff()
    msxf_data_file='C:\\Users\\ke.peng\\Desktop\\test\\msjr_data.txt'
    qudao_data_file='C:\\Users\\ke.peng\\Desktop\\test\\qudao_data.txt'
    msxf_data=readfile(msxf_data_file)
    qudao_data=readfile(qudao_data_file)
    with open('C:\\Users\\ke.peng\\Desktop\\test\\recon_result.html','w') as f:
        f.write(d.make_file(msxf_data,qudao_data))

if __name__ == '__main__':
    main()