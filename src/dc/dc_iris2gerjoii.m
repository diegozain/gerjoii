function s_i_r_d_std = dc_iris2gerjoii( src,i_o,rec,d_o,std_o )
% s_i_r_d_std is a cell of ns cells:
% 
% { { [s i],[r d_o] }, ..., { [s i],[r d_o] }  }
%
% [s i] is (1 by 3) first two entries are source, third is current.
% [r d_o std_o] is (nr_si by 4) where
%         nr_si is # of receivers for that source & current.
% ns is # of shots done, i.e. # of fwd models to do.
%
% example of usage:
% suppose we want to model src & current # j:
%
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
%
% ---------
% input:
% ---------
% src: sources (source and sink pair) numbered.
% i_o: input current
% rec: receivers (r+ and r- pair) numbered.
% d_o: observed voltages.
% ------------------------------------------------------------------------------
% bundle sources and current
src_i = [src i_o];
% there will be as many independent shots as different elements in src_i
[ns,~] = unique(src_i,'rows');
ns = size(ns,1);
s_i_r_d_std = cell(1,ns);
ii=1;
while size(src_i,1) > 0
  src_i_ = src_i(1,:);
  % get indicies of when this shot & current happen
  [~,isrc_i] = ismember(src_i,src_i_,'rows');
  isrc_i = find(isrc_i);
  % collect receivers, data & std from common shots with common current
  rec_ = rec(isrc_i,:);
  d_o_ = d_o(isrc_i);
  std_o_ = std_o(isrc_i);
  % 
  s_i_r_d_std_ = cell(1,2);
  s_i_r_d_std_{1} = src_i_;
  s_i_r_d_std_{2} = [rec_ d_o_ std_o_];
  % 
  s_i_r_d_std{ii} = s_i_r_d_std_;
  ii = ii+1;
  % pop src, current, rec, data and std from lists
  src_i(isrc_i,:) = [];
  rec(isrc_i,:) = [];
  d_o(isrc_i) = [];
  std_o(isrc_i) = [];
end
end
