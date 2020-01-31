function [gerjoii_,finite_] = dc_fwd2d(parame_,finite_,gerjoii_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% compute synthetic 2d electric potential field and error with oberved data.
% ------------------------------------------------------------------------------
%
% sigma_dc <- parameters 		(matrix n x m )
% s_dc <- source 			(vector n x 1 )
% Mdc <- field to data		(matrix d x nm ) 
% 					d size of data
% d_o <- vector 			(vector d x 1 )
% DELTAS <- lenghts of disc	(matrix n x m )
%
%                    ###
%                   #o###
%                 #####o###
%                #o#\#|#/###
%                 ###\|/#o#
%                  # }|{  #
%            n       }|{
%     ------------------
%       |            |
%       |            |
%   m   |            |
%       |            |
%       |            |
%       --------------
%
% returns u = (n x m) matrix
%	  e = (d x 1)  vector

% build pde solver matrix L
%
finite_ = dc_L(parame_,finite_,gerjoii_);
L = finite_.dc.L;

d_o = parame_.natu.dc.d_2d;
n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;
s = gerjoii_.dc.s;
M = gerjoii_.dc.M;

% field everywhere
%
u = L \ s;
% field to data
%
d = M * u;
% error
%
e_ = d - d_o;
u = reshape(u,[n,m]);

% % geometric factor
% %
% parame_.dc.sigma_robin = ones(n,m);
% finite_ = dc_L(parame_,finite_,gerjoii_);
% L = finite_.dc.L;
% u_ = L\s;
% d_ = M*u_;
% k = 1./d_;
% gerjoii_.dc.k_2d = k;

gerjoii_.dc.u_2d = u;
gerjoii_.dc.e_2d = e_;
gerjoii_.dc.d_2d = d;

end
