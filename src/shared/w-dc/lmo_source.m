function [s,d_muted,gaussian_] = lmo_source(d_lmo,t,t__,t_)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% given linear moveout corrected data (see lmo.m), 
% mute shot gather to only the desired velocity and stack
% to find source signature. 

[nt,nr]=size(d_lmo);

width_ = t__-t_;
middle = t_ + width_/2;
width_ = width_^5;
gaussian_ = exp(- ((t-middle).^6 / width_ ) );
% figure; plot(t,gaussian_); axis tight
gaussian__ = repmat(gaussian_,[1,nr]);

d_muted = d_lmo .* gaussian__;
s = sum(normc(d_muted),2)/nr;

end