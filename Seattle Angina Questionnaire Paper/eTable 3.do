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

capture program drop adjustlogit
program adjustlogit
melogit `1' i.cardiacstatusstemi i.step || centerid:, or
end

capture program drop adjustreg
program adjustreg
xtset,clear
xtset centerid
xtreg `1' i.cardiacstatusstemi i.step,re
end

capture program drop adjustquantile
program adjustquantile
xi:qreg2 `1' cardiacstatusstemi i.step,cluster(centerid)  quantile(.50)
end

*****************************************************************************
//Table 1
*****************************************************************************
adjustreg age
adjustlogit male
adjustlogit smokingortobacco
adjustlogit diabetes
adjustlogit transferpatient
adjustlogit noinsurance
adjustquantile onsettoarrival
adjustreg weight
adjustreg sbp
adjustreg heartrate
adjustquantile troponin
adjustreg labldl
adjustquantile labtrig
adjustquantile labcreatinine
adjustquantile labfg
adjustreg labhb
*adjustlogit intervention

adjustquantile anginafrequency
adjustlogit anyangina
meologit multinomialangina i.cardiacstatusstemi i.step || centerid:, or
adjustquantile physicallimitation
adjustquantile treatmentsatisfaction
adjustquantile qualityoflife
