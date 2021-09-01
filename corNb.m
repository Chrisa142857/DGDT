
function [Kcoc HA]=corNb(C,K)
[X,D]=size(C);
ccx=repmat(C,1,1,X);
ccy=permute(ccx,[3 2 1]);
discc=(ccx(:,1,:)-ccy(:,1,:)).^2;
for i=2:D
    discc=discc+(ccx(:,i,:)-ccy(:,i,:)).^2;  
end
dCC=permute(discc,[1 3 2]);
[dCCx,Kcoc]=sort(dCC);
Kcoc=Kcoc(2:1+K,:)';
Kc=zeros(X,D,K);
for i=1:K
    Kc(:,:,i)=C(Kcoc(:,i),:);
end
VkA=permute(Kc-repmat(C,1,1,K),[3 2 1]);
diskc=VkA(:,1,:).^2;
for i=2:D
    diskc=diskc+VkA(:,i,:).^2;
end
Miu0=sqrt(2*pi)^(-1)*exp(-0.5*permute(diskc,[3 1 2]));
xc=repmat([1:X],K,1);
xc=xc(:);
yc=Kcoc';
yc=yc(:);
ha=Miu0';
ha=ha(:);
HA=sparse(xc,yc,ha,X,X);
end
