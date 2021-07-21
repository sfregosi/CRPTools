# *** NOTE ABOUT PAMr vs PAMpal compatibility ***
# IF model was created in PAMr, but the the features were extracted with PAMpal,
# there will be two extra variables in the model that throws an error when 
# you try to run predict()

checkResult = checkVariables(bant.mdl, BANTER_Det)
# vDet should be 2 longer than vMdl because it has event.id and call.id added. 

# # if cols need to be added...run below. 
# BANTER_Det$detectors$Click_Detector_3$PeakHz_10dB = BANTER_Det$detectors$Click_Detector_3$peak
# BANTER_Det$detectors$Click_Detector_3$PeakHz_3dB = BANTER_Det$detectors$Click_Detector_3$peak
# 
# # if variable names need fixing...run below
# names(BANTER_Det$detectors$Cepstrum_Detector)[names(BANTER_Det$detectors$Cepstrum_Detector) == 'iciSlope'] = 'avgSlope'
# # check again
# checkResult = checkVariables(bant.mdl, BANTER_Det)

# Missing variables in Click_Detector_3 are PeakHz_10dB and PeakHz_3dB
# were removed in PAMpal because they are just duplicates of peak frequency'
# yy = names(bant.mdl@detectors$Click_Detector_3@model$forest$xlevels)
# ynames = names(BANTER_Det$detectors$Click_Detector_3)
# ynames should be 2 longer than yy because it has event.id and call.id added. 

# For Cepstrum Detector - issue with variable names
# vMdl = names(bant.mdl@detectors$Cepstrum_Detector@model$forest$xlevels)
# vDet = names(BANTER_Det$detectors$Cepstrum_Detector)