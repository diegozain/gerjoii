function [u_,z] = topo2mat(u,x,z,x_,z_,val)
% ------------------------------------------------------------------------------
% diego domenzain
% @ BSU fall 2019
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
if nargin<6
  val = NaN;
end
% ------------------------------------------------------------------------------
dz = z(2)-z(1);
% ------------------------------------------------------------------------------
z_ = interp1(x_,z_,x);
% ------------------------------------------------------------------------------
z_ = z_.';
% ------------------------------------------------------------------------------
% z  = [(z_(1):dz:z_(end-1)) , z];
z  = [(z_(end):dz:z_(2)) , z];
nz_= numel(z);
% ------------------------------------------------------------------------------
[nz,nx] = size(u);
u_ = ones(nz_,nx)*val;
% ------------------------------------------------------------------------------
for ix_=1:nx
  iz = binning(z,z_(ix_));
  u_(iz:(iz+nz-1),ix_) = u(:,ix_);
end
end