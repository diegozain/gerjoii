function d = logistic(X,w)
nd = size(X,2);
w=w(:);
% fwd
X = [ones(1,nd) ; X];
wX = (-X.'*w) ;
exp_wX = exp(wX);
d = 1 ./ ( 1+exp_wX );
end