import numpy as np
import re
from matplotlib import pyplot as plt
from matplotlib.ticker import MultipleLocator
import xlwt
import pandas as pd

# 筛选数据范围：经度20W到10E，纬度20N到50N的方形数据
# 数据格式：摄氏度，精确到小数点后2位。非海洋区域一律设为-10

path_prefix = "HaDISST96-17/HadISST1_SST_{}.txt"

total_data = []

path = path_prefix.format('1991-2003')
with open(path,'r') as f:
    lines = f.readlines()
    #print(len(lines))
    for year in range(2000, 2004):
        start = (year-1991)*12*181
        print(lines[start])
        data=[]
        for i in range(start+20,start+51):
            line = lines[i]
            tmp = np.array(re.findall(r'.{6}',line)[160:191],dtype=int)
            data.append(tmp)
        data = np.array(data)
        data[data == -32768] = -1000
        data = data / 100
        total_data.append(data)

for year in range(2004, 2018):
    path = path_prefix.format(year)
    #print(path)
    with open(path,'r') as f:
        lines = f.readlines()
        print(lines[0])
        data = []
        for i in range(20,51):
            line = lines[i]
            tmp = np.array(re.findall(r'.{6}',line)[160:191],dtype=int)
            data.append(tmp)
    data = np.array(data)
    data[data == -32768] = -1000
    data = data / 100
    total_data.append(data)

########
# 画图 #
########

for year in range(2000,2018):
    ax = plt.subplot(3,6,year-1999)
    ax.xaxis.set_major_locator(MultipleLocator(10))
    ax.set_xticklabels(['','19.5W','9.5W','0.5E','10.5E'])
    
    ax.yaxis.set_major_locator(MultipleLocator(10))
    ax.set_yticklabels(['','70.5N','60.5N','50.5N','40.5N'])
    ax.imshow(total_data[year-2000])
plt.show()

#################
# 保存到xls文件 #
#################

writer = pd.ExcelWriter('2000-2018一月SST.xlsx')		# 写入Excel文件

for year in range(2000,2018):

    dataframe = pd.DataFrame(total_data[year-2000], index=np.arange(70.5,39.5,-1), columns=np.arange(-19.5,11.5,1))

    dataframe.to_excel(writer, str(year), float_format='%.2f')

writer.save()
writer.close()


