function dt_u = w_dt(u,dt)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% takes time derivative
% of an (n x m x T) space-time cube u.
%
[m,n,T] = size(u);
dt_u = zeros(n,m,T);
dt_u(:,:,1)     = (1/(dt)) * ((-3/2)*u(:,:,1) + 2*u(:,:,2) - (1/2)*u(:,:,3));
dt_u(:,:,2:T-1) = (1/(dt)) * ((-1/2)*u(:,:,1:T-2) + (1/2)*u(:,:,3:T));
dt_u(:,:,T)     = (1/(dt)) * ((3/2)*u(:,:,T) - 2*u(:,:,T-1) + (1/2)*u(:,:,T-2));
end
