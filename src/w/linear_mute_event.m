function [d,mute_] = linear_mute_event(d,drx,t,t__,t_,vel_)
% 
% d is a shot gather of size (time by receivers)
% to is where the mute begins,
% vel_ is the velocity ( (x,t)-slope ) above which all will be muted.

[nt,nr] = size(d);
r = 0:drx:(drx*(nr-1));

to = t_+(r/vel_);
steep=5;
mute_ = zeros(nt,nr);

for i_=1:nr;  
  to__= t__ + to(i_);
  to_ = t_ + to(i_);
  width_ = to__-to_;
  middle = to_ + width_/2;
  width_ = width_^5;
  mute_(:,i_) = exp(- ((t-middle).^6 / width_ ) );
end
% figure;plot(t,mute_(:,3));axis tight;pause
% figure; imagesc(r,t,mute_);colorbar; pause;
d = d .* mute_;
end

