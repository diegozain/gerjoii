function step_w_s = w_pica_s(geome_,parame_,finite_,gerjoii_)
k_s = gerjoii_.w.k_s;
d_w = gerjoii_.w.d_2d;
e_w = gerjoii_.w.e_2d;
% log2exp conversion
parame_.w.sigma = parame_.w.sigma .* ...
                    exp(k_s*parame_.w.sigma .* gerjoii_.w.g_s);
% fwd run
[~,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_);           
% step like Pica
d_w_ = gerjoii_.w.d_2d - d_w;
step_w_s = k_s *((d_w_(:)' * e_w(:)) / (d_w_(:)' * d_w_(:)));
end