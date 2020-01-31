#!/bin/bash
# ------------------------------------------------------------------------------
python boreholes.py
python boreholes_appraisal.py
python viewer_dc.py
python solu_appraisal_dc.py
# ------------------------------------------------------------------------------
python viewer_dc_abc.py
python solu_appraisal_dc_abc.py
# ------------------------------------------------------------------------------
rm pics/figo.png
rm pics/fig.png
# ------------------------------------------------------------------------------