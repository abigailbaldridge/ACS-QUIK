*********************************************************************************************************
* PROGRAM     : Q:\GRP-Huffman\NU\ACS\Data\Q:\Faculty\Huffman\NU\ACS QUIK\Data\Online Supplement.SAS	*
* DESCRIPTION : 																						*
* PROGRAMMER  : Abigail Baldridge		 	            												*
* DATE		  : June 2, 2017																			*
*********************************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the locked data file
*********************************************************************************************;
libname raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper";

data Analysis; Set raw.Included; run;

filename Table1 "P:\Table1v2.sas";
%include Table1;

*****************************************************************************
eTable 1
*****************************************************************************;
%ByParametricBinary(Data=Analysis,Var=Age,by=Impute,dec=1);
%ByCategories(Data=Analysis,Var=Male,by=Impute,dec=1);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,by=Impute,dec=1);
%ByCategories(Data=Analysis,Var=HistoryRiskDiabetesMellitus,by=Impute,dec=1);
%ByCategories(Data=Analysis,Var=AdmsnTransferFromOutFacility,by=Impute,dec=1);
%ByCategories(Data=Analysis,Var=healthi4,by=Impute,dec=1);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,by=Impute,dec=1);
%Nonparametricbinary(Data=Analysis,Var=OnsettoArrival,by=Impute,dec=0);
%ByParametricBinary(Data=Analysis,Var=HistoryRiskWeight,by=Impute,dec=1);
%ByParametricBinary(Data=Analysis,Var=CardiacStatusSystolicBP,by=Impute,dec=1);
%ByParametricBinary(Data=Analysis,Var=CardiacStatusHeartRate,by=Impute,dec=1);
%Nonparametricbinary(Data=Analysis,Var=LabResultTroponinValue,by=Impute,dec=1);
%ByParametricBinary(Data=Analysis,Var=LabLDL,by=Impute,dec=1);
%Nonparametricbinary(Data=Analysis,Var=LabTrig,by=Impute,dec=0);
%Nonparametricbinary(Data=Analysis,Var=LabCreatinine,by=Impute,dec=1);
%Nonparametricbinary(Data=Analysis,Var=LabFG,by=Impute,dec=0);
%ByParametricBinary(Data=Analysis,Var=LabHb,by=Impute,dec=1);

Data ByDescriptives; Set ByDescriptives;
	If Variable in ("0","2") then delete;
	If Variable = "1" then Variable = "";
Run;

Data ByDescriptives; Set ByDescriptives;
	Retain Var N;
	If Variable ^= "" then do;
		Var = Variable;
		N = NTotal;
	End;
	If variable = "" then do;
		Variable = Var;
		NTotal = N;
	End;
	if _0 = "" then delete;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\eTable1.csv";
Proc Print Data = ByDescriptives noobs; Run;
ods csv close;

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Ttest WTest Totals; 
quit;
run;

Proc Freq Data = Analysis;
	Table Impute;
Run;

*****************************************************************************
eTable 3
*****************************************************************************;
%ByParametric(Data=Analysis,Var=Age,by=Group,dec=1);
%ByCategories(Data=Analysis,Var=Male,by=Group,dec=1);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,by=Group,dec=1);
%ByCategories(Data=Analysis,Var=HistoryRiskDiabetesMellitus,by=Group,dec=1);
%ByCategories(Data=Analysis,Var=AdmsnTransferFromOutFacility,by=Group,dec=1);
%ByCategories(Data=Analysis,Var=healthi4,by=Group,dec=1);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,by=Group,dec=1);
%Nonparametric(Data=Analysis,Var=OnsettoArrival,by=Group,dec=0);
%ByParametric(Data=Analysis,Var=HistoryRiskWeight,by=Group,dec=1);
%ByParametric(Data=Analysis,Var=CardiacStatusSystolicBP,by=Group,dec=1);
%ByParametric(Data=Analysis,Var=CardiacStatusHeartRate,by=Group,dec=1);
%Nonparametric(Data=Analysis,Var=LabResultTroponinValue,by=Group,dec=1);
%ByParametric(Data=Analysis,Var=LabLDL,by=Group,dec=1);
%Nonparametric(Data=Analysis,Var=LabTrig,by=Group,dec=0);
%Nonparametric(Data=Analysis,Var=LabCreatinine,by=Group,dec=1);
%Nonparametric(Data=Analysis,Var=LabFG,by=Group,dec=0);
%ByParametric(Data=Analysis,Var=LabHb,by=Group,dec=1);

Data ByDescriptives; Set ByDescriptives;
	If Variable = "0" then delete;
	If Variable = "1" then Variable = "";
Run;

Data ByDescriptives; Set ByDescriptives;
	Retain Var N;
	If Variable ^= "" then do;
		Var = Variable;
		N = NTotal;
	End;
	If variable = "" then do;
		Variable = Var;
		NTotal = N;
	End;
	if _0 = "" then delete;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\eTable3.csv";
