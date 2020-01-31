function vid_xz(u,X,Y,u_min,u_max,filename)

% u is a space-thick cube
[~,~,ndepth] = size(u);
[clmap,~,~] = fancy_colormap(u);

%-------------------------------------------------------------------------%

% video wave
%
vidObj = VideoWriter(filename);
vidObj.Quality = 100;
vidObj.FrameRate = 5;     % larger # = faster movie % 100
% [left bottom width height]
rect = [0 65 550 260]; % 10 20 400 420. 80 0 400 420
open(vidObj);
%

%-------------------------------------------------------------------------%
                       

for i = 1:ndepth
    
%-------------------------------------------------------------------------%
   
   % display
   %
   figure(1001);
   imagesc(X,Y,u(:,:,i));
   
   % u
   %
   colormap(clmap)
   c = colorbar;
   c.TickLength = 0;
   caxis([u_min,u_max]);
   title(['conductivity at iteration ' num2str(i)]);
   xlabel('x [m]');
   ylabel('z [m]');
   axis image;
   fancy_figure();
   
   getframe;

   % video wave
   %
   writeVideo(vidObj, getframe(gcf,rect));

%-------------------------------------------------------------------------% 
end
                       
%-------------------------------------------------------------------------%

% video wave
%
close(gcf)
close(vidObj);

%-------------------------------------------------------------------------%

end
