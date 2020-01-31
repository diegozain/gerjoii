function d_ = d_cog_f(d_cog,dt,f_disper,v,alph,dsr_)

[nt,nr] = size(d_cog);
d_ = zeros(nt,nr);

for ir=1:nr
dro = d_cog(:,ir);
[~,d__,~] = ftan(dro,dt,f_disper,v,alph,dsr_);
d__=abs(d__);
d__=sum(d__,1)/size(d__,1);
d_(:,ir) = d__.';
fprintf('done with receiver %2.2d of %2.2d \n',ir,nr);
end
end