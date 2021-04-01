clc
close all
clear
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will show you the data!')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
runs = [37,45,46,47,48]; % 37 is the smooth wdc without fancy shit.
ni   = 50;
nruns=numel(runs);
% ------------------------------------------------------------------------------
load('true/epsi_true.mat');
load('true/sigm_true.mat');
load('true/x.mat');
load('true/z.mat');
dx=x(2)-x(1); dz=z(2)-z(1);
klim = 2; % 1/m
sigm_true= 1e+3*sigm_true; % mS/m
[nz,nx]=size(sigm_true);
% ------------------------------------------------------------------------------
eps_sse = zeros(nruns,1);
sig_sse = zeros(nruns,1);
% ------------------------------------------------------------------------------
EE= zeros(nruns,ni*2);
AA= zeros(nruns,ni*2);
P = zeros(nruns, 9 );
% ------------------------------------------------------------------------------
for iruns=1:nruns
  iruns_=runs(iruns);
  project_=strcat('l',num2str(iruns_));
  path_ = strcat('../',project_,'/output/wdc/');
  % ------------------------------------------------------------------------------
  load(strcat(path_,'as.mat'));
  load(strcat(path_,'p_inv.mat'));
  % ----------------------------------------------------------------------------
  as(:,:,1)=[];
  Ews = squeeze(as(2,1,1:ni)).';
  Edc = squeeze(as(2,2,1:ni)).';
  EE(iruns,:) = [Ews Edc];
  % ----------------------------------------------------------------------------
  aw  = squeeze(as(1,1,1:ni)).';
  adc = squeeze(as(1,2,1:ni)).';
  AA(iruns,:) = [aw adc];
  % ----------------------------------------------------------------------------
  P(iruns,1) = adc(1);                         % adc_
  % ----------------------------------------------------------------------------
  P(iruns,2) = p_inv(10);                      % h_eps
  P(iruns,3) = p_inv(11);                      % d_eps
  b_eps = wdc_b(p_inv(10),p_inv(11),P(iruns,1),adc,aw);
  % ----------------------------------------------------------------------------
  P(iruns,5) = p_inv(13);                      % h_sig
  P(iruns,6) = p_inv(14);                      % d_sig
  b_sig = wdc_b(p_inv(13),p_inv(14),P(iruns,1),adc,aw);
  % ----------------------------------------------------------------------------
  P(iruns,8) = p_inv(8);                     % bet_eps
  P(iruns,9) = p_inv(9);                     % bet_sig
  % ----------------------------------------------------------------------------
  % ----------------------------------------------------------------------------
  load(strcat(path_,'epsi.mat'));
  load(strcat(path_,'sigm.mat'));
  sigm = 1e+3*sigm; % mS/m
  % ----------------------------------------------------------------------------
  sig_sse(iruns)=kk_error(sigm_true,sigm,dx,dz,klim);
  eps_sse(iruns)=kk_error(epsi_true,epsi,dx,dz,klim);
end
sig_sse
eps_sse
% ------------------------------------------------------------------------------
% figure;
% hold on;
% plot(aw,'k.-','markersize',20)
% plot(b_eps,'k-.','markersize',20)
% plot(bet_eps*ones(numel(aw)),'k--','markersize',20)
% plot(adc,'r.-','markersize',20)
% plot(b_sig,'r-.','markersize',20)
% plot(bet_sig*ones(numel(adc)),'r--','markersize',20)
% hold off
% xlabel('Iterations')
% ylabel('Weights')
% title('History of weights')
% simple_figure()
% ------------------------------------------------------------------------------
figure;
hold on
for iruns=1:nruns
  if iruns==1
    colo = [1 0.5 0.2];
  elseif iruns==2
    colo = [0.5 1 0.2];
  elseif iruns==3
    colo = [0.5 0.2 1];
  elseif iruns==4
    colo = [0.2 0.5 1];
  end
  % pause;
  plot(EE(iruns,(ni+1):ni*2),EE(iruns,1:ni),'.-','markersize',40);%,'color',colo );
  fprintf(' run %i\n',iruns)
end
hold off
xlabel('ER')
ylabel('GPR')
title('Objective functions history')
simple_figure()
% ------------------------------------------------------------------------------