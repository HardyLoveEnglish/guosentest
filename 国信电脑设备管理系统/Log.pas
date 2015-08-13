{*******************************************************

       软件名             Log单元

       版权所有 (C) 2006 鼎立

       Created by 黄晟楠 2006-9-26 10:48:49
          需要进行log动作，直接引用本单元，调用WriteLogMsg即可.
       Modified by 黄晟楠 2007-7-5 10:22:31
          添加告警处理类，根据告警的配置对告警做出不同的处理
*******************************************************}

unit Log;



interface

uses
  lyhClasses, DefinesUnit, SyncObjs;
type
  //扩展TlogFile，使之有线程安全
  TMyLogFile = class(TLogFile)
  private
    FLock:TCriticalSection;
  public
    constructor Create(AFileName: string); overload;
    destructor Destroy; override;

    function WriteLog(const Msg: string): Boolean;overload;
  end;
procedure WriteLogMsg(const LogType: TLogType; const Msg: string);


var
  LogFile: TMyLogFile; /// 程序日志文件
implementation
uses
  Windows, uMyTools, SysUtils;

procedure WriteLogMsg(const LogType: TLogType; const Msg: string);
begin
  if Assigned(LogFile) then
    LogFile.WriteLog(CSLogTypes[LogType] + CS_Comma + Msg);
end;


{ TMyLogFile }

constructor TMyLogFile.Create(AFileName: string);
begin
  FLock := TCriticalSection.Create;
  inherited Create(AFileName);
end;

destructor TMyLogFile.Destroy;
begin
  FreeAndNilEx(FLock);
  inherited;
end;

function TMyLogFile.WriteLog(const Msg: string):Boolean;
begin
  //先获得锁
  FLock.Enter;
  try
    inherited WriteLog(Msg);
  finally
    FLock.Leave;
  end;
end;

initialization
  if not DirectoryExists(AppPath + 'GXZHLogFile\') then
    ForceDirectories(AppPath + 'GXZHLogFile\');
  /// 创建日志文件对象
  LogFile := TMyLogFile.Create(ChangeFileExtEx(AppPath + 'GXZHLogFile\' + ParamStr(3) + '_' + ExtractFileName(ParamStr(0)), '.log'));
  LogFile.TimeStamp := True;
  LogFile.MaxSize := 10 * 1024 * 1024;

  WriteLogMsg(ltInfo, Format(CSLogFleetLoadProgram, [GetCommandLine]));

finalization
  if Assigned(LogFile) then
    LogFile.OnLogMessage := nil;
  WriteLogMsg(ltInfo, CSLogFleetExitProgram);
  FreeAndNilEx(LogFile);
  
end.
