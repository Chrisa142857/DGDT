
function  [C,W,sigma2,iter,T,alpha] =DGDT_GRBF(...
    	X,Y,PsiS,beta,lambda,max_it,tol,outliers,K,corresp,eta,iterflag...
    )

% get the dimension of the point set
[N, D]=size(X); [M, D]=size(Y);

% Initialization
T=Y; iter=0;  ntol=tol+10; 
W=zeros(M,D);
% W=Y;
if ~exist('sigma2','var') || isempty(sigma2) || (sigma2==0), 
   sigma2=(M*trace(X'*X)+N*trace(Y'*Y)-2*sum(X)*sum(Y)')/(M*N*D);
%    sigma2=15;
end

% Construct affinity matrix G
aax=repmat(Y,1,1,M);
aay=permute(aax,[3 2 1]);
disaa=(aax(:,1,:)-aay(:,1,:)).^2;
for i=2:D
    disaa=disaa+(aax(:,i,:)-aay(:,i,:)).^2;  
end
dAA=permute(disaa,[1 3 2]);
G=exp(-0.5*beta^(-2)*dAA);

iter=0; ntol=tol+10; L=1;
[Nm]=corNb(X,K);
[Nf]=corNb(T,K);

while  (ntol > tol) && (iter<max_it) && (sigma2 > 1e-8)  
% function of annealing scheme 
% ============================================
% if flag~=0,            
alpha=exp(-iter/10);        %method 1 How to determine the annealing function?
% else 
%     alpha=0;
% end
%  =======================================
%              if alpha~=0                   % method 2
% % %           alpha=sqrt(0.0625-iter^2/3600);
%         alpha=real(1*(1-iter/15));        
% %             alpha=exp(-iter/15);
%         else
%             alpha=0;           
%              end
tao=((max_it^4-iter^4+1)^0.25)/max_it;
lambda=tao*lambda;
eta=tao*eta;

% computing the local representor
              [xvextor]=Neib(X,Nm,min(PsiS,[],2));
              [yvextor]=Neib(T,Nf,min(PsiS,[],1));
          
% update the new coordinates by mixing global and local feature         
          newX=X+alpha*xvextor;
          newT=T+alpha*yvextor;

%           xs1=sum(X_SIFT(:,4:67).^2,2);xs2=sum(X_SIFT(:,68:131).^2,2);
%           ys1=sum(Y_SIFT(:,4:67).^2,2);ys2=sum(Y_SIFT(:,68:131).^2,2);
%           newX=[xs1.*newX(:,1) xs2.*newX(:,2) newX(:,3)];
%           newT=[ys1.*newT(:,1) ys2.*newT(:,2) newT(:,3)];
          
% to make all coordinates locate in interval (-1,1)        
%      [newX,newT,normal]=cpd_normalize(newX,newT);   
 
% record the loop     
    L_old=L;
    
    %E-step. Eastimate the correspondence   ,PsiS
%     [P1,Pt1, PX, L, P]=cpd_P(X,T,newX,newT,PsiS,sigma2,outliers); %%  Source x Target
[P, P1, Pt1, PX, L]=compute_P(newX(:,1:2),newT(:,1:2),PsiS,sigma2,outliers,iter); %%  Source x Target
%     [P1,Pt1, PX, L, P]=cpdTESP(X,T,newX,newT,sigma2,outliers);
if D==3
    PX=[PX zeros(size(PX,1),1)];
end
    tin=1e-300;
    tin=ones(M,D).*tin;
    mic=P1;
    b=(mic * ones(1,D)+tin); 
    vX=PX./ b; 
    
    [Nmv, Rx]=corNb(vX,K);
    [Nf, Ry]=corNb(T,K);
    
    Q=(Rx-K*eye(M))*vX-(Ry-K*eye(M))*(T+G*W);
    
    L=L+lambda/2*trace(W'*G*W)+eta/2*trace(Q*Q');
   
    ntol=abs((L-L_old)/L);

    % M-step. Solve linear system for W.
    A=2*K*Rx-2*Ry'*Rx+2*K*Ry'-2*K*K*eye(M);
    B=2*(Ry')*Ry-2*K*Ry-2*K*Ry'+2*K*K*eye(M);
    
    dP=spdiags(P1,0,M,M); % precompute diag(P)
%     W=(dP*G+lambda*sigma2*eye(M)+sigma2*eta*B*G)\...
%         (PX-dP*Y-sigma2*eta*A*vX-sigma2*eta*B*Y);
    W=pinv(dP*G+lambda*sigma2*eye(M)+sigma2*eta*B*G)*...
        (PX-dP*Y-sigma2*eta*A*vX-sigma2*eta*B*Y);
 
    %     W=(dP*G+lambda*sigma2*eye(M))\(PX-dP*Y);
    
    % update Y postions
    
    T=Y+G*W;
    
    Np=sum(P1);
    sigma2save=sigma2;
    sigma2=abs((sum(sum(X.^2.*repmat(Pt1,1,D)))+...
        sum(sum(T.^2.*repmat(P1,1,D))) -2*trace(PX'*T)) /(Np*D));
    iter=iter+1;
    
%     % Plot the result on current iteration
    if iterflag==1
        figure(1);
        plot(T(:,1),T(:,2),'+','color','r','linewidth',2);hold on
        plot(Y(:,1),Y(:,2),'+','color','y');hold on
        plot(X(:,1),X(:,2),'o','color','b','linewidth',2);hold on
        for i=1:M
            pcc.y=find(P(i,:)>=0.75);
            [test, pc]=max(P(i,:));
            plot([T(i,1) X(pc,1)],[T(i,2) X(pc,2)],'color','r','linewidth',1.5);hold on
            for j=1:size(pcc.y,2)
                plot([T(i,1) X(pcc.y(j),1)],[T(i,2) X(pcc.y(j),2)],'color','y');hold on
            end
        end
        figure(1);hold off
        pause(0.001);
    end
     outliers = 1 - Np/N; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if outliers>0.99
        outliers = 0.99;
    elseif outliers<0.01
        outliers = 0.01;
    end
end

% disp('CPD registration succesfully completed.');

%Find the correspondence, such that Y corresponds to X(C,:)
if corresp, C=cpd_Pcorrespondence(X,T,sigma2save,outliers); else C=0; end;
C=zeros(M,1);
for i=1:M
    if P1(i)>=0.75
        [test, C(i)]=max(P(i,:));
    else
        C(i)=0;
    end
end
% P=lap_wrapper(P*1e+6,1e+9);
% P1 = P*ones(N,1);
% Pt1 = P'*ones(M,1);
% PX = P*X;
%     tin=1e-300;
%     tin=ones(M,D).*tin;
%     mic=P1;
%     b=(mic * ones(1,D)+tin); 
% vX=PX./ b; 
% [Nmv, Rx]=corNb(vX,K);
% [Nf, Ry]=corNb(T,K);
% A=2*K*Rx-2*Ry'*Rx+2*K*Ry'-2*K*K*eye(M);
% B=2*(Ry')*Ry-2*K*Ry-2*K*Ry'+2*K*K*eye(M);
% dP=spdiags(P1,0,M,M);
% W=pinv(dP*G+lambda*sigma2*eye(M)+sigma2*eta*B*G)*...
%         (PX-dP*Y-sigma2*eta*A*vX-sigma2*eta*B*Y);
%     T=Y+G*W;
%     
%     C=zeros(M,1);
% for i=1:M
%     if P1(i)==1
%         [test, C(i)]=max(P(i,:));
%     else
%         C(i)=0;
%     end
% end
