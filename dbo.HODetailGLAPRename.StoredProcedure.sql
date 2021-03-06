USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailGLAPRename]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailGLAPRename]

AS
BEGIN
	
--This updates the account and description of the lines that need to be renamed in the GL Detail
Update A
Set A.Acct = B.CAcct, A.AcctDesc = B.CGroup
From Detail_GL_Data A, Report_Account_Collapse B
Where A.Acct between B.LAcct and B.HAcct

--This updates the account and description of the lines that need to be renamed in the AP Detail
Update A
Set A.Acct = B.CAcct, A.AcctDesc = B.CGroup
From Detail_AP_Data A, Report_Account_Collapse B
Where A.Acct between B.LAcct and B.HAcct

	
END


GO
