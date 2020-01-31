function a = curva_gauss_J(a,Dx,Dz)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% --
% computes the Jacobian of the gaussian curvature of the surface (x,z,a),
% where a=a(x,z).
% 'a' is an nz by nx matrix.
% --
a=double(a);
if nargin<3
  [nz,nx] = size(a);
  [Dx,Dz] = Dx_Dz(nz,nx);
end
a=a(:);
% ------------------------------------------------------------------------------
% ha = p/q
p = ((Dx*Dx)*a) .* ((Dz*Dz)*a) - ((Dx*Dx)*a).^2;
q = ( 1 + (Dx*a).^2 + (Dz*a).^2 ).^2;
% ------------------------------------------------------------------------------
% ha_ = (q*p_ - p*q_) / q^2
p_ = ((Dx*Dx).*(Dz*Dz) - 2*sparse_full(Dx*Dz,Dx*Dz*a));
qx=2*sparse_full(Dx,Dx*a);
qz=2*sparse_full(Dz,Dz*a);
q_ = 2*sparse_full(qx.*qz,1+(Dx*a).^2 + (Dx*a).^2);
% --
if numel(q_)==0
  p = sparse_full(p_,q);
else
  p = sparse_full(p_,q) - sparse_full(q_,p);
end
a = sparse_full(p,1./(q.^2));
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------