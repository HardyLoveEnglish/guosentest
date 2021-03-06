unit ReportWriterImpl;

interface

uses
  ReportParent, Variants, MyExcelReport, Graphics, Math, DateUtils, SysUtils,
  uDataManager, uDataModel, Windows, lyhTools, uConstAndType, RzListVw,
  ComCtrls, uOrderModel, Classes, FrmOutPutExcel;

type
  TReportWriteManger = class(TReportParent)
  private
    FTestTemplateFile: string;
    FReportDest: string;
    procedure WriteOneProduct(AvData: OleVariant; ARow: Integer; AMainProduct: TMainProduct);
  public
    constructor Create(const ATestTemplateFile, ADestFileName: string);
    destructor Destroy; override;
    procedure WriteProductList(ARow, ASheetNo: Integer; AOrderModel: TOrderModel);
    procedure WriteClientTotalList(AListView: TRzListView; AStartRow, AColCount: Integer; const AClientName: string);
    procedure WriteCompanyTotalList(AListView: TRzListView; AStartRow, AColCount: Integer);
    procedure WriteTotalList(AListView: TRzListView; AStartRow, AColCount: Integer; const AClientName: string; bIsClient: Boolean);
    //procedure SetDestFileName(const ADestFileName: string);
    procedure WriteTotalExcel(ADataList: TList; AOutputExcelType: TOutputExcelType; AOutPutExcelCondition: TOutPutExcelCondition);
    property ReportDest: string read FReportDest;
  end;

  function GetCurDateTimeBySystemTime: string;

implementation

uses
  uControlInf, uStaticFunction;

function GetCurDateTimeBySystemTime: string;
var
  fmt: TFormatSettings;
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fmt);
  fmt.DecimalSeparator := '.';
  fmt.TimeSeparator := '-';
  fmt.LongTimeFormat := 'hh-nn-ss';
  fmt.ShortTimeFormat := 'hh-nn-ss';
  fmt.DateSeparator := '-';
  fmt.ShortDateFormat := 'yyyy-mm-dd';
  fmt.LongDateFormat := 'yyyy-mm-dd';
  Result := DateTimeToStr(Now, fmt);
  //LocalmsgTime := GMTToLocale(msgTime);
end;

{ TReportWriteManger }

constructor TReportWriteManger.Create(const ATestTemplateFile, ADestFileName: string);
var
  sPath, sFileName, sDateTime: string;
begin
  inherited Create;
  FTestTemplateFile := ATestTemplateFile;
  sPath := ExtractFilePath(ParamStr(0));
  sFileName := ExtractFileName(ATestTemplateFile);
  sDateTime := '_' + GetCurDateTimeBySystemTime;
  if IsEmptyStr(ADestFileName) then
    FReportDest := sPath + ChangeFileExt(sFileName, '') + sDateTime + ExtractFileExt(sFileName)
  else
    FReportDest := ADestFileName;

  KillOffice;
  FExcel.OpenFileEx(FTestTemplateFile, FReportDest, True);
end;

destructor TReportWriteManger.Destroy;
begin
  FExcel.ActiveSheetNo := 1;
  FExcel.Save(FReportDest);
  inherited;
end;

procedure TReportWriteManger.WriteClientTotalList(AListView: TRzListView;
  AStartRow, AColCount: Integer; const AClientName: string);
var
  sNoOneContent: string;
begin
  sNoOneContent := '客户：' + Trim(AClientName);
  FReportDest := ExtractFilePath(FReportDest) + AClientName + '_' + ChangeFileExt(ExtractFileName(FReportDest), '') + ExtractFileExt(FReportDest);
  WriteTotalList(AListView, AStartRow, AColCount, sNoOneContent, True);
end;

procedure TReportWriteManger.WriteTotalList(AListView: TRzListView;
  AStartRow, AColCount: Integer; const AClientName: string; bIsClient: Boolean);
