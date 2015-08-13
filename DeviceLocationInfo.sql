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

Date: 2015-08-13 22:29:43
*/


-- ----------------------------
-- Table structure for [dbo].[DeviceLocationInfo]
-- ----------------------------
DROP TABLE [dbo].[DeviceLocationInfo]
GO
CREATE TABLE [dbo].[DeviceLocationInfo] (
[Id] bigint NOT NULL IDENTITY(1,1) ,
[WriteDateTime] datetime NOT NULL ,
[DeviceId] bigint NOT NULL ,
[LocationId] bigint NOT NULL ,
[UserId] bigint NOT NULL ,
[Memo] varchar(500) NULL 
)


GO

-- ----------------------------
-- Records of DeviceLocationInfo
-- ----------------------------
SET IDENTITY_INSERT [dbo].[DeviceLocationInfo] ON
GO
SET IDENTITY_INSERT [dbo].[DeviceLocationInfo] OFF
GO
