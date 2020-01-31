function [e_,d_e,d_oe] = w_bozdag(d_o,d,obj_fnc)
% diego domenzain
% fall 2019 @ Colorado School of Mines
% ------------------------------------------------------------------------------
% with different objective functions for the fwi scheme,
% the adjoint source also changes. this function takes care of that.
% see 
% "Misfit functions for full waveform inversion based on 
% instantaneous phase and envelope measurements", Bozdag et. al 2011.
% ------------------------------------------------------------------------------
% determine adjoint source for 
% different objective functions.
if or(strcmp(obj_fnc,'L2') , strcmp(obj_fnc,'FREQstp'))
  e_ = d-d_o;
  d_e = d; d_oe = d_o;
elseif strcmp(obj_fnc,'env_L2')
  [d_e, ~ ,d_H] = instant_(d);
  d_oe = instant_(d_o);
  % --------------------
  % for L2 obj fnc
  % --------------------
  dedoe = (d_e-d_oe)./(d_e);%+mean(d(:)));
  e__ = imag( hilbert(dedoe.*d_H) );
  e_ = d.*dedoe - e__;
  e_(isnan(e_))=0;
elseif strcmp(obj_fnc,'phase_L2')
  [d_e,d_,d_H] = instant_(d);
  [~,d_oe,~] = instant_(d_o);
  % --------------------
  % for L2 obj fnc
  % --------------------
  d_do_ = (d_-d_oe)./(d_e.^2);
  e__ = imag( hilbert(d_do_.*d) );
  e_ = - d_do_ + e__;
  d_e=d_;
elseif strcmp(obj_fnc,'env_L22')
  [d_e, ~ ,d_H] = instant_(d);
  d_oe = instant_(d_o);
  % --------------------
  % for L2 sqrd obj fnc
  % --------------------
  dedoe = d_e.^2 - d_oe.^2;
  e__ = imag( hilbert(dedoe.*d_H) );
  e_ = d.*dedoe - e__;
elseif strcmp(obj_fnc,'env_LOG')
  [d_e, ~ ,d_H] = instant_(d);
  d_oe = instant_(d_o);
  % --------------------
  % for log obj fnc
  % --------------------
  dedoe = real(log( d_oe./d_e ));
  e__ = imag( hilbert( dedoe.*( d_H./(d_e.^2) ) ) ) ;
  e_ = -dedoe.*(d./(d_e.^2)) + e__;
  e_(isnan(e_))=0;
end
end