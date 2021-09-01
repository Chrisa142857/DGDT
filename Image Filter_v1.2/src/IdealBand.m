%==========================================================================
% Image Processing: Ideal Filter Band-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function I=IdealBand(I,cutin,cutoff)
 [x y]=size(I);
 I = fftshift(fft2(I));
 f=idealbandpassfilter([x y],cutin,cutoff);
 I=f.*I;
 I=ifft2(ifftshift(I));
 I=norm_I(I);
%  I = uint8((real(ifft2(ifftshift(I)))));
 end