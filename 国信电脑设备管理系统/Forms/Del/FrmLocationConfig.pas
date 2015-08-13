unit FrmLocationConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, FrmBase, Grids, ActiveX, uDBFieldData, uDefine,
  uTransform, uControlInf;

type
  TLocationConfigForm = class(TBaseForm)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    strngrdLocation: TStringGrid;
    grpQuery: TGroupBox;
    grpDel: TGroupBox;
    btnDel: TButton;
    grpAdd: TGroupBox;
    lbl1: TLabel;
    btnAdd: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshStringGridFromDB;
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle): Boolean;
  end;


implementation

{$R *.dfm}

{ TLocationConfigForm }

class function TLocationConfigForm.DisplayOutForm(
  AHandle: THandle): Boolean;
var
  LocationConfigForm: TLocationConfigForm;
begin
  LocationConfigForm := TLocationConfigForm.Create(Application, AHandle);
  try
    if LocationConfigForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(LocationConfigForm) then
      FreeAndNil(LocationConfigForm);
  end;
end;

procedure TLocationConfigForm.FormShow(Sender: TObject);
begin
  //初始化StringGrid
  RefreshStringGridFromDB;
end;

procedure TLocationConfigForm.RefreshStringGridFromDB;
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
begin
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'Read';
    IXMLDBData.DBData.DBTable := CSLocationDBName;
    IXMLDBData.DBData.SQL := 'Select a.Id, b.Name as LocationTypeName, a.Name as LocationName, a.Address ' +
                             ' From LocationInfo a, LocationTypeInfo b ' +
                             ' where (a.LocationTypeId = b.Id) ';

    //装载ColData的内容
    AddLocationInfoColData(IXMLDBData);

    //从数据库中加载数据到RowData中
    gDatabaseControl.QueryDataByXMLData(IXMLDBData);
    
    //显示到StringGrid
    DisXMLDataToStringGrid(IXMLDBData, strngrdLocation);
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
end;

procedure TLocationConfigForm.btnAddClick(Sender: TObject);
begin
  inherited;
  ShowMessage('Test');
end;

end.
