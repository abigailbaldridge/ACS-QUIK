*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\eTable 2.sas*
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
eTable 2: SAQ Results
*****************************************************************************;
filename Table1 "P:\Table1v2.sas";
%include Table1;

*Angina Stability;
%Categorical(Data=Analysis,Var=ComparedTo4WeekChestpain,dec=0);
*Angina Frequency;
%Categorical(Data=Analysis,Var=ChestPainCount,dec=0);
%Categorical(Data=Analysis,Var=NitroIntakeCount,dec=0);
*Treatment Satisfication;
%Categorical(Data=Analysis,Var=BothersometoTakePills,dec=0);
%Categorical(Data=Analysis,Var=ChestPainTreatmentSatisfaction,dec=0);
%Categorical(Data=Analysis,Var=DoctorExplnSatisfaction,dec=0);
%Categorical(Data=Analysis,Var=OverallTreatmentSatisfaction,dec=0);
*QoL;
%Categorical(Data=Analysis,Var=InterferenceOfChestPain,dec=0);
%Categorical(Data=Analysis,Var=FeelOnRestLifeDueToChestPain,dec=0);
%Categorical(Data=Analysis,Var=WorryAboutHeartAttackAndDeath,dec=0);

*Angina Stability;
%ByCategories(Data=Analysis,Var=ComparedTo4WeekChestpain,by=Male,dec=0);
*Angina Frequency;
%ByCategories(Data=Analysis,Var=ChestPainCount,by=Male,dec=0);
%ByCategories(Data=Analysis,Var=NitroIntakeCount,by=Male,dec=0);
*Treatment Satisfication;
%ByCategories(Data=Analysis,Var=BothersometoTakePills,by=Male,dec=0);
%ByCategories(Data=Analysis,Var=ChestPainTreatmentSatisfaction,by=Male,dec=0);
%ByCategories(Data=Analysis,Var=DoctorExplnSatisfaction,by=Male,dec=0);
%ByCategories(Data=Analysis,Var=OverallTreatmentSatisfaction,by=Male,dec=0);
*QoL;
%ByCategories(Data=Analysis,Var=InterferenceOfChestPain,by=Male,dec=0);
%ByCategories(Data=Analysis,Var=FeelOnRestLifeDueToChestPain,by=Male,dec=0);
%ByCategories(Data=Analysis,Var=WorryAboutHeartAttackAndDeath,by=Male,dec=0);

Data Descriptives; Set Descriptives;
	Order = _N_;
Run;

Data ByDescriptives; Set ByDescriptives;
	Order = _N_;
Run;

Data eTable2; 
	Merge
	Descriptives
	ByDescriptives;
	By Order;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\eTable2.csv";
Proc Print Data = eTable2 Noobs; Run;
ods csv close;

proc datasets lib=work nolist;
delete ByDescriptives Descriptives Table2 cat chisqtest continuous Continuoustotal ttest totals wtest; 
quit;
run;
