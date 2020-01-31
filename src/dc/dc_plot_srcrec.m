function dc_plot_srcrec(gerjoii_,geome_,i_e)
s_i_r_d_std = gerjoii_.dc.s_i_r_d_std;

% src
s = s_i_r_d_std{ i_e }{ 1 }(1:2);
% current
i_amps = s_i_r_d_std{ i_e }{ 1 }(3);
% receivers
r = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
% data
d = s_i_r_d_std{ i_e }{ 2 }(:,3);
% std
std_ = s_i_r_d_std{ i_e }{ 2 }(:,4);

% real coordinates
s_real = zeros(1,2,2);
s_real(:,:,1) = gerjoii_.dc.electr_real(s(1),:);
s_real(:,:,2) = gerjoii_.dc.electr_real(s(2),:);
r_real = zeros( size(r,1) , 2 , 2 );
r_real(:,:,1) = gerjoii_.dc.electr_real(r(:,1),:);
r_real(:,:,2) = gerjoii_.dc.electr_real(r(:,2),:);

% see
figure;
xlim([geome_.X(1) geome_.X(end)])
ylim([geome_.Y(1) geome_.Y(end)])
hold on
% source
plot(s_real(:,1,1),s_real(:,2,1),'r diamond','MarkerFaceColor','r','MarkerSize',10)
% sink
plot(s_real(:,1,2),s_real(:,2,2),'r square','MarkerFaceColor','r','MarkerSize',10)
% rec-source
plot(r_real(:,1,1),r_real(:,2,1),'k.','MarkerSize',15)
% rec-sink
plot(r_real(:,1,2),r_real(:,2,2),'k.','MarkerSize',15)
hold off
legend({'source +','source -','receivers'},'Location','best')
xlabel('$x\;[m]$')
ylabel('$z\;[m]$')
title(['source \#',num2str(i_e)])
set(gca, 'Ydir', 'reverse')
grid on
fancy_figure()

end