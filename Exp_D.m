%======================================================
% Improved Non-rigid ICP Performance by Tang Hao Lin 
%======================================================
%addpath(genpath('Z:\TPS'));

close all
clear all

Times=100;    %loop
file='fish1';  %template%%%%%%%%%%%%%%%%%%%%%%
Results=zeros(Times,8,6,2);
%load source template
Mpoints=load([file,'.mat']);
Mpoints=Mpoints.input;
%Resize
Mpoints(:,1)=(Mpoints(:,1)-min(Mpoints(:,1)))/(max(Mpoints(:,1))-min(Mpoints(:,1)));
Mpoints(:,2)=(Mpoints(:,2)-min(Mpoints(:,2)))/(max(Mpoints(:,2))-min(Mpoints(:,2)));
Mpoints0=Mpoints(2:98,:);
%Set control points
points=[0 0 0;0.5 0 0;1 0 0;1 0.5 0;1 1 0;0.5 1 0;0 1 0;0 0.5 0];

mr0=[];
mr1=[];
mr2=[];
mr3=[];
R_0=[];
R_DGDT1=[];
R_DGDT2=[];
R_DGDT3=[];
for i=1:Times   
    cNum=size(points,1);
    wpoints=points;
    p1=randperm(cNum);
    xx_init=0.2;
    yy_init=0.2;
    i
    for j=1:4
        % Warping template 
%           a=randperm(4);
%             if a(1,1)==1
%                     xx_init=xx_init(1,1);
%                     yy_init=yy_init(1,1);
%             elseif a(1,1)==2
%                     xx_init=-xx_init(1,1);
%                     yy_init=-yy_init(1,1);
%             elseif a(1,1)==3
%                     xx_init=xx_init(1,1);
%                     yy_init=-yy_init(1,1);    
%             elseif a(1,1)==4
%                     xx_init=-xx_init(1,1);
%                     yy_init=yy_init(1,1);
%             end
%         xx=xx_init;
%         yy=yy_init;
%         wpoints(p1(1,j),:)=wpoints(p1(1,j),:)+[xx yy 0];
% 
%         Fpoints=TPS3D(points, wpoints, Mpoints);
         a=randperm(9);
            if a(1,1)==1
                    xx=0.2;
                    yy=0.2;
                    zz=0.2;
            elseif a(1,1)==2
                    xx=-0.2;
                    yy=-0.2;
                    zz=-0.2;
            elseif a(1,1)==3
                    xx=-0.2;
                    yy=-0.2;
                    zz=0.2; 
            elseif a(1,1)==4
                    xx=-0.2;
                    yy=0.2;
                    zz=-0.2; 
             elseif a(1,1)==5
                    xx=0.2;
                    yy=-0.2;
                    zz=-0.2; 
            elseif a(1,1)==6
                    xx=-0.2;
                    yy=0.2;
                    zz=-0.2;  
            elseif a(1,1)==7
                    xx=-0.2;
                    yy=0.2;
                    zz=0.2; 
            elseif a(1,1)==8
                    xx=0.2;
                    yy=-0.2;
                    zz=0.2;    
             elseif a(1,1)==9
                    xx=0.2;
                    yy=0.2;
                    zz=-0.2;                    
            end
        wpoints(p1(1,j),:)=wpoints(p1(1,j),:)+[xx yy zz];
        Fpoints=TPS3D(points, wpoints, Mpoints);
        
        Fpoints=Fpoints(1:97,:);
        sizeF=size(Fpoints,1);
    end
    
        figure; 
        plot(Mpoints(:,1),Mpoints(:,2),'o','color','b','LineWidth',2);hold on;
        axis off; 
        figure;
        plot(Fpoints(:,1),Fpoints(:,2),'o','color','b','LineWidth',2);hold on;
        axis off;
      