var
  fr: TFillRange;
  iRegionCount, iInc, iRowNo, i, j, iTotalRow: Integer;
  vData: OleVariant;
  AFont: TFont;
  CellPro: TCellProperty;
  AListItem: TListItem;
  sFieldName, sTotalFieldName: string;
begin
  FExcel.ActiveSheetNo := 1;
  
  iRegionCount := AListView.Items.Count;

  if (iRegionCount > 0) then
  begin
    for i := 0 to iRegionCount - 1 do
    begin
      FExcel.InsertRowExt(AStartRow);   
    end;
    fr.FromCell.Row := AStartRow;
    fr.FromCell.Col := 1;
    fr.ToCell.Row := fr.FromCell.Row + iRegionCount - 1;
    fr.ToCell.Col := AColCount;
    FExcel.SetRangeFonts(fr.FromCell.Row, fr.ToCell.Row, 1, AColCount, clBlack, [], 10);

    vData := VarArrayCreate([1, iRegionCount, 1, AColCount], varVariant);

    iRowNo := 0;
    for i := 0 to iRegionCount - 1 do
    begin
      Inc(iRowNo);
      iInc := (iRowNo + 1) div 2;

      AListItem := AListView.Items[i];
      vData[iRowNo, 1] := iInc;
      for j := 0 to AListItem.SubItems.Count - 1 do
      begin
        sFieldName := AListItem.SubItems[j];
        vData[iRowNo, (j + 2)] := sFieldName;
      end;
    end;

    if bIsClient then
    begin
      FExcel.TypeText(1, 1, AClientName);
    end;  

    //求合计
//    if ARow = 2 then
//    begin
//      sTotalFieldName := AProductList.GetTotalValue(tvtTotalCount);
//      iTotalRow := 6 + iRegionCount;
//      FExcel.TypeText(iTotalRow, 3, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtTotalSaleMoney);
//      FExcel.TypeText(iTotalRow, 8, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtTotalDiscountMoney);
//      FExcel.TypeText(iTotalRow, 9, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtTotalCashMoney);
//      FExcel.TypeText(iTotalRow, 10, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtFareCost);
//      FExcel.TypeText(iTotalRow, 11, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtFixCost);
//      FExcel.TypeText(iTotalRow, 12, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtProfitMoney);
//      FExcel.TypeText(iTotalRow, 13, sTotalFieldName);
//
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtFareRate);
//      FExcel.TypeText((iTotalRow + 1), 13, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtDiscountRate);
//      FExcel.TypeText((iTotalRow + 1), 17, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtProfitMoney);
//      FExcel.TypeText((iTotalRow + 2), 13, sTotalFieldName);
//
//      sTotalFieldName := AProductList.GetTotalValue(tvtProfitRate);
//      FExcel.TypeText((iTotalRow + 2), 17, sTotalFieldName);
//    end;
  end
  else
  begin
    FExcel.InsertRowExt(AStartRow);
    
    fr.FromCell.Row := AStartRow;
    fr.FromCell.Col := 1;
    fr.ToCell.Row := fr.FromCell.Row;
    fr.ToCell.Col := AColCount;
    FExcel.SetRangeFonts(fr.FromCell.Row, fr.ToCell.Row, 1, AColCount, clBlack, [], 10);

    vData := VarArrayCreate([1, 1, 1, AColCount], varVariant);

    for i := 1 to AColCount do
    begin
      vData[1, i] := '';
    end;
  end;  
  
  AFont := TFont.Create;
  try
    AFont.Size := 10;
    CellPro.Font := AFont;
    CellPro.Applyed := True;
    CellPro.BorderLineStyle := blLine;
    FExcel.FillProperty(fr, CellPro);
    FExcel.FillData(fr, vData);
    FExcel.SetRangeAlign(fr, haCenter);
  finally
    FreeAndNil(AFont);
  end;
  {* 设置左对齐 *}
  FExcel.SetRangeAlignDefault(fr);
end;

procedure TReportWriteManger.WriteCompanyTotalList(AListView: TRzListView;
  AStartRow, AColCount: Integer);
