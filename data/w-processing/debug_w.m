load('line11.mat')
d=radargram.d;
[nt,nr]=size(d);
d_=zeros(nt,nr-1);
for i_=1:(nr-1)
  d_(:,i_) = d(:,i_+1)-d(:,i_);
end
d__ = sum(d_.^2);
[~,i_] = min(d__);
figure;
hold on
plot(d(:,i_),'.-','markersize',20)
plot(d(:,i_+1),'.-','markersize',20)
hold off
i_
i_+1

load('line2.mat')
d=radargram.d;
d(:,46)=[];
radargram.d=d;
save('line2.mat','radargram')
load('line5.mat')
d=radargram.d;
d(:,24)=[];
radargram.d=d;
save('line5.mat','radargram')


i_=54;
tr = d(:,i_+1)-d(:,i_);
figure;
plot(t,tr)
axis tight
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
simple_figure()