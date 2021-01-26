# How to process raw [_Syscal_](http://www.iris-instruments.com/syscal-prosw.html) data

1. Get the data ready for _gerjoii_
  * If ```.txt``` or ```.csv``` run ```dc_process.py```
  * If ```.bin``` run ```syscal2npy.py```
  These extract:
   * abmn           (m)
   * voltages       (V)
   * input currents (A)
   * std            (tenths of percent)
   * SP             (V)
   * app-resi (Ohm.m)
1. Run ```datavis_dc.m``` and clean data up.
  This one saves the ```field_.mat``` structure as:
  ```../raw/PROJECT/dc-data/PROJECT_dc.mat```
1. Run ```data2inv_dc.m``` and save matlab structures for inversion.
  Reads ```PROJECT_dc.mat``` and builds:
   ```parame_dc.mat``` and ```s_i_r_d_std_.mat```
1. If you want to use radar data for the inversion too:
  * go to ```../w-processing/``` and follow procedure there
  * make sure the end of x-domain for the radar is the same as the one for ER
  
---

### Raw and Filtered data
![](pics/bhrs/bhrs-dc.png)

---

# How to process raw [_AGI_](https://www.agiusa.com/supersting-wifi) data

1. Run ```dc_process_AGI.py``` and extract:
  * abmn              (m)
  * voltages/currents (?)
  * output currents   (A)
  * std               (tenths of percent)
  * SP                (V)
  * app-resi          (Ohm.m or Ohm.ft)
2. Run ```datavis_dc2.m``` and clean data up.
3. Run ```data2inv_dc.m``` and save for matlab structures for inversion.