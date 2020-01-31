function u = w_dtu(u,dt)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% compute time derivative of an (x,z,t) wavefield u (often huge cube),
% by minimizing memory storage but sacrificing computing time. 
% ..............................................................................
[nz,nx,nt] = size(u);
n_slices = factor(nx);
n_slices = n_slices(2);
n_slice = nx/n_slices;
for i_=1:n_slices
  % compute derivative on u-slice,
  % store dtu_-slice... but store it in u!!! fucking smart is what it is.
  u(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:) = ...
   dt_u(u(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:),dt);
end
end
