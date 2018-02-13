*********************************************************************************************
* PROGRAM     : Q:\GRP-Huffman\NU\ACS\Data\Q:\Faculty\Huffman\NU\ACS QUIK\Data\Table1.SAS	*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : June 2, 2017																*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the analysis data file
*********************************************************************************************;
Libname Raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper";
Data Analysis; Set Raw.Included; Run;

%let dsid=%sysfunc(open(Analysis));
%let num=%sysfunc(attrn(&dsid,nlobs));
%let rc=%sysfunc(close(&dsid));

**>>>ST:Value(Label="N Total", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &num;
**<<<;

*****************************************************************************
RESULTS SECTION
*****************************************************************************;
Proc Freq Data = Analysis;
	Table Intervention;
	ods output onewayfreqs = Intervention;
Run;

Data Intervention; Set Intervention;
	If Intervention = 0 then call symput('Control',put(Frequency,8.0));
	If Intervention = 1 then Call symput('Intervention',put(Frequency,8.0));
Run;

**>>>ST:Value(Label="N Control", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &Control;
**<<<;
**>>>ST:Value(Label="N Intervention", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &Intervention; 
**<<<;

Proc Freq Data = Analysis;
	Table Intervention * Step /norow nocol nopercent;
Run;

Proc Means Data = Analysis;
	Var Age;
	ods output summary = Age;
Run;

Data Age; Set Age;
	call symput('Age',put(Age_Mean,8.2));
	call symput('AgeSD',put(Age_StdDev,8.2));
Run;

**>>>ST:Value(Label="Age", Frequency="Always", Type="Numeric", Decimals=1, Thousands=True);
%Put &Age;
**<<<;
**>>>ST:Value(Label="AgeSD", Frequency="Always", Type="Numeric", Decimals=1, Thousands=True);
%Put &AgeSD;
**<<<;

Proc Freq Data = Analysis;
	Table Male CardiacStatusStemi SmokingOrTobacco HistoryRiskDiabetesMellitus;
	ods output onewayfreqs = GenderStemi;
Run;

Data GenderStemi; Set GenderStemi;
	If Male = 1 then call symput('NMale',put(Frequency,8.0));
	If Male = 1 then call symput('PerMale',put(Percent,8.2));
	If CardiacStatusStemi = 1 then Call symput('NSTEMI',put(Frequency,8.0));
	If CardiacStatusStemi = 1 then Call symput('PerSTEMI',put(Percent,8.2));
Run;

**>>>ST:Value(Label="NMale", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &NMale;
**<<<;
**>>>ST:Value(Label="PerMale", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &PerMale;
**<<<;
**>>>ST:Value(Label="NSTEMI", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &NSTEMI;
**<<<;
**>>>ST:Value(Label="PerSTEMI", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &PerSTEMI;
**<<<;

Proc Freq Data = Analysis;
	Table Impute;
	ods output onewayfreqs = Completed;
Run;

Data Completed; Set Completed;
	If Impute = 0 then call symput('NComplete',put(Frequency,8.0));
	If Impute = 0 then call symput('CompletePer',put(Percent,8.2));
Run;

**>>>ST:Value(Label="NComplete", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &NComplete;
**<<<;
**>>>ST:Value(Label="CompletePer", Frequency="Always", Type="Numeric", Decimals=0, Thousands=True);
%Put &CompletePer;
**<<<;

*****************************************************************************
TABLE 1
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;

%ByParametricBinary(Data=Analysis,Var=Age,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=Male,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=HistoryRiskDiabetesMellitus,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=AdmsnTransferFromOutFacility,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=healthi4,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,by=Intervention,dec=1);
%Nonparametricbinary(Data=Analysis,Var=OnsettoArrival,by=Intervention,dec=0);
%ByParametricBinary(Data=Analysis,Var=HistoryRiskWeight,by=Intervention,dec=1);
%ByParametricBinary(Data=Analysis,Var=CardiacStatusSystolicBP,by=Intervention,dec=1);
%ByParametricBinary(Data=Analysis,Var=CardiacStatusHeartRate,by=Intervention,dec=1);
%Nonparametricbinary(Data=Analysis,Var=LabResultTroponinValue,by=Intervention,dec=1);
%ByParametricBinary(Data=Analysis,Var=LabLDL,by=Intervention,dec=1);
%Nonparametricbinary(Data=Analysis,Var=LabTrig,by=Intervention,dec=0);
%Nonparametricbinary(Data=Analysis,Var=LabCreatinine,by=Intervention,dec=1);
%Nonparametricbinary(Data=Analysis,Var=LabFG,by=Intervention,dec=0);
%ByParametricBinary(Data=Analysis,Var=LabHb,by=Intervention,dec=1);

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

**>>>ST:Table(Label="Table 1", Frequency="Always", ColFilterEnabled=True, ColFilterType="Exclude", ColFilterValue="1", RowFilterEnabled=True, RowFilterType="Exclude", RowFilterValue="1", Type="Default");
ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\Table1.csv";
Proc Print Data = ByDescriptives noobs;
	Var Variable _0 _1;
Run;
ods csv close;
**<<<;

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Ttest WTest Totals; 
quit;
run;

Proc means Data = Analysis N;
	Class Intervention;
	Var OnsettoArrival HistoryRiskWeight CardiacStatusSystolicBP CardiacStatusHeartRate LabResultTroponinValue LabLDL LabTrig LabCreatinine LabFG LabHb;
Run;

%ByCategories(Data=Analysis,Var=Hospitaltype,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=hsize,by=Intervention,dec=1);
%ByCategories(Data=Analysis,Var=CathLab,by=Intervention,dec=1);

proc datasets lib=work nolist;
delete Continuous ContinuousTotal Cat ChisqTest ByDescriptives Ttest WTest Totals; 
quit;
run;

Data Analysis; Set Analysis;
	If HospitalType = "Government" then Government = 1;
	Else Government = 0;
	If Hospitaltype = "Non-profit/Charity" then NP = 1;
	Else NP = 0;
	If Hospitaltype = "Private" then Private = 1;
	Else Private = 0;
	If hsize = "Extra Large" then ExtraLarge = 1;
	Else ExtraLarge= 0;
	If hsize = "Large" then large = 1;
	Else Large = 0; 
	If hsize = "Medium" then Medium = 1;
	Else Medium = 0; 
	If hsize = "Small" then Small = 1;
	Else Small = 0; 
	if CathLab = "Installed During Study" then IDS = 1;
	Else IDS = 0;
	If cathlab = "Yes" then Cathyes = 1;
	Else Cathyes = 0;
	If Cathlab = "No" then Cathno = 1;
	Else Cathno = 0;
Run;

proc freq data=Analysis;
   tables Intervention*Government / riskdiff;
   tables Intervention*NP / riskdiff;
   tables Intervention*Private / riskdiff;
	tables Intervention*ExtraLarge / riskdiff;
	tables Intervention*large / riskdiff;
	tables Intervention*Medium / riskdiff;
	tables Intervention*Small / riskdiff;
	tables Intervention*IDS / riskdiff;
	tables Intervention*Cathyes / riskdiff;
	tables Intervention*Cathno / riskdiff;
run;
