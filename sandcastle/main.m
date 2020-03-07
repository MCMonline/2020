%% 初始化参数
clc;
clear;
total = 1000; % 共切分1000个点，每个x向距离为1
hight = 1; % hight表示层数。暂时只研究一层。
hh = 500; % 高度
vv = 0.003;

global point;
point = zeros(total,3,hight); % 第2维分别表示x,y,坐标 
point(1:total,1,1) = 1:total; % 初始化x
point(1:total,2,1) = gety(total); % 由x计算y，初始设为圆形

%% 迭代
for tt = 1:100  %迭代100次
    %球面插值——用于求切线
    x1 = 0:0.1:total;
    y1 = interp1(point(1:total,1,1),point(1:total,2,1),x1,'spline');
    %优化开始
    for x = 1:total
        F = geogeo(x,y1(x*10),y1(x*10+1),hh,vv)  %求在切平面上除了Fc外的合力
        if F > Fc %如果合力超过了Fc的上限
            point(x,2,1) = max(point(x,2,1) - 1, 0); % y--
        end
    end 
end    

plot(point (1:total,1,1),point (1:total,2,1));

