function Fout = geogeo (total,vv,theta_d,beta)

global point;

hh = total*tan(deg2rad(point(1,3,1))); % 沙堆顶端高度

% 球面插值——用于求切线
x1 = 0:0.1:total;
y1 = interp1(point(1:total,1,1),point(1:total,2,1),x1,'spline');

% 预先分配内存以提高运算速率
DRAGFORCE = zeros(total-2,3);
GRAVITY = zeros(total-2,3);

for x = 2:total-1 % 不迭代两端点防止斜率定义有问题
    k = -0.2 / (y1(x*10+1)-y1(x*10-1)); % x点法线斜率
    b=y1(x*10)-k*x; % 直线方程
    x0=-b/k; % 横截距（等效圆心位置）

    if (k > 0)||(k < -100)
        DRAGFORCE(x,1:3) = [0,0,0];
    else
        BC=[0,0,(x0/total)*hh]; 
        AB=[x0-x,-y1(x),0];
        AC=AB+BC; % 竖直切线
        point(x,3,1)=max(rad2deg(asin(mage(AB)/mage(AC))),theta_d); % 更新角度
        AD=[0.2,y1(x*10+1)-y1(x*10-1),0]; % 水平切线
        nn=-cross(AD,AC); % 法向向外
        nn=nn/mage(nn);
        L = mage(AC); % 斜面长度
        heave = dot(nn,[vv,0,0]); % 水流冲击分量大小
        tangent = [vv,0,0]-heave*nn; % 水流切向分量

        DRAGFORCE(x,1:3) = beta * tangent * mage(tangent) * heave; % 拖拽力
    end
    
    G=[0,0,0.8172*L*deg2rad(point(x,3,1)-theta_d)*9.8]; % 重力矢量
    g = dot(nn,G); % 重力法向分量
    
    GRAVITY(x,1:3) = G - g*nn; % 重力切向分量
    
end

Fout = GRAVITY+DRAGFORCE;

end
