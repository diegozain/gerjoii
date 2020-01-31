function gerjoii_ = dc_M(finite_,gerjoii_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% matrix Mdc transforms received data into
% measured data.
%
% i.e. Mdc*u takes the calculated potential
% and performs differences to it.
%
% nR is number of receivers.
%
%
% Mdc:
%
%						         n*m
%		  -------------------------------------
%		  |			      |						            |
%	nd	|  nonzero	|						            |
%		  |			      |		zero			          |
%		  |			      |						            |
%		  -------------------------------------
%			    nR
%
% ---------------
%     input 
% ---------------
%
% "ia" is index for a_spacing (a=src_a(ia)) of shot.
%       "ia" should be an integer between 1 and numel( src_a ).
% "in" is index for n_spacing (n=an_spacings{ia}(in)) position of shot.
%       "in" should be an integer between 1 and src_n(ia).
%
% "receivers_vectorized" is a cell where,
% r = receivers_vectorized{ia}{in} is an (nd x 2) matrix with receivers in 
%                   vectorized format.
%                   column one is positive rec, column two is negative rec.
%                   corresponds to source:
%                   sources{ia}(in,:,:) (or if vectorized to sources{ia}(in,:))

n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;
r = gerjoii_.dc.r;

nd = size(r,1);
r = r.';
r = r(:);
i_ = (1:nd);
i_ = repmat(i_,[2,1]);
i_ = i_(:);
v = [ones(1,nd); -ones(1,nd)];
v = v(:);
M = sparse(i_,r,v,double(nd),double(n*m));

gerjoii_.dc.M = M;
gerjoii_.dc.nd = nd;
end
