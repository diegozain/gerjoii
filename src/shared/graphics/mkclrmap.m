function [nc]=mkclrmap(lowc,midc,hic,middle)

%
% make fancy colormap
%
% John Bradford gave me this,
% but he kept complaining about the
% color scale in my figures so
% I had to change his code.
%
% example:
%
% lowc = [0 0 1];
% midc = [.99 .99 .99];
% hic = [.5 .12 0];
% cmap = mkclrmap(lowc,midc,hic);
% colormap(cmap)
% --
% number of colors is 256.
nc = zeros(3,256);
% let's move where the 'middle' color is in the color-scale
if nargin<4
  middle=0.5;
end
i_mid = fix(middle*256); % 12
i_mid_ = 256-(i_mid+1); % 243
% R
nc(1,1:(i_mid+1)) = [lowc(1):(midc(1)-lowc(1))/i_mid:midc(1)];
nc(1,(i_mid+1):256) = [midc(1):(hic(1)-midc(1))/i_mid_:hic(1)];
% G
nc(2,1:(i_mid+1)) = [lowc(2):(midc(2)-lowc(2))/i_mid:midc(2)];
nc(2,(i_mid+1):256) = [midc(2):(hic(2)-midc(2))/i_mid_:hic(2)];
% B
nc(3,1:(i_mid+1)) = [lowc(3):(midc(3)-lowc(3))/i_mid:midc(3)];
nc(3,(i_mid+1):256) = [midc(3):(hic(3)-midc(3))/i_mid_:hic(3)];
% john codes things weirdly:
nc = nc.';

end
