clc
close all
clear
% ------------------------------------------------------------------------------
ls('..');
prompt = '\n\n    Tell me what sub-project you want:  ';
project_ = input(prompt,'s');
fprintf('\n\n          you still have to edit me for the values you want!\n\n')
% ------------------------------------------------------------------------------
colo_sigm = 0.8; % 1.3 0.9
colo_epsi = 2;   % 2 2.4
x_push = 5; % m
% ------------------------------------------------------------------------------
path_ = strcat('../',project_,'/output/wdc/');
% ------------------------------------------------------------------------------
load(strcat(path_,'sigm.mat'));
load(strcat(path_,'epsi.mat'));
load(strcat(path_,'x.mat'));
load(strcat(path_,'z.mat'));
load(strcat(path_,'as.mat'));
load(strcat(path_,'p_inv.mat'));
% ------------------------------------------------------------------------------
load('true/epsi_true.mat');
load('true/sigm_true.mat');
% ------------------------------------------------------------------------------
sigm = 1e+3*sigm; % mS/m
sigm_true = 1e+3*sigm_true; % mS/m
% ------------------------------------------------------------------------------
as(:,:,1)=[];
aw  = squeeze(as(1,1,:)).';
adc = squeeze(as(1,2,:)).';
Ews = squeeze(as(2,1,:)).';
Edc = squeeze(as(2,2,:)).';
% ------------------------------------------------------------------------------
adc_ = adc(1);
% ------------------------------------------------------------------------------
h_eps = p_inv(10)
d_eps = p_inv(11)
b_eps = wdc_b(h_eps,d_eps,adc_,adc,aw);
% ------------------------------------------------------------------------------
h_sig  = p_inv(13)
d_sig  = p_inv(14)
b_sig = wdc_b(h_sig,d_sig,adc_,adc,aw);
% ------------------------------------------------------------------------------
bet_eps = p_inv(8);
bet_sig = p_inv(9);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z);
colormap(rainbow2(colo_sigm));
% axis normal
axis image
xlabel('Length (m)')
ylabel('Depth (m)')
title('Recovered conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z);
colormap(rainbow2(colo_epsi));
% axis normal
axis image
xlabel('Length (m)')
ylabel('Depth (m)')
title('Recovered permittivity')
simple_figure()
% ------------------------------------------------------------------------------
figure;
plot(Edc,Ews,'k.-','markersize',20)
xlabel('ER')
ylabel('GPR')
title('History of objective functions')
simple_figure()
% ------------------------------------------------------------------------------
figure;
hold on;
plot(aw,'k.-','markersize',20)
plot(b_eps,'k-.','markersize',20)
plot(bet_eps*ones(numel(aw)),'k--','markersize',20)
plot(adc,'r.-','markersize',20)
plot(b_sig,'r-.','markersize',20)
plot(bet_sig*ones(numel(adc)),'r--','markersize',20)
hold off
xlabel('Iterations')
ylabel('Weights')
title('History of weights')
simple_figure()
% ------------------------------------------------------------------------------
%                 cross correlation of parameters vs true
% ------------------------------------------------------------------------------
epsi_true = normali(epsi_true);
sigm_true = normali(sigm_true);
epsi = normali(epsi);
sigm = normali(sigm);
% box around box
box_ix_  = binning(x,9);   % 9
box_ix__ = binning(x,11);  % 11
box_iz_  = binning(z,1);   % 1
box_iz__ = binning(z,3.75);   % 3.75
% cross corr
sigm_xcorr = xcorr2(sigm,sigm_true(box_iz_:box_iz__,box_ix_:box_ix__))/numel(epsi);
epsi_xcorr = xcorr2(epsi,epsi_true(box_iz_:box_iz__,box_ix_:box_ix__))/numel(epsi);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi_xcorr,x,z);
colormap(rainbow2(colo_epsi));
% axis normal
axis image
xlabel('Length (m)')
ylabel('Depth (m)')
title('xcorr permittivity')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm_xcorr,x,z);
colormap(rainbow2(colo_sigm));
% axis normal
axis image
xlabel('Length (m)')
ylabel('Depth (m)')
title('xcorr conductivity')
simple_figure()






