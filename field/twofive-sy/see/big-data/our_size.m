function [pot_,L_] = our_size(bytes,np,ns)
  % 2.5D solution with adjoint method - just gradient
  % ----------------------------------------------------------------------------
  % 2D potentials
  pot_ = bytes*(np.*ns)./(1e+9);
  % fwd banded matrix + adjoint
  L_   = bytes*(np*(5+1))./(1e+9);
end