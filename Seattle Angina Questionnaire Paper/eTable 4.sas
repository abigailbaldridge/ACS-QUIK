*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\eTable 4.sas*
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
eTable 3: SAQ Results
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
*SAQ;
%Categorical(Data=Analysis,Var=AnyAngina,dec=1);
%Categorical(Data=Analysis,Var=AnginaFreq,dec=1);
%Continuousnonparametric(Data=Analysis,Var=AnginaFrequency,dec=1);
%Continuousnonparametric(Data=Analysis,Var=PhysicalLimitation,dec=1);
%Continuousnonparametric(Data=Analysis,Var=TreatmentSatisfaction,dec=1);
%Continuousnonparametric(Data=Analysis,Var=QualityofLife,dec=1);

%ByParametricBinary(Data=Analysis,Var=Age,By=Intervention,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Male,By=Intervention,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=SmokingOrTobacco,By=Intervention,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=Diabetes,By=Intervention,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=TransferPatient,By=Intervention,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=NoInsurance,By=Intervention,dec=1,pval=2);
%ByCategories(Data=Analysis,Var=CardiacStatusStemi,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=OnsettoArrival,By=Intervention,dec=0,pval=2);
%ByParametricBinary(Data=Analysis,Var=Weight,By=Intervention,dec=1,pval=2);
%ByParametricBinary(Data=Analysis,Var=SBP,By=Intervention,dec=1,pval=2);
%ByParametricBinary(Data=Analysis,Var=HeartRate,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=Troponin,By=Intervention,dec=2,pval=2);
%ByParametricBinary(Data=Analysis,Var=LabLDL,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabTrig,By=Intervention,dec=0,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabCreatinine,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=LabFG,By=Intervention,dec=0,pval=2);
%ByParametricBinary(Data=Analysis,Var=LabHb,By=Intervention,dec=1,pval=2);
*SAQ;
%Bycategories(Data=Analysis,Var=AnyAngina,By=Intervention,dec=1,pval=2);
%Bycategories(Data=Analysis,Var=AnginaFreq,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=AnginaFrequency,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=PhysicalLimitation,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=TreatmentSatisfaction,By=Intervention,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=QualityofLife,By=Intervention,dec=1,pval=2);

Data Descriptives (drop=N); Set Descriptives;
	Order = _N_;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Data eTable4; 
	Merge
	Descriptives
	ByDescriptives;
	By Order;
Run;

Data eTable4; Set eTable4;
	If Variable = "0" then delete;
	If Variable = "1" then Variable = "";
Run;

Data eTable4; Set eTable4;
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

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\eTable4.csv";
Proc Print Data = eTable4 Noobs; Run;
ods csv close;

proc datasets lib=work nolist;
delete ByDescriptives Descriptives Table2 cat chisqtest continuous Continuoustotal ttest totals wtest; 
quit;
run;

Proc Freq Data = Analysis;
	Table Intervention;
Run;
