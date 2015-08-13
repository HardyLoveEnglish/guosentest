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

Date: 2015-08-13 22:30:04
*/


-- ----------------------------
-- Table structure for [dbo].[LocationInfo]
-- ----------------------------
DROP TABLE [dbo].[LocationInfo]
GO
CREATE TABLE [dbo].[LocationInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[LocationTypeId] bigint NOT NULL ,
[Name] varchar(50) NOT NULL ,
[Address] varchar(500) NOT NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[LocationInfo]', RESEED, 4)
GO

-- ----------------------------
-- Records of LocationInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[LocationInfo] ON
GO
INSERT INTO [dbo].[LocationInfo] ([Id], [LocationTypeId], [Name], [Address]) VALUES (N'1', N'1', N'办公室', N'珠海市香洲区翠香路274号安平大厦4楼');
GO
INSERT INTO [dbo].[LocationInfo] ([Id], [LocationTypeId], [Name], [Address]) VALUES (N'2', N'1', N'', N'');
GO
INSERT INTO [dbo].[LocationInfo] ([Id], [LocationTypeId], [Name], [Address]) VALUES (N'3', N'1', N'', N'');
GO
INSERT INTO [dbo].[LocationInfo] ([Id], [LocationTypeId], [Name], [Address]) VALUES (N'4', N'1', N'财务部', N'珠海');
GO
SET IDENTITY_INSERT [dbo].[LocationInfo] OFF
GO
