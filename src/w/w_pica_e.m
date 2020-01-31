function step_w_e = w_pica_e(geome_,parame_,finite_,gerjoii_)
k_e = gerjoii_.w.k_e;
d_w = gerjoii_.w.d_2d;
e_w = gerjoii_.w.e_2d;
% log2exp conversion
parame_.w.epsilon = parame_.w.epsilon .* ...
                    exp(k_e*parame_.w.epsilon .* gerjoii_.w.g_e);
% fwd run
[~,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_);
% step like Pica         
d_w_ = gerjoii_.w.d_2d - d_w;
step_w_e = k_e *((d_w_(:)' * e_w(:)) / (d_w_(:)' * d_w_(:)));
end
