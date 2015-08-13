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

Date: 2015-08-13 22:29:23
*/


-- ----------------------------
-- Table structure for [dbo].[DeviceInfo]
-- ----------------------------
DROP TABLE [dbo].[DeviceInfo]
GO
CREATE TABLE [dbo].[DeviceInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[WriteDateTime] datetime NOT NULL ,
[DeviceTypeId] bigint NOT NULL ,
[BrandId] bigint NOT NULL ,
[Model] varchar(50) NULL ,
[SeqNum] varchar(50) NULL ,
[ProductionDate] datetime NULL ,
[Quantity] bigint NULL ,
[MAC] varchar(50) NULL ,
[Memo] varchar(500) NULL ,
[IsVisible] bit NOT NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[DeviceInfo]', RESEED, 8)
GO

-- ----------------------------
-- Records of DeviceInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[DeviceInfo] ON
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'1', N'2015-03-23 08:57:15.000', N'1', N'1', N'', N'', N'2015-03-20 00:00:00.000', N'1', N'', N'', N'0');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'2', N'2015-03-23 08:57:29.000', N'1', N'1', N'', N'', N'2015-03-15 00:00:00.000', N'1', N'', N'', N'1');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'3', N'2015-03-31 17:44:48.000', N'2', N'2', N'', N'', N'2015-03-03 00:00:00.000', N'1', N'', N'', N'1');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'4', N'2015-03-31 17:45:14.000', N'3', N'5', N'', N'', N'2015-03-03 00:00:00.000', N'1', N'', N'', N'1');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'5', N'2015-03-31 17:45:30.000', N'5', N'1', N'', N'', N'2015-03-02 00:00:00.000', N'1', N'', N'', N'1');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'6', N'2015-03-31 18:25:08.000', N'1', N'1', N'', N'', N'2015-03-11 00:00:00.000', N'1', N'', N'', N'1');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'7', N'2015-03-31 18:25:37.000', N'1', N'1', N'', N'', N'2015-03-05 00:00:00.000', N'1', N'', N'', N'1');
GO
INSERT INTO [dbo].[DeviceInfo] ([Id], [WriteDateTime], [DeviceTypeId], [BrandId], [Model], [SeqNum], [ProductionDate], [Quantity], [MAC], [Memo], [IsVisible]) VALUES (N'8', N'2015-04-06 15:45:14.000', N'1', N'1', N'', N'', N'2015-04-16 00:00:00.000', N'1', N'', N'', N'0');
GO
SET IDENTITY_INSERT [dbo].[DeviceInfo] OFF
GO
