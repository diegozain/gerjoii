function do = w_unclip_(do,dt,f_,f__,nf,it_ini,it_end)
% diego domenzain
% 2021 @ Mines
% 
% unclip a trace by using its own frequency content.
% does not use common interpolation techniques.
%
%     --- calls w_unclip.m ---
% 
% inspired by,
% A Simple Algorithm for the Restoration of Clipped GPR amplitudes
% Akshay Gulati and Robert J. Ferguson
%
% that paper is pretty bad because it doesn't really explain what is what, 
% (see equation 1).
%
% this is my interpretation of it.
% ------------------------------------------------------------------------------
% do is the data to unclip. Dimensions of time by receivers (nt x nr)
%
% example,
%
% dt=1;     % ns
% f_ = 0.01;% GHz
% f__= 0.1; % GHz
% nf = 10;  % number of frequency samples
% it_ini = 60; % index number before which unclipping is not wanted
% it_end = 300; % index number after which unclipping is not wanted
% ------------------------------------------------------------------------------
[nt,nr] = size(do);
for ir=1:nr
 do(:,ir) = w_unclip(do(:,ir),dt,f_,f__,nf,it_ini,it_end);
end
end