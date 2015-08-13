unit FrmLocationConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, FrmBase, uDBFieldData, ActiveX, uDefine,
  uTransform, uControlInf;

type
  TLocationConfigForm = class(TBaseForm)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    strngrdLocation: TStringGrid;
    grpAdd: TGroupBox;
    grpDel: TGroupBox;
    btnAdd: TButton;
    grpQuery: TGroupBox;
    btnDel: TButton;
    lblTitle: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshStringGridFromDB;
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle): Boolean;
  end;


implementation

uses
  FrmAddLocations;

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

procedure TLocationConfigForm.FormShow(Sender: TObject);
begin
  SetStringGridStyle(strngrdLocation);
  strngrdLocation.ColWidths[0] := 20;
  strngrdLocation.ColWidths[1] := 50;
  strngrdLocation.ColWidths[4] := 400;
  RefreshStringGridFromDB;
end;

procedure TLocationConfigForm.btnAddClick(Sender: TObject);
begin
  if TAddLocationsForm.DisplayOutForm(Handle) then
  begin
    ShowMessage('添加成功');
    RefreshStringGridFromDB;
  end;
end;

procedure TLocationConfigForm.btnDelClick(Sender: TObject);
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  IXMLRowItem: IXMLRowItemType;
begin
  if gDatabaseControl.GetTableCountFromDB(CSLocationDBName, EmptyStr) <= 0 then
  begin
    ShowMessage('数据库中没有放置点数据');
    Exit;
  end;
  
  if (strngrdLocation.Row > 0) and (strngrdLocation.Row < strngrdLocation.RowCount) then
  begin
    if MessageDlg('确定要删除选中行吗？', mtConfirmation, [mbYes, mbNo], 0) = MrYes then
    begin
      CoInitialize(nil);
      IXMLDBData := NewGuoSenDeviceSystem;
      try
        IXMLDBData.DBData.OperaterType := 'write';
        IXMLDBData.DBData.DBTable := CSLocationDBName;
        
        AddLocationInfoColData(IXMLDBData);

        IXMLRowItem := IXMLDBData.DBData.RowData.Add;
        IXMLRowItem.ID := StrToInt(strngrdLocation.Cells[1, strngrdLocation.Row]);
        
        gDatabaseControl.DelLocationByXMLData(IXMLDBData);
        RefreshStringGridFromDB;
      finally
        IXMLDBData := nil;
        CoUninitialize;
      end;
    end;  
  end;  
end;

end.
