close all
clear all
clc
% ------------------------------------------------------------------------------
%
% give parame_.mat the new sources, and ONLY the new sources
%
% ------------------------------------------------------------------------------
% WARNING run after swvlets_w.m
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% must choose existing project:
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
% ------------------------------------------------------------------------------
fprintf('\n ------------------------------------------------------------------')
fprintf('\n   take swvlets from field_w and put them in parame_.mat \n\n           for project: %s',project_name)
fprintf('\n\n   this assumes you have already done the whole thing in after_field.md,\n   but have second thoughts about the source wavelet')
fprintf('\n ------------------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
% load field_ structure
load(strcat('../raw/',project_name,'/w-data/',project_name,'_w.mat'));
% load parame_ structure
load(strcat('../raw/',project_name,'/w-data/data-mat-fwi/parame_.mat'));
% get number of sources
load(strcat('../raw/',project_name,'/w-data/','data-mat-raw/','s_r','.mat'));
ns = size(s_r,1);
% ------------------------------------------------------------------------------
wvlet  = field_.w.wvlet;
wvlet_ = field_.w.wvlet_;
gaussian_=field_.w.gaussian_;
% ------------------------------------------------------------------------------
%   source wavelets from field_w into param_.mat
% ------------------------------------------------------------------------------
wvlets_ = repmat(wvlet_,1,ns);
gaussians_=repmat(gaussian_,1,ns);
% ------------------------------------------------------------------------------
figure;
hold on
plot(parame_.w.t*1e+9,parame_.w.wvlets_,'k-')
plot(parame_.w.t*1e+9,wvlets_,'r-')
hold off
xlabel('Time (ns)')
ylabel('Amplitude')
title('Old (black) and new (red) source-wavelets')
simple_figure()
% ------------------------------------------------------------------------------
parame_.w.wvlets_    = wvlets_;
parame_.w.gaussians_ = gaussians_;
% ------------------------------------------------------------------------------
parame_
% ------------------------------------------------------------------------------
%                           save master wavlet?
% ------------------------------------------------------------------------------
prompt = '\n\n    saving will rewrite parame_.mat. you sure? (y/n)  ';
src_yn = input(prompt,'s');
if strcmp(src_yn,'y')
  data_path__ = strcat('../raw/',project_name,'/w-data/data-mat-fwi/');
  name = strcat(data_path__,'parame_','.mat');
  save( name , 'parame_' );
  fprintf('\n    ok, source wavelets are saved in parame_.w.wvlets_ \n\n')
else
  fprintf('\n    ok, parame_.mat was not overwritten.\n\n')
end
% ------------------------------------------------------------------------------

