# pgUtils
Utilities (for R) to deal with issues across different versions of Pamguard/PAMpal/PAMr/BANTER

If a BANTER model was created in PAMr but features were extracted in PAMpal, you might get an error about the variables in the model and new detector data not matching. 

checkVariables.R lets you 
- check the length of measured features in the model vs the detector data (detector data should be 2 longer because it adds two cols)
- checks for Click Detector 3, Whistle and Moan Detector, and Cepstrum Detector (for now...could be expanded) 
- checks that fature names in model and detector data match, for the Cepstrum Detector (PAMr avgSlope becake PAMpal iciSlope)

