{*******************************************************}
{                                                       }
{       Fleet Enterprise Sources                        }
{                                                       }
{    版权所有 (C) 2002, 2005 Dingli Communications Inc. }
{                                                       }
{*******************************************************}

{
    Pilot Fleet数据服务常量和数据定义单元，基本单元
   日期：2005-08-15
   作者：Kingron
   平台：Delphi 7

  本单元为Fleet的公共常量定义单元
  单元定义规则：
  常量全部以 C 开头
  整形常量以 CI 开头
  GUID以 CG 开头
  字符串以 CS 开头,用于需要经常作为参数传递的场合
  资源串以 CS 开头，使用Resource方式定义，用于错误信息，文本提示等

  本单元为Fleet的公共字段定义，常量定义，数据类型定义单元，定义所有需要
  使用的字段数据格式，为基础单元，本单元同时提供最基础的一些函数
  提供一些最基础的类库

  所有的数据内部时间均以UTC时间为准，坐标均以经纬度表示，
  时间在最终显示时均以本地时间显示，内部处理时采用UTC
}
{$I Compiler.inc}
unit DefinesUnit;
{* |<PRE>
================================================================================
* 软件名称：FleetTerminalService － DefinesUnit.pas
* 单元名称：DefinesUnit.pas
* 单元作者：Kingron <Kingron@dinglicom.com>
* 备    注：- 数据服务常量定义单元，公共数据结构定义单元
*           -
*           -
* 开发平台：Windows XP + Delphi 2006
* 兼容测试：Windows 2K/XP/2003, Delphi 7/2006
* 本 地 化：该单元中的字符串均符合本地化处理方式
--------------------------------------------------------------------------------
* 更新记de 录：-
*           - 2007-8-24 - Kingron: 增加RCU Telnet的Socket Flag
================================================================================
|</PRE>}

interface

uses SysUtils, Windows, Messages, Classes, uMyTools;

const
  MAX_CHANNEL = 12; /// RCU最多端口数
  CSCompanyName = 'Dingli Communications Inc.';
  CSSoftwareName = 'Pilot Fleet Enterprise';
  CSRegXPFireWall =
    'SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List';

  CIFleetVerMajor = $0004;
  CIFleet40VerMajor = $0004;
  CIFleetVerMinor = $0000;
  CIFleetVersion = (CIFleetVerMajor shl 16) or CIFleetVerMinor; /// $000040000;
  CSFleetVersion = '3.0.0.0'; /// 数据服务器版本
  CSFleet40Version = '4.0.0.0'; /// 数据服务器版本
  CSFleet40Version4111 = '4.1.1.1';
  CSFleet40CurVer  = CSFleet40Version4111;

  CIPilotGUID: TGUID = '{80CFF480-9EBC-11D2-BC0B-0000B497536D}';
  CSFleetIndexFileFlag = '{FB19426B-58AC-492E-A623-A3E5C9E3B583}';
  CSFleetDTGUID = '{0B63FF00-1F54-4E44-92C4-077E174DBEDF}';
  CSFleetIndexFileVersion = '1.0';
  CSFleetIndexFileDescription = 'Dingli Pilot Fleet Index File'; /// 最多31个字符

  CSPathDecagent = 'decagent.exe';
  CSDecagentGuid = '{2AE29AB8-2D19-4CC4-A6AA-9FA3F90F770D}';
  CSPathLog = 'Logs';
  CSPathRcu = 'Rcus';
  CSPathRcuLog = 'RcuLogs';
  CSPathPDA = 'PDAs';
  CSPathDT = 'DTs';
  CSPathDecode = 'Dats';
  CSExtTempFile = '.tmp'; /// 解压缩临时流文件
  CSExtInfoFile = '.tif'; /// 临时信息文件，在传输的时候存在，完成后被删除
  CSExtRcuFile = '.rcu'; /// 原始数据文件后缀名
  CSExtRcusFile = '.rcus'; ///RCUS文件格式
  CSExtMsgFile = '.msg'; /// 解压后数据文件后缀名
  CSExtLogFile = '.log'; /// 日志文件后缀
  CSExtDecode = '.ddd'; /// 解码后的数据后缀名
  CSRcuIndexFilename = 'rcu_index'; /// 默认RCU数据的索引名
  CSDTIndexFilename = 'dt_index'; /// 默认路测数据的索引名
  CSOnlineFileName = 'online'; /// 存储RCU在线数据的文件名,文件存储在Root目录下
  CSUnBackupListFileName = 'UnBackup';
  CSIniDecodeTempDir    = 'DecodeTemp';

  INVALID_TIME_VALUE = 0.0;
  CI_Max_GPS_VALUE = 500.0;
  CI_Min_GPS_VALUE = -500.0;
  INVALID_GPS_VALUE = 0.0;
  INVALID_FIELD_VALUE = 0;

  CSComDLLName = 'FleetBaseDataSvr.DLL';
  CSCmdSeperator = #13#10#13#10; /// 命令和数据分隔符，双回车换行
  CISocketPort = 9000; /// 默认Socket端口
  CI_ReadTimeout = 1000 * 30; /// Socket 默认读取超时，单位毫秒，默认30秒钟
  CI_MAX_Line = 1024; /// 默认命令处理器每一行命令最多字符数
  CI_MAX_SOCKET_LOG = 1024 * 1024; //Log类型的SOCKET发送数据缓冲区大小,1M
  CI_MAX_RCU_PACK = 65534; /// RCU 最大数据包长度
  CI_MAX_SIGNAL_LENGTH = 65534; /// 每条信令最大长度
  CI_Rcu_Idle_Timeout = 60; /// 默认RCU Idle超时，单位，秒
  CI_Data_Keep_Days = 0; /// 数据最长的保留时间，单位：天数，0表示永远保留
  CB_Data_Delete_File = False; /// 数据清除时是否保留物理文件，默认：保留
  CI_MAX_LOG_SIZE = 4096; /// 最大的LOG的文件大小，单位：KB
  CI_MAX_VOICE_PACK_SIZE = 1024 * 1024 * 10; /// 语音评估数据报最大大小
  CI_MAX_DT_PACK_SIZE = 65534 * 10; /// 路测数据报最大大小
  {$MESSAGE HINT '请在这里设置最大的数据点的大小，如果扩大,请修改此值,并设置为4的倍数以提高性能'}
  CI_MAX_POINT_SIZE = 1024 + 512 {712} {488};
  /// 每个记录数据点最大大小,请小心定义:如果不够最大记录长,则内存访问错误,如果太大,则会严重浪费内存!
  CI_MAX_BUFF_SIZE = 1024 * 20 * CI_MAX_POINT_SIZE;
  /// 内存池和缓冲区最大大小，10M 单位：Byte
  CI_MAX_MSG_LENGTH = 655350; /// 最大的Msg数据的长度，关系到缓冲区的大小
  CI_GAME_OVER = 3; /// 如果连续三个数据报无法正确解码，则跳过当前文件！
  CI_VOICE_TIME_LENGTH = 12;
  /// 录音文件的长度，默认12秒，该常量关系到上行语音评估分数的匹配
  CI_ALARM_INTERVAL = 10; /// 告警间隔，默认5分钟如果问题没有解决，重新告警

