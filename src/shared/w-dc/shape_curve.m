function [pts,radius,cosi] = shape_curve(shape)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% shape is a 2d matrix containing a connected figure 
% well defined in the radial direction,
% (beans are allowed but cashew nuts are not).
%
% this method finds the pts on the shape's boundary and 
% returns them ordered counter-clockwise.
%
% to use for receivers in the wave solver:
%
% [pts,ip,cosi] = shape_curve(shape);
% %  decimate pts every dangle
% dangle = 2*pi/50;
% decimator = 0:dangle:(2*pi);
% angles = linspace(0,2*pi,size(pts,1));
% ip_ = binning(angles,decimator);
% pts = pts(ip_,:);
% % to see how they are decimated
% plot(angles,cosi(ip_))
% % to get real coordinates
% rx = x(int32(pts(:,1)));
% rz = z(int32(pts(:,2)));

% need a duplicate for later
shape_ = shape;
% get edges
[nz,nx]=size(shape_);
[Dx,Dz] = Dx_Dz(nz,nx);
shape_x=reshape(Dx*shape_(:),nz,nx);
shape_z=reshape(Dz*shape_(:),nz,nx);
shape_x=shape_x/max(shape_x(:));
shape_z=shape_z/max(shape_z(:));
shape_=abs(shape_x)+abs(shape_z);
shape_(shape_~=0)=1;
pts=find(shape_==1);
np=numel(pts);
% edges computed this way are actually 2 pixels thick,
% so this for loop fixes it
pts_=[];
for ip=1:np
  if shape(pts(ip))~=1
    pts_=[pts_ ; pts(ip)];
  end
end
pts=pts_;
% we now sort the points in polar coordinates
[iz,ix]=ind2sub([nz,nx],pts);
pts=[ix,iz];
np=size(pts,1);
ip=1:np;
% % geom_median is slow so let's give it less work,
% % (just 10% of all pts)
% np_=fix(0.1*np);
% ip=randi([1,np],np_,1);
pts_=pts(ip,:);
% get centroid
pts_centroid = geom_median(pts_,pts_(1,:)*2)
% correct for centroid = [0,0]
pts = pts - repmat(pts_centroid,size(pts,1),1);
% sort
[pts,ip,cosi] = polar_sort(pts);
% uncorrect for centroid
pts = pts + repmat(pts_centroid,size(pts,1),1);
% get radius
radius = norm(pts(1,:)-pts_centroid);
end