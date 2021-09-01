close all
clear all
%  Parameter :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 opt.thres=1.5;                %threshold of SIFT
 opt.k=1.5;                    %resize image in 1/k times 
 opt.xi=2;                    %Don't change
 opt.lambda=5;          %control global preserving
 opt.eta=3;                  %control local preserving
 opt.omega=0.01;            %outlier 
 opt.K=5;                     %number of neighbour points
 opt.correspflag=1;      %flag of return correspondence     
 opt.max_it=100;          %maximum of iteration 
 opt.tol=1e-10;             %Don't change
 opt.iterflag=1;             %show every iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Ia -> Source image
%Ib -> Target image
%
file1='14_1';
file2='14_2';
Ia=imread([file1 '.jpg']);
Ib=imread([file2 '.jpg']);
% % % run('C:\Program Files\MATLAB\R2016a\toolbox\vlfeat\toolbox\vl_setup')
n=size(Ia,1);
m=size(Ia,2);
k=opt.k;
Ia=imresize(Ia,[n/k m/k]);Ia0=Ia;
Iaa=im2double(Ia);
Ib=imresize(Ib,[n/k m/k]);Ib0=Ib;
Ibb=im2double(Ib);
if size(Ia,3)==3
    Ia0 = rgb2gray(Ia);
end
if size(Ib,3)==3
    Ib0 = rgb2gray(Ib);
end
Ia=imguidedfilter(Ia0);
Ia = sobel_o(Ia);
Ia = adapthisteq(Ia);
Ia=uint8(Ia*255);
%Ia = GAUSS_HIST(Ia,128,48);
% figure;imshow(Ia,[min(min(Ia)) max(max(Ia))]);
Ib=imguidedfilter(Ib0);
Ib = sobel_o(Ib);
Ib = adapthisteq(Ib);
Ib=uint8(Ib*255);
%Ib = GAUSS_HIST(Ib,128,48);
% figure;imshow(Ib,[min(min(Ib)) max(max(Ib))]);
% Ia1 = single(rgb2gray(Ia));
% Ib1 = single(rgb2gray(Ib));
Ia1=single(Ia);Ia1=Ia1./255;
Ib1=single(Ib);Ib1=Ib1./255;
for i=1:size(Ia1,2)
    ina=find(Ia1(:,i)<0.05);
    Ia1(ina,i)=0;
    inb=find(Ib1(:,i)<0.05);
    Ib1(inb,i)=0;
end
%
% Ia1=exp(-Ia1);
% test=exp(-Ia1);
% Ib1=exp(-Ib1);
%
% Ia1=round(Ia1);
% Ib1=round(Ib1);
% test=round(test);
% %
wida=size(Ia1,2);
heia=size(Ia1,1);
widb=size(Ib1,2);
heib=size(Ib1,1);
% SIFT
[fa, da] = vl_sift(Ia1) ;
[fb, db] = vl_sift(Ib1) ;
% [fb, db] = vl_sift(test) ;
[matches, scores] = vl_ubcmatch(da, db,opt.thres); 
Y_SIFT=[fa(1,matches(1,:))' fa(2,matches(1,:))' zeros(size(matches,2),1) da(:,matches(1,:))'];
X_SIFT=[fb(1,matches(2,:))' fb(2,matches(2,:))' zeros(size(matches,2),1) db(:,matches(2,:))'];
Y=[fa(1,matches(1,:))' fa(2,matches(1,:))' zeros(size(matches,2),1) ];
X=[fb(1,matches(2,:))' fb(2,matches(2,:))' zeros(size(matches,2),1) ];
% RSOC
% [X,Y,corr]=RSOC(Ia,Ib);
% x=X;y=Y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % y=[fa(1,:)' fa(2,:)' ];
% figure;imshow(Iaa);hold on;plot(y(:,1),y(:,2),'o','linewidth',2);hold off
% % x=[fb(1,:)' fb(2,:)' ];
% figure;imshow(Ibb);hold on;plot(x(:,1),x(:,2),'o','linewidth',2);hold off
% figure;imshow(test);hold on;plot(x(:,1),x(:,2),'o','linewidth',2);hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOH-SIFT
eha = getEOHDescriptors(Y',Iaa,50);
ehb = getEOHDescriptors(X',Ibb,50);
% eha = getEOHDescriptors(Y',Ia1,50);
% ehb = getEOHDescriptors(X',Ib1,50);
eoha=uint8(512*eha);
eohb=uint8(512*ehb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PsiS 
k1=round(size(matches,2)*1);
k2=round(size(matches,2)*1);
% PsiS=zeros(k1,k2);
PsiS=zeros(k1,k2);
for i = 1:k1
    for j= 1:k2
       PsiS(i,j)= (sum((eoha(:,j)-eohb(:,i)).^2))^0.25;
    end
end
minV=min(min(PsiS));maxV=max(max(PsiS));
for i=1:size(PsiS,2)
    PsiS(:,i)=(PsiS(:,i)-minV)/(maxV-minV);
end
% Y_resize=Y;X_resize=X;
[Y_resize,X_resize,minV,maxV]=resize_m(Y,X);

[C, W, sigma2, iter, T] = DGDT_GRBF(...
    X_resize,Y_resize,PsiS,opt.xi,opt.lambda,opt.max_it,opt.tol,opt.omega,opt.K,opt.correspflag,opt.eta,opt.iterflag...
    );

Transform.W=W;
Transform.sigma2=sigma2;
Transform.iter=iter;
Transform.T=T;

% T=[T zeros(size(T,1),1)];
[Y_desize,X_desize]=desize(T,X_resize,minV,maxV);
Pos1=[Y(:,2) Y(:,1) Y(:,3)];
Pos12=[Y_desize(:,2) Y_desize(:,1) Y_desize(:,3)];
Pos2=[X(:,2) X(:,1) X(:,3)];

% Ia=double(Ia)./255;
% Ib=double(Ib)./255;
I1_warped=tps_warp(Iaa,Pos1,Pos12,'bicubic');

figure;
imshow(Iaa,'border','tight','initialmagnification','fit');title('The Source Image');
set (gcf,'Position',[0,0,wida,heia]);
axis normal;hold on
plot(Pos1(:,2),Pos1(:,1),'o','Color',[1 0 0],'linewidth',2) 
hold on
figure; 
imshow(Ibb,'border','tight','initialmagnification','fit');title('The Target Image');
set (gcf,'Position',[0,0,widb,heib]);
axis normal;hold on
plot(Pos2(:,2),Pos2(:,1),'o','Color',[1 0 0],'linewidth',2) 
hold on
figure;
imshow(I1_warped,'border','tight','initialmagnification','fit');title('The Transformed Image');
set (gcf,'Position',[0,0,widb,heib]);
axis normal;hold on

figure;
imshow(immontage(I1_warped,Ibb,5));
title('Checkboard');

figure;
I=[Iaa Ibb];
dis=size(Ia,2);
imshow(I);hold on; 
plot(Pos1(:,2),Pos1(:,1),'.','Color',[1 0 0],'MarkerSize',3);hold on
plot(Pos2(:,2)+dis,Pos2(:,1),'.','Color',[0 0 1],'MarkerSize',3);hold on
for i=1:size(C,1)
    if (C(i))
        plot([Pos1(C(i),2) Pos2(C(i),2)+dis],[Pos1(C(i),1) Pos2(C(i),1)],'color','r','linewidth',1.5);hold on%TP
    end
end