% % % % %         Run CPD                    
% % %              Init full set of options %%%%%%%%%%
% % %         opt.method='nonrigid'; % use nonrigid registration
% % %         opt.beta=2;            % the width of Gaussian kernel (smoothness)
% % %         opt.lambda=8;          % regularization weight
% % % 
% % %         opt.viz=0;              % show every iteration
% % %         opt.outliers=0;       % use 0.7 noise weight
% % %         opt.fgt=0;              % do not use FGT (default)
% % %         opt.normalize=1;        % normalize to unit variance and zero mean before registering (default)
% % %         opt.corresp=1;          % compute correspondence vector at the end of registration (not being estimated by default)
% % % 
% % %         opt.max_it=150;         % max number of iterations
% % %         opt.tol=1e-15;          % tolerance
% % %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
        [Transform, C]=cpd_register(Fpoints,Mpoints0, opt);
% %        toc;
%         vx1=Transform.Y; 
%         r=((vx1(:,1)-Fpoints(:,1)).^2+(vx1(:,2)-Fpoints(:,2)).^2+(vx1(:,3)-Fpoints(:,3)).^2);
%         R_CPD=[mean(r) std(r)];
%         m_method='CPD';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f',m_method,j, R_CPD(1,1), R_CPD(1,2));
%         disp (str);
%                  figure(3); 
%          plot(vx1(:,1),vx1(:,2),'+','color','r','LineWidth',2);hold on;
%         plot(Fpoints(:,1),Fpoints(:,2),'o','color','b','LineWidth',2);hold on;
%         axis off; 
%         
%         
%                 % Run GMM  Method
%          Mpoints1=[Mpoints(:,1) Mpoints(:,2)];
%          Fpoints1=[Fpoints(:,1) Fpoints(:,2)];
% %         tic;
%         vx3=GMML2(Mpoints1,Fpoints1);
% %         toc; 
%         vx3=[vx3 zeros(size(vx3,1),1)];
%         r=((vx3(:,1)-Fpoints(:,1)).^2+(vx3(:,2)-Fpoints(:,2)).^2+(vx3(:,3)-Fpoints(:,3)).^2); %restore the error
%         R_GMM=[mean(r) std(r)];
%         m_method='GMMREG';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f',m_method,j, R_GMM(1,1), R_GMM(1,2));
%         disp (str);
%    
        %                    YANG
%         tic;
        [NewMpoints0] = GLMD_K(Mpoints0, Fpoints,5);
%         toc;       
        r0=((NewMpoints0(:,1)-Fpoints(:,1)).^2+(NewMpoints0(:,2)-Fpoints(:,2)).^2+(NewMpoints0(:,3)-Fpoints(:,3)).^2);
        [MF0]=cICP_findneighbours(NewMpoints0,Fpoints);
        mf0=MF0-[1:sizeF]';
        mf0=find(mf0(:)~=0);rr=(sizeF-length(mf0))/sizeF;
        mr0=[mr0;rr];
        R_0=[mean(r0) std(r0)]; 
        m_method='Yang';
        str0 = sprintf ('%s: Degree: %d Mean = %f STD: %f, accuracy: %f',m_method,j,R_0(1,1), R_0(1,2),rr);
        disp (str0);
        
