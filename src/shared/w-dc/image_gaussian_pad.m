function image_xy = image_gaussian_pad(image_xy,a,b,filt_TYPE,nx_pad,ny_pad)
% diego domenzain
% summer 2020 @ Mines
% ------------------------------------------------------------------------------
% up pad
image_xy = [repmat(image_xy(1,:) , ny_pad,1 ) ; image_xy ];
% down pad
image_xy = [image_xy; repmat(image_xy(end,:) , ny_pad,1 )];
% right pad
image_xy = [ image_xy , repmat(image_xy(:,end) , 1,nx_pad )];
% left pad
image_xy = [ repmat(image_xy(:,1) , 1,nx_pad ) , image_xy];
% ------------------------------------------------------------------------------
[image_xy,~,~] = image_gaussian(image_xy,a,b,filt_TYPE);
% ------------------------------------------------------------------------------
% up remove
image_xy(1:ny_pad,:) = [];
% down remove
image_xy((end-ny_pad+1):end,:) = [];
% right remove
image_xy(:,(end-nx_pad+1):end) = [];
% left remove
image_xy(:,1:nx_pad) = [];
end