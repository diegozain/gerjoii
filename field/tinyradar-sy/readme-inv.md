# Tiny radar & DC 2D example
diego domenzain

March 2021 @ Colorado School of Mines

**run forward models and a joint inversion of radar & DC two-dimensional data on a tiny model**

[![](image2mat/nature-synth/images/tiny-color.png)](./)

```
wave cube will be of size (double precision)          1      [Gb]
electric potential will be of size (double precision) 4.3e-4 [Gb]

x [m] = 8.0 
z [m] = 2.0 
t [ns] = 91.475508 

fo [Hz] = 2.5e+08 

dx [m] = 0.017237 
dz [m] = 0.017237 
dt [ns] = 0.036590 

n (no PML) = 465 
m (no PML, no air) = 117 
air = 60 
nt = 2500 
```

If you want to run the inversions on your personal computer, this is the right example for you.

The model parameters have no geological meaning, but are consistent with possible physical subsurface parameters.

The entire example is customizable too.

### Steps

1. Run the file,
   * ```gerjoii/field/tinyradar-sy/base/scripts/begin_check.m```
   * this will generate ```x.mat``` and ```z.mat``` needed for the step below.
1. The model parameters will have the shape of the image shown in,
   * ```gerjoii/field/tinyradar-sy/image2mat/nature-synth/images/tiny.png```
   * Feel free to edit this picture as you wish.
   * To make your life simple, try using the same colors as the original ```tiny.png```.
   * When you are done, make two copies: ```epsi.png``` and ```sigm.png```.
1. Choose your model parameter values in:
   * ```gerjoii/field/tinyradar-sy/image2mat/image2gerjoii.m```
   ```
   % permittivity
   eps_rgb = [23; 37; 130; 132; 255];
   eps_rel = [9; 8.5;   6;   5;   4];
   % conductivity
   sig_rgb = [0; 39; 133; 135; 255];
   sig_ele = [10; 8;   5;   3;   1]*1e-3;
   ```
   * Values for relative permittivity must be between 2 and 9.
   * Values for conductivity must be larger than zero.
   * This will save the model parameters as ```.mat``` files.
   * You can also save initial homogeneous models running this script.
1. Now you should copy-paste the directory ```base/``` and rename it ```t1/``` like so:
   * ```gerjoii/field/tinyradar-sy/t1/```
1. Go into ```t1/scripts/``` of this new directory and run *```wdc_begin_.m```*.
   * **This will generate the synthetic observed data,**
   * **and run the joint inversion.**
1. Memory requirements,
   * 0.7Gb of memory per CPU at most during the *joint inversion*
   * These 0.7Gb are due to the radar **gradient computation**
   * 0.5Gb during the **DC gradient computation**
1. For the model presented here running on
   * a *MacBook Pro 2010* with *2 CPUs* and *Matlab 2014a*,
     * 4 minutes for 10 radar *forward models*
     * 2 minutes for 64 DC *forward models*
     * 1.5Gb of memory at most during the *joint inversion*
   * the *University cluster* with *10 nodes* and *Matlab 2020a*,
     * 13 seconds for 10 radar *forward models*
     * 4 seconds for 64 DC *forward models*

### Visualize the results

1. The synthetic *observed* data is in,
   * ```t1/data-synth/```
1. The output of the inversion is in,
   * ```t1/output/```
1. The interface to visualize all the data is in,
   * ```t1/see/```
1. These scripts visualize the data,
   * ```data_dc.m```
   * ```data_w.m``` and ```data_w.py```
   
---

### True model

[![](see/pics/true.png)](./)[![](see/pics/shot1.png)](./)[![](see/pics/observed-wen.png)](./)