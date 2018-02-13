*********************************************************************************************
* PROGRAM     : Q:\GRP-Huffman\NU\ACS\Data\Q:\Faculty\Huffman\NU\ACS QUIK\Data\Table2.SAS	*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : June 2, 2017																*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the locked data file
*********************************************************************************************;
libname raw 'Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper\';

data Analysis; Set Raw.Included; Run;

*********************************************************************************************
Dataset for STEMI patients only
*********************************************************************************************;
Data Stemi; Set Analysis;
	If CardiacStatusStemi = 1;
Run;

*****************************************************************************
TABLE 2
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;
  
%ByCategories(Data=Analysis,Var=PreHospAspirin,by=Intervention,dec=1);
%ByCategories(Data=Stemi,Var=LyticsBeforeArrival,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=AdminAspirin,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=AdminAntiplatelet,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=AdminBetaBlocker,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=AdminAnticoagulant,by=Intervention,dec=1);

Data Cat; Set Cat;
	Where NTotal ^= "";
	Variable = "Placeholder";
	_0 = "";
	_1 = "";
	NTotal = "";
	Pvalue = "";
Run;

Proc Append Base = ByDescriptives Data = Cat; Run;

%ByCategories(Data=Analysis,Var=ProceduresEchocardiography,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=ProceduresCoroAngiography,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=ProceduresPCI,by=Intervention,dec=1);
%ByCategories(Data=Stemi,Var=ReperfusionPrimaryPCIn,by=Intervention,dec=1);
%Nonparametricbinary(Data=Stemi,Var=DoortoBalloon,by=Intervention,dec=0);
%ByCategories(Data=Stemi,Var=ReperfusionThrombolyticsn,by=Intervention,dec=1);
%Nonparametricbinary(Data=STEMI,Var=DoortoNeedle,by=Intervention,dec=0);
%ByCategories(Data=Stemi,Var=Reperfusion,by=Intervention,dec=1);
%ByCategories(Data=Stemi,Var=RescuePCI,by=Intervention,dec=1);

Data Cat; Set Cat;
	Where NTotal ^= "";
	Variable = "Placeholder";
	_0 = "";
	_1 = "";
	NTotal = "";
	Pvalue = "";
Run;

Proc Append Base = ByDescriptives Data = Cat; Run;

%ByCategories(Data=Analysis,Var=DischargeAspirin,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=DischargeAntiplatelet,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=DischargeBetaBlocker,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=DischargeStatin,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=DischargeMedLVSD,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=DischargeRehab,by=Intervention,dec=1);

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
	if (_0 = "" and Variable ^= "Placeholder") then delete;
Run;

Proc Means Data = Analysis N;
	Var PreHospAspirin AdminAspirin AdminAntiplatelet AdminBetaBlocker AdminAnticoagulant ProceduresEchocardiography ProceduresCoroAngiography ProceduresPCI
		DischargeAspirin DischargeAntiplatelet DischargeBetaBlocker DischargeStatin DischargeMedLVSD DischargeRehab;
	Class Intervention;
	ODS output Summary = NAnalysis;
Run;

Proc Transpose Data = NAnalysis Out = NAnalysis;
	ID Intervention;
Run; 

Data NAnalysis; Set NAnalysis;
	If _NAME_ = "NObs" then delete;
	Variable = upcase(scan(_NAME_,1,"_"));
	NControl = _0;
	NInt = _1;
Run;

Proc Means Data = Stemi N;
	Var LyticsBeforeArrival ReperfusionPrimaryPCIn DoortoBalloon ReperfusionThrombolyticsn DoortoNeedle Reperfusion RescuePCI;
	Class Intervention;
	ODS output Summary = NStemi;
Run;

Proc Transpose Data = NStemi Out = NStemi;
	ID Intervention;
Run; 

Data NStemi; Set NStemi;
	If _NAME_ = "NObs" then delete;
	Variable = upcase(scan(_NAME_,1,"_"));
	NControl = _0;
	NInt = _1;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Proc Sort Data = ByDescriptives; By Variable; Run;
Proc Sort Data = NAnalysis; By Variable; Run;
Proc Sort Data = NStemi; By Variable; Run;

Data ByDescriptives;
	Merge
	ByDescriptives
	NAnalysis (keep = Variable NControl NInt)
	NStemi (keep = Variable NControl NInt);
	By Variable;
Run;

Proc Sort Data = ByDescriptives; By Order; Run;

**>>>ST:Table(Label="Table 2", Frequency="Always", ColFilterEnabled=True, ColFilterType="Exclude", ColFilterValue="1", RowFilterEnabled=True, RowFilterType="Exclude", RowFilterValue="1", Type="Default");
ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\Table2.csv";
Proc Print Data = ByDescriptives noobs;
	Var Var _0 NControl _1 NInt;
Run;
ods csv close;
**<<<;

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Ttest WTest Totals; 
quit;
run;
