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
melogit `1' i.male i.step || centerid:, or
end

capture program drop adjustquantile
program adjustquantile
xi:qreg2 `1' male i.step,cluster(centerid)  quantile(.50)
end

*****************************************************************************
//Table 2
*****************************************************************************

adjustlogit anyangina
adjustquantile anginafrequency
meologit multinomialangina i.male i.step || centerid:, or

adjustquantile physicallimitation
adjustquantile treatmentsatisfaction
adjustquantile qualityoflife
