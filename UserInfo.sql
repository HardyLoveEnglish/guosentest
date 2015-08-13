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

Date: 2015-08-13 22:30:33
*/


-- ----------------------------
-- Table structure for [dbo].[UserInfo]
-- ----------------------------
DROP TABLE [dbo].[UserInfo]
GO
CREATE TABLE [dbo].[UserInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[UserID] varchar(10) NOT NULL ,
[UserName] varchar(20) NOT NULL ,
[LocationId] bigint NOT NULL 
)


GO

-- ----------------------------
-- Records of UserInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[UserInfo] ON
GO
SET IDENTITY_INSERT [dbo].[UserInfo] OFF
GO

-- ----------------------------
-- Indexes structure for table UserInfo
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table [dbo].[UserInfo]
-- ----------------------------
ALTER TABLE [dbo].[UserInfo] ADD PRIMARY KEY ([UserID])
GO
