USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HOReportDataInsertCorp]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HOReportDataInsertCorp] 
	@FY as bigint,
	@Pd as int
AS
BEGIN
	
--Declare @Pd as int, @FY as bigint
--Set @FY = 2013
--Set @Pd = 3

--Update Company 2 fit structure of Assign table
Update HOHyperionData
Set Company = cast(CAST(Company as bigint) as varchar(50)), AcctUnit = cast(CAST(AcctUnit as bigint) as varchar(50))
Where Company is not null


	Create table #Tempbal(
	[Owner] [varchar](50) NULL,
	[FiscalYear] [bigint] NULL,
	[Period] [bigint] NULL,
	[Company] [varchar](50) NULL,
	[AcctUnit] [varchar](50) NULL,
	[Decription] [varchar](50) NULL,
	[Account] [varchar](50) NULL,
	[AcctDecription] [varchar](50) NULL,
	[seq_number] [varchar](50) NULL,
	[AcctGroupDescription] [varchar](50) NULL,
	[AmountMth] [decimal](32, 2) NULL,
	[AmountYTD] [decimal](32, 2) NULL,
	[AmountType] [varchar](10) NULL,
	[Source] [varchar](50) NULL
	)

	Insert into #Tempbal(owner,FiscalYear,Period,Company,AcctUnit,Decription, Account,AcctDecription,seq_number,AcctGroupDescription,AmountMth,AmountYTD,AmountType,Source)
	select a.Owner,a.FiscalYear,a.Period,a.Company,a.AcctUnit,a.AcctUnitDesc,a.Acct,a.AcctDecription,a.seq_number as Seq_Number,a.AcctGroupDescription,
	a.Amount, sum(cast(b.amount as decimal(25,2))) as YTDF, a.Type,a.Source
	from
	(
		select 
		ha.Owner,hp.FiscalYear, hp.Period, cast(ha.Company as varchar(50)) as Company, ha.AcctUnit,  hp.AcctUnitDesc
		,cast(hp.Account as varchar(50)) as Acct,  hp.AccountDesc as AcctDecription, ds.seq_number , ds.account_desc as AcctGroupDescription,
		hp.Amount,
		hp.Type
		, 'Hyperion' as Source
		from 
		dbo.HOAcctUnitAssign ha 
		left outer join dbo.HOHyperionData hp on ha.Company = hp.company and ha.AcctUnit = hp.acctunit
		left outer join RLAWPROD..LAWSON.GLCHARTDTL dt on dt.account = hp.Account and dt.sub_account = 0
		left outer join RLAWPROD..LAWSON.GLCHARTSUM ds on ds.Sumry_Acct_ID = dt.Sumry_Acct_ID
		where hp.FiscalYear in (@FY,@FY-1) and hp.Period = @Pd and 
		hp.account between 50000 and 89999
	) a 
	left outer join HOHyperionData b on  a.Company = b.Company and a.AcctUnit = b.AcctUnit and a.Acct = b.Account and a.Type = b.Type and a.fiscalYear = b.FiscalYear
	where b.period <= a.Period
	group by 
	a.Owner,a.FiscalYear,a.Period, a.Company,a.AcctUnit, a.AcctUnitDesc,a.Acct, a.AcctDecription, a.seq_number, a.AcctGroupDescription, a.Type
	,a.Amount,a.Source



	Insert into #Tempbal(owner,FiscalYear,Period,Company,AcctUnit,Decription, Account,AcctDecription,seq_number,AcctGroupDescription,AmountMth,AmountYTD,AmountType,Source)
	select a.Owner,a.FiscalYear,a.Period,a.Company,a.AcctUnit,a.AcctUnitDesc,a.Acct,a.AcctDecription,a.seq_number as Seq_Number,a.AcctGroupDescription,
	a.Amount, sum(cast(b.amount as decimal(25,2))) as YTDF, a.Type,a.Source
	from
	(
		select 
		ha.Owner,hp.FiscalYear, hp.Period, cast(ha.Company as varchar(50)) as Company, ha.AcctUnit,  hp.AcctUnitDesc
		,cast(hp.Account as varchar(50)) as Acct,  hp.AccountDesc as AcctDecription, ds.seq_number , ds.account_desc as AcctGroupDescription,
		hp.Amount,
		hp.Type
		, 'Hyperion' as Source
		from 
		dbo.HOAcctUnitAssign ha 
		left join dbo.HOHyperionData hp on ha.Company = hp.company and ha.AcctUnit = hp.acctunit
		left outer join RLAWPROD..LAWSON.GLCHARTDTL dt on dt.account = hp.Account and dt.sub_account = 0
		left outer join RLAWPROD..LAWSON.GLCHARTSUM ds on ds.Sumry_Acct_ID = dt.Sumry_Acct_ID
		--(SELECT CAST(D.Account as varchar(40)) as Acct, D.Sub_Account as SubAcct, D.Account_Desc as AcctDesc, 
		--	S.Seq_Number as SumSeq, S.Account_Desc as SumDesc FROM
		--	RLAWPROD..LAWSON.GLCHARTDTL D
		--	LEFT OUTER JOIN RLAWPROD..LAWSON.GLCHARTSUM S on S.Sumry_Acct_ID = D.Sumry_Acct_ID WHERE D.Sub_Account = 0
		--	)C on hp.Acct = C.Acct
		where hp.FiscalYear = @FY-1 and hp.Period = 12 and 
		hp.account between 50000 and 89999
	) a 
	left outer join HOHyperionData b on  a.Company = b.Company and a.AcctUnit = b.AcctUnit and a.Acct = b.Account and a.Type = b.Type and a.fiscalYear = b.FiscalYear
	where b.period <= a.Period
	group by 
	a.Owner,a.FiscalYear,a.Period, a.Company,a.AcctUnit, a.AcctUnitDesc,a.Acct, a.AcctDecription, a.seq_number, a.AcctGroupDescription, a.Type
	,a.Amount,a.Source

	Declare @BuildLvl as bigint, @loopct as bigint, @int as bigint
	Set @BuildLvl = (Select max(BuilderOrder) from dbo.HOHierarchy)
	--Set @loopct = @BuildLvl

	While @BuildLvl > 0
	Begin
		
		Insert 
		#TempBal(Owner, FiscalYear, Period,Company,AcctUnit,Decription,Account,AcctDecription, seq_number,AcctGroupDescription,AmountMth, AmountYTD,AmountType,Source)
		select a.ParentOwner,
		a.FiscalYear, a.Period, '9999', a.Owner, a.Owner,a.Account, a.AcctDecription, a.seq_number,a.AcctGroupDescription,
		a.AmountMth, a.AmountYTD,a.AmountType, a.Source
		from
		(
		select hh.ParentOwner,
		a.FiscalYear, a.Period, a.Company, hh.Owner, a.Decription,a.Account, a.AcctDecription, a.seq_number,a.AcctGroupDescription,
		Sum(a.AmountMth) as AmountMth , Sum(a.AmountYTD) as AmountYTD,a.AmountType, a.Source
		from
		#TempBal a
		left join dbo.HOHierarchy hh on a.Owner = hh.Owner
		where BuilderOrder = @BuildLvl
		group by hh.ParentOwner,a.FiscalYear, a.Period, a.Company, hh.Owner,a.Decription,a.Account, a.AcctDecription,a.seq_number,a.AcctGroupDescription,
		a.AmountType, a.Source
		) a

		set @BuildLvl = @BuildLvl-1
	End
	--select * from #TempBal order by Owner

	Insert into dbo.HOReportData--([Owner],FY,Period,Company,AcctUnit,AcctUnitDesc,Acct,AcctDesc,SumSeq,SumDesc,Source)
	select distinct
	[Owner],
	@FY,
	@PD,
	[Company],
	[AcctUnit],
	[Decription],
	[Account],
	[AcctDecription],
	[seq_number],
	[AcctGroupDescription],
	sum(case when AmountType = 'Actual' and FiscalYear=@FY and Period = @PD then ISnull(AmountMth,0) else 0 end),
	sum(case when AmountType = 'Budget' and FiscalYear=@FY and Period = @PD then ISnull(AmountMth,0) else 0 end),
	sum(case when AmountType = 'Actual' and FiscalYear=@FY-1 and Period = @PD then ISnull(AmountMth,0) else 0 end),
	sum(case when AmountType = 'Actual' and FiscalYear=@FY and Period = @PD then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'Budget' and FiscalYear=@FY and Period = @PD then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'Actual' and FiscalYear=@FY-1 and Period = @PD then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'Budget' and FiscalYear=@FY and Period = 12 then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'Budget' and FiscalYear=@FY-1 and Period = 12 then ISnull(AmountYTD,0) else 0 end),
	[Source]
	from #TempBal
	group by
	[Owner],
	[Company],
	[AcctUnit],
	[Decription],
	[Account],
	[AcctDecription],
	[seq_number],
	[AcctGroupDescription],
	[Source]

	Drop table #Tempbal
		
END


GO
