# CRP Tools
Various tools for CRP projects, that others in CRP may find useful. Mix of R and Matlab. 


## PAMpal_BANTER folder:
Utilities (for R) to deal with issues across different versions of Pamguard/PAMpal/PAMr/BANTER

If a BANTER model was created in PAMr but features were extracted in PAMpal, you might get an error about the variables in the model and new detector data not matching. 

checkVariables.R lets you 
- check the length of measured features in the model vs the detector data (detector data should be 2 longer because it adds two cols)
- checks for Click Detector 3, Whistle and Moan Detector, and Cepstrum Detector (for now...could be expanded) 
- checks that fature names in model and detector data match, for the Cepstrum Detector (PAMr avgSlope becake PAMpal iciSlope)

```
checkResult = checkVariables(bant.mdl, BANTER_Det)
# vDet should be 2 longer than vMdl because it has event.id and call.id added. 

# if cols need to be added...run below. 
BANTER_Det$detectors$Click_Detector_3$PeakHz_10dB = BANTER_Det$detectors$Click_Detector_3$peak
BANTER_Det$detectors$Click_Detector_3$PeakHz_3dB = BANTER_Det$detectors$Click_Detector_3$peak

# if variable names need fixing...run below
names(BANTER_Det$detectors$Cepstrum_Detector)[names(BANTER_Det$detectors$Cepstrum_Detector) == 'iciSlope'] = 'avgSlope'
# check again
checkResult = checkVariables(bant.mdl, BANTER_Det)
```

## CruiseSupport folder:
MATLAB function to create .gpx files from DASBR locations for reading into the R/V Sette's nav system on the bridge

Example:
```
path_in = 'C:\DasbrDrifts\';
fileName = 'IMEI_P_Variables.csv';
dasbrDriftCSVToGPX(path_in, fileName);
```
