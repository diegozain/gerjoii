function d = w_sort(sr_mat,receivers,src_recs,line_sr,data_path_,nt)

[ns,nr_total] = size(sr_mat);
% 'line_sr' is a list of indicies in sr_mat,
%  make them subscripts
[is,ir] = ind2sub([ns,nr_total],line_sr);
% get number of subscripts
ns_ = numel(is);
% check if pairs [is,ir] are in the data
% i.e. if source-receiver pair exists,
% maybe [is,ir] references a skipped trace!!
n_traces = 0;
for is_=1:ns_
  if sr_mat(is(is_),ir(is_))==1
    n_traces = n_traces + 1;
  end
end
% allocate space for new sorted data
d = zeros(nt,n_traces);
for is_=1:ns_
  if sr_mat(is(is_),ir(is_))==1
    load(strcat(data_path_,'line',num2str(is(is_)),'.mat'));
    % get receiver # on the data that matches master list # ir(is_)
    r_master = receivers(ir(is_));
    ir_no = src_recs{is(is_)};
    ir_no = find(ir_no==r_master);
    % put the trace corresponding to that rec # in the new data
    d(:,is_)  = radargram.d(:,ir_no);
  end
end
end