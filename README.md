# Spook-and-Play
disembodied sync for 4 people mirror game
This document describe the work for the Spook and Play experiment, looking at disembodied social synchronisation using Chronos interface

The work progress through a number of scripts.

CHRONOS_0.m
Read raw data and all parameters needed to configure the experiment.
For each individual record, save the emotion and other characteristics

CHRONOS_2.m
1. Filter each record with butterworth filter
2. Calculates phases of each signal with Hilbert transform
3. Save results in intermediary file DATAXFILTPHASES.mat

CHRONOS_3_g.m
1. For each couple (group, trial) calculates the 
Order Parameter (Kuramoto) of phases calculated in CHRONOS_2

2. Calculates the synchronization thresholds for WEAK, MEDIUM, HIGH synchronization

3. Calculates TIS (Time In Sync) and TTS (Time To Sync) for each level and for 
two conditions :  sound with delay, sound without delay.

4. All data are saved for further comparaison with statistical tools
