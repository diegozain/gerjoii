function u = filt_gauss3d_(u,dt,f_low,f_high,steep)
% diego domenzain 2018.
%
% performs gaussian filter between f_low and f_high of wavefield u,
% but it does so by 
% opening wavefield 'drawer', 
% filter drawer, 
% put drawer back inside

nz_ = size(u,1);
n_slices = factor(nz_);
n_slices = n_slices(end);
n_slice = nz_/n_slices;
for i_=1:n_slices
  % filter on u-slice
  % store u_filt.slice... but store it in u!!! fucking smart is what it is.
  u( ((i_-1)*n_slice+1):(i_*n_slice) , : , : ) = ...
    filt_gauss3d( u( ((i_-1)*n_slice+1):(i_*n_slice) , : , : ) ,...
               dt,f_low,f_high,steep);
end
end