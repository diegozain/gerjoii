function [parame_,gerjoii_] = dc_image(parame_,finite_,geome_,gerjoii_)
  
  % this function hasn't been modified for sigma_robin !!!!!!!!

% choose source:
% "ia" is index for a_spacing (a=src_a(ia)) of shot.
%       "ia" should be an integer between 1 and numel( src_a )
% "in" is index for n_spacing (n=an_spacings{ia}(in)) position of shot.
%       "in" should be an integer between 1 and src_n(ia).
n_ky = finite_.dc.n_ky;
src_n = gerjoii_.dc.src_n;
src_a = gerjoii_.dc.src_a;
tol_iter = gerjoii_.dc.tol_iter;
tol_error = gerjoii_.dc.tol_error;

iter = 0;
while (E_>tol_error & iter<tol_iter)
  
  % loop over "a" spacings
  for ia=1:numel( src_a );
    
    % loop over "n" spacings
    for in=1:src_n(ia);
      
      % build source
      gerjoii_ = dc_sosi(gerjoii_,geome_,ia,in);
      % choose k-fourier weights for that source
      fintie_.dc.ky_wky_s = finite_.dc.ky_wky{ia}{in};
      % choose receivers for that source
      gerjoii_.dc.r = gerjoii_.dc.receivers_vectorized{ia}{in};
      % build M for that source
      gerjoii_ = dc_M(geome_,gerjoii_);
      % choose observed data
      parame_.natu.dc.d = parame_.natu.dc.data{ia}{in};
      
      % -----------
      %   inversion
      % -----------
      % loop over ky coefficients for this source
      for iky = 1:n_ky
        [ky,wky] = finite_.dc.ky_wky_s(iky,:);
        finite_.dc.ky = ky;
        % compute u_k potential
        [gerjoii_,finite_] = dc_fwd_k(parame_,finite_,geome_,gerjoii_);
        % compute a_k adjoint
        a_k = dc_adjoint( finite_.dc.L_k , gerjoii_.dc.M , gerjoii_.dc.e_k );
        % compute S_k matrix
        S_k = dc_S(parame_,finite_,geome_, gerjoii_.dc.u_k );
        S_k = S_k - ky^2 * sparse_diag( parame_.dc.sigma(:) )' ;
        % compute g_k gradient
        g_k = S_k * a_k;
        % stack wky*g_k gradients
        g = g + wky*g_k;
      end % for "ky"
    end % for "n"
  end % for "a"
end % while


end