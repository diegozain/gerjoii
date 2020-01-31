function b = w_xgrad(dE_,dE__,p)
% dE_  current diff of obj fnc
% dE__ first diff of obj fnc
% p    scaling parameter
% ------------------------------------------------------------------------------
b=1./dE_;
b=b-dE__;
b=abs(p*b);
end