
{*************************************************************************}
{                                                                         }
{                            XML Data Binding                             }
{                                                                         }
{         Generated on: 2015-03-22 11:25:00                               }
{       Generated from: D:\xiewei\Code\国信电脑设备管理系统\DBField.xml   }
{   Settings stored in: D:\xiewei\Code\国信电脑设备管理系统\DBField.xdb   }
{                                                                         }
{*************************************************************************}

unit uDBFieldData;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLGuoSenDeviceSystemType = interface;
  IXMLDBDataType = interface;
  IXMLColDataType = interface;
  IXMLColItemType = interface;
  IXMLRowDataType = interface;
  IXMLRowItemType = interface;
  IXMLFieldType = interface;

{ IXMLGuoSenDeviceSystemType }

  IXMLGuoSenDeviceSystemType = interface(IXMLNode)
    ['{A1DDA538-EA65-476A-81D9-358AC405F7B2}']
    { Property Accessors }
    function Get_DBData: IXMLDBDataType;
    { Methods & Properties }
    property DBData: IXMLDBDataType read Get_DBData;
  end;

{ IXMLDBDataType }

  IXMLDBDataType = interface(IXMLNode)
    ['{AA3670F4-B9CB-4622-8D64-C86DF1C83FC6}']
    { Property Accessors }
    function Get_OperaterType: WideString;
    function Get_DBTable: WideString;
    function Get_SQL: WideString;
    function Get_ColData: IXMLColDataType;
    function Get_RowData: IXMLRowDataType;
    procedure Set_OperaterType(Value: WideString);
    procedure Set_DBTable(Value: WideString);
    procedure Set_SQL(Value: WideString);
    { Methods & Properties }
    property OperaterType: WideString read Get_OperaterType write Set_OperaterType;
    property DBTable: WideString read Get_DBTable write Set_DBTable;
    property SQL: WideString read Get_SQL write Set_SQL;
    property ColData: IXMLColDataType read Get_ColData;
    property RowData: IXMLRowDataType read Get_RowData;
  end;

{ IXMLColDataType }

  IXMLColDataType = interface(IXMLNodeCollection)
    ['{28B3EBA5-C22F-4C95-893E-B3A5E2618F46}']
    { Property Accessors }
    function Get_ColItem(Index: Integer): IXMLColItemType;
    { Methods & Properties }
    function Add: IXMLColItemType;
    function Insert(const Index: Integer): IXMLColItemType;
    property ColItem[Index: Integer]: IXMLColItemType read Get_ColItem; default;
  end;

