function [GRAVITY,DRAGFORCE] = geogeo (total,hh,vv,theta_d,Rou,beta,num_fit)

global point;

yy = point(1:total,2,1);

% 预先分配内存以提高运算速率
DRAGFORCE = zeros(total-2,3);
GRAVITY = zeros(total-2,3);

for x = 2:total-1 % 不迭代两端点防止斜率定义有问题
    n = min([num_fit,x-1,total-x]);
    delta_yy = (yy(x)-yy(x-1:-1:x-n)')./(1:n); % 计算若干切线斜率
    k = -1/mean(delta_yy); % x点法线斜率
    b=yy(x)-k*x; % 直线方程
    x0=-b/k; % 横截距（等效圆心位置）

    BC=[0,0,(x0/total)*hh]; 
    AB=[x0-x,-yy(x),0];
    AC=AB+BC; % 竖直切线
    point(x,3,1)=max(rad2deg(acos(mage(AB)/mage(AC))),theta_d); % 更新角度
    AD=[1,-1/k,0]; % 水平切线
    nn=-cross(AD,AC); % 法向向外
    nn=nn/mage(nn);
    L = mage(AC); % 斜面长度
    
    if (k > 0)
        DRAGFORCE(x-1,1:3) = [0,0,0];
    else
        tangent = AD*dot(AD,[vv,0,0])/(mage(AD)^2); % 水流切向分量
        %heave = dot(nn,[vv,0,0]); % 水流冲击分量大小
        heave = mage([vv,0,0]-tangent);

        DRAGFORCE(x-1,1:3) = beta * tangent * mage(tangent) * heave / (vv^1.5); % 拖拽力
    end
    
    G = [0,0,0.5*Rou*(0.5*L/total)*sin(deg2rad(point(x,3,1)-theta_d))*9.8/cos(deg2rad(theta_d))]; % 重力矢量
    g = dot(nn,G); % 重力法向分量
    
    GRAVITY(x-1,1:3) = G - g*nn; % 重力切向分量
    
end

end