var
  fr: TFillRange;
  iRegionCount, iInc, i, j, iTotalRow: Integer;
  vData: OleVariant;
  AFont: TFont;
  CellPro: TCellProperty;
  AMainProduct: TMainProduct;
  sFieldName, sTotalFieldName: string;
begin
  WriteTotalList(AListView, AStartRow, AColCount, EmptyStr, False);
end;

procedure TReportWriteManger.WriteOneProduct(AvData: OleVariant; ARow: Integer;
  AMainProduct: TMainProduct);
var
  i: Integer;
  sFieldName: string;
begin
  if Assigned(AMainProduct) then
  begin
    AvData[ARow, 1] := AMainProduct.GUIDSeqID;
    for i := 0 to AMainProduct.ItemCount - 1 do
    begin
      sFieldName := AMainProduct.PropertyContent[i];
      AvData[ARow, (i + 2)] := sFieldName;
    end;
  end
  else
  begin
    for i := 1 to 16 do
    begin
      AvData[ARow, i] := '';
    end;
  end;  
end;

procedure TReportWriteManger.WriteProductList(ARow, ASheetNo: Integer; AOrderModel: TOrderModel);
var
  fr: TFillRange;
  iRegionCount, iInc, i, j, iTotalRow: Integer;
  vData: OleVariant;
  AFont: TFont;
  CellPro: TCellProperty;
  AMainProduct: TMainProduct;
  sFieldName, sTotalFieldName: string;
  AProductList: TProductList;
  dAvgValue: Double;
  iTotalCount: Integer;
begin
  FExcel.ActiveSheetNo := ASheetNo;

  AProductList := AOrderModel.OrderProductDetailList;
  iRegionCount := AProductList.ItemCount;

  if (iRegionCount > 0) then
  begin
    for i := 0 to iRegionCount - 1 do
    begin
      FExcel.InsertRowExt(ARow);   
    end;
    fr.FromCell.Row := ARow;
    fr.FromCell.Col := 1;
    fr.ToCell.Row := fr.FromCell.Row + iRegionCount - 1;
    fr.ToCell.Col := 18;
    FExcel.SetRangeFonts(fr.FromCell.Row, fr.ToCell.Row, 1, 18, clBlack, [], 10);

    vData := VarArrayCreate([1, iRegionCount, 1, 18], varVariant);

    iInc := 0;
    for i := 0 to iRegionCount - 1 do
    begin
      Inc(iInc);

      AMainProduct := AProductList.ProductItem[i];
      vData[iInc, 1] := AMainProduct.GUIDSeqID;
      for j := 0 to AMainProduct.ItemCount - 1 do
      begin
        sFieldName := AMainProduct.PropertyContent[j];
        vData[iInc, (j + 2)] := sFieldName;
      end;
    end;

    if ARow = 2 then
    begin
      sTotalFieldName := AProductList.GetTotalValue(tvtTotalCount);
      iTotalRow := 6 + iRegionCount;
      FExcel.TypeText(iTotalRow, 3, sTotalFieldName);
      iTotalCount := StrToInt(sTotalFieldName);

      sTotalFieldName := gGlobalControl.GetClientNameByClientId(AOrderModel.ClientId);
      FExcel.TypeText((iTotalRow + 1), 3, sTotalFieldName);

      sTotalFieldName := DateToStr(AOrderModel.OrderTime);
      FExcel.TypeText((iTotalRow + 2), 3, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtTotalSaleMoney);
      FExcel.TypeText(iTotalRow, 8, sTotalFieldName);

      if iTotalCount > 0 then
        dAvgValue := StrToFloat(sTotalFieldName) / iTotalCount
      else
        dAvgValue := 0;
      sTotalFieldName := Format('%.2f', [dAvgValue]);
      FExcel.TypeText((iTotalRow + 1), 8, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtTotalDiscountMoney);
      FExcel.TypeText(iTotalRow, 9, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtTotalCashMoney);
      FExcel.TypeText(iTotalRow, 10, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtFareCost);
      FExcel.TypeText(iTotalRow, 11, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtFixCost);
      FExcel.TypeText(iTotalRow, 12, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtProfitMoney);
      FExcel.TypeText(iTotalRow, 13, sTotalFieldName);


      sTotalFieldName := AProductList.GetTotalValue(tvtFareRate);
      FExcel.TypeText((iTotalRow + 1), 13, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtDiscountRate);
      FExcel.TypeText((iTotalRow + 1), 17, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtProfitMoney);
      FExcel.TypeText((iTotalRow + 2), 13, sTotalFieldName);

      sTotalFieldName := AProductList.GetTotalValue(tvtProfitRate);
      FExcel.TypeText((iTotalRow + 2), 17, sTotalFieldName);
    end;
  end
  else
  begin
    FExcel.InsertRowExt(ARow);
    
    fr.FromCell.Row := ARow;
    fr.FromCell.Col := 1;
    fr.ToCell.Row := fr.FromCell.Row;
    fr.ToCell.Col := 18;
    FExcel.SetRangeFonts(fr.FromCell.Row, fr.ToCell.Row, 1, 18, clBlack, [], 10);

    vData := VarArrayCreate([1, 1, 1, 18], varVariant);

    for i := 1 to 18 do
    begin
      vData[1, i] := '';
    end;
  end;  
  
  AFont := TFont.Create;
  try
    AFont.Size := 10;
    CellPro.Font := AFont;
    CellPro.Applyed := True;
    CellPro.BorderLineStyle := blLine;
    FExcel.FillProperty(fr, CellPro);
    FExcel.FillData(fr, vData);
    FExcel.SetRangeAlign(fr, haCenter);
  finally
    FreeAndNil(AFont);
  end;
  {* 设置左对齐 *}
  FExcel.SetRangeAlignDefault(fr);
