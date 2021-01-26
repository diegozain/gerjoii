close all
clear
clc
% ------------------------------------------------------------------------------
% precission of type 
bytes = 8;
% number of pixels
np = logspace(4,8);
% np = linspace(1e+4,1e+8,1e+3);
% number of copies of 2D electric potentials for 2.5D transform
ns = 4;
% number of copies of 2D domain in y-axis for 3D solution
ns_= 4;
% ------------------------------------------------------------------------------
H_         = H_size(bytes,np);
[pot_,L_]  = our_size(bytes,np,ns);
[pot__,L__]= frenchi_size(bytes,np,ns_);
% ------------------------------------------------------------------------------
o_ = pot_+L_;
o__= pot__+L__;
% ------------------------------------------------------------------------------
p_H = polyfit(log10(np),log10(H_),1); %p_H=p_H(1);
p_o = polyfit(log10(np),log10(o_),1); %p_o=p_o(1);
p__o= polyfit(log10(np),log10(o__),1);
% ------------------------------------------------------------------------------
red = logspace( log10(min(min(H_),min(min(o_),min(o__)))) , log10(max(max(H_),max(max(o_),max(o__)))));
% ------------------------------------------------------------------------------
figure;
hold on
loglog(np,H_,'-','Markersize',20,'linewidth',5,'color',[0.5,0.5,0.5])
loglog(np,o__,'--','Markersize',20,'linewidth',5,'color',[0.5,0.5,0.5])
loglog(np,o_,'-k','Markersize',20,'linewidth',5,'color',[0,0,0])

% loglog(np,o_,'w','linewidth',0.1)
% loglog(np,o__,'w','linewidth',0.1)
% loglog(np,H_,'w','linewidth',0.1)
loglog(ones(numel(red),1)*10^5,red,'r','linewidth',5)
hold off
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
axis tight
xlabel('Number of pixels')
ylabel('Memory (Gb)')
simple_figure()
% ------------------------------------------------------------------------------
% fig = gcf;fig.PaperPositionMode = 'auto'; print(gcf,'big-data','-dpng','-r600')
% ------------------------------------------------------------------------------
