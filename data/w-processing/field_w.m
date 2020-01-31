close all
clear all
clc
% ------------------------------------------------------------------------------
%
%                           build field_ structure
%
% that is, meta-data for all shot-gathers.
% ------------------------------------------------------------------------------
% must choose existing project:
project_name = 'bhrs';
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   build field_ gpr structure for project: %s',project_name)
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
field_ = struct;
% ------------------------------------------------------------------------------
% from real done survey 
field_.w.fo = 0.05; % GHz
field_.w.dr = 0.5;  % m
field_.w.ns = 28;
field_.w.nt = 717;
field_.w.dt = 1;    % ns
% ------------------------------------------------------------------------------
% you must choose these. maybe run datavis_w3 first to choose them.
field_.w.f_low   = 0.01; % GHz
field_.w.f_high  = 0.1;  % GHz
field_.w.f_max   = 0.12;  % GHz
field_.w.v_min   = 0.06; % m/ns
field_.w.v_2d    = 0.13; % m/ns
field_.w.t_o     = 20;   % ns 20
% ------------------------------------------------------------------------------
% do you want to mute?
field_.w.MUTE = 'no_MUTE';
% ------------------------------------------------------------------------------
% push all receivers x_push to give the fwd solver some room
field_.x_push = 5; % m
% begining of x & z domain. first source or some other number (m)
field_.aa     = 0; % s_r{1,1}(1,1);
% ending of x domain. last receiver or some other number (m)
% WARNING: has to be larger or equal than last receiver + x_push
field_.bb     = 45; % s_r{ns,2}(end,1);
% ending of z domain. (m)
field_.cc     = 15;
% ------------------------------------------------------------------------------
% number of lines that are good for amplitude estimation
field_.w.good_lines = 15;
% ------------------------------------------------------------------------------
% constants
field_.w.cf = 0.9; % []
field_.w.nl = 10;  % []
field_.w.c  = 0.299792458; % [m/ns]
% ------------------------------------------------------------------------------
% from values
field_.w.eps_max = (field_.w.c/field_.w.v_min)^2;
field_.w.eps_min = 1; % 0.7
field_.w.v_max = field_.w.c./(sqrt(field_.w.eps_min)); % m/ns
% ------------------------------------------------------------------------------
%  compute dx, dt_cfl, x and z for size of wave cube
% ------------------------------------------------------------------------------
% compute dx
dx = (field_.w.v_min)/(field_.w.nl*field_.w.f_max); % [m]
dx = field_.w.dr / ceil(field_.w.dr/dx); %     to not alias receivers
dz = dx;
% ------------------------------------------------------------------------------
% % make values for dc solver
% prompt = '\n\n    do you want dx & dz for dc 2.5d solver (y/n):  ';
% dxdz_dc_ = input(prompt,'s');
% % ------------------------------------------------------------------------------
% if strcmp(dxdz_dc_,'y')
%   dx = floor(dx/(10^(floor(log10(dx))))) * (10^(floor(log10(dx))));
%   dz = floor(dz/(10^(floor(log10(dz))))) * (10^(floor(log10(dz))));
% end
% ------------------------------------------------------------------------------
% build t. 
% nt will be smaller because of time trimming.
dt_cfl = field_.w.cf*( 1./( field_.w.v_max*sqrt(2/dx^2)  ) ); % [ns]
t = 0:field_.w.dt:field_.w.nt;
t = 0:dt_cfl:t(end);
% build x and z 
% x & z will be larger because of pml.
x=field_.aa:dx:field_.bb;
z=field_.aa:dz:field_.cc;
% ------------------------------------------------------------------------------
%   size of wave cube and permittivity
% ------------------------------------------------------------------------------
fprintf('\n\nwave cube will be of approx size (no pml, no air):  %1d [Gb]\n',...
          numel(x)*numel(z)*numel(t)*8*1e-9);
fprintf('\n min & max permitted = %d , %d',field_.w.eps_min,field_.w.eps_max)
fprintf('\n dx & dz             = %d , %d',dx,dz)
fprintf('\n dt                  = %d , %d\n',dt_cfl)
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save? (y/n)  ';
save_yn = input(prompt,'s');
if strcmp(save_yn,'y')
  save(strcat('../raw/',project_name,'/w-data/',project_name,'_w.mat'),'field_')
  % ----------------------------------------------------------------------------
  fprintf('\n\n       your field meta-data has been saved in %s \n\n\n',...
  strcat('../raw/',project_name,'/w-data/',project_name,'_w.mat'))
end

