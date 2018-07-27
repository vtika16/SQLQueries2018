Select 
P_C_RT_PP.CompanyID,
P_C_RT_PP.CompanyCode,
P_C_RT_PP.ProductID,
P_C_RT_PP.TPAInd,
P_C_RT_PP.PlanCode,
P_C_RT_PP.PlanOption,
P_C_RT_PP.LIFEANNInd,
R.RateID,
R.RulesetCode,
R.RateType,
R.RateEffectiveDate,
R.Rate,
R.RulesetEffectiveDate,
R.DepositDate,
R.Duration,
R.LoanRateType,
R.IssueAge,
R.FileInstanceID,
P_C_RT_PP.ProductPlanProfileCode,
P_C_RT_PP.StateCode,
P_C_RT_PP.IssueDate,
P_C_RT_PP.FormGroup,
P_C_RT_PP.RateTypeID,
P_C_RT_PP.FixedVariableInd
from Rate R 
	inner join  -- Rate table i.e. R joined with Join Result of Company_Product_RateType_PlanProfile i.e. P_C_RT_PP
		( 
			Select P_C_RT.CompanyCode,P_C_RT.PlanCode,P_C_RT.PlanOption,P_C_RT.RateType,P_C_RT.ProductID,
					P_C_RT.TPAInd,P_C_RT.CompanyID,P_C_RT.LIFEANNInd,P_C_RT.RateTypeID,P_C_RT.FixedVariableInd,PP.*
			from
				(
				Select ProductPlanProfileCode,StateCode,IssueDate,PlanRateID,FormGroup from PlanProfile
				) PP 
				inner join -- PlanProfile i.e. PP joined with Company_Product_RateType i.e. P_C_RT
					(
					Select distinct RT.ProductPlanProfileCode, ltrim(rtrim(P_C.CompanyCode)) as CompanyCode, P_C.CompanyID,
						P_C.ProductID, P_C.TPAInd, ltrim(rtrim(P_C.PlanCode)) as PlanCode, ltrim(rtrim(P_C.PlanOption)) as PlanOption,
						ltrim(rtrim(RT.RateType)) as RateType, ltrim(rtrim(P_C.LIFEANNInd)) as LIFEANNInd,RT.RateTypeID,RT.FixedVariableInd
					from 
						(
						Select distinct RateTypeID,ProductPlanProfileCode,RateType,ProductID,FixedVariableInd from RateType where ProductPlanProfileCode IS NOT NULL
						) RT
							inner join -- RateType join with Company_Product i.e. P_C
								(Select P.ProductID,P.TPAInd,P.CompanyID,C.CompanyCode,P.PlanCode,P.PlanOption,P.PlanEffectiveDate,P.FormGroup,P.LIFEANNInd
									from Product P inner join Company C on P.CompanyId=C.CompanyID 
								)P_C
							on RT.ProductID=P_C.ProductID
					) P_C_RT
				on PP.ProductPlanProfileCode=P_C_RT.ProductPlanProfileCode
		)P_C_RT_PP 
	on R.PlanRateID=P_C_RT_PP.PlanRateID and R.RateType=P_C_RT_PP.RateType and R.CompanyID=P_C_RT_PP.CompanyID
