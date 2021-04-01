load('../t1/data-synth/w/line1.mat')

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
xlabel('Frequency (GHz)')
ylabel('Power')
title('Power spectra')
simple_figure()

figure;
fancy_imagesc(d,rx,t)
axis normal
xlabel('Receivers (m)')
ylabel('Time (ns)')
title('Data')
simple_figure()
