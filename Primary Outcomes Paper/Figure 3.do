*************************************************************************************************************************
* PROGRAM     : C:\data_dimple\projects_CCDC\ACS QUIK\ACS_Questinaires_codebook_15052014\ACS_Statadofiles\March2017\	**
* DESCRIPTION : Descriptive Tables																						*
* PROGRAMMER  : Dimple Kondal																							*		 	            									
* DATE		  : May 17, 2017																							*															
*************************************************************************************************************************
//Directory
cd "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper"

//Dataset
use Analysis.dta

*****************************************************************************
//Figure 3
*****************************************************************************

***********************************************
//Sub group analysis for PRIMARY OUTCOME-MACE
************************************************
table mace agegroupc intervention
table agegroupc intervention
table mace demogender intervention
table mace cardiacstatusstemi intervention
table mace hsize intervention
table mace hospitaltype intervention

table cardiacstatusstemi mace
table hospitaltype intervention
table hospitaltype hsize intervention
table hospitaltype hsize intervention if mace == 1

**Age
melogit mace i.intervention i.step if  agegroupc==1|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  agegroupc==2|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  agegroupc==3|| centreid: , or
margins r.intervention

**Gender
melogit mace i.intervention i.step if  demogender==1|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  demogender==2|| centreid: , or
margins r.intervention

**STEMI VS NO STEMI
melogit mace i.intervention i.step if  cardiacstatusstemi==1|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  cardiacstatusstemi==0|| centreid: , or
margins r.intervention

**Hospital size
melogit mace i.intervention i.step if  hsize=="Extra Large"|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  hsize=="Large"|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  hsize=="Medium"|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  hsize=="Small"|| centreid: , or
margins r.intervention

**Hospital type
melogit mace i.intervention i.step if  hospitaltype=="Government"|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  hospitaltype=="Non-profit/Charity"|| centreid: , or
margins r.intervention
melogit mace i.intervention i.step if  hospitaltype=="Private"|| centreid: , or
margins r.intervention
