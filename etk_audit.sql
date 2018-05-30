USE [master]
GO

/****** Object:  Database [ETLAudit]    Script Date: 5/30/2018 11:28:33 AM ******/
DROP DATABASE [ETLAudit]
GO

/****** Object:  Database [ETLAudit]    Script Date: 5/30/2018 11:28:33 AM ******/
CREATE DATABASE [ETLAudit]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ETLAudit', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\ETLAudit.mdf' , SIZE = 139264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ETLAudit_log', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data\ETLAudit_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

ALTER DATABASE [ETLAudit] SET COMPATIBILITY_LEVEL = 130
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ETLAudit].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [ETLAudit] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [ETLAudit] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [ETLAudit] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [ETLAudit] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [ETLAudit] SET ARITHABORT OFF 
GO

ALTER DATABASE [ETLAudit] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [ETLAudit] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [ETLAudit] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [ETLAudit] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [ETLAudit] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [ETLAudit] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [ETLAudit] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [ETLAudit] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [ETLAudit] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [ETLAudit] SET  ENABLE_BROKER 
GO

ALTER DATABASE [ETLAudit] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [ETLAudit] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [ETLAudit] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [ETLAudit] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [ETLAudit] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [ETLAudit] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [ETLAudit] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [ETLAudit] SET RECOVERY FULL 
GO

ALTER DATABASE [ETLAudit] SET  MULTI_USER 
GO

ALTER DATABASE [ETLAudit] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [ETLAudit] SET DB_CHAINING OFF 
GO

ALTER DATABASE [ETLAudit] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [ETLAudit] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [ETLAudit] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [ETLAudit] SET QUERY_STORE = OFF
GO

USE [ETLAudit]
GO

ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

ALTER DATABASE [ETLAudit] SET  READ_WRITE 
GO


