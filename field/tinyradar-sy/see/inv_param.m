close all
clear
clc
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will show you the data!')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
% iruns_ =25;
% iruns__=36;
% runs = iruns_:iruns__;
% % ----------------------------------------------------------------------------
% runs(runs==30 ) = [];
% runs(runs==31 ) = [];
% ------------------------------------------------------------------------------
runs = [5,6,49,54,67,68,69];
% ------------------------------------------------------------------------------
ni=50;
nruns=numel(runs);
% ------------------------------------------------------------------------------
EE= zeros(nruns,ni*2);
P = zeros(nruns, 26 );
% ------------------------------------------------------------------------------
for iruns=1:nruns
  iruns_=runs(iruns);
  load(strcat('../inv-param/all/','p_inv',num2str(iruns_),'.mat'));
  load(strcat('../inv-param/all/','as',num2str(iruns_),'.mat'));
  % ----------------------------------------------------------------------------
  as(:,:,1)=[];
  fprintf('run %i had %i iterations\n',iruns_, size(as,3))
  Ews = squeeze(as(2,1,1:ni)).';
  Edc = squeeze(as(2,2,1:ni)).';
  EE(iruns,:) = [Ews Edc];
  % ----------------------------------------------------------------------------
  % p_inv(1:2) = [];
  P(iruns,:) = p_inv;
end
% ------------------------------------------------------------------------------
E_=min(EE);
% ------------------------------------------------------------------------------
Edc_ = E_(ni+1);
Ew_  = E_(1);
E_((ni+1):ni*2) = E_((ni+1):ni*2)-Edc_;
E_(1:ni)        = E_(1:ni)-Ew_;
E_              = E_*1.05;%*1.1;
E_((ni+1):ni*2) = E_((ni+1):ni*2)+Edc_;
E_(1:ni)        = E_(1:ni)+Ew_;
% ------------------------------------------------------------------------------
% dlmwrite('../inv-param/ml/data/EE.txt',EE,'delimiter',' ','precision',20);
% dlmwrite('../inv-param/ml/data/P.txt',P,'delimiter',' ','precision',20);
% dlmwrite('../inv-param/ml/data/E_.txt',E_,'delimiter',' ','precision',20);
% ------------------------------------------------------------------------------
figure;
hold on
for iruns=1:nruns
  if iruns<=fix(nruns/3)
    colo = [1 0 0];
  elseif and(iruns>fix(nruns/3),iruns<=fix(2*nruns/3))
    colo = [0 1 0];
  elseif iruns>fix(2*nruns/3)
    colo = [0 0 1];
  end 
  plot(EE(iruns,(ni+1):ni*2),EE(iruns,1:ni),'.-','markersize',40);%,'color',colo );
  fprintf(' run %i\n',runs(iruns))
  pause;
end
plot(E_((ni+1):ni*2),E_(1:ni),'k.-','markersize',20)
hold off
xlabel('ER')
ylabel('GPR')
title('Objective functions history')
simple_figure()
% ------------------------------------------------------------------------------
% i_=7;
% hold on
% plot(EE(i_,(ni+1):ni*2),EE(i_,1:ni),'k.-','markersize',30);
% hold off

% ------------------------------------------------------------------------------
% linear fit for inversion parameters and objective function histories
Lp = EE\P;
% ------------------------------------------------------------------------------
% match the proposed objective function history with its inversion parameters
p_new = E_*Lp