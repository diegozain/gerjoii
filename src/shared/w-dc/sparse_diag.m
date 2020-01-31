function a = sparse_diag(a)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
n = numel(a);
I = 1:n; J = I;
a = sparse(I,J,a);
end