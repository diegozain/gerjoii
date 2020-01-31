function [pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoa,n_electrodes)

% --------
%   wenner
% --------

% full list of wenner src-rec pairs
[~,abmn_wen,~] = dc_gerjoii2iris(n_electrodes);
% observed list of src-rec pairs
src_rec_o = [src rec];

% at most, a-spacing can be,
a_max = fix((n_electrodes-1)/3);
% at most, n-levels can be (take a=1),
n = n_electrodes-3;

% declare pseudo-section matrix
pseus_rhoa = nan(a_max,2*(n)+1);
pseus_do = nan(a_max,2*(n)+1);

% set a-spacing
for a=1:a_max
% for a=2:2
  % src-rec for this a-spacing
  src_rec = abmn_wen{a};
  % get number of sources from current a-src-rec list
  ns = size(src_rec,1);
  % loop over sources in this list to populate the pseudo section
  for i_src = 1:ns
    % set src-rec for common shot gather (only one data pt for wenner)
    src_rec_ = src_rec(i_src,:);
    % get indicies of when this shot happens
    [~,isrc_] = ismember(src_rec_o,src_rec_,'rows');
    isrc_ = find(isrc_);
    % collect data from common shots
    rhoa_a = rhoa(isrc_);
    d_o_a = d_o(isrc_);

    pseus_rhoa( a , 2*i_src-1+(3*a-3) : 2*i_src+(3*a-3) ) = rhoa_a;
    pseus_do( a , 2*i_src-1+ (3*a-3) : 2*i_src+ (3*a-3) ) = d_o_a;
  end
end

end