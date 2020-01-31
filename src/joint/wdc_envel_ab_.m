function geab = wdc_envel_ab_(a,b)
% -----------------------------
% envelopes & hilbert transform
% -----------------------------
amean = mean(a(:));
bmean = mean(b(:));
[a_,a__] = envelope_(a);
b_ = envelope_(b);
% -----------------------------
% center around zero, 
% square (for eliminating concave-convex problem),
% and normalize envelopes
% -----------------------------
a_=normali((a_-amean).^2);
b_=normali((b_-bmean).^2);
% -----------------------------
% compute error
% -----------------------------
e_a = a_-b_;
% -----------------------------
% gradient
% -----------------------------
geab = (e_a.*(a)) ./ (a_+amean);
% second part of gradient
[~,geab_]=envelope_((e_a.*a__) ./ (a_+amean));
% full gradient, normalize and 'push' gradient g_e
geab=geab-geab_;
geab(isnan(geab_))=0;
% -----------------------------
% normalize & add to fwi gradient
% -----------------------------
geab=normali(geab);
end