unit FrmAddLocations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, DBCtrls, ExtCtrls, RzCmboBx, Mask,
  RzEdit, RzButton, FrmBase, RzSpnEdt, uDBFieldData, ActiveX;

type
  TAddLocationsForm = class(TBaseForm)
    Panel1: TPanel;
    lblAddress: TLabel;
    lblLocationType: TLabel;
    cbbLocationType: TRzComboBox;
    mmoAddress: TRzMemo;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    lblLocationName: TLabel;
    edtLocationName: TRzEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle): Boolean;
  end;


implementation

uses
  uControlInf, uDefine, uTransform;

{$R *.dfm}

procedure TAddLocationsForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  ReloadDBItemToCombox(cbbLocationType, CSLocationTypeDBName, CSName);
  //ReloadDBItemToCombox(cbBrand, CSBrandDBName, CSName);
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
procedure TAddLocationsForm.btnOKClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
  IXMLFieldItem: IXMLFieldType;
begin
    //有效性判断
  if Trim(cbbLocationType.Text) = '' then begin cbbLocationType.SetFocus; raise Exception.Create('地点类型不能为空！'); exit; end;
  if Trim(edtLocationName.Text) = '' then begin edtLocationName.SetFocus; raise Exception.Create('地点名称不能为空！'); exit; end;

  //重复性检查
  

  //写入数据库
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'write';
    IXMLDBData.DBData.DBTable := CSLocationDBName;
    
    AddLocationInfoColData(IXMLDBData);

    IXMLRowItem := IXMLDBData.DBData.RowData.Add;
    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSLocationTypeId;
    IXMLFieldItem.Value := IntToStr(gDatabaseControl.GetDBIdByDBName(CSLocationTypeDBName, CSName, cbbLocationType.Text));

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSName;
    IXMLFieldItem.Value := edtLocationName.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSAddress;
    IXMLFieldItem.Value := mmoAddress.Text;

    gDatabaseControl.AddLocationFromXMLData(IXMLDBData);

    Self.ModalResult := mrOk;
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
 
end;

//返回按钮
procedure TAddLocationsForm.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('确定返回？', mtConfirmation, [MbYES, MbNo], 0) = MrYES then Self.ModalResult := mrCancel;
end;

class function TAddLocationsForm.DisplayOutForm(AHandle: THandle): Boolean;
var
  AddLocationsForm: TAddLocationsForm;
begin
  AddLocationsForm := TAddLocationsForm.Create(Application, AHandle);
  try
    if AddLocationsForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(AddLocationsForm) then
      FreeAndNil(AddLocationsForm);
  end;
end;

end.
