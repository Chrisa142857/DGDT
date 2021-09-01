%==========================================================================
% Image Processing: Ideal Filter Low-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function I=IdealLow(I,cutoff)
 [x y]=size(I);
 I = fftshift(fft2(I));
 f=ideallowpassfilter([x y],cutoff);
 I=f.*I;
 I = uint8((real(ifft2(ifftshift(I)))));
 end