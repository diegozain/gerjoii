function [gerjoii_,finite_] = dc_fwd2_5d(parame_,finite_,gerjoii_)
%
% compute synthetic u field and error.
%
%
%
% sigma_dc <- parameters 		(matrix n x m )
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
%
% 

d_o = parame_.natu.dc.d;
n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;
M = gerjoii_.dc.M;

n_ky = finite_.dc.n_ky;
ky_w_ = finite_.dc.ky_w_;

% compute each u_k_ independently (parfor-able)
u_k = zeros( n*m,n_ky );
for i_=1:n_ky
  finite_.dc.ky = ky_w_(i_,1);
  [gerjoii_,finite_] = dc_fwd_k( parame_,finite_,gerjoii_ );
  u_k(:,i_) = gerjoii_.dc.u_k_;
end
% weighted stack
u = (2/pi) * u_k * ky_w_(:,2);

% field to data
d = M * u;
% error
e_ = d - d_o;
% reshape
u = reshape(u, [n,m] );

gerjoii_.dc.u = u;
gerjoii_.dc.u_k = u_k;
gerjoii_.dc.e_ = e_;
gerjoii_.dc.d = d;
end