end;

//procedure TReportWriteManger.SetDestFileName(const ADestFileName: string);
//begin
//  FReportDest := ADestFileName;
//end;

procedure TReportWriteManger.WriteTotalExcel(ADataList: TList;
  AOutputExcelType: TOutputExcelType;
  AOutPutExcelCondition: TOutPutExcelCondition);
var
  fr: TFillRange;
  iRegionCount, iRowNo, i, iColAdd, iTotalRow: Integer;
  vData: OleVariant;
  AFont: TFont;
  CellPro: TCellProperty;
  AListItem: TListItem;
  sFieldName, sTotalFieldName: string;
  iStartRow, iStartCol, iColCount: Integer;
  AOutPutTotalResult: TOutPutTotalResult;
  iTotalCount: Integer;
  dTotalSaleMoney, dAvgSaleByOneBox, dProduceMaterial, dProduceMaterialRate,
  dProduceCost, dProduceCostRate, dProduceTotal, dProduceTotalRate,
  dTotalFareCost, dTotalDiscountMoney, dTotalYearEndReward, dTotalOtherCost,
  dSaleTotal, dSaleTotalRate, dFinanceTotal, dFinanceTotalRate, dTotalCost,
  dTotalCostRate, dTotalProfit, dTotalProfitRate: Double;

  iSumTotalCount: Integer;
  dSumTotalSaleMoney, dSumAvgSaleByOneBox, dSumProduceMaterial, dSumProduceMaterialRate,
  dSumProduceCost, dSumProduceCostRate, dSumProduceTotal, dSumProduceTotalRate,
  dSumTotalFareCost, dSumTotalDiscountMoney, dSumTotalYearEndReward, dSumTotalOtherCost,
  dSumSaleTotal, dSumSaleTotalRate, dSumFinanceTotal, dSumFinanceTotalRate, dSumTotalCost,
  dSumTotalCostRate, dSumTotalProfit, dSumTotalProfitRate: Double;
