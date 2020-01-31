function h = curva_gauss(a,Dx,Dz)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% --
% computes the gaussian curvature of the surface (x,z,a),
% where a=a(x,z).
% 'a' is an nz by nx matrix.
% --
if nargin<3
  [nz,nx] = size(a);
  [Dx,Dz] = Dx_Dz(nz,nx);
end
a=double(a);
% gaussian curvature
% -
ax=Dx*a(:); az=Dz*a(:);
axx=Dx*ax; azz=Dz*az;
axz=Dx*az;
% -
h = (axx.*azz - axz.^2)./((1 + ax.^2 + az.^2).^2);
% -
h=reshape(h,size(a));
h=full(h);
end