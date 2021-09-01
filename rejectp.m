%=======WZQ  2017.07.03==========%
function [x,num]=rejectp(x,s)
[ns,t]=size(s);
[nx,t]=size(x);
xr=repmat(x,1,1,ns);
sr=permute(repmat(s,1,1,nx),[3 2 1]);
dis=(xr-sr).^2;
dis=squeeze(sum(dis,2));
[dis,s0]=min(abs(dis),[],2);
s0=sort(s0);
s1=[];s1=[s1;s0(1)];j=2;
for i=2:size(s0,1)
    if s1(j-1)~=s0(i)
        s1(j)=s0(i);
        j=j+1;
    end
end
[x0,y0]=find(min(abs(dis),2)>1e0);
s=s(s1,:);
x=[x(x0,:);s];
num=length(x0)+length(s1);
end