function outout = Fc (total,theta_d,r,Gamma)
global point;

outout=zeros(total-2);
for x=2:total-1
    outout(x)=1.2*pi*Gamma*r*cos(deg2rad(theta_d))*(3*0.64/(4*pi*r^3))^(2/3) / (sqrt(6)*deg2rad(point(x,3,1)-theta_d));
end
end