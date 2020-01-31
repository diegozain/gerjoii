% zoom [m]
% rx_zoom_ = 4;
% rx_zoom__ = 13;
rx_zoom_ = 0;
rx_zoom__ = 7;
% get indicies
irx_zoom_ = binning(rx,rx_zoom_);
irx_zoom__ = binning(rx,rx_zoom__);
% crop
d_zoom = d(:,irx_zoom_:irx_zoom__);
rx_zoom = rx(irx_zoom_:irx_zoom__);
% markers [m]
% rx_marks = [5 6 8 9 11 12];
rx_marks = [0 1 2 4 5 6];
rx_marks = ones(size(d_zoom,1),1)*rx_marks;
% markers [ns]
t_marks = [40 60];
t_marks = ones(size(d_zoom,2),1)*t_marks;
% see
figure;
fancy_imagesc(d_zoom,rx_zoom,t,0.7)
hold on;
plot(rx_marks(:,2:end),t,'k--','linewidth',2)
plot(rx_zoom,t_marks,'k--','linewidth',2)
hold off
for i_=1:(size(rx_marks,2)-1)
  text(0.5*(rx_marks(1,i_+1)+rx_marks(1,i_)),t(10),num2abc(i_),'color','black')
end
axis normal
colorbar('off')
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Common offset gather # ',cog_(4:end),' @ ',num2str(fo*1e+3),'MHz'])
simple_figure()

i_=1;
text(0.5*(rx_marks(1,i_+1)+rx_marks(1,i_)),t(20),'+',...
'fontweight','bold','color','black','fontsize',30);%simple_figure();
i_=3;
text(0.5*(rx_marks(1,i_+1)+rx_marks(1,i_)),t(20),'+',...
'fontweight','bold','color','black','fontsize',30);%simple_figure();
i_=5;
text(0.5*(rx_marks(1,i_+1)+rx_marks(1,i_)),t(20),'+',...
'fontweight','bold','color','black','fontsize',30);%simple_figure();