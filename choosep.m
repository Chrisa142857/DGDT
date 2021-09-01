%=======WZQ  2017.07.10==========%
function [in]=choosep(ia,ib,x,y,xi,yi,C,i,iii)
            h1=figure;imshow(ia);hold on
            plot(x(xi,1),x(xi,2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
            title('Source image');
            h2=figure;imshow(ib);hold on
            plot(y(yi,1),y(yi,2),'+','Color','y','MarkerSize',10,'LineWidth',1.5);hold on
            plot(y(yi(iii),1)+ren,y(yi(iii),2),'+','Color','r','MarkerSize',10,'LineWidth',1.5);hold on
            title('Target image');
            [gx,gy,btn] = ginput(1);
            if btn==1
                [t,in]=min((y(yi,1)-gx).^2+(y(yi,2)-gy).^2);
            elseif btn==2
                in=C(xi(i));
            else
                in=0;
            end
            close(h1);close(h2);
end