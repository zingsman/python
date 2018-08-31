import os
import datetime
import pymysql as db
def get_conn(**kwargs):
    mysqldb=db.connect(host=kwargs.get('host', 'localhost'),user=kwargs.get('user'),
               passwd=kwargs.get('passwd'),
               port=kwargs.get('port',3306),
               db=kwargs.get('db'))
    return mysqldb
def main():
    conn = get_conn(host='127.0.0.1',user='app',passwd='xxxx',port=3306,db='pk')
    cur = conn.cursor()
    cur.execute('SELECT trans_date_time,acct_name,trans_amount,inst_code FROM depute_trans')
    all_data=cur.fetchall()
    cur.close()
    conn.close()
    with open('C:\\Users\\ke.peng\\Desktop\\test\\mysql_data.txt','w') as f:
        for data in all_data:
            print(data)
            f.write(str(data) + '\n')
        print('Data write to "mysql_data.txt" is over!')
if __name__ == '__main__':
    main()