const
  /// Fleet Message 消息定义
  CSDecoderAgent = 'Fleet Decoder Agent';
  FM_Base = WM_USER + $209;
  FM_LOG = FM_BASE + 1;
  FM_DECODMSG = FM_BASE + 2; /// wParam: Port, lParam: Message Size
  FM_DATAOK = FM_BASE + 3; /// wParam: Port
  FM_ERROR = FM_BASE + 4; /// 错误！
  FM_INIT = FM_BASE + 6; /// 初始化通知，发送服务器句柄！ wParam: HWND;
  FM_InitDevice = FM_BASE + 7; //重新初始化设备解码库
  FW_StopCurrentTask = FM_BASE + 8; //停止当前任务
  FM_InitRcuList = FM_BASE + 9; //发送RCU GUID列表
  FM_DECODMSG_RE = FM_BASE + 10;

  // FleetTool, 数据刷新消息，WParam为PGUID消息，LPARAM为PortNo，PRCUID内存由消息处理者释放
  // WPARAM为需要刷新的RCU的GUID，PSTRING指针
  // LPARAM为对应的端口的数据
  CM_REFRESH_DATA = WM_USER + $100;

  CSTab = #9; /// 语音评估分数数据的分隔符
  CS_Comma = ';'; /// Log各个字段的分隔符
  CS_Seperator = '='; /// Value=Name的分隔符
  CS_Space = ' '; /// 默认命令的分隔符
  CSIPSerperator = ':'; /// IP地址和端口的分隔符
  CSFmtIdentString = '%s=%s';
  CSFmtIdentInteger = '%s=%d';
  CSFmtTerminalDevice = '%d';
  CSDevice = 'Device';
  CSSn = 'SN';
  CSCount = 'Count';

  /// 以下为命令参数常量
  CSEnd = 'End';
  CSTotalSize = 'TotalSize';
  CSSize = 'Size';
  CSCommand = 'Command';
  CSCommandSub = 'SubCmd';
  CSClient = 'Client';
  CSPhoneNum = 'PhoneNum';
  CSUserName = 'User Name';
  CSPassword = 'Password';
  CSUser = 'User';
  CSVersion = 'User'; /// 老版本协议定义未定义Version，使用User代替！
  CSVersion40 = 'Version';
  CSResponse = 'Response';
  CSRequest = 'Request';
  CSResult = 'Result';
  CSOK = 'OK';
  CSError = 'Error';
  CSWarn = 'Warnning';
  CSAlarm = 'Alarm';
  CSNone = '<N/A>';
  CSDeamon = 'Deamon';
  CSItem = 'Item';
  CSMessage = 'Message';
  CSFileName = 'FileName';
  CSFileSize = 'File Size';
  CSDataSize = 'Length';
  CSCompress = 'Compress';
  CSBeginTime = 'Begin Time';
  CSEndTime = 'End Time';
  CSTime = 'Time';
  CSLeft = 'long1';
  CSTop = 'lat1';
  CSRight = 'long2';
  CSBottom = 'lat2';
  CSMethod = 'Method';
  CSType = 'Type';
  CSCode = 'Code';
  CSDeleteFile = 'deletefile';
  CSRebuild = 'rebuild';
  CSRcuTestPlanVer = 'TestPlan_Ver';
  CSGroupname = 'GroupName';
  CSGroupInfo = 'GroupInfo';
  CSDeviceModel = 'DeviceInfo';
  CSContext = 'Context';
  CSPort = 'Port'; //Rcu的模块端口号标识，锁网络需要 2009-5-27,Tanding
  CSBand = 'Band';
  CSSubFolder = 'SubFolder';
  CSServerVer  = 'ServerVer';
  
  //Rcu的锁定网络标识，Band=0表示自动寻网，也就是解除锁定网络。Band=1表示锁定GSM;Band=2表示锁定WCDMA;锁网络需要 2009-5-27,Tanding
/// Voice交互命令常量
  CSReport = 'Report';
  CSEvent = 'Event';
  CSPesq = 'PESQ';
  CSOpen = 'Open';
  CSAction = 'Action';
  CSTerminateChar = #$1A;
  CSTransmit = 'Transmit';
  CSDisable = 'Disable';
  CSEnable = 'Enable';
  CSTerminateLine = #$1A#$0D#$0A;
  CSEndFlag = CSTerminateChar;
  CSRequestTime = 'Request Time';
  CSResponseTime = 'Response Time';
  CSPhoneNumber = 'Phone';

  /// Premier/Panorama命令参数常量
  CSPilotMajorVerion = 'Major Version';
  CSPilotMinorVersion = 'Minor Version';
  CSTerminalGUID = 'Terminal GUID';
  CSBegin = 'Begin';

  CSNavDownloadTotalSize = 'TotalSize';
  CSNavDownloadKeySize = 'KeySize';
  CSNavDownloadKeyCode = 'KeyCode';
  CSFileVersion = 'FileVersion';
  
  CSClientId = 'ClientID';

  /// PDA Login命令行参数常量
  CSPDADeviceInfo = 'DeviceInfo';
  /// 以下为Socket Flag
type
  TSocketFlag = (sfNull, /// 0,空Socket处理器
    sfDefault, /// 1， 默认处理， Ctrl + A
    sfRcu, /// 2， RCU Socket, Ctrl + B
    sfUpload, /// 3， 路测数据Socket, Ctrl + C
    sfStatistic, /// 4，统计服务器, Ctrl + D
    sfControl, /// 5，远程控制和维护Socket, Ctrl + E
    sfVoice, /// 6，语音评估Socket, Ctrl + F
    sfProject, /// 7, 工程Project, Ctrl + G
    sfDownload, /// 8, 分析模块下载数据, Ctrl + H
    sfLog, /// 9, Tab, Ctrl + I
    sfStatistic40, //10, 统计服务4.0版本
    sfMonitor, //11,监控服务
    sfDecodeData, //12,解码数据接口
    sfTelnetRcu, //13, Rcu Telnet接口   Ctrl + M
    sfTelnetClient, // 14, Telnet命令连接的接口 Ctrl + N
    sfPDA //15,Pda接口
    );
const
  CSSocketFlags: array[TSocketFlag] of string = (
    CSNone, 'Console', 'Rcu', 'Upload', 'Statistic v3', 'Control', 'Voice',
    'Project', 'Download', 'Log', 'Statistic v4', 'Monitor', 'DecodeData',
    'Telnet Rcu', 'Telnet Client', 'PDA Client');

resourcestring
  CIFE_SVR_DB_NOT_OPEN = 'Can not connect to database:%s:%d; %s,%s';

