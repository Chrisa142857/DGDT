%==========================================================================
% Image Processing: Normalization
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function I = norm_I(I)
I_max=max(max(I));
I_min=min(min(I));
I=(I-I_min)./(I_max-I_min);
end