%% 
% Topsis�㷨����˼�룺���ڹ�һ�����ԭʼ���ݾ��󣬲������ҷ��ҳ����޷����е����ŷ��������ӷ������ֱ�����������������������ʾ����
% Ȼ��ֱ��������۶��������ŷ��������ӷ�����ľ��룬��ø����۶��������ŷ�������Խӽ��̶ȣ��Դ���Ϊ�������ӵ����ݡ�
% �������룺x����Ҫ���۵Ķ������
%% 

x=[
21584   76.7    7.3 1.01    78.3    97.5    2.0
24372   86.3    7.4 0.80    91.1    98.0    2.0
22041   81.8    7.3 0.62    91.1    97.3    3.2
21115   84.5    6.9 0.60    90.2    97.7    2.9
24633   90.3    6.9 0.25    95.5    97.9    3.6];%����
[n,m]=size(x);
%��3��4��7�ĵ���ָ��ȡ����ת��Ϊ����ָ�겢�Ұ�����ָ�껻�ɽӽ��Ĵ�С
x(:,1)=x(:,1)/100;
x(:,3)=(1./x(:,3))*100;
x(:,4)=(1./x(:,4))*100;
x(:,7)=(1./x(:,7))*100;
zh=zeros(1,m);
d1=zeros(1,n); %��Сֵ����
d2=zeros(1,n); %���ֵ����
c=zeros(1,n);  %�ӽ��̶�
%% ��һ��
%��x����ÿһ����ƽ����
for i=1:m
    for j=1:n
        zh(i)=zh(i)+x(j,i)^2;
    end
end

for i=1:m
    for j=1:n
       x(j,i)=x(j,i)/sqrt( zh(i));
    end
end
%% %�������
xx=min(x);
dd=max(x);
for i=1:n
    for j=1:m
        d1(i)=d1(i)+(x(i,j)-xx(j))^2;
    end
    d1(i)=sqrt(d1(i));
end
for i=1:n
    for j=1:m
        d2(i)=d2(i)+(x(i,j)-dd(j))^2;
    end
    d2(i)=sqrt(d2(i));
end
%% %����ӽ��̶�
for i=1:n
    c(i)=d1(i)/(d2(i)+d1(i));
end
c = c'

