function h = curva_mean(a,Dx,Dz)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% computes the mean curvature of the surface (x,z,a),
% where a=a(x,z).
% 'a' is an nz by nx matrix.
% ------------------------------------------------------------------------------
if nargin<3
  [nz,nx] = size(a);
  [Dx,Dz] = Dx_Dz(nz,nx);
end
a=double(a);
% ------------------------------------------------------------------------------
ax=Dx*a(:); az=Dz*a(:);
axx=Dx*ax; azz=Dz*az;
axz=Dx*az;
% ------------------------------------------------------------------------------
% mean curvature
h = ( (1+ax.^2).*azz + (1+az.^2).*axx-(2.*ax.*az.*axz) ) ./ ...
    ( (1 + ax.^2 + az.^2).^(1.5) );
% ------------------------------------------------------------------------------
h=reshape(h,size(a));
h=full(h);
end