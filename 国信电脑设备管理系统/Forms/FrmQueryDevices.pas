unit FrmQueryDevices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBGridEhGrouping, GridsEh, DBGridEh, StdCtrls, Grids,
  uDBFieldData, uDefine, ComCtrls, Buttons, Menus;

type
  TQueryDevicesForm = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    lbl1: TLabel;
    strngrdDeviceQry: TStringGrid;
    pnl3: TPanel;
    grpAdd: TGroupBox;
    grpDel: TGroupBox;
    btnAdd: TButton;
    btnDel: TButton;
    grpModify: TGroupBox;
    btnModify: TButton;
    grpDisDetail: TGroupBox;
    btnDisDetail: TButton;
    grpQuery: TGroupBox;
    statDevice: TStatusBar;
    btnSetting: TBitBtn;
    tmrDateTime: TTimer;
    pmSys: TPopupMenu;
    mniDBConfig: TMenuItem;
    mniLocationConfig: TMenuItem;
    mniUserConfig: TMenuItem;
    grpIO: TGroupBox;
    btnOutput: TButton;
    btnInput: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrDateTimeTimer(Sender: TObject);
    procedure btnSettingClick(Sender: TObject);
    procedure mniDBConfigClick(Sender: TObject);
    procedure mniLocationConfigClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure strngrdDeviceQryMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnInputClick(Sender: TObject);
    procedure mniUserConfigClick(Sender: TObject);
    procedure btnDisDetailClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshStringGridFromDB;
    procedure AddLocationAndUserNameToStringGrid;
  public
    { Public declarations }
  end;

var
  QueryDevicesForm: TQueryDevicesForm;

implementation

uses
  Log, FrmAddDevices, uDBInf, uTransform, uControlInf, ActiveX, FrmDBConfig,
  FrmLocationConfig, FrmModifyLocation, uStaticFunction, FrmUserConfig,
  FrmDisplayDetails;

{$R *.dfm}

procedure TQueryDevicesForm.btnAddClick(Sender: TObject);
begin
  if TAddDevicesForm.DisplayOutForm(Handle) then
  begin

  end;
  RefreshStringGridFromDB;
end;

procedure TQueryDevicesForm.btnDelClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
begin
  if gDatabaseControl.GetTableCountFromDB(CSDeviceDBName, ' where (IsVisible = 1) ') <= 0 then
  begin
    ShowMessage('���ݿ���û���豸����');
    Exit;
  end;
  
  if (strngrdDeviceQry.Row > 0) and (strngrdDeviceQry.Row < strngrdDeviceQry.RowCount) then
  begin
    if MessageDlg('ȷ��Ҫɾ��ѡ������', mtConfirmation, [mbYes, mbNo], 0) = MrYes then
    begin
      CoInitialize(nil);
      IXMLDBData := NewGuoSenDeviceSystem;
      try
        IXMLDBData.DBData.OperaterType := 'write';
        IXMLDBData.DBData.DBTable := CSDeviceDBName;
    
        AddDeviceInfoColData(IXMLDBData);

        IXMLRowItem := IXMLDBData.DBData.RowData.Add;
        IXMLRowItem.ID := StrToInt(strngrdDeviceQry.Cells[1, strngrdDeviceQry.Row]);
        
        gDatabaseControl.DelDeviceByXMLData(IXMLDBData);
        RefreshStringGridFromDB;
      finally
        IXMLDBData := nil;
        CoUninitialize;
      end;
    end;  
  end;  
end;

procedure TQueryDevicesForm.FormCreate(Sender: TObject);
begin
  gGlobalControl := TGlobalControl.Create;
  //�����ʼ��
  SetStringGridStyle(strngrdDeviceQry);
  RefreshStringGridFromDB;
end;

procedure TQueryDevicesForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(gGlobalControl);
end;

procedure TQueryDevicesForm.RefreshStringGridFromDB;
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
begin
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'Read';
    IXMLDBData.DBData.DBTable := CSDeviceDBName;
    IXMLDBData.DBData.SQL := 'Select a.Id, a.WriteDateTime, b.Name as DeviceTypeName, c.Name as BrandName, ' +
                             ' a.Model, a.SeqNum, a.ProductionDate, a.Quantity, a.MAC, a.Memo ' +
                             ' From DeviceInfo a, DeviceTypeInfo b, BrandInfo c ' +
                             ' where (a.IsVisible = 1) and (a.DeviceTypeId = b.Id) and (a.BrandId = c.Id) ';

    //װ��ColData������
    AddDeviceInfoColData(IXMLDBData);

    //�����ݿ��м������ݵ�RowData��
    gDatabaseControl.QueryDataByXMLData(IXMLDBData);
    
    //��ʾ��StringGrid
    DisXMLDataToStringGrid(IXMLDBData, strngrdDeviceQry);

    //������ʾλ����Ϣ�͸�����Ϣ������
    AddLocationAndUserNameToStringGrid;

  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;
end;

procedure TQueryDevicesForm.AddLocationAndUserNameToStringGrid;
var
  i, iDeviceId: Integer;
