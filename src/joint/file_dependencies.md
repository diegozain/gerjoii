# File dependencies for inversion routines

### Joint inversion
```matlab
wdc_imageOBJe2_5d.m
 w_updateOBJ_s_.m
  w_updateOBJ_s.m or w_objs_s.m
 dc_update2_5d__.m
  dc_update2_5d.m
 w_updateOBJ_e_.m
  w_updateOBJ_e.m or w_objs_e.m
```

### Joint inversion AWI 
```matlab
wdc_imageAWIe2_5d.m
 w_updateAWI_s_.m
  w_updateAWI_s.m
 dc_update2_5d__.m
  dc_update2_5d.m
 w_updateAWI_e_.m
  w_updateAWI_e.m
```

### Wave migration
```matlab  
w_migra.m
 w_migra_.m
```

### Wave migration (Slurm)
```shell 
w_migra.sh
  steady_migra_.sh
    begin_migra_.bash
      w_migration_.m
```