{ IXMLColItemType }

  IXMLColItemType = interface(IXMLNode)
    ['{50F2E7E5-5DF9-4822-B0AF-657070F04B13}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_DisplayName: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_DisplayName(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property DisplayName: WideString read Get_DisplayName write Set_DisplayName;
  end;

{ IXMLRowDataType }

  IXMLRowDataType = interface(IXMLNodeCollection)
    ['{7D0E7D09-377F-45ED-B319-82BD09180DD5}']
    { Property Accessors }
    function Get_RowItem(Index: Integer): IXMLRowItemType;
    { Methods & Properties }
    function Add: IXMLRowItemType;
    function Insert(const Index: Integer): IXMLRowItemType;
    property RowItem[Index: Integer]: IXMLRowItemType read Get_RowItem; default;
  end;

{ IXMLRowItemType }

  IXMLRowItemType = interface(IXMLNodeCollection)
    ['{0765134E-9F04-47BD-8D2B-49D6BD58DF3C}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_Field(Index: Integer): IXMLFieldType;
    procedure Set_ID(Value: Integer);
    { Methods & Properties }
    function Add: IXMLFieldType;
    function Insert(const Index: Integer): IXMLFieldType;
    property ID: Integer read Get_ID write Set_ID;
    property Field[Index: Integer]: IXMLFieldType read Get_Field; default;
  end;

{ IXMLFieldType }

  IXMLFieldType = interface(IXMLNode)
    ['{3414B518-B9CE-4511-BC5F-B5606745135B}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Value: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Value(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  end;

{ Forward Decls }

  TXMLGuoSenDeviceSystemType = class;
  TXMLDBDataType = class;
  TXMLColDataType = class;
  TXMLColItemType = class;
  TXMLRowDataType = class;
  TXMLRowItemType = class;
  TXMLFieldType = class;

{ TXMLGuoSenDeviceSystemType }

  TXMLGuoSenDeviceSystemType = class(TXMLNode, IXMLGuoSenDeviceSystemType)
  protected
    { IXMLGuoSenDeviceSystemType }
    function Get_DBData: IXMLDBDataType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDBDataType }

  TXMLDBDataType = class(TXMLNode, IXMLDBDataType)
  protected
    { IXMLDBDataType }
    function Get_OperaterType: WideString;
    function Get_DBTable: WideString;
    function Get_SQL: WideString;
    function Get_ColData: IXMLColDataType;
    function Get_RowData: IXMLRowDataType;
    procedure Set_OperaterType(Value: WideString);
    procedure Set_DBTable(Value: WideString);
    procedure Set_SQL(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLColDataType }

  TXMLColDataType = class(TXMLNodeCollection, IXMLColDataType)
  protected
    { IXMLColDataType }
    function Get_ColItem(Index: Integer): IXMLColItemType;
    function Add: IXMLColItemType;
    function Insert(const Index: Integer): IXMLColItemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLColItemType }

  TXMLColItemType = class(TXMLNode, IXMLColItemType)
  protected
    { IXMLColItemType }
    function Get_Name: WideString;
    function Get_DisplayName: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_DisplayName(Value: WideString);
  end;

{ TXMLRowDataType }

  TXMLRowDataType = class(TXMLNodeCollection, IXMLRowDataType)
  protected
    { IXMLRowDataType }
    function Get_RowItem(Index: Integer): IXMLRowItemType;
    function Add: IXMLRowItemType;
    function Insert(const Index: Integer): IXMLRowItemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRowItemType }

  TXMLRowItemType = class(TXMLNodeCollection, IXMLRowItemType)
  protected
    { IXMLRowItemType }
    function Get_ID: Integer;
    function Get_Field(Index: Integer): IXMLFieldType;
    procedure Set_ID(Value: Integer);
    function Add: IXMLFieldType;
    function Insert(const Index: Integer): IXMLFieldType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFieldType }

  TXMLFieldType = class(TXMLNode, IXMLFieldType)
  protected
    { IXMLFieldType }
    function Get_Name: WideString;
    function Get_Value: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Value(Value: WideString);
  end;

{ Global Functions }

function GetGuoSenDeviceSystem(Doc: IXMLDocument): IXMLGuoSenDeviceSystemType;
function LoadGuoSenDeviceSystem(const FileName: WideString): IXMLGuoSenDeviceSystemType;
function NewGuoSenDeviceSystem: IXMLGuoSenDeviceSystemType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetGuoSenDeviceSystem(Doc: IXMLDocument): IXMLGuoSenDeviceSystemType;
begin
  Result := Doc.GetDocBinding('GuoSenDeviceSystem', TXMLGuoSenDeviceSystemType, TargetNamespace) as IXMLGuoSenDeviceSystemType;
end;

function LoadGuoSenDeviceSystem(const FileName: WideString): IXMLGuoSenDeviceSystemType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('GuoSenDeviceSystem', TXMLGuoSenDeviceSystemType, TargetNamespace) as IXMLGuoSenDeviceSystemType;
end;

function NewGuoSenDeviceSystem: IXMLGuoSenDeviceSystemType;
begin
  Result := NewXMLDocument.GetDocBinding('GuoSenDeviceSystem', TXMLGuoSenDeviceSystemType, TargetNamespace) as IXMLGuoSenDeviceSystemType;
end;

{ TXMLGuoSenDeviceSystemType }

procedure TXMLGuoSenDeviceSystemType.AfterConstruction;
begin
  RegisterChildNode('DBData', TXMLDBDataType);
  inherited;
end;

function TXMLGuoSenDeviceSystemType.Get_DBData: IXMLDBDataType;
begin
  Result := ChildNodes['DBData'] as IXMLDBDataType;
end;

{ TXMLDBDataType }

procedure TXMLDBDataType.AfterConstruction;
begin
  RegisterChildNode('ColData', TXMLColDataType);
  RegisterChildNode('RowData', TXMLRowDataType);
  inherited;
end;

function TXMLDBDataType.Get_OperaterType: WideString;
begin
  Result := AttributeNodes['OperaterType'].Text;
