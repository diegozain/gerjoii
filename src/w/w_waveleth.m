function wavelet = w_waveleth(t,ampli,tce,twd,dt)
% diego domenzain
% fall 2021
% ..............................................................................
% this method generates a source signature in all of time with a given amp.
%
% because the wave solver is staggered in time, whatever 'wavlet' is, the
% solver will input the time integral of that.
% the default is the time derivative of a ricker wavelet.
% ------------------------------------------------------------------------------
%                           🍏🍏 Green for impulse 🍏🍏
% ------------------------------------------------------------------------------
% sR = distance from source to receiver
% wavelet = (1/2/pi)*(1/sqrt((vel_*t)^2 - sR^2));
% ------------------------------------------------------------------------------
%                               🍘🍘 Ricker 🍘🍘
% ------------------------------------------------------------------------------
% %         📖 from "Frequencies of the Ricker wavelet". Yanghua Wang.
% fo = 1 / pi / twd; % Hz
% wo = 2*pi*fo;
% tau = 1 / pi / fo;
% wavelet = ( 1-0.5*(wo^2)*(t-tce).^2 ) .* exp( -0.25*(wo^2)*(t-tce).^2 );
% ------------------------------------------------------------------------------
%                          -∂t 🍘🍘 Ricker 🍘🍘
% ------------------------------------------------------------------------------
% wavelet = -(t-tce).*exp( -( ((t-tce).^2) ./ (twd^2) ) );
% ------------------------------------------------------------------------------
%                              🚶 step function 🚶
% ------------------------------------------------------------------------------
% % sd ∼ flat part / 4
% twd = 1 / pi / twd; % hz
% twd = 2.25 / twd; % s
% sd = twd / 4; % s
% % flatness
% fl = 10;

% sd controls the width of the flat part
sd = twd / pi; % s
% flatness
fl = 10;

wavelet = exp(-((t-tce)/sd).^fl);
% ------------------------------------------------------------------------------
%                             ⏰➖⏰ ∂t ⏰➖⏰
% ------------------------------------------------------------------------------
wavelet = differentiate_o6(wavelet,dt);
% ------------------------------------------------------------------------------
%                          📢📢 normalize by amp 📢📢
% ------------------------------------------------------------------------------
wavelet = - ampli * ( wavelet / max(abs(wavelet)) );
end
