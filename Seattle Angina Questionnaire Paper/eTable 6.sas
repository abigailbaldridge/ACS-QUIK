*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\eTable 6.SAS	*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : January 11, 2019															*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the locked data file
*********************************************************************************************;
Libname Raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper";
Data Analysis; Set Raw.SAQ; Run;

*********************************************************************************************
Dataset for STEMI patients only
*********************************************************************************************;
Data Stemi; Set Analysis;
	If CardiacStatusStemi = 1;
Run;

*****************************************************************************
eTable 6
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;
  
%Categorical(Data=Analysis,Var=PreHospAspirin,dec=1);
%Categorical(Data=Stemi,Var=LyticsBeforeArrival,dec=1);
%Categorical(Data=Analysis,Var=AdminAspirin,dec=1);
%Categorical(Data=Analysis,Var=AdminAntiplatelet,dec=1);
%Categorical(Data=Analysis,Var=AdminBetaBlocker,dec=1);
%Categorical(Data=Analysis,Var=AdminAnticoagulant,dec=1);

%Categorical(Data=Analysis,Var=Echo,dec=1);
%Categorical(Data=Analysis,Var=Angiography,dec=1);
%Categorical(Data=Analysis,Var=PCI,dec=1);
%Categorical(Data=Stemi,Var=PrimaryPCIForSTEMI,dec=1);
%Continuousnonparametric(Data=Stemi,Var=DoortoBalloon,dec=0);
%Categorical(Data=Stemi,Var=LyticsForSTEMI,dec=1);
%Continuousnonparametric(Data=STEMI,Var=DoortoNeedle,dec=0);
%Categorical(Data=Stemi,Var=Reperfusion,dec=1);
%Categorical(Data=Stemi,Var=RescuePCI,dec=1);

%Categorical(Data=Analysis,Var=DischargeAspirin,dec=1);
%Categorical(Data=Analysis,Var=DischargeAntiplatelet,dec=1);
%Categorical(Data=Analysis,Var=DischargeBetaBlocker,dec=1);
%Categorical(Data=Analysis,Var=DischargeStatin,dec=1);
%Categorical(Data=Analysis,Var=DischargeMedLVSD,dec=1);
%Categorical(Data=Analysis,Var=DischargeRehab,dec=1);

%ByCategories(Data=Analysis,Var=PreHospAspirin,by=Male,dec=1);
%ByCategories(Data=Stemi,Var=LyticsBeforeArrival,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=AdminAspirin,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=AdminAntiplatelet,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=AdminBetaBlocker,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=AdminAnticoagulant,by=Male,dec=1);

%ByCategories(Data=Analysis,Var=Echo,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=Angiography,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=PCI,by=Male,dec=1);
%ByCategories(Data=Stemi,Var=PrimaryPCIForSTEMI,by=Male,dec=1);
%Nonparametricbinary(Data=Stemi,Var=DoortoBalloon,by=Male,dec=0);
%ByCategories(Data=Stemi,Var=LyticsForSTEMI,by=Male,dec=1);
%Nonparametricbinary(Data=STEMI,Var=DoortoNeedle,by=Male,dec=0);
%ByCategories(Data=Stemi,Var=Reperfusion,by=Male,dec=1);
%ByCategories(Data=Stemi,Var=RescuePCI,by=Male,dec=1);

%ByCategories(Data=Analysis,Var=DischargeAspirin,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=DischargeAntiplatelet,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=DischargeBetaBlocker,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=DischargeStatin,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=DischargeMedLVSD,by=Male,dec=1);
%ByCategories(Data=Analysis,Var=DischargeRehab,by=Male,dec=1);


Data Descriptives (drop=N); Set Descriptives;
	Order = _N_;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Data eTable6; 
	Merge
	Descriptives
	ByDescriptives;
	By Order;
Run;

Data eTable6; Set eTable6;
	If Variable = "0" then delete;
	If Variable = "1" then Variable = "";
Run;

Data eTable6; Set eTable6;
	Retain Var N P;
	If Variable ^= "" then do;
		Var = Variable;
		N = NTotal;
		P = Pvalue;
	End;
	If variable = "" then do;
		Variable = Var;
		NTotal = N;
		Pvalue = P;
	End;
	if _0 = "" then delete;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\eTable6.csv";
Proc Print Data = Etable6 noobs;
Run;
ods csv close;

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Ttest WTest Totals; 
quit;
run;
