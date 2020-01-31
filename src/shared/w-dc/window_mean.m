function [u,meaner] = window_mean(u,c)
% window-mean the columns of u,
% with a width c.
% ---
% build window
meaner = ones(c,1)/c;
% mean it
u = conv2(u,meaner,'same');
% ---
% % dt=0.005;nt=1000;c=20;t=((0:(nt-1))*dt).';d=t;
% % d_=d; [d_meaned,meaner] = window_mean(abs(d_),c); d_ = d_ ./ d_meaned; 
% % figure;hold on;plot(t,d_,'k.-');plot(t,d,'r.-');plot(t,d_meaned,'b.-');
% ---
% fix edges
% ending
a=c./(ceil(c*0.5):(c-1));
for i_=0:(fix(c*0.5)-1)
  u(end-i_,:) = u(end-i_,:)*a(i_+1);
end
% begining
a=c./((fix(c*0.5)+1):c);
for i_=0:(fix(c*0.5)-1)
  u(i_+1,:) = u(i_+1,:)*a(i_+1);
end
end
% ------------------------------------------------------------------------------
% % example
% dt=0.1; nt=100;
% t=(0:(nt-1))*dt;t=t.'; % [s]
% u=rand(nt,1);
% c=1; % [s]
% c = fix(c/dt);
% [u_,meaner] = window_mean(u,c); 
% [u_white,meaner] = window_mean(abs(u),c); 
% u_white = u ./ u_white; 
% figure;
% subplot(2,1,1)
% hold on
% plot(t,u)
% plot(t,u_)
% plot(t,u_white)
% hold off
% legend({'signal','average','whitened'})
% axis tight
% subplot(2,1,2)
% plot((0:(c-1))*dt,meaner)
% ylim([0 1])
% legend({'averager'})
% axis tight
% 
