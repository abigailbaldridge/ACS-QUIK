*********************************************************************************************
* PROGRAM     : Q:\GRP-Huffman\NU\ACS\Data\Q:\Faculty\Huffman\NU\ACS QUIK\Data\Table3.SAS	*
* DESCRIPTION : 																			*
* PROGRAMMER  : Abigail Baldridge		 	            									*
* DATE		  : June 2, 2017																*
*********************************************************************************************;

OPTIONS NODATE NONUMBER nofmterr mprint mlogic symbolgen;

*********************************************************************************************
Import the analysis data file
*********************************************************************************************;
libname raw 'Q:\Faculty\Huffman\NU\ACS QUIK\Data\Code\SAS Code\Primary Outcomes Paper';

data Analysis; Set Raw.Included; Run;

*****************************************************************************
TABLE 3
*****************************************************************************;
Proc Sort Data = Analysis; By Intervention; Run;

Proc Freq Data = Analysis;	
	Table MACE Death CVDDeath InDeath Reinfarction Stroke MajorBleeding OptimalInHospMeds OptimalDischargeMeds DischargeSmokeCounsel;
	By Intervention;
	ods output onewayfreqs = Cat;
Run;

Data Cat (Keep = Intervention Table Frequency Per); Set Cat;
	if OptimalInHospMeds = 1 or OptimalDischargeMeds = 1 or DischargeSmokeCounsel = 1 then Per = Percent;
	Else if MACE = 1 or Death = 1 or CVDDeath = 1 or InDeath = 1 or Reinfarction = 1 or Stroke = 1 or MajorBleeding = 1 then do;
		If Intervention = 1 then Per = 100*(Frequency / 11308);
		if Intervention = 0 then Per = 100*(Frequency / 10066);
	End;
	Where MACE = 1 or Death = 1 or CVDDeath = 1 or InDeath = 1 or Reinfarction = 1 or Stroke = 1 or 
			MajorBleeding = 1 or OptimalInHospMeds = 1 or OptimalDischargeMeds = 1 or DischargeSmokeCounsel = 1;
Run;

**>>>ST:Table(Label="Table 3", Frequency="Always", ColFilterEnabled=True, ColFilterType="Exclude", ColFilterValue="1", RowFilterEnabled=True, RowFilterType="Exclude", RowFilterValue="1", Type="Default");
ods csv file = "Q:\Faculty\Huffman\NU\ACS QUIK\Data\Output\Primary Outcomes Paper\Table3.csv";
Proc Print Data = Cat noobs; Run;
ods csv close;
**<<<;
