function theta = gettheta(x,y1,y2,hh)
k = -0.1 / (y2 - y1);  % x��ķ���б��
b = y1 - k * x; % ���߽ؾ�
xx = -b/k;
theta = sqrt(hh^2+(x-xx)^2);
end

