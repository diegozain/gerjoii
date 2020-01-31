function [d,b,c] = fit_hyperexp(a_o,x)
%
% fits observed amplitudes 'a_o' to a hyperbola+exponential 'a':
%
% a(x) = ( 1/(x+b) )*exp(-c*(x+b)) = a_o
%
% and it does so in a least square sense.
%
% NOTE:
% a_o and x have to be column vectors.
%
% a(x) = ( 1./(x+b) ).*exp(-c*(x+b)) = a_o
% c = - (log(a_o)+log(x+b))./(x+b);

d=1;
b=0;
c = - (log(a_o)+log(x+b))./(x+b);
c = abs(mean(c));
for i_=1:5
Bb = log(x+b);
unos = ones( size(Bb) );
A = [-x , -Bb , -unos];
A = A\log(a_o);
c = abs(A(1));
A(2)
b = abs(A(3)/c);
end
end