%==========================================================================
% Image Processing: Ideal Filter Band-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================


function f = idealbandpassfilter(sze, cutin, cutoff)
    
    
    f = ideallowpassfilter(sze, cutoff) - ideallowpassfilter(sze, cutin);