resourcestring
  CSServiceDescription =
    'Pilot Fleet database service, Project Provider, Logfile manager, Post processor, Rcu Manager.';

  CSAppTitle = 'Pilot Fleet Data Service';
  CSNeedConfigSystem = 'Warnning:'#13 +
    '    First run or config file missing.'#13 +
    '    Please config system first. Now loading default configration.';
  CSNeedRestartService = 'Need restart service, continue?';
  CSSelectDirectory =
    '  Please select store path, all data will save to this direcotry:';
  //CSDongleExpiredWarn = 'Dongle will be expired %d days';
  CSChangeSettings = 'Change settings';
  CSErrChangeSeetings = 'Do not support this version';
  CSHackInformation =
    'Stop hacking, your IP had been record.'#13#10' Alarming mail had sent to administrator.';

  /// 以下为普通的错误信息
  CSErrAccessDeined = 'Access deined, not enough rights';
  //CSErrMaxLicenseClient = '%d client(s) overflow license client count %d';
  CSErrLoadDLL = 'Error load project com library [%s]';
  CSErrInvalidIndexFile = 'Invalid index file: %s';
  CSErrReadData = 'Read error, expect: %d, actual: %d';
  CSErrWriteData = 'Write error, expect: %d, actual: %d';
  CSErrTempInfoSize = 'File size %d < Temp info size %d';
  CSErrReLoadData = 'Reload data for upload error';
  //CSErrDecodeMsg = 'Decode message error, %s: %s';
  CSErrDataFlag = 'Message Flag Error: 0x%x';
  //CSErrUnknowError = 'Unknow error %s: %s';
  CSErrLoadDecoderDll = 'Error load %s(%s), check DEVICE config';
  CSErrCreateDecoder = 'Start %s(%s) decoder error';
  CSErrCreateDecodeObject = 'Cant find [CreateDecodeObject] in library %s(%s)';
  CSErrPushData = 'Error during push data to statistic client, %s: %s';
  CSErrCreateRootPath = 'Cant''t create root path [%s]';
  CSErrAleadyLogin = 'Already login as [%s], please logout first!';
  CSErrCommand = 'Bad Request or command [%s]';
  CSErrNotLogon = 'Not logon, Please login first';
  CSErrSendMail = 'Send email error, %s: %s';
  CSErrUserNotExist = 'Error user name [%s]';
  CSErrPassword = 'Error password';
  CSErrSMTPLogin = 'SMTP Authorize error';
  CSLoginSucc = 'User [%s] login succ';
  CSLogoutSucc = 'User [%s] logout succ';
  CSErrProject = 'Project error';
  CSFileErrWriteData = 'File %s Write error, expect: %d, actual: %d';
  /// Socket Log 信息
  CSLogSockConnect = 'Socket Connect';
  CSLogSockDisConnect = 'Socket DisConnect';

  /// Fleet Logs 信息
  CSLogFleetLoadProgram = 'Program Loaded, CmdLine: %s';
  CSLogFleetExitProgram = 'Program Terminated';
  CSLogOpenXPFirewallSucc = 'Modify windows firewall success';
  CSLogOpenXPFirewallFail =
    'Modify windows firewall failure, please setting firewall manully';
  CSLogFleetListenSucc = 'Listen socket at %s:%d success';
  CSLogFleetErrStartService = 'Start service error';
  CSLogFleetErrStopService = 'Stop service error';
  CSLogFleetServiceStart = 'Service Started';
  CSLogFleetServiceStop = 'Service Stopped';
  CSLogFleetCreateSocket = 'Create socket handler: %s';
  CSLogFleetDestroySocket = 'Destroy socket handler: %s';
  CSLogFleetLoadProjectSucc = 'Load project %s success';
  CSLogFleetLoadProjectSucc40 = 'Load project from %s:%d/%s success ';
  CSLogFleetSaveProjectSucc = 'Save project %s success';
  CSLogFleetRunCommand = 'Run command: %s, %s';
  CSLogFleetBackup = 'Backup File(s)';
  CSLogFleetGPS = '%s, (%s, %s)';
  CSLogRcuLockBandResponse =
    'Rcu LockBand command Response: %s, Port:%s, LockBand:%s, %s';
  CSLogRcuUnLockBandResponse =
    'Rcu UnLockBand command Response: %s, Port:%s, %s';

  /// 命令交互常量，定义格式：CS + CatLog + Type + Name， Type = Err | Msg
  /// RCU命令交互信息
  CSRcuErrMaxPacket = 'Packet Size %d > MAX_RCU_PACK_SIZE %d';
  CSRcuErrNotLogin = 'Not login';
  CSRcuErrRcuID = 'Invalid RcuID format: %s';
  CSRcuErrRcuNotFound = 'RcuID check error: %s not found in project';
  CSRcuErrUploadFinished = 'Data %s already upload finished';
  CSRcuErrOpenFileFail = 'Open file %s for upload failure';
  CSRcuErrNotUpload = 'Transmitting only valid after UPLOAD command';
  CSRcuErrNotLOGUpload = 'Transmitting only valid after LOGUPLOAD command';
  CSRcuErrInvalidFileName = 'Invalid filename: %s';
  CSRcuErrNoTrans = 'Currently no data is transmitting';
  CSRcuErrSocketPack =
    'Packet should include CMD & ENTRY, and Seperator by <CR><CR>';
  CSRcuErrDataPackSize =
    'Data packet size error, Packet size: %d, Data size: %d';
  CSRcuErrCrcFail = 'Data CRC error, CRC: %d, Header CRC: %d';
  //CSRcuErrDataProcess = 'Data process error, File: %s, Position: %d, Pack size:%d';
  CSRcuErrDisconnectOldSocket = 'Error during disconnect old socket: %s';
  CSRcuErrTempInfo = 'Temp file %s dont match %s';
  CSRcuBindNewSocket = 'Rcu %s bind a new sock: %s, old socket: %s';
  CSRcuLoginSucc = 'Login Success';
  CSRcuLogoutSucc = 'Logout Success';
  CSRcuDisconnect = 'RCU Disconnect';
  CSRcuConnect = 'Rcu Connect';
  CSRcuSycnTimeSucc = 'Sync time success';
  CSRcuSetSucc = 'Rcu make config success';
  CSRcuSendConfig = 'Send RCU config, %s';
  CSRcuSetFail = 'Rcu make config failure, %s: %s';
  CSRcuUploadFile = 'Start upload log file: %s, Position: %d';
  CSRcuLogUploadFile = 'Start upload Rcu log file: %s, Position: %d';
  CSRcuUploadStopSucc = 'Stop upload %s success';
  CSRcuUploadStopFail = 'Stop upload %s failure';
  CSRcuUploadEndSucc = 'Rcu finish upload %s success';
  CSRcuUploadEndFail = 'Rcu finish upload %s failure';
  CSRcuAppendDataSucc = 'Recv %d B(s) success, CurPos: %d';
  CSRcuLogAppendDataSucc = 'RCU LOG Data Recv %d B(s) success, CurPos: %d';
  CSRcuWaitSucc = 'Keep PPP connection';
  CSRcuReportEvent = 'Event report';
  CSRcuForceDisconnFail = '%s, Force disconnect RCU %s error, %s: %s';
  CSRcuRestart = 'Restart rcu';
  CSRcuSkipFile = 'Skip file %s, trasmitting size: %d';
  CSRcuErrDomain = 'Rcu domain error';
  CSRcuLoginIpInfo = 'Rcu %s login: %s';
  CSRcuLogUploadEndSucc  = 'Rcu Log finish upload %s success';
  /// DT命令交互信息
  CSDTListSucc = 'Get data list success';
  CSDTGroupListSucc = 'Get group list success';
  CSDTGroupNotExist = 'The group not existed';
  CSDTGroupNameError = 'Group name can not be spatial';
  CSDTGroupExist = 'The group already existed';
  CSDTGroupCreateSucc = 'Create group success';
  CSDTUploadEndSucc = 'DT finish upload %s success';
  CSDTUploadEndFail = 'DT finish upload %s failure';
  CSDTErrDeviceInfo = 'Read information of device error';
  CSDTDisconnect = 'DT Disconnect';
  CSDTConnect = 'DT Connect';

  //PDA协议
  CSPdaErrMaxPacket = 'Packet Size %d > MAX_PDA_PACK_SIZE %d';
  CSPdaLoginSucc = 'PDA login success';
  CSPdaAppendDataSucc = 'Recv %d B(s) success, CurPos: %d';
  CSPdaDisconnect = 'PDA Disconnect';
  CSPdaConnect = 'PDA Connect';
  CSPdaUploadEndSucc = 'PDA finish upload %s success';
  CSPdaUploadEndFail = 'PDA finish upload %s failure';
  CSPdaForceDisconnFail = '%s, Force disconnect PDA %s error, %s: %s';
  CSPdaBindNewSocket = 'PDA %s bind a new sock: %s, old socket: %s';

  /// Statistic命令交互信息
  CSStsStartRefreshProject = 'Send Rcu information...';
  CSStsRefreshProjectSucc = 'Send Rcu Information success';

  /// Voice命令交互信息，LOG信息
  CSVoiceUnkownRequest = 'Unknow voice request: %s';
  CSVoiceRequestCmd = 'Request command: %s';
  CSVoiceResponseCmd = 'Response command: %s';

  /// 工程交互命令
  CSPrjSendProject = 'Get project data success';
  CSPrjCommitSucc = 'Commit project success';
  CSPrjCommitFail = 'Commit project failure, Read Data error or License limit';

  /// 控制命令
  CSCtlRcuList = 'Get rcu list';
  CSCtlRcu = 'Get rcu info';
  CSCtlDataList = 'Get data list';
  CSCtlGetConfig = 'Get configuration';
  CSCtlSysInfo = 'Get system information';
  CSCtlSocketList = 'Get socket list';
  CSCtlRcuDisconnect = 'Execute Rcu disconnect command';
  CSCtlRcuSet = 'Execute Rcu set command ';
  CSCtlRcuReboot = 'Execute RCU reboot command';
  CSCtlRcuSkipFile = 'Execute RCU Skip file command';
  CSCtlRcuTelnet = 'Remote telnet RCU command';
  CSCtlRcuLockBand = 'RCU LockBand command';
  CSCtlResetCounter = 'Reset RCU counter';
  CSCtlDataClear = 'Data clear success';
  CSCtlDataDelete = 'Data delete success';
  CSCtlDataRebuild = 'Data rebuild';
  CSCtlKill = 'Kill Process';
  CSCtlExit = 'Exit Program';
  CSCtlRestart = 'Restart service';
  CSCtlReboot = 'Reboot computer';
  CSCtlDisconnect = 'Disconnect clients';

  /// Pilot 命令交互Log
  CSPilotVer = 'Pilot client connected. Client Verion: ';
  CSPilotSentFileSucc = 'Pilot client send file success';
  CSPilotNoClientID = 'Pilot client logon error, unknown client ID';
  CSPilotDownloadStart = 'Pilot download start, Rcu: %s';
  CSPilotDownloadEnd = 'Pilot download end, Rcu: %s';

