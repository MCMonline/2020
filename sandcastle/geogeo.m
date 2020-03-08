function Fout = geogeo (total,hh,vv,theta_d,Rou,beta,num_fit)

global point;

yy = point(1:total,2,1);

% Ԥ�ȷ����ڴ��������������
DRAGFORCE = zeros(total-2,3);
GRAVITY = zeros(total-2,3);

for x = 2:total-1 % ���������˵��ֹб�ʶ���������
    n = min([num_fit,x-1,total-x]);
    delta_yy = (yy(x)-yy(x-1:-1:x-n)')./(1:n); % ������������б��
    k = -1/mean(delta_yy); % x�㷨��б��
    b=yy(x)-k*x; % ֱ�߷���
    x0=-b/k; % ��ؾࣨ��ЧԲ��λ�ã�

    BC=[0,0,(x0/total)*hh]; 
    AB=[x0-x,-yy(x),0];
    AC=AB+BC; % ��ֱ����
    point(x,3,1)=max(rad2deg(acos(mage(AB)/mage(AC))),theta_d); % ���½Ƕ�
    AD=[1,-1/k,0]; % ˮƽ����
    nn=-cross(AD,AC); % ��������
    nn=nn/mage(nn);
    L = mage(AC); % б�泤��
    
    if (k > 0)
        DRAGFORCE(x-1,1:3) = [0,0,0];
    else
        heave = dot(nn,[vv,0,0]); % ˮ�����������С
        tangent = [vv,0,0]-heave*nn; % ˮ���������

        DRAGFORCE(x-1,1:3) = beta * tangent * mage(tangent) * heave / (vv^1.5); % ��ק��
    end
    
    G=[0,0,0.5*Rou*(L/1000)*deg2rad(point(x,3,1)-theta_d)*9.8/cos(deg2rad(theta_d))]; % ����ʸ��
    g = dot(nn,G); % �����������
    
    GRAVITY(x-1,1:3) = G - g*nn; % �����������
    
end

Fout = GRAVITY+DRAGFORCE;

end
