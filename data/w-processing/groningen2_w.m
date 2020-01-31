% ------------------------------------------------------------------------------
%
%
%         groningen2
%
%
% ------------------------------------------------------------------------------
% number of lines
ns = 59; % 30 for groningen
% data path
data_path_ = '../raw/groningen2/w-data/data-mat/';
data_name_ = 'line'; % 'cmp'; 'line';
% ------------------------------------------
%   choose f_low f_high
% ------------------------------------------
% % UHF ambient signal (tv, garage remote, military, etc)
% f_low = 0.33; % [GHz]
% f_high = 0.53; % [GHz]
% % VHF radar signal
% f_low = 0.05; % [GHz]
% f_high = 0.3; % [GHz]
% VHF radar signal - "Frequencies of the Ricker wavelet" Yanghua Wang
fo_ = 0.16; % [GHz]
fc = 1.059095 * fo_; % [GHz]
fb = 0.577472 * fo_; % [GHz]
f_low = fc-fb;
f_high = fc+fb;
% % VHF radar signal - overhead line from train
% f_low = 0.175; % [GHz]
% f_high = 0.325; % [GHz]
% % overhead line from train
% f_low = 0.02; % [GHz]
% f_high = 0.1; % [GHz]

% ------------------------------------------
%   choose up to which receivers to keep
% ------------------------------------------
r_keepx = 1.5; % [m]
% ------------------------------------------
%   choose t_fa, v_min, eps_max, eps_min and f_max
% ------------------------------------------
t_fa = 33; % [ns]             ground wave begins
t_fa_ = 40; % [ns]            ground wave ends
vel_ = 0.072; % [m/ns]        ground wave velocity
v_min = 0.045; % [m/ns]       target minimum velocity
eps_max = (c/v_min)^2; % [ ]  max relative permittivity
eps_min = 1; % [ ]            min relative permittivity (air)
f_max = 0.32; % [GHz]         max characteristic frequency 