function gerjoii_ = dc_geomefactor_2d(parame_,finite_,gerjoii_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% compute geometric factor for a given source-sink-receivers configuration.
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
s = gerjoii_.dc.s;
M = gerjoii_.dc.M;

% geometric factor
%
% k = i / voltage(sig=1)
%
% sigma_a = i / (k * voltage)
%
% rho_a   = k * voltage / i
%
parame_.dc.sigma_robin = ones(n,m);
finite_ = dc_L(parame_,finite_,gerjoii_);
L = finite_.dc.L;
u_ = L\s;
d_ = M*u_;
gerjoii_.dc.k_2d = 1./d_;

end