Proc Print Data = ByDescriptives noobs; Run;
ods csv close;

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Anovatest KWTest Totals; 
quit;
run;

Proc Freq Data = Analysis;
	Table Group;
Run;

*****************************************************************************
eTable 4
*****************************************************************************;
%ByParametric(Data=Analysis,Var=Age,by=Step,dec=1);
%ByCategories(Data=Analysis,Var=Male,by=Step,dec=1);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,by=Step,dec=1);
%ByCategories(Data=Analysis,Var=HistoryRiskDiabetesMellitus,by=Step,dec=1);
%ByCategories(Data=Analysis,Var=AdmsnTransferFromOutFacility,by=Step,dec=1);
%ByCategories(Data=Analysis,Var=healthi4,by=Step,dec=1);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,by=Step,dec=1);
%Nonparametric(Data=Analysis,Var=OnsettoArrival,by=Step,dec=0);
%ByParametric(Data=Analysis,Var=HistoryRiskWeight,by=Step,dec=1);
%ByParametric(Data=Analysis,Var=CardiacStatusSystolicBP,by=Step,dec=1);
%ByParametric(Data=Analysis,Var=CardiacStatusHeartRate,by=Step,dec=1);
%Nonparametric(Data=Analysis,Var=LabResultTroponinValue,by=Step,dec=1);
%ByParametric(Data=Analysis,Var=LabLDL,by=Step,dec=1);
%Nonparametric(Data=Analysis,Var=LabTrig,by=Step,dec=0);
%Nonparametric(Data=Analysis,Var=LabCreatinine,by=Step,dec=1);
%Nonparametric(Data=Analysis,Var=LabFG,by=Step,dec=0);
%ByParametric(Data=Analysis,Var=LabHb,by=Step,dec=1);

Data ByDescriptives; Set ByDescriptives;
	If Variable = "0" then delete;
	If Variable = "1" then Variable = "";
Run;

Data ByDescriptives; Set ByDescriptives;
	Retain Var N;
	If Variable ^= "" then do;
		Var = Variable;
		N = NTotal;
	End;
	If variable = "" then do;
		Variable = Var;
		NTotal = N;
	End;
	if _0 = "" then delete;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\eTable4.csv";
Proc Print Data = ByDescriptives noobs; Run;
ods csv close;

Proc Freq Data = Analysis;
	Table Step;
Run;

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Anovatest KWTest Totals; 
quit;
run;

*****************************************************************************
eTable 7
*****************************************************************************;
Proc Sort Data = Analysis; By Intervention; Run;

Proc Freq Data = Analysis;	
	Table MACE_n inhosp_heartf inhosp_cardio inhosp_cardiac;
	By Intervention;
	ods output onewayfreqs = Cat;
Run;

Data Cat (Keep = Intervention Table Frequency Per); Set Cat;
	If Intervention = 0 then Per = 100* (Frequency / 10066);
	If Intervention = 1 then Per = 100 * (Frequency / 11308);
	Where MACE_n = 1 or inhosp_heartf = 1 or inhosp_cardio = 1 or inhosp_cardiac = 1;
Run;

Proc Print Data = Cat noobs;
	Var Frequency Per;
Run; 

*****************************************************************************
eFigure 1b
*****************************************************************************;
Data Analysis; Set Analysis;
	If MACE = . then MACE = 0;
Run;

Proc Freq Data = Analysis;	
	Table CentreID;
	Ods output onewayfreqs = TotalN;
Run;

Proc Freq Data = Analysis;	
	Table MACE * CentreID;
	Where Intervention = 0;
	Ods output crosstabfreqs = ControlMace;
Run;

Data ControlMace (Keep = CentreID ControlPercent); Set ControlMace;
	If MACE in (.,0) then delete;
	If CentreID = . then delete;
	ControlPercent = ColPercent;
Run;

Proc Freq Data = Analysis;	
	Table MACE * CentreID;
	Where Intervention = 1;
	Ods output crosstabfreqs = IntMace;
Run;

Data IntMace (Keep = CentreID IntPercent); Set IntMace;
	If MACE in (.,0) then delete;
	If CentreID = . then delete;
	IntPercent = ColPercent;
Run;

Proc Sort Data = Analysis; By CentreID; Run;

Data First (Keep = CentreID Cohort); Set Analysis;
	By CentreId;
	If First.Centreid;
Run;

Data Percents;
	Merge ControlMACE IntMACE First TotalN (Keep = Frequency CentreID);
	By CentreID;
Run;

Data Percents; Set Percents;
	If IntPercent = . then MACEChange = 0;
	Else MACEChange = ControlPercent - IntPercent;
Run;

Proc Sort Data = Percents; By descending MACEChange; Run;

Data Percents; Set Percents;
	Order = _N_;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\eFigure1.csv";
proc print data = percents noobs; run;
ods csv close;
