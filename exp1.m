clear all
close all
filee='Terrace';
file1='2.1';
file2='2';
pn=100;
pnt=20;
methodName='GLMDTPS';%% 'Ours'    'CPD'    'GLMDTPS'
tureC=load([filee '_source_' file1 'and_target_' file2 '_TUREindex_' num2str(pn) 'featurepoint.mat']);
tureC=tureC.results;
%   run('D:\M\toolbox\vlfeat\toolbox\vl_setup')
pnum=2000;
wh=9;wl=9;
sig2=((wh+wl)/2+1)^2;
ia=imread([file1 '.png']);
ib=imread([file2 '.png']);
k=1.5;
[n,m,d]=size(ia);
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
[rem,ren,red]=size(ia);
ia1=rgb2gray(ia);
ib1=rgb2gray(ib);
wida=size(ia1,2);
heia=size(ia1,1);
widb=size(ib1,2);
heib=size(ib1,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select feature points from ia1 and ib1
[x,y,pnumx,pnumy]=selectpRSat(ia1,ib1,pnum);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute LT of two point set x and y
% [xglcm,yglcm]=computeLTRSat(x,y,ia1,ib1,pnumx,pnumy,rem,ren,sig2);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ming=min(min([xglcm;yglcm]));
% maxg=max(max([xglcm;yglcm]));
% for i=1:size(xglcm,2)
% %     ming=min(xglcm(i,:));maxg=max(xglcm(i,:));
%     xglcm(:,i)=(xglcm(:,i)-ming)/(maxg-ming);
% end
% for i=1:size(yglcm,2)
% %     ming=min(yglcm(i,:));maxg=max(yglcm(i,:));
%     yglcm(:,i)=(yglcm(:,i)-ming)/(maxg-ming);
% end
PsiS=zeros(pnumy,pnumx);
% for i = 1:pnumy
%     for j= 1:pnumx
%        PsiS(i,j)= sum((xglcm(j,:)-yglcm(i,:)).^2)+1;
%     end
% end
% minp=min(min(PsiS));maxp=max(max(PsiS));
% for i=1:size(PsiS,2)
%     PsiS(:,i)=(PsiS(:,i)-minp)/(maxp-minp)+1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x_re,y_re,minv,maxv]=resize_m([x zeros(pnumx,1)],[y zeros(pnumy,1)]);
[T,C]=pointregistRS(methodName,x_re,y_re,PsiS);
 [t_desize,x_desize]=desize(T,[y zeros(pnumy,1)],minv,maxv);
