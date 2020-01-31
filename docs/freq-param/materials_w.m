clear
close all
clc
% ------------------------------------------------------------------------------
f = linspace(0,5e+2,1e+3); % MHz
f = f.';
omeg = 2*pi*f*1e6;   % rad/s
muo  = 4*pi*1e-7; % H/m
epso = 8.854187817e-12; % F/m
% ------------------------------------------------------------------------------
fo=250; % MHz
% ------------------------------------------------------------------------------
% dry sand (Bradford, Frequency-dependent attenuation analysis... 2007)
% ------------------------------------------------------------------------------
eps_dc =5.7;       % F/m
eps_inf=3.4;       % ?
tau    =1e-9*8;         % s
gamm   =0.7;
sigm_dc=0.45*1e-3; % S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w  = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ dry sand \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/sand_dry.mat','material');
% ------------------------------------------------------------------------------
figure;
subplot(3,1,1)
hold on
plot(f,epsi)
subplot(3,1,2)
hold on
plot(f,epsi_)
subplot(3,1,3)
hold on
plot(f,alph)%,'k.-')
% ------------------------------------------------------------------------------
% figure;
% hold on
% plot(f,epsi_.*omeg)
% ------------------------------------------------------------------------------
% moist sand (Bradford, Frequency-dependent attenuation analysis... 2007)
% ------------------------------------------------------------------------------
eps_dc =8.9;       % F/m
eps_inf=5.6;       % ?
tau    =1e-9*11;         % s
gamm   =0.75;
sigm_dc=2*1e-3; % S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ moist sand \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/sand_moist.mat','material');
% ------------------------------------------------------------------------------
subplot(3,1,1)
plot(f,epsi)
subplot(3,1,2)
plot(f,epsi_)
subplot(3,1,3)
plot(f,alph)%,'k-.')
% ------------------------------------------------------------------------------
% plot(f,epsi_.*omeg)
% ------------------------------------------------------------------------------
% wet sand (Bradford, Frequency-dependent attenuation analysis... 2007)
% ------------------------------------------------------------------------------
eps_dc =29;       % F/m
eps_inf=25.6;       % ?
tau    =1e-9*22.2;         % s
gamm   =0.88;
sigm_dc=6.06*1e-3; % S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ wet sand \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/sand_wet.mat','material');
% ------------------------------------------------------------------------------
subplot(3,1,1)
plot(f,epsi)
subplot(3,1,2)
plot(f,epsi_)
subplot(3,1,3)
plot(f,alph)%,'k-')
% ------------------------------------------------------------------------------
% plot(f,epsi_.*omeg)
% ------------------------------------------------------------------------------
% wet clay (Bradford, Frequency-dependent attenuation analysis... 2007)
% ------------------------------------------------------------------------------
eps_dc =43.04;      % F/m
eps_inf=20.73;      % ?
tau    =1e-9*18.3;  % s (18.3 or 8.9??)
gamm   =0.66;
sigm_dc=42.5*1e-3; % S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ wet clay \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/clay_wet.mat','material');
% ------------------------------------------------------------------------------
subplot(3,1,1)
plot(f,epsi)
subplot(3,1,2)
plot(f,epsi_)
subplot(3,1,3)
plot(f,alph)%,'k-')
% ------------------------------------------------------------------------------
subplot(3,1,1)
axis tight
% legend({'Dry sand','Moist sand','Wet sand','Wet clay'})
xlabel('Frequency (MHz)')
ylabel('Real permittivity ()')
subplot(3,1,2)
axis tight
legend({'Dry sand','Moist sand','Wet sand','Wet clay'})
xlabel('Frequency (MHz)')
ylabel('Imaginary permittivity')
subplot(3,1,3)
axis tight
% legend({'Dry sand','Moist sand','Wet sand','Wet clay'})
xlabel('Frequency (MHz)')
ylabel('Attenuation coeff. (1/m)')
simple_figure()
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
%
%
%         too conductive
%
%
% ------------------------------------------------------------------------------
% first look at silty loam (Friel and Or, 1999) 
% ------------------------------------------------------------------------------
eps_dc   =21.5;
eps_inf  =18;
tau  =.8e-9; % s
ap   =0.99;
sigm_dc=0.0035;% S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ silty loam \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/silty_loam.mat','material');
% ------------------------------------------------------------------------------
% now look at brine wetted sandstone (Taherian et al., 1990) 
% ------------------------------------------------------------------------------
eps_dc   =20.47;
eps_inf  =15.38;
tau  =5.8e-9;
ap   =1-.1833;
sigm_dc=0.0162;
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ sandstone with brine \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/brine_wet.mat','material');
% ------------------------------------------------------------------------------
% now look at water 
% ------------------------------------------------------------------------------
eps_dc   =79.77;
eps_inf  =1.34^2;
tau  =9.3e-12;
ap   =1;
sigm_dc=0.00045;
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ water \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/water.mat','material');
% ------------------------------------------------------------------------------
%
%
%         from angry reviewer
%
%
% ------------------------------------------------------------------------------
% Ultra-broad-band electrical spectroscopy of soils and sediments— 
% a combined permittivity and conductivity model.
% M. Loewer, T. Gunther, J. Igel,1 S. Kruschwitz, T. Martin and N. Wagner
% ------------------------------------------------------------------------------
eps_dc   =45.68;
eps_inf  =2.05;
tau  =3.93e-9; % s
ap   =0.72;
sigm_dc=0.0723;% S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ loess \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/loess.mat','material');
% ------------------------------------------------------------------------------
eps_dc   =65.55;
eps_inf  =2.08;
tau  =5.94e-8; % s
ap   =0.56;
sigm_dc=0.009;% S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ laterite \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/laterite.mat','material');
% ------------------------------------------------------------------------------
eps_dc   =32.49;
eps_inf  =2;
tau  =3.60e-8; % s
ap   =0.55;
sigm_dc=0.0195;% S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ humus \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/humus.mat','material');
% ------------------------------------------------------------------------------
eps_dc   =464.6;
eps_inf  =2.6;
tau  =5.3e-5; % s
ap   =0.5;
sigm_dc=0.0096;% S/m
% ------------------------------------------------------------------------------
[epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm);
alph         = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
alph_dc      = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg);
% ------------------------------------------------------------------------------
material = struct;
material.alph_dc = alph_dc;
material.epsi = epsi;
material.epsi_= epsi_;
material.sigm_dc = sigm_dc;
material.sigm_w = omeg.*epsi_*epso+sigm_dc;
material.alph = alph;
material.omeg = omeg;
material.f    = f;
% ------------------------------------------------------------------------------
sigm_ef = material.sigm_w(binning(f,fo));
fprintf(' ------------------ sandstone \n\n')
fprintf(' sigm_ef = %2.2d (S/m)\n',sigm_ef)
fprintf(' sigm_dc = %2.2d (S/m)\n',sigm_dc)
fprintf(' sigm_ef/sigm_dc = %2.2d \n',sigm_ef/sigm_dc)
fprintf('  \n\n')
% ------------------------------------------------------------------------------
save('mat-files/sandstone.mat','material');
% ------------------------------------------------------------------------------
%
%    figures
%
% ------------------------------------------------------------------------------
figure;
hold on
% ------------------------------------------------------------------------------
load('mat-files/sand_dry.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'b-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'b-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/sand_moist.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'g-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'g-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/sand_wet.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'r-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'r-','LineWidth',1.5)
% ------------------------------------------------------------------------------
xlabel('Frequency (MHz)')
ylabel('Conductivity')
simple_figure()
% ------------------------------------------------------------------------------
figure;
hold on
% ------------------------------------------------------------------------------
load('mat-files/sand_dry.mat');
alph = material.alph;
plot(f,alph,'r-.','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/sand_moist.mat');
alph = material.alph;
plot(f,alph,'g-.','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/sand_wet.mat');
alph = material.alph;
plot(f,alph,'b-.','LineWidth',1.5)
% ------------------------------------------------------------------------------
xlabel('Frequency (MHz)')
ylabel('Attenuation (1/m)')
simple_figure()
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
figure;
hold on
% ------------------------------------------------------------------------------
load('mat-files/silty_loam.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'y-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'y-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/clay_wet.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'c-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'c-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/brine_wet.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'k-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'k-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/loess.mat');
sigm_w = material.sigm_w;
sigm_dc= material.sigm_dc;
plot(f,sigm_w,'m-.','LineWidth',1.5)
plot(f,sigm_dc*ones(size(f)),'m-','LineWidth',1.5)
% ------------------------------------------------------------------------------
xlabel('Frequency (MHz)')
ylabel('Conductivity')
simple_figure()
% ------------------------------------------------------------------------------
figure;
hold on
% ------------------------------------------------------------------------------
load('mat-files/silty_loam.mat');
alph = material.alph;
alph_dc = material.alph_dc;
plot(f,alph,'y-.','LineWidth',1.5)
plot(f,alph_dc,'y-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/clay_wet.mat');
alph = material.alph;
alph_dc = material.alph_dc;
plot(f,alph,'c-.','LineWidth',1.5)
plot(f,alph_dc,'c-','LineWidth',1.5)
% ------------------------------------------------------------------------------
load('mat-files/brine_wet.mat');
alph = material.alph;
alph_dc = material.alph_dc;
plot(f,alph,'k-.','LineWidth',1.5)
plot(f,alph_dc,'k-','LineWidth',1.5)
% ------------------------------------------------------------------------------
xlabel('Frequency (MHz)')
ylabel('Attenuation (1/m)')
simple_figure()
