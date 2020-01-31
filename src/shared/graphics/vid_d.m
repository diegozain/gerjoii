function trace_video(u_o,X,T,filename)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% u is a space-time cube
% u_o is a time-width square

[Tmax,n] = size(u_o);
u_obs = zeros(Tmax,n);
%-------------------------------------------------------------------------%
% video wave
vidObj = VideoWriter(filename);
vidObj.Quality = 100;
vidObj.FrameRate = 100;     % larger # = faster movie
open(vidObj);
marg = 30;
pos = [73.8000   47.2000  434.0000  342.3000];
rect = [marg, -marg, pos(3)-1.5*marg, pos(4)+2*marg];
%-------------------------------------------------------------------------%
for t = 1:Tmax  
%-------------------------------------------------------------------------%
   % display
   u_obs(1:t,:) = u_o(1:t,:);
   % plotting stuff
   imagesc(X,T,u_obs(:,:))
   colormap(b2r(-7e-3, 7e-3))
   caxis([-7e-3 7e-3])
   axis square;
%    ylabel('t [ns]','FontSize',14);
%    xlabel('receivers [m]','FontSize',14);
   title('observation of wave','FontSize',14);
   getframe;
   % video wave
   writeVideo(vidObj, getframe(gca,rect));
%-------------------------------------------------------------------------% 
end
%-------------------------------------------------------------------------%
% video wave
close(gcf)
close(vidObj);
%-------------------------------------------------------------------------%
end