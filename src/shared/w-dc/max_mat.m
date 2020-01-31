function curve = max_mat(a,J_,I_)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% returns curve of maximum values of a matrix (I_,J_),
% 
% I_ parametrizes columns,
% J_ parametrizes rows.
% 
% to plot on top of imagesc(J_,I_,a) do,
% 
% plot(curve(:,2),curve(:,1))

[~,i_max] = max(a);
curve_I = I_(i_max);

if size(curve_I,1) == 1
  curve_I = curve_I.';
end
if size(J_,1) == 1
  J_ = J_.';
end
curve = [curve_I , J_];
end