%% ��ʼ������
clc;
clear;
total = 1000; % ���з�1000���㣬ÿ��x�����Ϊ1
hight = 1; % hight��ʾ��������ʱֻ�о�һ�㡣
hh = 500; % �߶�
vv = 0.003;

global point;
point = zeros(total,3,hight); % ��2ά�ֱ��ʾx,y,���� 
point(1:total,1,1) = 1:total; % ��ʼ��x
point(1:total,2,1) = gety(total); % ��x����y����ʼ��ΪԲ��

%% ����
for tt = 1:100  %����100��
    %�����ֵ��������������
    x1 = 0:0.1:total;
    y1 = interp1(point(1:total,1,1),point(1:total,2,1),x1,'spline');
    %�Ż���ʼ
    for x = 1:total
        F = geogeo(x,y1(x*10),y1(x*10+1),hh,vv)  %������ƽ���ϳ���Fc��ĺ���
        if F > Fc %�������������Fc������
            point(x,2,1) = max(point(x,2,1) - 1, 0); % y--
        end
    end 
end    

plot(point (1:total,1,1),point (1:total,2,1));

