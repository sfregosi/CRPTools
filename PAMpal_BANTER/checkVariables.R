checkVariables = function(bant.mdl, BANTER_Det){
  
  # -------------------------------------------------------------------------
  # BANTER model and test data MUST have same number of variables (measurements
  # extracted by PAMpal)
  
  # *** NOTE ABOUT PAMr vs PAMpal compatibility ***
  
  # IF model was created in PAMr, but the the features were extracted with PAMpal,
  # there will be two extra variables in the Click Detector 3 model
  # that throws an error when you try to run predict() 
  # Error in predict.randomForest(object@detectors[[d]]@model, new.data$detectors[[d]],  : 
  # variables in the training data missing in newdata
  
  # the third variable in the Cepstrum Detector has the wrong name - in PAMr it 
  # was called 'avgSlope', in PAMpal its called 'iciSlope' so need to rename
  # throws same error as above. 
  
  
  # need to check for this and fix if needed
  
  
  # S. Fregosi updated 24 March 2021 (selene.fregosi@noaa.gov)
  # -------------------------------------------------------------------------
  
  # check Click_Detector_3
  # in Click_Detector_3 Missing variables are PeakHz_10dB and PeakHz_3dB
  # were removed in PAMpal because they are just duplicates of peak frequency
  
  vMdl = names(bant.mdl@detectors$Click_Detector_3@model$forest$xlevels)
  vDet = names(BANTER_Det$detectors$Click_Detector_3)
  # vDet should be 2 longer than vMdl because it has event.id and call.id added. 
  
  if (length(vMdl)+2 == length(vDet)){
    checkResult = "variables match"
  } else if (length(vMdl) == length(vDet)){
    # need to manually add these cols as workaround
    checkResult = "NEED TO ADD COLS"
  }
  
  # click_Detector_3 compatibility check results
  cat(paste("Done with C3 compatibility check...", checkResult, '\n', 'vMdl length: ', 
            length(vMdl),', vDet length: ', length(vDet), '\n', sep = ""))
  
  
  
  # check Whistle_and_Moan_Detector
  vMdl = names(bant.mdl@detectors$Whistle_and_Moan_Detector@model$forest$xlevels)
  vDet = names(BANTER_Det$detectors$Whistle_and_Moan_Detector)
  # vDet should be 2 longer than vMdl because it has event.id and call.id added. 
  
  if (length(vMdl)+2 == length(vDet)){
    checkResult = "variables match"
  } else if (length(vMdl) == length(vDet)){
    # need to manually add these cols as workaround
    checkResult = "NEED TO ADD COLS"
  }
  
  # check Whistle_and_Moan_Detector compatibility check results
  cat(paste("Done with WM compatibility check ...", checkResult, '\n', 'vMdl length: ', 
            length(vMdl),', vDet length: ', length(vDet), '\n', sep = "")) 
  
  
  
  # check Cepstrum_Detector
  vMdl = names(bant.mdl@detectors$Cepstrum_Detector@model$forest$xlevels)
  vDet = names(BANTER_Det$detectors$Cepstrum_Detector)
  # vDet should be 2 longer than vMdl because it has event.id and call.id added. 
  
  if (length(vMdl)+2 == length(vDet) && all(vDet[1:(length(vDet)-2)] == vMdl)){
    checkResult = "correct length and variable names"
  } else if (length(vMdl)+2 == length(vDet) && !all(vDet[1:(length(vDet)-2)] == vMdl)){
    checkResult = "correct length; NEED TO FIX NAMES"
  } else if (length(vMdl) == length(vDet)){
    # need to manually add these cols as workaround
    checkResult = "NEED TO ADD COLS"
  }
  
  # check Cepstrum_Detector compatibility check results
  cat(paste("Done with Cepstrum compatibility check ...", checkResult, '\n', 'vMdl length: ', 
            length(vMdl),', vDet length: ', length(vDet), '\n', sep = "")) 
  
  return(checkResult)
  
}