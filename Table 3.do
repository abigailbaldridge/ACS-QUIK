*************************************************************************************************************************
* PROGRAM     : C:\data_dimple\projects_CCDC\ACS QUIK\ACS_Questinaires_codebook_15052014\ACS_Statadofiles\March2017\	**
* DESCRIPTION : Descriptive Tables																						*
* PROGRAMMER  : Dimple Kondal																							*		 	            									
* DATE		  : May 17, 2017																							*															
*************************************************************************************************************************
//Directory
cd "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper"

//Dataset
use Included.dta

capture program drop model
program model
melogit `1' i.intervention i.step || centreid:, or 
estat icc  
margins intervention
margins r.intervention
end

capture program drop unadjustedmodel
program unadjustedmodel
melogit `1' i.intervention|| centreid:, or
margins intervention
margins r.intervention
end

*****************************************************************************
//Table 3
*****************************************************************************
unadjustedmodel mace
model mace

unadjustedmodel death
model death

unadjustedmodel cvddeath
model cvddeath

unadjustedmodel indeath
model indeath

unadjustedmodel reinfarction
model reinfarction

unadjustedmodel stroke
model stroke

unadjustedmodel majorbleeding
model majorbleeding

unadjustedmodel optimalinhospmeds
model optimalinhospmeds

unadjustedmodel optimaldischargemeds
model optimaldischargemeds

unadjustedmodel dischargesmokecounsel
model dischargesmokecounsel

