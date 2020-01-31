function [parame_,finite_] = dc_robin(geome_,parame_,finite_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% expand domain to extra pixels that account for robin boundary conditions.
% ------------------------------------------------------------------------------
nx = finite_.dc.nx;
nz = finite_.dc.nz;
robin = parame_.dc.robin;
% --------
%   DELTAS
% --------
x = geome_.X;
z = geome_.Y;

dx1 = x(2)-x(1);
dx2 = x(geome_.n)-x(geome_.n-1);
dz2 = z(geome_.m)-z(geome_.m-1);

dx1_robin = (1:robin)*dx1;
dx2_robin = (1:robin)*dx2;
dz2_robin = (1:robin)*dz2;

x = [dx1_robin x dx2_robin];
z = [z dz2_robin];

finite_.dc.x_robin = x;
finite_.dc.z_robin = z;

finite_.dc.DELTAS = do_grid(finite_);
% -------
%   sigma
% -------
sigma_robin = parame_.dc.sigma;

sig1 = sigma_robin(1,:);
sig2 = sigma_robin(geome_.n,:);
sig1 = repmat(sig1, robin  ,  1  );
sig2 = repmat(sig2, robin  ,  1  );
sigma_robin = [sig1; sigma_robin; sig2];

sig3 = sigma_robin(:,geome_.m);
sig3 = repmat(sig3, 1  , robin  );
sigma_robin = [sigma_robin , sig3];

parame_.dc.sigma_robin = sigma_robin;
end
