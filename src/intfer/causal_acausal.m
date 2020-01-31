function [v_g_causal,v_g_acausal,t_causal] = causal_acausal(v_g,t_corr)
% v_g is virtual shot gather
% t_corr is correlation time

% correlation time t is 2t-1,
% so causal time is
it_o = (numel(t_corr)+1)/2;
t_causal = t_corr(it_o:end);
% causal - acausal
v_g_causal = v_g(it_o:end,:);
v_g_acausal = v_g(1:it_o,:);
v_g_acausal = flip(v_g_acausal);
end