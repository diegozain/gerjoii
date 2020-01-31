function [pot_,L_] = our_size(bytes,np,ns)
  pot_ = bytes*(np.*ns)./(1e+9);
  L_   = bytes*(np*(5+1))./(1e+9);
end