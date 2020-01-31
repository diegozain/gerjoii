function [d,b,c] = fit_gaussian(a_o,x)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% fits observed amplitudes 'a_o' to a gaussian 'a':
%
% a(x) = d*exp( -( (x-b).^2 )/( 2*c^2 ) ) = a_o
% 
% and it does so in a least squares sense.
%
% NOTE:
% a_o and x have to be column vectors.

d=1;
c=1;
for i_=1:5
b = x - sqrt((2*c^2)*(log(d)-log(a_o)));
b = abs(mean(b));
Bb = -(x-b).^2;
unos = ones( size(Bb) );
A = [unos , Bb];
A = (A) \ ( log(a_o) );
d = exp(A(1));
c = sqrt(2*A(2));
end
end