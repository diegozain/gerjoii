function dc_plot_srcrec_all(gerjoii_,geome_,s_all,r_all)
% diego domenzain
% spring 2018
% plot all src-recs from an ER experiment
% ------------------------------------------------------------------------------
ne = size(s_all,2);
figure;
xlim([geome_.X(1) geome_.X(end)])
ylim([1 ne])
hold on
for i_e=1:ne
  % src
  s = s_all{ i_e }(1:2);
  % receivers
  r = r_all{ i_e }(:,1:2);
  % real coordinates
  s_real = zeros(1,2,2);
  s_real(:,:,1) = gerjoii_.dc.electr_real(s(1),:);
  s_real(:,:,2) = gerjoii_.dc.electr_real(s(2),:);
  r_real = zeros( size(r,1) , 2 , 2 );
  r_real(:,:,1) = gerjoii_.dc.electr_real(r(:,1),:);
  r_real(:,:,2) = gerjoii_.dc.electr_real(r(:,2),:);
  % source
  plot(s_real(:,1,1),s_real(:,2,1)+i_e,...
  'r diamond','MarkerFaceColor','r','MarkerSize',10)
  % sink
  plot(s_real(:,1,2),s_real(:,2,2)+i_e,...
  'r square','MarkerFaceColor','r','MarkerSize',10)
  % rec-source
  plot(r_real(:,1,1),r_real(:,2,1)+i_e,...
  'k.','MarkerSize',25)
  % rec-sink
  plot(r_real(:,1,2),r_real(:,2,2)+i_e,...
  'k.','MarkerSize',25)
  end
hold off
grid on
grid minor
xlabel('Length (m)')
ylabel('Source #')
title('ER sources and receivers')
end