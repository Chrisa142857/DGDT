function Iout=immontage(Ia,Ib,N)
n=size(Ia,1);
m=size(Ia,2);
stepn=round(n/N);
stepm=round(m/N);
Iout=zeros(n,m,size(Ia,3));
    for i=1:N %stepn
        for j=1:N %stepm
            ns=(i-1)*stepn+1;
            if i*stepn<n
                ne=i*stepn;
            else
                ne=n;
            end               
            ms=(j-1)*stepm+1;
            
            if j*stepm<m
                me=j*stepm;
            else
                me=m;
            end
            if mod(i+j,2)==0   
                Iout(ns:ne,ms:me,:)=Ia(ns:ne,ms:me,:);
            else
                Iout(ns:ne,ms:me,:)=Ib(ns:ne,ms:me,:);
            end
        end        
    end
%     imshow(Iout);
    
end