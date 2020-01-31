function gerjoii_ = w_freqchoose(gerjoii_,parame_,iter,dE_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% choose frequencies for frequency scheme inversion
% ..............................................................................
% % my way
% % ..............................................................................
% f = gerjoii_.w.regu.frequis; % 0.05*1e+9; % [Hz]
% if numel(f)>0
%   % frequency scheme
%   gerjoii_.w.regu.fstp__ =   f(1); % 0.4*1e+9; % [Hz]
%   gerjoii_.w.regu.fstp_  = - f(1);
%   % pop frequency used
%   f(1) = [];
%   gerjoii_.w.regu.frequis = f;
% end
% ..............................................................................
% Adam Mengel's way
% ..............................................................................
tol = gerjoii_.w.regu.f_tol;
Fpi = gerjoii_.w.regu.Fpi;
Fsi = gerjoii_.w.regu.Fsi;
fo  = parame_.w.fo;
% ..............................................................................
% At the first iterations, start band limiting
if iter == 0
  % Fpi = 0.05*fo; % start with the passband at 10% of the central frequency
  % Fsi = 1.1*Fpi;
  % --
  Fpi = -0.5*fo;
  Fsi =  0.5*fo;
% elseif and(Fpi < 0.9*fo , Fsi< parame_.w.f_high)
elseif Fsi < parame_.w.f_high
  % If the cost function changes by more than the tolerance, 
  % stay in the current band. 
  % If the cost function doesn't change considerably,
  % move on to the next frequency band.
  if dE_ > -tol && dE_ <= 0
    % Fpi = 1.1*Fpi; % increase the pass band by 10% of the previous passband
    % Fsi = 1.1*Fpi;
    % --
    Fpi = 2.5*Fpi;
    Fsi = 2.5*Fsi;
    if Fsi> parame_.w.f_high
      Fpi = -parame_.w.f_high;
      Fsi =  parame_.w.f_high;
    end
    fprintf('\n        JUMPED! the frequency band is now %d to %d Hz\n\n',Fpi,Fsi)
  else
    fprintf('\n        NO JUMP! the frequency band is still %d to %d Hz\n\n',Fpi,Fsi)
  end
% elseif or(Fpi > 0.9*fo , Fsi> parame_.w.f_high)
else
  fprintf('\n          JUMPED! to use the full frequency band\n')
  % Using full bandwidth to reconstruct
  gerjoii_.w.regu.f_yesno='NO';
  Fpi = -parame_.w.f_high;
  Fsi =  parame_.w.f_high;
end
% ..............................................................................
gerjoii_.w.regu.Fpi = Fpi;
gerjoii_.w.regu.Fsi = Fsi;
gerjoii_.w.regu.fstp_ = Fpi;
gerjoii_.w.regu.fstp__= Fsi;
end