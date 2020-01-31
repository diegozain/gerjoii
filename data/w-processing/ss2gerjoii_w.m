% ------------------------------------------------
%
% take field radargrams and turn them into .mat
%
%
%
% ------------------------------------------------ 
close all
clear all
clc
addpath('read-data')
% ------------------------------------------------------------------------------
% Loop through done survey lines and save all of the data to .mat in disk.
% Also save r and t as r_all and t_all in memory.
% ------------------------------------------------------------------------------
fprintf('\n saving survey to .mat files\n')
% data_path = '../raw/groningen2/w-data/';
data_path = '../raw/vinyard-hat/w-data/'; 
data_name = 'LINE';
% data_path = '../raw/groningen2/w-data/data-mat/';
data_path_ = '../raw/vinyard-hat/w-data/data-mat/';
data_name_ = 'line'; % 'cog'; 'line';
% groningen:
% cog: 4, 5. line: (6:35)
%
% groningen2:
% cog: 0, 66. line: (1:59)
%
% hat ranch: 
% line: (1:20)
source_no = (1:20); 
ns = numel(source_no);
t_all = cell(1,ns);
r_all = cell(1,ns);

fprintf('    # of lines = %i\n',ns)

% % % this was the set up for groningen:
% % dr = 0.03; %      [m]
% fo = 250; %       [MHz]
% ds = 0.5; %           [m] % groningen 1. groningen2 0.5
% dsr = 0.9; %        [m] % cog: 0, 1.4. line: 0.9

% % this was the set up for the hat ranch:
% dr = 0.03; %      [m]
fo = 200; %       [MHz]
ds = 0.25; %           [m] % groningen 1. groningen2 0.5
dsr = 0.25; %        [m] % cog: 0, 1.4. line: 0.9

for is=1:ns;
  if source_no(is) < 10
    no = strcat(  num2str( 0 ) , num2str( source_no(is) ) );
  else 
    no = num2str( source_no(is) );
  end
  d_path = strcat( data_path,data_name,no );
  [d,r,t,header,skips] = ekko2mat_pro(d_path);
  radargram = struct;
  radargram.d = d;          % [ns] x [m]
  radargram.r = r;          % [m]
  radargram.t = t.';        % [ns]
  radargram.dt = t(2)-t(1); % [ns]
  radargram.dr = r(2)-r(1); % [m]
  radargram.dsr = dsr; %      [m]
  radargram.fo = fo; %        [MHz]
  name = strcat(data_path_,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
  % save t_all and r_all
  t_all{is} = t.';
  r_all{is} = r;
end
%%{
% ------------------------------------------------------------------------------
% Loop over all saved lines: time shift, unit convert and s_r store
% ------------------------------------------------------------------------------

fprintf('\n time-shift, unit convertion and s-r tuples\n')
fprintf('    # of shot-gathers = %i\n',ns)

% ns  --> s  | *1e-9
% MHz --> Hz | *1e+6

t_all = cell2mat(t_all);
s_r = cell(ns,2);

% plot how wrong the time-shift is
figure;
plot(t_all(1,:),'k.-','MarkerSize',13)
axis tight
xlabel('shot gather \#')
ylabel('time $t_o\,[ns]$')
title('time-shift')
fancy_figure()

for is=1:ns;
  load(strcat(data_path_,data_name_,num2str(is),'.mat'));
  % extract values
  d = radargram.d;
  t = radargram.t; %          [ns]
  dt = radargram.dt; %        [ns]
  fo = radargram.fo; %        [Hz]
  r = radargram.r; %          [m]
  dr = radargram.dr; %        [m]
  dsr = radargram.dsr; %      [m]
  % time shift
  nt = numel(t);
  nto = fix((t(1))/dt);
  shift_ = -nto;
  if shift_ > 0
  	d(1:nt-shift_+1,:) = d(shift_:nt,:);
  elseif shift_< 0
  	d(1-shift_:nt,:) = d(1:nt+shift_,:);
  end
  t = t-t(1);
  % GHz
  radargram.fo = fo*1e-3; % [GHz]
  % sources in real coordinates
  sx = (is-1)*ds;
  sz = 0;
  s_r{is,1} = [sx sz];
  % receivers in real coordinates
  rx = (is-1)*ds+dsr+r_all{is};
  rz = zeros(numel(rx),1);
  s_r{is,2} = [rx rz];
  % record new src-receivers on shot gather structure
  radargram.r = [rx rz];
  radargram.s = [sx sz];
  % overwrite
  radargram.t = t;
  radargram.d = d;
  name = strcat(data_path_,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end

clear d dr ds dsr dt fo t header is name no r r_all t_all radargram rx rz skips;
clear source_no sx sz;

% s_r is a cell where, (in real coordinates)
%
% s_r{shot #, 1}(:,1) is sx
% s_r{shot #, 1}(:,2) is sz
% s_r{shot #, 2}(:,1) is rx
% s_r{shot #, 2}(:,2) is rz
name = strcat(data_path_,'s_r','.mat');
save( name , 's_r' );

% ------------------------------------------------------------------------------
% see if we actually did this right
% ------------------------------------------------------------------------------

% lista = [13,14,15,27,28];
lista = [3,10,18];
figure;
hold on
% for i_=1:numel(lista)
% is = lista(i_);
% for is=1:30
for is=1:20
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
d=radargram.d;
t=radargram.t;
plot(d(:,1));
end
hold off
axis tight
legend({'13','14','15','27','28'},'Location','best')
xlabel('$t\,[ns]$')
title('first receiver time corrected')
fancy_figure()

% lista = [13,14,15,27,28];
lista = [3,10,18];
% lista = [1];
for i_=1:numel(lista)
is = lista(i_);
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
d=radargram.d;
t=radargram.t;
rx=s_r{is,2}(:,1);
figure;
fancy_imagesc(d,rx,t)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
end

% plot src-rec done
figure;
hold on
for is=1:ns
  plot(s_r{is,1}(:,1),s_r{is,1}(:,2)+is,'r.','MarkerSize',25)
  plot(s_r{is,2}(:,1),s_r{is,2}(:,2)+is,'k.','MarkerSize',10)
end
hold off
axis tight
xlabel('survey length $x\,[m]$')
ylabel('shot \#')
title('sources and receivers')
fancy_figure()
%}