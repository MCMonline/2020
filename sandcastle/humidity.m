function [Vwaterpercent,gamma,rou]=humidity(phi)
%% 变量解释
% Vwaterpercent 体积含水量百分数 水的体积/总体积
% gamma gamma 
% rou 密度
% phi 是调整输出的把手，间接表征含水量。真正含水量用Vwaterpercent表针。画图，横坐标用Vwaterpercent
%tau 抗剪强度
%% 调参模块
KK=1;%gamma = K*F^2;
r=0.001; %表示沙子的半径
k=0.55 ; %表示两粒沙子的平均距离D=2k+2r
rousand=1.5; %表示沙子的密度
%% 计算 gamma
p2 =r*(1+k)/sin(phi )-r;
p1 =cos(phi ).*(r+p2 )-p2 ;
F = 2*pi*r*0.073*cos(phi ).*cos(phi )...
    -pi*r^2*cos(phi ).*cos(phi ).*(1./p2 -1./p1 )*0.073;
gamma = KK*F^2;%可调参数KK
%% 计算 rou
V1=6*2*ndefint(p2*sin(phi),p1,p2);%水的体积
V2=4/3*pi*r^3;
rou=V1/(V1+V2*rousand);
%% 计算 Vwaterpercent;
Vwaterpercent = V1/(4/3*pi*(r+k)^3);
end 
%%


%% 
function tau=getceiling(phi,netp)
%% 调参模块
c=10%论文取值为10kPa
a1=deg2rad(26);
a2=deg2rad(26);%这两个值为不同情况下的参数，大约为26+-10，...
%a1 a2 调参详见https://wenku.baidu.com/view/65f8f2c35fbfc77da269b11f.html
a=10;
%% 计算流沙 
[Vwaterpercent,~,~] = humidity(phi);
atract = a*exp(sqrt(Vwaterpercent/45)-2.71828);
tau = c + Np*tan(a1)+atract*tan(a2);
end
%%



%%
function outout=ndefint(x,p1,p2)
%% 定积分原函数
outout=pi* (x* (p1^(2)+2*p1*p2+2*p2^(2))-x *(p1+p2) /sqrt(p2^(2)-x^(2))-p2^(2) *(p1+p2)*atan((x)/(sqrt(p2^(2)-x^(2))))-(x^(3))/(3));
end