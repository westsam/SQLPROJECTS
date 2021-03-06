USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HOReportDataInsertRetail]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HOReportDataInsertRetail]
	-- Add the parameters for the stored procedure here
	@FY as bigint,@PD as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
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
	

	--Comnay NULL for summary lines ***********
	--select * from #TempBal order by Owner

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

	--select * from dbo.Report_Data
	--select * from #Tempbal t left join dbo.report_data d on t.FiscalYear = d.FY and t.Period = d.period and t.Account = d.Acct and t.Company = d.company and t.AcctUnit = d.acctunit
	--where t.AmountType = 'A' and t.FiscalYear = @FY and t.Period = @PD

	--update  dbo.Report_Data
	--set MTDACT = (select AmountMth from  dbo.Report_Data t2 left join #Tempbal t1 
	--on 
	--t1.Company = t2.Company and t1.AcctUnit = t2.AcctUnit and t1.decription = t2.AcctUnitDesc and t1.FiscalYear = t2.FY and t1.Period = t2.Period
	--and t1.Owner = t2.Owner and t1.Account = t2.Acct
	--where t1.AmountType = 'A' and t1.FiscalYear = @FY and t1.Period = @PD
	--)
	------MTDBUD = (select t.AmountMth from #Tempbal t left join dbo.report_data d on t.FiscalYear = d.FY and t.Period = d.period and t.Account = d.Acct and t.Company = d.company and t.AcctUnit = d.acctunit
	------where t.AmountType = 'B'),
	------MTDLYA = (select t.AmountMth from #Tempbal t left join dbo.report_data d on t.FiscalYear = d.FY-1 and t.Period = d.period and t.Account = d.Acct and t.Company = d.company and t.AcctUnit = d.acctunit
	------where t.AmountType = 'A')
	Drop table #TempBal


END

GO