%                  %             Run ours
%       %  tic;
%         %Init full set of options %%%%%%%%%%
%         opt.method='nonrigid'; % use nonrigid registration
%         opt.beta=2;            % the width of Gaussian kernel (smoothness)
%         opt.lambda=15;          % regularization weight
%         opt.eta=2;
%         opt.viz=0;              % show every iteration
%         opt.outliers=0;       % use 0.7 noise weight
%         opt.fgt=0;              % do not use FGT (default)
%         opt.normalize=1;        % normalize to unit variance and zero mean before registering (default)
%         opt.corresp=1;          % compute correspondence vector at the end of registration (not being estimated by default)
%         opt.max_it=100;         % max number of iterations
%         opt.tol=1e-10;          % tolerance 
% %           tic;
%         [Transform, C]=LV_CN(Fpoints, Mpoints0, opt);
% %        toc;
%         vx=Transform.Y; 
%         r=((vx(:,1)-Fpoints(:,1)).^2+(vx(:,2)-Fpoints(:,2)).^2+(vx(:,3)-Fpoints(:,3)).^2);
%         [MF2]=cICP_findneighbours(vx,Fpoints);
%         mf2=MF2-[1:sizeF]';
%         mf2=find(mf2(:)~=0);
%         mr2=[mr2;rr];
%         R_DGDT2=[mean(r) std(r)];
%         m_method='WZQ_DGDT2';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f, accuracy: %f',m_method,j,R_DGDT2(1,1), R_DGDT2(1,2),rr);   
%         disp(str);
        
%         %Wang
%         %tic;
%        [NewMpoints] = AGMReg(Mpoints,Fpoints);
%         %toc;
%         r=((NewMpoints(:,1)-Fpoints(:,1)).^2+(NewMpoints(:,2)-Fpoints(:,2)).^2+(NewMpoints(:,3)-Fpoints(:,3)).^2);
%         R_AGM=[mean(r) std(r)]; 
%         m_method='Wang';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f',m_method,j,R_AGM(1,1), R_AGM(1,2));
%         disp (str);

%           % Ma L2E   Method
% %         tic;
%         [NewMpoints2] = FL2E(Mpoints, Fpoints);
% %         toc; 
%         r4=((NewMpoints2(:,1)-Fpoints(:,1)).^2+(NewMpoints2(:,2)-Fpoints(:,2)).^2+(NewMpoints2(:,3)-Fpoints(:,3)).^2);
%         R_FL2E=[mean(r4) std(r4)]; 
%         m_method='Ma¡¡JiaYi 2';
%         str4 = sprintf ('%s: Degree: %d Mean = %f STD: %f',m_method,j,R_FL2E(1,1), R_FL2E(1,2));
%         disp (str4);  
        
% %              %MA  GLS   Method
%         %Init full set of options %%%%%%%%%%
%         opt1.outliers = 0.2;
%         opt1.viz = 0;
%         opt1.t = 0.9;
%         opt1.sparse = 1;
%         opt1.nsc = 5;
%         opt1.normalize = 1;
%         opt1.beta = 2;
%         opt1.lambda = 3;
%         opt.max_it=100;
%         opt1.tol = 1e-15;
%       % tic;
%         [Transform, C] = prgls_register(Fpoints, Mpoints,opt1);
%       % toc;       
%         vx1=Transform.Y; 
%         r=((vx1(:,1)-Fpoints(:,1)).^2+(vx1(:,2)-Fpoints(:,2)).^2+(vx1(:,3)-Fpoints(:,3)).^2);
%      
%         R_PRGLS=[mean(r) std(r)]; 
%         m_method='Ma_PRGLS';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f',m_method,j,R_PRGLS(1,1), R_PRGLS(1,2));   
%         disp (str);
%         figure(4); 
%         plot(vx1(:,1),vx1(:,2),'+','color','r','LineWidth',2);hold on;
%         plot(Fpoints(:,1),Fpoints(:,2),'o','color','b','LineWidth',2);hold on;
%         axis off; 

% %                       Run DGDT(WZQ)
%         %Init full set of options %%%%%%%%%%
%         opt.max_it=50;
%         opt.K=5;
%         opt.outlier=0.01;
%         opt.alphac=8;
%         opt.eta=5;
%         opt.lambda=3;
%         opt.xi=2;
%         opt.tol=1e-3;
%         opt.itershow=0;
%         opt.lambdaM=100;
%       % tic;
%         [Parameter, vx] = DGDT(Mpoints,Fpoints,opt);
%         r=((vx(:,1)-Fpoints(:,1)).^2+(vx(:,2)-Fpoints(:,2)).^2+(vx(:,3)-Fpoints(:,3)).^2);
%         [MF1]=cICP_findneighbours(vx,Fpoints);
%         mf1=MF1-[1:sizeF]';
%         mf1=find(mf1(:)~=0);rr=(sizeF-length(mf1))/sizeF;
%         mr1=[mr1;rr];
%         R_DGDT1=[R_DGDT1;mean(r) std(r)]; 
%         m_method='WZQ_DGDT1';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f, accuracy: %f',m_method,j,R_DGDT(1,1), R_DGDT(1,2),rr);   
%         disp(str);
        
