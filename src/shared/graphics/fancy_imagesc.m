function fancy_imagesc(a,x,z,sc)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
[clmap,~,~] = fancy_colormap(a);
switch nargin
  case 4
    amp=max(a(:));
    imagesc(x,z,a,[-sc*amp sc*amp])
  case 3
    imagesc(x,z,a)
  case 1
    imagesc(a)
end
colormap(clmap)
c = colorbar('southoutside');
c.TickLength = 0;
% mina = full(min(a(:))); maxa = full(max(a(:))); meana = mean(full(a(:)));
% if mina == maxa
%   labels = meana;
% elseif fix(mina) ~= fix(maxa)
%   labels = [fix(mina) fix(maxa)];
% else
%   labels = [mina maxa];
% end
% set(c,'YTick',labels);

% labels = fix(labels./0.001)*0.001;
% if labels(1)==labels(2)
%   labels = labels(1)
% end
% labels(1) = []; % ceil(labels(1)/0.01)*0.01;
% set(c,'YTick',labels);
axis image
end