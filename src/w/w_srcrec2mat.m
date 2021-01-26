function [SR_,recs_unique] = w_srcrec2mat(s_r_)
% ..............................................................................
%                 build a matrix of (sources x receivers)
% ..............................................................................
% s_r_ is a cell where,
%
% s_r_{shot #, 1}(:,1) is index of sx
% s_r_{shot #, 1}(:,2) is index of sz
% s_r_{shot #, 2}(:,1) is index of rx
% s_r_{shot #, 2}(:,2) is index of rz
% ..............................................................................
% SR_ is a matrix where, 
% 
% row i has a one in column j if source-receiver pair ij exists in the survey.
% ..............................................................................
ns = size(s_r_,1);
% ..............................................................................
% get all unique receivers of survey 
recs_unique = s_r_{1, 2};
for is=2:ns
      recs_unique = unique([recs_unique ; s_r_{is, 2}],'rows') ;
end
% ..............................................................................
nr = size(recs_unique,1);
% ..............................................................................
SR_ = zeros(ns,nr);
% ..............................................................................
for is=1:ns
      recs_ = s_r_{is, 2};
      for ir_=1:size(recs_,1)
            for ir=1:nr
                  if isequal(recs_(ir_,:),recs_unique(ir,:))
                        SR_(is,ir)=1;
                  end
            end
      end
end
% ..............................................................................
SR_=sparse(SR_);
end