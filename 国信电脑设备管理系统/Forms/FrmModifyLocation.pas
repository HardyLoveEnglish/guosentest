unit FrmModifyLocation;

{设备借用}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, RzEdit, Mask, RzCmboBx, ExtCtrls, FrmBase,
  uTransform, uDefine, Grids, uDBFieldData, ActiveX, uControlInf;

type
  TModifyLocationForm = class(TBaseForm)
    pnl1: TPanel;
    lblDeviceBrand: TLabel;
    lblDeviceModel: TLabel;
    lblLocation: TLabel;
    lblMemo: TLabel;
    lblDeviceType: TLabel;
    lblFundCode: TLabel;
    edtDeviceBrand: TRzEdit;
    edtDeviceModel: TRzEdit;
    mmoOperation: TRzMemo;
    rzbtbtnOK: TRzBitBtn;
    rzbtbtnCancel: TRzBitBtn;
    lblSeqID: TLabel;
    edtDeviceType: TRzEdit;
    edtSeqID: TRzEdit;
    cbbLocation: TRzComboBox;
    cbbDeviceUser: TRzComboBox;
    procedure FormShow(Sender: TObject);
    procedure rzbtbtnCancelClick(Sender: TObject);
    procedure rzbtbtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FDeviceGrid: TStringGrid;
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle; ADeviceGrid: TStringGrid): Boolean;
    property DeviceGrid: TStringGrid write FDeviceGrid;
  end;



implementation

{$R *.dfm}

{ TModifyLocationForm }

class function TModifyLocationForm.DisplayOutForm(
  AHandle: THandle; ADeviceGrid: TStringGrid): Boolean;
var
  ModifyLocationForm: TModifyLocationForm;
begin
  ModifyLocationForm := TModifyLocationForm.Create(Application, AHandle);
  try
    ModifyLocationForm.DeviceGrid := ADeviceGrid;
    if ModifyLocationForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(ModifyLocationForm) then
      FreeAndNil(ModifyLocationForm);
  end;
end;

procedure TModifyLocationForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  ReloadDBItemToCombox(cbbLocation, CSLocationDBName, CSName);
  ReloadDBItemToCombox(cbbDeviceUser, CSUserDBName, CSUserName);
  for i := 0 to pnl1.ControlCount - 1 do
  begin
    if pnl1.Controls[i] is TRzEdit then
      TRzEdit(pnl1.Controls[i]).Clear;
    if pnl1.Controls[i] is TRzComboBox then
      TRzComboBox(pnl1.Controls[i]).ItemIndex := 0;
  end;

  edtDeviceType.Text := FDeviceGrid.Cells[3, FDeviceGrid.Row];
  edtDeviceBrand.Text := FDeviceGrid.Cells[4, FDeviceGrid.Row];
  edtDeviceModel.Text := FDeviceGrid.Cells[5, FDeviceGrid.Row];
  edtSeqID.Text := FDeviceGrid.Cells[6, FDeviceGrid.Row];
  //cbOperationType.Items.AddStrings(DMForm.stOperationType);
end;

procedure TModifyLocationForm.rzbtbtnCancelClick(Sender: TObject);
begin
  if MessageDlg('确定返回？', mtConfirmation, [MbYES, MbNo], 0) = MrYES then Self.ModalResult := mrCancel;
end;

procedure TModifyLocationForm.rzbtbtnOKClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
  IXMLFieldItem: IXMLFieldType;
begin
    //有效性判断
  if Trim(cbbLocation.Text) = '' then begin cbbLocation.SetFocus; raise Exception.Create('设备位置不能为空！'); exit; end;
  if Trim(cbbDeviceUser.Text) = '' then begin cbbDeviceUser.SetFocus; raise Exception.Create('设置使用人不能为空！'); exit; end;

  //重复性检查
  

  //写入数据库
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'write';
    IXMLDBData.DBData.DBTable := 'DeviceLocationInfo';
    
    AddDeviceLocationInfoColData(IXMLDBData);

    IXMLRowItem := IXMLDBData.DBData.RowData.Add;
    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSDeviceId;
    IXMLFieldItem.Value := FDeviceGrid.Cells[1, FDeviceGrid.Row];
    
    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSLocationId;
    IXMLFieldItem.Value := IntToStr(gDatabaseControl.GetDBIdByDBName(CSLocationDBName, CSName, cbbLocation.Text));

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSUserId;
    IXMLFieldItem.Value := IntToStr(gDatabaseControl.GetDBIdByDBName(CSUserDBName, CSUserName, cbbDeviceUser.Text));

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSMemo;
    IXMLFieldItem.Value := mmoOperation.Text;

    gDatabaseControl.AddDeviceLocationFromXMLData(IXMLDBData);

    Self.ModalResult := mrOk;
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
 
end;

end.
