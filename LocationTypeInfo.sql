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

Date: 2015-08-13 22:30:20
*/


-- ----------------------------
-- Table structure for [dbo].[LocationTypeInfo]
-- ----------------------------
DROP TABLE [dbo].[LocationTypeInfo]
GO
CREATE TABLE [dbo].[LocationTypeInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[Name] varchar(50) NOT NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[LocationTypeInfo]', RESEED, 3)
GO

-- ----------------------------
-- Records of LocationTypeInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[LocationTypeInfo] ON
GO
INSERT INTO [dbo].[LocationTypeInfo] ([Id], [Name]) VALUES (N'1', N'场内部门');
GO
INSERT INTO [dbo].[LocationTypeInfo] ([Id], [Name]) VALUES (N'2', N'场外网点');
GO
INSERT INTO [dbo].[LocationTypeInfo] ([Id], [Name]) VALUES (N'3', N'在库库存');
GO
SET IDENTITY_INSERT [dbo].[LocationTypeInfo] OFF
GO
