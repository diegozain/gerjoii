close all
clear
clc
t=(0:0.01:100).';
wo=2;
bo=2;
to=20;
co=-0.5;
po=[wo;bo;to;co]
s_o_ = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to)+co);
figure;plot(t,s_o_,'r','linewidth',5);hold on;

s_o = exp(-((t-to).^2)./((bo*5)^2)) .* cos(wo*0.1*(t-to)+co*2);
plot(t,s_o,'k--');

p=[wo*0.1;to]
[wo,to]=fit_ricker(s_o_,t,p,'n');
s_o = ( 1-0.5*(wo^2)*(t-to).^2 ) .* exp( -0.25*(wo^2)*(t-to).^2 );
plot(t,s_o,'g','linewidth',3);

p=[wo;bo*5;to]
[wo,bo,to,E_] = fit_gabor(s_o_,t,p,'n');
s_o = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to));
plot(t,s_o,'b','linewidth',3);

p=[wo;bo;to;co*2]
[wo,bo,to,co,E_] = fit_gabor_(s_o_,t,p,'n');
s_o = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to)+co);
plot(t,s_o,'k','linewidth',2);

legend({'True','Initial','Ricker fit','Gabor fit','Gabor-Shift fit'})
xlabel('Time')
ylabel('Amplitue')
simple_figure();

p=[wo;bo;to;co]

figure;
plot(E_,'.-','markersize',15)
