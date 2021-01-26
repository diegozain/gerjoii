% ------------------------------------------------------------------------------
%
%
%  										see if we actually did this right
%
%
% ------------------------------------------------------------------------------
clear
clc
% ------------------------------------------------------------------------------
% must choose existing project:
ls('../raw/');
fprintf('\n we see an existing project\n')
prompt = '\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path__ = strcat('../raw/',project_name,'/w-data/','data-mat-fwi/');
data_name_  = 'line';
% ------------------------------------------------------------------------------
load(strcat(data_path__,'s_r','.mat'));
load(strcat(data_path__,'s_r_','.mat'));
ns = size(s_r,1);
load(strcat(data_path__,'parame_','.mat'));
nt = parame_.w.nt;
x  = parame_.x;
% ------------------------------------------------------------------------------
% lista = [13,14,15,27,28];
lista = [1];
% lista = [1,7,15,22,30];
for i_=1:numel(lista)
  is = lista(i_);
  load(strcat(data_path__,data_name_,num2str(is),'.mat'));
  d=radargram.d;
  t=radargram.t;
  r=radargram.r;
  rx=r(:,1);
  % ----------------------------------------------------------------------------
  figure;
  fancy_imagesc(d,rx,t);
  axis normal
  xlabel('Receivers (m)')
  ylabel('Time (ns)')
  title(['Line # ',num2str(is)])
  simple_figure()
  % ----------------------------------------------------------------------------
  wigb(d,1,rx,t);
  axis normal
  xlabel('Receivers (m)')
  ylabel('Time (ns)')
  title(['Line # ',num2str(is)])
  simple_figure()
end
% ----------------------------------------------------------------------------
% plot wavelet sources
figure;
hold on
for is=1:ns
% is = lista(i_);
load(strcat(data_path__,data_name_,num2str(is),'.mat'));
t=radargram.t;
wvlet = radargram.wvlet;
plot(t,wvlet)
end
hold off
axis tight
ylabel('Amplitude (V/m)')
xlabel('Time (ns)')
title('all sources')
simple_figure()
% ----------------------------------------------------------------------------
% plot wavelet sources - wigb
sources = zeros(nt,ns);
for is=1:ns
  % is = lista(i_);
  load(strcat(data_path__,data_name_,num2str(is),'.mat'));
  t=radargram.t;
  wvlet = radargram.wvlet;
  sources(:,is) = wvlet;
end
wigb(sources,1,1:ns,t);
xlabel('Line #')
ylabel('Time (ns)')
title('all sources')
simple_figure()
% ----------------------------------------------------------------------------
% plot src-rec of survey
figure;
hold on
for is=1:ns
  plot(s_r{is,1}(:,1),s_r{is,1}(:,2)+is,'r.','MarkerSize',25)
  plot(s_r{is,2}(:,1),s_r{is,2}(:,2)+is,'k.','MarkerSize',10)
end
hold off
axis tight
xlabel('Length (m)')
ylabel('Line #')
title('Sources and Receivers')
simple_figure()
% ----------------------------------------------------------------------------
wigb(radargram.d,1,x(s_r_{is,2}(:,1)),radargram.t); 
ylabel('Time (ns)');
xlabel('receivers [m]');
title('Data');
simple_figure();
% ----------------------------------------------------------------------------
figure;
hold on
for is=1:ns
plot(diff(x(s_r_{is,2}(:,1))),'.-','Markersize',10)
end
hold off
axis tight
ylabel('drx (m)');
xlabel('Receiver index');
title('Derivative of binned receivers');
simple_figure();
% ----------------------------------------------------------------------------
