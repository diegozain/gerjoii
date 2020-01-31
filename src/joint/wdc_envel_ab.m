function gab = wdc_envel_ab(a,b)
% -----------------------------
% envelopes & hilbert transform
% -----------------------------
% amean = mean(a(:));
% bmean = mean(b(:)));
[a_,a__] = envelope_(a);
b_ = envelope_(b);
amean = mean(a_(:));
bmean = mean(b_(:));
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
% gab = (e_a.*(a)) ./ (a_+amean);
gab = e_a.*a;
% second part of gradient
% [~,geab_]=envelope_((e_a.*a__) ./ (a_+amean));
[~,geab_]=envelope_( e_a.*a__ );
% full gradient, normalize and 'push' gradient g_e
gab=gab-geab_; 
% gab(isnan(geab_))=0;
% -----------------------------
% normalize & add to fwi gradient
% -----------------------------
gab=normali(gab);
end