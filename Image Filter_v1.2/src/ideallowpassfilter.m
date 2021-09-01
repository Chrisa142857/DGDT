%==========================================================================
% Image Processing: Ideal Filter Low-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function f = ideallowpassfilter(sze, cutoff)
       
    %  Modification ELEC 301 Project Group, Dec 2001
    %  Original code [rows, cols] = sze was not accepted by Matlab
    rows = sze(1);
    cols = sze(2);
    %  End Alteration

    % X and Y matrices with ranges normalised to +/- 0.5
    x =  (ones(rows,1) * [1:cols]  - (fix(cols/2)+1))/cols;
    y =  ([1:rows]' * ones(1,cols) - (fix(rows/2)+1))/rows;
    
    radius = sqrt(x.^2 + y.^2);        % A matrix with every pixel = radius relative to centre.
    f=zeros(rows,cols);
    for i=1:rows
        for j=1:cols
            if radius(i,j)<=cutoff
            f(i,j)=1;
            else
            f(i,j)=0;
            end
        end
    end
