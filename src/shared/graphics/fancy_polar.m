function fancy_polar(d,r,theta,sc)
[r,theta] = meshgrid (r , theta );
x_polar = (r.*cos(theta)).'; 
y_polar = (r.*sin(theta)).';
polar(x_polar,y_polar);
% ------
% find all of the lines in the polar plot
delete(findall(gcf,'type','line'));
% find and remove all of the text objects in the polar plot
delete(findall(gcf,'type','text'))
% ------
hold on
contourf(x_polar , y_polar , d, 300 , 'edgecolor','none','fill','on') ; 
hold off
axis image
clmap = fancy_colormap(1);
colormap(clmap)
if nargin==4
  amp = max(d(:));
  caxis([-sc*amp sc*amp]);
end
cc = colorbar('southoutside');
cc.TickLength = 0;
end
