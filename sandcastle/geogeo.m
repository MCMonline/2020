function Fout = geogeo (total,vv,theta_d,beta)

global point;

hh = total*tan(deg2rad(point(1,3,1))); % ɳ�Ѷ��˸߶�

% �����ֵ��������������
x1 = 0:0.1:total;
y1 = interp1(point(1:total,1,1),point(1:total,2,1),x1,'spline');

% Ԥ�ȷ����ڴ��������������
DRAGFORCE = zeros(total-2,3);
GRAVITY = zeros(total-2,3);

for x = 2:total-1 % ���������˵��ֹб�ʶ���������
    k = -0.2 / (y1(x*10+1)-y1(x*10-1)); % x�㷨��б��
    b=y1(x*10)-k*x; % ֱ�߷���
    x0=-b/k; % ��ؾࣨ��ЧԲ��λ�ã�

    if (k > 0)||(k < -100)
        DRAGFORCE(x,1:3) = [0,0,0];
    else
        BC=[0,0,(x0/total)*hh]; 
        AB=[x0-x,-y1(x),0];
        AC=AB+BC; % ��ֱ����
        point(x,3,1)=max(rad2deg(asin(mage(AB)/mage(AC))),theta_d); % ���½Ƕ�
        AD=[0.2,y1(x*10+1)-y1(x*10-1),0]; % ˮƽ����
        nn=-cross(AD,AC); % ��������
        nn=nn/mage(nn);
        L = mage(AC); % б�泤��
        heave = dot(nn,[vv,0,0]); % ˮ�����������С
        tangent = [vv,0,0]-heave*nn; % ˮ���������

        DRAGFORCE(x,1:3) = beta * tangent * mage(tangent) * heave; % ��ק��
    end
    
    G=[0,0,0.8172*L*deg2rad(point(x,3,1)-theta_d)*9.8]; % ����ʸ��
    g = dot(nn,G); % �����������
    
    GRAVITY(x,1:3) = G - g*nn; % �����������
    
end

Fout = GRAVITY+DRAGFORCE;

end
