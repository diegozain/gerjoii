clear
close all
clc
% ------------------------------------------------------------------------------
% see obs vs recovered data for 1 shot-gather
% ------------------------------------------------------------------------------
path_obs = '../../bhrs2-fi/data/w/';
path_ini = '../b0/data-recovered/w/';
% ------------------------------------------------------------------------------
ls(path_obs)
prompt = '\n\n    what number of line (eg, 2 or 100):  ';
line_no   = input(prompt,'s');
line_name = strcat('line',line_no);
line_name = strcat(line_name,'.mat');
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me what project you want:  ';
ls('../');
project_ = input(prompt,'s');
path_reco= strcat('../',project_,'/data-recovered/w/');
% ------------------------------------------------------------------------------
fprintf('\n')
% ------------------------------------------------------------------------------
load(strcat(path_obs,line_name));
% ------------------------------------------------------------------------------
d_obs= radargram.d;  %        (time x receivers )
t   = radargram.t;  %        [ns]
dt  = radargram.dt; %        [ns]
fo  = radargram.fo; %        [GHz]
r   = radargram.r;  %        [m] x [m]
s   = radargram.s;  %        [m] x [m]
dr  = radargram.dr; %        [m]
dsr = radargram.dsr;%        [m]
% ------------------------------------------------------------------------------
dt= t(2)-t(1); %        [ns]
rx= r(:,1);
drx=rx(2)-r(1);
% ------------------------------------------------------------------------------
load(strcat(path_ini,line_name));
d_ini = radargram.d;
% ------------------------------------------------------------------------------
load(strcat(path_reco,line_name));
load('../data/w/parame_.mat');
% ------------------------------------------------------------------------------
d_reco = radargram.d;  %        (time x receivers )
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(d_reco-d_obs,rx,t);
axis normal
xlabel('Length (m)')
ylabel('Time (ns)')
title('Residual')
simple_figure()
% ------------------------------------------------------------------------------
nrx= size(d_reco,2);
% ------------------------------------------------------------------------------
figure;
hold on;
for ir = 1:nrx
  d_r = d_reco(:,ir);
  do_r= d_obs(:,ir);
  di_r= d_ini(:,ir);
  
  amp = -min(do_r);
  
  d_r = d_r/amp;
  do_r= do_r/amp;
  di_r= di_r/amp;
  
  plot(t,ir+1.1*(ir-1) + do_r,'k');
  plot(t,ir+1.1*(ir-1) + di_r,'b');
  plot(t,ir+1.1*(ir-1) + d_r ,'r');
end
hold off;
axis tight;
ylabel('Trace #')
xlabel('Time (ns)')
simple_figure()
% ------------------------------------------------------------------------------
irec = 1;
t1=150;
t2=400;

figure;
subplot(121)
hold on;
plot(t(1:binning(t,t1)),d_ini(1:binning(t,t1),irec),'b')
plot(t(1:binning(t,t1)),d_obs(1:binning(t,t1),irec),'k')
plot(t(1:binning(t,t1)),d_reco(1:binning(t,t1),irec),'r')
hold off;
axis tight;
ylabel('Amplitude (V/m)')
xlabel('Time (ns)')
title(['First receiver line # ',line_no])
simple_figure()

subplot(122)
hold on;
plot(t(binning(t,t1):binning(t,t2)),d_ini(binning(t,t1):binning(t,t2),irec),'b')
plot(t(binning(t,t1):binning(t,t2)),d_obs(binning(t,t1):binning(t,t2),irec),'k')
plot(t(binning(t,t1):binning(t,t2)),d_reco(binning(t,t1):binning(t,t2),irec),'r')
hold off;
axis tight;
% ylabel('Amplitude (V/m)')
xlabel('Time (ns)')
simple_figure()
% ------------------------------------------------------------------------------
line_no=str2num(line_no);

s = -dtu(parame_.w.wvlets_(:,line_no),dt);
s = s.';

figure;
subplot(211)
plot(t(1:binning(t,280)),s(1:binning(t,280)),'b');
axis tight;
ylabel('Amplitude')
title('Source wavelet - no inversion')
simple_figure()

subplot(212)
hold on;
plot(t(1:binning(t,280)),d_obs(1:binning(t,280),1),'k');
plot(t(1:binning(t,280)),d_reco(1:binning(t,280),1),'r');
hold off;
axis tight;
legend({'Observed','Recovered'})
% title('First trace')

ylabel('Amplitude')
xlabel('Time (ns)')
simple_figure()

% figure;
% hold on;
% load('../data/w/parame_.mat');
% s = -dtu(parame_.w.wvlets_(:,line_no),dt);
% s = s.';
% plot(t,s,'r');
% !scp diegodomenzain@mio.mines.edu:/u/wy/ba/diegodomenzain/gerjoii/field/bhrs2-fi/b2/tmp/parame_.mat .
% load('parame_.mat');
% s = -dtu(parame_.w.wvlets_(:,line_no),dt);
% s = s.';
% plot(t,s,'k');
% hold off

