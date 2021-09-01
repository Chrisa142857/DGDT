%==========================================================================
% Image Processing: Ideal Filter High-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function I=IdealHigh(I,cutoff)
 [x y]=size(I);
 I = fftshift(fft2(I));
 f=idealhighpassfilter([x y],cutoff);
 I=f.*I;
 I=ifft2(ifftshift(I));
 I=norm_I(I);
 end