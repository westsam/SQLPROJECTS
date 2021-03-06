USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HOReportDataBuild]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HOReportDataBuild]
	@FY as bigint,
	@Pd as int
AS
BEGIN
	SET NOCOUNT ON;

--Step 1*********** HOHyperionDataConvert
Delete from HOReportData
--Update Report_AcctUnit_Assign Set SummaryBuilt = Null
Delete FROM HOHyperionData where Amount = ''

	UPDATE H
	SET Company = substring(LEFT(Entity,PATINDEX('%[_]%',Entity)-1),4,LEN(LEFT(Entity,PATINDEX('%[_]%',Entity)-1))), 
	AcctUnit = SUBSTRING(Entity, PATINDEX('%[_]%',Entity) +1, LEN(Entity)),AcctUnitDesc = EntityDesc
	FROM ExpenseReporting.dbo.HOHyperionData H

	--This changes the Hyperion accounts to Corporate Lawson accounts
	UPDATE H
	SET Account = HC.CLAcct
	FROM ExpenseReporting.dbo.HOHyperionData H
		INNER JOIN ExpenseReporting.dbo.TranslationHypeToCorp HC on
			H.Acct = HC.HAcct
		
	--This changes the Corporate Lawson accounts to Retail Lawson accounts
	UPDATE H
	SET Account = CR.RTLAcct, AccountDesc = CR.RTLDesc
	FROM ExpenseReporting.dbo.HOHyperionData H
		INNER JOIN ExpenseReporting.dbo.TranslationCorpToRetail CR on
			H.Account = CR.CLAcct

	UPDATE H
	SET FiscalYear = '20'+ right(ISNULL(FY,'NULL'),2),Period = case
	when Pd = 'Apr' then 1 
	when Pd = 'May' then 2
	when Pd = 'Jun' then 3
	when Pd = 'Jul' then 4
	when Pd = 'Aug' then 5
	when Pd = 'Sep' then 6
	when Pd = 'Oct' then 7
	when Pd = 'Nov' then 8
	when Pd = 'Dec' then 9
	when Pd = 'Jan' then 10
	when Pd = 'Feb' then 11
	when Pd = 'Mar' then 12
	else ''
	End
	FROM ExpenseReporting.dbo.HOHyperionData H

	--Delete Suppressed Accounts
	Delete h 
	From HOHyperionData h
	Inner Join HOAcctSurpress s on h.Account = s.Account

	--Check if any accounts didn't convert		
	SELECT * FROM HOHyperionData WHERE Len(Account) <> 5 Order By Acct


--Step 2*********** HOReportDataInsertRetail @FY, @Pd 
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
	Insert into #Tempbal
	Select 
	ha.Owner,fb.FiscalYear, fb.Period, cast(ha.Company as varchar(50)), ha.AcctUnit,  rtrim(n.AcctUnitDescr) as Decription,cast(fb.Account as varchar(50)),  cd.Account_Desc as AcctDecription, cs.seq_number , cs.account_desc as AcctGroupDescription,
	fb.AmountMth, fb.AmountYTD,fb.AmountType, fb.SourceSystem as Source
	from 
	dbo.HOAcctUnitAssign ha 
	left join VMXXCRPFNDB01.FSR.dbo.FSBalances fb on ha.Company = fb.company and ha.AcctUnit = fb.acctunit
	Left Outer Join VMXXCRPFNDB01.FSR.dbo.FSACCTUNIT n on fb.company = n.company and fb.acctunit = n.acctunit
	Left Outer Join RLAWPROD..LAWSON.GLCHARTDTL cd on fb.account = cd.account and fb.subaccount = cd.sub_account
	Left Outer Join RLAWPROD..LAWSON.GLCHARTSUM cs on cd.sumry_acct_id = cs.sumry_acct_id
	where fb.fiscalyear in (@FY, @FY-1) and fb.period in (12, @PD) and fb.account between 50000 and 89999
	
	Declare @BuildLvl as bigint, @loopct as bigint, @int as bigint
	Set @BuildLvl = (Select max(BuilderOrder) from dbo.HOHierarchy)
	--Set @loopct = @BuildLvl

	While @BuildLvl > 0
	Begin
		
		Insert 
		#TempBal(Owner, FiscalYear, Period,Company,AcctUnit,Decription,Account,AcctDecription, seq_number,AcctGroupDescription,AmountMth, AmountYTD,AmountType,Source)
		select a.ParentOwner,
		a.FiscalYear, a.Period, '9999', a.Owner, a.Owner --a.Decription
		,a.Account, a.AcctDecription, a.seq_number, a.AcctGroupDescription,
		a.AmountMth, a.AmountYTD,a.AmountType, a.Source
		from
		(
		select hh.ParentOwner,
		a.FiscalYear, a.Period, a.Company, hh.Owner,  a.Decription,a.Account,  a.AcctDecription, a.seq_number, a.AcctGroupDescription,
		Sum(a.AmountMth) as AmountMth , Sum(a.AmountYTD) as AmountYTD,a.AmountType, a.Source
		from
		#TempBal a
		left join dbo.HOHierarchy hh on a.Owner = hh.Owner
		where BuilderOrder = @BuildLvl
		group by hh.ParentOwner,a.FiscalYear, a.Period, a.Company, hh.Owner,  a.Decription,a.Account,  a.AcctDecription, a.seq_number, a.AcctGroupDescription,
		a.AmountType, a.Source
		) a
	

		set @BuildLvl = @BuildLvl-1
	End

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
	sum(case when AmountType = 'A' and FiscalYear=@FY and Period = @PD then ISnull(AmountMth,0) else 0 end),
	sum(case when AmountType = 'B' and FiscalYear=@FY and Period = @PD then ISnull(AmountMth,0) else 0 end),
	sum(case when AmountType = 'A' and FiscalYear=@FY-1 and Period = @PD then ISnull(AmountMth,0) else 0 end),
	sum(case when AmountType = 'A' and FiscalYear=@FY and Period = @PD then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'B' and FiscalYear=@FY and Period = @PD then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'A' and FiscalYear=@FY-1 and Period = @PD then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'B' and FiscalYear=@FY and Period = 12 then ISnull(AmountYTD,0) else 0 end),
	sum(case when AmountType = 'B' and FiscalYear=@FY-1 and Period = 12 then ISnull(AmountYTD,0) else 0 end),
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

	Drop table #TempBal


