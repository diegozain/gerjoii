clear
close all
nx=6e+2;nz=3e+2;
x=linspace(0,6*pi,nx); dx=x(2)-x(1);
z=linspace(0,3*pi,nz); dz=z(2)-z(1);
[X,Z]=meshgrid(x,z);
a=sin(0.05*pi*(X-3*pi).^2 + (Z-pi*1.5).^2);
b=cos(X+Z);
a=a/max(abs(a(:)));
b=b/max(abs(b(:)));
% nx=numel(x); nz=numel(z);a=dsig;b=deps;
% figure;fancy_imagesc(a,x,z);title('a');
% figure;fancy_imagesc(b,x,z);title('b');
[Dx,Dz] = Dx_Dz(nz,nx);
% Dx=Dx/dx; Dz=Dz/dz;
% vertical derivative
adx = Dx*a(:);
bdx = Dx*b(:);
% horizontal derivative
adz = Dz*a(:);
bdz = Dz*b(:);
adx=reshape(adx,size(a));
adz=reshape(adz,size(a));
bdx=reshape(bdx,size(b));
bdz=reshape(bdz,size(b));
% cross
xab=(Dx*a(:)).*(Dz*b(:))-(Dz*a(:)).*(Dx*b(:));
xab=reshape(xab,size(a));
xab=xab/max(abs(xab(:)));
a_=a+2*xab;
a_=a_/max(abs(a_(:)));
b_=b+2*xab;
b_=b_/max(abs(b_(:)));
% sum
ab = 2*a+b;
ab=ab/max(abs(ab(:)));
ba = a+2*b;
ba=ba/max(abs(ba(:)));
% see
% figure;fancy_imagesc(adx,x,z);title('dza');
% figure;fancy_imagesc(adz,x,z);title('dxa');
% figure;fancy_imagesc(bdx,x,z);title('dzb');
% figure;fancy_imagesc(bdz,x,z);title('dxb');
figure;fancy_imagesc(xab,x,z);title('cross ab');simple_figure()
% figure;fancy_imagesc(a_,x,z);title('a filt');%caxis([-0.7 0.7])
% figure;fancy_imagesc(b_,x,z);title('b filt');%caxis([-0.7 0.7])
% figure;fancy_imagesc(ab,x,z);title('a+b');
% figure;fancy_imagesc(ba,x,z);title('b+a');

figure;
subplot(3,2,1)
fancy_imagesc(a,x,z);
caxis([-1 1])
colorbar('off')
set(gca,'Xtick',[])
set(gca,'Ytick',[])
title('$a$');
fancy_figure();
subplot(3,2,2)
fancy_imagesc(b,x,z);
caxis([-1 1])
colorbar('off')
set(gca,'Xtick',[])
set(gca,'Ytick',[])
title('$b$');
fancy_figure();
%
subplot(3,2,3)
fancy_imagesc(a_,x,z);
caxis([-1 1])
colorbar('off')
set(gca,'Xtick',[])
set(gca,'Ytick',[])
title('$a+2\cdot |\nabla a,\nabla b|$');
fancy_figure();
subplot(3,2,4)
fancy_imagesc(b_,x,z);
caxis([-1 1])
colorbar('off')
set(gca,'Xtick',[])
set(gca,'Ytick',[])
title('$b+2\cdot |\nabla a,\nabla b|$');
fancy_figure();
%
subplot(3,2,5)
fancy_imagesc(ab,x,z);
caxis([-1 1])
colorbar('off')
set(gca,'Xtick',[])
set(gca,'Ytick',[])
title('$b+2\cdot a$');
fancy_figure();
subplot(3,2,6)
fancy_imagesc(ba,x,z);
caxis([-1 1])
colorbar('off')
set(gca,'Xtick',[])
set(gca,'Ytick',[])
title('$a+2\cdot b$');
fancy_figure();


% (Dx*dep(:)).*(Dz*dsi(:))-(Dz*dep(:)).*(Dx*dsi(:))