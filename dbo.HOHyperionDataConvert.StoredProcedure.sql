USE [ExpenseReporting]
GO
/****** Object:  StoredProcedure [dbo].[HOHyperionDataConvert]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HOHyperionDataConvert]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Delete FROM HOHyperionData where Amount = ''

	UPDATE H
	SET Company = substring(LEFT(Entity,PATINDEX('%[_]%',Entity)-1),4,LEN(LEFT(Entity,PATINDEX('%[_]%',Entity)-1))), 
	AcctUnit = SUBSTRING(Entity, PATINDEX('%[_]%',Entity) +1, LEN(Entity)),AcctUnitDesc = EntityDesc
	FROM ExpenseReporting.dbo.HOHyperionData H

	--This changes the Hyperion accounts to Corporate Lawson accounts
	UPDATE H
	SET Account = HC.CLAcct
	FROM ExpenseReporting.dbo.HOHyperionData H
		INNER JOIN ExpenseReporting.dbo.TranslationHypeToCorp HC on
			H.Acct = HC.HAcct
		
	--This changes the Corporate Lawson accounts to Retail Lawson accounts
	UPDATE H
	SET Account = CR.RTLAcct, AccountDesc = CR.RTLDesc
	FROM ExpenseReporting.dbo.HOHyperionData H
		INNER JOIN ExpenseReporting.dbo.TranslationCorpToRetail CR on
			H.Account = CR.CLAcct

	UPDATE H
	SET FiscalYear = '20'+ right(ISNULL(FY,'NULL'),2),Period = case
	when Pd = 'Apr' then 1 
	when Pd = 'May' then 2
	when Pd = 'Jun' then 3
	when Pd = 'Jul' then 4
	when Pd = 'Aug' then 5
	when Pd = 'Sep' then 6
	when Pd = 'Oct' then 7
	when Pd = 'Nov' then 8
	when Pd = 'Dec' then 9
	when Pd = 'Jan' then 10
	when Pd = 'Feb' then 11
	when Pd = 'Mar' then 12
	else ''
	End
	FROM ExpenseReporting.dbo.HOHyperionData H

	--Delete Suppressed Accounts
	Delete h 
	From HOHyperionData h
	Inner Join HOAcctSurpress s on h.Account = s.Account

	--Delete zero accounts
	--Delete
	--From HOHyperionData
	--Where 
	--abs(MTDACT) +
	--abs(MTDBUD) +
	--abs(MTDLYA) +
	--abs(YTDACT) +
	--abs(YTDBUD) +
	--abs(YTDLYA) +
	--abs(FULBUD) +
	--abs(FULLYA) = 0

	--Check if any accounts didn't convert		
	SELECT * FROM HOHyperionData WHERE Len(Account) <> 5 Order By Acct


END

GO
