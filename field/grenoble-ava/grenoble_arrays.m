% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
% arrays
array_names = {'C_26_78' , 'C_45_135' , 'C_78_405'};
% ------------------------------------------------------------------------------
narray = numel(array_names);
locs_ = cell(narray,1);
% ------------------------------------------------------------------------------
for i_=1:narray
  data_path_=strcat('data-mat/',array_names(i_),'/');
  load(char(strcat(data_path_,'geome','_',array_names(i_),'.mat')));
  % get its info
  locs_{i_}=geome.locs;
end
% ------------------------------------------------------------------------------
figure;
hold on
for i_=1:narray
locs = locs_{i_};
colo = 1-(i_/narray);
colo=repmat(colo,1,3);
scatter(locs(:,1),locs(:,2),300*ones(numel(locs(:,1)),1),colo,'filled');
end
line([locs_{3}(1,1),locs_{3}(10,1)],[locs_{3}(1,2),locs_{3}(10,2)],...
'color','r','linewidth',3)
hold off
xlabel('Easting (m)')
ylabel('Northing (m)')
title('Arrays');
box on;
simple_figure()