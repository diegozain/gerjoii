function v = dc_currentpot(u,dx,dz)
% given an electric potential u of size (nx,nz),
% return the scalar field v whose gradient is 
% orthogonal to the electric field E (= the gradient of u).
%
% The contour lines of v are orthogonal to the contour lines of u.
% The contour lines of v follow the field lines of E.
%
% E = \nabla u = (u_x,u_z)^\top
% V = (u_z,-u_x)^\top = \nabla v
% ------------------------------------------------------------------------------
[nz,nx] = size(u);
[Dz,Dx] = Dx_Dz(nz,nx);
% ------------------------------------------------------------------------------
Dx=Dx/dx;
Dz=Dz/dz;
% ------------------------------------------------------------------------------
ux = Dx*u(:); ux = reshape(ux,nz,nx);
uz = Dx*u(:); uz = reshape(uz,nz,nx);
% ------------------------------------------------------------------------------
v = intgrad2(uz,-ux,dx,dz,0);
% ------------------------------------------------------------------------------
end
% ------------------------------------------------------------------------------
% usage in gerjoii_:
% 
% v = dc_currentpot(gerjoii_.dc.u.',geome_.dx,geome_.dy);
% v = v.';
