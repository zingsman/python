import  os,openpyxl,glob

def main():
    dirname='C:\\Users\\ke.peng\\Desktop\\test\\tmp'
    files=glob.glob(os.path.join(dirname,'*.xlsx'))
    print(files)
    wb = openpyxl.load_workbook(files[0])
    ws = wb.active
    ws.title = 'All result'
    for i in files[1:]:
        workbook = openpyxl.load_workbook(i)
        sheet = workbook.active
        for row in sheet.iter_rows():
            values = [cell.value for cell in row]
            ws.append(values)
    wb.save(dirname + '\\new.xlsx')
if __name__ == '__main__':
    main()