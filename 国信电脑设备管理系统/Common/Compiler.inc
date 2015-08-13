/// 本文件为Fleet的编译条件指令文件，所有的编译指令应该添加到这里
/// 各个工程应该在 dpr 中添加类似下面的代码：
///  {$I '..\..\Compiler.inc'}

/// 下面的编译指令为新的数据服务使用
{$IFNDEF _NEW_SERVER_}
  {$DEFINE _NEW_SERVER_}
{$ENDIF}

/// 下面的编译指令为Lucent防火墙使用
/// Lucent防火墙关闭了其他端口，只允许21端口的入站数据
{$IFNDEF _LUCENT_FIREWALL_}
  {$DEFINE _LUCENT_FIREWALL_}
{$ENDIF}

//定义是否需要转换解码的数据，
//旧的解码库根据fleet定义的field来解码，新的解码库解码出最大范围的数据的结构，
//但是有些数据fleet可能不需要，所以我们自己定义了需要统计的数据的结构。所以必须转换成fleet的结构;
//注释by 黄晟楠 06-11-13
//由于MonitorDataObject单元中也需要此编译条件，因此将此编译条件定义成全局的;
{$IFNDEF _CONVERT_DECODED_SIGNAL}
  {$DEFINE _CONVERT_DECODED_SIGNAL }
{$ENDIF}

//数据服务4.0版本
{$IFNDEF _Ver40}
  {$DEFINE _Ver40}
{$ENDIF}

// Added by 黄晟楠 2006-12-5 10:12:19
// 由于11月初给Lucent的数据服务版本有个BUG,在存储msg文件时，语音拨打上行数据没有包含数据头；
// 导致在提供下载msg数据时，会发生异常。
// 因此针对Lucent的msg数据添加了特别处理
{$IFNDEF _Lucent_Fix}
  {.$DEFINE _Lucent_Fix}
{$ENDIF}
//读取针对N85所作的新的接口
{$IFNDEF _NEW_}
  {$DEFINE _NEW_}
{$ENDIF}
//add by 黄晟楠 2010-7-20
//陕西移动版本，增加向其第三方系统发送告警信息功能
{$IFNDEF _ShanXiMobile}
  {.$DEFINE _ShanXiMobile}
{$ENDIF}
