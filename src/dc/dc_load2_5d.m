function [parame_,gerjoii_,finite_] = dc_load2_5d(parame_,gerjoii_,finite_,i_e)
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
% ------------------------------------------------------------------------------
load(strcat(data_path_,'ky_w','.mat'));
% ------------------------------------------------------------------------------
% return values
% ------------------------------------------------------------------------------
% source & receivers
gerjoii_.dc.r_ = r_;
gerjoii_.dc.s_ = s_;
gerjoii_.dc.i_ = i_;
% fourier ky-coefficients and w weights
finite_.dc.ky_w_ = ky_w(:,:,i_e);
% data 2.5d
parame_.natu.dc.d = d;
parame_.natu.dc.std_ = std_;
% clear used variables. "use and destroooooyyy"
% clear dcgram;
clear s_i_r_d_std ky_w;
end