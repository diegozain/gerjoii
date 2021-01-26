function wave=gengabor(f,t,dt,t0,phi);
% from John Bradford, fall 2020
% 
%generates a gabor wavelet
%format:  wave=gengabor(f,t,dt,t0)
%f:  dominant frequency of wavelet
%t:  time series
%dt: width of guassian window
%t0: time dilation
%phi: wavelet phase constant

wave=exp(-(t-t0).^2/2/dt^2).*cos(2*pi*f*(t-t0)+phi);


end