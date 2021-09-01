close all
clear all
%
%Ia -> Source image
%Ib -> Target image
%
% % % run('C:\Program Files\MATLAB\R2016a\toolbox\vlfeat\toolbox\vl_setup')
pnum=2000;
wh=9;wl=9;
sig2=(wh+1)^2;
op1=0;op2=1;
ia=imread('5.png');
[n,m,d]=size(ia);
ib=imread('5.png');
k=1.5;
ia=im2double(ia);
ib=im2double(ib);
ia=imresize(ia,[n/k m/k]);
ib=imresize(ib,[n/k m/k]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ia=[zeros(size(ia,1),(wh-1)*0.5+1,3) ia zeros(size(ia,1),(wl-1)*0.5+1,3)];
ia=[zeros((wh-1)*0.5+1,size(ia,2),3);ia;zeros((wl-1)*0.5+1,size(ia,2),3)];
ib=[zeros(size(ib,1),(wh-1)*0.5+1,3) ib zeros(size(ib,1),(wl-1)*0.5+1,3)];
ib=[zeros((wh-1)*0.5+1,size(ib,2),3);ib;zeros((wl-1)*0.5+1,size(ib,2),3)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ren=size(ia,2);rem=size(ia,1);
% sig2=ren*rem;
ia1=rgb2gray(ia);
ib1=rgb2gray(ib);
wida=size(ia1,2);
heia=size(ia1,1);
widb=size(ib1,2);
heib=size(ib1,1);
%Harris
iatt=ia1;
% ibtt=ib1;
% iatt=exp(-(imadjust(ia1)));
% tia=round(iatt);
% for i=1:size(iatt,1)
%     ta=find(tia(i,:)==1);
%     iatt(i,ta)=1;
% end
ibtt=exp(-(imadjust(ib1)));
tib=round(ibtt);
for i=1:size(ibtt,1)
    tb=find(tib(i,:)==1);
    ibtt(i,tb)=1;
end
% iatt=1-iatt;
ibtt=1-ibtt;
x=corner(iatt,'MinimumEigenvalue',pnum);
[te1, x]=extractFeatures(iatt,x);
y=corner(ibtt,'MinimumEigenvalue',pnum);
[te2, y]=extractFeatures(ibtt,y);
[fa, da] = vl_sift(single(ia1));
[fb, db] = vl_sift(single(ib1));
xs=[fa(1,:)' fa(2,:)'];
% [x,pnumx]=rejectp(x,xs);
% x=round(x);
ys=[fb(1,:)' fb(2,:)'];
[y,pnumy]=rejectp(y,ys);
y=round(y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;imshow(iat);
% figure;imshow(ibt);
figure;imshow(iatt);figure;imshow(ia);hold on
plot(x(:,1),x(:,2),'o','linewidth',1.5,'color','b');hold off
% figure;imshow(ia);hold on
% plot(xs(:,1),xs(:,2),'o','linewidth',1);hold off
% % % % % figure;imshow(bwareaopen(iat,10));figure;imshow(iat1);
figure;imshow(ibtt);figure;imshow(ib);hold on
plot(y(:,1),y(:,2),'o','linewidth',1.5,'color','b');hold off
% figure;imshow(ib);hold on
% plot(ys(:,1),ys(:,2),'o','linewidth',1);hold off
% % % % % figure;imshow(bwareaopen(ibt,10));figure;imshow(ibt1);
figure;imshow(ia);hold on
plot(xs(:,1),xs(:,2),'o','linewidth',1.5,'color','b');hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Options.upright=true;
Options.tresh=0.0001;
xsu=OpenSurf(ia1,Options);
figure;imshow(ia);hold on
plot([xsu.x],[xsu.y],'o','linewidth',1.5,'color','b');hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  preprocessing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
tx=[];ty=[];
for i=1:pnumx
    if x(i,1)-(wh-1)*0.5<=0 || x(i,2)-(wl-1)*0.5<=0 || x(i,1)+(wh-1)*0.5>size(ia1,2) || x(i,2)+(wl-1)*0.5>size(ia1,1)
        tx=[tx i];
    end
end
for i=1:pnumy
    if y(i,1)-(wh-1)*0.5<=0 || y(i,2)-(wl-1)*0.5<=0 || y(i,1)+(wh-1)*0.5>size(ib1,2) || y(i,2)+(wl-1)*0.5>size(ib1,1)
        ty=[ty i];
    end
end
xc=[1:pnumx];
yc=[1:pnumy];
for i=1:length(tx)
    cc=find(xc-tx(i)==0);
    xc=[xc(1:cc-1) xc(cc+1:pnumx-i+1)];
end
for i=1:length(ty)
    cc=find(yc-ty(i)==0);
    yc=[yc(1:cc-1) yc(cc+1:pnumy-i+1)];
end
pnumx=pnumx-length(tx);
pnumy=pnumy-length(ty);
x=x(xc,:);
y=y(yc,:);
[fa, da] = vl_sift(single(ia1));
[fb, db] = vl_sift(single(ib1));
xs=[fa(1,:)' fa(2,:)'];
ys=[fb(1,:)' fb(2,:)'];
[x,pnumx]=rejectp(x,xs);
[y,pnumy]=rejectp(y,ys);
x=round(x);y=round(y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wx=zeros(wh,wl,pnumx);
wy=zeros(wh,wl,pnumy);
xglcm=[];yglcm=[];tx=[];ty=[];
for i=1:pnumx
%     tic
    x1down=x(i,1)-(wl-1)*0.5;x1up=x(i,1)+(wl-1)*0.5;
    x2down=x(i,2)-(wh-1)*0.5;x2up=x(i,2)+(wh-1)*0.5;
    if x1down<=0
        x1down=1;
%         x1up=2*x(i,1)-1;
    end
    if x2down<=0 
        x2down=1;  
%         x2up=2*x(i,2)-1;
    end
    if x1up>size(ia1,2)
        x1up=size(ia1,2);
%         x1down=2*x(i,1)-size(ia1,2); 
    end
    if x2up>size(ia1,1)
        x2up=size(ia1,1);
%         x2down=2*x(i,2)-size(ia1,1); 
    end
%     wx=ia1(x2down:x2up,x1down:x1up);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x0=x(i,2);y0=x(i,1);
    [X,Y]=meshgrid(1:rem,1:ren);
    dsx=(X'-x0).^2+(Y'-y0).^2;
    gsx=exp(dsx/(-2*sig2));
%     gsx(x2down:x2up,x1down:x1up)=1;
    wx=ia1.*gsx;
%     figure(7);imshow(wx);hold on
%     text()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  RLBP
% tic
    xglcm=[xglcm;rlbp(wx,1,8)];
% toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GLCM
%     glcm=graycoprops(graycomatrix(imadjust(wx),'offset',[op1 op2]));
%      if isempty(find(isnan([glcm.Contrast glcm.Correlation glcm.Energy glcm.Homogeneity])==1))
%          xglcm=[xglcm;[glcm.Contrast...
%             glcm.Correlation...
%             glcm.Energy...
%             glcm.Homogeneity]];
%      else
%          tx=[tx i];
%      end
% toc
end
for i=1:pnumy
    y1down=y(i,1)-(wl-1)*0.5;y1up=y(i,1)+(wl-1)*0.5;
    y2down=y(i,2)-(wh-1)*0.5;y2up=y(i,2)+(wh-1)*0.5;
    if y1down<=0
        y1down=1;
%         y1up=2*y(i,1)-1;
    end
    if y2down<=0 
        y2down=1;  
%         y2up=2*y(i,2)-1;
    end
    if y1up>size(ib1,2)
        y1up=size(ib1,2);
%         y1down=2*y(i,1)-size(ib1,2); 
    end
    if y2up>size(ib1,1)
        y2up=size(ib1,1);
%         y2down=2*y(i,2)-size(ib1,1); 
    end
%     wy=ib1(y2down:y2up,y1down:y1up);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x0=y(i,2);y0=y(i,1);
    [X,Y]=meshgrid(1:rem,1:ren);
    dsy=(X'-x0).^2+(Y'-y0).^2;
    gsy=exp(dsy/(-2*sig2));
    gsy(y2down:y2up,y1down:y1up)=1;
    wy=ib1.*gsy;
%     figure(2);imshow(wy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  RLBP
    yglcm=[yglcm;rlbp(wy,1,8)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GLCM
%     glcm=graycoprops(graycomatrix(imadjust(wy),'offset',[op1 op2]));
%     if isempty(find(isnan([glcm.Contrast glcm.Correlation glcm.Energy glcm.Homogeneity])==1))
%         yglcm=[yglcm;[glcm.Contrast...
%             glcm.Correlation...
%             glcm.Energy...
%             glcm.Homogeneity]];
%     else
%          ty=[ty i];
%     end
end
xc=[1:pnumx];
yc=[1:pnumy];
for i=1:length(tx)
    cc=find(xc-tx(i)==0);
    xc=[xc(1:cc-1) xc(cc+1:pnumx-i+1)];
end
for i=1:length(ty)
    cc=find(yc-ty(i)==0);
    yc=[yc(1:cc-1) yc(cc+1:pnumy-i+1)];
end
pnumx=pnumx-length(tx);
pnumy=pnumy-length(ty);
x=x(xc,:);
y=y(yc,:);

%
% figure(1);imshow(ia1);hold on
% plot(x(:,1),x(:,2),'o','linewidth',2);
% figure(2);imshow(ib1);hold on
% plot(y(:,1),y(:,2),'o','linewidth',2);

% ming=min(min([xglcm;yglcm]));
% maxg=max(max([xglcm;yglcm]));
% for i=1:size(xglcm,2)
%     xglcm(:,i)=(xglcm(:,i)-ming)/(maxg-ming);
% end
% for i=1:size(yglcm,2)
%     yglcm(:,i)=(yglcm(:,i)-ming)/(maxg-ming);
% end

% PsiS=ones(pnumy,pnumx);
PsiS=zeros(pnumy,pnumx);
for i = 1:pnumy
    for j= 1:pnumx
       PsiS(i,j)= sum((xglcm(j,:)-yglcm(i,:)).^2);
    end
end
minp=min(min(PsiS));maxp=max(max(PsiS));
for i=1:size(PsiS,2)
    PsiS(:,i)=(PsiS(:,i)-minp)/(maxp-minp)+1;
end
toc
%%%  Parameter :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 opt.xi=2;                    %Don't change
 opt.lambda=8;          %control global preserving
 opt.eta=0;                  %control local preserving
 opt.omega=0.7;            %outlier
 opt.K=5;                     %number of neighbour points
 opt.correspflag=1;      %flag of return correspondence
 opt.max_it=50;          %maximum of iteration
 opt.tol=1e-10;             %Don't change
 opt.iterflag=0;             %show every iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x_re,y_re,minv,maxv]=resize_m([x zeros(pnumx,1)],[y zeros(pnumy,1)]);
tic
[C, W, sigma2, iter, T] = DGDT_GRBF(...
    y_re,x_re,PsiS,opt.xi,opt.lambda,opt.max_it,opt.tol,opt.omega,opt.K,opt.correspflag,opt.eta,opt.iterflag...
    );
toc
 [t_desize,x_desize]=desize(T,[y zeros(pnumy,1)],minv,maxv);
Pos1=[x(:,2) x(:,1) zeros(pnumx,1)];
Pos12=[t_desize(:,2) t_desize(:,1) t_desize(:,3)];
% Pos12=[];
% for i=1:pnumx
%     if C(i)==0
%         Pos12=[Pos12;[t_desize(i,2) t_desize(i,1) t_desize(i,3)]];
%     else
%         Pos12=[Pos12;[y(C(i),2) y(C(i),1) 0]];
%     end
% end
Pos2=[y(:,2) y(:,1) zeros(pnumy,1)];

I1_warped=tps_warp(ia,Pos1,Pos12,'bicubic');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
imshow(ia,'border','tight','initialmagnification','fit');title('The Source Image');
set (gcf,'Position',[0,1,wida,heia]);
axis normal;hold on
plot(Pos1(:,2),Pos1(:,1),'o','Color',[1 0 0],'linewidth',1) 
hold on
figure; 
imshow(ib,'border','tight','initialmagnification','fit');title('The Target Image');
set (gcf,'Position',[0,1,widb,heib]);
axis normal;hold on
plot(Pos2(:,2),Pos2(:,1),'o','Color',[1 0 0],'linewidth',1) 
hold on
figure;
imshow(I1_warped,'border','tight','initialmagnification','fit');title('The Transformed Image');
set (gcf,'Position',[0,1,widb,heib]);
axis normal;hold on
plot(Pos12(:,2),Pos12(:,1),'o','Color',[1 0 0],'linewidth',1)
hold on

figure;
imshow(immontage(I1_warped,ib,10));
title('Checkboard');

figure;
imshow(round(abs(ib1-rgb2gray(I1_warped))));

figure;
I=[ia ib];
dis=size(ia,2);
imshow(I);hold on;
plot(Pos1(:,2),Pos1(:,1),'o','Color',[0 0 1]);hold on
plot(Pos2(:,2)+dis,Pos2(:,1),'o','Color',[0 0 1]);hold on
for i=1:10:size(C,1)
    if C(i)~=0
        plot([Pos1(i,2) Pos2(C(i),2)+dis],[Pos1(i,1) Pos2(C(i),1)],'color','r','linewidth',1.5);hold on%TP
    %TF
    end
end
i
