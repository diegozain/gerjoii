function P_w = w_kurzmann(u_w,a_max,c_stab)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% compute Kurzmann preconditioner.
% ..............................................................................
a = max(abs(u_w),[],3) + a_max;
b = 1 ./ (a + c_stab * mean(a(:)));
P_w = b / max(b(:));

end
