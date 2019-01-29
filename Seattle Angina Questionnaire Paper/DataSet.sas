*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\DataSet.sas*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : March 22, 2018																*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import data
*********************************************************************************************;
Libname Clean "Q:\Faculty\Huffman\NU\ACS QUIK\Data\BioLINCC\Data Sets\SAS";
Libname Analysis "Q:\Faculty\Huffman\NU\ACS QUIK\Data\BioLINCC";

Data Analysis;
	Merge
	Analysis.Analysis
	Clean.SAQ (in = in1);
	By ID;
	If in1;
Run;

Proc Univariate Data = Analysis;
	Var FollowUPTime;
Run;

*****************************************************************************
Physical Limitation
*****************************************************************************;
Proc Freq Data = Analysis;
	Table SelfDressing WalkingIndoors Showering ClimbWithoutStop Gardening BriskWalkingPace Running LiftingHeavyObjects Sports;
Run; 

*Response of 6 = Missing;
Data Analysis; Set Analysis;
	If SelfDressing = 6 then SelfDressing = .;
	if WalkingIndoors = 6 then WalkingIndoors = .;
	if Showering= 6 then Showering= .;
	if ClimbWithoutStop= 6 then ClimbWithoutStop= .;
	if Gardening= 6 then Gardening = .;
	if BriskWalkingPace = 6 then BriskWalkingPace = .;
	if Running= 6 then  Running= .;
	if LiftingHeavyObjects= 6 then LiftingHeavyObjects= .;
	if Sports= 6 then Sports= .;
Run; 

*If more than 4 items are missing in this scale, then exclude these patients;
Data Analysis; Set Analysis;
	nummiss = cmiss(SelfDressing,WalkingIndoors,Showering,ClimbWithoutStop,Gardening,BriskWalkingPace,Running,LiftingHeavyObjects,Sports);
Run;

Proc Freq Data = Analysis;
	Table nummiss;
Run;
*N = 1184 have 4 or fewer items missing;

* Activities are grouped into three levels;
Data Analysis; Set Analysis;
	If Nummiss <= 4 then do;
		if SelfDressing = . and WalkingIndoors = . and Showering = . then LowIntensity = .; 
		else LowIntensity = mean(SelfDressing,WalkingIndoors,Showering);
		if ClimbWithoutStop = . and Gardening = . and BriskWalkingPace = . then MedIntensity = .; 
		else MedIntensity = mean(ClimbWithoutStop,Gardening,BriskWalkingPace);
		if Running = . and LiftingHeavyObjects = . and Sports = . then HighIntensity = .; 
		else HighIntensity = mean(Running,LiftingHeavyObjects,Sports);
	End;
Run;

*If any value is missing, then assign the mean value of the intensity level;
Data Analysis; Set Analysis;
	If Nummiss <= 4 then do;
		*Low Intensity Items;
		If SelfDressing = . then SelfDressing = LowIntensity;
		If WalkingIndoors = . then WalkingIndoors = LowIntensity;
		If Showering = . then Showering = LowIntensity;
		*Med Intensity Items;
		If ClimbWithoutStop = . then ClimbWithoutStop = MedIntensity;
		If Gardening = . then Gardening = MedIntensity;
		If BriskWalkingPace = . then BriskWalkingPace = MedIntensity;
		*High Intensity Items;
		If Running = . then Running = HighIntensity;
		If LiftingHeavyObjects = . then LiftingHeavyObjects = HighIntensity;
		If Sports = . then Sports = HighIntensity;
	End;
Run;

Proc Freq Data = Analysis;
	Table SelfDressing WalkingIndoors Showering ClimbWithoutStop Gardening BriskWalkingPace Running LiftingHeavyObjects Sports /nopercent;
	Where nummiss <= 4;
Run;

