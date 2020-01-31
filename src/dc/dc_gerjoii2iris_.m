function [src,rec,cur,d_o,std_,ns] = dc_gerjoii2iris_(s_i_r_d_std)
% ------------------------------------------------------------------------------
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
% 
% example:
% >> s_i_r_d_std{1}
% 
% ans = 
% 
%     [1x3 double]                     [14x4 double]
%  srcs(x,z) and current (A)      recs(x,z), data (V), std_.
% ------------------------------------------------------------------------------
% rhoa_o_.mat
% the data (V) converted to app. resistivity with geometric factor k_factor.mat
% ------------------------------------------------------------------------------
ns  = numel(s_i_r_d_std);
src =[];
cur =[];
rec =[];
d_o =[];
std_=[];
% ------------------------------------------------------------------------------
for is=1:ns
  d_o  = [d_o; s_i_r_d_std{ is }{ 2 }(:,3)];   % gives observed data.
  std_ = [std_; s_i_r_d_std{ is }{ 2 }(:,4)]; % gives observed std.
  rec_ = s_i_r_d_std{ is }{ 2 }(:,1:2);       % gives receivers.
  rec  = [rec; rec_];
  src_ = s_i_r_d_std{ is }{ 1 }(1:2);         % gives source.
  cur_ = s_i_r_d_std{ is }{ 1 }(3);           % gives current.
  src_ = repmat(src_,size(rec_,1),1);
  cur_ = repmat(cur_,size(rec_,1),1);
  src  = [src; src_];
  cur  = [cur; cur_];
end
end