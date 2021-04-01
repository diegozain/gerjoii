function dtu = dt_u(u,dt)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% takes time derivative
% of an (nz x nx x nt) space-time cube u.
%
[nz,nx,nt] = size(u);
dtu = zeros(nz,nx,nt);

dtu(:,:,1)     = (1/(dt)) * ((-3/2)*u(:,:,1) + 2*u(:,:,2) - (1/2)*u(:,:,3));
dtu(:,:,2:nt-1)= (1/(dt)) * ((-1/2)*u(:,:,1:nt-2) + (1/2)*u(:,:,3:nt));
dtu(:,:,nt)    = (1/(dt)) * ((3/2)*u(:,:,nt) - 2*u(:,:,nt-1) + (1/2)*u(:,:,nt-2));

end
