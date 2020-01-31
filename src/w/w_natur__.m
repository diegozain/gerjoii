function wvlet_ = w_natur__(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% runs GPR forward model for one source (indexed by input 'is').
% this program reads sources and receivers made in experim_wdc.m or experim_w.m.
% it then goes on to shoot and record electromagnetic wave data.
% -
% each survey line is saved with data structure 'radargram' but named line.mat
% and saved in data_path_, which is defined in experim_wdc.m or experim_w.m.
% ..............................................................................
% this path is defined in natur__w, wdc_begin_ or wdc_forward_
data_path_ = parame_.w.data_path_;
data_path__= parame_.w.data_path__;
% ----- load meta  ------
[parame_,gerjoii_] = w_load(parame_,gerjoii_,is);
% ----- fwd models ------
[~,gerjoii_] = w_fwd_(geome_,parame_,finite_,gerjoii_,0);
% ------ radargram ------
% load radargram
load(strcat(data_path_,'line',num2str(is),'.mat'));
% overwrite data
radargram.d = gerjoii_.w.d_2d;  % [s] x [m]
radargram.Jy= gerjoii_.w.Jy;    % recorder of source
% save
name = strcat(data_path__,'line',num2str( is ),'.mat');
save( name , 'radargram' );
% ..............................................................................
fprintf('   just finished gpr fwd model               #%i\n',is);
end