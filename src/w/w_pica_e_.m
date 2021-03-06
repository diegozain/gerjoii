function step_w_e = w_pica_e_(geome_,parame_,finite_,gerjoii_)
k_e = gerjoii_.w.k_e;
d_w = gerjoii_.w.d_2d;
e_w = gerjoii_.w.e_2d;
% --------------------------
% find optimum k_e for pica
% --------------------------
% first choose bwd or fwd finite difference approx to the Jacobian:
% fwd_bwd =  1; % fwd
fwd_bwd = -1; % bwd
% for w_boundstep.m the gradient has to be normalized beforehand and,
% the Jacobian is to be approximated by a bwd or fwd finite difference:
% k_e = w_boundstep(parame_.w.epsilon,fwd_bwd*gerjoii_.w.g_e,parame_.w.eps_max_);
% ---
% for w_boundstep.m the gradient does not have to be normalized beforehand and,
% the Jacobian is to be approximated by a bwd or fwd finite difference.
k_e = w_boundstep2(parame_.w.epsilon,fwd_bwd*gerjoii_.w.g_e,...
                  gerjoii_.w.regu.eps_max_ ,gerjoii_.w.regu.eps_min_,k_e);
% log2exp conversion
parame_.w.epsilon = parame_.w.epsilon .* ...
                    exp( fwd_bwd*k_e*parame_.w.epsilon .* gerjoii_.w.g_e);
% fwd run
[~,gerjoii_] = w_fwd_(geome_,parame_,finite_,gerjoii_,0);           
% step like Pica
d_w_ = fwd_bwd*(gerjoii_.w.d_2d - d_w);
step_w_e = k_e *( (d_w_(:).' * e_w(:)) / (d_w_(:).' * d_w_(:)) );
% print steps and mins
fprintf('step eps %2.2d\n', step_w_e );
% fprintf('step k_e %2.2d\n', k_e );
end
