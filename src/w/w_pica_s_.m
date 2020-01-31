function step_w_s = w_pica_s_(geome_,parame_,finite_,gerjoii_)
k_s = gerjoii_.w.k_s;
d_w = gerjoii_.w.d_2d;
e_w = gerjoii_.w.e_2d;
% --------------------------
% find optimum k_e for pica
% --------------------------
% first choose bwd or fwd finite difference approx to the Jacobian:
fwd_bwd =  1; % fwd
% fwd_bwd = -1; % bwd
% for w_boundstep.m the gradient has to be normalized beforehand and,
% the Jacobian is to be approximated by a bwd or fwd finite difference:
% k_s = w_boundstep(parame_.w.sigma,fwd_bwd*gerjoii_.w.g_s,parame_.w.sig_max_);
% ---
% for w_boundstep.m the gradient does not have to be normalized beforehand and,
% the Jacobian is to be approximated by a bwd or fwd finite difference.
k_s = w_boundstep2(parame_.w.sigma,fwd_bwd*gerjoii_.w.g_s,...
                  gerjoii_.w.regu.sig_max_ , gerjoii_.w.regu.sig_min_,k_s)*0.05;
% log2exp conversion
parame_.w.sigma = parame_.w.sigma .* ...
                    exp( fwd_bwd*k_s*parame_.w.sigma .* gerjoii_.w.g_s);
% fwd run
[~,gerjoii_] = w_fwd_(geome_,parame_,finite_,gerjoii_,0);           
% step like Pica
d_w_ = fwd_bwd*(gerjoii_.w.d_2d + d_w);
step_w_s = k_s *((d_w_(:).' * e_w(:)) / (d_w_(:).' * d_w_(:)));
% % check pica won't leave the stability region, and if it does leave fix it
% fprintf('    step sig %2.2d\n', step_w_s );
% fprintf('    step k_s %2.2d\n', k_s );
end