type
  /// 终端设备状态信息
  TTerminalStatus = (tsNull, tsIdle, tsOffline, tsEof, tsSkip,
    tsLogin, tsLogout, tsSync, tsConfig, tsUpload,
    tsTrans, tsStop, tsCmd, tsKeep, tsAlarm, tsGPS, tsReport);
const
  CSTerminalStatus: array[TTerminalStatus] of string = (
    '<N/A>', 'Idle', '-', 'Finished', 'Skip',
    'Login', 'Logout', 'Sync Time', 'Config', 'Upload',
    'Uploading', 'Stop', 'Cmd', 'Keep', 'Alarm', 'GPS', 'Report'
    );

  //type
  //  /// 网络类型
  //  TNetType = (ntNull, ntGSM, ntCDMA, ntUMTS);
  //  TNetTypes = set of TNetType;
  //const
  //  CSNetTypeNames : array[TNetType] of string = (CSNone, 'GSM', 'CDMA', 'UMTS');

type
  //告警来源
  TAlarmSource = (
    asNone, //未分类告警
    asRCU, //RCU
    asDataSvr, //数据服务
    asStatSvr, //统计服务
    asVoiceSvr, //语音服务；
    asWebSvr, //Web服务
    asAutoStatSvr, //自动统计
    asBgSvr, //后台工具
    asPda
    );

  //告警处理方式：
  TAlarmProcess = (
    apNone, //无处理
    apLog, //记录，不做其他处理
    apEmail, //记录，发送邮件
    apSms, //记录，发送短信
    apCustom, //记录，等待用户处理
    apOther //记录，声音，显示等方式告警
    );

  //告警的数据库配置结构
  PAlarmConfig = ^TAlarmConfig;
  TAlarmConfig = packed record
    Code: Integer; //告警代码
    Source: TAlarmSource; //告警产生的来源。
    ProcessType: TAlarmProcess; //告警处理方式
    FilterFlag: Integer;
    //对于短时间内重复的告警的过滤（两种方式：值1表示按次数，值2表示按时间）
    FilterValue: Integer;
    //当FilterFlag为1时，本字段表示发生多少次重复告警才进行处理。
  //当FilterFlag为2时，表示间隔上一次相同告警的时间超过本字段的值才进行处理(单位：秒)。
    Contact: WideString; //联系人
    Id: Integer; //此告警记录唯一标识
  end;

  //Event的数据库配置结构
  PEventConfig = ^TEventConfig;
  TEventConfig = packed record
    EventType: DWORD;
    ProcessType: TAlarmProcess;
    FilterFlag: Integer;
    FilterValue: Integer;
    Contact: string;
    Id: Integer;
  end;

