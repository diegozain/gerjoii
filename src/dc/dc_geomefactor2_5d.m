function gerjoii_ = dc_geomefactor2_5d(parame_,finite_,gerjoii_)
%
% compute synthetic u field and error.
%
%
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


n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;

% geometric factor
%
% k = i / voltage(sig=1)
%
% sigma_a = i / (k * voltage)
%
% rho_a   = k * voltage / i
%
parame_.dc.sigma_robin = ones(n,m);
% % get average conductivity == 1
% gerjoii_.dc.sig_o = 1;
[gerjoii_,finite_] = dc_fwd2_5d(parame_,finite_,gerjoii_);
d = gerjoii_.dc.d;
gerjoii_.dc.k = 1 ./ d;

% u_green2_5d = dc_analhomo2_5d(parame_,finite_,gerjoii_);
% M = gerjoii_.dc.M;
% d = M*u_green2_5d(:);
% gerjoii_.dc.k = 1 ./ d;


end
