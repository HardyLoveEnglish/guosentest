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

Date: 2015-08-13 22:29:54
*/


-- ----------------------------
-- Table structure for [dbo].[DeviceTypeInfo]
-- ----------------------------
DROP TABLE [dbo].[DeviceTypeInfo]
GO
CREATE TABLE [dbo].[DeviceTypeInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[Name] varchar(50) NOT NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[DeviceTypeInfo]', RESEED, 6)
GO

-- ----------------------------
-- Records of DeviceTypeInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[DeviceTypeInfo] ON
GO
INSERT INTO [dbo].[DeviceTypeInfo] ([Id], [Name]) VALUES (N'1', N'显示器');
GO
INSERT INTO [dbo].[DeviceTypeInfo] ([Id], [Name]) VALUES (N'2', N'电脑主机');
GO
INSERT INTO [dbo].[DeviceTypeInfo] ([Id], [Name]) VALUES (N'3', N'有线宽带');
GO
INSERT INTO [dbo].[DeviceTypeInfo] ([Id], [Name]) VALUES (N'4', N'无线网卡');
GO
INSERT INTO [dbo].[DeviceTypeInfo] ([Id], [Name]) VALUES (N'5', N'桌子');
GO
INSERT INTO [dbo].[DeviceTypeInfo] ([Id], [Name]) VALUES (N'6', N'其他');
GO
SET IDENTITY_INSERT [dbo].[DeviceTypeInfo] OFF
GO
