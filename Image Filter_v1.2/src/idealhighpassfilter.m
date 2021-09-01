%==========================================================================
% Image Processing: Ideal Filter High-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================

function f = idealhighpassfilter(sze, cutoff)
       
    f = 1.0 - ideallowpassfilter(sze, cutoff);
