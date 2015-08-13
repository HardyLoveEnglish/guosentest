unit FrmUserConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, FrmBase, uDefine, uDBFieldData, ActiveX,
  uTransform, uControlInf;

type
  TUserConfigForm = class(TBaseForm)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    strngrdUser: TStringGrid;
    lbl1: TLabel;
    grpAddOrDel: TGroupBox;
    btnAdd: TButton;
    btnDel: TButton;
    grpQuery: TGroupBox;
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshStringGridFromDB;
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle): Boolean;
  end;


implementation

uses
  FrmAddUsers;

{$R *.dfm}

{ TForm3 }

class function TUserConfigForm.DisplayOutForm(AHandle: THandle): Boolean;
var
  UserConfigForm: TUserConfigForm;
begin
  UserConfigForm := TUserConfigForm.Create(Application, AHandle);
  try
    if UserConfigForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(UserConfigForm) then
      FreeAndNil(UserConfigForm);
  end;
end;

procedure TUserConfigForm.btnAddClick(Sender: TObject);
begin
  if TAddUsersForm.DisplayOutForm(Handle) then
  begin
    ShowMessage('添加成功');
    RefreshStringGridFromDB;
  end;
end;

procedure TUserConfigForm.RefreshStringGridFromDB;
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
begin
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'Read';
    IXMLDBData.DBData.DBTable := CSUserDBName;
    IXMLDBData.DBData.SQL := 'Select a.Id, a.UserID, a.UserName, b.Name as LocationName ' +
                             ' From UserInfo a, LocationInfo b ' +
                             ' where (a.LocationId = b.Id) ';

    //装载ColData的内容
    AddUserInfoColData(IXMLDBData);

    //从数据库中加载数据到RowData中
    gDatabaseControl.QueryDataByXMLData(IXMLDBData);

    //显示到StringGrid
    DisXMLDataToStringGrid(IXMLDBData, strngrdUser);
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
end;

procedure TUserConfigForm.FormShow(Sender: TObject);
begin
  SetStringGridStyle(strngrdUser);
  strngrdUser.ColWidths[0] := 20;
  strngrdUser.ColWidths[1] := 50;
  strngrdUser.ColWidths[4] := 400;
  RefreshStringGridFromDB;
end;

end.
