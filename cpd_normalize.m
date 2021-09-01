
function  [X, Y, normal] =cpd_normalize(x,y)
if nargin<2, 
    error('cpd_normalize error! Not enough input parameters.'); 
end
n=size(x,1);
m=size(y,1);
normal.xd=mean(x);
normal.yd=mean(y);
x=x-repmat(normal.xd,n,1);
y=y-repmat(normal.yd,m,1);
normal.xscale=sqrt(sum(sum(x.^2,2))/n);
normal.yscale=sqrt(sum(sum(y.^2,2))/m);
X=x/normal.xscale;
Y=y/normal.yscale;
end



