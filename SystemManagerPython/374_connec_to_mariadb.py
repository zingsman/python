import os
import datetime
import pymysql as db
import time
def get_conn(**kwargs):
    mysqldb=db.connect(host=kwargs.get('host', 'localhost'),user=kwargs.get('user'),
               passwd=kwargs.get('passwd'),
               port=kwargs.get('port',3306),
               db=kwargs.get('db'))
    return mysqldb
def main():
    conn = get_conn(host='127.0.0.1',
                    user='app',
                    passwd='xxxxxx',
                    port=3306,db='pk')
    cur = conn.cursor()
    cur.execute('SELECT * FROM depute_trans')
    all_data=cur.fetchall()
    cur.close()
    conn.close()
#    for i in all_data:
#        print(i[0])
#        print(time.strftime('%Y%m%d',time.localtime()))
    with open('C:\\Users\\ke.peng\\Desktop\\test\\mysql_data.txt','w') as f:
        for data in all_data:
            for i in data:
                f.write(str(i) + '|')
            f.write('\n')
        print('Data write to "mysql_data.txt" is over!')
if __name__ == '__main__':
    main()
