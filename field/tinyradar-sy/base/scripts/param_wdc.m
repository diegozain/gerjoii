parame_ = struct;
% diego domenzain
% fall 2018 @ BSU
% ------------------------------------------------------------------------------
% builds relevant parameters to be used in the GPR and ER forward models.
% ------------------------------------------------------------------------------
% domain diagram:
% 
%           x
%   aa .--------------. bb
%      |              |
%      |              |
%      |              |  z
%      |              |
%      |              |
%      |              |
%   cc .--------------.
%
%--------------
% domain limits
%--------------
parame_.aa = 0;
parame_.bb = 8;
parame_.cc = 2;
%--------------
% material properties constants
%--------------
parame_.w.eps_0 = 8.854187817e-12;   % [F/m]             
parame_.w.mu_0  = 4*pi*1e-7;         % [H/m]
parame_.w.c = 1/sqrt(parame_.w.mu_0*parame_.w.eps_0); % [m/s]
% ------------------------------------------------------------------------------
%                         model parameters
% ------------------------------------------------------------------------------
% here, place the interval of values you want your model parameters to have.
parame_.natu.epsilon_z  = [2 10];
parame_.natu.sig_e = 1e-3 * [1 1];
% ------------------
% number of air pixels
% ------------------
parame_.w.air = 60;
% ------------------
% max frequency and max time steps
% ------------------
parame_.w.fo = 250e6; % [Hz]
parame_.w.nt = 2500;
% ------------------
% pml padding
% ------------------
parame_.w.pml_w = 20;
parame_.w.pml_d = 20;
%------------------
% robin padding
%------------------
parame_.dc.robin = 1;
%------------------
% 2.5d for ER solver
%------------------
parame_.dc.n_ky = 4;
% ------------------------------------------------------------------------------
% this entire section is irrelevant but CANNOT be erased.
% it is a left-over of the very first version of this code.
% it is ugly but wdc_geom.m depends on it,
% and I do not want to fix that right now.
% ------------------------------------------------------------------------------
parame_.natu.eps_fig = parame_.natu.epsilon_z(1);
parame_.natu.sig_fig = parame_.natu.sig_e(1);
parame_.natu.lp   = [6 6];
% length of square (rectangle really) [m]
lx = 0.6; lz = 0.6; % 2 , 0.6
ax = (parame_.bb-parame_.aa)/2 - lx/2; az = (parame_.cc-parame_.aa)/3 - lz/2;
bx = (parame_.bb-parame_.aa)/2 + lx/2; bz = az;
cx = ax; cz = (parame_.cc-parame_.aa)/3 + lz/2;
% real coordinates for square
a = [ax az];
b = [bx bz];
c = [cx cz];
parame_.natu.eps_fig_pos = [a;b;c];
parame_.natu.sig_fig_pos = [a;b;c];
% length from center of figure [m]
parame_.natu.eps_fig_lxcenter = 0; parame_.natu.eps_fig_lzcenter = 0;
parame_.natu.sig_fig_lxcenter = 1.6; parame_.natu.sig_fig_lzcenter = 0;
% record length of square
parame_.natu.lx = lx; parame_.natu.lz = lz;
clear lx lz a b c ax az bx bz cx cz;
% ------------------------------------------------------------------------------
