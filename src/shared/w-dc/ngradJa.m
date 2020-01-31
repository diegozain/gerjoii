function Ja = ngradJa(a,Dx,Dz)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% let tau be the 2d-norm of gradients of a and b:
% tau = (Dx*a(:)).^2 + (Dz*a(:)).^2 + (Dx*b(:)).^2 + (Dz*b(:)).^2
% then Ja is the jacobian of tau with respect to a.
% ------------------------------------------------------------------------------
if nargin<3
  [nz,nx] = size(a);
  [Dz,Dx] = Dx_Dz(nz,nx);
end
% ------------------------------------------------------------------------------
a=a(:);
Ja = sparse_full(Dx,2*Dx*a(:)) + sparse_full(Dz,2*Dz*a(:));
Ja = Ja.';
end