type
  /// 定义共享内存块数据结构，用于参数传递！
  PShareMemData = ^TShareMemData;
  TShareMemData = packed record
    DataType: Char; /// 数据类型：D,E,V,F,P,...
    Time: TDateTime;
    Count: Integer;
    PointSize: Integer;
    Port: Integer;
    Model: array[0..49] of Char; //此数据包应用的端口设备
  end;

  // 对应某个RCU解码过程的内存映射记录
  PShareMemoryMap = ^TShareMemoryMap;
  TShareMemoryMap = record
    InMapHandle: THandle; // 原始数据共享内存快，为 Server --> Agent
    InMapShareRecord: PShareMemData;
    InMapShare: PChar;

    OutMapHandle: THandle; // 解码后的数据共享内存快， 为 Agent --> Server
    OutMapShareRecord: PShareMemData;
    OutMapShare: PChar;
    WindowHWD: Cardinal;
  end;

  TGeographyParam = packed record
    case Integer of
      0: (LongAxis, ShortAxis, FalseEasting, FalseNorthing,
        CentralMeridian, Scale: Single);
      1: (Values: array[0..5] of Single);
  end;

  PAlarmData = ^TAlarmData; /// 实时的告警信息
  {$IFDEF _ShanXiMobile}
  TAlarmData = packed record
    Port: Byte;
    Time: Integer;
    Major: DWORD;
    Minor:DWORD; //实际的值是LAC
    CellID:DWORD;
    Reverved1,Reverved2:Dword;
  end;
  {$ELSE}
  TAlarmData = packed record
    Port: Byte;
    Time: Integer;
    Major: DWORD;
    Minor: DWORD;
  end;
  {$ENDIF}
  
  PGPSData = ^TGPSData; /// 实时的GPS信息
  TGPSData = packed record
    Time: Integer;
    X: Single;
    Y: Single;
  end;

  PRTEvent = ^TRTEvent;
  TRTEvent = packed record /// 实时 Event 信息
    Port: Byte;
    Time: Integer;
    Data: Pointer;
  end;

  TLogType = (ltNull, ltInfo, ltSucc, ltWarn, ltError, ltDebug);
  TDefaultCmd = (dcNull, dcHelp, dcLogin, dcLogout, dcClose, dcExit, dcKill,
    dcRun, dcList, dcCmd);
  TVoiceCmd = (vcNull, vcSyncTime, vcPESQ, vcTransmit, vcAlarm, vcEvent,
    vcConfigChanged, vcGetTestPlan, vcPushTestPlan);
  TProjectCmd = (pcNull, pcLogin, pcLogout, pcGet, pcSet, pcGet2);
  /// RCU上行命令，从RCU发送给服务器
  TRcuCmd = (rcNull, rcLogin, rcLogout, rcSyncTime, rcSet, rcUpload, rcStop,
    rcEof, rcWait, rcAlarm, rcGPS, rcEvent, rcReboot, rcTelnet, rcLockBand,rcRcuLogUpload,rcRcuLogEof,rcRcuLogData);
  //TServerCmd = (scNull, scReboot, scDisconnect, scSet, scStop);  /// RCU下行命令，从服务器发送给RCU
  TUploadCmd = (ucNull, ucLogin, ucLogout, ucList, ucGet, ucRcuList, ucRcuGet);
  /// 兼容Premier/Panorama的命令！！！
  TDownloadCmd = (dlcNull, dlcVersion, dlcLogin, dlcLogin2, dlcLogout, dlcList,
    dlcGet, dlcPut, dlcAbort, dlcRcuList, dlcRcuGet);
  TControlCmd = (ccNull, ccLogin, ccLogout, ccRcuList, ccRcuReset,
    ccRcuDisconnect, ccRcuSet, ccRcuSkip, ccRcuResetCounter, ccRcuTelnet,
    ccSockList, ccSockDis, ccSysInfo, ccConfigGet, ccConfigSet,
    ccDataList, ccDataClear, ccDataDelete, ccDataRebuild, ccDataDateDel,
    ccDataInvalidDel,
    ccKill, ccRestart, ccReboot, ccExit, ccDataGetMsg, ccDataGetGsg2,
    ccWebGetRcuInfo, ccWebGetAllRcuInfo, ccWebRcuDisconnect,
    ccWebRcuReset, ccWebRcuSkip, ccWebDataRebuild, ccRcuGetConfig,
    ccDownloadFile, ccWebDownloadFile, ccControlChat, ccRcuLockBand);
  TStatisticCmd = (scNull, scLogin, scLogout, scStatistic);
  TDecodeUpCmd = (ducNull, ducLogin, ducAlarm, ducActive, ducRedecode,
    ducDTDecodeDataContinue, ducDTDecodeDataReload);
  //增加DT解码命令,20080828,tanding
  TDecodeDownCmd = (ddcNull, ddcRcuInfoUpdate);
  //rcu配置版本
  TRcuConfigVersion = (rcv10, rcv20, rcv21, rcv40, rcv41);
  //pda版本
  TPdaVersion = (pv10);
  //PDA命令
  TPdaCmd = (pdaNull, pdaLogin, pdaLogout, pdaUpload, pdaStop, pdaEof);
  //控制协议中的下载文件命令类型
  TDownfileType = (dftNull, dftDecodeFile, dftDT, dftPDA,dftRcuLog);
  //路测交互
  TDTCmd = (dtcNull, dtcLogin, dtcGroupList, dtcDataList, dtcCreateGroup,
    dtcUploadData, dtcEof);
const
  CSRcuCmdData = 'Data'; /// RCU传输的数据
  CSRcuCmdTelnet = 'telnet'; /// Telnet 请求
  CSRcuCmdLockBand = 'lockband';
  //LockBand锁网络命令，目前仅针对5210umts模块，锁gsm和wcdma网络 2009-5-27,Tanding
  CSLogTypes: array[TLogType] of string = ('<N/A>', 'Info', 'Succ', 'Warn',
    'Error', 'Debug');
  CSVoiceCmds: array[TVoiceCmd] of string = ('', 'Sync Time', 'PESQ',
    'Transmit',
    'Alarming', 'Event', 'ConfigChanged', 'GetTestPlan', 'PushTestPlan');
  CSProjectCmds: array[TProjectCmd] of string = ('', 'login', 'logout', 'get',
    'set', 'get2');
  CSRcuCmds: array[TRcuCmd] of string = ('', 'login', 'logout', 'sync Time',
    'set', 'upload', 'upload stop', 'eof', 'wait', 'alarm', 'gps', 'event',
    'reset', 'telnet', 'lockband','LogUpload','LogEof','LogData');
  //CSServerCmds: array[TServerCmd] of string =('', 'Reboot', 'Disconnect', 'Set', 'Stop') ;
  CSDefaultCmds: array[TDefaultCmd] of string = ('', '?', 'login', 'logout',
    'close', 'exit', 'kill', 'run', 'list', 'cmd');
  CSUploadCmds: array[TUploadCmd] of string = ('', 'login', 'logout', 'list',
    'get', 'rcu_list', 'rcu_get');
  CSDownloadCmds: array[TDownloadCmd] of string = ('', 'version', 'login',
    'login2', 'logout', 'list', 'get', 'put', 'abort', 'rcu_list', 'rcu_get');
  CSControlCmds: array[TControlCmd] of string = (
    '', 'login', 'logout', 'rcu_list', 'rcu_reset', 'rcu_disconnect', 'rcu_set',
    'rcu_skip', 'reset_counter', 'rcu_telnet',
    'sock_list', 'sock_discon', 'sysinfo', 'config_get', 'config_set',
    'data_list', 'data_clear', 'data_delete', 'data_rebuild', 'data_datedel',
    'data_invaliddel',
    'kill', 'restart', 'reboot', 'exit', 'data_getmsg', 'data_getmsg2',
    'web_rcu', 'web_rculist',
    'web_rcu_disconnect', 'web_rcu_reset', 'web_rcu_skip', 'web_DataRebuild',
    'Rcu_GetConfig',
    'data_downloadfile', 'web_data_downloadfile', 'control_chat',
    'rcu_lockband');
  CSStatisticCmds: array[TStatisticCmd] of string = ('', 'login', 'logout',
    'statistic');
  CSDecodeUpCmds: array[TDecodeUpCmd] of string = ('', 'LOGIN', 'ALARM',
    'ACTIVE', 'DecodeRequest', 'DTDecodeDataContinue', 'DTDecodeDataReload');
  //增加DT解码命令,20080828,tanding
  CSDecodeDownCmds: array[TDecodeDownCmd] of string = ('', 'rcuinfoupdate');
  CSPdaCmds: array[TPdaCmd] of string = ('', 'Login', 'Logout', 'Upload',
    'Stopupload', 'Eof');
  CSDownloadType: array[TDownfileType] of string = ('', 'decode', 'dt', 'pda','rculog');
  CSDTCmds: array[TDTCmd] of string = ('', 'login', 'GetGroupList',
    'GetDataList', 'CreateGroup', 'Upload', 'Eof');
