USE [master]
GO
/****** Object:  Database [dbShop]    Script Date: 15.07.2022 22:10:57 ******/
CREATE DATABASE [dbShop]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbShop', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\dbShop.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbShop_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\dbShop_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [dbShop] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbShop].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dbShop] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dbShop] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dbShop] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dbShop] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dbShop] SET ARITHABORT OFF 
GO
ALTER DATABASE [dbShop] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [dbShop] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dbShop] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dbShop] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dbShop] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dbShop] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dbShop] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dbShop] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dbShop] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dbShop] SET  ENABLE_BROKER 
GO
ALTER DATABASE [dbShop] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dbShop] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dbShop] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dbShop] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dbShop] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dbShop] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dbShop] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dbShop] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [dbShop] SET  MULTI_USER 
GO
ALTER DATABASE [dbShop] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dbShop] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dbShop] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dbShop] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [dbShop] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [dbShop] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [dbShop] SET QUERY_STORE = OFF
GO
USE [dbShop]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_TotalOrder]    Script Date: 15.07.2022 22:10:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[FN_TotalOrder]()/*------------ Toplam Sipariş Sayısını Geriye döndüren bir Fonksiyon oluşturdum. Count fonksiyonu ile kayıt sayısını aldım.*/
Returns int
as
begin declare @total int
select @total=(select count(*) from Orders)
return @total
end
GO
/****** Object:  Table [dbo].[Users]    Script Date: 15.07.2022 22:10:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Kullanıcı bilgilerinin tutulduğu tablo */
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](35) NULL,
	[LastName] [varchar](20) NULL,
	[EMail] [varchar](50) NULL,
	[PhoneNumber] [varchar](15) NULL,
	[UserPassword] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 15.07.2022 22:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Sipariş bilgilerinin tutulduğu tablo */

CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderNumber] [int] NULL,
	[ProductId] [int] NULL,
	[Quantity] [int] NULL,
	[UserId] [int] NULL,
	[OrderDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Users_Never_Ordered]    Script Date: 15.07.2022 22:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Asla sipariş vermemiş kullanıcıların bulunduğu bir view oluşturdum. */
CREATE VIEW [dbo].[Users_Never_Ordered] AS
SELECT FirstName,LastName FROM Users where Id not in (select UserId from Orders) /* Not in keywordunden sonraki parantezde, Orders tablosundaki bütün kullanıcı Idlerini aldım; where koşulunda ise Users tablosundaki kullanıcı idlerinden parantezdeki sorguda gelen idlerin içinde olmayanları bulmasını istedim. Yani users tablosunda olup, orders tablosunda bulunmayan useridler geldi. Böylece sipariş vermemiş kullanıcıları bulmuş oldum. */
GO
/****** Object:  Table [dbo].[Product]    Script Date: 15.07.2022 22:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](  /*ürün tablosunu oluşturdum*/
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](50) NULL,
	[UnitPrice] [smallmoney] NULL,
	[CategoryId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetByCategoryId]    Script Date: 15.07.2022 22:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* parametre olarak verilen kategori idsine sahip ürünleri tablo olarak döndüren bir fonksiyon oluşturdum.*/ 
Create Function [dbo].[FN_GetByCategoryId](@CategoryId int)
Returns table
As
Return select * from Product where CategoryId=@CategoryId
GO
/****** Object:  Table [dbo].[Category]    Script Date: 15.07.2022 22:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category]( /*Kategori tablosunu oluşturdum) */
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders]  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[SP_GETORDERDETAILS]    Script Date: 15.07.2022 22:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Parametre olarak verilen orderId ile eşleşen siparişleri getiren bir procedure yazdım. */
create procedure [dbo].[SP_GETORDERDETAILS] @OrderId int
as
Select * from OrderDetail where OrderId=@OrderId
GO
USE [master]
GO
ALTER DATABASE [dbShop] SET  READ_WRITE 
GO
