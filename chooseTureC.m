
function [ind]=chooseTureC(ia,ib,ren,x,y,C,pn,pnumx)
stepx=pnumx/pn;
% stepy=pnumy/pn;
xi=round([1:stepx:pnumx]);
yi=C(xi);
ii=[ia ib];
ind=[xi' zeros(pn,1)];
nn=1;yii=find(yi([1:pn]));iii=[];
for i=1:pn
    figure(1);imshow(ii);hold on
    plot(x(xi(i:pn),1),x(xi(i:pn),2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
    plot(y(yi(yii),1)+ren,y(yi(yii),2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
	plot(y(yi(yii(iii)),1)+ren,y(yi(yii(iii)),2),'+','Color','r','MarkerSize',10,'LineWidth',1.5);hold on
    title('Source image                                             Target image','FontSize',10,'FontWeight','Bold');
    if C(xi(i))~=0
        plot([x(xi(i),1) y(C(xi(i)),1)+ren],[x(xi(i),2) y(C(xi(i)),2)],'Color','r','LineWidth',1.5);hold on
        [tx,ty,btn] = ginput(1);
        if btn==1
            ind(i,2)=C(xi(i));
            iii=[iii;nn];
        elseif btn==2
            in=choosep(ia,ib,x,y,xi,yi(yii),C,i,iii);
            if in~=0
                ind(i,2)=yi(in);
                iii=[iii;find(yi(yii)==yi(in))];
            end
        end
        nn=nn+1;
    else
        plot(x(xi(i),1),x(xi(i),2),'p','Color','r','MarkerSize',10,'LineWidth',1.5);hold on
        [tx,ty,btn] = ginput(1);
        if btn~=1
            in=choosep(ia,ib,x,y,xi,yi(yii),C,i,iii);
            ind(i,2)=yi(in);
            iii=[iii;find(yi(yii)==yi(in))];
        end
    end
    str=sprintf ('%d: source point index: %d - target: %d',i,ind(i,1),ind(i,2));disp(str);
end
results=ind;
save([filee '_source_' file1 'and_target_' file2 '_TUREindex_' num2str(pn) 'featurepoint.mat'],'results');
end