Pos1=[x(:,2) x(:,1) zeros(pnumx,1)];
Pos12=[t_desize(:,2) t_desize(:,1) t_desize(:,3)];
Pos2=[y(:,2) y(:,1) zeros(pnumy,1)];
I1_warped=tps_warp(ia,Pos1,Pos12,'bicubic');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chooseTureC(ia,ib,ren,x,y,C,pn,pnumx);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [RMSE,MAD,MAE]=chooseL(filee,file1,file2,methodName,pnt,ia,ib,i1_warped)
% methodName
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
imshow(ia,'border','tight','initialmagnification','fit');title('The Sensed Image');hold on
set (gcf,'Position',[0,1,wida,heia+40]);
plot(Pos1(:,2),Pos1(:,1),'o','Color',[1 0 0],'linewidth',1) 
hold on
toSave=[filee '_sensed_' file1 '_' num2str(pnumx) '+' file2 '_' num2str(pnumy) '_' methodName '.svg'];
saveas(gca,toSave,'svg'); 
%%%%%%%%%%%%%%
figure; 
imshow(ib,'border','tight','initialmagnification','fit');title('The Reference Image');hold on
set (gcf,'Position',[0,1,widb,heib+40]);
plot(Pos2(:,2),Pos2(:,1),'o','Color',[1 0 0],'linewidth',1) 
hold on
toSave=[filee '_reference_' file1 '_' num2str(pnumx) '+' file2 '_' num2str(pnumy) '_' methodName '.svg'];
saveas(gca,toSave,'svg'); 
%%%%%%%%%%%%%%
figure;
imshow(I1_warped,'border','tight','initialmagnification','fit');title('The Transformed Image');hold on
set (gcf,'Position',[0,1,widb,heib+40]);
plot(Pos12(:,2),Pos12(:,1),'o','Color',[1 0 0],'linewidth',1)
hold on
toSave=[filee '_transform_' file1 '_' num2str(pnumx) '+' file2 '_' num2str(pnumy) '_' methodName '.svg'];
saveas(gca,toSave,'svg'); 
%%%%%%%%%%%%%%
figure;nc=7;
immon=immontage(I1_warped,ib,nc);
imshow(immon,'border','tight','initialmagnification','fit');title('Checkboard');
set (gcf,'Position',[0,1,size(immon,2),size(immon,1)+40]);
title('Checkboard');
toSave=[filee '_checkboard' num2str(nc) '_' file1 '_' num2str(pnumx) '+' file2 '_' num2str(pnumy) '_' methodName '.svg'];
saveas(gca,toSave,'svg'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
I=[ia ib];
dis=ren;
imshow(I);hold on;
stepx=pnumx/pn;
xi=round([1:stepx:pnumx]);
fn=0;tn=0;fp=0;tp=0;
for i=1:pn
    if C(xi(i))==0 && tureC(i,2)~=0
        plot([Pos1(xi(i),2) Pos2(tureC(i,2),2)+dis],[Pos1(xi(i),1) Pos2(tureC(i,2),1)],...
            'color','b','linewidth',1.5);hold on%FN
        fn=fn+1;
    elseif C(xi(i))~=0 && C(xi(i))==tureC(i,2)
        plot([Pos1(xi(i),2) Pos2(tureC(i,2),2)+dis],[Pos1(xi(i),1) Pos2(tureC(i,2),1)],...
            'color','y','linewidth',1.5);hold on%TP
        tp=tp+1;
    elseif C(xi(i))~=0 && C(xi(i))~=tureC(i,2)
        plot([Pos1(xi(i),2) Pos2(C(xi(i)),2)+dis],[Pos1(xi(i),1) Pos2(C(xi(i)),1)],...
            'color','b','linewidth',1.5);hold on%FP
        fp=fp+1;
    else
        plot(Pos1(xi(i),2),Pos1(xi(i),1),...
            '+','color','r','linewidth',1.5);hold on%FP
        tn=tn+1;
    end
end
toSave=[filee '_line' num2str(pn) '_' file1 '_' num2str(pnumx) '+' file2 '_' num2str(pnumy) '_' methodName '.svg'];
saveas(gca,toSave,'svg'); 
TN=tn/pnt
TP=tp/pnt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=load([filee '_' file1 'and' file2 '_target_' num2str(pnt) 'Landmarks.mat']);
ys=t.results;
figure;
subplot(1,2,1);imshow(ib);title('The Reference Image');hold on
plot(ys(:,1),ys(:,2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
for i=1:pnt
    text(ys(i,1),ys(i,2)+6,sprintf('%d',i),'Color','r','FontSize',10,'FontWeight','Bold');hold on
end
subplot(1,2,2);imshow(I1_warped);hold on
sssst=0;
matt1=[];
matt2=ys;
for i=1:pnt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x1,y1,btn] = ginput(1);
    plot(x1,y1,'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
    sssst=sssst+1;
    matt1=[matt1;[x1 y1]];
    text(x1,y1+6,sprintf('%d',sssst),'Color','r','FontSize',10,'FontWeight','Bold');hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dist=sqrt((x1-ys(i,1))^2+(y1-ys(i,2))^2);
    eye_dis(sssst,1)=dist;
    str=sprintf('Selected Landmark %d points', sssst);disp(str);
end
RMSE=mean(eye_dis)
MAD=mad(eye_dis,1)
eve_avg_mat=repmat(RMSE,sssst,1);
MAE=mae(abs(matt1(:,1)-matt2(:,1))+abs(matt1(:,2)-matt2(:,2)))
sst=sprintf('%d',sssst);
sstr=sprintf('%d',sssst);
results=matt1;
save([filee '_' file1 'and' file2 '_transf_' sst methodName 'Landmarks.mat'],'results');