type
  PVoiceMessage = ^TVoiceMessage;
  TVoiceMessage = packed record /// 存储在Msg文件中Voice数据
    Leng: TDateTime;
    Link: Char;
    Score: Single;
    LQ: Single;
  end;

  TVoiceData = packed record /// 上行语音评估数据
    StartTime: TDateTime; /// 录音开始时间
    EndEndTime: TDateTime; /// 录音结束时间
    Score: Double; /// 分数
    LQ: Double; /// LQ分数
    Port: Integer;
  end;
  PVoiceData = ^TVoiceData;

  TRcuFileHeader = packed record /// .Rcu文件头信息，主要为Rcu ID和模块信息
    RcuID: array[0..37] of char;
    Devices: array[0..MAX_CHANNEL - 1, 0..31] of char;
  end;

  TDeviceInfo = TRcuFileHeader;
  TDataInfo = record //数据 头,总长1K
    FileVersion:DWORD;/// 文件版本号,格式: 高位:主版本,地位低版本,例如:$00040000,表示4.0
    KeySize: DWORD;
    Key: array[0..1015] of Char;
  end;
//新RCUS文件的文件头
  TRcusFileHeader = packed record
    DeviceInfo:TDeviceInfo;
    DataInfo:TDataInfo;//数据信息 加密的相关信息
  end;

  TChannelInfo = packed record /// MSG文件端口信息
    Provider: array[0..31] of char; /// 运营商
    Model: array[0..15] of char;
    DeviceType: Byte; /// 设备类型
    NetType: Byte; /// 网络类型，GSM | CDMA |UMTS
    Reserved: Word; /// 保留，4字节对齐用
  end;

  TGPSRange = packed record ///GPS坐标范围记录
    MinLongitude, MinLatitude, MaxLongitude, MaxLatitude: Double;
  end;

  PMsgFileHeader = ^TMsgFileHeader;
  TMsgFileHeader = packed record /// .Msg文件头信息， 共512Byte！
    FileID: TGUID; /// 文件ID
    FileVer: DWORD;
    /// 文件版本号，格式： 高位：主版本，地位低版本，例如：$00040000，表示4.0

    DeviceID: array[0..39] of Char;
    /// RCU ID或者用户名字，用于在索引中分类别或管理数据;

  /// 以下是地理参数信息
    LongAxis, ShortAxis, FalseEasting, FalseNorthing, CentralMeridian, Scale:
    Double;

    /// 以下是文件的相关信息
    BeginTime, EndTime: TDateTime; /// 数据的时间范围
    GPSRange: TGPSRange; /// 数据坐标范围
    DataCount: Integer; /// 数据信息条数
    RcuPos: Integer; /// 最后传输的RCU文件的位置
    Size: Integer; /// Message文件大小，主要用于保护文件映射错误时的保护

    ChannelNum: Integer; /// 端口个数
    ChannelInfos: array[0..MAX_CHANNEL - 1] of TChannelInfo;
    /// 设备信息，包括设备ID和设备各个端口信息
    Hotspot: Boolean; //热点标识
    case Boolean of
      False: (KeySize: DWORD; Key: array [0..222] of Char);
      True: (Reserved: array[0..226] of char); /// 1K Pending
  end;
  //端口设备
  TDevicePortInfo = record
    PortNo: Integer; //	端口号
    DeviceType: SHORT; //	端口设备类型：0=Modem，1=GPS，2=Handset，3=Reciever
    Provider: array[0..31] of char; //	运营商
    NetType: Byte; //	网络类型：0=GSM，1=CDMA
    Model: array[0..15] of char;
    //	设备模块，例如：NMEA0183，MOTO，QualcommMS，G18
  end;
  //数据头
  TMsgDataHeader = record
    DeviceID: TGUID;
    BeginTime: TDateTime;
    MinorVersion: TDateTime;
    GeographyParam: TGeographyParam;
    Count: Integer; //端口个数
    DevicePortInfos: array of TDevicePortInfo;
  end;
  //Msg数据点
  PMsgDataPoint = ^TMsgDataPoint;
  TMsgDataPoint = record
    Flag: Char;
    Port: Byte;
    Time: TDateTime;
    Size: SmallInt;
    DataValue: string;
  end;
  /// RCU传送数据时数据包的包头，非压缩信息，包含Len和CRC16的值
  PTerminalPacketHead = ^TTerminalPacketHead;
  TTerminalPacketHead = packed record
    Size: Word; /// 数据大小
    Code: Word; /// 数据的CRC16的值
  end;

  /// 每一条信令的头
  PTerminalMessageHead = ^TTerminalMessageHead;
  TTerminalMessageHead = packed record
    Flag: Char; /// 数据类型
    Port: Byte; /// 端口号
    Length: Word; /// 信令长度
    case Boolean of /// 信令的时间,为Unix格式的时间戳!
      False: (Seconds: Cardinal; uSeconds: Cardinal);
      True: (Value: Int64);
  end;

  ///*.RCU解压后为*.MSG文件，*.RCU文件包括头信息和DataPacket数据包，数据包包含Size,crc,CompressedData（压缩数据）
  ///CompressedData（压缩数据）解压后为*.MSG文件内的数据包，格式为Flag,Port,Length,Seconds,uSeconds,SampleData(具体数据，长度为Length),具体定义见《RCU文件结构.doc》
  ///TDeviceMessageHead为*.MSG数据的数据包头信息。20080908,tanding
  PDeviceMessageHead = ^TDeviceMessageHead;
  TDeviceMessageHead = packed record
    Flag: Char;
    Port: Byte;
    Time: TDateTime;
    Size: Word;
  end;
  {* 新增一个记录,包括RCU的设备信息和RCU上传数据中的标志值 *}
  TDeviceNewMessageHead = packed record
    FDeviceMsgHead: TDeviceMessageHead;
    FFlagStr: array [0..3] of Char;//用于存储RCU数据中的标志值$DIV占用四个字节
  end;
  PDeviceNewMsgHead = ^TDeviceNewMessageHead;

  PPESQ_Data = ^TPESQ_Data;
  TPESQ_Data = packed record
    PESQ_End_Time: Cardinal;
    PESQ_score: Single;
    Symmetric_disturbance: Single;
    Asymmetric_disturbance: Single;
    PESQ_LQ_score: Single;
    Number_of_samples_in_reference: Single;
    Speech_activity_in_reference: Single;
    Number_of_samples_in_degraded: Single;
    Speech_activity_in_degraded: Single;
    Active_speech_level_of_reference_signal: Single;
    Mean_noise_level_of_reference_signal: Single;
    RMS_mean_level_of_whole_reference_signal: Single;
    Active_speech_level_of_degraded_signal: Single;
    Mean_noise_level_of_degraded_signal: Single;
    RMS_mean_level_of_whole_degraded_signal: Single;
    Insertion_gain: Single;
    Noise_gain: Single;
    Flag: Char;
  end;
  PDataMessage = ^TDataMessage; 
  TDataMessage = record
    Link: Char;
    mSeconds: Integer;
    TotalBytes: Integer;
    mInterval: Integer;
    Bytes: Integer;
  end;
  PFTPMessage = ^TFTPMessage; /// FTP数据
  TFTPMessage = record
    Link: Char;
    mSeconds: Integer;
    TotalBytes: Integer;
    mInterval: Integer;
    Bytes: Integer;
  end;

  PPingMessage = ^TPingMessage; /// Ping数据
  TPingMessage = record
    PingIP: Cardinal;
    PacketSize: Integer;
    TimeOut: LongBool;
    TTL: Integer;
    Delay: Integer;
  end;

  //VMOS Video Telephony和Video Stream的MOS 2009-5-27,Tanding
  PVMOSMessage = ^TVMOSMessage;
  TVMOSMessage = record
    TestType: Integer; //1表示telephony，0表示stream
    Score: Integer; //Scale 1000 2009-5-27,Tanding
  end;

  /// 解码设备数据，内存需要手动申请和释放Data
  TDecodeDataHeader = packed record /// 解码数据头信息
    Version: Word; /// 版本信息
    Terminal: TGUID; /// RCU ID
    Port: Word; /// 端口
    FieldType: Char; /// 数据类型
    FieldExt: Char; ///
  end;

  TDecodeSocketHeader = packed record /// 解码数据Socket包头！！
    Version: Word; /// 版本
    Flag: Char; /// Flag：包括 'F' 和 'T'
    Ext: Char; /// 扩展标志
  end;

  // Added by 黄晟楠 2006-11-28 11:14:02
  //简化版的设备结构，其中包括解码库对象
  //-------------------------------------------
  TDeviceSimple = record
    Decoder: TObject;
    //    Decoder: IDecoder;
    Handle: THandle;
    NetType: Byte;
    DeviceType: Byte;
    Provider: array[0..31] of char;
    Model: array[0..31] of char;    
    Port: Integer;
  end;
  TDeviceArray = array of TDeviceSimple;
  //Msg文件头包含的头信息及设备对象
  PMsgFileInfo = ^TMsgFileInfo;
  TMsgFileInfo = record
    FileID: TGUID;
    RcuID: TGUID;
    MajorVer, MinorVer: DWORD;
    FileVer: DWORD;
    BeginTime, EndTime: TDateTime;
    GEO: TGeographyParam;
    DeviceCount: Integer;
    DataCount: Integer;
    Devices: TDeviceArray;
  end;
  //---------------------------------------------
