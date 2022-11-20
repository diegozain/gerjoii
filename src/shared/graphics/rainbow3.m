function rgb=rainbow3(n)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% to get even better colormaps, concatenate them!
% the factor n will move the white towards the bottom if n>1.
% cmap=rainbow2(8);colormap(cmap)
rgb=rainbow(0,[0.3765,0.0353,0.6196; 0.8980,0.3059,0.0706; 0.865,0.865,0.865],64);
rgb_=rainbow(0,[0.865,0.865,0.865; 0.2510,0.5490,0.2549; 0.8275,0.7922,0.0745],fix(64*n));
rgb=[rgb;rgb_]; 
end
