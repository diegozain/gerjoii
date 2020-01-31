function B_ = sher_morr(B,q,y)
  % diego domenzain
  % spring 2017 @ BSU
  % ----------------------------------------------------------------------------
  % iteratively computes the inverse of the hessian B = H^-1
  % using the SHERman MORRison formula.
  %
  % let p be sought after parameters and 
  % let g be the gradient of the objective function.
  %
  % underscore stands for current evaluation, 
  % no underscore stands for previous evaluation.
  %
  % q = p_ - p
  % y = g_ - g
  
r = 1 / (q'*y);
I = eye(length(q),'single');

B_ = (I - r*(q*y')) *B* (I - r*(y*q')) + r*(q*q'); 

end 