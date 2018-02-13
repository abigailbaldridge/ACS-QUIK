*************************************************************************************************************************
* PROGRAM     : C:\data_dimple\projects_CCDC\ACS QUIK\ACS_Questinaires_codebook_15052014\ACS_Statadofiles\March2017\	**
* DESCRIPTION : Descriptive Tables																						*
* PROGRAMMER  : Dimple Kondal																							*		 	            									
* DATE		  : May 17, 2017																							*															
*************************************************************************************************************************
//Directory
cd "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper\"

//Dataset
use Included.dta

*****************************************************************************
//Table 1
*****************************************************************************
capture program drop rawlogit
program rawlogit
melogit `1' i.impute, or
margins impute
margins r.impute
end

capture program drop rawreg
program rawreg
reg `1' i.impute
margins impute
margins r.impute
end

capture program drop rawquantile
program rawquantile
xi:qreg2 `1' i.impute, quantile(.50) 
margins,by(impute)
margins,by(r.impute)
end

*Unadjusted
rawreg age
rawlogit male
rawlogit smokingortobacco
rawlogit historyriskdiabetesmellitus
rawlogit admsntransferfromoutfacility
rawlogit healthi4
rawlogit cardiacstatusstemi
rawquantile onsettoarrival
rawreg historyriskweight
rawreg cardiacstatussystolicbp
rawreg cardiacstatusheartrate
rawquantile labresulttroponinvalue
rawreg labldl
rawquantile labtrig
rawquantile labcreatinine
rawquantile labfg
rawreg labhb


*****************************************************************************
//eTable 2
*****************************************************************************
capture program drop adjustlogit
program adjustlogit
melogit `1' i.intervention i.step || centreid:, or
margins intervention
margins r.intervention
end

capture program drop adjustreg
program adjustreg
xtset,clear
xtset centreid
xtreg `1' i.intervention i.step,re
margins intervention
margins r.intervention
end

capture program drop adjustquantile
program adjustquantile
xi:qreg2 `1' intervention i.step,cluster(centreid)  quantile(.50)
margins,by(intervention)
margins,by(r.intervention)
end

*Adjusted
adjustreg age
adjustlogit male
adjustlogit smokingortobacco
adjustlogit historyriskdiabetesmellitus
adjustlogit admsntransferfromoutfacility
adjustlogit healthi4
adjustlogit cardiacstatusstemi
adjustquantile onsettoarrival
adjustreg historyriskweight
adjustreg cardiacstatussystolicbp
adjustreg cardiacstatusheartrate
adjustquantile labresulttroponinvalue
adjustreg labldl
adjustquantile labtrig intervention
adjustquantile labcreatinine
adjustquantile labfg
adjustreg labhb

*****************************************************************************
//eTable 5
*****************************************************************************
capture program drop adjustedmodel
program adjustedmodel
melogit `1' i.intervention i.step age i.male i.cardiacstatusstemi cardiacstatussystolicbp cardiacstatusheartrate labcreatinine i.inhosp_heartf i.inhosp_cardio i.inhosp_cardiac|| centreid:, or 
end

adjustedmodel mace
adjustedmodel death
adjustedmodel cvddeath
adjustedmodel indeath
adjustedmodel reinfarction
adjustedmodel stroke
adjustedmodel majorbleeding
adjustedmodel optimalinhospmeds
adjustedmodel optimaldischargemeds
adjustedmodel dischargesmokecounsel

capture program drop transfermodel
program transfermodel
melogit `1' i.intervention i.step i.admsntransferfromoutfacility|| centreid:, or 
end

transfermodel mace
transfermodel death
transfermodel cvddeath
transfermodel indeath
transfermodel reinfarction
transfermodel stroke
transfermodel majorbleeding
transfermodel optimalinhospmeds
transfermodel optimaldischargemeds
transfermodel dischargesmokecounsel

capture program drop insurancemodel
program insurancemodel
melogit `1' i.intervention i.step i.healthi4|| centreid:, or 
end

insurancemodel mace
insurancemodel death
insurancemodel cvddeath
insurancemodel indeath
insurancemodel reinfarction
insurancemodel stroke
insurancemodel majorbleeding
insurancemodel optimalinhospmeds
insurancemodel optimaldischargemeds
insurancemodel dischargesmokecounsel

capture program drop preaspirinmodel
program preaspirinmodel
melogit `1' i.intervention i.step i.prehospaspirin|| centreid:, or 
end

preaspirinmodel mace
preaspirinmodel death
preaspirinmodel cvddeath
preaspirinmodel indeath
preaspirinmodel reinfarction
preaspirinmodel stroke
preaspirinmodel majorbleeding
preaspirinmodel optimalinhospmeds
preaspirinmodel optimaldischargemeds
preaspirinmodel dischargesmokecounsel

*****************************************************************************
//eTable 6
*****************************************************************************
capture program drop timemodel
program timemodel
melogit `1' i.intervention i.step i.intervention#i.step|| centreid:, or 
end

timemodel mace
timemodel death
timemodel cvddeath
timemodel indeath
timemodel reinfarction
timemodel stroke
timemodel majorbleeding
timemodel optimalinhospmeds
timemodel optimaldischargemeds
timemodel dischargesmokecounsel

*****************************************************************************
//eTable 7
*****************************************************************************
capture program drop adjustlogit
program adjustlogit
melogit `1' i.intervention i.step || centreid:, or
margins intervention
margins r.intervention
end

capture program drop unadjustlogit
program unadjustlogit
melogit `1' i.intervention || centreid:, or
margins intervention
margins r.intervention
end

unadjustlogit mace_n
adjustlogit mace_n
estat icc

unadjustlogit inhosp_heartf
adjustlogit inhosp_heartf
estat icc

unadjustlogit inhosp_cardio
adjustlogit inhosp_cardio
estat icc

unadjustlogit inhosp_cardiac
adjustlogit inhosp_cardiac
estat icc

  
*****************************************************************************
//eFigure 1
*****************************************************************************
xtmelogit mace i.intervention i.step || centreid:, or
estat icc
predict u0,reffects
predict u0se,reses
egen pickone=tag(centreid)
sort u0
gen u0rank=sum(pickone)
//Produce a caterpillar plot for Hospital level intercept residuals
serrbar u0 u0se u0rank if pickone==1, scale(1.96) mvopts(mlabposition(0.5) mlabgap(automatic)) ytitle("Average Studentized Residual") yline(0) xtitle("Hospital By Rank Order")