begin
  strngrdDeviceQry.ColCount := strngrdDeviceQry.ColCount + 2;
  strngrdDeviceQry.Cells[11, 0] := '���õ�';
  strngrdDeviceQry.Cells[12, 0] := 'ʹ����';
  for i := 1 to strngrdDeviceQry.RowCount - 1 do
  begin
    iDeviceId := StrToInt(strngrdDeviceQry.Cells[1, i]);
    strngrdDeviceQry.Cells[11, i] := gDatabaseControl.GetLocationNameByDeviceId(iDeviceId);
    strngrdDeviceQry.Cells[12, i] := gDatabaseControl.GetUserNameByDeviceId(iDeviceId);
  end;
end;

procedure TQueryDevicesForm.tmrDateTimeTimer(Sender: TObject);
begin
  statDevice.Panels[2].Text := DateTimeToStr(Now);
end;

procedure TQueryDevicesForm.btnSettingClick(Sender: TObject);
begin
  pmSys.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TQueryDevicesForm.mniDBConfigClick(Sender: TObject);
begin
  TDBConfigForm.DisplayOutForm(Self);
end;

procedure TQueryDevicesForm.mniLocationConfigClick(Sender: TObject);
begin
  // Deleted by Hardy 2014/10/30 20:52:28
  if TLocationConfigForm.DisplayOutForm(Handle) then
  begin
    //ˢ�·��õ��ComboBox
  end;
end;

procedure TQueryDevicesForm.btnOutputClick(Sender: TObject);
var
  iDeviceId: Integer;
begin
  if (strngrdDeviceQry.Row > 0) and (strngrdDeviceQry.Row < strngrdDeviceQry.RowCount) then
  begin
    iDeviceId := StrToInt(strngrdDeviceQry.Cells[1, strngrdDeviceQry.Row]);
    //�ж�ѡ�е��豸�Ƿ�Ϊ�ڿ��豸��δ���õ��豸����ִ������Ĺ黹����
    if gDatabaseControl.IsExistInDeviceLocationDB(iDeviceId) then
    begin
      ShowMessage('ѡ�е��豸�ѱ����ã����ȹ黹');
      Exit;
    end;

    if TModifyLocationForm.DisplayOutForm(Handle, strngrdDeviceQry) then
    begin

    end;
    RefreshStringGridFromDB;
  end;
end;

procedure TQueryDevicesForm.strngrdDeviceQryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //StringGridTitleDown(Sender, Button, X, Y);
end;

procedure TQueryDevicesForm.btnInputClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
  iDeviceId: Integer;
begin
  if gDatabaseControl.GetTableCountFromDB(CSDeviceDBName, EmptyStr) <= 0 then
  begin
    ShowMessage('���ݿ���û���豸����');
    Exit;
  end;
  
  if (strngrdDeviceQry.Row > 0) and (strngrdDeviceQry.Row < strngrdDeviceQry.RowCount) then
  begin
    iDeviceId := StrToInt(strngrdDeviceQry.Cells[1, strngrdDeviceQry.Row]);
    //�ж�ѡ�е��豸�Ƿ�Ϊ�ڿ��豸��δ���õ��豸����ִ������Ĺ黹����
    if not gDatabaseControl.IsExistInDeviceLocationDB(iDeviceId) then
    begin
      ShowMessage('ѡ�е��豸���ڿ��豸������黹');
      Exit;
    end;
    //��δ���

    //�黹�豸��������
    if MessageDlg('ȷ��Ҫ��ѡ���豸�黹��', mtConfirmation, [mbYes, mbNo], 0) = MrYes then
    begin
      CoInitialize(nil);
      IXMLDBData := NewGuoSenDeviceSystem;
      try
        IXMLDBData.DBData.OperaterType := 'read';
        IXMLDBData.DBData.DBTable := CSDeviceLocationDBName;
        IXMLDBData.DBData.SQL := Format('Select * From DeviceLocationInfo where (DeviceId = %d) ', [iDeviceId]);
    
        AddDeviceLocationInfoColData(IXMLDBData);

        //�����ݿ��м������ݵ�RowData��
        gDatabaseControl.QueryDataByXMLData(IXMLDBData);
        
        gDatabaseControl.DelDeviceLocationByXMLData(IXMLDBData);
        RefreshStringGridFromDB;
      finally
        IXMLDBData := nil;
        CoUninitialize;
      end;
    end;  
  end;  
end;

procedure TQueryDevicesForm.mniUserConfigClick(Sender: TObject);
begin
  if TUserConfigForm.DisplayOutForm(Handle) then
  begin
    //ˢ�·��õ��ComboBox
  end;
end;

procedure TQueryDevicesForm.btnDisDetailClick(Sender: TObject);
var
  iDeviceId: Integer;
begin
  if (strngrdDeviceQry.Row > 0) and (strngrdDeviceQry.Row < strngrdDeviceQry.RowCount) then
  begin
    iDeviceId := StrToInt(strngrdDeviceQry.Cells[1, strngrdDeviceQry.Row]);

    if TDisplayDetailsForm.DisplayOutForm(Handle, strngrdDeviceQry) then
    begin
       
    end;
  end;
end;

end.
