function [pseus_do,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoa,a,n_electrodes)

% full list of dipole-dipole src-rec pairs (just right sided receivers)
[abmn_dd,~,~] = dc_gerjoii2iris(n_electrodes);
% just for a-spacing -> cell2matrix
src_rec = bundle_abmn( abmn_dd , a);
% observed list of src-rec pairs
src_rec_o = [src rec];
% get number of sources from current a-src-rec list
ns = size(src_rec,1);
% declare pseudo-section matrix
pseus_rhoa = nan(size(abmn_dd{a},1) +1,size(abmn_dd{a}{1},1)*2 +1);
pseus_do = nan(size(abmn_dd{a},1) +1,size(abmn_dd{a}{1},1)*2 +1);
% loop over sources in this list to populate the pseudo section
for i_src = 1:ns
  % set src-rec for common shot gather
  src_rec_ = src_rec(i_src,:);
  % get indicex of when this src-rec happens
  [~,isrc_] = ismember(src_rec_o,src_rec_,'rows');
  isrc_ = find(isrc_);
  % collect data from common shots
  rhoa_a = rhoa(isrc_);
  d_o_a = d_o(isrc_);
  if numel(rhoa_a) > 0
    n_level =( src_rec_(3)-src_rec_(2) )/a;
    source_no = 2*src_rec_(1)-1+(n_level-1)*(a):2*src_rec_(1)+(n_level-1)*(a);
    pseus_rhoa( n_level,source_no ) = rhoa_a;
    pseus_do( n_level,source_no ) = d_o_a;
  end
end
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function abmn = bundle_abmn( abmn_dd , a )
% ---------------
%   print surveys
% ---------------
abmn = [];
% dipole-dipole survey
nlvl_max = size(abmn_dd{a},1);
for n_lvl=1:nlvl_max
  abmn = [abmn; abmn_dd{a}{n_lvl}];
end
end