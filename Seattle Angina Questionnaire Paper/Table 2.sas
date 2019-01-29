*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\Table 2.sas*
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
Table 2: SAQ Results
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;

%Categorical(Data=Analysis,Var=AnyAngina,dec=1);
%Continuousnonparametric(Data=Analysis,Var=AnginaFrequency,dec=1);
%Categorical(Data=Analysis,Var=AnginaFreq,dec=1);
%Continuousnonparametric(Data=Analysis,Var=PhysicalLimitation,dec=1);
%Continuousnonparametric(Data=Analysis,Var=TreatmentSatisfaction,dec=1);
%Continuousnonparametric(Data=Analysis,Var=QualityofLife,dec=1);

%Bycategories(Data=Analysis,Var=AnyAngina,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=AnginaFrequency,By=Male,dec=1,pval=2);
%Bycategories(Data=Analysis,Var=AnginaFreq,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=PhysicalLimitation,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=TreatmentSatisfaction,By=Male,dec=1,pval=2);
%NonParametricBinary(Data=Analysis,Var=QualityofLife,By=Male,dec=1,pval=2);

Data Descriptives (drop = N); Set Descriptives;
	Order = _N_;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Data Table2; 
	Merge
	Descriptives
	ByDescriptives;
	By Order;
Run;

Data Table2; Set Table2;
	If Variable = "0" then delete;
	If Variable = "ANYANGINA" then do;
		Call Symput ('NTotal',NTotal);
		Call Symput ('Pvalue',Pvalue);
	End; 
	If Variable = "ANGINAFREQ" then Call Symput ('HeadOrder',Order);
Run; 

Data Table2; Set Table2;
	If Variable = "1" then do;
		Variable = "ANYANGINA";
		Ntotal = "&NTotal";
		PValue = "&PValue";
	End; 
	If (Variable = "ANYANGINA" and Descriptive = "") then delete;
	If Variable = "Daily" then Order = &HeadOrder + 1;
	If Variable = "Weekly" then Order = &HeadOrder + 2;
	If Variable = "Monthly" then Order = &HeadOrder + 3;
	If Variable = "None" then Order = &HeadOrder + 4;
Run;

Proc Sort Data = Table2; By Order; Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\Table2.csv";
Proc Print Data = Table2 Noobs; 
Var Variable NTotal Descriptive _1 _0 PValue;
Run;
ods csv close;


proc datasets lib=work nolist;
delete ByDescriptives Descriptives Table2 cat chisqtest continuous Continuoustotal ttest totals wtest; 
quit;
run;
