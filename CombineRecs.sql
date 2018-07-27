Select 
R1R3.CompanyCode,
R1R3.PlanCode,
R1R3.PlanOption,
R1R3.StrategyType,
R1R3.State,
R1R3.RateType,
R1R3.IssueDate,
R1R3.RuleSetPointer,
R1R3.FileInstanceID,
R1R3.CycleDate,
R1R3.FormGroup,
R1R3.PlanEffectiveDate,
R2.RulesetEffectiveDate,
Rate,
DENSE_RANK() over 
(partition by R1R3.CompanyCode,R1R3.RateType,R1R3.RulesetPointer,R1R3.PlanCode,R1R3.PlanOption,R1R3.StrategyType,
R1R3.State,convert(varchar(8),R1R3.IssueDate,112),R1R3.FormGroup order by R2.RulesetEffectiveDate desc) 
as RuleSetEffCNTR, -- To get Closest RuleSet Effective Date looking back for an Issue date ranking
R2.RateEffectiveDate,
R2.DepositDate,
R2.Duration,
R2.LoanRateType,
R2.IssueAge 
from
( --R1R3 Join Result Query
Select 
R1.*,R3.FormGroup,R3.PlanEffectiveDate 
from
(Select distinct
ltrim(rtrim(CompanyCode)) CompanyCode
,ltrim(rtrim(PlanCode)) as PlanCode
,ltrim(rtrim(PlanOption)) as PlanOption
,ltrim(rtrim(StrategyType)) as StrategyType
,ltrim(rtrim(State)) as State
,ltrim(rtrim(RateType)) as RateType
,IssueDate
,ltrim(rtrim(RulesetPointer)) as RuleSetPointer
,ltrim(rtrim(FileInstanceID)) as FileInstanceID
,CycleDate
FROM [dbo].StageRec1
) R1
inner join
(SELECT
ltrim(rtrim(CompanyCode)) as CompanyCode
,ltrim(rtrim(PlanCode)) as PlanCode
,ltrim(rtrim(PlanOption)) as PlanOption
,ltrim(rtrim(FormGroup)) as FormGroup
, Max(PlanEffectiveDate) as PlanEffectiveDate
FROM [dbo].StageRec3 group by CompanyCode, PlanCode,PlanOption,FormGroup
) R3
on  R1.CompanyCode=R3.CompanyCode
and R1.PlanCode=R3.PlanCode
and R1.PlanOption=R3.PlanOption
) R1R3
inner join  -- Join Rec1Rec3 Result to Rec2
( -- Rec2 Query
SELECT Distinct
ltrim(rtrim(CompanyCode)) as CompanyCode
,ltrim(rtrim(RuleSetPointer)) as RuleSetPointer
,ltrim(rtrim(RateType)) as RateType
,ltrim(rtrim(RulesetEffectiveDate)) as RulesetEffectiveDate
,ltrim(rtrim(Rate)) as Rate
,ltrim(rtrim(RateEffectiveDate)) as RateEffectiveDate
,ltrim(rtrim(DepositDate)) as DepositDate
,ltrim(rtrim(Duration)) as Duration
,ltrim(rtrim(LoanRateType)) as LoanRateType
,ltrim(rtrim(IssueAge)) as IssueAge
FROM
STG_RDBA.dbo.StageRec2
) R2
On  R1R3.CompanyCode=R2.CompanyCode
and R1R3.RateType=R2.RateType
and R1R3.RuleSetPointer=R2.RuleSetPointer
and R1R3.IssueDate>=Convert(date,R2.RulesetEffectiveDate)
