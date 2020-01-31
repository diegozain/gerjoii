function A = sparse_full(A,b)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% Multiply elementwise a sparse matrix 'A' times a 
% full matrix made of many identical column vectors 'b'.
% --
% Bad way to do this is A = A.*repmat(b,1,size(A,2)),
% your computer may die if you try.
% --
% This way exploits sparsity structure on 'A'.
% ------------------------------------------------------------------------------
% get nnz ij subindicies
[i,j]=find(A);
% transform nnz ij as if it were a looooong column vector
i_=sub2ind(size(A),i,j);
% now you can multiply like so because 
% b(i) repeats elements that are 
% repeated in i.
A = A(i_).*b(i);
A = sparse(i,j,A);
end