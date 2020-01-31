function rgb = rainbow(x,rgb,n_rgb)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% colormap tool
%
% x is vector of values between 0 and 1 that linearly interpolates 
% the rows of rgb.
% rgb is a matrix of (# of colors by 3).
% n_rgb will be the final # of colors of the rgb colormap.
% ------------------------------------------------------------------------------
% if you want the middle of the colorbar to be skewed, change x.
% ------------------------------------------------------------------------------
%
% example:
% 
% 
% imagesc( matrix )
% colormap(rainbow())
% 
% you can also move the middle cream color around:
% colormap(rainbow( 0.2 )) % cream goes low
% colormap(rainbow( 0.5 )) % cream stays in the middle (default)
% colormap(rainbow( 0.8 )) % cream goes up
% ------------------------------------------------------------------------------
if nargin<2
  % % rainbow
  % rgb = [0 1 1; 1 1 0; 1 0 1; 0 1 0; 1 0 0; 0 0 1; 1 1 1];
  % % rainbow 2
  % rgb = [0 1 1; 1 1 0; 1 0 1; 0 1 0; 1 0 0; 0 0 1];
  % % blue-white-orange
  % rgb = [0.230, 0.299, 0.754; 1,1,1 ; 0.759, 0.334, 0.046];
  % % purple-white-red
  % rgb = [0.3533    0.1491    0.5602; 1 1 1; 0.8078    0.0941    0.0941];
  % % for blind ppl i think
  % rgb = [0.217, 0.525, 0.910; 0.865, 0.865, 0.865; 0.677, 0.492, 0.093];
  % for blind ppl i think (blue-red)
  rgb = [0.217, 0.525, 0.910; 0.865, 0.865, 0.865; 0.8078, 0.0941,0.0941];
  % % purple-white-orange
  % rgb = [0.3533    0.1491    0.5602; 1 1 1; 0.8078    0.4275    0.0941];
end
% ------------------------------------------------------------------------------
if nargin>1
  if numel(x)<2
    x=linspace(0,1,size(rgb,1));
  end
end
% ------------------------------------------------------------------------------
if nargin<1
  x=linspace(0,1,size(rgb,1));
end
% ------------------------------------------------------------------------------
if nargin<3
  n_rgb = 255;
  if numel(x)==1
    x=[0 x 1];
  end
end
% ------------------------------------------------------------------------------
rgb = interp1(x,rgb,linspace(0,1,n_rgb));
end