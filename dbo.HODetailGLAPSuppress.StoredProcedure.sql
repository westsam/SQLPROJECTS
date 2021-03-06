USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailGLAPSuppress]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailGLAPSuppress]
	
AS
BEGIN

--This deletes the lines that should not be shown in the GL detail table

DELETE D FROM
Detail_GL_Data D
INNER JOIN Report_Account_Suppress S on S.Account = D.Acct

--This deletes the lines that should not be shown in the AP detail table
DELETE D FROM
Detail_AP_Data D
INNER JOIN Report_Account_Suppress S on S.Account = D.Acct

END


GO
