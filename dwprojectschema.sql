USE [master]
GO
/****** Object:  Database [DataWarehousingProject]    Script Date: 5/14/2024 8:26:57 PM ******/
CREATE DATABASE [DataWarehousingProject]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DataWarehousingProject', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DataWarehousingProject.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DataWarehousingProject_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DataWarehousingProject_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DataWarehousingProject] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DataWarehousingProject].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DataWarehousingProject] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET ARITHABORT OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DataWarehousingProject] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DataWarehousingProject] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DataWarehousingProject] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DataWarehousingProject] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DataWarehousingProject] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DataWarehousingProject] SET  MULTI_USER 
GO
ALTER DATABASE [DataWarehousingProject] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DataWarehousingProject] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DataWarehousingProject] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DataWarehousingProject] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DataWarehousingProject] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DataWarehousingProject] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [DataWarehousingProject] SET QUERY_STORE = ON
GO
ALTER DATABASE [DataWarehousingProject] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DataWarehousingProject]
GO
/****** Object:  User [testUser]    Script Date: 5/14/2024 8:26:57 PM ******/
CREATE USER [testUser] FOR LOGIN [testLogin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[AccountTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTable](
	[Account_Type] [nvarchar](50) NOT NULL,
	[Account_Number] [int] NOT NULL,
	[Open_Date] [date] NOT NULL,
	[Close_Date] [nvarchar](50) NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Balance] [int] NOT NULL,
	[Currency] [nvarchar](50) NOT NULL,
	[Last_Transaction_Date] [date] NOT NULL,
 CONSTRAINT [PK_AccountTable] PRIMARY KEY CLUSTERED 
(
	[Account_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountTypeTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTypeTable](
	[Account_Type] [nvarchar](50) NOT NULL,
	[Account_Type_Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_AccountTypeTable] PRIMARY KEY CLUSTERED 
(
	[Account_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BranchTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BranchTable](
	[Branch_ID] [int] NOT NULL,
	[Branch_Name] [nvarchar](50) NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[Manager_ID] [smallint] NOT NULL,
 CONSTRAINT [PK_BranchTable] PRIMARY KEY CLUSTERED 
(
	[Branch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CreditCardTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CreditCardTable](
	[Credit_Card_ID] [int] NOT NULL,
	[Expiry_Date] [date] NOT NULL,
	[Card_Limit] [int] NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Account_Number] [int] NOT NULL,
 CONSTRAINT [PK_CreditCardTable] PRIMARY KEY CLUSTERED 
(
	[Credit_Card_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerTable](
	[Customer_ID] [int] NOT NULL,
	[Customer_Type] [nvarchar](50) NOT NULL,
	[First_Name] [nvarchar](50) NOT NULL,
	[Last_Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Date_of_Birth] [date] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerTypeTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerTypeTable](
	[Customer_Type] [nvarchar](50) NOT NULL,
	[Customer_Type_Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CustomerTypeTable] PRIMARY KEY CLUSTERED 
(
	[Customer_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTable](
	[Employee_ID] [int] NOT NULL,
	[First_Name] [nvarchar](50) NOT NULL,
	[Last_Name] [nvarchar](50) NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
	[Salary] [money] NOT NULL,
	[Branch_ID] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeTable] PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanPaymentsTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanPaymentsTable](
	[Payment_Number] [int] NOT NULL,
	[Payment_Date] [date] NOT NULL,
	[Payment_Amount] [float] NOT NULL,
	[Loan_ID] [int] NOT NULL,
 CONSTRAINT [PK_LoanPaymentsTable] PRIMARY KEY CLUSTERED 
(
	[Payment_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanTable](
	[Loan_ID] [int] NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Loan_Type_ID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Interest_Rate] [nvarchar](50) NOT NULL,
	[Term_Years] [tinyint] NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Branch_ID] [int] NOT NULL,
 CONSTRAINT [PK_LoanTable] PRIMARY KEY CLUSTERED 
(
	[Loan_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanTypeTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanTypeTable](
	[Loan_Type_ID] [int] NOT NULL,
	[Loan_Type] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_LoanTypeTable] PRIMARY KEY CLUSTERED 
(
	[Loan_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransactionTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionTable](
	[Transaction_ID] [int] NOT NULL,
	[Account_Number] [int] NOT NULL,
	[Transaction_Type] [nvarchar](50) NOT NULL,
	[Amount] [float] NOT NULL,
	[Transaction_Date] [date] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Transaction_Time] [time](7) NOT NULL,
	[Transaction_Branch_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransactionTypeTable]    Script Date: 5/14/2024 8:26:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionTypeTable](
	[Transaction_Type_ID] [int] NOT NULL,
	[Transaction_Type] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Limit] [smallint] NOT NULL,
 CONSTRAINT [PK_TransactionTypeTable] PRIMARY KEY CLUSTERED 
(
	[Transaction_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [DataWarehousingProject] SET  READ_WRITE 
GO
