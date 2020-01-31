function [epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamm)
%
% epsi_star = epsi - i*epsi_ 
%
% sigm_effective = sigm_dc + omeg_o * epsi_
% 
% from john's 2007 paper @ 250MHz:
% (Frequency-dependent attenuation analysis of ground-penetrating radar data)
%
% dry sand
% [epsi,epsi_] = w_colecole(3.4,5.7,2*pi*0.25,8,0.7)
%                 3.6062
%                 0.2945      sigm_dc = 0.45 (mS/m)
% moist sand
% [epsi,epsi_] = w_colecole(5.6,8.9,2*pi*0.25,11,0.75)
%                 5.7766
%                 0.3258      sigm_dc = 2    (mS/m)
% wet sand
% [epsi,epsi_] = w_colecole(25.6,29,2*pi*0.25,22.2,0.88)
%                 25.6339
%                 0.1440      sigm_dc = 6.06 (mS/m)
% clay (30% water)
% [epsi,epsi_] = w_colecole(20.7,43,2*pi*0.25,18.3,0.66)
%                 22.0376
%                 1.8630      sigm_dc = 42.5 (mS/m)
% ------------------------------------------------------------------------------
epsi = eps_inf + ( (eps_dc-eps_inf) ./ (1+(1i*omeg*tau).^gamm) );
epsi_= - imag(epsi);
epsi = real(epsi);
end