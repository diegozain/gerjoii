function a = divide_nnz(a,b)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% divide a by b only in nnz entries of b
% ------------------------------------------------------------------------------
% get nnz ij subindicies of b
[i,j]=find(b);
% transform nnz ij as if it were a looooong column vector
ib_=sub2ind(size(b),i,j);
% divide 
a(ib_) = a(ib_)./b(ib_);
% ------ clean --------------
% get zero ij subindicies of b
[i,j]=find(b==0);
% transform nnz ij as if it were a looooong column vector
ib=sub2ind(size(b),i,j);
a(ib) = 0;
end