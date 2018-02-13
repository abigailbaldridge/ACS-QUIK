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
margins intervention
margins r.intervention
end

capture program drop modelStemi
program modelStemi
melogit `1' i.intervention i.step if cardiacstatusstemi==1|| centreid:, or
margins intervention
margins r.intervention
end

*****************************************************************************
//Table 2
*****************************************************************************
*Adjusted
model prehospaspirin
modelStemi lyticsbeforearrival
model adminaspirin
model adminantiplatelet
model adminbetablocker
model adminanticoagulant

model proceduresechocardiography
*model procedurescoroangiography
model procedurespci
modelStemi reperfusionprimarypcin
xi:qreg2 doortoballoon intervention i.step if cardiacstatusstemi==1,cluster(centreid) quantile(.50) 
margins,by(intervention)
margins,by(r.intervention)
modelStemi reperfusionthrombolyticsn
xi:qreg2 doortoneedle intervention i.step if cardiacstatusstemi==1,cluster(centreid) quantile(.50) 
margins,by(intervention)
margins,by(r.intervention)
modelStemi reperfusion
modelStemi rescuepci

model dischargeaspirin
model dischargeantiplatelet
model dischargebetablocker
model dischargestatin
model dischargemedlvsd
*model dischargerehab




