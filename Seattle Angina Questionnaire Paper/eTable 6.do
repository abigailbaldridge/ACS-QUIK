*************************************************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\Stata Code\Seattle Angina Paper\eTable 6.do					*
* DESCRIPTION : Descriptive Tables																						*
* PROGRAMMER  : Dimple Kondal																							*		 	            									
* DATE		  : January 11, 2019																						*															
*************************************************************************************************************************
//Directory
cd "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper"

//Dataset
use SAQ.dta, replace

capture program drop adjustlogit
program adjustlogit
melogit `1' i.male i.step || centerid:, or
end

capture program drop adjustlogitstemi
program adjustlogitstemi
melogit `1' i.male i.step if cardiacstatusstemi==1|| centerid:, or
end

capture program drop adjustquantilestemi
program adjustquantilestemi
xi:qreg2 `1' i.male i.step if cardiacstatusstemi==1,cluster(centerid)  quantile(.50)
end

*****************************************************************************
//eTable 6
*****************************************************************************
*Adjusted
adjustlogit prehospaspirin
adjustlogitstemi lyticsbeforearrival
adjustlogit adminaspirin
adjustlogit adminantiplatelet
adjustlogit adminbetablocker
adjustlogit adminanticoagulant

adjustlogit echo
adjustlogit angiography
adjustlogit pci
adjustlogitstemi primarypciforstemi
adjustquantilestemi doortoballoon 
adjustlogitstemi lyticsforstemi
adjustquantilestemi doortoneedle
adjustlogitstemi reperfusion
adjustlogitstemi rescuepci

adjustlogitstemi dischargeaspirin
adjustlogitstemi dischargeantiplatelet
adjustlogitstemi dischargebetablocker
adjustlogitstemi dischargestatin
adjustlogitstemi dischargemedlvsd
adjustlogitstemi dischargerehab




