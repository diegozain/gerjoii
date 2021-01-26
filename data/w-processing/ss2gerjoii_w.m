% ------------------------------------------------------------------------------
%
% take field radargrams and turn them into .mat
%
%
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
pwd_ = pwd;
cd ../../
dir_paths;
cd(pwd_);
% ------------------------------------------------------------------------------
addpath('read-data');
% ------------------------------------------------------------------------------
% Loop through done survey lines and save all of the data to .mat in disk.
% Also save r and t as r_all and t_all in memory.
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will quick-process your survey.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat-raw/');
data_path = strcat('../raw/',project_name,'/w-data/');
ls(strcat('../raw/',project_name,'/w-data/'));
prompt = '\n\n    what is the leading name of the files? (eg, LINE or SH,...)   ';
data_name = input(prompt,'s');
prompt = '    tell me *line* or *cog*, eg: line:                              ';
data_name_ = input(prompt,'s');
prompt = '    is the counter funny (LINE01) or human (LINE1)? (if funny: y)   ';
count_ = input(prompt,'s');
%ls(data_path);
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% ------------------------------------------------------------------------------
prompt = '    tell me source-receiver distance in meters, eg 0.02:            ';
dsr = input(prompt,'s'); 
dsr=str2double(dsr);
prompt = '    tell me source-source distance in meters, eg 0.02:              ';
ds = input(prompt,'s'); 
ds=str2double(ds);
prompt = '    tell me receiver-receiver distance in meters (ignore if NA):    ';
dr = input(prompt,'s');
dr_ = strcmp(dr,'');
if dr_~=1 % (if it's not empty...)
  dr=str2double(dr);
end
prompt = '    tell me frequency used in MHz, eg 250:                          ';
fo = input(prompt,'s');
fo = str2double(fo);
% ------------------------------------------------------------------------------
fprintf('\n ok, gonna save survey to .mat files\n')
% ------------------------------------------------------------------------------
source_no = (iline_:iline__); 
ns = numel(source_no);
t_all = cell(1,ns);
r_all = cell(1,ns);
fprintf('    # of lines = %i\n',ns)
% ------------------------------------------------------------------------------
% % % this was the set up for groningen:
% % dr = 0.03; %      [m]
% fo = 250; %       [MHz]
% ds = 0.5; %           [m] % groningen 1. groningen2 0.5
% dsr = 0.9; %        [m] % cog: 0, 1.4. line: 0.9
% % this was the set up for the hat ranch:
% hat ranch: 
% line: (1:20)
% dr = 0.03; %      [m]
% fo = 200; %       [MHz]
% ds = 0.25; %           [m] % groningen 1. groningen2 0.5
% dsr = 0.25; %        [m] % cog: 0, 1.4. line: 0.9
% ------------------------------------------------------------------------------
for is=1:ns;
  if (strcmp(count_,'y')) && (source_no(is) < 10)
    no = strcat(  num2str( 0 ) , num2str( source_no(is) ) );
  else 
    no = num2str( source_no(is) );
  end
  d_path = strcat( data_path,data_name,no );
  [d,r,t,header,skips] = ekko2mat_pro(d_path);
  % -----------------------------------------
  % WARNING: the odometer does not always 
  % work right in the field. So r might not
  % be linear with respect to dr.
  % -----------------------------------------
  % radargram struct
  radargram = struct;
  radargram.d = d;          % [ns] x [m]
  radargram.t = t.';        % [ns]
  radargram.dt = t(2)-t(1); % [ns]
  if dr_~=1
    radargram.dr = dr;
    r = 0:dr:((numel(r)-1)*dr);
    r = r.';
  else
    radargram.dr= r(2)-r(1); % [m]
  end
  radargram.r = r;          % [m]
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
xlabel('shot gather #')
ylabel('time t_o (ns)')
title('time-shift')
simple_figure()
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
  % -----------------------------------------
  % WARNING: the odometer does not always 
  % work right in the field. So r might not
  % be linear with respect to dr.
  % -----------------------------------------
  % remove negative time nonsense
  t = dt*(0:(numel(t)-1)).';
  % -----------------------------------------
  % % time shift
  % nt = numel(t);
  % nto = fix((t(1))/dt);
  % shift_ = -nto;
  % if shift_ > 0
  % 	d(1:nt-shift_+1,:) = d(shift_:nt,:);
  %   d((nt-shift_+2):nt,:) = [];
  % elseif shift_< 0
  % 	d(1-shift_:nt,:) = d(1:nt+shift_,:);
  %   d(1:(-shift),:) = [];
  % end
  % t = t-t(1);
  % t=t(1:size(d,1));
  % -----------------------------------------
  % GHz
  radargram.fo = fo*1e-3; % [GHz]
  % sources in real coordinates
  sx = (is-1)*ds;
  sz = 0;
  s_r{is,1} = [sx sz];
  % -------------------------------
  % receivers in real coordinates
  % WARNING: the odometer does not always 
  % work right in the field. So rx might not
  % be linear with respect to dr.
  rx = (is-1)*ds+dsr+r_all{is};
  rz = zeros(numel(rx),1);
  s_r{is,2} = [rx rz];
  % record new src-receivers on shot gather structure
  radargram.r = [rx rz];
  radargram.s = [sx sz];
  % -------------------------------
  % overwrite
  radargram.t = t;
  radargram.d = d;
  name = strcat(data_path_,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end
clear d dr ds dsr dt fo t header is name no r r_all t_all radargram rx rz skips;
clear source_no sx sz;
% s_r is a cell where, (in real coordinates)
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
lista = 1:ns;
figure;
hold on
for is=1:numel(lista)
  load(strcat(data_path_,data_name_,num2str(lista(is)),'.mat'));
  d=radargram.d;
  t=radargram.t;
  plot(t,d(:,1));
end
hold off
axis tight
% legend({'1','2'},'Location','best')
xlabel('Time (ns)')
title('First receiver time corrected')
simple_figure()
% -
% lista = [1,2,3];
lista = 1:ns;
D=[];Rx=[];
for i_=1:numel(lista)
  is = lista(i_);
  load(strcat(data_path_,data_name_,num2str(is),'.mat'));
  d=radargram.d;
  t=radargram.t;
  rx=s_r{is,2}(:,1);
  D = [D d];
  Rx= [Rx; rx];
end
figure;
fancy_imagesc(D,Rx,t,0.1)
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title('All Lines')
simple_figure()
% -
% plot src-rec done
figure;
hold on
for is=1:ns
  plot(s_r{is,1}(:,1)+1,s_r{is,1}(:,2)+is,'r.','MarkerSize',25)
  plot(s_r{is,2}(:,1)+1,s_r{is,2}(:,2)+is,'k.','MarkerSize',10)
end
hold off
axis tight
xlabel('Survey length x (m)')
ylabel('Shot #')
title('Sources and receivers')
grid on
simple_figure()
%}
