%% 初始化参数
clc;
clear;
total = 1000; % 共切分1000个点，每个x向距离为1
hight = 1; % hight表示层数。暂时只研究一层
vv = 4.5; % 海浪速度:2.30,3.66,5.81,11.62
r = 0.001; % 沙粒半径(0.0003~0.0015);
% water = 0.35; % 含水体积与总体积之比(0.25~0.42)
% Gamma = 0.0555; % 材料粘度
% Rou = 1230; % 材料密度
theta_d = 23.4; % 自然堆积的稳定角
theta_0 = 28; % 迭代初始角度
step = 0.01; % 优化步长
beta = 392.13; % 拖曳力系数

num_fit = 10; % 求斜率时用来平均的点数

hh = total*tan(deg2rad(theta_0)); % 沙堆顶端高度

%% 引入沙子湿度的影响
yy_total = zeros(total,15); % 保存每一个湿度的运算结果
for ww = 1:15
water = 0.27+0.01 * ww;

[Vwaterpercent,gamma,tau,rou]=humidity(r);
gamma_effective = min(gamma,tau); % 有效粘度
Gamma = interp1(Vwaterpercent,gamma_effective,water,'spline');
Rou = interp1(Vwaterpercent,rou,water,'linear');

global point;
point = zeros(total,3,hight); % 第2维分别表示x,y,坐标 
point(1:total,1,1) = 1:total; % 初始化x
point(1:total,2,1) = gety(total); % 由x计算y，初始设为圆形
point(1:total,3,1) = linspace(theta_0,theta_0,total); % 倾角（度）

%% 迭代
for tt = 1:100  %迭代220次
    
    %优化开始
    F = geogeo(total,hh,vv,theta_d,Rou,beta,num_fit);  %求在切平面上除了Fc外的合力
    fc = Fc(total,theta_d,r,Gamma);
    for x = 1:total-2 % 不迭代端点，因为导数没定义
        delta_f = mage(F(x,1:3)) - fc(x);
        %delta_f/fc(x)
        if delta_f > 0 %如果合力超过了fc的上限
            point(x+1,2,1) = max(point(x+1,2,1) - delta_f*step*(0.7-abs(x-total*2/3)/total), 0); % y--
        end
    end
    point(total,2,1) = point(total-1,2,1);
end

%% 画图2D
point(1,2,1) = 0;
%yy = point(1:total,2,1);

% plot(1:5:total,yy(1:5:total),'r');
% hold on
% original_y = gety(total);
% plot(1:5:total,original_y(1:5:total),'r--');
% for x = 100:150:total
%     text(x-5,yy(x)+5,'x','color','g');
%     text(x+20,yy(x),['(',num2str(x),',',num2str(round(yy(x))),')'],'color','b'); % 标记坐标
% end
% hold off

yy_total(1:total,ww) = point(1:total,2,1);
point(total,2,1)
end
%%
[grid,~] = meshgrid(1:10:total,1:2:15);
%size(grid)
%size(yy_total)
plot(grid',yy_total(1:10:total,1:2:15));

%% 画图3D
% plot3(1:10:total,point(1:10:total,2,1),zeros(total/10),'r');
% hold on
% plot3(1:10:total,-point(1:10:total,2,1),zeros(total/10),'r'); % 镜像对称的另一半
% hold on
% plot3([1,total-9,total-9],[0,0,yy(total-9)],[0,(total-9)/total*hh,0],'r');
% hold on
% plot3([1,total-9,total-9],-[0,0,yy(total-9)],[0,(total-9)/total*hh,0],'r'); % 镜像
% hold on
% for x = 101:100:total
%     n = min([num_fit,x-1]);
%     delta_yy = (yy(x)-yy(x-1:-1:x-n)')./(1:n); % 计算若干切线斜率
%     k = -1/mean(delta_yy); % x点法线斜率
%     b=yy(x)-k*x; % 直线方程
%     x0=-b/k; % 横截距（等效圆心位置）
%     
%     x0=min(x0,total);
%     plot3([x,x0],[yy(x),0],[0,(x0/total)*hh],'r');
%     hold on
%     plot3([x,x0],-[yy(x),0],[0,(x0/total)*hh],'r'); % 镜像
%     hold on
% end
% grid on
% hold off