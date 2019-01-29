*********************************************************************************************
* PROGRAM     : Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Seattle Angina Paper\Figures.sas*
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
Figure 1
*****************************************************************************;
%Macro MakeLong(Var=,Int=,Num=);
Data Temp (Keep = Response Indicator Intensity Order Male); Set Analysis;
	Length Indicator Intensity $40.;
	Indicator = "&Var";
	Intensity = "&Int";
	Response = &Var;
	Order = "&Num";
Run;

Proc Append Base = PhysicalActivity Data = Temp; Run;
%Mend MakeLong;

%MakeLong(Var=SelfDressing,Int=Low,Num=A);
%MakeLong(Var=WalkingIndoors,Int=Low,Num=B);
%MakeLong(Var=Showering,Int=Low,Num=C);
%MakeLong(Var=ClimbWithoutStop,Int=Medium,Num=D);
%MakeLong(Var=Gardening,Int=Medium,Num=E);
%MakeLong(Var=BriskWalkingPace,Int=Medium,Num=F);
%MakeLong(Var=Running,Int=High,Num=G);
%MakeLong(Var=LiftingHeavyObjects,Int=High,Num=H);
%MakeLong(Var=Sports,Int=High,Num=I);

proc datasets lib=work nolist;
delete Temp; 
quit;
run;

Data PhysicalActivity; Set PhysicalActivity;
	RoundResponse = Round(Response,1);
Run;

Data PhysicalActivity; Set PhysicalActivity;
	If RoundResponse = 1 then do;
		CharResponse = "Severely Limited";
		YOrder = "G"; 
	End;
	If RoundResponse = 2 then do;
		CharResponse = "Moderately Limited";
		YOrder = "F"; 
	End;
	If RoundResponse = 3 then do;
		CharResponse = "Somewhat Limited";
		YOrder = "E";  
	End;
	If RoundResponse = 4 then do;
		CharResponse = "A Little Limited";
		YOrder = "D";  
	End;
	If RoundResponse = 5 then do;
		CharResponse = "Not Limited";
		YOrder = "C"; 
	End;
	If RoundResponse = 6 then do;
		CharResponse = "Limited, Or Did Not Do";
		YOrder = "B"; 
	End;G
	If RoundResponse = . then do;
		CharResponse = "Did not respond";
		YOrder = "A";  
	End;
Run; 

Data Figure1; Set PhysicalActivity;
	where CharResponse ^= "";
Run;

Data Raw.Figure1; Set Figure1; Run;



*****************************************************************************
Figure 2
*****************************************************************************;
Proc Sort Data = Analysis;
	By CenterID;
Run; 

proc means data=Analysis noprint;                                                                                                           
   by CenterID;                                                                                                                    
   var PhysicalLimitation AnginaStability AnginaFrequency TreatmentSatisfaction QualityofLife;                                                                                                                            
   output out=Scores;                                                                     
run;    

Data Scores; Set Scores;
	Where _STAT_ = "MEAN";
Run;

%Macro AddOrder (Var =);
Proc Sort data = Scores; By descending &Var; Run;

Data Scores; Set Scores;
	Order&Var = _N_;
Run;
       
Proc Sort Data = Scores; By CenterID; Run;

Data Analysis;	
	Merge
	Analysis
	Scores (Keep = CenterId Order&Var);
	By CenterID;
Run; 
%Mend AddOrder;

%AddOrder(Var=PhysicalLimitation);
%AddOrder(Var=AnginaFrequency);
%AddOrder(Var=TreatmentSatisfaction);
%AddOrder(Var=QualityofLife);

Proc Sort Data = Analysis; By OrderPhysicalLimitation; Run;                                                                                                                                                                                                                                                                                                                                
Proc SGPLot Data = Analysis;
	hbox PhysicalLimitation / category=CenterID meanattrs = (symbol = diamondfilled color = black) whiskerattrs = (color = black) fillattrs = (color = grey) BOXWIDTH= .35;
	yaxis discreteorder=data display = none;
	xaxis min = 0 max =100 valueattrs = (size = 18) display = (Nolabel);
Run;

Proc Sort Data = Analysis; By OrderAnginaFrequency; Run;                                                                                                                                                                                                                                                                                                                                
Proc SGPLot Data = Analysis;
	hbox AnginaFrequency / category=CenterID meanattrs = (symbol = diamondfilled color = black) whiskerattrs = (color = black) fillattrs = (color = grey) BOXWIDTH= .35;
	yaxis discreteorder=data display = none;
	xaxis min = 0 max =100 valueattrs = (size = 18) display = (Nolabel);
Run;

Proc Sort Data = Analysis; By OrderTreatmentSatisfaction; Run;                                                                                                                                                                                                                                                                                                                                
Proc SGPLot Data = Analysis;
	hbox TreatmentSatisfaction / category=CenterID meanattrs = (symbol = diamondfilled color = black) whiskerattrs = (color = black) fillattrs = (color = grey) BOXWIDTH= .35;
	yaxis discreteorder=data display = none;
	xaxis min = 0 max =100 valueattrs = (size = 18) display = (Nolabel);
Run;

Proc Sort Data = Analysis; By OrderQualityofLife; Run;                                                                                                                                                                                                                                                                                                                                
Proc SGPLot Data = Analysis;
	hbox QualityofLife / category=CenterID meanattrs = (symbol = diamondfilled color = black) whiskerattrs = (color = black) fillattrs = (color = grey) BOXWIDTH= .35;
	yaxis discreteorder=data display = none;
	xaxis min = 0 max =100 valueattrs = (size = 18) display = (Nolabel);
Run;


