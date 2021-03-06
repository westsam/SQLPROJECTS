USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[BulkLoadData]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BulkLoadData]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Truncate table dbo.HOHyperionData


	-- create temp table, then insert into mainhyperiondata from temptable
	Bulk Insert dbo.HOHyperionDATA
	From 'O:\Financial Systems\Hyperion\Downloads\HomeOffice\Whls&FVC.txt'
	WITH
	( 
	FORMATFILE = 'O:\Financial Systems\Hyperion\Downloads\HomeOffice\format.txt',
	ERRORFILE = 'O:\Financial Systems\Hyperion\Downloads\HomeOffice\myRubbishData.log'
	)

	--Bulk Insert Detail_AP_Data
	--From 'C:\ImportData\Expense Reporting\ExportData\APDataCorp.txt'
	--WITH
	--(
	--FIELDTERMINATOR = '^',
	--ROWTERMINATOR = '\n'
	--)

END

GO
