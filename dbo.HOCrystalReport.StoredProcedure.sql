USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HOCrystalReport]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		xchen
-- Create date: 08/15/2016
-- Description:	Data to be used for Crystal Report
-- =============================================
CREATE PROCEDURE [dbo].[HOCrystalReport]

AS
BEGIN
	Declare @FYMax as Bigint
	Set @FYMax = (Select max(isnull(FY,0)) From HOReportData)

	Select d.owner as Report, @FYMax as FY, d.Period, d.Company, d.AcctUnit, d.AcctUnitDesc, d.Acct, d.AcctDesc, d.SumSeq, d.SumDesc,
	Sum(isnull(MTDACT,0)) as MTDACT, sum(isnull(MTDBUD,0)) as MTDBUD, sum(isnull(MTDLYA,0)) as MTDLYA,
	sum(isnull(YTDACT,0)) as YTDACT, sum(isnull(YTDBUD,0)) as YTDBUD, sum(isnull(YTDLYA,0)) as YTDLYA, 
	sum(isnull(FULBUD,0)) as FULBUD, sum(isnull(FULLYA,0)) as FULLYA, d.Source
	From HOReportData d (nolock)
	Where d.owner is not null
	group by d.owner, d.Period, d.Company, d.AcctUnit, d.AcctUnitDesc, d.Acct, d.AcctDesc, d.SumSeq, d.SumDesc,d.source
END



GO
