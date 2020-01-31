function x = conj_grad(A,b,tol_n)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
x = ones(numel(b),1);
r = b-A*x;
p = r;
k = 0;
while( norm(r) > 1e-20 && k < tol_n )
  k = k+1;
  
  Ap = A*p;
  alph = (r'*r) / (p'*Ap);
  x = x + alph*p;
  r_ = r - alph*Ap;
  
  bet = (r_'*r_) / (r'*r);
  p = r_ + bet*p;
  
  r = r_;
end