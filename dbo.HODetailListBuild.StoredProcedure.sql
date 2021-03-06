USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailListBuild]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailListBuild]
	
AS
BEGIN

DECLARE @Name as varchar(50), @Count as bigint, @NameTotal as int, @NameCount as int

--Clear distribution list
DELETE FROM Detail_Distrib_List

--Create temp tables
CREATE TABLE #DetailList
	(Company varchar(50), 
	AcctUnit varchar(50), 
	Report varchar(50),
	Name varchar(50))

CREATE TABLE #NameList
	(NameID int identity(1,1), 
	Name varchar(50))

--Insert all names 
INSERT INTO #NameList
SELECT DISTINCT Report as Name FROM Report_AcctUnit_Assign

SET @NameTotal = @@ROWCOUNT
SET @NameCount = 1

WHILE @NameCount <= @NameTotal
	BEGIN
	
	SET @Name = (SELECT MAX(Name) FROM #NameList WHERE NameID = @NameCount)
	SET @Count = 1
	
		--First Pass, this sets up the summary groups
		INSERT INTO #DetailList
		SELECT DISTINCT A.Company, A.AcctUnit, A.Report, @Name FROM Report_AcctUnit_Assign A
		INNER JOIN (SELECT Company, AcctUnit, Report FROM Report_AcctUnit_Assign WHERE Report = @Name) S on S.AcctUnit = A.Report
		WHERE NOT EXISTS(SELECT * FROM #DetailList D WHERE D.Company = A.Company and D.AcctUnit = A.AcctUnit and D.Report = A.Report)

		SET @Count = @Count + 1
	
		--Loop to get others
		While @Count <= 5
			BEGIN
						
				INSERT INTO #DetailList
				SELECT DISTINCT A.Company, A.AcctUnit, A.Report, @Name FROM Report_AcctUnit_Assign A
				INNER JOIN (SELECT Company, AcctUnit, Report, Name FROM #DetailList) S on S.AcctUnit = A.Report
				WHERE NOT EXISTS(SELECT * FROM #DetailList D WHERE D.Company = A.Company and D.AcctUnit = A.AcctUnit and 
				D.Report = A.Report)
		
				----Insert Individual Cost Centers
				INSERT INTO #DetailList
				SELECT DISTINCT A.Company, A.AcctUnit, A.Report, @Name FROM Report_AcctUnit_Assign A
				WHERE NOT EXISTS(SELECT * FROM #DetailList D WHERE D.Company = A.Company and D.AcctUnit = A.AcctUnit and D.Report = A.Report) 
				and A.Report = @Name and A.Company <> '9999'
					
				SET @Count = @Count + 1
			END
			
	----Delete Summary Groups
	DELETE FROM #DetailList WHERE Company = '9999'
		
	INSERT INTO Detail_Distrib_List 
	SELECT * FROM #DetailList
	
	DELETE FROM #DetailList		
	
	SET @NameCount = @NameCount + 1
	END

SELECT * FROM Detail_Distrib_List 

DROP TABLE #DetailList
DROP TABLE #NameList

END



GO
