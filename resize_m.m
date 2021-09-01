function [Mpoints_resize,Fpoints_resize,minV,maxV]=resize_m(Mpoints,Fpoints)
[M,D]=size(Mpoints);
if D==3
    minz=min(min(Mpoints(:,3)), min(Fpoints(:,3)));
    maxz=max(max(Mpoints(:,3)), max(Fpoints(:,3)));
else
    minz=0;maxz=0;
end
    if minz~=maxz
        a=[min(Mpoints) min(Fpoints)];
        b=[max(Mpoints) max(Fpoints)];
        minV=min(a);
        maxV=max(b);
        Mpoints_resize(:,1)=(Mpoints(:,1)-minV)/(maxV-minV);
        Mpoints_resize(:,2)=(Mpoints(:,2)-minV)/(maxV-minV);
        if D==3
            Mpoints_resize(:,3)=(Mpoints(:,3)-minV)/(maxV-minV);
            Fpoints_resize(:,3)=(Fpoints(:,3)-minV)/(maxV-minV);
        end
        Fpoints_resize(:,1)=(Fpoints(:,1)-minV)/(maxV-minV);
        Fpoints_resize(:,2)=(Fpoints(:,2)-minV)/(maxV-minV);
    else
        a=[min(Mpoints(:,1:2)) min(Fpoints(:,1:2))];
        b=[max(Mpoints(:,1:2)) max(Fpoints(:,1:2))];
        minV=min(a);
        maxV=max(b);
        Mpoints_resize(:,1)=(Mpoints(:,1)-minV)/(maxV-minV);
        Mpoints_resize(:,2)=(Mpoints(:,2)-minV)/(maxV-minV);
        if D==3
            Mpoints_resize(:,3)=zeros(size(Mpoints,1),1);
            Fpoints_resize(:,3)=zeros(size(Fpoints,1),1);
        end
        Fpoints_resize(:,1)=(Fpoints(:,1)-minV)/(maxV-minV);
        Fpoints_resize(:,2)=(Fpoints(:,2)-minV)/(maxV-minV);  
    end    

end