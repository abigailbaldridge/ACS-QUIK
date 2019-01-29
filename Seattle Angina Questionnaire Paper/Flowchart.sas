*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\FlowChart.sas*
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
Figure
*****************************************************************************;
Proc Sort Data = Analysis; By Step Cohort; Run;

*Calculate Control Phase numbers;
Proc Freq Data = Analysis;
	Table CenterID;
	By Step;
	Where Intervention = 0;
	Ods output onewayfreqs = ControlCenters;
Run;

Data ControlCenters; Set ControlCenters;
	Site = 1;
Run;

*Number of sites in each step;
Proc Freq Data = ControlCenters;
	Table Site * Step / norow nocol nopercent;
Run;

*Number of participants in each step;
Proc Means Data = ControlCenters sum;
	Var Frequency;
	Class Step;
Run;

*Calculate Intervention Phase numbers;
Proc Freq Data = Analysis;
	Table CenterID;
	By Step Cohort;
	Where Intervention = 1;
	Ods output onewayfreqs = InterventionCenters;
Run;

Data InterventionCenters; Set InterventionCenters;
	Site = 1;
Run;

Proc Means Data = InterventionCenters sum;
	Var Site;
	Class Step Cohort;
Run;

Proc Means Data = InterventionCenters sum;
	Var Frequency;
	Class Step Cohort;
Run;

