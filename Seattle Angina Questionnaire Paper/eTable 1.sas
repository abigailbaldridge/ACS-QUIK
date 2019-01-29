*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\eTable 1.sas*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : March 22, 2018																*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the analysis data file
*********************************************************************************************;

Libname Raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\BioLINCC\Locked Analysis Datasets";
Data Analysis; Set Raw.Analysis; Run;

Libname Raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper";
Data SAQ; Set Raw.SAQ; Run;

Proc Sort data = Analysis; By ID; Run;
Proc Sort data = SAQ; By ID; Run;

Data Analysis;
	Merge
	Analysis
	SAQ (keep = ID in=in1);
	By ID;
	If in1 then SAQ = 1;
	if not in1 then SAQ = 0;
Run;

Proc Freq Data = Analysis; 
	Table SAQ;
Run;

*****************************************************************************
eTable 1: In and All
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;

%Continousparametric(Data=Analysis,Var=Age,dec=1);
%Categorical(Data=Analysis,Var=Male,dec=1);
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
%Categorical(Data=Analysis,Var=Intervention,dec=1);

%ByParametricBinary(Data=Analysis,Var=Age,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Male,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Diabetes,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=TransferPatient,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=NoInsurance,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,By=SAQ,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=OnsettoArrival,By=SAQ,dec=0,pval=2);
%ByParametricBinary(Data=Analysis,Var=Weight,By=SAQ,dec=1,pval=2);
%ByParametricBinary(Data=Analysis,Var=SBP,By=SAQ,dec=1,pval=2);
%ByParametricBinary(Data=Analysis,Var=HeartRate,By=SAQ,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=Troponin,By=SAQ,dec=2,pval=2);
%ByParametricBinary(Data=Analysis,Var=LabLDL,By=SAQ,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabTrig,By=SAQ,dec=0,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabCreatinine,By=SAQ,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabFG,By=SAQ,dec=0,pval=2);
%ByParametricBinary(Data=Analysis,Var=LabHb,By=SAQ,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Intervention,By=SAQ,dec=1,pval=2);

Data Descriptives (drop=N); Set Descriptives;
	Order = _N_;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Data eTable1; 
	Merge
	Descriptives
	ByDescriptives;
	By Order;
Run;

Data eTable1; Set eTable1;
	If Variable = "0" then delete;
	If Variable = "1" then Variable = "";
Run;

Data eTable1; Set eTable1;
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

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\eTable1.csv";
Proc Print Data = eTable1 Noobs; Run;
ods csv close;

proc datasets lib=work nolist;
delete ByDescriptives Descriptives Table2 cat chisqtest continuous Continuoustotal ttest totals wtest; 
quit;
run;

Proc Freq Data = Analysis;
	Table Intervention;
Run;

proc export data=Analysis outfile= "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\eTable1.dta" replace; run;
