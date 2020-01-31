function a = sparse_full_(a,b)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% --
% Multiply elementwise a sparse matrix 'a' times a 
% full matrix made of many identical row vectors 'b'.
% --
% Bad way to do this is a = a.*repmat(b,size(a,1),1),
% your computer may die if you try.
% --
% This way exploits sparsity structure on 'a'.
% ------------------------------------------------------------------------------
% get nnz ij subindicies
[i,j]=find(a);
% transform nnz ij as if it were a looooong column vector
i_=sub2ind(size(a),i,j);
% now you can multiply like so because 
% b(j) repeats elements that are 
% repeated in j.
a = a(i_).*b(j);
a = sparse(i,j,a);
end