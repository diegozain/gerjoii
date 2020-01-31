% ------------------------------------------------------------------------------
%
%
% set paths for gerjoii
%
%
% ------------------------------------------------------------------------------
gerjoii = pwd;
% ------
% source
% ------
addpath( genpath(strcat(gerjoii,'/src/shared')) );
addpath( strcat(gerjoii,'/src/dc') );
addpath( strcat(gerjoii,'/src/w') );
addpath( strcat(gerjoii,'/src/intfer') );
addpath( strcat(gerjoii,'/src/joint') );
% ------
%   data
% ------
addpath( genpath(strcat(gerjoii,'/data/raw')) );
clear gerjoii