begin
  FExcel.ActiveSheetNo := 1;

  case AOutputExcelType of
    oetAllArea, oetAllClient, oetAllMonth, oetAllDay:
    begin
      iStartRow := 5;
      iColCount := 23;
      iStartCol := 2;
    end;
    oetAllClientByOneArea,
    oetAllMonthByOneArea,
    oetAllMonthByOneClient,
    oetAllDayByOneClient:
    begin
      iStartRow := 5;
      iColCount := 24;
      iStartCol := 3;
    end;  
  else ;
  end;

  iSumTotalCount := 0;
  dSumTotalSaleMoney := 0;
  dSumProduceMaterial := 0;
  dSumProduceCost := 0;
  dSumTotalFareCost := 0;
  dSumTotalDiscountMoney := 0;
  dSumTotalYearEndReward := 0;
  dSumTotalOtherCost := 0;
  dSumFinanceTotal := 0;
  
  iRegionCount := ADataList.Count;
  if (iRegionCount > 0) then
  begin
    for i := 0 to iRegionCount - 1 do
    begin
      FExcel.InsertRowExt(iStartRow);   
    end;
    fr.FromCell.Row := iStartRow;
    fr.FromCell.Col := iStartCol;
    fr.ToCell.Row := fr.FromCell.Row + iRegionCount - 1;
    fr.ToCell.Col := iColCount;
    FExcel.SetRangeFonts(fr.FromCell.Row, fr.ToCell.Row, 1, iColCount, clBlack, [], 10);

    case AOutputExcelType of
      oetAllClientByOneArea,
      oetAllMonthByOneArea:
      begin
        FExcel.TypeText(5, 2, AOutPutExcelCondition.FAreaName);
      end;  
      oetAllMonthByOneClient,
      oetAllDayByOneClient:
      begin
        FExcel.TypeText(5, 2, AOutPutExcelCondition.FClientName);
      end;  
    else ;
    end;

    case AOutputExcelType of
      oetAllClientByOneArea,
      oetAllMonthByOneArea,
      oetAllMonthByOneClient,
      oetAllDayByOneClient:
      begin
        FExcel.CombineCells(5, 2, (5 + iRegionCount), 2);
      end;  
    else ;
    end;

    vData := VarArrayCreate([1, iRegionCount, 1, (iColCount - iStartCol + 1)], varVariant);

    iRowNo := 0;
    for i := 0 to iRegionCount - 1 do
    begin
      Inc(iRowNo);

      FExcel.TypeText((iRowNo + 4), 1, IntToStr(iRowNo));

      AOutPutTotalResult := TOutPutTotalResult(ADataList.Items[i]);
      iTotalCount := AOutPutTotalResult.FTotalCount;
      dTotalSaleMoney := AOutPutTotalResult.FTotalSaleMoney;
      dProduceMaterial := AOutPutTotalResult.FTotalProduceMaterial;
      dProduceCost := AOutPutTotalResult.FTotalProduceCost;
      dTotalFareCost := AOutPutTotalResult.FTotalFareCost;
      dTotalDiscountMoney := AOutPutTotalResult.FTotalDiscountMoney;
      dTotalYearEndReward := AOutPutTotalResult.FTotalYearEndReward;
      dTotalOtherCost := AOutPutTotalResult.FTotalOtherCost;
      dFinanceTotal := AOutPutTotalResult.FTotalFinanceCost;

      dAvgSaleByOneBox := dTotalSaleMoney / iTotalCount;
      dProduceMaterialRate := dProduceMaterial / dTotalSaleMoney;
      dProduceCostRate := dProduceCost / dTotalSaleMoney;
      dProduceTotal := dProduceMaterial + dProduceCost;
      dProduceTotalRate := dProduceTotal / dTotalSaleMoney;
      dSaleTotal := dTotalFareCost + dTotalDiscountMoney + dTotalYearEndReward + dTotalOtherCost;
      dSaleTotalRate := dSaleTotal / dTotalSaleMoney;
      dFinanceTotalRate := dFinanceTotal / dTotalSaleMoney;
      dTotalCost := dProduceTotal + dSaleTotal + dFinanceTotal;
      dTotalCostRate := dTotalCost / dTotalSaleMoney;
      dTotalProfit := dTotalSaleMoney - dTotalCost;
      dTotalProfitRate := dTotalProfit / dTotalSaleMoney;

      iSumTotalCount := GetOperaterResult(iSumTotalCount, iTotalCount);
      dSumTotalSaleMoney := GetOperaterResult(dSumTotalSaleMoney, dTotalSaleMoney);
      dSumProduceMaterial := GetOperaterResult(dSumProduceMaterial, dProduceMaterial);
      dSumProduceCost := GetOperaterResult(dSumProduceCost, dProduceCost);
      dSumTotalFareCost := GetOperaterResult(dSumTotalFareCost, dTotalFareCost);
      dSumTotalDiscountMoney := GetOperaterResult(dSumTotalDiscountMoney, dTotalDiscountMoney);
      dSumTotalYearEndReward := GetOperaterResult(dSumTotalYearEndReward, dTotalYearEndReward);
      dSumTotalOtherCost := GetOperaterResult(dSumTotalOtherCost, dTotalOtherCost);
      dSumFinanceTotal := GetOperaterResult(dSumFinanceTotal, dFinanceTotal);

      dSumAvgSaleByOneBox := dSumTotalSaleMoney / iSumTotalCount;
      dSumProduceMaterialRate := dSumProduceMaterial / dSumTotalSaleMoney;
      dSumProduceCostRate := dSumProduceCost / dSumTotalSaleMoney;
      dSumProduceTotal := dSumProduceMaterial + dSumProduceCost;
      dSumProduceTotalRate := dSumProduceTotal / dSumTotalSaleMoney;
      dSumSaleTotal := dSumTotalFareCost + dSumTotalDiscountMoney + dSumTotalYearEndReward + dSumTotalOtherCost;
      dSumSaleTotalRate := dSumSaleTotal / dSumTotalSaleMoney;
      dSumFinanceTotalRate := dSumFinanceTotal / dSumTotalSaleMoney;
      dSumTotalCost := dSumProduceTotal + dSumSaleTotal + dSumFinanceTotal;
      dSumTotalCostRate := dSumTotalCost / dSumTotalSaleMoney;
      dSumTotalProfit := dSumTotalSaleMoney - dSumTotalCost;
      dSumTotalProfitRate := dSumTotalProfit / dSumTotalSaleMoney;

      vData[iRowNo, 1] := AOutPutTotalResult.FGroupFieldValue;
      vData[iRowNo, 2] := iTotalCount;
      vData[iRowNo, 3] := GetFloatFormat(dTotalSaleMoney, 2);
      vData[iRowNo, 4] := GetFloatFormat(dAvgSaleByOneBox, 2);
      vData[iRowNo, 5] := GetFloatFormat(dProduceMaterial, 2);
      vData[iRowNo, 6] := GetFloatFormat(dProduceMaterialRate); //百分比
      vData[iRowNo, 7] := GetFloatFormat(dProduceCost, 2);
      vData[iRowNo, 8] := GetFloatFormat(dProduceCostRate);   //百分比
      vData[iRowNo, 9] := GetFloatFormat(dProduceTotal, 2);
      vData[iRowNo, 10] := GetFloatFormat(dProduceTotalRate);  //百分比
      vData[iRowNo, 11] := GetFloatFormat(dTotalFareCost, 2);
      vData[iRowNo, 12] := GetFloatFormat(dTotalDiscountMoney, 2);
      vData[iRowNo, 13] := GetFloatFormat(dTotalYearEndReward, 2);
      vData[iRowNo, 14] := GetFloatFormat(dTotalOtherCost, 2);
      vData[iRowNo, 15] := GetFloatFormat(dSaleTotal, 2);
      vData[iRowNo, 16] := GetFloatFormat(dSaleTotalRate);  //百分比
      vData[iRowNo, 17] := GetFloatFormat(dFinanceTotal, 2);
      vData[iRowNo, 18] := GetFloatFormat(dFinanceTotalRate);  //百分比
      vData[iRowNo, 19] := GetFloatFormat(dTotalCost, 2);
      vData[iRowNo, 20] := GetFloatFormat(dTotalCostRate);    // 百分比
      vData[iRowNo, 21] := GetFloatFormat(dTotalProfit, 2);
      vData[iRowNo, 22] := GetFloatFormat(dTotalProfitRate);  //百分比
    end;

    iTotalRow := 5 + iRegionCount;
    iColAdd := 0;
    case AOutputExcelType of
      oetAllClientByOneArea,
      oetAllMonthByOneArea,
      oetAllMonthByOneClient,
      oetAllDayByOneClient:
      begin
        iColAdd := 1;
      end;  
    else ;
    end;
    //求合计
    if iTotalRow > 0 then
    begin
      sTotalFieldName := IntToStr(iSumTotalCount);
      FExcel.TypeText(iTotalRow, (3 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalSaleMoney, 2);
      FExcel.TypeText(iTotalRow, (4 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumAvgSaleByOneBox, 2);
      FExcel.TypeText(iTotalRow, (5 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumProduceMaterial, 2);
      FExcel.TypeText(iTotalRow, (6 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumProduceMaterialRate, 4);
      FExcel.TypeText(iTotalRow, (7 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumProduceCost, 2);
      FExcel.TypeText(iTotalRow, (8 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumProduceCostRate, 4);
      FExcel.TypeText(iTotalRow, (9 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumProduceTotal, 2);
      FExcel.TypeText(iTotalRow, (10 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumProduceTotalRate, 4);
      FExcel.TypeText(iTotalRow, (11 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalFareCost, 2);
      FExcel.TypeText(iTotalRow, (12 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalDiscountMoney, 2);
      FExcel.TypeText(iTotalRow, (13 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalYearEndReward, 2);
      FExcel.TypeText(iTotalRow, (14 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalOtherCost, 2);
      FExcel.TypeText(iTotalRow, (15 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumSaleTotal, 2);
      FExcel.TypeText(iTotalRow, (16 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumSaleTotalRate, 4);
      FExcel.TypeText(iTotalRow, (17 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumFinanceTotal, 2);
      FExcel.TypeText(iTotalRow, (18 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumFinanceTotalRate, 4);
      FExcel.TypeText(iTotalRow, (19 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalCost, 2);
      FExcel.TypeText(iTotalRow, (20 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalCostRate, 4);
      FExcel.TypeText(iTotalRow, (21 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalProfit, 2);
      FExcel.TypeText(iTotalRow, (22 + iColAdd), sTotalFieldName);

      sTotalFieldName := GetFloatFormat(dSumTotalProfitRate, 4);
      FExcel.TypeText(iTotalRow, (23 + iColAdd), sTotalFieldName);
    end;
  end
  else
  begin
    FExcel.InsertRowExt(iStartRow);
    
    fr.FromCell.Row := iStartRow;
    fr.FromCell.Col := iStartCol;
    fr.ToCell.Row := fr.FromCell.Row;
    fr.ToCell.Col := iColCount;
    FExcel.SetRangeFonts(fr.FromCell.Row, fr.ToCell.Row, 1, iColCount, clBlack, [], 10);

    vData := VarArrayCreate([1, 1, 1, iColCount - iStartRow + 1], varVariant);

    for i := 1 to (iColCount - iStartRow + 1) do
    begin
      vData[1, i] := '';
    end;
  end;  
  
  AFont := TFont.Create;
  try
    AFont.Size := 10;
    CellPro.Font := AFont;
    CellPro.Applyed := True;
    CellPro.BorderLineStyle := blLine;
    FExcel.FillProperty(fr, CellPro);
    FExcel.FillData(fr, vData);
    FExcel.SetRangeAlign(fr, haCenter);
  finally
    FreeAndNil(AFont);
  end;
  {* 设置左对齐 *}
  FExcel.SetRangeAlignDefault(fr);
end;

end.
 