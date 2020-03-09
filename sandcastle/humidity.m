function [Vwaterpercent,gamma,tau,rou]=humidity(r)
%% ��������
% Vwaterpercent �����ˮ���ٷ��� ˮ�����/�����
% gamma gamma 
% rou �ܶ�
% phi ���߽ǣ��Ƕȣ����ǵ�������İ��֣���ӱ�����ˮ����������ˮ����Vwaterpercent��������ͼ����������Vwaterpercent
% tau ����ǿ��

%% ����ģ��
netp = 10000;

phi_range = 40:0.1:56;
theta = deg2rad(-20); % �����
KK=70; % gamma = K*F;
r=0.001; % ��ʾɳ�ӵİ뾶
k=0.05; % ��ʾ����ɳ�ӵ�ƽ�����ľ���D=2r(1+k)
rousand=2.6*10^3; % ��ʾɳ�ӵ��ܶ�
rouwater=1.0*10^3; % ˮ���ܶ�

c = 10000; % ����ȡֵΪ10kPa
a1 = deg2rad(26);
a2 = deg2rad(26); % ������ֵΪ��ͬ����µĲ�������ԼΪ26+-10��...
%a1 a2 �������https://wenku.baidu.com/view/65f8f2c35fbfc77da269b11f.html
a = 10000; % �����ֵ��ص����Բ�������ɰ��ԼΪ10kPa
%% ���� gamma
gamma = [];
Vwaterpercent = [];
rou = [];
for t = phi_range
    phi = deg2rad(t);

    p2 = r*(1+k)/sin(phi)-r;
    p1 = cos(phi-theta)*(r+p2)-p2;
    F = (2*pi*r*0.073*cos(phi-theta)*cos(phi) - pi*r^2*(1/p2-1/p1)*0.073*cos(phi)*cos(phi));
    gamma = [gamma, KK*F]; % �ɵ�����KK
    
    %extra_length = max(p2*sin(phi-theta)-r*(1+k-sin(phi)),0); % �������������
    %extra_p = p1*(1-extra_length/(p2*sin(phi-theta)))+p2*extra_length/(p2*sin(phi-theta));
    V1 = 12*(ndefint(phi-theta,p1,p2) - pi/12*r^3*(8-9*sin(phi)-sin(3*phi))); % ˮ�����
    V2 = 4/3*pi*r^3; % ɳ�����
    Vtotal = (4/3*pi*(r*(1+k))^3)/0.64;
    Vwaterpercent = [Vwaterpercent,(V1+V2)/Vtotal];
    rou = [rou,(V1*rouwater+V2*rousand)/Vtotal];
end

%% ������ɳ
attract = a*exp(0.45./Vwaterpercent-2.71828);
tau = c + netp*tan(a1) + attract*tan(a2);
tau = tau*pi*(r*(1+k))^2; % ��ѹǿ����Ϊ��

%plot(phi_range,Vwaterpercent);

% plot(Vwaterpercent,gamma);
% hold on
% plot(Vwaterpercent,tau);
% hold off
plot(Vwaterpercent,min(gamma,tau));
% plot(Vwaterpercent,rou);

end

%% ������ԭ����
function outout=ndefint(pt,p1,p2)
outout = (p2*pi*(3*(4*p1^2 + 8*p1*p2 + 7*p2^2)*...
        sin(pt) + p2*(-12*(p1 + p2)*pt - ...
          6*(p1 + p2)*sin(2*pt) + p2*sin(3*pt))))/12;
end