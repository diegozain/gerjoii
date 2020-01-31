clear all
close all
clc

% from Loke manual on his program. on mtu server.

a=1:1:12;

% ----- dipole -----

%   a       n*a         a
% s_____s____________r_____r
%
b = [0.416 0.697 0.962 1.22 1.476 1.73]';
b = [(1:numel(b))' ones(numel(b),1)] \ b;
m = b(1); intercept = b(2);
b = m*(1:10)' + intercept;
ze_dipole = b*a;

%   a       n*a         a
% s_____s____________r_____r
%
xmin_dipole = zeros(numel(b),numel(a));
for n=1:numel(b)
  for i=1:numel(a)
    xmin_dipole(n,i) = (2+n)*a(i);
  end
end

nr = 4:12; % (1:numel(b))+3;
num_pseudo_dipole = zeros(numel(b),numel(nr));
for n=1:numel(b)
  for i=1:numel(nr)
    num_pseudo_dipole(n,i) = nr(i)-n-2;
  end
end
num_pseudo_dipole(num_pseudo_dipole<0)=0;
% for ploting nodes on grid 
aa = min(a):1:max(a);
bb = repmat(1:numel(b),1,numel(aa));
aa = repmat(aa,numel(b),1);
aa = aa(:);
nodes_ = [aa bb'];

% choose black dots to plot
% dc_depth_spacing( ze or xmin, low, high )
ze_nodes_dipole = dc_depth_spacing(ze_dipole,0,2);

% [n,~] = size(ze_dipole);
% ze_dipole_ = ze_dipole(:);
% I = (ze_dipole_<=5) .* (ze_dipole_>=3);
% I = find(I);
% i = mod(I,n); i(i==0) = n;
% j = ( (I-i) / n ) + 1;
% ze_nodes_dipole = [j i];

xmin_nodes_dipole = dc_depth_spacing(xmin_dipole,0,18);

% [n,~] = size(xmin_dipole);
% xmin_dipole_ = xmin_dipole(:);
% I = (xmin_dipole_<=30) .* (xmin_dipole_>=0);
% I = find(I);
% i = mod(I,n); i(i==0) = n;
% j = ( (I-i) / n ) + 1;
% xmin_nodes_dipole = [j i];

% ------------------
% see
% ------------------
ze_dipole_=ze_dipole;
ze_dipole_(ze_dipole_>2)=3;

figure;
hold on
plot(nodes_(:,1),nodes_(:,2),'.','color',[0,0,0]+0.8,'Markersize',30)
[c,h] = contour(a,1:numel(b),ze_dipole,[1:1:max(ze_dipole(:))],...
'ShowText','on','linewidth',5);
% plot(xmin_nodes_dipole(:,1),xmin_nodes_dipole(:,2),'k.','Markersize',30)
hold off
clabel(c,h,'FontSize',15);
colormap(rainbow([0 0.2 1]))
c = colorbar;
c.TickLength = 0;
ylabel(c, '(m)');
xlabel('electrode spacing a (m)')
ylabel('src-rec separation n (index #)')
title('maximum depth for dipole-dipole (m)')
simple_figure()

figure;
hold on
plot(nodes_(:,1),nodes_(:,2),'.','color',[0,0,0]+0.8,'Markersize',30)
[c,h] = contour(a,1:numel(b),xmin_dipole,...
[10:5:max(xmin_dipole(:))],'ShowText','on','linewidth',5);
% plot(xmin_nodes_dipole(:,1),xmin_nodes_dipole(:,2),'k.','Markersize',30)
hold off
clabel(c,h,'FontSize',15);
colormap(rainbow([0 0.2 1]))
c = colorbar;
c.TickLength = 0;
ylabel(c, '(m)');
xlabel('electrode spacing a (m)')
ylabel('src-rec separation n (index #)')
title('minimum length for dipole-dipole (m)')
simple_figure()

% figure;
% [c,h] = contour(nr,1:numel(b),num_pseudo_dipole,'ShowText','on');
% clabel(c,h,'FontSize',15);
% [clmap,~,~] = fancy_colormap(num_pseudo_dipole);
% colormap(clmap)
% c = colorbar;
% c.TickLength = 0;
% ylabel(c, '[i]');
% xlabel('\# of receivers')
% ylabel('n (src-rec separation (index #))')
% title('\# of elements in pseudosection')
% simple_figure()

% ----- wenner -----
%    n*a     n*a     n*a
% s_______r_______r_______s
%
b = [0.52 0.93 1.32 1.71 2.09 2.48]';
b = [(1:numel(b))' ones(numel(b),1)] \ b;
m = b(1); intercept = b(2);
b = m*(1:10)' + intercept;
ze_wenner = b*a;
ze_wenner = b*a;

xmin_wenner = zeros(numel(b),numel(a));
for n=1:numel(b)
  for i=1:numel(a)
    xmin_wenner(n,i) = 3*n*a(i);
  end
end

aa = min(a):1:max(a);
bb = repmat(1:numel(b),1,numel(aa));
aa = repmat(aa,numel(b),1);
aa = aa(:);
nodes_ = [aa bb'];
%
xmin_nodes_wenner = dc_depth_spacing(xmin_wenner,0,18);
% ------------------
% see
% ------------------
figure;
hold on
plot(nodes_(:,1),nodes_(:,2),'.','color',[0,0,0]+0.8,'Markersize',30)
[c,h] = contour(a,1:numel(b),ze_wenner,[1:2:max(ze_wenner(:))],...
'ShowText','on','linewidth',5);
% plot(xmin_nodes_wenner(:,1),xmin_nodes_wenner(:,2),'k.','Markersize',30);
hold off
clabel(c,h,'FontSize',15);
colormap(rainbow([0 0.2 1]))
c = colorbar;
c.TickLength = 0;
ylabel(c, '(m)');
xlabel('electrode spacing a (m)')
ylabel('src-rec separation n (index #)')
title('maximum depth for Wenner (m)')
simple_figure()

figure;
hold on
plot(nodes_(:,1),nodes_(:,2),'.','color',[0,0,0]+0.8,'Markersize',30)
[c,h] = contour(a,1:numel(b),xmin_wenner,[10:10:max(xmin_wenner(:))],...
'ShowText','on','linewidth',5);
% plot(xmin_nodes_wenner(:,1),xmin_nodes_wenner(:,2),'k.','Markersize',30);
hold off
clabel(c,h,'FontSize',15);
colormap(rainbow([0 0.2 1]))
c = colorbar;
c.TickLength = 0;
ylabel(c, '(m)');
xlabel('electrode spacing a (m)')
ylabel('src-rec separation n (index #)')
title('minimum length for Wenner (m)')
simple_figure()

