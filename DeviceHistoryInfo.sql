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

Date: 2015-08-13 22:29:11
*/


-- ----------------------------
-- Table structure for [dbo].[DeviceHistoryInfo]
-- ----------------------------
DROP TABLE [dbo].[DeviceHistoryInfo]
GO
CREATE TABLE [dbo].[DeviceHistoryInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[DeviceId] bigint NOT NULL ,
[StartDateTime] datetime NOT NULL ,
[EndDateTime] datetime NOT NULL ,
[LocationId] bigint NOT NULL ,
[UserId] bigint NOT NULL ,
[Memo] varchar(500) NULL 
)


GO

-- ----------------------------
-- Records of DeviceHistoryInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[DeviceHistoryInfo] ON
GO
INSERT INTO [dbo].[DeviceHistoryInfo] ([Id], [DeviceId], [StartDateTime], [EndDateTime], [LocationId], [UserId], [Memo]) VALUES (N'1', N'555', N'2015-03-21 18:23:00.000', N'2015-03-22 18:23:00.000', N'666', N'777', N'');
GO
SET IDENTITY_INSERT [dbo].[DeviceHistoryInfo] OFF
GO
