# Reading Segy files into Matlab

## Velocity model for Radar

1. In Matlab type:
  ```data=ReadSegy(filename)```
1. Get metadata from whoever gave you the segy file.
1. Convert to ```m/ns```.
  - Most likely the data is in ```cm/mus``` so seismic processing played nice when getting this model.
  - If so, multiply by ```1e-2/1e-3 = 1e-5```.