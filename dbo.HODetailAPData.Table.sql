USE [ExpenseReporting]
GO
/****** Object:  Table [dbo].[HODetailAPData]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HODetailAPData](
	[Company] [numeric](4, 0) NULL,
	[AcctUnit] [varchar](50) NULL,
	[Journal] [varchar](50) NULL,
	[Vendor] [varchar](50) NULL,
	[VendorName] [varchar](50) NULL,
	[InvoiceNum] [varchar](50) NULL,
	[PONum] [varchar](50) NULL,
	[Suffix] [numeric](3, 0) NULL,
	[InvoiceItemDesc] [varchar](50) NULL,
	[Acct] [varchar](50) NULL,
	[AcctDesc] [varchar](50) NULL,
	[Cost] [decimal](32, 2) NULL,
	[Retail] [decimal](32, 2) NULL,
	[InvoicePODate] [date] NULL,
	[CreateDate] [date] NULL,
	[PostDate] [date] NULL,
	[GLObjID] [numeric](12, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
