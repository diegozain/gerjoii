% ------------------------------------------------------------------------------
% choose values of bottom and top layer
bott = 14;
topp = 5;
% ------------------------------------------------------------------------------
% build horizon and bin it
hori_z = 0.01*x+0.8; % 0.3
iz=binning(z,hori_z);
% ------------------------------------------------------------------------------
% build epsi
epsi = ones(numel(z),numel(x))*bott;
for i_=1:numel(x)
  epsi(1:iz(i_),i_) = topp;
end
% ------------------------------------------------------------------------------
% smooth it
ax = 0.8; % 1/m
az = 0.8; % 1/m
dx=x(2)-x(1); dz=z(2)-z(1);
ax=ax*dx;az=az*dz;
epsi = smooth2d(epsi,ax,az);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z)
colormap(rainbow2(2))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial permittivity')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi(z_:z__,x_:x__),x(x_:x__)-x_push,z(z_:z__))
colormap(rainbow2(2))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial permittivity')
simple_figure()
% ------------------------------------------------------------------------------
% save
save('../data/initial-guess/epsi.mat','epsi')
% ------------------------------------------------------------------------------
