function [gerjoii_,finite_] = dc_fwd_k(parame_,finite_,gerjoii_)
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


% build pde solver matrix L
%
finite_ = dc_Lk(parame_,finite_,gerjoii_);

sigma_robin  = parame_.dc.sigma_robin;
Lk  = finite_.dc.Lk;
s = gerjoii_.dc.s;
s = 0.5*s;

% compute k-fourier potential
u_k = Lk \ s;

gerjoii_.dc.u_k_ = u_k;

end