function wavelet = w_wavelet(t,ampli,tau)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% this method generates a source signature in all of time with a given amplitude
% and tau parameter.
% because the wave solver is staggered in time, whatever 'wavlet' is, the 
% solver will input the time integral of that.
% the default is the time derivative of a ricker wavelet. 
% ..............................................................................
% tau = 1/fo/pi;
tau = tau/pi;
to = 5 * tau;
% % ---------
% % Green for impulse
% % ---------
% % sR = distance from source to receiver
% wavelet = (1/2/pi)*(1/sqrt((vel_*t)^2 - sR^2));
% % ---------
% % Ricker
% % ---------
% % from "Frequencies of the Ricker wavelet". Yanghua Wang.
% % w  = 2*pi*f,
% % wo = 2*pi*fo = 2/tau
% wo = 2/tau;
% wavelet = ( 1-0.5*(wo^2)*(t-to).^2 ) .* exp( -0.25*(wo^2)*(t-to).^2 );
% ---------
% - d_t( Ricker )
% ---------
wavelet = -(t-to).*exp( -( ((t-to).^2) ./ (tau^2) ) );
% normalize amplitude
wavelet = ampli * ( wavelet / max(abs(wavelet)) );
end