const
  DEFAULT_DECODE_SOCK_HEADER: TDecodeSocketHeader = (
    Version: CIFleetVerMajor;
    Flag: 'F';
    Ext: #0
    );

type
  PDecodeData = ^TDecodeData;
  TDecodeData = packed record /// 解码点数据信息
    Size: Integer; /// Data的大小！
    Header: TDecodeDataHeader; /// 数据头
    Data: array[0..CI_MAX_POINT_SIZE - 1] of char; /// 数据！
  end;

  ///对应RCU上传的文件的解码数据点结构体
  PDecodeData40 = ^TDecodeData40;
  TDecodeData40 = packed record /// 4.0版本中使用,解码后
    Size: Integer; /// Data的大小！
    Header: TDecodeDataHeader; /// 数据头
    Data: array[0..CI_MAX_POINT_SIZE - 1] of char; /// 数据！
    FilePosition: Int64;
  end;

  //Pioneer DT数据的解码数据点结构体，发送给统计服务器，20080828,tanding
  PDTDecodeData40 = ^TDTDecodeData40;
  TDTDecodeData40 = packed record /// 4.0版本中使用,解码后
    Size: Integer; /// Data的大小！
    Header: TDecodeDataHeader; /// 数据头
    GroupID: Integer; ///数据所属组的ID
    CreatorId: Integer; //创建者ID,文件上传者在数据库中的用户ID
    FileName: string[63]; //发送解码数据的源文件名称(*.msg)
    DeviceType: Byte; /// 设备类型,0：Modem；1：GPS；2：Handset；3：Scanner
    Model: array[0..15] of char;
    ///设备模块，例如：NMEA0183，MOTO，QualcommMS，G18, MC8755, NTM N95等
    Data: array[0..CI_MAX_POINT_SIZE - 1] of char; /// 数据！
    FilePosition: Int64;
  end;

  TDeviceModel = (dmNull, dmGPS, dmGSM, dmCDMA, dmUMTS, dmTDSCDMA);

  TIndexFileheader = packed record /// 128 Byte
    FileFlag: string[38]; /// GUID
    Version: string[8]; /// 文件版本
    Description: string[31]; /// Dingli
    Count: Integer; /// 分类Tag的个数,即 TIndexGroup的个数
    Reserved: Integer; /// 保留
    Reserved1: Integer; /// 保留
    Reserved2: Integer; ///保留
    Reserved3: string[31]; /// 保留
  end;

  TIndexItem = packed record
    Group: string[39]; /// 分组类型，可以为RCU或者UserName，
    BeginTime, EndTime: TDateTime; /// 数据开始时间，结束时间
    Left, Right, Top, Bottom: Double; /// 数据对应坐标范围
    FileSize: Integer; /// 最后正确传输数据的位置!
    Filename: string[63]; /// 文件名，不包含路径,文件名路径和Group相关
    Finished: Boolean;
    Reserved1: Integer; // 在DBVersion中，本字段代表是否需要更新相应的数据库记录
    Reserved2: string[6]; /// 保留
    ResetSeq:Integer; //重启后上传的第一文件的标识，1是第一个文件，0为非第一个文件
  end;
  PIndexItem = ^TIndexItem;

  PPdaIndexItem = ^TPdaIndexItem;
  TPdaIndexItem = packed record
    IMEI: string[39]; //标识
    PhoneNum: string[15];
    FileName: string[63];
    Finished: Boolean;
    FileSize: Integer; //已接收的数据大小
    UploadDT: TDateTime; //开始接收数据的时间
    LastUploadDT: TDateTime; //最后接收数据的时间
  end;

  PDTIndexItem = ^TDTIndexItem;
  TDTIndexItem = packed record
    DtId: Integer; //DT上传数据在数据库DataIndex_DT表中的ID,20080904,tanding
    GroupName: string[50]; //组名
    CreatorId: Integer; //创建者ID
    BeginTime, EndTime: TDateTime; /// 数据开始时间，结束时间
    Left, Right, Top, Bottom: Double; /// 数据对应坐标范围
    FileSize: Integer; /// 最后正确传输数据的位置!
    Filename: string[63]; /// 文件名，不包含路径,文件名路径和Group相关
    Finished: Boolean;
    AreaInfo: string[255];
    Remark1: string[255];
    Remark2: string[255];
  end;

