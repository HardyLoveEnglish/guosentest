{*******************************************************

       �����             Log��Ԫ

       ��Ȩ���� (C) 2006 ����

       Created by ����� 2006-9-26 10:48:49
          ��Ҫ����log������ֱ�����ñ���Ԫ������WriteLogMsg����.
       Modified by ����� 2007-7-5 10:22:31
          ��Ӹ澯�����࣬���ݸ澯�����öԸ澯������ͬ�Ĵ���
*******************************************************}

unit Log;



interface

uses
  lyhClasses, DefinesUnit, SyncObjs;
type
  //��չTlogFile��ʹ֮���̰߳�ȫ
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
  LogFile: TMyLogFile; /// ������־�ļ�
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
  //�Ȼ����
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
  /// ������־�ļ�����
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
