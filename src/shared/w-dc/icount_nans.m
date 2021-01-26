function ix = icount_nans(a)
% get first index where nan stops occuring in a
ix=1;
while isnan(a(ix))
 ix=ix+1;
end
end