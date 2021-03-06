USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailGLAPUpdateDesc]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailGLAPUpdateDesc]

AS
BEGIN

--Updates the retail account descriptions in the GL detail table
UPDATE D
SET AcctDesc = G.Account_Desc
FROM Detail_GL_Data D
	INNER JOIN (SELECT CAST(Account as Varchar(50)) as Account, Account_Desc FROM RETAIL_LAWSON..LAWSON.GLCHARTDTL) G on
		G.Account = D.Acct

--Updates the retail account descriptions in the AP detail table
UPDATE D
SET AcctDesc = G.Account_Desc
FROM Detail_AP_Data D
	INNER JOIN (SELECT CAST(Account as Varchar(50)) as Account, Account_Desc FROM RETAIL_LAWSON..LAWSON.GLCHARTDTL) G on
		G.Account = D.Acct		
END


GO
