function [pts,ip,cosi] = polar_sort(pts)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% sort pts by polar angle with respect to pts(ip).
% assumes pts are centered around their centroid=[0,0].
%
% ip are indicies such that pts(ip,:) are sorted.
% cosi is curve of angle vs amplitude used for sorting,
%       useful for decimating the pts.


np=size(pts,1);
% normalize first
[pts_max,pts_imax]=max(pts);
pts=pts./repmat(pts_max,np,1);
% get positive values of x & y
pts_ipos = find(pts(:,1)>0 & pts(:,2)>0);
pts_pos = pts(pts_ipos,:);
% get minimum value of y with x & y positive and swap
[~,pts_miny] = min( pts_pos(:,2) );
pts1 = pts(1,:);
% pts(1,:) = pts(pts_ipos(pts_miny),:);
pts(1,:) = pts_pos(pts_miny,:);
pts(pts_ipos(pts_miny),:) = pts1;
% initialize cosi vector
cosi=zeros(np,1);
% the first value we know because we forced it this way
cosi(1)=2;
ip=1;
for ip_=2:np
  % get area of triangle pts(ip)-pts(ip_)-centroid.
  % if positive upper hull (0,pi), 
  % if negative lower hull (pi,2pi),
  % if zero pi or 2pi
  crs_ = cross_(pts(ip,:),pts(ip_,:),[0 0]);
  dot_ = (pts(ip_,:) * pts(ip,:).') / norm(pts(ip_,:));
  sgn_ = sign(crs_);
  if sgn_==0; sgn_=-1; end
  cosi(ip_) = sgn_ * (1+dot_);
end
[~,ip]=sort(cosi,'descend');
% figure;plot(cosi(ip),'.-')
cosi = cosi(ip);
pts = pts(ip,:) .* repmat(pts_max,np,1);
end

% pts=rand(100,2);
% pts_centroid=geom_median(pts,pts(1,:)*2);
% pts_ctr = pts - repmat(pts_centroid,size(pts,1),1); 
% pts_sort = polar_sort(pts_ctr);
% figure;
% hold on
% plot(pts(:,1),pts(:,2),'.-','markersize',20)
% plot(pts_sort(:,1),pts_sort(:,2),'.-','markersize',20)
% hold off