end;

procedure TXMLDBDataType.Set_OperaterType(Value: WideString);
begin
  SetAttribute('OperaterType', Value);
end;

function TXMLDBDataType.Get_DBTable: WideString;
begin
  Result := AttributeNodes['DBTable'].Text;
end;

procedure TXMLDBDataType.Set_DBTable(Value: WideString);
begin
  SetAttribute('DBTable', Value);
end;

function TXMLDBDataType.Get_SQL: WideString;
begin
  Result := AttributeNodes['SQL'].Text;
end;

procedure TXMLDBDataType.Set_SQL(Value: WideString);
begin
  SetAttribute('SQL', Value);
end;

function TXMLDBDataType.Get_ColData: IXMLColDataType;
begin
  Result := ChildNodes['ColData'] as IXMLColDataType;
end;

function TXMLDBDataType.Get_RowData: IXMLRowDataType;
begin
  Result := ChildNodes['RowData'] as IXMLRowDataType;
end;

{ TXMLColDataType }

procedure TXMLColDataType.AfterConstruction;
begin
  RegisterChildNode('ColItem', TXMLColItemType);
  ItemTag := 'ColItem';
  ItemInterface := IXMLColItemType;
  inherited;
end;

function TXMLColDataType.Get_ColItem(Index: Integer): IXMLColItemType;
begin
  Result := List[Index] as IXMLColItemType;
end;

function TXMLColDataType.Add: IXMLColItemType;
begin
  Result := AddItem(-1) as IXMLColItemType;
end;

function TXMLColDataType.Insert(const Index: Integer): IXMLColItemType;
begin
  Result := AddItem(Index) as IXMLColItemType;
end;

{ TXMLColItemType }

function TXMLColItemType.Get_Name: WideString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLColItemType.Set_Name(Value: WideString);
begin
  SetAttribute('Name', Value);
end;

function TXMLColItemType.Get_DisplayName: WideString;
begin
  Result := AttributeNodes['DisplayName'].Text;
end;

procedure TXMLColItemType.Set_DisplayName(Value: WideString);
begin
  SetAttribute('DisplayName', Value);
end;

{ TXMLRowDataType }

procedure TXMLRowDataType.AfterConstruction;
begin
  RegisterChildNode('RowItem', TXMLRowItemType);
  ItemTag := 'RowItem';
  ItemInterface := IXMLRowItemType;
  inherited;
end;

function TXMLRowDataType.Get_RowItem(Index: Integer): IXMLRowItemType;
begin
  Result := List[Index] as IXMLRowItemType;
end;

function TXMLRowDataType.Add: IXMLRowItemType;
begin
  Result := AddItem(-1) as IXMLRowItemType;
end;

function TXMLRowDataType.Insert(const Index: Integer): IXMLRowItemType;
begin
  Result := AddItem(Index) as IXMLRowItemType;
end;

{ TXMLRowItemType }

procedure TXMLRowItemType.AfterConstruction;
begin
  RegisterChildNode('Field', TXMLFieldType);
  ItemTag := 'Field';
  ItemInterface := IXMLFieldType;
  inherited;
end;

function TXMLRowItemType.Get_ID: Integer;
begin
  Result := AttributeNodes['ID'].NodeValue;
end;

procedure TXMLRowItemType.Set_ID(Value: Integer);
begin
  SetAttribute('ID', Value);
end;

function TXMLRowItemType.Get_Field(Index: Integer): IXMLFieldType;
begin
  Result := List[Index] as IXMLFieldType;
end;

function TXMLRowItemType.Add: IXMLFieldType;
begin
  Result := AddItem(-1) as IXMLFieldType;
end;

function TXMLRowItemType.Insert(const Index: Integer): IXMLFieldType;
begin
  Result := AddItem(Index) as IXMLFieldType;
end;

{ TXMLFieldType }

function TXMLFieldType.Get_Name: WideString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLFieldType.Set_Name(Value: WideString);
begin
  SetAttribute('Name', Value);
end;

function TXMLFieldType.Get_Value: WideString;
begin
  Result := AttributeNodes['Value'].Text;
end;

procedure TXMLFieldType.Set_Value(Value: WideString);
begin
  SetAttribute('Value', Value);
end;

end. 