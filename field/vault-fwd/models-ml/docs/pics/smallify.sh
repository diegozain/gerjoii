#!/bin/bash
# ------------------------------------------------------------------------------
# make images small so they fit in markdown doc
# ------------------------------------------------------------------------------
sips --resampleWidth 468 --resampleHeight 888 file_system.png 
sips --resampleWidth 1030 --resampleHeight 350 train-data.png
sips --resampleWidth 1030 --resampleHeight 411 train-models.png
sips --resampleWidth 300 --resampleHeight 300 wdc-bhrs.png
# ------------------------------------------------------------------------------