--Step 3*********** HOReportDataInsertCorp @FY, @Pd
Update HOHyperionData
Set Company = cast(CAST(Company as bigint) as varchar(50)), AcctUnit = cast(CAST(AcctUnit as bigint) as varchar(50))
Where Company is not null


	Create table #Tempbalc(
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

	Insert into #Tempbalc(owner,FiscalYear,Period,Company,AcctUnit,Decription, Account,AcctDecription,seq_number,AcctGroupDescription,AmountMth,AmountYTD,AmountType,Source)
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



	Insert into #Tempbalc(owner,FiscalYear,Period,Company,AcctUnit,Decription, Account,AcctDecription,seq_number,AcctGroupDescription,AmountMth,AmountYTD,AmountType,Source)
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
		where hp.FiscalYear = @FY-1 and hp.Period = 12 and 
		hp.account between 50000 and 89999
	) a 
	left outer join HOHyperionData b on  a.Company = b.Company and a.AcctUnit = b.AcctUnit and a.Acct = b.Account and a.Type = b.Type and a.fiscalYear = b.FiscalYear
	where b.period <= a.Period
	group by 
	a.Owner,a.FiscalYear,a.Period, a.Company,a.AcctUnit, a.AcctUnitDesc,a.Acct, a.AcctDecription, a.seq_number, a.AcctGroupDescription, a.Type
	,a.Amount,a.Source

	Declare @BuildLvlc as bigint, @loopctc as bigint, @intc as bigint
	Set @BuildLvlc = (Select max(BuilderOrder) from dbo.HOHierarchy)
	--Set @loopct = @BuildLvl

	While @BuildLvl > 0
	Begin
		
		Insert 
		#TempBalc(Owner, FiscalYear, Period,Company,AcctUnit,Decription,Account,AcctDecription, seq_number,AcctGroupDescription,AmountMth, AmountYTD,AmountType,Source)
		select a.ParentOwner,
		a.FiscalYear, a.Period, '9999', a.Owner, a.Owner,a.Account, a.AcctDecription, a.seq_number,a.AcctGroupDescription,
		a.AmountMth, a.AmountYTD,a.AmountType, a.Source
		from
		(
		select hh.ParentOwner,
		a.FiscalYear, a.Period, a.Company, hh.Owner, a.Decription,a.Account, a.AcctDecription, a.seq_number,a.AcctGroupDescription,
		Sum(a.AmountMth) as AmountMth , Sum(a.AmountYTD) as AmountYTD,a.AmountType, a.Source
		from
		#TempBalc a
		left join dbo.HOHierarchy hh on a.Owner = hh.Owner
		where BuilderOrder = @BuildLvl
		group by hh.ParentOwner,a.FiscalYear, a.Period, a.Company, hh.Owner,a.Decription,a.Account, a.AcctDecription,a.seq_number,a.AcctGroupDescription,
		a.AmountType, a.Source
		) a

		set @BuildLvlc = @BuildLvlc-1
	End

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
	from #TempBalc
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
	Drop table #TempBalc


--Step 4*********** HOReportDataCollapseSupress
Update A
Set A.Acct = B.CAcct, A.AcctDesc = B.CGroup
From HOReportData A, HOAcctCollapse B
Where A.Acct between B.LAcct and B.HAcct

--Supress
DELETE R FROM
HOReportData R
INNER JOIN HOAcctSurpress S on S.Account = R.Acct

DELETE From HOReportData Where Acct < '50000'

Print 'Report Data Built!'

END


GO
