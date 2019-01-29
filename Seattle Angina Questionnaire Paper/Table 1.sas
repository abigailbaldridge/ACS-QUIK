*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\Table 1.sas*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : March 22, 2018																*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the analysis data file
*********************************************************************************************;
Libname Raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper";
Data Analysis; Set Raw.SAQ; Run;

*****************************************************************************
Table 1: Baseline Demographics
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;

%Continousparametric(Data=Analysis,Var=Age,dec=1);
%Categorical(Data=Analysis,Var=SmokingOrTobacco,dec=1);
%Categorical(Data=Analysis,Var=Diabetes,dec=1);
%Categorical(Data=Analysis,Var=TransferPatient,dec=1);
%Categorical(Data=Analysis,Var=NoInsurance,dec=1);
%Categorical(Data=Analysis,Var=CardiacStatusStemi,dec=1);
%Continuousnonparametric(Data=Analysis,Var=OnsettoArrival,dec=0);
%Continousparametric(Data=Analysis,Var=Weight,dec=1);
%Continousparametric(Data=Analysis,Var=SBP,dec=1);
%Continousparametric(Data=Analysis,Var=HeartRate,dec=1);
%Continuousnonparametric(Data=Analysis,Var=Troponin,dec=2);
%Continousparametric(Data=Analysis,Var=LabLDL,dec=1);
%Continuousnonparametric(Data=Analysis,Var=LabTrig,dec=0);
%Continuousnonparametric(Data=Analysis,Var=LabCreatinine,dec=1);
%Continuousnonparametric(Data=Analysis,Var=LabFG,dec=0);
%Continousparametric(Data=Analysis,Var=LabHb,dec=1);
%Categorical(Data=Analysis,Var=Intervention,dec=0); 

%ByParametricBinary(Data=Analysis,Var=Age,By=Male,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,By=Male,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Diabetes,By=Male,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=TransferPatient,By=Male,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=NoInsurance,By=Male,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=OnsettoArrival,By=Male,dec=0,pval=2);
%ByParametricBinary(Data=Analysis,Var=Weight,By=Male,dec=1,pval=2);
%ByParametricBinary(Data=Analysis,Var=SBP,By=Male,dec=1,pval=2);
%ByParametricBinary(Data=Analysis,Var=HeartRate,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=Troponin,By=Male,dec=2,pval=2);
%ByParametricBinary(Data=Analysis,Var=LabLDL,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabTrig,By=Male,dec=0,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabCreatinine,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabFG,By=Male,dec=0,pval=2);
%ByParametricBinary(Data=Analysis,Var=LabHb,By=Male,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Intervention,By=Male,dec=0,pval=2);

Data Descriptives (drop=N); Set Descriptives;
	Order = _N_;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Data Table1; 
	Merge
	Descriptives
	ByDescriptives;
	By Order;
Run;

Data Table1; Set Table1;
	If Variable = "0" then delete;
	If Variable = "1" then Variable = "";
Run;

Data Table1; Set Table1;
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

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\Table1.csv";
Proc Print Data = Table1 Noobs; 
	Var Var N Descriptive _1 _0 P;
Run;
ods csv close;

proc datasets lib=work nolist;
delete ByDescriptives Descriptives Table1 cat chisqtest continuous Continuoustotal ttest totals wtest; 
quit;
run;

Proc Freq data = analysis;
	Table Male;
Run;
