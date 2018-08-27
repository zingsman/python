from collections import namedtuple
#Disk = namedtuple('Disk', 'major_number minor_number device_name read_count read_merged_count read_sections time_spend_reading write_count write_merged_count write_sections time_spent_write io_requests time_spent_write io_requests time_spent_doing_io weighted_time_spent_doing_io')
Disk = namedtuple('Disk', 'major_number minor_number device_name'
                          ' read_count read_merged_count read_sections'
                          ' time_spent_reading write_count write_merged_count'
                          ' write_sections time_spent_write io_requests'
                          ' time_spent_doing_io weighted_time_spent_doing_io')
def get_disk_info(device):
    with open('C:\\Users\\ke.peng\\Desktop\\test\\test.txt') as f:
        for line in f:
            if line.split()[2] == device:
                return  Disk(*(line.split()))
    raise RuntimeError("device ({0}) not found !".format(device))

def main():
    disk_info=get_disk_info('vda')
    print(disk_info)
    print("磁盘写入次数:{0}".format(disk_info.write_count))
    print("磁盘写入字节数:{0}".format(disk_info.write_sections))
    print("磁盘写入延时:{0}".format(disk_info.time_spent_write))

if __name__ == '__main__':
    main()