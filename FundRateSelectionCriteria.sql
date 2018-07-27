SELECT DISTINCT
Activity.RateType,
Activity.IssueDate,
Activity.Rate,
Activity.FundCode,
Activity.CISDuration,
activity.Plancode
FROM
LAYER_ACTIVITY.dbo.Activity
WHERE (
StrategyType='FFND'  OR PlanCode in ('SG05M','SG07M','3MYGAR')
)
AND FundCode is not Null
--AND issuedate='2018-02-01'
AND (
(LEN(Activity.FundCode)=4 and Plancode LIKE 'PE%') OR Plancode not like 'PE%'
)
AND ACTIVITY.RATE <>0
AND ACTIVITY.RateType IN ('CF','GF')
