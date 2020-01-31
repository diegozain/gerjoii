% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
%
%   dc experiments
%
% ..............................................................................
% builds experiment parameters.
% 
% depends on structures: 
% 
%     parame_, finite_ and geome_
%
% structure gerjoii_ has to be defined already,
% so when joining with the dc it doesn't get re-written.
% ..............................................................................
% number of electrodes
n_electrodes = 17;
% electrode spacing. [ms]
dr = 1;
parame_.dc.dr = dr;
% wanna do double sided acquisition?
abmn_flip = 'yes';
% ..............................................................................
% generate shots
[abmn_dd,abmn_wen,abmn] = dc_gerjoii2iris(n_electrodes);
if strcmp(abmn_flip,'yes')
  abmn_ = dc_abmn_flip(abmn,n_electrodes);
  abmn = [abmn ; abmn_];
  abmn = unique(abmn,'rows');
end
% -----------------------------
% schlumberger ?
% -----------------------------
abmn_sch = dc_schlumberger(n_electrodes);
abmn = [abmn ; abmn_sch];
% 
[n_shots,~] = size(abmn);
% collect sources
src = abmn(:,1:2);
% collect receivers
rec = abmn(:,3:4);
% set electric current value for sources [A]
i_o = ones(n_shots,1);
% set observed data to zero 
d_o = zeros(n_shots,1);
% set standard deviation to zero
std_o = zeros(n_shots,1);
% bundle sources, current, receivers, observed data and standard deviation,
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
s_i_r_d_std = dc_iris2gerjoii( src,i_o,rec,d_o,std_o );
% set real coordinates of electrodes (x,z) [m]
% electrode spacing is dr
electr_real = [ ((dr*(0:n_electrodes-1)) + 2).' , zeros(n_electrodes,1) ];
% bundle variables in structure gerjoii_.dc.
gerjoii_.dc.electr_real = electr_real;
gerjoii_.dc.n_electrodes = n_electrodes;
gerjoii_.dc.n_exp = size( s_i_r_d_std , 2 );
% ------------------------------------------------------------------------------
% plot src-rec pairs
for i_e=1:gerjoii_.dc.n_exp
  s_all{i_e} = s_i_r_d_std{ i_e }{ 1 }(1:2);
  r_all{i_e} = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
end
% dc_plot_srcrec_all(gerjoii_,geome_,s_all,r_all);
% ------------------------------------------------------------------------------
% save
% experiments data is saved in 
% data_path_, accessed in natur__dc.m -> dc_natur_.m, 
% and completed in the end of natur__dc.m
% ------------------------------------------------------------------------------
name = strcat(data_path_dc,'s_i_r_d_std_nodata','.mat');
save( name , 's_i_r_d_std' );
% clear
clear electr_real n_electrodes src i_o rec d_o std_o s_all r_all dr;
