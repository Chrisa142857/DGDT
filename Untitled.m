
% ag=gradient(iatt);bg=gradient(ibtt);
% % figure;imshow(ia);hold on
% % t=zeros(pnumx,255);
% stepx=pnumx/100;xc=round([1:stepx:pnumx]);n=0;
%%%%%%%%%%%%%
y1=[0.2:0.2:0.8];
x1=[0.6 0.6 0.6 0.6];
p1=[x1' y1'];
y2=[0.4 0.6];x2=[0.4 0.4];
p2=[x2' y2'];
r=[1 0 0;0 1 0;1 1 1];
figure;
[c1,c2]=meshgrid([0.2:0.1:0.8]);
cc1=c1(:);cc2=c2(:);
fz=(cc1-0.5).^2;fm=1*pi*std(cc1)^2;
ee=exp(-fz./fm);
fz1=(cc1-0.3).^2;fm1=1*pi*std([0.2:0.1:0.4])^2;
ee1=exp(-fz1(1:21)./fm1);ee1=[ee1;zeros(7,1);-ee1];
e0=reshape(ee,[7 7]);
for i=1:size(cc1,1)
    annotation('arrow',[cc2(i) cc2(i)+0.09*ee(i)],[cc1(i) cc1(i)-0.09*ee1(i)],...
        'headStyle','vback3','HeadLength',15,'HeadWidth',10);
%         annotation('arrow',[cc2(i) cc2(i)+0.09*ee(i)],[cc1(i) cc1(i)],...
%         'headStyle','vback3','HeadLength',15,'HeadWidth',10);
end
plot(p1(:,1),p1(:,2),'.','Color','r','MarkerSize',80);hold on
plot(p2(:,1),p2(:,2),'.','Color','b','MarkerSize',80);hold on
axis([0 1 0 1])
set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
%%%%%%%%%%%%%
% grid on
ii=[ia ib];
pn=100;
stepx=pnumx/pn;
stepy=pnumy/pn;
xi=round([1:stepx:pnumx]);
yi=round([1:stepy:pnumy]);
figure(1);imshow(ii);hold on
% plot(x(662,1),x(662,2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
% plot(y(56,1)+ren,y(56,2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
text(x(662,1)-5,x(662,2)-20,'a','Color','r','FontSize',15,'FontWeight','Bold');hold on
text(y(56,1)+ren-5,y(56,2)-20,'b','Color','r','FontSize',15,'FontWeight','Bold');hold on
for i=1:100
    plot(x([xi pnumx],1),x([xi pnumx],2),'.','Color','b','MarkerSize',10,'LineWidth',1.5);hold on
%     plot(y([yi 56],1)+ren,y([yi 56],2),'.','Color','b','MarkerSize',10,'LineWidth',1.5);hold on
end
plot([x(662,1) y(56,1)+ren],[x(662,2) y(56,2)],'color','r','linewidth',1.5);hold on

figure;bar(xglcm(662,:));xlim([0,300]);
figure;bar(yglcm(56,:));xlim([0,300]);
%%%%%%%%%%%%
ia1t=ia1(round(rem/2):rem,round(ren/2):ren);
iii=[ia1t imadjust(ia1t)];
iii=iii(1:size(iii,1)-5,1:size(iii,2)-5);
iig1=gradient(ia1t);iig2=gradient(imguidedfilter(ia1t));
iig=[iig1 iig2];iig=iig(1:size(iig,1)-5,1:size(iig,2)-5);
st=round(ren/2);igi=[iii;iig];ign=size(igi,2);igm=size(igi,1);
figure(3);imshow(igi);hold on;set (gcf,'Position',[0,1,ign,igm+50]);
title('Before filter             After filter ')
 pos3 = [18+st 16 48 34];
figure(3);rectangle('Position',pos3,'EdgeColor','r','LineWidth',1.5);hold on
 pos1 = [25+st 45 48 22];
figure(3);rectangle('Position',pos1,'EdgeColor','r','LineWidth',1.5);hold on
 pos3 = [35+st 80 64 40];
figure(3);rectangle('Position',pos3,'EdgeColor','r','LineWidth',1.5);hold on
 pos3 = [6+st 56 38 57];
figure(3);rectangle('Position',pos3,'EdgeColor','r','LineWidth',1.5);hold on
 pos3 = [18 16 48 34];
figure(3);rectangle('Position',pos3,'EdgeColor','r','LineWidth',1.5);hold on
 pos1 = [25 45 48 22];
figure(3);rectangle('Position',pos1,'EdgeColor','r','LineWidth',1.5);hold on
 pos3 = [35 80 64 40];
figure(3);rectangle('Position',pos3,'EdgeColor','r','LineWidth',1.5);hold on
pos3 = [6 56 38 57];
figure(3);rectangle('Position',pos3,'EdgeColor','r','LineWidth',1.5);hold on

%%%%%%%%%%%
ii=[ia1 wx];
figure(1);imshow(ii);hold on
 pos = [35 35 30 20];
figure(1);rectangle('Position',pos,'EdgeColor','r','LineWidth',1.5);hold on
plot([x(pnumx,1) x(pnumx,1)-10],[x(pnumx,2)+rem x(pnumx,2)],'color','r','LineWidth',1.5);hold on
plot([x(pnumx,1) x(pnumx,1)+10],[x(pnumx,2)+rem x(pnumx,2)],'color','r','LineWidth',1.5);hold on
%%%%%%%%%%%
x=[0:0.01:10];
y=x.*sin(2*pi*x);
 cc=[];
for i=1:1001
if abs(x(i)-y(i))<=1e-4
cc=[cc;i];
end
end
% figure;plot(x,y,'color','b');hold on
% plot(x,x,'color','k');plot(x(cc),x(cc),'*','color','r','markersize',10,'linewidth',1.2);
% xlabel('x','Fontname','Times new roman');ylabel('y','Fontname','Times new roman');
% hh=legend('y_1=xsin(2\pix)','y_2=x','location','North');
% set(hh,'Fontname','Times new roman');

st1=0;st2=0;st3=0;st4=0;
xs=round(xs);
xsu=round([[xsu.x]' [xsu.y]']);
for i=1:size(x,1)
    if tf1(x(i,2),x(i,1))>=1e-2
        st1=st1+1;
    end
end
for i=1:size(y,1)
    if tf1(y(i,2),y(i,1))>=1e-2
        st2=st2+1;
    end
end
for i=1:size(xs,1)
    if tf1(xs(i,2),xs(i,1))>=1e-2
        st3=st3+1;
    end
end
for i=1:size(xsu,1)
    if tf1(xsu(i,2),xsu(i,1))>=1e-2
        st4=st4+1;
    end
end


