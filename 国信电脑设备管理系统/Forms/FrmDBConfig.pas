unit FrmDBConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ADODB, FrmQueryDevices;

const
  //DataIndex
  csIniDBIp = 'DBIp';
  csIniDBPort = 'DBPort';
  csIniDBName = 'DBName';
  csIniDBUsername= 'DBUserName';
  csIniDBPassword= 'DBPassword';

  CS_EncryptKey = '11E246A';

type
  TDBConfigForm = class(TForm)
    img1: TImage;
    Label21: TLabel;
    cbbServerName: TComboBox;
    Label23: TLabel;
    edtLoginName: TEdit;
    Label24: TLabel;
    edtPassword: TEdit;
    Label22: TLabel;
    cbbDBName: TComboBox;
    btnTestCon: TButton;
    Label1: TLabel;
    edtPort: TEdit;
    lbl1: TLabel;
    btnOk: TButton;
    procedure btnTestConClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbDBNameDropDown(Sender: TObject);
    procedure cbbServerNameDropDown(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    FOwner: TQueryDevicesForm;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    MainFrmHandle: Cardinal;
    procedure LoadSetting;
    procedure SaveSetting;
    class function DisplayOutForm(AMainForm: TQueryDevicesForm): Boolean;
    constructor Create(AMainForm: TQueryDevicesForm); reintroduce;
  end;
  
  procedure ReadDBConfigFromIni;
  procedure SaveDBConfigToIni;


implementation

uses
  Math, DateUtils, uDBInf, ComObj, IniFiles, uSimpleEncrypt;

{$R *.dfm}

procedure ReadDBConfigFromIni;
var
  iniSet: TIniFile;
  sFileName, sDBPassword: string;
  i:Integer;
begin
  sFileName := ExtractFilePath(ParamStr(0)) + 'Option.ini';
  iniSet := TIniFile.Create(sFileName);
  try
    gDBInterface.DBName := iniSet.ReadString('SystemConfig','DatabaseName','');
    gDBInterface.DBUserName := iniSet.ReadString('SystemConfig','UserName','');
    sDBPassword := iniSet.ReadString('SystemConfig','Password','');
    gDBInterface.DBPassword := DecryStrHex(sDBPassword, CS_EncryptKey);
    gDBInterface.DBServer := iniSet.ReadString('SystemConfig','Server','');
    gDBInterface.DBPort := iniSet.ReadInteger('SystemConfig','Port',1433);
  finally
    iniSet.Free;
  end;
end;

procedure SaveDBConfigToIni;
var
  iniSet: TIniFile;
  sFileName: string;
begin
  sFileName := ExtractFilePath(ParamStr(0)) + 'Option.ini';
  iniSet := TIniFile.Create(sFileName);
  try
    iniSet.WriteString('SystemConfig','DatabaseName',gDBInterface.DBName);
    iniSet.WriteString('SystemConfig','UserName',gDBInterface.DBUserName);
    iniSet.WriteString('SystemConfig','Password', EncryStrHex(Trim(gDBInterface.DBPassword), CS_EncryptKey));
    iniSet.WriteString('SystemConfig','Server',gDBInterface.DBServer);
    iniSet.WriteInteger('SystemConfig','Port',gDBInterface.DBPort);
  finally
    iniSet.Free;
  end;
end; 

procedure GetServerList(Names: TStrings);
var
  SQLServer:   Variant;
  ServerList:   Variant;
  i,   nServers:   integer;
begin
  Names.Clear;
  SQLServer := CreateOleObject('SQLDMO.Application');
  ServerList := SQLServer.ListAvailableSQLServers;
  nServers := ServerList.Count;
  for i := 1 to nServers do
  begin
    Names.Add(ServerList.Item(i));
  end;
  VarClear(SQLServer);
  VarClear(serverList);
end;

procedure GetAllDBName(const AConnetStr: string; Names: TStrings);
var
  adoCon: TADOConnection;
  adoReset: TADODataSet;
begin
  adoCon := TADOConnection.Create(nil);
  adoReset := TADODataSet.Create(nil);
  try
    try
      adoCon.LoginPrompt := False;
      adoCon.ConnectionString := AConnetStr;
      adoCon.Connected := True;
      adoReset.Connection := adoCon;
      adoReset.CommandText := 'use master;Select name From sysdatabases';
      adoReset.CommandType := cmdText;
      adoReset.Open;

      Names.BeginUpdate;
      Names.Clear;
      while not adoReset.Eof do
      begin
        Names.Add(adoReset.FieldByName('name').AsString);
        adoReset.Next;
      end;
      Names.EndUpdate;
    except
      on e:Exception do
      begin
        {$IFDEF _Log}
        WriteLogMsg(ltError,Format('%s,HAPPEN AT GetAllDBName',[e.Message]));
        {$ENDIF}
        raise;
      end;
    end;
  finally
    adoReset.Close;
    FreeAndNil(adoReset);
    FreeAndNil(adoCon);
  end;
end;

procedure TDBConfigForm.LoadSetting();
begin
  cbbServerName.Text:= gDBInterface.DBServer;
  edtPort.Text := IntToStr(gDBInterface.DBPort);
  cbbDBName.Text:= gDBInterface.DBName;
  edtLoginName.Text:= gDBInterface.DBUsername;
  edtPassword.Text:= gDBInterface.DBPassword;
end;

procedure TDBConfigForm.SaveSetting();
begin
  gDBInterface.DBServer:= cbbServerName.Text;
  gDBInterface.DBPort:= StrToIntDef(edtPort.Text, 1433);
  gDBInterface.DBName:= cbbDBName.Text;
  gDBInterface.DBUsername:= edtLoginName.Text;
  gDBInterface.DBPassword:= edtPassword.Text;
end;

procedure TDBConfigForm.btnTestConClick(Sender: TObject);
var
  AdoCon: TADOConnection;
begin
  AdoCon := TADOConnection.Create(nil);
  try
    try
      AdoCon.LoginPrompt := False;
      AdoCon.ConnectionString := Format(CSSQLConnectionString, [cbbServerName.Text,
        edtPort.Text, cbbDBName.Text, edtLoginName.Text, edtPassword.Text]);
    
      AdoCon.Connected := True;
      MessageDlg('Connect to ' + cbbServerName.Text + ' Successfully!', mtInformation,[mbOk], 0);
    except
      on e:Exception do
        MessageDlg('Unable to Connect to server ' + cbbServerName.Text + ':' + cbbDBName.Text + #13#10#13#10
                                   + e.Message, mtError,[mbOk], 0);
    end;
  finally
    FreeAndNil(AdoCon);
  end;

end;

procedure TDBConfigForm.FormCreate(Sender: TObject);
begin
  LoadSetting;
end;



procedure TDBConfigForm.cbbDBNameDropDown(Sender: TObject);
var
  sConStr: string;
begin
  Screen.Cursor:= crHourGlass;
  try
    try
      sConStr := Format(CSSQLConnectionString, [cbbServerName.Text,
        edtPort.Text, cbbDBName.Text, edtLoginName.Text, edtPassword.Text]);
      GetAllDBName(sConStr, cbbDBName.Items);
    except            
      on e:Exception do
        MessageDlg('Unable to Connect to server ' + cbbServerName.Text + #13#10#13#10
                                   + e.Message, mtError,[mbOk], 0);
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TDBConfigForm.cbbServerNameDropDown(Sender: TObject);
begin
  Screen.Cursor:= crHourGlass;
  try
    try
      GetServerList(cbbServerName.Items);
    except
      ;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TDBConfigForm.btnOkClick(Sender: TObject);
begin
  SaveSetting;
  ModalResult := mrOk;
end;

class function TDBConfigForm.DisplayOutForm(AMainForm: TQueryDevicesForm): Boolean;
var
  DBConfigForm: TDBConfigForm;
begin
  DBConfigForm := TDBConfigForm.Create(AMainForm);
  try
    Result := (DBConfigForm.ShowModal = mrOk);
  finally
    if Assigned(DBConfigForm) then
      FreeAndNil(DBConfigForm);
  end;
end;

procedure TDBConfigForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := FOwner.Handle;
end;

constructor TDBConfigForm.Create(AMainForm: TQueryDevicesForm);
begin
  FOwner := AMainForm;
  inherited Create(Application);
end;

end.
