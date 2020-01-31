function d = filt_svd(d,cut_off)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% svd filter of an image d:  remove horizontal high amplitudes.
% ..............................................................................
[nt,nr]=size(d);
[V,E,Q]=svd(d);
E(1:cut_off,1:nr)=zeros(cut_off,nr);
d = V*E*Q';
% % normalize
% d = d./repmat(max(d),[nt,1]);
end