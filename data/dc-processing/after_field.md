# How to process raw [_Syscal_](http://www.iris-instruments.com/syscal-prosw.html) data

1. Run ```dc_process.py``` and extract:
 * abmn           (m)
 * voltages       (V)
 * input currents (A)
 * std            (tenths of percent)
 * SP             (V)
 * app-resi (Ohm.m)
2. Run ```datavis_dc2.m``` and clean data up.
3. Run ```data2inv_dc.m``` and save for matlab structures for inversion.

---

### Raw data
![](pics/bhrs/bhrs-dc-dd.png)
### Filtered data
![](pics/bhrs/bhrs-dc-dd-filt.png)

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