function [ieps,isig,ieps_,isig_,il] = w_index2model_2l(me,ms,ml,i_)
% find the indicies in the discretizations of eps, sig and lambda 
% for the 2 layer model.
% 
% the i_'th model has:
% two layers,
%    first  layer with values eps(ieps) and sig(isig)
%    second layer with values eps(ieps_) and sig(isig_)
% the second layer is lambda(il) deep.
% ..............................................................................
% the model index space is parametrized by a cube matrix of size
%       n_models = me*ms*(me-1)*(ms-1)*ml
% where:
% ml is the number of elements of lambda
% me is the number of elements of eps
% ms is the number of elements of sig
% ..............................................................................
% get index in cube matrix, and also the lambda index
[i_mems,i_mems_,il] = ind2sub([me*ms,(me-1)*(ms-1),ml], i_ );
% get index of first layer values
[ieps,isig]         = ind2sub([me,ms], i_mems );
% get index of second layer values
index_         = 1:(me*ms);
index_ = reshape(index_,[me,ms]);
index_(:,isig) = [];
index_(ieps,:) = [];
index_         = index_(:);
i_mems_        = index_(i_mems_);
[ieps_,isig_]  = ind2sub([me,ms], i_mems_ );
end