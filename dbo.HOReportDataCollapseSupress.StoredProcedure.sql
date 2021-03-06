USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HOReportDataCollapseSupress]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HOReportDataCollapseSupress]
	
AS
BEGIN

	--This updates the account and description of the lines that need to be collapsed
Update A
Set A.Acct = B.CAcct, A.AcctDesc = B.CGroup
From HOReportData A, HOAcctCollapse B
Where A.Acct between B.LAcct and B.HAcct

--Supress
DELETE R FROM
HOReportData R
INNER JOIN HOAcctSurpress S on S.Account = R.Acct

DELETE From HOReportData Where Acct < '50000'

END


GO
