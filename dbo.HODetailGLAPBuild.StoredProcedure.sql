USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HODetailGLAPBuild]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HODetailGLAPBuild]

AS
BEGIN

--******Step1 Exec Detail_GLAP_Import
--******Step2 Exec Detail_GLAP_Convert
UPDATE D
SET Acct = CR.RTLAcct, [AcctDesc] = CR.RTLDesc
FROM dbo.HODetailGLData D
	INNER JOIN Conversion_FromC_ToR CR on
		D.Acct = CR.CLAcct
		
--This changes the Corporate Lawson accounts to Retail Lawson accounts in the AP detail table
UPDATE D
SET Acct = CR.RTLAcct, [AcctDesc] = CR.RTLDesc
FROM dbo.HODetailAPData D
	INNER JOIN Conversion_FromC_ToR CR on
		D.Acct = CR.CLAcct

--******Step3 Exec Detail_GLAP_Suppress
DELETE D FROM
dbo.HODetailGLData D
INNER JOIN HOAcctSurpress S on S.Account = D.Acct

--This deletes the lines that should not be shown in the AP detail table
DELETE D FROM
dbo.HODetailAPData D
INNER JOIN HOAcctSurpress S on S.Account = D.Acct

--******Step4 Exec Detail_GLAP_UpdateDesc
UPDATE D
SET AcctDesc = G.Account_Desc
FROM dbo.HODetailGLData D
	INNER JOIN (SELECT CAST(Account as Varchar(50)) as Account, Account_Desc FROM RLAWPROD..LAWSON.GLCHARTDTL) G on
		G.Account = D.Acct

--Updates the retail account descriptions in the AP detail table
UPDATE D
SET AcctDesc = G.Account_Desc
FROM dbo.HODetailAPData D
	INNER JOIN (SELECT CAST(Account as Varchar(50)) as Account, Account_Desc FROM RLAWPROD..LAWSON.GLCHARTDTL) G on
		G.Account = D.Acct	

--******Step5 Exec Detail_GLAP_Rename
Update A
Set A.Acct = B.CAcct, A.AcctDesc = B.CGroup
From dbo.HODetailGLData A, HOAcctCollapse B
Where A.Acct between B.LAcct and B.HAcct

--This updates the account and description of the lines that need to be renamed in the AP Detail
Update A
Set A.Acct = B.CAcct, A.AcctDesc = B.CGroup
From dbo.HODetailAPData A, HOAcctCollapse B
Where A.Acct between B.LAcct and B.HAcct

--******Step6 Exec Detail_List_Build
DECLARE @Name as varchar(50), @Count as bigint, @NameTotal as int, @NameCount as int

--Clear distribution list
DELETE FROM HODetailDistribList

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
SELECT DISTINCT owner as Name FROM HOAcctUnitAssign

SET @NameTotal = @@ROWCOUNT
SET @NameCount = 1

WHILE @NameCount <= @NameTotal
	BEGIN
	
	SET @Name = (SELECT MAX(Name) FROM #NameList WHERE NameID = @NameCount)
	SET @Count = 1
	
		--First Pass, this sets up the summary groups
		INSERT INTO #DetailList
		SELECT DISTINCT A.Company, A.AcctUnit, A.Owner, @Name FROM HOAcctUnitAssign A
		INNER JOIN (SELECT Company, AcctUnit, Owner FROM HOAcctUnitAssign WHERE Owner = @Name) S on S.AcctUnit = A.Owner
		WHERE NOT EXISTS(SELECT * FROM #DetailList D WHERE D.Company = A.Company and D.AcctUnit = A.AcctUnit and D.Report = A.Owner)

		SET @Count = @Count + 1
	
		--Loop to get others
		While @Count <= 5
			BEGIN
						
				INSERT INTO #DetailList
				SELECT DISTINCT A.Company, A.AcctUnit, A.Owner, @Name FROM HOAcctUnitAssign A
				INNER JOIN (SELECT Company, AcctUnit, Report, Name FROM #DetailList) S on S.AcctUnit = A.Owner
				WHERE NOT EXISTS(SELECT * FROM #DetailList D WHERE D.Company = A.Company and D.AcctUnit = A.AcctUnit and 
				D.Report = A.Owner)
		
				----Insert Individual Cost Centers
				INSERT INTO #DetailList
				SELECT DISTINCT A.Company, A.AcctUnit, A.Owner, @Name FROM HOAcctUnitAssign A
				WHERE NOT EXISTS(SELECT * FROM #DetailList D WHERE D.Company = A.Company and D.AcctUnit = A.AcctUnit and D.Report = A.Owner) 
				and A.Owner = @Name and A.Company <> '9999'
					
				SET @Count = @Count + 1
			END
			
	----Delete Summary Groups
	DELETE FROM #DetailList WHERE Company = '9999'
		
	INSERT INTO HODetailDistribList 
	SELECT * FROM #DetailList
	
	DELETE FROM #DetailList		
	
	SET @NameCount = @NameCount + 1
	END

SELECT * FROM HODetailDistribList 

DROP TABLE #DetailList
DROP TABLE #NameList

--Check GL detail account conversion
SELECT * FROM dbo.HODetailGLData WHERE LEN(Acct) <> 5
 
--Check AP detail account conversion
SELECT * FROM dbo.HODetailAPData WHERE LEN(Acct) <> 5


END


GO
