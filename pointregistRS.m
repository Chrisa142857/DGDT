%=======WZQ  2017.07.13==========%
%  x----source 
%  y----target
function [T,C]=pointregistRS(method,x_re,y_re,PsiS)

if strcmpi(method,'Ours')
    %%%  Ours
    %%%  Parameter :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 opt.xi=2;                    %Don't change
 opt.lambda=8;          %control global preserving
 opt.eta=0;                  %control local preserving
 opt.omega=0.7;            %outlier
 opt.K=5;                     %number of neighbour points
 opt.correspflag=1;      %flag of return correspondence
 opt.max_it=50;          %maximum of iteration
 opt.tol=1e-10;             %Don't change
 opt.iterflag=0;             %show every iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
[C, W, sigma2, iter, T] = DGDT_GRBF(...
    y_re,x_re,PsiS,opt.xi,opt.lambda,opt.max_it,opt.tol,...
    opt.omega,opt.K,opt.correspflag,opt.eta,opt.iterflag...
    );
toc

elseif strcmpi(method,'CPD')
    %%%  CPD    
            opt.method='nonrigid'; % use nonrigid registration
        opt.beta=2;            % the width of Gaussian kernel (smoothness)
        opt.lambda=3;          % regularization weight
        opt.viz=0;              % show every iteration
        opt.outliers=0.3;       % use 0.7 noise weight
        opt.fgt=0;              % do not use FGT (default)
        opt.normalize=1;        % normalize to unit variance and zero mean before registering (default)
        opt.corresp=1;          % compute correspondence vector at the end of registration (not being estimated by default)
        opt.max_it=150;         % max number of iterations
        opt.tol=1e-10;          % tolerance
        tic; 
        [Transform, C]=cpd_register(y_re,x_re, opt);
        toc;
        T=Transform.Y; 

elseif strcmpi(method,'GLMDTPS')
        %%% glmdTPS
         tic;
         [T,m] = GLMD_K(x_re,y_re,5);
         toc; 
         C=zeros(size(x_re,1),1);
         for i=1:size(x_re,1)
            if ~isempty(find(m(i,:)))
                C(i)=find(m(i,:));
            end
         end
end
end