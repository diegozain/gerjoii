% ------------------------------------------------------------------------------
% 
% correct source wavlet amplitude to match initial model
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
ls('../../');
prompt = '\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
ls(strcat('../../',project_,'/data-recovered/w/'));
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% ------------------------------------------------------------------------------
source_no = (iline_:iline__); 
ns = numel(source_no);

a = zeros(ns,1);
% ------------------------------------------------------------------------------
for is=1:ns
 is_ = source_no(is);
 
 name_ = strcat('../../',project_,'/data-recovered/w/line',num2str(is_),'.mat');
 load(name_)
 a_reco= max(radargram.d(:));
 
 name_ = strcat('../w/line',num2str(is_),'.mat');
 load(name_)
 a_obs = max(radargram.d(:));

 a(is) = a_obs/a_reco;
end
% a_ = geomean(a);
windo = 5; % 10;
a_ = window_mean(a,windo);
% ------------------------------------------------------------------------------
figure;
hold on
plot(source_no,a,'k.-','markersize',20);
plot(source_no,a_,'r.-','markersize',20)
hold off
axis tight
xlabel('Shot #')
ylabel('Ratio of Amplitudes ( )')
title('Factor to Correct Source Amplitudes')
simple_figure();
% ------------------------------------------------------------------------------
load('../w/parame_.mat');
parame_.w.wvlets_ = parame_.w.wvlets_.*repmat(a_.',size(parame_.w.wvlets_,1),1);
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save wavelets with new amplitude? (y/n)  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  save('../w/parame_.mat','parame_');
  fprintf('\n    ok, wavelets are saved now\n\n    dont forget to upload this new parame_.mat!!\n\n')
else
  fprintf('\n    ok, wavelets are not saved.\n\n')
end
% ------------------------------------------------------------------------------
