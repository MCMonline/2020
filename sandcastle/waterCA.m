function [] = waterCA()
%% ���ò���
nx = 300;
ny = 50;
h0 = 30;
v0 = 0;
dt_dx = 0.4; % �ṩ���ٺͿ����ݻ�����
dt_dy = dt_dx;
g = 0.02;
% Ԫ����������ֱ�Ϊ
% ����߶�DEM
% ����n
% ˮ��h
% X������M
% Y������N
zerogrid = zeros(nx,ny,5);
water = zerogrid;
[X,Y] = meshgrid(1:nx,1:ny);
water(:,:,1) = 0.5*(25-abs(Y-25))'; % ��ر���״
water(1,:,3) = h0-water(1,:,1);
water(1,:,4) = v0;
water(:,:,2) = 1; % �ڶ���Ϊ1

%% ����
for tt = 1:100
    % ���·�Χ
    xind = 1:nx-1;
    yind = 1:ny-1;
    % �߽�����
    water(1:nx,1,5) = water(1:nx,2,5);
    water(1:nx,ny,5) = water(1:nx,ny-1,5);
    water(1:nx,ny,3) = water(1:nx,ny-1,3);
    water(nx,1:ny,3) = 0;
    % ����ˮ�߸����ٶ�
    delta_M = g*dt_dx*(water(xind,yind,3)+water(xind,yind,1)-water(xind+1,yind,3)-water(xind+1,yind,1)).*water(xind,yind,3) - ...
        g*dt_dx*water(xind,yind,2).*water(xind,yind,4).*sqrt(water(xind,yind,4).^2+water(xind,yind,5).^2)./(water(xind,yind,3).^0.33+0.01);
    delta_N = g*dt_dy*(water(xind,yind,3)+water(xind,yind,1)-water(xind,yind+1,3)-water(xind,yind+1,1)).*water(xind,yind,3) - ...
        g*dt_dy*water(xind,yind,2).*water(xind,yind,5).*sqrt(water(xind,yind,4).^2+water(xind,yind,5).^2)./(water(xind,yind,3).^0.33+0.01);
    water(xind,yind,4) = water(xind,yind,4) + delta_M;
    water(xind,yind,5) = water(xind,yind,5) + delta_N;
    % ���·�Χ
    xind = 2:nx-1;
    yind = 2:ny-1;
    % �����ٶȸ���ˮ��
    water(xind,yind,3) = max(water(xind,yind,3) + ...
        dt_dx*(water(xind-1,yind,4)-water(xind,yind,4)) + ...
        dt_dy*(water(xind,yind-1,5)-water(xind,yind,5)), ...
        0);
        
end
[X,Y] = meshgrid(1:nx,2:ny-1); 
surf(X,Y,(water(1:nx,2:ny-1,3)+water(1:nx,2:ny-1,1))');
% xlim([0,nx]);
% ylim([0,ny]);

end