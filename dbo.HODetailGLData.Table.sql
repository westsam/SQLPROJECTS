USE [ExpenseReporting]
GO
/****** Object:  Table [dbo].[HODetailGLData]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HODetailGLData](
	[Company] [numeric](4, 0) NULL,
	[AcctUnit] [varchar](50) NULL,
	[Journal] [varchar](50) NULL,
	[JournalDesc] [varchar](50) NULL,
	[Reversing] [char](1) NULL,
	[Acct] [varchar](50) NULL,
	[AcctDesc] [varchar](50) NULL,
	[Cost] [decimal](32, 2) NULL,
	[Retail] [decimal](32, 2) NULL,
	[PostDate] [date] NULL,
	[ObjID] [numeric](12, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
