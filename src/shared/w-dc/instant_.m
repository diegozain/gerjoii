function [u,u_,u_H] = instant_(u)
% diego domenzain
% fall 2019 @ mines
% ------------------------------------------------------------------------------
% u is a matrix, 
% the envelope & phase will be done column-wise.
% 
% output u is the instantaneous amplitude (envelope),
%        u_ is the instantaneous phase
%        u_H is hilbert transform
% --
% hilbert(u) returns:
% u_analytic = u_real + i*u_imag
u = hilbert(u);
% the hilbert transform is the imag part
u_H = imag(u);
% instantaneous phase
u_ = angle(u);
% instantaneous amp (aka envelope)
u = abs(u);
end