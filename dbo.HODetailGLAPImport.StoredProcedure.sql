USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailGLAPImport]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailGLAPImport]
AS
BEGIN
		
	DELETE FROM Detail_GL_Data
	DELETE FROM Detail_AP_Data
	
	BULK 
	INSERT Detail_GL_Data
	FROM '\\Obxxhegw71552\ImportData\Expense Reporting\ExportData\GLData.txt'
	WITH
	(
	FIELDTERMINATOR = '^',
	ROWTERMINATOR = '\n'
	)
	
	BULK 
	INSERT Detail_GL_Data
	FROM '\\Obxxhegw71552\ImportData\Expense Reporting\ExportData\GLDataCorp.txt'
	WITH
	(
	FIELDTERMINATOR = '^',
	ROWTERMINATOR = '\n'
	)
	
	BULK 
	INSERT Detail_AP_Data
	FROM '\\Obxxhegw71552\ImportData\Expense Reporting\ExportData\APData.txt'
	WITH
	(
	FIELDTERMINATOR = '^',
	ROWTERMINATOR = '\n'
	)
	
	BULK 
	INSERT Detail_AP_Data
	FROM '\\Obxxhegw71552\ImportData\Expense Reporting\ExportData\APDataCorp.txt'
	WITH
	(
	FIELDTERMINATOR = '^',
	ROWTERMINATOR = '\n'
	)
END


GO
