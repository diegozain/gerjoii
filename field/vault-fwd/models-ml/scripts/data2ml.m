% diego domenzain
% spring 2020 @ CSM
% ..............................................................................
%
%   get all data ready for ml
%
% ..............................................................................
% wdc_fwd_2l;
% wdc_fwd_test; 
% ..............................................................................
% train
dc2voltagrams;
% test
dc2voltagrams;
% ..............................................................................
% train
!python dc2pics.py
% test
!python dc2pics.py
% ..............................................................................
% train
!python w2pics.py
% test
!python w2pics.py
% ..............................................................................
% train
!python im2rgb.py
% test
!python im2rgb.py
% ..............................................................................
!sh just_pics.sh
% ..............................................................................
% train
models2mat.m
% test
models2mat_.m
% ..............................................................................
% train
!python models2pics.py
% test
!python models2pics.py
% ..............................................................................
% train
!sh model-pics.sh
% test
!sh model-pics.sh
% ..............................................................................
% train
!python see_models.py
% test
!python see_models.py
% ..............................................................................
!python thumb_grid.py
!python thumb_grid.py
!python thumb_grid.py
!python thumb_grid.py
% ..............................................................................
% ..............................................................................