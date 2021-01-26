function [epsi,sigm] = w_model_2l(x,z,eps_,sig_,lam_,i_)
% build 1D (in the xz-plane) electrical parameters.
% 
% the index i_ gives:
% depth to second layer,
% permittivity and conductivity values for both layers.
% ..............................................................................
% x and z are discretized length and depth
% eps_ is a list of values for permittivity
% sig_ is a list of values for conductivity
% lam_ is a list of values for depths
% i_ is the index of the 2 layer model
% ..............................................................................
me = numel(eps_);
ms = numel(sig_);
ml = numel(lam_);
% ..............................................................................
% get index of wanted value of eps_, sig_ and lam_ from global index i_
[ieps,isig,ieps_,isig_,il] = w_index2model_2l(me,ms,ml,i_);
% ..............................................................................
nx = numel(x);
nz = numel(z);
% ..............................................................................
% lower layer
epsi = ones(nz,nx)*eps_(ieps_);
sigm = ones(nz,nx)*sig_(isig_);
% ..............................................................................
ilz  = binning(z,lam_(il));
% ..............................................................................
% upper layer
epsi(1:ilz,:) = eps_(ieps);
sigm(1:ilz,:) = sig_(isig);
end
% ..............................................................................
% % example:
% x=linspace(0,35,668);
% z=linspace(0,10,191);
% eps_=2:2:24;
% sig_=(1:10:100)*1e-3;
% lam_=0.75:0.25:(10-0.25);
% me = numel(eps_);
% ms = numel(sig_);
% ml = numel(lam_);
% n_models = me*ms*(me-1)*(ms-1)*ml;
% i_=1; % some number between 1 and n_models
% [epsi,sigm] = w_model_2l(x,z,eps,sig,lam,i_);
% figure;fancy_imagesc(epsi,x,z); figure;fancy_imagesc(sigm,x,z) 
% ..............................................................................
