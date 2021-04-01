# Building synthetic models

1. __image2gerjoii.m__

  True epsi and sigm:

  ```epsi.mat, sigm_w.mat, sigm_dc.mat```

2. __image2gerjoii.m__

  Do true epsi but without top layer:

  ```epsi_notop.mat```

3. __smooth_true.m__ (optional)

  Smooth true-epsi: 
  
  ```epsi_smooth.mat```

4. __smooth_true.m__

  Smooth `epsi_notop.mat`:
  
  ```epsi_notop_smooth.mat```

5. __smooth_boundary.m__

  Put top layer on ```epsi_notop_smooth.mat``` and smooth again, but less.
  
  Result is 4% less than true values.
  
  ```epsi_top_smooth.mat```

6. __smooth_boundary_interp.m__

  Interpolate `epsi_top_smooth.mat` to make smooth sigm-w and sigm-dc:
  
  ```sigm_w_top_smooth.mat, sigm_dc_top_smooth.mat```

***
# True models

ls nature-synth/mat-synth/

`epsi.mat`       : with top layer   
`sigm_w_.mat`    : with top layer   
`sigm_dc_.mat`   : with top layer   
`epsi_notop.mat` : without top layer

***
# Initial models

ls nature-synth/initial-guess/

`epsi_notop_smooth.mat`   : without top layer but smoothed
`epsi_top_smooth.mat`     : top layer added & smoothed (less smoothed)

`sigm_dc_top_smooth.mat`  : interpolated from `epsi_top_smooth.mat`

`sigm_w_top_smooth.mat`   : interpolated from `epsi_top_smooth.mat`

***
# Uploading to server

cd ../../

sh push_param.sh

***
