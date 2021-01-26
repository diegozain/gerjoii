function domain_ = w_stack_disk(path_,name_,nx,nz,ns)
% diego domenzain
% @ Mines, summer 2020
% 
% this is only used when the domain is to big for memory.
% in that case, the domain is chopped up into many mini domains,
% as many as shot-gathers there are.
% each shot gather's update is computed in its own domain and saved to disk.
% 
% this function takes all chunks from disk and puts them together.
% ------------------------------------------------------------------------------
% path_ is the path where the updates are stored
% name_ is either epsi or sigm
% nx , nz are the big domain sizes
% ns    is the total number of shot-gathers
%
% domain_ is the big domain formed by the smaller ones
% ------------------------------------------------------------------------------
domain_ = zeros(nz,nx,ns);
for is=1:ns
 % -----------------------------------------------------------------------------
 name__ = strcat(path_,num2str(is),'/',name_);
 load(name__);
 % 
 domain__ = domain_mini.domain__;
 ix = domain_mini.ix;
 ix_= size(domain__,2) + ix - 1;
 %
 domain_(:,ix:ix_,is) = domain__;
end
% get overlap of domains on the fly
% (easier to do this than to count outside and import variable)
% 
% collapse on x
n_overlap = sum(domain_~=0,1);
n_overlap = squeeze(n_overlap);
% collapse on x again 
n_overlap = max(sum(n_overlap~=0,2));
% sum up
domain_ = sum(domain_,3)/n_overlap;
end