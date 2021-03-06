USE [ExpenseReporting]
GO
/****** Object:  Table [dbo].[HOAcctCollapse]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HOAcctCollapse](
	[CGroup] [varchar](50) NULL,
	[CAcct] [varchar](50) NULL,
	[LAcct] [varchar](50) NULL,
	[HAcct] [varchar](50) NULL,
	[Comment] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Meals', N'6780X', N'67800', N'67805', NULL)
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Travel Other', N'678XX', N'67835', N'67835', N'Travel - Mileage')
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Full Time Regular', N'5XXXX', N'50100', N'50100', N'Added by DR on 9/12/12')
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Full Time Regular', N'5XXXX', N'51400', N'51400', N'Added by DR on 9/12/12')
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Full Time Regular', N'5XXXX', N'52055', N'52055', N'Added by DR on 9/12/12')
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Full Time Regular', N'5XXXX', N'51100', N'51100', N'Added by DR on 9/12/12')
INSERT [dbo].[HOAcctCollapse] ([CGroup], [CAcct], [LAcct], [HAcct], [Comment]) VALUES (N'Travel Other', N'678XX', N'67840', N'67840', N'Travel - Other')
