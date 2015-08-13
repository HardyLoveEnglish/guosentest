/*
Navicat SQL Server Data Transfer

Source Server         : localhost
Source Server Version : 90000
Source Host           : localhost:1433
Source Database       : DevicesSystem
Source Schema         : dbo

Target Server Type    : SQL Server
Target Server Version : 90000
File Encoding         : 65001

Date: 2015-08-13 22:28:47
*/


-- ----------------------------
-- Table structure for [dbo].[BrandInfo]
-- ----------------------------
DROP TABLE [dbo].[BrandInfo]
GO
CREATE TABLE [dbo].[BrandInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[Name] varchar(50) NOT NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[BrandInfo]', RESEED, 7)
GO

-- ----------------------------
-- Records of BrandInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[BrandInfo] ON
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'1', N'联想');
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'2', N'戴尔');
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'3', N'惠普');
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'4', N'华为');
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'5', N'电信');
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'6', N'联通');
GO
INSERT INTO [dbo].[BrandInfo] ([Id], [Name]) VALUES (N'7', N'无');
GO
SET IDENTITY_INSERT [dbo].[BrandInfo] OFF
GO
