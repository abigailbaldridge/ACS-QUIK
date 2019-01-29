*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\eTable 5.sas*
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
eTable 5: Univariable Association with SAQ
*****************************************************************************;
%Macro ContinuousModel(Var =);
Proc GLM Data = Analysis; 
	Model &Outcome = &Var;
	ods output ParameterEstimates = Parms;
Run;

Data Parms; Set Parms;
	Length Var $40.;
	Where Parameter ^= "Intercept";
	Var = "&Var";
Run;

Proc Append Base = ModelOutput Data = Parms Force; Run;
%Mend ContinuousModel;

%Macro CategoricalModel(Var =,Ref=);
Proc GLM Data = Analysis; 
	Class &Var(ref=&Ref);
	Model &Outcome = &Var / solution;
	ods output ParameterEstimates = Parms;
Run;

Data Parms; Set Parms;
	Length Var $40.;
	Where Parameter ^= "Intercept";
	Var = "&Var";
	If Probt ^= .;
Run;

Proc Append Base = ModelOutput Data = Parms Force; Run;
%Mend CategoricalModel;

%Macro Wrapper (Outcome=);
%ContinuousModel(Var=Age);
%CategoricalModel(Var=Male,Ref='0');
%CategoricalModel(Var=SmokingOrTobacco,ref='0');
%CategoricalModel(Var=Diabetes,ref='0');
%CategoricalModel(Var=TransferPatient,ref='0');
%CategoricalModel(Var=NoInsurance,ref='0');
%CategoricalModel(Var=CardiacStatusStemi,ref='0');
%ContinuousModel(Var=OnsettoArrivalHours);
%ContinuousModel(Var=Weight);
%ContinuousModel(Var=SBP);
%ContinuousModel(Var=HeartRate);
%ContinuousModel(Var=Troponin);
%ContinuousModel(Var=LabLDL);
%ContinuousModel(Var=LabTrig);
%ContinuousModel(Var=LabCreatinine);
%ContinuousModel(Var=LabFG);
%ContinuousModel(Var=LabHb);
%CategoricalModel(Var=Intervention);
%Mend Wrapper; 

%Wrapper(Outcome=PhysicalLimitation);
%Wrapper(Outcome=AnginaFrequency);
%Wrapper(Outcome=TreatmentSatisfaction);
%Wrapper(Outcome=QualityofLife);

Data ModelOutput; Set ModelOutput;
	If round(estimate,.01) ^= 0 then Beta = trim(left(put(Estimate,6.2)));
	if round(Estimate,.01) = 0 then Beta = trim(left(put(Estimate,7.3)));
	if round(Estimate,.001) = 0 then Beta = trim(left(put(Estimate,7.4)));
	If Probt < 0.01 then PVal = "<0.01";
	Else Pval = trim(left(put(Probt,6.2)));
	BetaP = trim(left(Beta))||" ("||trim(left(PVal))||")";
Run;

Proc Sort Data =Modeloutput; By Var; Run; 

Proc Transpose Data = ModelOutput out = Wide;
	By Var;
	ID Dependent;
	Var BetaP;
Run;

ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Seattle Angina Paper\eTable5.csv";
Proc Print Data = Wide Noobs; Run;
ods csv close;

proc datasets lib=work nolist;
delete ByDescriptives Descriptives Table2 cat chisqtest continuous Continuoustotal ttest totals wtest; 
quit;
run;
