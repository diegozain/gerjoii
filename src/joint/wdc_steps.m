function a = wdc_steps(Ew,Edc)
% diego domenzain
% boise state university, 2018.
% ------------------------------------------------------------------------------
% finds stepsizes for joint updates in terms of the objective functions values
% ------------------------------------------------------------------------------
Ew_=log10(Ew); Edc_=log10(Edc);
[~,mini] = min([Ew,Edc]);
% if Ew is smallest (Ew_<Edc_)
if mini==1
  aw = 1;
  adc = 1/ (abs(Ew_ - (Edc_+1)))^(0.5);
end
% if Edc is smallest (Edc_<Ew_)
if mini==2
  adc = 1;
  aw = 1/ (abs(Ew_ - (Edc_-1)))^(0.5);
end
a=[aw,adc];
a(find(isinf(a)))=1;
a(find(isnan(a)))=1;
end