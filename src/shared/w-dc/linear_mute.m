function [d,mute_] = linear_mute(d,drx,t,to,vel_)
% 
% d is a shot gather of size (time by receivers)
% to is where the mute begins,
% vel_ is the velocity ( (x,t)-slope ) above which all will be muted.

[nt,nr] = size(d);
r = 0:drx:(drx*(nr-1));

to_ = to+(r/vel_);
steep=5;
mute_ = zeros(nt,nr);

for i_=1:nr;
  % sigmoid mute 
  mute_(:,i_) = 1 ./ ( 1+exp(-steep*(t-to_(i_))) );
end
% figure;plot(t,mute_(:,3));axis tight;pause
% figure; imagesc(r,t,mute_);colorbar; pause;
d = d .* mute_;
end