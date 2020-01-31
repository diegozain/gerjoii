function a = wdc_amp_ab(a,b)
% demean
a=a-mean(a(:)); b=b-mean(b(:));
% normalize
a=normali(a); b=normali(b);
% square
a=a.^2; b=b.^2;
% difference
a=(a - b);
% normalize difference
a=normali(a);
% % flatten?
end