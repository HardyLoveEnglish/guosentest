unit uTransform;

{ 此单元是处理工厂，输入某些东西，输出某些东西，函数内就是处理过程

  1、将ADOQuery的内容显示到StringGrid中

  2、设置StringGrid的样式

  3、传入ComboBox，加载数据库中的列表选项 }

interface

uses
  ADODB, DB, SysUtils, Classes, Grids, uDBFieldData, Log, RzCmboBx, uDefine;


  procedure DisADOQryToStringGrid(AQry: TADOQuery; AStrGrid: TStringGrid);
  procedure TransformADOQryToXMLData(AQry: TADOQuery; IXMLDBData: IXMLGuoSenDeviceSystemType);
  procedure DisXMLDataToStringGrid(IXMLDBData: IXMLGuoSenDeviceSystemType; AStrGrid: TStringGrid);
  procedure SetStringGridStyle(AStrGrid: TStringGrid);
  procedure ReloadDBItemToCombox(AComboBox: TRzComboBox; const ATableName,
    AColName: string);
  procedure AddDeviceInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
  procedure AddLocationInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
  procedure AddUserInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
  procedure AddDeviceLocationInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
  procedure AddDeviceHistoryInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
  function GetFieldValueByFieldName(IXMLRowItem: IXMLRowItemType;
    const AFieldName: string): string;
  procedure FillADOQryFromXMLData(IXMLDBData: IXMLGuoSenDeviceSystemType; AQry: TADOQuery);

implementation

uses
  uControlInf;

//将ADOQuery查询到的数据显示到StringGrid上
procedure DisADOQryToStringGrid(AQry: TADOQuery; AStrGrid: TStringGrid);
var
  i, j: Integer;
begin
  if AQry.RecordCount <= 0 then
    AStrGrid.RowCount := AQry.RecordCount + 2
  else
    AStrGrid.RowCount := AQry.RecordCount + 1;
  AStrGrid.ColCount := AQry.FieldCount + 1;
  //设置列名
  for i := 0 to AQry.FieldCount - 1 do
  begin
    AStrGrid.Cells[(i+1), 0] := AQry.Fields[i].FieldName;
  end;
  //填充内容
  for i := 0 to AQry.RecordCount - 1 do
  begin
    for j := 0 to AQry.FieldCount - 1 do
    begin
      AStrGrid.Cells[0, (i+1)] := IntToStr(i+1);
      AStrGrid.Cells[(j+1), (i+1)] := AQry.FieldByName(AQry.Fields[j].FieldName).AsString;
    end;
    AQry.Next;
  end;
end;

procedure TransformADOQryToXMLData(AQry: TADOQuery; IXMLDBData: IXMLGuoSenDeviceSystemType);
var
  recordset: _Recordset;
  i: Integer;
  IXMLRowItem: IXMLRowItemType;
  IXMLFieldItem: IXMLFieldType;
begin
  recordset := AQry.Recordset;
  if recordset.RecordCount > 0 then
  begin
    recordset.MoveFirst;
    while not recordset.EOF do
    begin
      IXMLRowItem := IXMLDBData.DBData.RowData.Add;

      for i := 0 to IXMLDBData.DBData.ColData.Count - 1 do
      begin
        IXMLFieldItem := IXMLRowItem.Add;
        IXMLFieldItem.Name := IXMLDBData.DBData.ColData.ColItem[i].Name;
        IXMLFieldItem.Value := string(recordset.Fields.Item[IXMLFieldItem.Name].Value);
      end;
      recordset.MoveNext;
    end;
    //ADOQuery.Recordset.Fields.Item[];
  end;
end;  

procedure DisXMLDataToStringGrid(IXMLDBData: IXMLGuoSenDeviceSystemType; AStrGrid: TStringGrid);
var
  i, j: Integer;
  IXMLRowItem: IXMLRowItemType;
begin
  if IXMLDBData.DBData.RowData.Count <= 0 then
    AStrGrid.RowCount := IXMLDBData.DBData.RowData.Count + 2
  else
    AStrGrid.RowCount := IXMLDBData.DBData.RowData.Count + 1;
  AStrGrid.ColCount := IXMLDBData.DBData.ColData.Count + 1;
  //设置列名
  for i := 0 to IXMLDBData.DBData.ColData.Count - 1 do
  begin
    AStrGrid.Cells[(i+1), 0] := IXMLDBData.DBData.ColData[i].DisplayName;
  end;
  //填充内容
  for i := 0 to IXMLDBData.DBData.RowData.Count - 1 do
  begin
    IXMLRowItem := IXMLDBData.DBData.RowData.RowItem[i];
    for j := 0 to IXMLRowItem.Count - 1 do
    begin
      AStrGrid.Cells[0, (i+1)] := IntToStr(i+1);
      AStrGrid.Cells[(j+1), (i+1)] := GetFieldValueByFieldName(IXMLRowItem, IXMLDBData.DBData.ColData[j].Name);
    end;
  end;
end; 

//设置StringGrid的样式到固定的好看的样式
procedure SetStringGridStyle(AStrGrid: TStringGrid);
begin
  if not (goRowSizing in AStrGrid.Options) then
    AStrGrid.Options := AStrGrid.Options + [goRowSizing];

  if not (goColSizing in AStrGrid.Options) then
    AStrGrid.Options := AStrGrid.Options + [goColSizing];

  if not (goRowSelect in AStrGrid.Options) then
    AStrGrid.Options := AStrGrid.Options + [goRowSelect];
    
  if not (goThumbTracking in AStrGrid.Options) then
    AStrGrid.Options := AStrGrid.Options + [goThumbTracking];

  if goRangeSelect in AStrGrid.Options then
    AStrGrid.Options := AStrGrid.Options - [goRangeSelect];

  AStrGrid.DefaultColWidth := 96;