const
  default_PDA_Index_Item: TPdaIndexItem = (
    IMEI: CSNone;
    PhoneNum: CSNone;
    FileName: CSNone;
    Finished: False;
    FilesIze: 0;
    UploadDT: INVALID_TIME_VALUE;
    LastUploadDT: INVALID_TIME_VALUE;
    );

  DEFAULT_INDEX_ITEM: TIndexItem = (
    Group: CSNone;
    BeginTime: INVALID_TIME_VALUE;
    EndTime: INVALID_TIME_VALUE;
    Left: INVALID_GPS_VALUE;
    Right: INVALID_GPS_VALUE;
    Top: INVALID_GPS_VALUE;
    Bottom: INVALID_GPS_VALUE;
    FileSize: 0;
    FileName: '';
    Finished: False;
    Reserved1: 0;
    Reserved2: '';
    );

  DEFAULT_DTIndex_Item: TDTIndexItem = (
    GroupName: CSNone;
    CreatorId: 0;
    BeginTime: INVALID_TIME_VALUE;
    EndTime: INVALID_TIME_VALUE;
    Left: INVALID_GPS_VALUE;
    Right: INVALID_GPS_VALUE;
    Top: INVALID_GPS_VALUE;
    Bottom: INVALID_GPS_VALUE;
    FileSize: 0;
    FileName: CSNone;
    Finished: False;
    AreaInfo: CSNone;
    Remark1: CSNone;
    Remark2: CSNone;
    );

type
  TOnlineItem = packed record /// RCU在线数据
    RcuId: string[39]; /// RCU ID
    BeginTime, EndTime: TDateTime; /// 时间范围
  end;

  //时间窗结构
  TWindowsTime = packed record
    Interval: Integer;
    Duration: Integer;
    Length: Integer;
    Synchronized: Boolean;
  end;

  //Ras结构
  TRasType = (rtNull= -1, rtRAS, rtWIFI);
  TWIFIType =(wtNull=-1,wtWeb,wtGeneral);
  TRasInfo = packed record
    ID: Integer;
    RasType: TRasType;
    Name: string;
    RASNumber: string;
    APN: string;
    UserName: string;
    Password: string;
    TimeOut: Integer;
    PAP: Boolean;
    WiFiType:string;
  end;
  //Server结构
  TServerInfo = packed record
    ID: Integer;
    Name: string;
    IP: string;
    Port: Integer;
    LoginAccount: string;
    LoginPassword: string;
    Passive: Boolean;
    RequiredAuthorized: Boolean;
  end;

  //User结构
  TUserInfo = packed record
    ID: Integer;
    LoginName: string;
    Password: string;
    Email: string;
    Phone: string;
    FirstName: string;
    LastName: string;
  end;
  TRcuLogIndex = packed record
    FileName :String;
    SubFolder:string;
    FileSize :String;
    RcuGuid  :String;
    RcuName  :String;
    CreateDate : TDateTime
  end;
function StrToDefaultCmd(const Cmd: string): TDefaultCmd;
function StrToRcuCmd(const Cmd: string): TRcuCmd;
function StrToVoiceCmd(Command: string): TVoiceCmd;
function StrToProjectCmd(Command: string): TProjectCmd;
function StrToUploadCmd(Command: string): TUploadCmd;
function StrToDownloadCmd(Command: string): TDownloadCmd;
function StrToControlCmd(Command: string): TControlCmd;
function StrToStatisticCmd(Command: string): TStatisticCmd;
function StrToDecodeUpCmd(Command: string): TDecodeUpCmd;
function StrToPdaCmd(const Cmd: string): TPdaCmd;
function StrToDownTypeCmd(Command: string): TDownfileType;
function StrToDTCmd(Command: string): TDTCmd;
function DateTimeForWebMonitor(ATime: TDateTime): string;
///转换DateTime返回'hh:nn:ss.zzz'供WebMonitor使用20080721,tanding
var
  //全局变量定义
  FormatSet: TFormatSettings; //国际化中用于处理符号

implementation
//uses
//  Log;

function StrToDefaultCmd(const Cmd: string): TDefaultCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Cmd, CSDefaultCmds[Result]) then
      Exit;
  Result := dcNull;
end;

function StrToRcuCmd(const Cmd: string): TRcuCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Cmd, CSRcuCmds[Result]) then
      Exit;
  Result := rcNull;
end;

function StrToPdaCmd(const Cmd: string): TPdaCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Cmd, CSPdaCmds[Result]) then
      Exit;
  Result := pdaNull;
end;

function StrToVoiceCmd(Command: string): TVoiceCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSVoiceCmds[Result]) then
      Exit;
  Result := vcNull;
end;

function StrToProjectCmd(Command: string): TProjectCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSProjectCmds[Result]) then
      Exit;
  Result := pcNull;
end;

function StrToUploadCmd(Command: string): TUploadCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSUploadCmds[Result]) then
      Exit;
  Result := ucNull;
end;

function StrToDownloadCmd(Command: string): TDownloadCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSDownloadCmds[Result]) then
      Exit;
  Result := dlcNull;
end;

function StrToControlCmd(Command: string): TControlCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSControlCmds[Result]) then
      Exit;
  Result := ccNull;
end;

function StrToDecodeUpCmd(Command: string): TDecodeUpCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSDecodeUpCmds[Result]) then
      Exit;
  Result := ducNull;
end;

function StrToStatisticCmd(Command: string): TStatisticCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSStatisticCmds[Result]) then
      Exit;
  Result := scNull;
end;

function StrToDownTypeCmd(Command: string): TDownfileType;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSDownloadType[Result]) then
      Exit;
  Result := dftNull;
end;

function StrToDTCmd(Command: string): TDTCmd;
begin
  for Result := High(Result) downto Low(Result) do
    if SameText(Command, CSDTCmds[Result]) then
      Exit;
  Result := dtcNull;
end;

//function StrToNetType(const S: string): TNetType;
//begin
//  for Result := High(Result) to Low(Result) do
//    if SameText(S, CSNetTypeNames[Result]) then Exit;
//  Result := ntNull;
//end;

function DateTimeForWebMonitor(ATime: TDateTime): string;
begin
  try
    if ATime > 0 then
      Result := Format('%s', [DateTimeToStr(ATime, FormatSet)])
    else
      Result := '';
  except
    Result := '';
  end;
end;

initialization
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FormatSet);
  FormatSet.DecimalSeparator := '.';
  FormatSet.LongTimeFormat := 'hh:nn:ss.zzz';
  FormatSet.ShortTimeFormat := 'hh:nn:ss.zzz';
  FormatSet.DateSeparator := '-';
  FormatSet.ShortDateFormat := 'yyyy-mm-dd';
  FormatSet.LongDateFormat := 'yyyy-mm-dd';
  //统一时间格式，不受本地系统设置影响，格式为：yyyy-mm-dd hh:nn:ss.zzz  tanding 20080814
end.