% %% WIN        %                       Run DGDT(WZQ)
%         %Init full set of options %%%%%%%%%%
%         opt.max_it=20;
%         opt.K=5;
%         opt.outlier=0.01;
%         opt.alphac=8;
%         opt.eta=5;
%         opt.lambda=3;
%         opt.xi=2;
%         opt.tol=1e-3;
%         opt.itershow=1;
%         opt.lambdaM=50;
%       % tic;
%         [Parameter, vx] = DGDT(Mpoints0,Fpoints,opt);
%         r=((vx(:,1)-Fpoints(:,1)).^2+(vx(:,2)-Fpoints(:,2)).^2+(vx(:,3)-Fpoints(:,3)).^2);
%         [MF2]=cICP_findneighbours(vx,Fpoints);rrr=max(Parameter.P,[],2);
%         mf2=MF2-[1:sizeF]';mrrr=rrr-[1:sizeF]';
%         mf2=find(mf2(:)~=0);rr=(sizeF-length(mf2))/sizeF;
%         mrrr=find(mrrr(:)~=0);mmrr=(sizeF-length(mrrr))/sizeF
%         mr2=[mr2;rr];
%         R_DGDT2=[mean(r) std(r)]; 
%         m_method='WZQ_DGDT2';
%         str = sprintf ('%s: Degree: %d Mean = %f STD: %f, accuracy: %f',m_method,j,R_DGDT2(1,1), R_DGDT2(1,2),rr);   
%         disp(str);
%%       
        %                       Run DGDT(WZQ)
        %Init full set of options %%%%%%%%%%
 opt.xi=2;
 opt.lambda=15;
 opt.eta=2;
 opt.omega=0;
 opt.correspflag=1;          
 opt.max_it=100;        
 opt.tol=1e-10;
 opt.iterflag=0;
      % tic;
        [Transform,C] = DGDT(Fpoints,Mpoints0,opt);
        vx=Transform.T;
        r=((vx(1:96,1)-Fpoints(2:97,1)).^2+(vx(1:96,2)-Fpoints(2:97,2)).^2+(vx(1:96,3)-Fpoints(2:97,3)).^2);
        rr=C-[2:98]';mf=(97-length(find(rr~=0)))/97;
        R_DGDT=[mean(r) std(r)]; 
        m_method='DGDT';
        str = sprintf ('%s: Degree: %d Mean = %f STD: %f,  %f',m_method,j,R_DGDT(1,1), R_DGDT(1,2),mf);   
        disp(str);
%         if rr~=1
%             pause
%         end
        
         
%              
%              Results(i,j,1,:)=R_CPD;
%              Results(i,j,2,:)=R_GMM;         
%              Results(i,j,3,:)=R_0;    
% %              Results(i,j,4,:)=R_AGM; 
%              Results(i,j,4,:)=R_FL2E;
%              Results(i,j,5,:)=R_PRGLS;
%              Results(i,j,6,:)=R_DGDT;                 
% %                 
%     fprintf('\n');
%     sp=[file,'D_DGDTtest2.mat']; 
%     savefile=[sp];
%     save(savefile,'Results');  
    end
% end
mean(mr0)
mean(R_0,1)
mean(mr1)
mean(R_DGDT1,1)
mean(mr2)
mean(R_DGDT2,1)
mean(mr3)
mean(R_DGDT3,1)



