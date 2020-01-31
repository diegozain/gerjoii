function [u,u_] = envelope_(u)
% diego domenzain
% fall 2018 @ colorado school of mines
% ------------------------------------------------------------------------------
% u is a matrix, 
% the envelope will be done column-wise.
% 
% output u is the envelope,
%        u_ is the hilbert transform
%           (imaginary part of matlab's hilbert)
% ----------------------------------------------
% u_mean = repmat(mean(u),size(u,1),1);
% u = hilbert(u-u_mean);
u = hilbert(u);
% u = hilbert(u);
u_ = imag(u);
% u = abs(u) + u_mean;
u = abs(u);
% u = abs(u);
end
% % % this works better IF
% % % u has as many negative 
% % % as positive amplitudes.
% % u_ = envelope_(u); 
% % u__ = envelope_(-u);
% % u = 0.5*(u_+u__);