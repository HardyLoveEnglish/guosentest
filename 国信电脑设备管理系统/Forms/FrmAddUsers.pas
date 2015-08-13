unit FrmAddUsers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzButton, StdCtrls, RzCmboBx, Mask, RzEdit, uDefine,
  FrmBase, uTransform, uDBFieldData, ActiveX, uControlInf;

type
  TAddUsersForm = class(TBaseForm)
    pnl1: TPanel;
    rzbtbtnOK: TRzBitBtn;
    rzbtbtnCancel: TRzBitBtn;
    lblLocation: TLabel;
    lblUserID: TLabel;
    lblUserName: TLabel;
    cbbLocation: TRzComboBox;
    edtUserID: TRzEdit;
    edtUserName: TRzEdit;
    procedure FormShow(Sender: TObject);
    procedure rzbtbtnCancelClick(Sender: TObject);
    procedure rzbtbtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle): Boolean;
  end;


implementation

{$R *.dfm}

{ TAddUsersForm }

class function TAddUsersForm.DisplayOutForm(AHandle: THandle): Boolean;
var
  AddUsersForm: TAddUsersForm;
begin
  AddUsersForm := TAddUsersForm.Create(Application, AHandle);
  try
    if AddUsersForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(AddUsersForm) then
      FreeAndNil(AddUsersForm);
  end;
end;

procedure TAddUsersForm.FormShow(Sender: TObject);
var
  i: Integer;
  sDBNameAndCondition, sCondition: string;
begin
  //LocationTypeId = 1 只查找场内部门，因为员工只归属于场内部门
  sCondition := ' where LocationTypeId = 1 ';
  sDBNameAndCondition := Format(' %s %s ', [CSLocationDBName, sCondition]);
  ReloadDBItemToCombox(cbbLocation, sDBNameAndCondition, CSName);
  //ReloadDBItemToCombox(cbBrand, CSBrandDBName, CSName);
  for i := 0 to pnl1.ControlCount - 1 do
  begin
    if pnl1.Controls[i] is TRzEdit then
      TRzEdit(pnl1.Controls[i]).Clear;
    if pnl1.Controls[i] is TRzComboBox then
      TRzComboBox(pnl1.Controls[i]).ItemIndex := 0;
  end;

  //cbOperationType.Items.AddStrings(DMForm.stOperationType);
end;

procedure TAddUsersForm.rzbtbtnCancelClick(Sender: TObject);
begin
  if MessageDlg('确定返回？', mtConfirmation, [MbYES, MbNo], 0) = MrYES then Self.ModalResult := mrCancel;
end;

procedure TAddUsersForm.rzbtbtnOKClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
  IXMLFieldItem: IXMLFieldType;
begin
    //有效性判断
  if Trim(cbbLocation.Text) = '' then begin cbbLocation.SetFocus; raise Exception.Create('场内部门不能为空！'); exit; end;
  if Trim(edtUserID.Text) = '' then begin edtUserID.SetFocus; raise Exception.Create('员工Lotus号不能为空！'); exit; end;
  if Trim(edtUserName.Text) = '' then begin edtUserName.SetFocus; raise Exception.Create('员工姓名不能为空！'); exit; end;

  //重复性检查
  

  //写入数据库
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'write';
    IXMLDBData.DBData.DBTable := CSUserDBName;

    AddUserInfoColData(IXMLDBData);

    IXMLRowItem := IXMLDBData.DBData.RowData.Add;
    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSUserId;
    IXMLFieldItem.Value := edtUserID.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSUserName;
    IXMLFieldItem.Value := edtUserName.Text;

    IXMLFieldItem := IXMLRowItem.Add;
    IXMLFieldItem.Name := CSLocationId;
    IXMLFieldItem.Value := IntToStr(gDatabaseControl.GetDBIdByDBName(CSLocationDBName, CSName, cbbLocation.Text));

    gDatabaseControl.AddUserFromXMLData(IXMLDBData);

    Self.ModalResult := mrOk;
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
 
end;

end.
