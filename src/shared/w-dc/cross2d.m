function xab = cross2d(a,b,Dx,Dz)
% takes 2d cross product of each entry of two matricies a & b.
% 2d cross product is taken as the determinant of two 2d vectors.
% a & b have to be the same size.
% --
if nargin<4
  [nz,nx] = size(a);
  [Dz,Dx] = Dx_Dz(nz,nx);
end
% cross
xab=(Dx*a(:)).*(Dz*b(:))-(Dz*a(:)).*(Dx*b(:));
% xab=normali(xab);
xab=reshape(xab,size(a));
end 