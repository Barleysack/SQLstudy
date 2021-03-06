USE [master]
GO
/****** Object:  Database [bookrentalshop21]    Script Date: 2021-05-08 오전 7:37:23 ******/
CREATE DATABASE [bookrentalshop21]
GO

USE [bookrentalshop21]
GO


/****** Object:  Table [dbo].[bookstbl]    Script Date: 2021-05-08 오전 7:37:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookstbl](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[Author] [nvarchar](50) NULL,
	[Division] [varchar](8) NOT NULL,
	[Names] [nvarchar](100) NULL,
	[ReleaseDate] [date] NULL,
	[ISBN] [varchar](200) NULL,
	[Price] [decimal](10, 0) NULL,
	[Descriptions] [nvarchar](max) NULL,
 CONSTRAINT [PK__bookstbl__C496003E2776CDED] PRIMARY KEY CLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[divtbl]    Script Date: 2021-05-08 오전 7:37:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[divtbl](
	[Division] [varchar](8) NOT NULL,
	[Names] [nvarchar](45) NULL,
 CONSTRAINT [PK__divtbl__566774CC3C70A6A2] PRIMARY KEY CLUSTERED 
(
	[Division] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[membertbl]    Script Date: 2021-05-08 오전 7:37:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[membertbl](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[Names] [nvarchar](50) NOT NULL,
	[Levels] [char](1) NULL,
	[Addr] [nvarchar](100) NULL,
	[Mobile] [varchar](13) NULL,
	[Email] [varchar](50) NULL,
	[userID] [varchar](20) NOT NULL,
	[passwords] [varchar](max) NOT NULL,
	[lastLoginDt] [datetime] NULL,
	[loginIpAddr] [varchar](30) NULL,
 CONSTRAINT [PK__membertbl__C496003E35C0672A] PRIMARY KEY CLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rentaltbl]    Script Date: 2021-05-08 오전 7:37:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rentaltbl](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[memberIdx] [int] NULL,
	[bookIdx] [int] NULL,
	[rentalDate] [date] NULL,
	[returnDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Idx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bookstbl]  WITH CHECK ADD  CONSTRAINT [FK__bookstbl__Divtbl__267ABA7A] FOREIGN KEY([Division])
REFERENCES [dbo].[divtbl] ([Division])
GO
ALTER TABLE [dbo].[bookstbl] CHECK CONSTRAINT [FK__bookstbl__Divtbl__267ABA7A]
GO
ALTER TABLE [dbo].[rentaltbl]  WITH CHECK ADD  CONSTRAINT [FK__rentaltbl__booktbl__2F10007B] FOREIGN KEY([bookIdx])
REFERENCES [dbo].[bookstbl] ([Idx])
GO
ALTER TABLE [dbo].[rentaltbl] CHECK CONSTRAINT [FK__rentaltbl__booktbl__2F10007B]
GO
ALTER TABLE [dbo].[rentaltbl]  WITH CHECK ADD  CONSTRAINT [FK__rentaltbl__membertbl__2E1BDC42] FOREIGN KEY([memberIdx])
REFERENCES [dbo].[membertbl] ([Idx])
GO
ALTER TABLE [dbo].[rentaltbl] CHECK CONSTRAINT [FK__rentaltbl__membertbl__2E1BDC42]
GO
USE [master]
GO
ALTER DATABASE [bookrentalshop21] SET  READ_WRITE 
GO
