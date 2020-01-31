function [sr_mat,receivers,src_recs] = w_sr(ns,nz,nx,data_path_)

% data_path_ = parame_.w.data_path_;
load(strcat(data_path_,'s_r_','.mat'));
% load src-recs from all lines (shot-gathers) and 
% store receivers in one big list
receivers = [];
src_recs = cell(ns,1);
for is=1:ns
  % load(strcat(data_path_,'line',num2str(is),'.mat'));
  % access receivers on binned coordinates
  % -- r --
  rx = s_r_{is,2}(:,1); % ix
  rz = s_r_{is,2}(:,2); % iz
  % make a big list of recs
  r = sub2ind([nz,nx],rz,rx);
  receivers = [receivers; r];
  % store source # with its baby receivers
  src_recs{is} = uint32(r);
end
receivers = uint32(receivers);
% thin down 'receivers' to only unique elements.
% this list will be the master list for receivers.
% NOTE: if a special ordering is to be done on receivers, 
% this is where to change that.
receivers = unique(receivers);
nr_total = numel(receivers);
% form source-receivers matrix
sr_mat = sparse(ns,nr_total);
for is=1:ns
  % get recs for this source in index coord of full domain
  s_recs = src_recs{is};
  % get indicies of recs in master list
  % [C,ia,ib] = intersect(A,B) , 
  % C = A(ia) and C = B(ib)
  s_recs = intersect(receivers,s_recs);
  % store as activated entry in sr_mat
  sr_mat(is,s_recs) = 1;
end
end