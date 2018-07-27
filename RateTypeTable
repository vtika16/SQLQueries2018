Select 
P_C_RT_FP.CompanyID,
P_C_RT_FP.CompanyCode,
P_C_RT_FP.ProductID,
P_C_RT_FP.TPAInd,
P_C_RT_FP.PlanCode,
P_C_RT_FP.PlanOption,
P_C_RT_FP.LIFEANNInd,
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
P_C_RT_FP.ProductFundProfileCode,
P_C_RT_FP.IndexStrategyLength,
P_C_RT_FP.StateCode,
P_C_RT_FP.IssueDate,
P_C_RT_FP.FormGroup,
P_C_RT_FP.StrategyType,
P_C_RT_FP.RateTypeID,
P_C_RT_FP.FixedVariableInd
from Rate R 
	inner join  -- Rate table i.e. R joined with Join Result of Company_Product_RateType_FundProfile i.e. P_C_RT_FP
		( 
			Select P_C_RT.CompanyCode,P_C_RT.PlanCode,P_C_RT.PlanOption,P_C_RT.RateType,P_C_RT.ProductID,
					P_C_RT.TPAInd,P_C_RT.CompanyID,P_C_RT.LIFEANNInd,P_C_RT.RateTypeID,P_C_RT.FixedVariableInd,FP.*
			from
				(
				Select ProductFundProfileCode,IndexStrategyLength,StateCode,IssueDate,FundRateID,StrategyType,FormGroup from FundProfile
				) FP 
				inner join -- FundProfile i.e. FP joined with Company_Product_RateType i.e. P_C_RT
					(
					Select distinct RT.ProductFundProfileCode, ltrim(rtrim(P_C.CompanyCode)) as CompanyCode, P_C.CompanyID,
						P_C.ProductID, P_C.TPAInd, ltrim(rtrim(P_C.PlanCode)) as PlanCode, ltrim(rtrim(P_C.PlanOption)) as PlanOption,
						ltrim(rtrim(RT.RateType)) as RateType, ltrim(rtrim(P_C.LIFEANNInd)) as LIFEANNInd,RT.RateTypeID,RT.FixedVariableInd
					from 
						(
						Select distinct RateTypeID,ProductFundProfileCode,RateType,ProductID,FixedVariableInd from RateType where ProductFundProfileCode IS NOT NULL
						) RT
							inner join -- RateType join with Company_Product i.e. P_C
								(Select P.ProductID,P.TPAInd,P.CompanyID,C.CompanyCode,P.PlanCode,P.PlanOption,P.PlanEffectiveDate,P.FormGroup,P.LIFEANNInd
									from Product P inner join Company C on P.CompanyId=C.CompanyID 
								)P_C
							on RT.ProductID=P_C.ProductID
					) P_C_RT
				on FP.ProductFundProfileCode=P_C_RT.ProductFundProfileCode
		)P_C_RT_FP 
	on R.FundRateID=P_C_RT_FP.FundRateID and R.RateType=P_C_RT_FP.RateType and R.CompanyID=P_C_RT_FP.CompanyID
