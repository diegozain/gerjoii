function [gerjoii_,parame_] = w_lmute(gerjoii_,parame_)
% diego domenzain
% spring 2019 @ TUDelft
% ..............................................................................
% mutes linear arrival of shot gathers with a smooth mute.
% i don't think the data should be muted.
% ..............................................................................
% d is (time by receivers) multioffset shot gather, i.e. the data
% rx are x coordinates of receivers
% t is time vector
% to is time zero of shot
% v is velocity of linear arrival to mute.
% ..............................................................................
d_o= parame_.natu.w.d_2d;
d  = gerjoii_.w.d_2d;
t  = parame_.w.t;
v_mute = gerjoii_.w.v_mute;
t_mute = gerjoii_.w.t_mute;
rx = gerjoii_.w.r_real(:,1);
% ..............................................................................
% m/ns  --> m/s  | *1e+9
% ns    --> s    | *1e-9
v_mute = v_mute*1e+9;
t_mute = t_mute*1e-9;
% ..............................................................................
[nt,nr] = size(d);
rx = rx-rx(1);
% ..............................................................................
to_ = t_mute+(rx/v_mute);
steep=5;
mute_ = zeros(nt,nr);
% ..............................................................................
for i_=1:nr;
  % sigmoid mute 
  mute_(:,i_) = 1 ./ ( 1+exp(steep*(to_(i_)-t)) );
end
% ..............................................................................
d  = d .* mute_;
d_o= d_o .* mute_;
e_ = d-d_o;
% ..............................................................................
parame_.natu.w.d_2d = d_o;
gerjoii_.w.d_2d = d;
gerjoii_.w.e_2d = e_;
end