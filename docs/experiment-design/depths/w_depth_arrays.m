clear
close all
clc
%-----------------------------------------
% % 
% %  
% % 
%-----------------------------------------
eps0 = 8.8541e-12;
mu0 = 4*pi*1e-7;
c = 1 / sqrt(mu0*eps0); % [m/s]
fo = linspace(10e6,500e6,100)'; % 10e6 to 1000e6 Hz
e_max = linspace(1,20,100)'; % 1 to 100 relative permittivity
l_min = c ./ ( sqrt(e_max) * fo' );
labels_l = logspace(log10(min(l_min(:))),log10(max(l_min(:))),8);
foo = linspace(min(c./(1*sqrt(e_max))),max(c./(1*sqrt(e_max))),100);
eps_rel = (c./(1*foo)).^2;
% ------
% let r be the number of receivers
% 
% x_offset = 2*ze = l_min + (r-1)*(l_min/4)
% ->
% ze = (l_min/2) + (r-1)*(l_min/8)
r = (1:40)';
l_min_linear = linspace(0.2,3,100)';
r_ = repmat(r,1,numel(l_min_linear));
l_min_linear_ = repmat(l_min_linear',numel(r),1);
ze = (l_min_linear_/2) + (r_-1).*(l_min_linear_/8);
labels_ze = logspace(log10(min(ze(:))),log10(max(ze(:))),8);
% ------
n = (1:50)';
n_ = repmat(n',numel(r),1);
r_ = repmat(r,1,numel(n));
Lo = c/sqrt(10)/100e6; % target wavelength (m), c/sqrt(10)/20e6
xmin = Lo + (r_-1)*(Lo/4) + (n_-1)*Lo/4;
labels_xmin = linspace(min(xmin(:)),max(xmin(:)),8);
x=Lo + (r-1)*(Lo/4);
x_ = repmat(x,1,numel(n));
xmin_=Lo + x_ + (n_-1)*Lo/4;
% ------

figure;
hold on
% plot(foo,eps_rel,'k-','LineWidth',5);
[cc,hh] = contour(fo,e_max,l_min,labels_l,'ShowText','on','linewidth',6);
hold off
clabel(cc,hh,'FontSize',15);
colormap(rainbow([0 0.05 1]))
cc = colorbar;
cc.TickLength = 0;
grid on
ylabel(cc, '(m)');
xlabel('characteristic frequency (Hz)')
ylabel('maximum permittivty ( )')
title('minimum wavelength (m)')
simple_figure()

figure;
[cc,hh] = contour(l_min_linear,r,ze,labels_ze,'ShowText','on','linewidth',6);
clabel(cc,hh,'FontSize',15);
colormap(rainbow([0 0.1 1]))
cc = colorbar;
cc.TickLength = 0;
grid on
ylabel(cc, '(m)');
xlabel('minimum wavelength (m)')
ylabel('# of receivers')
title('maximum depth (m)')
simple_figure()

figure;
[cc,hh] = contour(n,r,xmin,labels_xmin,'ShowText','on','linewidth',6);
clabel(cc,hh,'FontSize',15);
colormap(rainbow([0 0.5 1]))
cc = colorbar;
cc.TickLength = 0;
grid on
ylabel(cc, '(m)');
ylabel('# of receivers')
xlabel('# of points at depth')
Lo=num2str(Lo); Lo=Lo(1:3);
title([strcat('min length for wavelength',{' '} ,Lo, 'm')])
simple_figure()

figure;
[cc,hh] = contour(n,x,xmin_,labels_xmin,'ShowText','on','linewidth',6);
clabel(cc,hh,'FontSize',15);
colormap(rainbow([0 0.5 1]))
cc = colorbar;
cc.TickLength = 0;
grid on
ylabel(cc, '(m)');
ylabel('shot-gather max offset')
xlabel('# of points at depth (m)')
Lo=num2str(Lo); Lo=Lo(1:3);
title([strcat('min length for wavelength',{' '} ,Lo, 'm')])
simple_figure()

% ---
% common offset
% ---

z=linspace(0,20,90)'; % [m]
s=sqrt(e_max)/c;
t = s*z';
t=t*1e9; % [ns]
labels_t = linspace(min(t(:)),max(t(:)),10);

figure;
[cc,hh] = contour(z/2,e_max,t,labels_t,'ShowText','on','linewidth',6);
clabel(cc,hh,'FontSize',15);
colormap(rainbow([0 0.5 1]))
cc = colorbar;
cc.TickLength = 0;
grid on
ylabel(cc, '(ns)');
ylabel('maximum permittivty ( )')
xlabel('depth (m)')
Lo=num2str(Lo); Lo=Lo(1:3);
title(['two way travel time (ns)'])
simple_figure()




