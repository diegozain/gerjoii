% diego domenzain
% spring 2020 @ CSM
% ..............................................................................
%
%   wave experiments
%
% ..............................................................................
% eps_ is a list of values that will be used for modeling the two layer scenario
% sig_ also.
% lam_ also. this are the heights to second layer
% --
% eps_ = 2:2:24; 
% sig_ = (1:10:100)*1e-3;      % mS/m
% lam_ = 0.75:0.25:(10-0.25);  % m
% --
eps_ = 2:8:24;
sig_ = [1,10]*1e-3;      % mS/m
lam_ = [0.75,1,1.25,1.5];    % m
% ..............................................................................
% wavelength [m] & velocity [m/ns]
l = parame_.w.c/( sqrt( max(eps_) ))/parame_.w.fo;
v = parame_.w.c/( sqrt( max(eps_) )) * 1e-9;
% ..............................................................................
fprintf('\n')
% ..............................................................................
fprintf('\n    minimum wavelength: %d (m)',l)
fprintf('\n    minimum Velocity  : %d (m/ns)',v)
% ..............................................................................
fprintf('\n')
% ..............................................................................
me  = numel(eps_);
ms  = numel(sig_);
ml  = numel(lam_);
% ..............................................................................
n_models_2l = me*ms*(me-1)*(ms-1)*ml;
% ..............................................................................
fprintf('\n # of different permittivity values: %i',me);
fprintf('\n # of different conductivity values: %i',ms);
fprintf('\n # of different depth values:        %i',ml);
% ..............................................................................
