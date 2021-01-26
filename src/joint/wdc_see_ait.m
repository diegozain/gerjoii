close all
clc
clear
% ------------------------------------------------------------------------------
n_iter = 50;
iter = 1:(n_iter-1);
iter_ = 1:(fix(n_iter*0.6));
iter__ = (fix(n_iter*0.4)):n_iter;
% adc
adc_ = 0.5;
low_ite = fix(n_iter*0.25);
low_adc = 0.2;
x = [1 low_ite iter_(end-1) iter_(end)];
y = [adc_ low_adc 1 1];
p = polyfit(x,y,3);
adc = polyval(p,iter_);
adc = [adc ones(1,numel(iter)-numel(iter_))];
% aw
aw = logistic(iter,[0.3*n_iter,-0.45]);
aw = aw+low_adc*0.5; aw=aw/max(aw);
aw_ = adc_;
low_ite_w = fix(n_iter*0.8);
low_aw = low_adc;
% ------------------------------------------------------------------------------
% aw_ = adc_;
% low_ite_w = fix(n_iter*0.75);
% low_aw = low_adc;
% x = [iter__(1) iter__(2) low_ite_w n_iter];
% y = [1 1 low_aw aw_];
% p = polyfit(x,y,3);
% aw = polyval(p,iter__);
% aw = [ones(1,numel(iter)-numel(iter__)) aw];
% ------------------------------------------------------------------------------
figure('Position',[360 400 560 297]);
hold on
plot(iter,aw,'k-','linewidth',5);
plot(iter,adc,'-','color','[0.5 0.5 0.5]','linewidth',5);
hold off
text(1+1,adc_*1.01,'{\bf (0)}')
text(1+low_ite*0.2,adc_*0.65,'{\bf (1) or (3)}')
% text(iter_(end-4),0.85,'{\bf (3)}')
text(iter__(12),0.85,'{\bf (2)}')
text(low_ite_w*0.95,aw_*0.5,'{\bf (2) or (4)}')
set(gca,'YTick',[0 0.5 1])
axis tight
ylim([0 1])
legend({'$a_w$','$a_{dc}$'},'Location','south','Interpreter','latex')
xlabel('Iteration #')
ylabel('Weights')
title('Bowtie weights history')
simple_figure()
% ------------------------------------------------------------------------------
% % cross gradient weights
% load('bse.txt'); 
% be=bse(2:2:end); 
% bs=bse(1:2:end);
% ------------------------------------------------------------------------------
% cross gradient weights
adc=adc.';
% -- he < de
he = 1e-5; % 1e-2;
de = 1; % 1e-1;
be_do = ( he*(adc./aw) - (he-de)*adc_ ).*aw;
% --- he >= de
he = 5e-1; % 1e-1;
de = 5e-1; % 1e-2;
be_up = ( he*(adc./aw) - (he-de)*adc_ ).*aw;
% ------------------------------------------------------------------------------
% be=be_up;
% bet_e = 0.3*ones(size(be));
% save('weights/bet_e.mat','bet_e')
% save('weights/be.mat','be')
% save('weights/aw.mat','aw')
% save('weights/adc.mat','adc')
% ------------------------------------------------------------------------------
% figure;
hold on
plot(iter,be_do,'-','color','[0.5 0 0]','linewidth',5);
plot(iter,be_up,'-','color','[0 0 0.5]','linewidth',5);
hold off
simple_figure()
% ------------------------------------------------------------------------------
% 
% for field paper
% 
% ------------------------------------------------------------------------------
% cross gradient weights
% -- he >= de
hs = 1.5e-3; 
ds = 1e-4; 
bs_ = ( hs*(adc./aw) - (hs-ds)*adc_ ).*aw;
% -- he >= de
he = 2e-3; 
de = 8e-4; 
be_ = ( he*(adc./aw) - (he-de)*adc_ ).*aw;
% ------------------------------------------------------------------------------
figure;
subplot(211)
hold on
plot(iter,aw,'color','[0 0 0]','linewidth',5)
plot(iter,adc,'color','[0.5 0.5 0.5]','linewidth',5)
hold off
axis tight
ylabel('Weight value')
% xlabel('Iteration #')
simple_figure()
subplot(212)
hold on
plot(iter,be_,'color','[0 0 0]','linewidth',5)
plot(iter,bs_,'color','[0.5 0.5 0.5]','linewidth',5)
hold off
axis tight
ylabel('Weight value')
xlabel('Iteration #')
simple_figure()
% ------------------------------------------------------------------------------
% save('weights/bs_.mat','bs_')
% save('weights/be_.mat','be_')
% ------------------------------------------------------------------------------
