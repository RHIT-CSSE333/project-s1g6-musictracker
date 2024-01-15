/****** Object:  Table [dbo].[BillingInfo]    Script Date: 1/4/2024 11:35:11 AM ******/
CREATE TABLE [dbo].[BillingInfo](
	[BillingID] [int] IDENTITY(1,1) NOT NULL,
	[CCNum] [varchar](30) NOT NULL,
	[NameOnCard] [nvarchar](50) NOT NULL,
	[ExpirationDate] [date] NOT NULL,
	[CVV] [int] NOT NULL,
	[CustomerUsername] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_BillingInfo] PRIMARY KEY CLUSTERED 
(
	[BillingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComesWith]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComesWith](
	[PurchasedID] [int] NOT NULL,
	[AlsoProvidedID] [int] NOT NULL,
 CONSTRAINT [PK_ComesWith] PRIMARY KEY CLUSTERED 
(
	[PurchasedID] ASC,
	[AlsoProvidedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Username] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver](
	[Username] [nvarchar](20) NOT NULL,
	[LicenseNumber] [nvarchar](30) NULL,
 CONSTRAINT [PK_Driver] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodStyle]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodStyle](
	[StyleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_FoodStyle] PRIMARY KEY CLUSTERED 
(
	[StyleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Manager]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manager](
	[Username] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Manager] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuItem]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuItem](
	[MenuItemID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [text] NULL,
	[Price] [money] NOT NULL,
	[RestID] [int] NOT NULL,
 CONSTRAINT [PK_MenuItem] PRIMARY KEY CLUSTERED 
(
	[MenuItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[DriverUsername] [nvarchar](20) NOT NULL,
	[CustomerUsername] [nvarchar](20) NOT NULL,
	[MenuItemID] [int] NOT NULL,
	[OrderDateTime] [datetime] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[DriverUsername] ASC,
	[CustomerUsername] ASC,
	[MenuItemID] ASC,
	[OrderDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentInfo]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentInfo](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[RoutingNumber] [varchar](20) NOT NULL,
	[AccountNumber] [varchar](20) NOT NULL,
	[AccountType] [varchar](10) NOT NULL,
	[DriverUsername] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_PaymentInfo] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[Username] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](300) NOT NULL,
	[State] [char](2) NOT NULL,
	[ZipCode] [nchar](10) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restaurant]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurant](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](300) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State] [char](2) NOT NULL,
	[ZipCode] [nvarchar](20) NOT NULL,
	[ManagerUsername] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Restaurant] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestFoodStyle]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestFoodStyle](
	[RestID] [int] NOT NULL,
	[StyleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RestFoodStyle] PRIMARY KEY CLUSTERED 
(
	[RestID] ASC,
	[StyleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 1/4/2024 11:35:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[CustomerUsername] [nvarchar](20) NOT NULL,
	[RestID] [int] NOT NULL,
	[Stars] [int] NOT NULL,
	[Text] [text] NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[CustomerUsername] ASC,
	[RestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[BillingInfo]  WITH CHECK ADD  CONSTRAINT [FK_BillingInfo_Customer] FOREIGN KEY([CustomerUsername])
REFERENCES [dbo].[Customer] ([Username])
GO
ALTER TABLE [dbo].[BillingInfo] CHECK CONSTRAINT [FK_BillingInfo_Customer]
GO
ALTER TABLE [dbo].[ComesWith]  WITH CHECK ADD  CONSTRAINT [FK_ComesWith_MenuItem_Additional] FOREIGN KEY([AlsoProvidedID])
REFERENCES [dbo].[MenuItem] ([MenuItemID])
GO
ALTER TABLE [dbo].[ComesWith] CHECK CONSTRAINT [FK_ComesWith_MenuItem_Additional]
GO
ALTER TABLE [dbo].[ComesWith]  WITH CHECK ADD  CONSTRAINT [FK_ComesWith_MenuItem_Purchased] FOREIGN KEY([PurchasedID])
REFERENCES [dbo].[MenuItem] ([MenuItemID])
GO
ALTER TABLE [dbo].[ComesWith] CHECK CONSTRAINT [FK_ComesWith_MenuItem_Purchased]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Person] FOREIGN KEY([Username])
REFERENCES [dbo].[Person] ([Username])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Person]
GO
ALTER TABLE [dbo].[Driver]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Person] FOREIGN KEY([Username])
REFERENCES [dbo].[Person] ([Username])
GO
ALTER TABLE [dbo].[Driver] CHECK CONSTRAINT [FK_Driver_Person]
GO
ALTER TABLE [dbo].[Manager]  WITH CHECK ADD  CONSTRAINT [FK_Manager_Person] FOREIGN KEY([Username])
REFERENCES [dbo].[Person] ([Username])
GO
ALTER TABLE [dbo].[Manager] CHECK CONSTRAINT [FK_Manager_Person]
GO
ALTER TABLE [dbo].[MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_MenuItem_Restaurant] FOREIGN KEY([RestID])
REFERENCES [dbo].[Restaurant] ([ID])
GO
ALTER TABLE [dbo].[MenuItem] CHECK CONSTRAINT [FK_MenuItem_Restaurant]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customer] FOREIGN KEY([CustomerUsername])
REFERENCES [dbo].[Customer] ([Username])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customer]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Driver] FOREIGN KEY([DriverUsername])
REFERENCES [dbo].[Driver] ([Username])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Driver]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_MenuItem] FOREIGN KEY([MenuItemID])
REFERENCES [dbo].[MenuItem] ([MenuItemID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_MenuItem]
GO
ALTER TABLE [dbo].[PaymentInfo]  WITH CHECK ADD  CONSTRAINT [FK_PaymentInfo_Driver] FOREIGN KEY([DriverUsername])
REFERENCES [dbo].[Driver] ([Username])
GO
ALTER TABLE [dbo].[PaymentInfo] CHECK CONSTRAINT [FK_PaymentInfo_Driver]
GO
ALTER TABLE [dbo].[PaymentInfo]  WITH CHECK ADD  CONSTRAINT [FK_PaymentInfo_PaymentInfo] FOREIGN KEY([PaymentID])
REFERENCES [dbo].[PaymentInfo] ([PaymentID])
GO
ALTER TABLE [dbo].[PaymentInfo] CHECK CONSTRAINT [FK_PaymentInfo_PaymentInfo]
GO
ALTER TABLE [dbo].[RestFoodStyle]  WITH CHECK ADD  CONSTRAINT [FK_RestFoodStyle_FoodStyle] FOREIGN KEY([StyleName])
REFERENCES [dbo].[FoodStyle] ([StyleName])
GO
ALTER TABLE [dbo].[RestFoodStyle] CHECK CONSTRAINT [FK_RestFoodStyle_FoodStyle]
GO
ALTER TABLE [dbo].[RestFoodStyle]  WITH CHECK ADD  CONSTRAINT [FK_RestFoodStyle_Restaurant] FOREIGN KEY([RestID])
REFERENCES [dbo].[Restaurant] ([ID])
GO
ALTER TABLE [dbo].[RestFoodStyle] CHECK CONSTRAINT [FK_RestFoodStyle_Restaurant]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Customer] FOREIGN KEY([CustomerUsername])
REFERENCES [dbo].[Customer] ([Username])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Customer]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Restaurant] FOREIGN KEY([RestID])
REFERENCES [dbo].[Restaurant] ([ID])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Restaurant]
GO