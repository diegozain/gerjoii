clear
close all
nx=1e+3;nz=2e+2;
x=linspace(0,20,nx); dx=x(2)-x(1);
z=linspace(0,4,nz); dz=z(2)-z(1);
[X,Z]=meshgrid(x,z);
% ------------------------------------------------------------------------------
ss=1;
sigm = exp((-(X-5).^2 - (Z-2).^2)/(2*ss^2));
epsi = 1+(-exp((-(X-15).^2 - (Z-2).^2)/(2*ss^2)));
dsigm = sigm;
depsi = epsi;
% ------------------------------------------------------------------------------
figure('Position',[530 272 661 350]);
subplot(2,1,1)
fancy_imagesc(epsi,x,z);
colorbar('off')
set(gca,'XTick',[])
title('Epsi and sigm');
simple_figure();
subplot(2,1,2)
fancy_imagesc(sigm,x,z);
colorbar('off')
simple_figure();
% --
h=get(subplot(2,1,2),'Position');
cc=colorbar;
cc.Location = 'eastoutside';
cc.TickLength = 0;
% [left, bottom, width, height]
cc.Position = [h(3)*1.2,h(4)*1.1,0.02,0.6];
cc.Label.FontSize = 20;
xlabel(cc,'amplitude')
% --
% ------------------------------------------------------------------------------
nx=numel(x);nz=numel(z);
[Dx,Dz] = Dx_Dz(nz,nx);
% ------------------------------------------------------------------------------
% epsi = envelope_(epsi);
% sigm = envelope_(sigm);
% ------------------------------------------------------------------------------
hs = curva_mean(dsigm,Dx,Dz);
he = curva_mean(depsi,Dx,Dz);
hes=he.*hs; hes=hes/max(abs(hes(:)));
% ------------------------------------------------------------------------------
depsi_=(depsi/max(abs(depsi(:))))+5*hes.*(dsigm/max(abs(dsigm(:))));
depsi_=depsi_/max(abs(depsi_(:)));
% ------------------------------------------------------------------------------
figure;
subplot(2,1,1)
fancy_imagesc(hes,x,z);
title('Product curvature');
simple_figure();
subplot(2,1,2)
fancy_imagesc(log10(abs(hes)),x,z);
title('Product curvature (dB)');
simple_figure();
% ------------------------------------------------------------------------------
xes = cross2d(epsi,sigm,Dx,Dz);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(xes,x,z);
title('Cross gradient');
simple_figure();
