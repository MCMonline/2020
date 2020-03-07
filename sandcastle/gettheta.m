function theta = gettheta(x,y1,y2,hh)
k = -0.1 / (y2 - y1);  % x点的法线斜率
b = y1 - k * x; % 垂线截距
xx = -b/k;
theta = sqrt(hh^2+(x-xx)^2);
end

