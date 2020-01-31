function [er,er_] = kk_error(true_,reco_,dx,dz,klim)
% give absolute error (between 0 and 1) of true_ and reco_ matricies within
% the SQUARE domain of [-klim,klim]. klim has units of 1/dx.
% ..............................................................................
[true_,kx,kz] = fourier_2d(true_,dx,dz);
[reco_,kx,kz] = fourier_2d(reco_,dx,dz);
% ..............................................................................
ikx_ = binning(kx,-klim);
ikx__= binning(flip(kx),klim); 
ikx__= numel(kx)-ikx__+1;
ikz_ = binning(kz,-klim);
ikz__= binning(flip(kz),klim); 
ikz__= numel(kz)-ikz__+1;
% ..............................................................................
reco_= reco_(ikz_:ikz__,ikx_:ikx__);
true_= true_(ikz_:ikz__,ikx_:ikx__);
% ..............................................................................
er_= abs(reco_-true_);
er = sum(er_(:).^2 )/sum(abs(true_(:)).^2);
% ..............................................................................
% reco_ = abs(reco_);
% true_ = abs(true_);
% er_= reco_-true_;
% er = sum(er_(:).^2) / sum(true_(:).^2);
end