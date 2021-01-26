function [epsi,sigm,I_] = w_model_2l_(x,z,eps_,sig_,lam_,I_)
% build 1D (in the xz-plane) electrical parameters.
% 
% the list of indicies I_ gives
% depth to layers,
% permittivity and conductivity values for all layers.
% ..............................................................................
% x and z are discretized length and depth
% eps_ is a list of values for permittivity
% sig_ is a list of values for conductivity
% lam_ is a list of values for depths
% i_ is the index of the 2 layer model
% ..............................................................................
nx = numel(x);
nz = numel(z);
me = numel(eps_);
ms = numel(sig_);
ml = numel(lam_);
% ..............................................................................
I_ = clean_I(me,ms,I_);
nI = numel(I_);
% ..............................................................................
% get index of wanted value of eps_, sig_ and lam_ from global index i_
[ieps,isig,ieps_,isig_,il] = w_index2model_2l(me,ms,ml,I_(1));
% ..............................................................................
% upper layer
epsi = ones(nz,nx)*eps_(ieps);
sigm = ones(nz,nx)*sig_(isig);
% ..............................................................................
ilz  = binning(z,lam_(il));
% ..............................................................................
% lower layer
epsi( (ilz+1):nz , : ) = eps_(ieps_);
sigm( (ilz+1):nz , : ) = sig_(isig_);
% ..............................................................................
if nI==1
  return
end
i_ = 2;
while I_(i_-1)<I_(i_)
 % .............................................................................
 % get index of wanted value of eps_, sig_ and lam_ from global index i_
 [ieps,isig,ieps_,isig_,il] = w_index2model_2l(me,ms,ml,I_(i_));
 % .............................................................................
 ilz  = binning(z,lam_(il));
 % .............................................................................
 % lower layer
 epsi( (ilz+1):nz , : ) = eps_(ieps_);
 sigm( (ilz+1):nz , : ) = sig_(isig_);
 % .............................................................................
 i_=i_+1;
 % .............................................................................
 if i_>nI
   break
 end
end
% ..............................................................................
end
% .............................................................................
% 
% 
% .............................................................................
function I_ = clean_I(me,ms,I_)
% .............................................................................
% first remove all elements in I_ that are not strictly increasing
nI = numel(I_);
i_=1;
while I_(i_)<I_(i_+1)
  i_=i_+1;
  if i_ > nI-1
    break
  end
end
I_=I_(1:i_);
% .............................................................................
% now remove all elements that are within the same depth for the 2 layer model
nl = me*ms*(me-1)*(ms-1);
i_ = 1;
while i_<= numel(I_)
  if I_(i_) <= (i_-1)*nl
    I_(i_) = [];
  else
    i_=i_+1;
  end
end
% I_
nI= numel(I_);
i_=1;
while i_ < numel(I_)
  if floor((I_(i_+1)-1)/nl)==floor((I_(i_)-1)/nl)
    I_(i_+1)=[];
  end
  i_=i_+1;
end
% .............................................................................
end