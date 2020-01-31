% ------------------------------------------------------------------------------
% parameters for preprocessing a common-shot gather.
%                     I am file pp_cog_w.m
% ------------------------------------------------------------------------------
% constant. [m/ns]
c           = 0.299792458;
% bandpass. [GHz]
f_low       = 0.01;%0.05;
f_high      = 0.2;%0.3;
% fk-filter. [1/m] & [1/ns]
% smaller # -> bigger smudge
ar = 10;%10;
at = 25;%25;
% svd filter 
cut_off = 2;%2;
% first arrival time shift & velocity. [ns] & [m/ns]
t_fa        = 16;%20;%55;%85%20;
v_fa        = c;
% amputate receivers. relative distance [m]
r_keepx_    = 0;
r_keepx__   = rx(end)-rx(1);
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% bundle in radargram structure
% ------------------------------------------------------------------------------
% bandpass. [GHz]
radargram.f_low = f_low;
radargram.f_high= f_high;
% fk-filter. [1/m] & [1/ns]
radargram.ar  = ar;
radargram.at = at;
% first arrival time shift & velocity. [ns] & [m/ns]
radargram.t_fa = t_fa;
radargram.v_fa = v_fa;
% svd filter 
radargram.cut_off = cut_off;
% amputate. [m]
radargram.r_keepx_ = r_keepx_;
radargram.r_keepx__= r_keepx__;