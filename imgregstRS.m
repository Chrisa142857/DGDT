%=======WZQ  2017.07.14==========%
%  a----source 
%  b----target
function [Mpoints,Fpoints,Pos1,Pos2,corr]=imgregstRS(Ia,Ib,Ia1,Ib1,Ia_rsoc,Ib_rsoc,thres,method)
if strcmpi(method,'SIFT')

[fa, da] = vl_sift(Ia1) ;
[fb, db] = vl_sift(Ib1) ;
[matches, scores] = vl_ubcmatch(da, db,thres) ; %matches是2xM的矩阵，matches（1，M）与matches（2，M)是对应点的序号
Mpoints_SIFT=[fa(1,matches(1,:))' fa(2,matches(1,:))' zeros(size(matches,2),1) da(:,matches(1,:))'];%每个关键点有三个信息：位置、尺度、方向
Fpoints_SIFT=[fb(1,matches(2,:))' fb(2,matches(2,:))' zeros(size(matches,2),1) db(:,matches(2,:))'];
Mpoints=[fa(1,matches(1,:))' fa(2,matches(1,:))' zeros(size(matches,2),1) ];
Fpoints=[fb(1,matches(2,:))' fb(2,matches(2,:))' zeros(size(matches,2),1) ];
Pos1=[Mpoints(:,2) Mpoints(:,1) Mpoints(:,3)]; 
Pos2=[Fpoints(:,2) Fpoints(:,1) Fpoints(:,3)];
corr=[1:sizeof(Pos1)];

elseif strcmpi(method,'SURF')
    
[Mpoints,Fpoints]=SURF(Ia,Ib);
Pos1=[Mpoints(:,1) Mpoints(:,2) zeros(size(Mpoints,1),1)];
Pos2=[Fpoints(:,1) Fpoints(:,2) zeros(size(Fpoints,1),1)];
corr=[1:size(Pos1,2)];
    
elseif strcmpi(method,'RSOC')
    
[Mpoints,Fpoints,corr]=RSOC(Ia_rsoc,Ib_rsoc);
Mpoints=Mpoints';
Fpoints=Fpoints';
Pos1=[Mpoints(:,2) Mpoints(:,1) zeros(size(Mpoints,1),1)]; 
Pos2=[Fpoints(:,2) Fpoints(:,1) zeros(size(Fpoints,1),1)];
    
end
end