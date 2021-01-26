% ------------------------------------------------------------------------------
% parameters for preprocessing a common-shot gather.
%                     I am file pp_csg_w.m
% ------------------------------------------------------------------------------
% project: bhrs
% ------------------------------------------------------------------------------
% constants. [], [], [m/ns]
cf          = 0.9;
nl          = 10;
c           = 0.299792458;
% bandpass. [GHz]
f_low       = 0.01;
f_high      = 0.1;
% amputate receivers. relative distance [m]
r_keepx_    = 5;
r_keepx__   = rx(end)-rx(1);
% first arrival time shift & velocity. [ns] & [m/ns]
t_fa        = 55;
v_fa        = c;
% ground time-window & velocity. [ns] & [m/ns]
% Since this is for a linear moveout,
% choose these values WITHOUT ANY time-shift correction, that is, 
% just as they look from the (filtered and 2.5D corrected) data.
t_ground_   = 55;
t_ground__  = 120;
v_ground    = c;
% stability of wave solver. [m/ns] & [GHz]
v_min       = 0.05;
f_max       = 0.2; % 1/radargram.dt/2; % 0.32% [GHz]
% velocity for 2d transform. [m/ns]
v_2d        = 0.13; 
% muting parameters
v_mute = v_ground;   % m/ns
t_mute = t_ground_-2; % ns
% ------------------------------------------------------------------------------
%                               hyperbolic events
% ------------------------------------------------------------------------------
% line 1
v_pick  = 0.057; % [m/ns]
to_pick = 326;  % [ns]
% % line 15
% v_pick  = 0.082; % [m/ns]
% to_pick = 345;  % [ns]
% ----------------------------------
% filter
% ----------------------------------
% amputate
% ----------------------------------
% time shift
% ----------------------------------
% choose max-min velocities
% ----------------------------------
v__ = 0.3; % [m/ns]
v_  = 0.03; % [m/ns] (velocity of water 0.03m/ns, rel perm~80)
dv = (v__-v_)*0.01;   % [m/ns]
v = v_ : dv : v__;  % [m/s] velocities to consider
% ----------------------------------
% choose velocity picks
% ----------------------------------
[t_hyper,z_pick] = v_hyperbola(v_pick,to_pick,rx,dsr);
% ------------------------------------------------------------------------------
% bundle in radargram structure
% ------------------------------------------------------------------------------
% bandpass. [GHz]
radargram.f_low     = f_low;
radargram.f_high    = f_high;
% amputate. [m]
radargram.r_keepx_  = r_keepx_;
radargram.r_keepx__ = r_keepx__;
% first arrival time shift & velocity. [ns] & [m/ns]
radargram.t_fa      = t_fa;
radargram.v_fa      = v_fa;
% ground time-window & velocity. [ns] & [m/ns]
radargram.t_ground_ = t_ground_;
radargram.t_ground__= t_ground__;
radargram.v_ground  = v_ground;
% stability of wave solver. [m/ns] & [GHz]
radargram.v_min     = v_min; 
% radargram.f_max= f_max;
% velocity picks from hyperbolic semblance
radargram.v_pick    = v_pick;
radargram.to_pick   = to_pick;
% velocity for 2d transform. [m/ns]
radargram.v_2d      = v_2d;
% linear mute
radargram.v_mute = v_mute;
radargram.t_mute = t_mute;
% ------------------------------------------------------------------------------


