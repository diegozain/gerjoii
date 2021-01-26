function [wdc_dsigma_,a] = wdc_dsigma(wdsigma,dcdsigma,Ew,Edc,step_)
% diego domenzain
% boise state university, 2018.
% ---- in
% wdsigma:  is the raw dsigma update from the wave
% dcdsigma: is the raw dsigma update from the dc
% Ew & Edc: are the current objective function values for wave and dc
% step_   : amplify or dim final amplitude of dsigma
% ---- out
% wdc_dsigma_: is the joint update ready for rock 'n rolling
% a:          are the weights used for summing the dsigma's & saves Ew,Edc too.
% ---- gerjoii_
% in gerjoii_ structure:
% [gerjoii_.wdc.dsigma,a_] = wdc_dsigma(gerjoii_.w.dsigma,...
%                                       gerjoii_.dc.dsigma,...
%                                       gerjoii_.w.E_,gerjoii_.dc.E_,step_);
% ------------------------------------------------------------------------------
% magic weight calculation
% ------------------------------------------------------------------------------
a = wdc_steps(Ew , Edc);
% ------------------------------------------------------------------------------
% normalizing updates
% NOTE: could it be better??
% ------------------------------------------------------------------------------
wdsig_  = max(abs(wdsigma(:)));
dcdsig_ = max(abs(dcdsigma(:)));
% ------------------------------------------------------------------------------
if wdsig_==0
  wdsig_=dcdsig_;
end
if dcdsig_==0
  dcdsig_=wdsig_;
end
% ------------------------------------------------------------------------------
wdsigma  = normali(wdsigma);
dcdsigma = normali(dcdsigma);
% ------------------------------------------------------------------------------
% weighing updates
wdsigma  = a(1)*wdsigma; 
dcdsigma = a(2)*dcdsigma.';
wdc_dsigma_ =  wdsigma + dcdsigma;
% ------------------------------------------------------------------------------
% find step-size for joint update 
% NOTE: could it be better??
% ------------------------------------------------------------------------------
amp = [wdsig_ , dcdsig_];
fprintf('\n         the amplitude for dsigma_w  = %d\n',wdsig_);
fprintf('         the amplitude for dsigma_dc = %d\n',dcdsig_);
% ------------------------------------------------------------------------------
% % min of amp
% amp = min(amp);
% ------------------------------------------------------------------------------
% % maxi of max(a)
% [~,amp_i] = max(a);
% amp = amp(amp_i);
% ------------------------------------------------------------------------------
% max of amp
% ------------------------------------------------------------------------------
% % This one worked for the complicated example (Part 2 paper)
% amp = max(amp);
% ------------------------------------------------------------------------------
%  geometric average
% ------------------------------------------------------------------------------
% This one worked for the box (Part 1 paper).
% Maybe it worked for the original BHRS inversion, not sure :(
amp = geomean(amp);
% ------------------------------------------------------------------------------
fprintf('         the amplitude for dsigma    = %d\n\n',step_ * amp);
% update
wdc_dsigma_ = step_ * amp * normali(wdc_dsigma_);
% % ----------------------------------------------------------------------------
% % store a 
% % ----------------------------------------------------------------------------
% a_ = zeros(1,2);
% a_(1,:) = a;
end