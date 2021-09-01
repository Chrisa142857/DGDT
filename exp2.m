clear all
close all
filee='Terrace';
file1='20.1';
file2='20';
pn=100;
pnt=20;
methodName='SIFT';%% 'SIFT'    'SURF'   
ia=imread([file1 '.png']);
ib=imread([file2 '.png']);
wh=9;wl=9;
k=1.5;   
thres=1;
[n,m,d]=size(ia);
Ia_rsoc=imresize(ia,[n/k m/k]);
Ib_rsoc=imresize(ib,[n/k m/k]);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x,y,Pos1,Pos2]=imgregstRS(ia,ib,single(ia1),single(ib1),Ia_rsoc,Ib_rsoc,thres,methodName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pnumx=size(x,1);pnumy=size(y,1);
I1_warped=tps_warp(ia,Pos1,Pos2,'bicubic');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
plot(Pos2(:,2),Pos2(:,1),'o','Color',[1 0 0],'linewidth',1)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
