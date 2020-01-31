function a = normali(a)
a_maxi = max(abs(a(:)));
if a_maxi==0
  a_maxi=1;
end
a=a/a_maxi;
end