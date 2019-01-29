*************************************************************************************************************************
* PROGRAM     : Table 1.do																								*
* DESCRIPTION : Descriptive Tables																						*
* PROGRAMMER  : Dimple Kondal																							*		 	            									
* DATE		  : May 17, 2017																							*															
*************************************************************************************************************************
//Directory
cd "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper"

//Dataset
use Included.dta

capture program drop rawlogit
program rawlogit
melogit `1' i.intervention, or
margins intervention
margins r.intervention
end

capture program drop rawreg
program rawreg
reg `1' i.intervention
margins intervention
margins r.intervention
end

capture program drop rawquantile
program rawquantile
xi:qreg2 `1' i.intervention, quantile(.50) 
margins,by(intervention)
margins,by(r.intervention)
end

*****************************************************************************
//Table 1
*****************************************************************************
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


