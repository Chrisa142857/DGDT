%=======WZQ  2017.07.10==========%
function [RMSE,MAD,MAE,eve_avg_mat]=chooseL(filee,file1,file2,methodName,pnt,ia,ib,i1_warped)
h=figure;set(h, 'color', [1 1 1]);
axes('position',[.66  0  .33  1]); imshow(ia);hold on;title('Source image','FontSize',10,'FontWeight','Bold');
axes('position',[0  0  .33  1]); imshow(ib);hold on;title('Target image','FontSize',10,'FontWeight','Bold');
axes('position',[.33  0  .33  1]); imshow(i1_warped);hold on;title('Transformation image','FontSize',10,'FontWeight','Bold');
toSave=[filee '_' 'LMark_' file1 '+' file2 '_' num2str(pnt) '_' methodName '.fig'];
saveas(gca,toSave,'fig'); 
sssst=0;
sssstr=0;
sssss=0;
matt1=[];
matt2=[];
matt3=[];
for i=1:pnt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x1,y1,btn] = ginput(1);
    plot(x1,y1,'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
    sssst=sssst+1;
    matt1=[matt1;[x1 y1]];
    text(x1,y1+6,sprintf('%d',sssst),'Color','r','FontSize',10,'FontWeight','Bold');hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x2,y2,btn] = ginput(1);
    plot(x2,y2,'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
    sssstr=sssstr+1;
    matt2=[matt2;[x2 y2]];
    text(x2,y2+6,sprintf('%d',sssstr),'Color','r','FontSize',10,'FontWeight','Bold');hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x3,y3,btn] = ginput(1);
    plot(x3,y3,'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
    sssss=sssss+1;
    matt3=[matt3;[x3 y3]];
    text(x3,y3+6,sprintf('%d',sssss),'Color','r','FontSize',10,'FontWeight','Bold');hold on
    dist=sqrt((x1-x2)^2+(y1-y2)^2);
    eye_dis(sssst,1)=dist;
    str=sprintf('Selected Landmark %d points', sssst);disp(str);
end
RMSE=mean(eye_dis);
MAD=mad(eye_dis,1);
eve_avg_mat=repmat(RMSE,sssstr,1);
MAE=mae(abs(matt1(:,1)-matt2(:,1))+abs(matt1(:,2)-matt2(:,2)));
sst=sprintf('%d',sssst);
sstr=sprintf('%d',sssst);
results=matt1;
save([filee '_' file1 'and' file2 '_target_' sst 'Landmarks.mat'],'results');
results=matt2;
save([filee '_' file1 'and' file2 '_transf_' sst methodName 'Landmarks.mat'],'results');
results=matt3;
save([filee '_' file1 'and' file2 '_source_' sst 'Landmarks.mat'],'results');
close(h);
end
