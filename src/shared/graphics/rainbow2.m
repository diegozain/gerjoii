function rgb=rainbow2(n)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% to get even better colormaps, concatenate them!
% the factor n will move the white towards the bottom if n>1.
% cmap=rainbow2(8);colormap(cmap)
rgb=rainbow(0,[0.8275    0.7922    0.0745; 0.230, 0.299, 0.754; 0.865,0.865,0.865],64);
% rgb_=rainbow(0,[1 1 1; 0.8078,0.4275,0.0941; 0.8078,0.0941,0.0941],fix(64*n));
rgb_=rainbow(0,[0.865,0.865,0.865; 0.8078, 0.0941,0.0941; 0,0,0],fix(64*n));
rgb=[rgb;rgb_]; 
end