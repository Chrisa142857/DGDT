
function [xglcm,yglcm]=computeLTRSat(x,y,ia1,ib1,pnumx,pnumy,rem,ren,sig2)
xglcm=[];yglcm=[];
for i=1:pnumx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x0=x(i,2);y0=x(i,1);
    [X,Y]=meshgrid(1:rem,1:ren);
    dsx=(X'-x0).^2+(Y'-y0).^2;
    gsx=exp(dsx/(-2*sig2));
    wx=ia1.*gsx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  RLBP
    xglcm=[xglcm;rlbp(wx,1,8)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
for i=1:pnumy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x0=y(i,2);y0=y(i,1);
    [X,Y]=meshgrid(1:rem,1:ren);
    dsy=(X'-x0).^2+(Y'-y0).^2;
    gsy=exp(dsy/(-2*sig2));
    wy=ib1.*gsy;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  RLBP
    yglcm=[yglcm;rlbp(wy,1,8)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end
