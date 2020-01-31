% ------------------------------------------------------------------------------
%
%
%         groningen
%
%
% ------------------------------------------------------------------------------
% number of lines
ns = 30; % 30 for groningen
% data path
data_path_ = '../raw/groningen/w-data/data-mat/';
data_name_ = 'line'; % 'cmp'; 'line';
% ------------------------------------------
%   choose f_low f_high
% ------------------------------------------
fo_ = 0.16; % [GHz]
fc = 1.059095 * fo_; % [GHz]
fb = 0.577472 * fo_; % [GHz]
f_low = fc-fb;
f_high = fc+fb;
% ------------------------------------------
%   choose up to which receivers to keep
% ------------------------------------------
r_keepx = 1; % [m]
% ------------------------------------------
%   choose t_fa, v_min, eps_max, eps_min and f_max
% ------------------------------------------
t_fa = 30; % [ns]             ground wave begins
t_fa_ = 46; % [ns]            ground wave ends
vel_ = 0.055; % [m/ns]        ground wave velocity
v_min = 0.045; % [m/ns]       target minimum velocity
eps_max = (c/v_min)^2; % [ ]  max relative permittivity
eps_min = 1; % [ ]            min relative permittivity (air)
f_max = 0.32; % [GHz]         max characteristic frequency 