end;

//从数据库中加载选项显示到ComboBox中
procedure ReloadDBItemToCombox(AComboBox: TRzComboBox; const ATableName,
  AColName: string);
var
  NameItems: TStringList;
  OneItemName: string;
  i: Integer;
begin
  NameItems := TStringList.Create;
  try
    gDatabaseControl.QueryNameFromDB(ATableName, AColName, NameItems);

    AComboBox.Items.BeginUpdate;
    AComboBox.Clear;
    //for i := 0 to FProductTypes.Count - 1 do
    for i := 0 to NameItems.Count - 1 do
    begin
      //OneItemName := FProductTypes.ProductItem[i].PropertyContent[0];

      OneItemName := NameItems.Strings[i];
      AComboBox.Items.Add(OneItemName);
      
    end;
    AComboBox.ItemIndex := 0;
    AComboBox.Items.EndUpdate;
  finally
    FreeAndNil(NameItems);
  end;   

end;

procedure AddDeviceInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
var
  IXMLColItem: IXMLColItemType;
begin
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSID;
  IXMLColItem.DisplayName := '序号';
  
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSWriteDateTime;
  IXMLColItem.DisplayName := '入库时间';
  
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSDeviceTypeName;
  IXMLColItem.DisplayName := '设备类型';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSBrandName;
  IXMLColItem.DisplayName := '品牌名称';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSModel;
  IXMLColItem.DisplayName := '设备型号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSSeqNum;
  IXMLColItem.DisplayName := '出厂编号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSProductionDate;
  IXMLColItem.DisplayName := '生产日期';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSQuantity;
  IXMLColItem.DisplayName := '设备数量';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSMAC;
  IXMLColItem.DisplayName := 'MAC地址';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSMemo;
  IXMLColItem.DisplayName := '备注';
end;

procedure AddLocationInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
var
  IXMLColItem: IXMLColItemType;
begin
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSID;
  IXMLColItem.DisplayName := '序号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSLocationTypeName;
  IXMLColItem.DisplayName := '放置点类型';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSLocationName;
  IXMLColItem.DisplayName := '放置点名称';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSAddress;
  IXMLColItem.DisplayName := '放置点地址';
end;

procedure AddUserInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
var
  IXMLColItem: IXMLColItemType;
begin
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSID;
  IXMLColItem.DisplayName := '序号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSUserId;
  IXMLColItem.DisplayName := '员工Lotus号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSUserName;
  IXMLColItem.DisplayName := '员工姓名';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSLocationName;
  IXMLColItem.DisplayName := '员工所在部门';
end;

procedure AddDeviceLocationInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
var
  IXMLColItem: IXMLColItemType;
begin
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSID;
  IXMLColItem.DisplayName := '序号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSWriteDateTime;
  IXMLColItem.DisplayName := '写入时间';
  
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSDeviceId;
  IXMLColItem.DisplayName := '设备序号';
  
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSLocationId;
  IXMLColItem.DisplayName := '放置点序号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSUserId;
  IXMLColItem.DisplayName := '使用人序号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSMemo;
  IXMLColItem.DisplayName := '备注';
end;

procedure AddDeviceHistoryInfoColData(IXMLDBData: IXMLGuoSenDeviceSystemType);
var
  IXMLColItem: IXMLColItemType;
begin
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSID;
  IXMLColItem.DisplayName := '序号';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSStartDateTime;
  IXMLColItem.DisplayName := '开始时间';
  
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSEndDateTime;
  IXMLColItem.DisplayName := '结束时间';
  
  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSLocationName;
  IXMLColItem.DisplayName := '放置点名称';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSUserName;
  IXMLColItem.DisplayName := '使用人姓名';

  IXMLColItem := IXMLDBData.DBData.ColData.Add;
  IXMLColItem.Name := CSMemo;
  IXMLColItem.DisplayName := '备注';
end;

function GetFieldValueByFieldName(IXMLRowItem: IXMLRowItemType;
  const AFieldName: string): string;
var
  i: Integer;
begin
  Result := EmptyStr;
  for i := 0 to IXMLRowItem.Count - 1 do
  begin
    if SameText(AFieldName, IXMLRowItem.Field[i].Name) then
    begin
      Result := IXMLRowItem.Field[i].Value;
      Break;
    end;  
  end;
end;  

procedure FillADOQryFromXMLData(IXMLDBData: IXMLGuoSenDeviceSystemType; AQry: TADOQuery);
begin
  //ADOQuery.FieldByName('OrderTime').AsDateTime := AOrderModel.OrderTime;
  //ADOQuery.FieldByName('ClientId').AsInteger := AOrderModel.ClientId;
  //ADOQuery.FieldByName('CostSum').AsFloat := AOrderModel.CostSum;
//  ADOQuery.FieldByName('PlanTotalCount').AsInteger := AOrderModel.PlanTotalCount;
//  ADOQuery.FieldByName('IsVisible').AsBoolean := AOrderModel.IsVisible;
//  IXMLDBData.DBData
end;

end.
