USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailGLAPConvert]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailGLAPConvert]
AS
BEGIN

--This changes the Corporate Lawson accounts to Retail Lawson accounts in the GL detail table
UPDATE D
SET Acct = CR.RTLAcct, [AcctDesc] = CR.RTLDesc
FROM Detail_GL_Data D
	INNER JOIN Conversion_FromC_ToR CR on
		D.Acct = CR.CLAcct
		
--This changes the Corporate Lawson accounts to Retail Lawson accounts in the AP detail table
UPDATE D
SET Acct = CR.RTLAcct, [AcctDesc] = CR.RTLDesc
FROM ExpenseReporting.dbo.Detail_AP_Data D
	INNER JOIN Conversion_FromC_ToR CR on
		D.Acct = CR.CLAcct
		
END


GO
