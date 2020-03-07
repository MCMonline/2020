function outout = gety(inin)
%根据x获得y
for jj=1:inin
    outout(jj)=sqrt(inin^2-(inin-jj)^2);
end
end

