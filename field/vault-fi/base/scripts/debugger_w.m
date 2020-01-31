clear
close all
% ------------------------------------------------------------------------------
load('/Users/diegox/Desktop/intelecto/geophysics/software/slurm-bsu/scripts/down-view/obs_line1.mat')
radargram_obs=radargram;
load('/Users/diegox/Desktop/intelecto/geophysics/software/slurm-bsu/scripts/down-view/line1.mat')
% ------------------------------------------------------------------------------
load('../../data/w/parame_.mat')
% ------------------------------------------------------------------------------
d=radargram.d;
d_o=radargram_obs.d;
t=radargram.t;
nt=numel(t);
dt=t(2)-t(1);
r = radargram.r; 
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
% ------------------------------------------------------------------------------
% er=d-d_o;
% d=er;
% ------------------------------------------------------------------------------
% d=filt_gauss(d,dt,-0.1,0.1,8);
% ------------------------------------------------------------------------------
%   fourier
% ------------------------------------------------------------------------------
% fprintf('fourier\n');
% % taper edges to zero
% % before fourier
% %
% for i=1:nr
%   d(:,i) = d(:,i) .* tukeywin(nt,0.1);
% end
% % d(t,s) -> d(f,s)
% [d_,f,df] = fourier_rt(d,dt);
% % power
% d_pow = abs(d_).^2 / nt^2;
% %
% figure;
% plot(f,d_pow,'.-')
% axis tight
% xlabel('f (GHz)')
% ylabel('d power')
% simple_figure()
% %
% figure;
% fancy_imagesc(log10(d_pow),rx,f);
% axis normal
% colormap(hsv)
% xlabel('x (m)')
% ylabel('f (GHz)')
% simple_figure()
% ------------------------------------------------------------------------------
% t_=radargram.t_ground_;
% t__=radargram.t_ground__;
% ------------------------------------------------------------------------------
% s = parame_.w.wvlets_(:,1);
% s = -dtu(s,dt);
% [s_new,a] = w_wiener(d,d_o,s);
% % -
% load('/Users/diegox/Desktop/intelecto/geophysics/software/GPR-ER/gerjoii/data/raw/bhrs/w-data/bhrs_w.mat')
% gaussian_=field_.w.gaussian_;
% s_new  = s_new.*gaussian_;
% tuk = tukeywin(nt,2);
% s_new  = s_new.*tuk;
% % ------------------------------------------------------------------------------
% s_new_ =-integrate(double(s_new),dt,0);
% % ------------------------------------------------------------------------------
% figure;
% hold on
% plot(t,s,'.-')
% plot(t,s_new,'.-')
% plot(t,s_new_,'.-')
% % plot(t,d_o(:,1))
% hold off
% legend('current','new','yee')
% 
% figure;
% hold on
% plot(t,gaussian_,'.-')
% plot(t,tuk,'.-')
% hold off
% legend('gaussian','tukey')
% ------------------------------------------------------------------------------
[max_obse,iobse]=min(radargram_obs.d(:,1));
[max_reco,ireco]=min(radargram.d(:,1));
a=max_obse/max_reco;
i_=abs(iobse-ireco);
figure;
plot(radargram_obs.d(:,1))
hold on;
plot(radargram.d(:,1)*a)
% ------------------------------------------------------------------------------
d=radargram.d;
if i_>0
  % d(i_:end,:)=d(1:end-i_+1,:);
  d(1:end-i_,:)=d(i_:end-1,:);
elseif i_<0
  i_=abs(i_)
  % d(1:end-i_,:)=d(i_:end-1,:);
  d(i_:end,:)=d(1:end-i_+1,:);
end
hold on;
plot(d(:,1)*a)
% ------------------------------------------------------------------------------
load('../../data/w/parame_.mat')
parame_.w.wvlets_=parame_.w.wvlets_*a;
parame_.w.wvlets_(1:end-i_,:)=parame_.w.wvlets_(i_:end-1,:);
save('../../data/w/parame_.mat','parame_')
% ------------------------------------------------------------------------------
% load('../../data/w/parame_.mat')
% dx=parame_.dx;
% dz=parame_.dz;
% x=parame_.x;
% z=parame_.z;
% nx=numel(x);
% nz=numel(z);
% epsi_=zeros(nz,nx);
% steep=8;
% z_=2;
% for i_=1:nx;
%   epsi_(:,i_) = 1 ./ ( 1+exp(-steep*(z-z_)) );
% end
% epsi_=epsi_*7;
% epsi_=epsi_+1;
% figure;fancy_imagesc(epsi_,x,z)
