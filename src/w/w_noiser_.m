function w_noiser_(parame_,gerjoii_,is)
% diego domenzain
% fall 2019 @ BSU
% ------------------------------------------------------------------------------
% input:
% source number
% data path
% percentage of noise
% bandpass frequencies
% ------------------------------------------------------------------------------
% output: data with noise.
% ------------------------------------------------------------------------------
% read data
% this path is defined in natur__w
data_path_ = parame_.w.data_path_;
load(strcat(data_path_,'line',num2str(is),'.mat'));
% extract from struct
d = radargram.d;
t = radargram.t; %          [s]
dt = radargram.dt; %        [s]
fo = radargram.fo; %        [Hz]
r = radargram.r; %          [m] x [m]
s = radargram.s; %          [m] x [m]
% -----------------------------------------------
%   WARNING: this part is only for synthetic data
% -----------------------------------------------
t = 1e+9 *t; %          [ns]
dt = 1e+9 *dt; %        [ns]
fo = 1e-9 *fo; %        [GHz]
% -----------------------------------------------
fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
sx = s(1);
nr = numel(rx);
prcent = gerjoii_.w.noise.prcent;
f_low = gerjoii_.w.noise.f_low;
f_high = gerjoii_.w.noise.f_high;
% "to give noise" as a verb is "to noiser",
% that is how english works.
std_ = prcent*std(d(:));
noise_amp = mean(d(:)) + std_; % 1e+2;
noise = (2*rand(nt,nr)-1) * noise_amp;
d = d + noise;
% % mute earlier than air energy
% c=0.299792458; % [m/ns]
% to=3; % [ns]
% d = w_lmute(d,rx,t,sx,to,c);
% bandpass data back to denoised levels
for i=1:nr
  d(:,i) = d(:,i) .* tukeywin(nt,0.1);
end
nbutter = 10;
d = filt_gauss(d,dt,f_low,f_high,nbutter); % [s], [GHz]
% keep track of noise level??
radargram.std_ = ones(nr*nt,1); % std_;
radargram.d = d;
% save new data 
name = strcat(data_path_,'line',num2str( is ),'.mat');
save( name , 'radargram' );
end