% ------------------------------------------------------------------------------
[s_pow,f,df] = fourier_rt(s,dt);
% power
s_pow = abs(s_pow).^2 / numel(t)^2;

% get max freq of spectra. 
% our scan will do low-passes ranging from f_mini to f_max
[~,f_mini] = max(s_pow);
f_mini = f(f_mini);
% get new df
df = df*5;
% 
f_high = parame_.w.f_high*1e-9;

figure;
subplot(211)
hold on
plot(f_mini*ones(2,1),[0,max(s_pow)],'k')
plot(f_high*ones(2,1),[0,max(s_pow)],'k')
plot(f(binning(f,0):binning(f,0.15)),s_pow(binning(f,0):binning(f,0.15)),'b')
hold off
axis tight
xlabel('Frequency (GHz)')
ylabel('Power')
title('Source wavelets - many inversions')
simple_figure()
% ------------------------------------------------------------------------------
% to=51; % ns
% d_obs = linear_mute(d_obs,drx,t,to,parame_.w.c*1e-9);
% ------------------------------------------------------------------------------
f_range= f_mini:df:f_high; % GHz
s_err = zeros(numel(f_range),1);
s_many = zeros(numel(s),numel(f_range));
for i_=1:numel(f_range)
  f_ = f_range(i_);
  s_ = filt_gauss(s,dt,-f_,f_,10);
  [s_,a] = w_wiener(d_reco,d_obs,s_);
  s_ = s_.*parame_.w.gaussians_(:,line_no);
  s_ = filt_gauss(s_,dt,-parame_.w.f_high*1e-9,parame_.w.f_high*1e-9,10);
  s_ = s_.*parame_.w.gaussians_(:,line_no);
  
  s_err(i_) = sum((s-s_).^2);
  
  s_many(:,i_) = s_;
end
[~,i__] = min(s_err);
fprintf('\n the best source wavelet was found for freq %2.2d GHz\n\n',f_range(i__));

subplot(212)
hold on
for i_=1:numel(f_range)
 plot(t(binning(t,25):binning(t,95)),s_many(binning(t,25):binning(t,95),i_),'color',[0.9 0.9 0.9]*(1/i_));
end
plot(t(binning(t,25):binning(t,95)),s(binning(t,25):binning(t,95)),'b','linewidth',2);
plot(t(binning(t,25):binning(t,95)),s_many(binning(t,25):binning(t,95),i__),'r','linewidth',2);

hold off
axis tight;
ylabel('Amplitude')
xlabel('Time (ns)')
% title('Source Wavelets')
simple_figure()
% ------------------------------------------------------------------------------
% 
%             AWI adjoint source
% 
% ------------------------------------------------------------------------------
%{
b=0;
c=1e-1*t(end);
T = -0.5*((t-b).^2 / (2*c^2));
T = exp(T);
T = 1-T;
T = diag(T);

ir=10;
d_r = d_reco(:,ir);
do_r= d_obs(:,ir);

tic;
a = wiener_filter(do_r,d_r);
Eawi  = 0.5*sum((T*a).^2)/sum(a.^2);
s_adj = w_awi(a,Eawi,T,do_r);
s_adj_= filt_gauss(s_adj,dt,-parame_.w.f_high*1e-9,parame_.w.f_high*1e-9,10);
toc;

res = do_r-d_r;
res = filt_gauss(res,dt,-parame_.w.f_high*1e-9,parame_.w.f_high*1e-9,10);
s_adj_ = max(abs(res(:)))*normali(s_adj_);

figure;
hold on
% plot(t,a,'k');
plot(t,res,'r');
plot(t,s_adj_,'b');
hold off;
axis tight;
legend({'Residual','AWI source'})
ylabel('Amplitude')
xlabel('Time (ns)')
simple_figure()
%}
% ------------------------------------------------------------------------------
%{
s_adj_ = zeros(size(d_obs));
for ir = 1:8%nrx
  d_r = d_reco(:,ir);
  do_r= d_obs(:,ir);
  
  a = wiener_filter(do_r,d_r);
  Eawi = 0.5*sum((T*a).^2)/sum(a.^2);
  s_adj = w_awi(a,Eawi,T,do_r);
  s_adj = filt_gauss(s_adj,dt,-parame_.w.f_high*1e-9,parame_.w.f_high*1e-9,10);
  
  s_adj_(:,ir) = s_adj;
end

figure;
fancy_imagesc(s_adj_(:,1:8),rx(1:8),t)
axis normal;
ylabel('Amplitude')
xlabel('Time (ns)')
simple_figure()
%}
% ------------------------------------------------------------------------------
