function vid_w(u,x,z,dt,filename,centered,pct)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% use:
%
% u=gerjoii_.w.u_2d; x=geome_.X;z=geome_.Y;dt=geome_.w.dt;
% vid_w(u,x,z,dt,'u'); 
% ------------------------------------------------------------------------------
% u is a space-time cube
nt = size(u,3);
% -----
% get nice colormaps
clmap=rainbow([0 0.5 1]);
% clmap=rainbow2(0.4);
% -----
% get nice axis
u_max=max(u(:)); u_min=min(u(:));
% % - NOTE: only for u centered around zero
if strcmp(centered,'y')
  u_min = -min(abs([u_max,u_min]));
  u_max = -u_min;
end
%-------------------------------------------------------------------------%
% video wave
vidObj = VideoWriter(filename);
vidObj.Quality = 100;
vidObj.FrameRate = 2;     % larger # = faster movie , 100 is good for wave
% [left bottom width height]
rect = [20 120 510 220];
open(vidObj);
%-------------------------------------------------------------------------%
for it=1:nt
%-------------------------------------------------------------------------%
 % display
 figure(1001);
 fancy_imagesc(u(:,:,it),x,z);
 % u
 colormap(clmap)
 caxis(pct*[u_min, u_max]); % 8e-1 3e-1
 time_ = dt*(it-1);
 title(['iteration # ' num2str(time_)]);%,'Interpreter','Latex');
 xlabel('x (m)');
 ylabel('z (m)');
 axis image;
 simple_figure();
 getframe;
 % video wave
 writeVideo(vidObj, getframe(gcf,rect));
%-------------------------------------------------------------------------% 
end
%-------------------------------------------------------------------------%
% video wave
close(gcf)
close(vidObj);
%-------------------------------------------------------------------------%
end