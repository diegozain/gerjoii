# Preprocessing of Radar Data for FWI

You are in ```data/w-processing/```.

1. ```ss2gerjoii_w.m```
  - Get data from _Sensors and Software_ binary files
  - Save data as ```.mat``` files in ```data/raw/PROJECT/w-data/data-mat-raw```
  - You need to input survey parameters:
    - source-receiver spacing
    - source-source spacing
    - receiver-receiver spacing
    - central frequency
1. ```datavis_w.m```
  - Visualize the data, line by line
  - Decide all preprocessing parameters
  - Pulls parameters from file ```pp_csg_w.m```
    - If these parameters were already chosen, look for this file in ```data/raw/PROJECT/w-data/```
    - If it is a new project, edit the file ```data/w-processing/pp_csg_w.m```
    - Saves each line as a ```.mat``` file in ```data/raw/PROJECT/w-data/data-mat```
1. ```datablitz_w.m```
  - Like ```datavis_w.m``` but for all lines at the same time
  - Saves each line as a ```.mat``` file in ```data/raw/PROJECT/w-data/data-mat```
1. ```field_w.m```
  - Once you are satisfied with those parameters, ```field_w.m``` will save a binary version of them in ```data/raw/PROJECT/w-data/``` for later
  - You need to re-write the parameters from ```pp_csg_w.m``` into ```field_w.m```
  - If a project already had these parameters saved, the file would be in ```data/raw/PROJECT/w-data/```
1. ```swvlets_w.m``` 
  - Computes and saves source-wavelets using the parameters chosen before
  - Saves to ```data/raw/PROJECT/w-data/field_w.mat```
1. ```data2fwi_w.m```
  - This is the last step before the inversion
  - Saves all data in ```data/raw/PROJECT/w-data/data-mat-fwi/```
1. ```swvlets2param_w.m```
  - In case you just want to update the source-wavelet, instead of running ```data2fwi_w.m``` run ```swvlets2param_w.m```. 
  - This will save _only_ the gaussian time windows and the source wavelets to ```data/raw/PROJECT/w-data/data-mat-fwi/parame_.mat```
1. ```see_domain_w.m``` will plot the survey in case you forget what it looks like.
