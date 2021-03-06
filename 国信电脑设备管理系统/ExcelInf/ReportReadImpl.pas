unit ReportReadImpl;

interface

uses
  ReportParent, Variants, MyExcelReport, Graphics, Math, DateUtils, SysUtils,
  uDataManager, uDataModel, Windows, lyhTools;

type
  TReportReadManger = class(TReportParent)
  private
    FTestTemplateFile: string;
    procedure ReadOneProduct(AvData: OleVariant; ARow: Integer; AMainProduct: TMainProduct);
  public
    constructor Create(const ATestTemplateFile: string);
    destructor Destroy; override;
    procedure ReadProductList(ARow: Integer; AProductList: TProductList);
  end;

implementation

uses
  uControlInf;

{ TReportReadManger }

constructor TReportReadManger.Create(const ATestTemplateFile: string);
begin
  inherited Create;

  KillOffice;
  FExcel.OpenFile(ATestTemplateFile, True);
  FExcel.ActiveSheetNo := 1;
end;

destructor TReportReadManger.Destroy;
begin
  FExcel.Close(False);
  inherited;
end;

procedure TReportReadManger.ReadOneProduct(AvData: OleVariant;
  ARow: Integer; AMainProduct: TMainProduct);
begin

end;

function VIsInt(v: Variant): Boolean;
begin
  Result := VarType(v) in [varSmallInt, varInteger, varBoolean, varShortInt,
                         varByte, varWord, varLongWord, varInt64];
end;

function VIsFloat(v: Variant): Boolean;
begin
  Result := VarType(v) in [varSingle, varDouble, varCurrency];
end;

function ChangeStrToDouble(const sSrcData: string): Double;
begin
  if Pos('%', sSrcData) > 0 then
    Result := StrToFloat(ReplaceString(sSrcData, '%', '')) / 100
  else
    Result := StrToFloat(sSrcData);
end;  

procedure TReportReadManger.ReadProductList(ARow: Integer;
  AProductList: TProductList);
var
  iRow, iGUIDSeqID, iProductSeqID: Integer;
  sProductName: string;
  iProductCount: Integer;
  sPromotionRate: string;
  sStandardPromotionRate: string;
  dPromotionRate: Double;
  dStandardPromotionRate: Double;
  dPrice: Double;
  dFareCost: Double;
  sGrossMarginRate: string;
  dGrossMarginRate: Double;
  sFixCostRate: string;
  dFixCostRate: Double;
  dProduceCostRate: Double;
  dFinanceCostRate: Double;
  AMainProduct: TMainProduct;
begin
  iRow := 2;
  AProductList.ClearAllProduct;
  while VIsFloat(FExcel.ReadText(iRow, 1)) do
  begin
    iGUIDSeqID := FExcel.ReadText(iRow, 1);
    sProductName := FExcel.ReadText(iRow, 2);
    iProductCount := FExcel.ReadText(iRow, 3);
    sStandardPromotionRate := FExcel.ReadText(iRow, 4);
    sPromotionRate := FExcel.ReadText(iRow, 5);
    dPromotionRate := ChangeStrToDouble(sPromotionRate);
    dStandardPromotionRate := ChangeStrToDouble(sStandardPromotionRate);
    dPrice := FExcel.ReadText(iRow, 7);
    dFareCost := FExcel.ReadText(iRow, 11);
    sGrossMarginRate := FExcel.ReadText(iRow, 16);
    dGrossMarginRate := ChangeStrToDouble(sGrossMarginRate);
    sFixCostRate := FExcel.ReadText(iRow, 17);
    dFixCostRate := ChangeStrToDouble(sFixCostRate);

    iProductSeqID := gGlobalControl.GetProductSeqIdByName(sProductName);
    AMainProduct := TMainProduct.Create(iGUIDSeqID, iProductSeqID, dPrice, dGrossMarginRate, dStandardPromotionRate, dProduceCostRate, dFinanceCostRate, sProductName);
    AMainProduct.ProductCount := iProductCount;
    AMainProduct.PromotionRate := dPromotionRate;
    AMainProduct.FareCost := dFareCost;
    AMainProduct.FixCostRate := dFixCostRate;
    AProductList.AddOneProduct(AMainProduct);

    Inc(iRow);
  end;
end;

end.
