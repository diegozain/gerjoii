#!/bin/bash

# set permission
# chmod 777 dc-process-data.sh

# set file to be processed
export er_data=../../raw/groningen2/dc-data/groningen2-pygimli.txt

printf "\n\nprocessing raw er-data file ** $er_data **\n\n"

# get lines of txt
nl=$(wc -l < $er_data)

# get number of receivers
nr=$(awk NR==1 $er_data)
printf "number of receivers = $nr\n";

# get receiver (x,y,z) locations in binned notation
nr_=$(($nr+2))
sed -n "3,${nr_}p" $er_data > er-xyz-binned-r.txt

# get number of shots
ns_=$(($nr_+1))
ns=$(awk NR=="${ns_}" $er_data)
printf "number of shots = $ns\n";

# print what each column is in the data file
ncols_=$(($ns_+1))
columns=$(awk NR=="${ncols_}" $er_data | awk '{$1=""}1')
printf "\ncolumns in the data are:\n"
printf "$columns\n";

printf "\n"
# see https://gitlab.com/resistivity-net/bert/blob/master/python/pybert/importer/importData.py
printf " a b m n:   source sink rec+ rec- \n"
printf " bat_rx:    rec Battery Voltage [V] \n"
printf " bat_tx:    src Battery Voltage [V] \n"
printf " err:       Standard deviation \n"
printf " gm:        Chargeability [mV/V] \n"
printf " i:         Injected current [A] \n"
printf " ip:        Induced polarisation [mV/V] \n"
printf " iperr:     ? \n"
printf " k:         geometric factor \n"
printf " r:         ? \n"
printf " rhoa:      Apparent resistivity [Ohm.m]\n"
printf " rs_check:  ground resistance value of the reception dipole \n"
printf " sp: Self   potential [V] \n"
printf " stacks:    stacks \n"
printf " temp:      Battery temperature [C] \n"
printf " u:         Measured voltage [V] \n"
printf " vab:       Injected Voltage [V] \n"
printf " valid:     valid or not \n"

# get ALL of the data!!!!
nbegin_=$(($ns_+2))
nend_=$(($nl-1))
sed -n "${nbegin_},${nend_}p" $er_data > er-ALL-data.txt

# get only sources and receivers
export er_data_nice=er-ALL-data.txt
awk '{print $1 " " $2 " " $3 " " $4}' "$er_data_nice" > er-src-rec.txt

# get only apparent resistivity
awk '{print $14}' "$er_data_nice" > er-rhoa.txt

# get current, electric potential and standard deviation
awk '{print $9 " " $19 " " $7}' "$er_data_nice" > er-i-u-std.txt

printf "\n output files give:\n";
printf "      all data:               er-ALL-data.txt\n"
printf "      source and receivers:   er-src-rec.txt\n"
printf "      apparent resistivity:   er-rhoa.txt\n"
printf "      current, voltage, std:  er-i-u-std.txt\n"
printf "      binned receivers:       er-xyz-binned-r.txt\n"

printf "\n";
