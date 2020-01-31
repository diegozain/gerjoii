function hw = wdc_hw(Ews,Edc,adc_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% compute weight h for joint update.
% ------------------------------------------------------------------------------
if Edc<Ews
  % reverse loop
  hw = 1;
  adc = Inf;
  while (adc>adc_)
    a = wdc_steps(hw*Ews,Edc);
    adc = a(2);
    hw = 0.5*hw;
  end
  % forward loop
  while (adc<adc_)
    a = wdc_steps(hw*Ews,Edc);
    adc = a(2);
    hw = 1.05*hw;
  end
else
  % forward loop
  hw = 1;
  adc = 0;
  while (adc<adc_)
    a = wdc_steps(hw*Ews,Edc);
    adc = a(2);
    hw = 1.5*hw;
  end
  % reverse loop
  while (adc>adc_)
    a = wdc_steps(hw*Ews,Edc);
    adc = a(2);
    hw = 0.95*hw;
  end
end
end