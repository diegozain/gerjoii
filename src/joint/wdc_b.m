function b = wdc_b(h,d,adc_,adc,aw)
% % -------------------------
% b = h*(adc./aw);
% % ------------------------- lehmann
% b = h*(adc./aw)-(h-d)*adc_;
% ------------------------- sonic
b = (h*(adc./aw)-(h-d)*adc_).*aw;
% % ------------------------- r3
% b = (h*(aw./adc)-(h-d)*adc_).*adc;
% -------------------------
if or(isnan(b),isinf(b))
  b=0;
end
end