clc
close all
clear
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will show you the data!')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
runs = [37,39,40,38];
ni   = 50;
nruns=numel(runs);
% ------------------------------------------------------------------------------
load('true/epsi_true.mat');
load('true/sigm_true.mat');
load('true/x.mat');
load('true/z.mat');
sigm_true= 1e+3*sigm_true; % mS/m
[nz,nx]=size(sigm_true);
% box around box
box_ix_  = binning(x,8);   % 9
box_ix__ = binning(x,12);  % 11
box_iz_  = binning(z,0);   % 1
box_iz__ = binning(z,4);% 3.75
%
sigm_true_ = sigm_true(box_iz_:box_iz__,box_ix_:box_ix__);
epsi_true_ = epsi_true(box_iz_:box_iz__,box_ix_:box_ix__);
[mz,mx]=size(sigm_true_);
%
nmz=nz+mz-1;
nmx=nx+mx-1;
sigm_xcorr = zeros(nmz*nmx,nruns);
epsi_xcorr = zeros(nmz*nmx,nruns);
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
  % % epsi = normali(epsi);
  % % sigm = normali(sigm);
  % % cross corr
  % sigm_xcorr_=xcorr2(sigm,sigm_true_)/numel(epsi);
  % epsi_xcorr_=xcorr2(epsi,epsi_true_)/numel(epsi);
  % % bundle
  % sigm_xcorr(:,iruns) = sigm_xcorr_(:);
  % epsi_xcorr(:,iruns) = epsi_xcorr_(:);
  % ----------------------------------------------------------------------------
  sigm_ = sigm(box_iz_:box_iz__,box_ix_:box_ix__);
  epsi_ = epsi(box_iz_:box_iz__,box_ix_:box_ix__);
  sig_sse(iruns)=sqrt(sum( (sigm_true_(:)-sigm_(:)).^2 )/ sum( sigm_true_(:).^2 ));
  eps_sse(iruns)=sqrt(sum( (epsi_true_(:)-epsi_(:)).^2 )/ sum( epsi_true_(:).^2 ));
end
sig_sse
eps_sse
best_rms=(sig_sse+eps_sse)*0.5
[~,best_rms]=sort(best_rms)
[~,best_xcorr_sigm]=sort(max(sigm_xcorr));
best_xcorr_sigm = flip(best_xcorr_sigm)
[~,best_xcorr_epsi]=sort(max(epsi_xcorr));
best_xcorr_epsi = flip(best_xcorr_epsi)
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
figure;
plot(sigm_xcorr,'.')
xlabel('Index')
ylabel('xcorr')
title('Xcorr of box around box - Conductivity')
simple_figure()
% ----------------------------------------------------------------------------
figure;
plot(epsi_xcorr,'.')
xlabel('Index')
ylabel('xcorr')
title('Xcorr of box around box - Permittivity')
simple_figure()
% ------------------------------------------------------------------------------
% sigm_xcorr_((nmz-floor((mz-1)*0.5)):nmz,:)  =[];
% sigm_xcorr_(:,(nmx-(floor((mx-1)*0.5)):nmx))=[];
% sigm_xcorr_( 1:(floor((mz-1)*0.5)-1) ,:)=[];
% sigm_xcorr_(:, 1:(floor((mx-1)*0.5)-1) )=[];
% figure;
% plot(x,sigm_xcorr_.')
% % xlabel('Length')
% % ylabel('Depth')
% title('Xcorr of box around box - Conductivity')
% simple_figure()