% ------------------------------------------------------------------------------
% 
% correct source wavlet phase. Only if air refraction is present in data.
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

load('../w/parame_.mat');

t_max = zeros(ns,1);
% ------------------------------------------------------------------------------
for is=1:ns
 is_ = source_no(is);
 
 name_ = strcat('../../',project_,'/data-recovered/w/line',num2str(is_),'.mat');
 load(name_)
 it_reco = radargram.d(:,1);
 [~,it_reco] = max(it_reco);
 
 % figure;
 % plot(parame_.w.t*1e+9,radargram.d(:,1),'r-');
 % hold on
 
 name_ = strcat('../w/line',num2str(is_),'.mat');
 load(name_)
 it_obs = radargram.d(:,1);
 [~,it_obs] = max(it_obs);
 
 % plot(parame_.w.t*1e+9,radargram.d(:,1),'b-');
 % hold off
 % axis tight
 % xlabel('Time (ns)')
 % ylabel('Amplitude (V/m)')
 % simple_figure()

 t_max(is) = parame_.w.t(it_reco)-parame_.w.t(it_obs);
 it_max = it_reco-it_obs;
 
 if it_max<0
   % push source forward in time
   parame_.w.wvlets_((1-it_max-1):end,is_) = parame_.w.wvlets_(1:(end+it_max+1),is_);
   parame_.w.gaussians_((1-it_max-1):end,is_) = parame_.w.gaussians_(1:(end+it_max+1),is_);
   
   parame_.w.gaussians_(1:(-it_max-1),is_) = 0;
 elseif it_max>0
   % pull source backwards in time
   parame_.w.wvlets_(1:(end-it_max+1),is_) = parame_.w.wvlets_(it_max:end,is_);
   parame_.w.gaussians_(1:(end-it_max+1),is_) = parame_.w.gaussians_(it_max:end,is_);
 end
end
parame_.w.wvlets_ = parame_.w.wvlets_ .* parame_.w.gaussians_;
% ------------------------------------------------------------------------------
figure;
plot(source_no,t_max*1e+9,'k.-','markersize',20);
axis tight
xlabel('Shot #')
ylabel('Difference in first arrival (ns)')
simple_figure();

figure;
hold on
plot(parame_.w.t*1e+9,parame_.w.wvlets_,'-','markersize',20);
plot(parame_.w.t*1e+9,parame_.w.gaussians_*max(parame_.w.wvlets_(:)),'-','markersize',20);
hold off
axis tight
ylabel('Amplitude (V/m)')
xlabel('Time (ns)')
title('New Wavelets')
simple_figure();

figure;
fancy_imagesc(parame_.w.wvlets_(1:binning(parame_.w.t*1e+9,130),1:20),(1:20),parame_.w.t(1:binning(parame_.w.t*1e+9,130))*1e+9);
axis normal;
colormap(rainbow2(0.98))
title('Source Wavelets (V/m)');
xlabel('Source #');
ylabel('Time (ns)');
simple_figure()
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save wavelets with new time zero? (y/n)  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  save('../w/parame_.mat','parame_');
  fprintf('\n    ok, wavelets are saved now\n\n    dont forget to upload this new parame_.mat!!\n\n')
else
  fprintf('\n    ok, wavelets are not saved.\n\n')
end
% ------------------------------------------------------------------------------