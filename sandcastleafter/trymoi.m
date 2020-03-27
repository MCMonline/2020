
clc;
clear;

colordef white
grid on
axis equal
view(3)
hold on

%% ��ʼ��
nx=160; %must be divisible by 8
ny=160; %��ʼ��ɳ��
nz=50;

seasurface=10; %��ƽ��
rain=0.1;%ÿ�������������ʪ�ļ���
threshold=0.1; %������͸���ٶȣ�Խ��Խ��͸
initwater =0 ;% ��ʼ��ˮ����

z=zeros(nx,ny,nz);
o=ones(nx,ny,nz);
sand = z;
sandnew = z;
water = rand(nx,ny,nz)<initwater;
waternew = z;
gnd = z ;
gnd(1:nx,1:ny,1:3)=1 ;% the ground line
%     wetlevel=z;
%     wetlevel(:,:,:)=2;%��ʼ������wetlevel

%% ɳ��Ԥ��
%load sandinit.mat %ʹ�ô洢�õ�ɳ��
sand(50:100,50:100,5:50) = 1; %���¹���ɳ������
%% ������ʼ
for i=1:1000
    i  %�����������
    %% ɨ��ķ�ʽ1�����������ڷ���
    p=rand(1,3)<0.5; %margolis neighborhood
        %upper left cell update
    xind = 1+p(1):2:nx-2+p(1);
    yind = 1+p(2):2:ny-2+p(2);
    zind = 1+p(3):2:nz-2+p(3);
    %% ɨ��ķ�ʽ2������������debug
    %     p=mod(i,2); %margolis neighborhood
    %     sand(nx/2,ny/2,nz-4) = 1; %add a grain at the top
    %     %upper left cell update
    %     xind = 1+p:2:nx-2+p;
    %     yind = 1+p:2:ny-2+p;
    %     zind = 1+p:2:nz-2+p;
    %     %randomize the flow -- 10% of the time
    %% ��͸��ʼ��
    %����ʪ���Ƕ�ɳ�������ģ�����ɳ���ƶ����˵ĵط���û����ˮ
    water = sand.*water;
    %%Ѱ�ұ߽�
    xindex = 2:1:nx-1;
    yindex = 2:1:ny-1;
    zindex = 2:1:nz-1;
    height=zeros(nx,ny);
    highestinfo=zeros(nx,ny);
    visit=zeros(nx,ny,nz);
    rrrrand=rand(nx,ny,nz);
    for oo=1:nx
        for ll = 1:ny
            hhhh=1;
            for hh = 1:1:nz
                if sand(oo,ll,hh)==1
                    height(oo,ll)=height(oo,ll)+1;
                    hhhh=hh;
                end
            end
            if i==1
                water(oo,ll,hhhh)=(hhhh<seasurface )| (rand<rain); %��ʼ����ˮ
            else
                water(oo,ll,hhhh)=(hhhh<seasurface );        %���������˶�������ˮ�л��߱�����ʪ����Щ���ӻ�˲��ʪ��Ϊ1
            end
        end
    end
    %% Ԫ���Զ��� water
    waternew(xindex,yindex,zindex)=water(xindex-1,yindex,zindex)+water(xindex+1,yindex,zindex)+water(xindex,yindex-1,zindex)...
        +water(xindex,yindex+1,zindex)+water(xindex,yindex,zindex-1)+water(xindex,yindex,zindex+1);
    water(xindex,yindex,zindex) = water(xindex,yindex,zindex) | ...
        ((waternew(xindex,yindex,zindex))>=1&(rrrrand(xindex,yindex,zindex)<=threshold)&(visit(xindex,yindex,zindex))==0);
    visit(xindex,yindex,zindex) = waternew(xindex,yindex,zindex)>=1;
    
    %% Ԫ���Զ��� sand
    suiji1=rand(length(xind),length(yind),length(zind))< .5 ;
    suiji2 = 1-suiji1;
    suiji3=rand(length(xind),length(yind),length(zind))< .5 ;
    suiji4= 1-suiji3;
    suiji5=rand(length(xind),length(yind),length(zind))<.5;
    suiji6=1-suiji5;
    suiji7=rand(length(xind),length(yind),length(zind))<.5;
    suiji8=1-suiji7;
    
    r=0;t=0;  %E,A
    SUIJI1=suiji1;
    SUIJI2=suiji5;
    A=sand(xind+r,yind+t,zind+1)     ;
    B=sand(xind+mod(t+1,2),yind+r,zind+1)     ;
    C=sand(xind+t,yind+mod(r+1,2),zind+1)     ;
    D=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)     ;
    E=sand(xind+r,yind+t,zind)    ;
    F=sand(xind+mod(t+1,2),yind+r,zind)    ;
    J=sand(xind+t,yind+mod(r+1,2),zind)    ;
    H=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind)    ;
    GA=1-gnd(xind+r,yind+t,zind+1)    ;
    GB=1-gnd(xind+mod(t+1,2),yind+r,zind+1)    ;
    GC=(1-gnd(xind+t,yind+mod(r+1,2),zind+1))    ;
    GD=1-gnd(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)    ;
    
    sandnew(xind+r,yind+t,zind)= ...
        sand(xind+r,yind+t,zind)|(1-sand(xind+r,yind+t,zind))&(((1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,yind+t,zind+1))|...
        (1-A)&(GD&D&H&(GC&C&J|GB&F&B|(1-B)&F&(1-C)&J)|((H&(1-D)|D&(1-H))&(GC&C&J|GB&B&F))|(1-D)&(1-H)&(GC&C&GB&B&F&J&(1-2*SUIJI2)|SUIJI2&(GC&C&J|GB&B&F))));
    
    sandnew(xind+r,yind+t,zind+1)=gnd(xind+r,yind+t,zind+1)&sand(xind+r,yind+t,zind+1)|sand(xind+r,yind+t,zind+1)&(1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,...
        yind+t,zind)&(1-((1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))));
    
    r=1;t=1;  %E,A
    SUIJI1=suiji2;
    SUIJI2=suiji6;
    A=sand(xind+r,yind+t,zind+1)     ;
    B=sand(xind+mod(t+1,2),yind+r,zind+1)     ;
    C=sand(xind+t,yind+mod(r+1,2),zind+1)     ;
    D=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)     ;
    E=sand(xind+r,yind+t,zind)    ;
    F=sand(xind+mod(t+1,2),yind+r,zind)    ;
    J=sand(xind+t,yind+mod(r+1,2),zind)    ;
    H=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind)    ;
    GA=1-gnd(xind+r,yind+t,zind+1)    ;
    GB=1-gnd(xind+mod(t+1,2),yind+r,zind+1)    ;
    GC=(1-gnd(xind+t,yind+mod(r+1,2),zind+1))    ;
    GD=1-gnd(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)    ;
    
    sandnew(xind+r,yind+t,zind)= ...
        sand(xind+r,yind+t,zind)|(1-sand(xind+r,yind+t,zind))&(((1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,yind+t,zind+1))|...
        (1-A)&(GD&D&H&(GC&C&J|GB&F&B|(1-B)&F&(1-C)&J)|((H&(1-D)|D&(1-H))&(GC&C&J|GB&B&F))|(1-D)&(1-H)&(GC&C&GB&B&F&J&(1-2*SUIJI2)|SUIJI2&(GC&C&J|GB&B&F))));
    
    sandnew(xind+r,yind+t,zind+1)=gnd(xind+r,yind+t,zind+1)&sand(xind+r,yind+t,zind+1)|sand(xind+r,yind+t,zind+1)&(1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,...
        yind+t,zind)&(1-((1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))));
    
    r=0;t=1;  %E,A
    SUIJI1=suiji3;
    SUIJI2=suiji7;
    A=sand(xind+r,yind+t,zind+1)     ;
    B=sand(xind+mod(t+1,2),yind+r,zind+1)     ;
    C=sand(xind+t,yind+mod(r+1,2),zind+1)     ;
    D=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)     ;
    E=sand(xind+r,yind+t,zind)    ;
    F=sand(xind+mod(t+1,2),yind+r,zind)    ;
    J=sand(xind+t,yind+mod(r+1,2),zind)    ;
    H=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind)    ;
    GA=1-gnd(xind+r,yind+t,zind+1)    ;
    GB=1-gnd(xind+mod(t+1,2),yind+r,zind+1)    ;
    GC=(1-gnd(xind+t,yind+mod(r+1,2),zind+1))    ;
    GD=1-gnd(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)    ;
    
    sandnew(xind+r,yind+t,zind)= ...
        sand(xind+r,yind+t,zind)|(1-sand(xind+r,yind+t,zind))&(((1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,yind+t,zind+1))|...
        (1-A)&(GD&D&H&(GC&C&J|GB&F&B|(1-B)&F&(1-C)&J)|((H&(1-D)|D&(1-H))&(GC&C&J|GB&B&F))|(1-D)&(1-H)&(GC&C&GB&B&F&J&(1-2*SUIJI2)|SUIJI2&(GC&C&J|GB&B&F))));
    
    sandnew(xind+r,yind+t,zind+1)=gnd(xind+r,yind+t,zind+1)&sand(xind+r,yind+t,zind+1)|sand(xind+r,yind+t,zind+1)&(1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,...
        yind+t,zind)&(1-((1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))));
    
    r=1;t=0;  %E,A
    SUIJI1=suiji4;
    SUIJI2=suiji8;
    A=sand(xind+r,yind+t,zind+1)     ;
    B=sand(xind+mod(t+1,2),yind+r,zind+1)     ;
    C=sand(xind+t,yind+mod(r+1,2),zind+1)     ;
    D=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)     ;
    E=sand(xind+r,yind+t,zind)    ;
    F=sand(xind+mod(t+1,2),yind+r,zind)    ;
    J=sand(xind+t,yind+mod(r+1,2),zind)    ;
    H=sand(xind+mod(r+1,2),yind+mod(t+1,2),zind)    ;
    GA=1-gnd(xind+r,yind+t,zind+1)    ;
    GB=1-gnd(xind+mod(t+1,2),yind+r,zind+1)    ;
    GC=(1-gnd(xind+t,yind+mod(r+1,2),zind+1))    ;
    GD=1-gnd(xind+mod(r+1,2),yind+mod(t+1,2),zind+1)    ;
    
    sandnew(xind+r,yind+t,zind)= ...
        sand(xind+r,yind+t,zind)|(1-sand(xind+r,yind+t,zind))&(((1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,yind+t,zind+1))|...
        (1-A)&(GD&D&H&(GC&C&J|GB&F&B|(1-B)&F&(1-C)&J)|((H&(1-D)|D&(1-H))&(GC&C&J|GB&B&F))|(1-D)&(1-H)&(GC&C&GB&B&F&J&(1-2*SUIJI2)|SUIJI2&(GC&C&J|GB&B&F))));
    
    sandnew(xind+r,yind+t,zind+1)=gnd(xind+r,yind+t,zind+1)&sand(xind+r,yind+t,zind+1)|sand(xind+r,yind+t,zind+1)&(1-gnd(xind+r,yind+t,zind+1))&sand(xind+r,...
        yind+t,zind)&(1-((1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        SUIJI1&(1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(sand(xind+mod(r+1,2),yind+mod(t+1,2),zind+1))|...
        (1-(sand(xind+t,yind+mod(r+1,2),zind+1)))&(1-(sand(xind+t,yind+mod(r+1,2),zind)))&(1-sand(xind+mod(t+1,2),yind+r,zind+1))&(1-sand(xind+mod(t+1,2),yind+r,zind))));
    

    sand=sandnew;
%% ��ͼģ��
    plottime=10; %���Ч�ʣ�ÿplottime�ε�������һ��plot
    if(mod(i,plottime)==0)
        num=1;
        numm=1;
        
        clear sandear;
        %���������Ƭ���������޸� aa bb cc ��ȡֵ��Χ
        for aa=1:nx
            for bb=1:ny
                for cc=1:nz
                    if (sand (aa,bb,cc)~=0)%ɳ�� ��ͼ
                        %if (water (aa,bb,cc)~=0)%ˮ ��ͼ
                        sandear(num,1:3)=[aa,bb,cc];
                        num=num+1;
                    end
                    if (gnd(aa,bb,cc)~=0)
                        gndear(numm,1:3)=[aa,bb,cc];
                        numm=numm+1;
                    end
                end
            end
        end
        clf;
        scatter3(gndear(:,1),gndear(:,2),gndear(:,3),'r','Marker','s')
        hold on;
        scatter3(sandear(:,1),sandear(:,2),sandear(:,3),'.','b')
        xlim([0,nx]);
        ylim([0,ny]);
        zlim([0,nz]);
        axis equal;

        
    end
end