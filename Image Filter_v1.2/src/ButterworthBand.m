%==========================================================================
% Image Processing: Butterworth Filter
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function I=ButterworthBand(I,order,cutin,cutoff)
 [x y]=size(I);
 I = fftshift(fft2(I));
 f=bandpassfilter([x y],cutin,cutoff,order);
 I=f.*I;
 I=ifft2(ifftshift(I));
 I=norm_I(I);
 end