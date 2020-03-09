%% ��ʼ������
clc;
clear;
total = 1000; % ���з�1000���㣬ÿ��x�����Ϊ1
hight = 1; % hight��ʾ��������ʱֻ�о�һ��
vv = 3.66; % �����ٶ�:2.30,3.66,5.81,11.62
r = 0.001; % ɳ���뾶(0.0003~0.0015);
water = 0.35; % ��ˮ����������֮��(0.25~0.42)
% Gamma = 0.0555; % ����ճ��
% Rou = 1230; % �����ܶ�
theta_d = 23.4; % ��Ȼ�ѻ����ȶ���
theta_0 = 28; % ������ʼ�Ƕ�
step = 0.002; % �Ż�����
beta = 392.13/2; % ��ҷ��ϵ��

num_fit = 5; % ��б��ʱ����ƽ���ĵ���

%% ����ɳ��ʪ�ȵ�Ӱ��
yy_total = zeros(total,15); % ����ÿһ��ʪ�ȵ�������
for ww = 1:5
water = 0.22+0.04 * ww;

hh = total*tan(deg2rad(theta_0)); % ɳ�Ѷ��˸߶�

[Vwaterpercent,gamma,tau,rou]=humidity(r);
gamma_effective = min(gamma,tau); % ��Чճ��
Gamma = interp1(Vwaterpercent,gamma_effective,water,'spline');
Rou = interp1(Vwaterpercent,rou,water,'linear');

global point;
point = zeros(total,3,hight); % ��2ά�ֱ��ʾx,y,���� 
point(1:total,1,1) = 1:total; % ��ʼ��x
point(1:total,2,1) = gety(total); % ��x����y����ʼ��ΪԲ��
point(1:total,3,1) = linspace(theta_0,theta_0,total); % ��ǣ��ȣ�

%% ����
delta_fs = [];
Gs = [];
DFs = [];
fcs = [];
for tt = 1:500 %������500��
    
    %�Ż���ʼ
    [GRAVITY,DRAGFORCE] = geogeo(total,hh,vv,theta_d,Rou,beta,num_fit);  %������ƽ���ϳ���Fc��ĺ���
    F = GRAVITY + DRAGFORCE;
    fc = Fc(total,theta_d,r,Gamma);
    delta_f = mage(F(1:total-2,1:3)') - fc(1:total-2);
    
    delta_fs = [delta_fs,delta_f'];
%     Gs(tt,:) = mage(GRAVITY');
%     DFs(tt,:) = mage(DRAGFORCE');
%     fcs(tt,:) = fc(1:total-2);
    
    %steprand = step*rand;
    for x = 1:total-2 % �������˵㣬��Ϊ����û����
        if delta_f(x) > 0 %�������������fc������
            point(x+1,2,1) = max(point(x+1,2,1) - delta_f(x)*step, 0); % y--*(0.7-abs(x-total*1/2)/total)
        end
    end
    point(total,2,1) = 2*point(total-1,2,1)-point(total-2,2,1);
    
    if sum((delta_f(150:200:total)<1))==5
        break
    end
    
end
tt
% plot(1:tt, fcs(:,150:200:total));
% hold off
% plot(1:tt, Gs(:,150:200:total));
% hold off
% plot(1:tt, DFs(:,150:200:total));
% hold off
delta_fs = delta_fs';
plot(1:tt, delta_fs(:,150:200:total));

%% ��ͼ2D
point(1,2,1) = 0;
yy = point(1:total,2,1);
yy_total(1:total,ww) = point(1:total,2,1);

% plot(1:5:total,yy(1:5:total),'r');
% hold on
% original_y = gety(total);
% plot(1:5:total,original_y(1:5:total),'r--');
% for x = 100:150:total
%     text(x-5,yy(x)+5,'x','color','g');
%     text(x+20,yy(x),['(',num2str(x),',',num2str(round(yy(x))),')'],'color','b'); % �������
% end
% hold off

end
%%
%[grid,~] = meshgrid(1:10:total,1:2:15);
%size(grid)
%size(yy_total)
plot(1:10:total,yy_total(1:10:total,1:5));

%% ��ͼ3D
% plot3(1:10:total,point(1:10:total,2,1),zeros(total/10),'r');
% hold on
% plot3(1:10:total,-point(1:10:total,2,1),zeros(total/10),'r'); % ����ԳƵ���һ��
% hold on
% plot3([1,total-9,total-9],[0,0,yy(total-9)],[0,(total-9)/total*hh,0],'r');
% hold on
% plot3([1,total-9,total-9],-[0,0,yy(total-9)],[0,(total-9)/total*hh,0],'r'); % ����
% hold on
% for x = 101:100:total
%     n = min([num_fit,x-1]);
%     delta_yy = (yy(x)-yy(x-1:-1:x-n)')./(1:n); % ������������б��
%     k = -1/mean(delta_yy); % x�㷨��б��
%     b=yy(x)-k*x; % ֱ�߷���
%     x0=-b/k; % ��ؾࣨ��ЧԲ��λ�ã�
%     
%     x0=min(x0,total);
%     plot3([x,x0],[yy(x),0],[0,(x0/total)*hh],'r');
%     hold on
%     plot3([x,x0],-[yy(x),0],[0,(x0/total)*hh],'r'); % ����
%     hold on
% end
% grid on
% hold off