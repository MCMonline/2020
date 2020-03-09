function [Vwaterpercent,gamma,tau,rou]=humidity(r)
%% 变量解释
% Vwaterpercent 体积含水量百分数 水的体积/总体积
% gamma gamma 
% rou 密度
% phi 切线角（角度）。是调整输出的把手，间接表征含水量。真正含水量用Vwaterpercent表征。画图，横坐标用Vwaterpercent
% tau 抗剪强度

%% 调参模块
netp = 10000;

phi_range = 40:0.1:56;
theta = deg2rad(-20); % 浸润角
KK=70; % gamma = K*F;
r=0.001; % 表示沙子的半径
k=0.05; % 表示两粒沙子的平均球心距离D=2r(1+k)
rousand=2.6*10^3; % 表示沙子的密度
rouwater=1.0*10^3; % 水的密度

c = 10000; % 论文取值为10kPa
a1 = deg2rad(26);
a2 = deg2rad(26); % 这两个值为不同情况下的参数，大约为26+-10，...
%a1 a2 调参详见https://wenku.baidu.com/view/65f8f2c35fbfc77da269b11f.html
a = 10000; % 与进气值相关的土性参数，对砂土约为10kPa
%% 计算 gamma
gamma = [];
Vwaterpercent = [];
rou = [];
for t = phi_range
    phi = deg2rad(t);

    p2 = r*(1+k)/sin(phi)-r;
    p1 = cos(phi-theta)*(r+p2)-p2;
    F = (2*pi*r*0.073*cos(phi-theta)*cos(phi) - pi*r^2*(1/p2-1/p1)*0.073*cos(phi)*cos(phi));
    gamma = [gamma, KK*F]; % 可调参数KK
    
    %extra_length = max(p2*sin(phi-theta)-r*(1+k-sin(phi)),0); % 如果超过两球间距
    %extra_p = p1*(1-extra_length/(p2*sin(phi-theta)))+p2*extra_length/(p2*sin(phi-theta));
    V1 = 12*(ndefint(phi-theta,p1,p2) - pi/12*r^3*(8-9*sin(phi)-sin(3*phi))); % 水的体积
    V2 = 4/3*pi*r^3; % 沙粒体积
    Vtotal = (4/3*pi*(r*(1+k))^3)/0.64;
    Vwaterpercent = [Vwaterpercent,(V1+V2)/Vtotal];
    rou = [rou,(V1*rouwater+V2*rousand)/Vtotal];
end

%% 计算流沙
attract = a*exp(0.45./Vwaterpercent-2.71828);
tau = c + netp*tan(a1) + attract*tan(a2);
tau = tau*pi*(r*(1+k))^2; % 把压强量化为力

%plot(phi_range,Vwaterpercent);

% plot(Vwaterpercent,gamma);
% hold on
% plot(Vwaterpercent,tau);
% hold off
plot(Vwaterpercent,min(gamma,tau));
% plot(Vwaterpercent,rou);

end

%% 定积分原函数
function outout=ndefint(pt,p1,p2)
outout = (p2*pi*(3*(4*p1^2 + 8*p1*p2 + 7*p2^2)*...
        sin(pt) + p2*(-12*(p1 + p2)*pt - ...
          6*(p1 + p2)*sin(2*pt) + p2*sin(3*pt))))/12;
end