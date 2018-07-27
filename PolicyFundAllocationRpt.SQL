SELECT [PolicyNum] as PolicyNumber
      ,[FundCode] as StrategyType
	  ,a.Plan_Code as PlanCode
	  ,a.Marketing_Nm as MarketingName
	  ,a.Initial_Buy_Dt as InitialBuyDate
	 -- ,a.Admin_Status_ID
	  ,a.VendorDesc as PolicyStatus
  FROM [CDS].[Policy].[PolicySummaryFinancialsFund] psf


  join (
  SELECT
		policy_num
      ,[Admin_Status_ID]
      ,[Admin_Status_Last_Changed_Dt]
      ,[NB_Status_ID]
	  ,pc.Plan_Code
	  ,mn.Marketing_Nm
      ,[Initial_Buy_Dt]
	  ,ld.VendorDesc
  FROM [CDS].[Policy].[Policy] p

  join [Lookup].[LookupDetails] ld
  on p.Admin_Status_ID = ld.lookupdetailid

  join Product.Plan_Code pc
  on pc.plan_code_id = p.plan_code_id

  join [Product].[Product_Plan_Code_XRef] pcx
  on pcx.[Plan_Code_ID] = pc.Plan_Code_ID

  join [Product].[Marketing_Name] mn
  on pcx.[Marketing_ID] = mn.marketing_id

  where tpa_id = 2
  and p.[Initial_Buy_Dt] >= '2017-08-22' ) a

  on psf.policynum = a.policy_num
