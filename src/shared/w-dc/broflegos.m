function H = broflegos(H,q,y)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% approximate Hessian
%
% using BROyden-FLEtcher-GOldfarb-Shanno algorithm
%
% let p be sought after parameters and 
% let g be the gradient of the objective function.
%
% underscore stands for current evaluation, 
% no underscore stands for previous evaluation.
%
% q = p_ - p
% y = g_ - g
% ..............................................................................
Hq = H*q;
qtH = q'*H;
H = H - ( (Hq * qtH) / (q'*H*q) ) + ( (y*y') / (y'*q) );
end
