USE [ExpenseReporting]
GO
/****** Object:  Table [dbo].[HOHierarchy]    Script Date: 8/25/2016 10:19:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOHierarchy](
	[PKID] [float] NULL,
	[ParentOwner] [nvarchar](255) NULL,
	[Owner] [nvarchar](255) NULL,
	[BuilderOrder] [float] NULL
) ON [PRIMARY]

GO
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (1, N'Fitzgerald', N'Anyaegbunam', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (1, N'Fitzgerald', N'Stanny', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (1, N'Fitzgerald', N'Finance', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (2, N'Stanny', N'Arazny', 2)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (2, N'Stanny', N'Bressanelli', 2)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (2, N'Stanny', N'Tadder', 2)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (2, N'Stanny', N'Farrell', 2)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (2, N'Stanny', N'Hamilton', 2)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (3, N'Bressanelli', N'Koehler', 3)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (3, N'Bressanelli', N'Battaglia', 3)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Cameli', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Exec Admin', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Kurth', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Miller', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'open', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Schultz', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Tolly', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Trikha', 1)
INSERT [dbo].[HOHierarchy] ([PKID], [ParentOwner], [Owner], [BuilderOrder]) VALUES (4, N'Thompson', N'Vear', 1)
