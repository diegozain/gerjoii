clc
close all
clear
epsi_max=20;
epsi=[4,4,4];
% epsi=[2,3,19];
g=[1e-1,-1e-4,-1];
depsi=-g;
% get value
k = w_boundstep(epsi,depsi,epsi_max)
% check
epsi.*exp(k*epsi.*depsi)
% % check update:
% step_ = pica step on backwards derivative
% k_ = w_boundstep(epsi,-g,epsi_max)
% step_e = min([k_,step_])