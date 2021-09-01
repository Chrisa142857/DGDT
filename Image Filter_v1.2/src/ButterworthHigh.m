%==========================================================================
% Image Processing: Butterworth Filter High-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function I=ButterworthHigh(I,order,cutoff)
 [x y]=size(I);
 I = fftshift(fft2(I));
 f=highpassfilter([x y],cutoff,order);
 I=f.*I;
 I=ifft2(ifftshift(I));
 I=norm_I(I);
 end