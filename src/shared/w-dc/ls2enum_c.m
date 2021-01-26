function c = ls2enum_c(c,n)
% input class index, output the folder name
% ------------------------------------------------------------------------------
a = ls2enum(n);
c = a(c);
end