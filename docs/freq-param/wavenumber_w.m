clear all
close all
clc

addpath('../../../graphics')

eps_0 = 8.854187817e-12;                
mu_0  = 4*pi*1e-7;
c = 1/sqrt(mu_0 * eps_0);

fo = 250e6; % [Hz]
fmax = 2.2 * fo;
epsi = eps_0*linspace(1,10,100);
mu = mu_0;
sig = linspace(1e-4,2e-3,100);
omega = fo*(2*pi);

vel_min = c/sqrt(max(epsi/eps_0));
vel_max = c/sqrt(min(epsi/eps_0));
l_min = vel_min / fmax;
lo = vel_min / fo;

[sig_,epsi_] = meshgrid(sig,epsi);
k = omega*sqrt(mu*epsi_.*sqrt(1+(sig_./(epsi_*omega)).^2));

k=k/(2*pi);

v = c./sqrt(mu*epsi'/(eps_0*mu_0));
l = v/fo;
l = repmat(l,1,numel(sig));
k_ = 1./l;

dif = k-k_;

figure;
fancy_imagesc(k,sig,epsi/eps_0);
axis square
ylabel('$\varepsilon$ $[\;]$')
xlabel('$\sigma$ $[S/m]$')
title('wavenumber magnitude $[1/m]$')
fancy_figure()

figure;
fancy_imagesc(log10(dif),sig,epsi/eps_0);
axis square
ylabel('$\varepsilon$ $[\;]$')
xlabel('$\sigma$ $[S/m]$')
title('wavenumber difference $\log_{10}[1/m]$')
fancy_figure()