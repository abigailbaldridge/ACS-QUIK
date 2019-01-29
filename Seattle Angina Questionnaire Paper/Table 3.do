*************************************************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\Stata Code\Seattle Angina Questionnaire						*
* DESCRIPTION : Descriptive Tables																						*
* PROGRAMMER  : Abigail Baldridge																						*		 	            									
* DATE		  : August 21, 2017																							*															
*************************************************************************************************************************
//Directory
cd "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper"

//Dataset
use SAQ.dta, replace

capture program drop PLModel
program PLModel
xtset,clear
xtset centerid
xtreg physicallimitation `1' i.step age i.male i.cardiacstatusstemi sbp heartrate i.incidentheartfailure i.incidentshock i.incidentcardiacarrest,re
end

capture program drop AFModel
program AFModel
xtset,clear
xtset centerid
xtreg anginafrequency `1' i.step age i.male i.cardiacstatusstemi sbp heartrate i.incidentheartfailure i.incidentshock i.incidentcardiacarrest,re
end

capture program drop TSModel
program TSModel
xtset,clear
xtset centerid
xtreg treatmentsatisfaction `1' i.step age i.male i.cardiacstatusstemi sbp heartrate i.incidentheartfailure i.incidentshock i.incidentcardiacarrest,re
end

capture program drop QOLModel
program QOLModel
xtset,clear
xtset centerid
xtreg qualityoflife `1' i.step age i.male i.cardiacstatusstemi sbp heartrate i.incidentheartfailure i.incidentshock i.incidentcardiacarrest,re
end


*****************************************************************************
//Table  3
*****************************************************************************
PLModel
PLModel smokingortobacco
PLModel diabetes
PLModel transferpatient
PLModel noinsurance
PLModel onsettoarrivalhours
PLModel weight
PLModel troponin
PLModel labldl
PLModel labtrig
PLModel labcreatinine
PLModel labfg
PLModel labhb
PLModel intervention

AFModel
AFModel smokingortobacco
AFModel diabetes
AFModel transferpatient
AFModel noinsurance
AFModel onsettoarrivalhours
AFModel weight
AFModel troponin
AFModel labldl
AFModel labtrig
AFModel labcreatinine
AFModel labfg
AFModel labhb
AFModel intervention

TSModel
TSModel smokingortobacco
TSModel diabetes
TSModel transferpatient
TSModel noinsurance
TSModel onsettoarrivalhours
TSModel weight
TSModel troponin
TSModel labldl
TSModel labtrig
TSModel labcreatinine
TSModel labfg
TSModel labhb
TSModel intervention

QOLModel
QOLModel smokingortobacco
QOLModel diabetes
QOLModel transferpatient
QOLModel noinsurance
QOLModel onsettoarrivalhours
QOLModel weight
QOLModel troponin
QOLModel labldl
QOLModel labtrig
QOLModel labcreatinine
QOLModel labfg
QOLModel labhb
QOLModel intervention
