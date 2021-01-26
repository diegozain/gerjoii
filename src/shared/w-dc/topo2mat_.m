function [xbore_,z] = topo2mat_(u,x,z,x_,z_,xbore)
% ------------------------------------------------------------------------------
% diego domenzain
% @ CSM fall 2020
% ------------------------------------------------------------------------------
% u is a matrix that needs topographic adjusment
% x is discretized length for u
% z is discretized depth for u
% z_ is discretized topographic adjusment in depth
%       z_ has to be negative depth (height) to a datum of zero, i.e.
%       z_ = [-1:dz_:0]
%       so, from field topography data z_ do: z_=-(z_-min(z_));
% x_ is discretized length of topographic adjusment
% val is value to be filled for topographic adjusment (NaN is default)
% ------------------------------------------------------------------------------
nbore = numel(xbore);
% ------------------------------------------------------------------------------
z_ = interp1(x_,z_,x);
z_ = z_.';
% ------------------------------------------------------------------------------
% z  = [(z_(1):dz:z_(end-1)) , z];
dz = z(2)-z(1);
z  = [(z_(end):dz:z_(2)) , z];
nz_= numel(z);
% ------------------------------------------------------------------------------
[nz,nx] = size(u);
xbore_  = nan(nz_,nbore);
% ------------------------------------------------------------------------------
for ix_=1:nbore
  iz = binning(z,z_(ix_));
  xbore_(iz:(iz+nz-1),ix_) = u(:,binning(x,xbore(ix_)));
end
end