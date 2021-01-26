% ------------------------------------------------------------------------------
% 
% MANY 2D synthetic forward models of GPR data. 
% this is for machine learning. only 1D subsurface models.
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
pwd_ = pwd;
cd ../../../../
dir_paths;
cd(pwd_);
% ------------------------------------------------------------------------------
% build geometry and initial guess
% ------------------------------------------------------------------------------
pwd_ = pwd;
cd ../../
param_wdc;
cd(pwd_);
% ------------------------------------------------------------------------------
[parame_,finite_,geome_] = wdc_geom(parame_);
% ------------------------------------------------------------------------------
% set permittivities, conductivities and depths of second layer
% ------------------------------------------------------------------------------
model_param;
% ------------------------------------------------------------------------------
fprintf('\n\n ---------------------------------------------------------------\n')
fprintf('   ok, the total number of 2 layer subsurface scenarios will be: %i\n',n_models_2l)
fprintf('         ...so buckle up, buckaroo\n')
fprintf(' ---------------------------------------------------------------\n')
% ------------------------------------------------------------------------------
% set experiment
% ------------------------------------------------------------------------------
% this is where the sources-receivers are saved
data_path_w = '../mat-file/';
% this will make all experiments have the same receivers
parame_.natu.epsilon_w = eps_;
% ------------------------------------------------------------------------------
% make sources-receivers
experim_check;
% make sure the number of sources (gerjoii_.w.ns) is set to 1 !! (for now)
% ------------------------------------------------------------------------------
% size of convolution filters used in the CNN
% the size should capture smallest wavelength in time and space,
% 
% tmax / tmin = npy/npfy
% xmax / drx  = npx/npfx
% 
npx   = 740; npy = 740;
drx   = max(diff(gerjoii_.w.receivers_real{1}(:,1)));
xmax  = max(gerjoii_.w.receivers_real{1}(:,1)) - min(gerjoii_.w.receivers_real{1}(:,1));
tmax  = geome_.w.T(end);
l1    = lam_(1);
epsmin= min(eps_);
c     = parame_.w.c;
% ------------------------------------------------------------------------------
nfx_ = drx/xmax;
nfy_ = 2*l1*sqrt(epsmin) / (c*tmax);
% ------------------------------------------------------------------------------
fprintf('\n\n       CNN width  filter size  = %i \n',nfx_*npx)
fprintf('       CNN height filter size  = %i \n',nfy_*npx)
% ------------------------------------------------------------------------------
fprintf('\n the size of the data (time by receivers) is: %i by  %i\n\n',numel(geome_.w.T),size(s_r_{1,2},1))
% ------------------------------------------------------------------------------
% 
%             example of a "linear combination" of models
% 
% ------------------------------------------------------------------------------
% every nl, the index for the models jumps to another depth 
nl = me*ms*(me-1)*(ms-1);
% ------------------------------------------------------------------------------
% % randomly choose from all depths. Not all will be present.
% I_ = randperm(ml-1);
% I_ = nl*I_ + randi(nl-1,1,(ml-1))
% --
% % randomly choose from all depths. All will be present.
% I_ = 1:(ml-1);
% I_ = nl*I_ + randi(nl-1,1,(ml-1))
% --
% % randomly choose from only ml_ depths. Every ml_ will be present.
% ml_= 5;
% I_ = 1:ml_:(ml-1);
% I_ = nl*I_ + randi(nl-1,1,numel(I_))
% --
% % randomly choose ml_ consecutive depths
% ml_= 3;
% I_ = 0:(ml_-1);
% I_ = nl*I_ + randi(nl-1,1,numel(I_)); % [1,32]
% --
% specifically choose I_
I_ = [10 16 22];
% .............................................................................
[epsi,sigm,I_] = w_model_2l_(geome_.X,geome_.Y,eps_,sig_,lam_,I_);
I_
% .............................................................................
figure;
fancy_imagesc(sigm,geome_.X,geome_.Y);
colormap(rainbow2(1));
xlabel('Length (m)')
ylabel('Depth (m)')
title('Conductivity (mS/m)')
simple_figure()
% .............................................................................
figure;
fancy_imagesc(epsi,geome_.X,geome_.Y);
colormap(rainbow2(1));
xlabel('Length (m)')
ylabel('Depth (m)')
title('Permittivity ( )')
simple_figure()
% ..............................................................................
% 8,1,1,8,8
% 8,4,4,4,4,3 

npx=740;
nfx=3;

me=3;
ms=2;
ml=4;

a=8;
ncnn=npx-nfx*a+1;
ncnn = floor(ncnn/2);

a=16;
ncnn =ncnn-nfx*a+1;
ncnn = floor(ncnn/2);

a=32;
ncnn =ncnn-nfx*a+1;
ncnn = floor(ncnn/2);

a=8;
ncnn =ncnn-nfx*a+1;
ncnn = floor(ncnn/2);


