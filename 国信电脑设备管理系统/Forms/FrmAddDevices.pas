unit FrmAddDevices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, DBCtrls, ExtCtrls, RzCmboBx, Mask,
  RzEdit, RzButton, FrmBase, RzSpnEdt, uDBFieldData, ActiveX;

type
  TAddDevicesForm = class(TBaseForm)
    Panel1: TPanel;
    lblBrand: TLabel;
    lblModel: TLabel;
    lblCount: TLabel;
    lblMemo: TLabel;
    lblDeviceType: TLabel;
    cbbDeviceType: TRzComboBox;
    cbBrand: TRzComboBox;
    edtModel: TRzEdit;
    edtSeqID: TRzEdit;
    mmoDeviceInfo: TRzMemo;
    btnOK: TRzBitBtn;
    btnReset: TRzBitBtn;
    btnCancel: TRzBitBtn;
    lblDeviceMAC: TLabel;
    edtDeviceMAC: TRzEdit;
    lblSeqID: TLabel;
    lblBirDate: TLabel;
    edtBirDate: TRzDateTimeEdit;
    edtCount: TRzSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    function isDigit(aString: string): Boolean;
    procedure DoReset;
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle): Boolean;
  end;


implementation

uses
  uControlInf, uDefine, uTransform;

{$R *.dfm}

procedure TAddDevicesForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  ReloadDBItemToCombox(cbbDeviceType, CSDeviceTypeDBName, CSName);
  ReloadDBItemToCombox(cbBrand, CSBrandDBName, CSName);
  for i := 0 to Panel1.ControlCount - 1 do
  begin
    if Panel1.Controls[i] is TRzEdit then
      TRzEdit(Panel1.Controls[i]).Clear;
    if Panel1.Controls[i] is TRzComboBox then
      TRzComboBox(Panel1.Controls[i]).ItemIndex := 0;
  end;

  //cbOperationType.Items.AddStrings(DMForm.stOperationType);
end;

//确定按钮
procedure TAddDevicesForm.btnOKClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
  IXMLFieldItem: IXMLFieldType;
begin
    //有效性判断
  if Trim(cbbDeviceType.Text) = '' then begin cbbDeviceType.SetFocus; raise Exception.Create('设备类型不能为空！'); exit; end;
  if Trim(cbBrand.Text) = '' then begin cbBrand.SetFocus; raise Exception.Create('设备品牌不能为空！'); exit; end;
  if edtCount.IntValue <= 0 then begin edtCount.SetFocus; raise Exception.Create('数量不能小于等于0！'); exit; end;
  if Trim(edtBirDate.Text) = '' then begin edtBirDate.SetFocus; raise Exception.Create('生产日期不能为空！'); exit; end;
  //写入数据库
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'write';
    IXMLDBData.DBData.DBTable := 'DeviceInfo';
    
    AddDeviceInfoColData(IXMLDBData);

    IXMLRowItem := IXMLDBData.DBData.RowData.Add;
    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSDeviceTypeId;
    IXMLFieldItem.Value := IntToStr(gDatabaseControl.GetDBIdByDBName(CSDeviceTypeDBName, CSName, cbbDeviceType.Text));

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSBrandId;
    IXMLFieldItem.Value := IntToStr(gDatabaseControl.GetDBIdByDBName(CSBrandDBName, CSName, cbBrand.Text));

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSModel;
    IXMLFieldItem.Value := edtModel.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSSeqNum;
    IXMLFieldItem.Value := edtSeqID.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSProductionDate;
    IXMLFieldItem.Value := edtBirDate.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSQuantity;
    IXMLFieldItem.Value := edtCount.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSMAC;
    IXMLFieldItem.Value := edtDeviceMAC.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSMemo;
    IXMLFieldItem.Value := mmoDeviceInfo.Text;

    gDatabaseControl.AddDeviceFromXMLData(IXMLDBData);

    if MessageDlg('添加成功，是否继续添加？', mtConfirmation, [mbYes, mbNo], 0) = MrNo then Self.ModalResult := mrOk
    else begin
      DoReset;
    end;
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
 
end;

//重置按钮
procedure TAddDevicesForm.btnResetClick(Sender: TObject);
begin
  if MessageDlg('确定需要重置？', mtConfirmation, [MbYES, MbNo], 0) <> MrYES then exit;

  DoReset;
end;

//返回按钮
procedure TAddDevicesForm.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('确定返回？', mtConfirmation, [MbYES, MbNo], 0) = MrYES then Self.ModalResult := mrCancel;
end;

function TAddDevicesForm.isDigit(aString: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i:= 1 to Length(aString) do
    if not (aString[i] in ['0'..'9']) then begin Result := False; Break; end;
end;

class function TAddDevicesForm.DisplayOutForm(AHandle: THandle): Boolean;
var
  AddDevicesForm: TAddDevicesForm;
begin
  AddDevicesForm := TAddDevicesForm.Create(Application, AHandle);
  try
    if AddDevicesForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(AddDevicesForm) then
      FreeAndNil(AddDevicesForm);
  end;
end;

procedure TAddDevicesForm.DoReset;
begin
  cbbDeviceType.ItemIndex := 0;
  cbBrand.ItemIndex := 0;
  edtModel.Clear;
  edtSeqID.Clear;
  edtBirDate.Clear;
  edtCount.IntValue := 1;
  edtDeviceMAC.Clear;
  mmoDeviceInfo.Clear;

  cbbDeviceType.SetFocus;
end;

end.