*If Lowest or highest level is missing then use the medium score;
Data Analysis; Set Analysis;
	If Nummiss <= 4 then do;
		*Low Intensity Items;
		If SelfDressing = . then SelfDressing = MedIntensity;
		If WalkingIndoors = . then WalkingIndoors = MedIntensity;
		If Showering = . then Showering = MedIntensity;
		*High Intensity Items;
		If Running = . then Running = MedIntensity;
		If LiftingHeavyObjects = . then LiftingHeavyObjects = MedIntensity;
		If Sports = . then Sports = MedIntensity;
	End;
Run;

*If Medium are missing, then average low and high;
Data Analysis; Set Analysis;
	If Nummiss <= 4 then do;
		*Med Intensity Items;
		If ClimbWithoutStop = . then ClimbWithoutStop = mean(LowIntensity,HighIntensity);
		If Gardening = . then Gardening = mean(LowIntensity,HighIntensity);
		If BriskWalkingPace = . then BriskWalkingPace = mean(LowIntensity,HighIntensity);
	End;
Run;

Data Analysis (drop = lowintensity medintensity highintensity); Set Analysis;
	If Nummiss <= 4 then do;
	PhysicalLimitation = 100*(mean(SelfDressing,WalkingIndoors,Showering,ClimbWithoutStop,Gardening,BriskWalkingPace,Running,LiftingHeavyObjects,Sports)-1)/4;
	End;
	Else PhysicalLimitation = .;
Run;

*****************************************************************************
Angina Stability
*****************************************************************************;
Data Analysis; Set Analysis;
	if ComparedTo4WeekChestpain = 6 then ComparedTo4WeekChestpain = 3;
	AnginaStability = 100*(ComparedTo4WeekChestpain - 1)/4;
Run;

*****************************************************************************
Angina Frequency
*****************************************************************************;
Data Analysis; Set Analysis;
	ChestPainCount = Past4weeksAverageChestPainCount;
	NitroIntakeCount = Past4weeksAverageNitrosIntakeCou;
	AnginaFrequency = 100*(mean(Past4weeksAverageChestPainCount,Past4weeksAverageNitrosIntakeCou) - 1)/5;
Run;

Data Analysis; set Analysis;
	If AnginaFrequency < 100 then AnyAngina = 1;
	If AnginaFrequency = 100 then AnyAngina = 0;
	Length AnginaFreq $8.;
	If AnginaFrequency <= 30 then do;
		AnginaFreq = "Daily";
		MultinomialAngina = 3;
	End;
	Else If AnginaFrequency <= 60 then do;
		AnginaFreq = "Weekly";
		MultinomialAngina = 2;
	End;
	Else If AnginaFrequency <= 99 then do;
		AnginaFreq = "Monthly";
		MultinomialAngina = 1;
	End;
	Else If AnginaFrequency = 100 then do;
		AnginaFreq = "None";
		MultinomialAngina = 0;
	End;
Run;

*****************************************************************************
Treatment Satisfaction
*****************************************************************************;
*Response of 6 = 5 for pills;
Data Analysis; Set Analysis;
	If BothersometoTakePills = 6 then BothersometoTakePills = 5;
	TreatmentSatisfaction = 100*(mean(BothersometoTakePills,ChestPainTreatmentSatisfaction,DoctorExplnSatisfaction,OverallTreatmentSatisfaction)-1)/4;
Run;

*****************************************************************************
Quality of Life
*****************************************************************************;
Data Analysis; Set Analysis;
	InterferenceOfChestPain = InterferenceOfChestPainOnEnjoyme;
	QualityofLife = 100*(mean(InterferenceOfChestPainOnEnjoyme,FeelOnRestLifeDueToChestPain,WorryAboutHeartAttackAndDeath)-1)/4;
Run;

*****************************************************************************
Add Time in Hours
*****************************************************************************;
Data Analysis;	Set Analysis;
	If OnsettoArrival ^= . then OnsettoArrivalHours = OnsettoArrival / 60;
	Else OnsettoArrivalHours = .;
Run;

Libname Raw "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper";

Data Raw.SAQ; set Analysis; Run; 
proc export data=Analysis outfile= "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\SAQ.dta" replace; run;
