%%=======WZQ  2017.07.13==========%
function [x,y,pnumx,pnumy]=selectpRSat(ia1,ib1,pnum)
iatt=exp(-(imadjust(ia1)));
ibtt=exp(-(imadjust(ib1)));
tia=round(iatt);
tib=round(ibtt);
for i=1:size(iatt,1)
    ta=find(tia(i,:)==1);
    iatt(i,ta)=1;
end
for i=1:size(ibtt,1)
    tb=find(tib(i,:)==1);
    ibtt(i,tb)=1;
end
x=corner(iatt,'MinimumEigenvalue',pnum);
y=corner(ibtt,'MinimumEigenvalue',pnum);
[te1, x]=extractFeatures(iatt,x);
[te2, y]=extractFeatures(ibtt,y);
[fa, da] = vl_sift(single(ia1));
[fb, db] = vl_sift(single(ib1));
xs=[fa(1,:)' fa(2,:)'];
ys=[fb(1,:)' fb(2,:)'];
[x,pnumx]=rejectp(x,xs);
[y,pnumy]=rejectp(y,ys);
x=round(x);y=round(y);
end
