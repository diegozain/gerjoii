function pts_ = graham_scan(pts)
% diego domenzain 2018.
%
% given points (pts) in a plane, return convex hull in counter clockwise order.
% adapted from the wikipedia page
% https://en.wikipedia.org/wiki/Graham_scan#Pseudocode

% pts is an (np x 2) matrix
np = size(pts,1);
% get centroid and recenter
pts_centroid = geom_median(pts,pts(1,:)*2);
pts = pts - repmat(pts_centroid,np,1);
% sort by polar angle with pts(1,:) being
% the largest x and smallest y
pts = polar_sort(pts);
% initialize stack
pts_ = [pts(1,:);pts(2,:);pts(3,:)];
% for loop
for ip = 3:(np+2)
  ip=mod(ip,np); if ip==0;ip=np;end
  while and(cross_(pts_(end-1,:), pts_(end,:), pts(ip,:))<=0 , size(pts_,1)>2)
    % pop stack
    pts_(end,:) = [];
  end
  % push pts(ip) to stack
  pts_ = [pts_; pts(ip,:)];
end
% pts_(1:2,:)=[];
% return to where they where
pts_ = pts_ + repmat(pts_centroid,size(pts_,1),1);
end

% pts=rand(100,2);
% pts_ = graham_scan(pts);
% pts_c=geom_median(pts,pts(1,:)*2);
% figure;
% hold on;
% plot(pts(:,1),pts(:,2),'.-','markersize',40); 
% plot(pts_(:,1),pts_(:,2),'.-','markersize',40,'linewidth',3);
% plot(pts_c(1),pts_c(2),'.','markersize',80)
% hold off