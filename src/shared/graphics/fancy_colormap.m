function [clmap,c_axis,amp] = fancy_colormap(a)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% a is a matrix to be plotted using imagesc 
%

% for plotting
sc=0.3;

% % john's version
% clo=[0 0 1];cmid=[.99 .99 .99];chi=[.5 .12 0];

% green
% [0.1411    0.4782    0.1807]
% yellow
% [0.8275    0.7922    0.0745]
% [1.0000    0.9765    0.6667]
% purple
% [0.3533    0.1491    0.5602]
% [0.9020    0.8196    1.0000]
% red
% [0.7399 0.1019 0.1019]
% blue
% [0.0745    0.3882    0.8275]
% shit
% [0.3098    0.2353    0.0118]
% pistache
% [0.7098    1.0000    0.7373]
% gris
% [0.4863    0.4863    0.4784]
% gris oscuro
% [ 0.2000    0.2000    0.1961]
% azul-verde fosforescente
% [0    0.7961    1]
% mas fosforescente
% [0.4000    1.0000    0.9294]
% [0.8667    0.9922    1]
% naranja
% [0.8078    0.4275    0.0941]
% super rojo
% [0.8078    0.0941    0.0941]
% fosforescente light
% [0.6431    0.9765    0.9882]
% azul claro
% [0.8902    0.9608    0.9882]

% % purple-blue-red
% % lowest color
% clo=[0.3533    0.1491    0.5602];
% % middle color
% cmid=[0.8000    0.9922    1.0000];
% % highest color
% chi=[0.8078    0.0941    0.0941];

% % orange-white-green
% % lowest color
% clo=[0.1411    0.4782    0.1807];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.8078    0.4275    0.0941];

% purple-white-red
% lowest color
clo=[0.3533    0.1491    0.5602];
% middle color
cmid=[0.99 0.99 0.99];
% highest color
chi=[0.8078    0.0941    0.0941];

% % purple--white
% % lowest color
% clo=[0.3533    0.1491    0.5602];
% % middle color
% cmid=[0.1411    0.4782    0.1807];
% % highest color
% chi=[0.99 0.99 0.99];

% % yellow-white-blue
% % lowest color
% clo=[0.8275    0.7922    0.0745];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.1176    0.2980    0.5882];

% % green-red-blue
% % lowest color
% clo=[0.8275    0.7922    0.0745];
% % middle color
% cmid=[0.8078    0.0941    0.0941];
% % highest color
% chi=[0.0745    0.3882    0.8275];

% % green-white-blue
% % lowest color
% clo=[0.1411    0.4782    0.1807];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.0745    0.3882    0.8275];

% % purple-white-orange
% % lowest color
% clo=[0.3533    0.1491    0.5602];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.8078    0.4275    0.0941];

% % purple-white-green
% % lowest color
% clo=[0.3533    0.1491    0.5602];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.1411    0.4782    0.1807];

% % black-blue-red
% % lowest color
% clo=[0 0 0];
% % middle color
% cmid=[0.8667    0.9922    1];
% % highest color
% chi=[0.8078    0.0941    0.0941];

% % black-purple-red
% % lowest color
% clo=[0 0 0];
% % middle color
% cmid=[0.3533    0.1491    0.5602];
% % highest color
% chi=[0.8078    0.0941    0.0941];

% % black-white-blue
% % lowest color
% clo=[0 0 0];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.0745    0.3882    0.8275];

% % black-white-red
% % lowest color
% clo=[0 0 0];
% % middle color
% cmid=[0.99 0.99 0.99];
% % highest color
% chi=[0.8078    0.0941    0.0941];

clmap=mkclrmap(clo,cmid,chi);

amp = max(a(:));
c_axis = [-sc*amp sc*amp];
end