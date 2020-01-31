function [parame_,gerjoii_] = dc_load(parame_,gerjoii_,i_e)
%
% loads field data from hard disk sotred file.
% 'i_e' indexes source #
%
% ----------------------------------------
data_path_ = parame_.dc.data_path_;
load(strcat(data_path_,'s_i_r_d_std','.mat'));
s_ = s_i_r_d_std{ i_e }{ 1 }(1:2);
i_ = s_i_r_d_std{ i_e }{ 1 }(3);
r_ = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
d = s_i_r_d_std{ i_e }{ 2 }(:,3);
std_ = s_i_r_d_std{ i_e }{ 2 }(:,4);
% ----------------------------------------
% data_path_ = parame_.dc.data_path_;
% load(strcat(data_path_,'line',num2str(i_e),'.mat'));
% % load everything
% d    = dcgram.d;
% s_   = dcgram.s_;
% i_   = dcgram.i_;
% r_   = dcgram.r_;
% std_ = dcgram.std_;
% ----------------------------------------
% ------------------------------------------------------------------------------
% return values
% ------------------------------------------------------------------------------
% source & receivers
gerjoii_.dc.r_ = r_;
gerjoii_.dc.s_ = s_;
gerjoii_.dc.i_ = i_;
% data 2d
parame_.natu.dc.d_2d = d;
parame_.natu.dc.std_2d = std_;
% data 2.5d
parame_.natu.dc.d = d;
parame_.natu.dc.std_ = std_;
% clear used variables. "use and destroooooyyy"
% clear dcgram;
clear s_i_r_d_std;
end