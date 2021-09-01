%=======WZQ  2017.05.13==========%
%compute local vector VkC
function [FC,VkC]=Neib(C,Kcoc,outs)
K=size(Kcoc,2);
[X,D]=size(C);
Kc=zeros(X,D,K);
for ii=1:K
    Kc(:,:,ii)=C(Kcoc(:,ii),:);
end
VkC=permute(Kc-repmat(C,1,1,K),[3 2 1]);
%%%%%%%%%%%%%%%%%%%%%%%%
diskc=VkC(:,1,:).^2;
for i=2:D
    diskc=diskc+VkC(:,i,:).^2;
end
DD=permute(diskc,[3 1 2]);
sD=repmat(sum(DD,2),1,K);
DD=DD-sD;
Miu0=sqrt(2*pi)^(-1)*exp(-0.5*DD);
%%%%%%%%%%%%%%%%%%%%%%%%
% Miu0=zeros(X,K);
% for i=1:X
%     for j=1:K
%             Miu0(i,j)=outs(Kcoc(i,j));
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%
Miu=permute(repmat(Miu0,1,1,D),[2 3 1]);
FC=permute(sum(Miu.*VkC),[3 2 1]);
end

