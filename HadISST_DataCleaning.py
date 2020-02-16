import numpy as np
import re
from matplotlib import pyplot as plt
from matplotlib.ticker import MultipleLocator
import scipy.io as io
import pandas as pd

# 筛选数据范围：经度20W到10E，纬度20N到50N的方形数据
# 数据格式：摄氏度，精确到小数点后2位。非海洋区域一律设为-10

path_prefix = "HaDISST96-17/HadISST1_SST_{}.txt"

total_data = {}

path = path_prefix.format('1991-2003')
with open(path,'r') as f:
    lines = f.readlines()
    #print(len(lines))
    for year in range(2000, 2004):
        for month in range(1,13):
            start = ((year-1991)*12 + month - 1)*181
            print(lines[start])
            data=[]
            for i in range(start+20,start+51):
                line = lines[i]
                tmp = np.array(re.findall(r'.{6}',line)[160:191],dtype=int)
                data.append(tmp)
            data = np.array(data)
            data[data == -32768] = -1000
            data = data / 100
            total_data['SST'+str(year)+'_'+str(month)] = data

for year in range(2004, 2018):
    path = path_prefix.format(year)
    with open(path,'r') as f:
        lines = f.readlines()
        #print(len(lines))
        for month in range(1,13):
            start = (month-1)*181
            print(lines[start])
            data = []
            for i in range(start+20, start+51):
                line = lines[i]
                tmp = np.array(re.findall(r'.{6}',line)[160:191],dtype=int)
                data.append(tmp)
            data = np.array(data)
            data[data == -32768] = -1000
            data = data / 100
            total_data['SST'+str(year)+'_'+str(month)] = data

########
# 画图 #
########

#print(list(total_data.keys()))

for year in range(2000,2018):
    ax = plt.subplot(3,6,year-1999)
    ax.xaxis.set_major_locator(MultipleLocator(10))
    ax.set_xticklabels(['','19.5W','9.5W','0.5E','10.5E'])
    
    ax.yaxis.set_major_locator(MultipleLocator(10))
    ax.set_yticklabels(['','70.5N','60.5N','50.5N','40.5N'])
    fig = ax.imshow(total_data['SST'+str(year)+'_4'], cmap = plt.cm.hot)

    plt.colorbar(fig)

#plt.show()

#################
# 保存到xls文件 #
#################

writer = pd.ExcelWriter('2000-2018SST.xlsx')		# 写入Excel文件

for year in range(2000,2018):
    for month in range(1,13):
        dataframe = pd.DataFrame(total_data['SST'+str(year)+'_'+str(month)], index=np.arange(70.5,39.5,-1), columns=np.arange(-19.5,11.5,1))

        dataframe.to_excel(writer, str(year)+'-'+str(month), float_format='%.2f')

writer.save()
writer.close()
print('saved to Excel')

#################
# 保存到mat文件 #
#################

io.savemat('2000-2018SST.mat', total_data)         # 写入mat文件
print('saved to mat')