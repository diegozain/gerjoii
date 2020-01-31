function Ja = crossJa(b,Dx,Dz)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% let tau be the 2d-cross product of a and b:
% tau = (Dx*a).*(Dz*b) - (Dz*a).*(Dx*b)
% then Ja is the jacobian of tau with respect to a.
% ------------------------------------------------------------------------------
if nargin<3
  [nz,nx] = size(b);
  [Dz,Dx] = Dx_Dz(nz,nx);
end
% ------------------------------------------------------------------------------
b=b(:);
Ja = sparse_full(Dx,Dz*b) - sparse_full(Dz,Dx*b);
Ja = Ja.';
end