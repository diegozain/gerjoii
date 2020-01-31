close all
clear
clc
% ------------------------------------------------------------------------------
path_ = '../t3/output/w/';
% ------------------------------------------------------------------------------
load(strcat(path_,'x'))   
load(strcat(path_,'z'))
% ------------------------------------------------------------------------------
path_ = '../t3/data-recovered/w/';
load(strcat(path_,'line1'));
% ------------------------------------------------------------------------------
t = radargram.t*1e+9;
do= radargram.d;
r = radargram.r;
% ------------------------------------------------------------------------------
% center to zero
rc = r-1;
% get angle of receivers
theta = atan2(rc(:,2) , rc(:,1));
theta = theta .* (theta >= 0) + (theta + 2 * pi) .* (theta < 0);
% ------------------------------------------------------------------------------
% this one takes too long to render
figure;
fancy_polar(do,t+t(end)*0.55,theta,0.05);
title(['Shot-gather #',num2str(1)])
simple_figure();
% print(gcf,'dataw-polar','-dpng','-r650')
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(do,1:size(do,2),t,0.05);
axis normal;
xlabel('Receiver #')
ylabel('t (ns)')
title(['Shot-gather #',num2str(1)])
simple_figure(); 
% ------------------------------------------------------------------------------
