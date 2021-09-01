function [Mpoints_desize,Fpoints_desize]=desize(Mpoints,Fpoints,minV,maxV)
[M,D]=size(Mpoints);
if D==3
minz=min(min(Mpoints(:,3)), min(Fpoints(:,3)));
maxz=max(max(Mpoints(:,3)), max(Fpoints(:,3)));
else
    minz=0;maxz=0;
end
    if minz~=maxz
        Mpoints_desize(:,1)=Mpoints(:,1)*(maxV-minV)+minV;
        Mpoints_desize(:,2)=Mpoints(:,2)*(maxV-minV)+minV;
        if D==3
            Mpoints_desize(:,3)=Mpoints(:,3)*(maxV-minV)+minV; 
            Fpoints_desize(:,3)=Fpoints(:,3)*(maxV-minV)+minV;
        end
        Fpoints_desize(:,1)=Fpoints(:,1)*(maxV-minV)+minV;
        Fpoints_desize(:,2)=Fpoints(:,2)*(maxV-minV)+minV;  
    else       
        Mpoints_desize(:,1)=Mpoints(:,1)*(maxV-minV)+minV;
        Mpoints_desize(:,2)=Mpoints(:,2)*(maxV-minV)+minV;
        if D==3
            Mpoints_desize(:,3)=zeros(size(Mpoints,1),1);
            Fpoints_desize(:,3)=zeros(size(Fpoints,1),1);
        end
        Fpoints_desize(:,1)=Fpoints(:,1)*(maxV-minV)+minV;
        Fpoints_desize(:,2)=Fpoints(:,2)*(maxV-minV)+minV;
    end
end