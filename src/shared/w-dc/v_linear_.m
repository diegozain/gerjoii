function [v_t,d] = v_linear_(v,ns,nt,data_path_,data_name_)


nv = numel(v);
v_t = zeros(nt,nv);

for is=1:ns
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
d = radargram.d;
t = radargram.t; %          [ns]
dt = radargram.dt; %        [ns]
fo = radargram.fo; %        [GHz]
r = radargram.r; %          [m] x [m]
s = radargram.s; %          [m] x [m]
dr = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
% remove wow
d = dewow(d,dt,fo);
% taper edges to zero before fourier
for i=1:nr
  d(:,i) = d(:,i) .* tukeywin(nt,0.1);
end
% ----
f_low = 0.05; % [GHz]
f_high = 0.5; % [GHz]
% ----
% filter
nbutter = 10;
% d = butter_butter(d,dt,f_low,f_high,nbutter);
d = filt_gauss(d,dt,f_low,f_high,nbutter);
% amputate
r_keepx_  = rx(15);    % [m]
r_keepx__ = rx(end);  % [m] % +1, +1.5
ir_keep_  = binning(rx,r_keepx_);
ir_keep__ = binning(rx,r_keepx__);
dsr = dsr + abs(rx(1)-rx(ir_keep_));
rx = rx(ir_keep_:ir_keep__);
rz = rz(ir_keep_:ir_keep__);
r = [rx,rz];
d = d(:,ir_keep_:ir_keep__);
% linear semblance
v_analyn = v_linear(angle(hilbert(d)),t,rx,v);
% stack
v_t = v_analyn + v_t;
end
v_t = v_t/ns;
end