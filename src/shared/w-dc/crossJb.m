function Jb = crossJb(a,Dx,Dz)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% let tau be the 2d-cross product of a and b:
% tau = (Dx*a).*(Dz*b) - (Dz*a).*(Dx*b)
% then Jb is the jacobian of tau with respect to b.
% ------------------------------------------------------------------------------
if nargin<3
  [nz,nx] = size(a);
  [Dz,Dx] = Dx_Dz(nz,nx);
end
% ------------------------------------------------------------------------------
Jb = - crossJa(a,Dx,Dz);
end