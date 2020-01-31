function ab = ngrad2d(a,b,Dx,Dz)
% takes 2d norm of gradients of each entry of two matricies a & b.
% a & b have to be the same size.
% --
if nargin<4
  [nz,nx] = size(a);
  [Dz,Dx] = Dx_Dz(nz,nx);
end
% cross
ab = (Dx*a(:)).^2 + (Dz*a(:)).^2 + (Dx*b(:)).^2 + (Dz*b(:)).^2;
% ab=normali(ab);
ab=reshape(ab,size(a));
end 