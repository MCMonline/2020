function [Vwaterpercent,gamma,rou]=humidity(phi)
%% ��������
% Vwaterpercent �����ˮ���ٷ��� ˮ�����/�����
% gamma gamma 
% rou �ܶ�
% phi �ǵ�������İ��֣���ӱ�����ˮ����������ˮ����Vwaterpercent���롣��ͼ����������Vwaterpercent
%tau ����ǿ��
%% ����ģ��
KK=1;%gamma = K*F^2;
r=0.001; %��ʾɳ�ӵİ뾶
k=0.55 ; %��ʾ����ɳ�ӵ�ƽ������D=2k+2r
rousand=1.5; %��ʾɳ�ӵ��ܶ�
%% ���� gamma
p2 =r*(1+k)/sin(phi )-r;
p1 =cos(phi ).*(r+p2 )-p2 ;
F = 2*pi*r*0.073*cos(phi ).*cos(phi )...
    -pi*r^2*cos(phi ).*cos(phi ).*(1./p2 -1./p1 )*0.073;
gamma = KK*F^2;%�ɵ�����KK
%% ���� rou
V1=6*2*ndefint(p2*sin(phi),p1,p2);%ˮ�����
V2=4/3*pi*r^3;
rou=V1/(V1+V2*rousand);
%% ���� Vwaterpercent;
Vwaterpercent = V1/(4/3*pi*(r+k)^3);
end 
%%


%% 
function tau=getceiling(phi,netp)
%% ����ģ��
c=10%����ȡֵΪ10kPa
a1=deg2rad(26);
a2=deg2rad(26);%������ֵΪ��ͬ����µĲ�������ԼΪ26+-10��...
%a1 a2 �������https://wenku.baidu.com/view/65f8f2c35fbfc77da269b11f.html
a=10;
%% ������ɳ 
[Vwaterpercent,~,~] = humidity(phi);
atract = a*exp(sqrt(Vwaterpercent/45)-2.71828);
tau = c + Np*tan(a1)+atract*tan(a2);
end
%%



%%
function outout=ndefint(x,p1,p2)
%% ������ԭ����
outout=pi* (x* (p1^(2)+2*p1*p2+2*p2^(2))-x *(p1+p2) /sqrt(p2^(2)-x^(2))-p2^(2) *(p1+p2)*atan((x)/(sqrt(p2^(2)-x^(2))))-(x^(3))/(3));
end