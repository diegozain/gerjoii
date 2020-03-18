load('../r1/data-recovered/w/line1.mat')

d   = radargram.d;
t   = radargram.t; %          [ns]
dt  = radargram.dt; %        [ns]
fo  = radargram.fo; %        [GHz]
r   = radargram.r; %          [m] x [m]
s   = radargram.s; %          [m] x [m]
dr  = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
t = 1e+9 *t; %          [ns]
dt= 1e+9 *dt; %        [ns]
fo= 1e-9 *fo; %        [GHz]
for i=1:nr
  d(:,i) = d(:,i) .* tukeywin(nt,0.1);
end
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
%
figure;
plot(f,d_pow,'.-')
axis tight
xlabel('f (GHz)')
ylabel('d power')
title('line')
simple_figure()

% [~,il]=max(diff(rx));
% d(:,1:il) = [];
% rx(1:il)  = [];

f_low = 0.01;
f_high= 0.1;

fprintf('masw\n');
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% make velocity and frequency vectors
f_disp = (f_low) : (df) : (f_high);  % [GHz] frequencies to scan over
v__ = 0.3; % 0.29; % 0.2; % 0.1; % [m/ns]
v_  = 0.04; % 0.05; % 0.02; % [m/ns]
dv = (v__-v_)*0.01;   % [m/ns]
vp = v_ : dv : v__;  % [m/s] velocities to consider
sx = 1./vp;
% masw
[disper_vxf,disper_sxf] = masw(d_,(rx-rx(1))+dsr,sx,f,f_disp);

figure; 
fancy_imagesc(disper_vxf,f_disp,vp);
xlabel('Frequency (GHz)')
ylabel('Velocity (m/ns)')
axis square 
set(gca,'YDir','normal')
colormap(rainbow2(1))
simple_figure()

figure; 
fancy_imagesc(log10(disper_vxf),f_disp,vp);
xlabel('Frequency (GHz)')
ylabel('Velocity (m/ns)')
axis square 
set(gca,'YDir','normal')
colormap(rainbow2(1))
simple_figure()

