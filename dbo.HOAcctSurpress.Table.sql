USE [ExpenseReporting]
GO
/****** Object:  Table [dbo].[HOAcctSurpress]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HOAcctSurpress](
	[Account] [varchar](50) NULL,
	[Comment] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'ACC_500000', N'Total Operating Expenses')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60100', N'Commission Expense')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60101', N'Commission Expense - Adjustments')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60125', N'Commission Exp - Deferred')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60150', N'Commission Exp - Interco')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60200', N'Real Estate Tax')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60250', N'Personal Property Tax')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60390', N'Contractual Donations')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60400', N'Convenant/Lease Rights')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60401', N'Covenant/Goodwill')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60500', N'Leasehold Improvements')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60560', N'Depreciation - Building')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60650', N'Depreciation Allocation')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60510', N'Depreciation - Equipment')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60520', N'Depreciation - Cash Registers')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60540', N'Depreciation - JDA/POS Equipment')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60545', N'Depreciation - Software')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'60550', N'Depreciation - Auto and Truck')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'ACC_791001', N'efollett allocation')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'ACC_709300', N'Gains & Losses')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'79500', N'Federal Income Tax')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'79510', N'City and State Income Tax')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'79520', N'Estimated Income Tax Expense')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'ACC_791000', N'Group Prorates')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'ACC_721500', N'Marketplace Commission')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'ACC_709100', N'Insurance')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'38401', N'Commissions - FHEG Whsle Rental')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'68700', N'G/L - Foreign Exchange')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'79110', N'Interest Income - Outside')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'79200', N'Interest Exp - Outside')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'79260', N'Interest Allocation')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'80500', N'Admin Expense')
INSERT [dbo].[HOAcctSurpress] ([Account], [Comment]) VALUES (N'80508', N'Admin Expense')
