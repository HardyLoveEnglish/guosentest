{-------------------------------------------------------------------------------

   单元名称：ReportParent
   创建日期：2004-10-10
   创 建 人：weier.huang

   功能描述：Fleet报表父类，所有的报表都是继承于它。它提供了所有报表的一个统一
             接口，使得报表的管理、维护与扩展更加的容易。


   版权所有：珠海鼎利通信科技发展有限公司


   修改记录：

      日  期：    描  述：                                           修 订 人：
    --------------------------------------------------------------------------
   2005.04.22    增加报表类型rsJxCustom，专门为江西移动定制的报表   weier.huang

-------------------------------------------------------------------------------}

unit ReportParent;

interface

uses
  Classes, SysUtils, MyExcelReport, ActiveX;

const
  CIFtpDropRate = 0;             //FTP Drop的阀值
  CIFtpFullDownloadRate = 0;     //FTP Download的阀值

  CITotalProgress = 1000;    //报表状态进度条的最大值；
type
  TReportStyle = (rsUniversal, rsJmcc, rsGmcc, rsCompare, rsJxCustom, rsSmsReport,rsbenchmarkingReport,rsSupplementary,rsGMCCWordReport,rsChallengeTgt,rsChinaMobileGPRS);

  //网络指标定义    增加网络指标需要增加其对应的名称和改变总个数常量值
  TNetworkIndex = (niCoverageRate, niCallQuality, niCallSuccRate, niDropCallRate,
    niHandOverSuccRate, niTA, niVoiceUp, niVoiceDown, niFtpDownloadSpeed, niFtpDropRate);
  TNetworkIndexs = set of TNetworkIndex;


  //生成报表状态事件
  TReportStatus = procedure (Sender: TObject; Status: string; Total: integer;
    Percent: integer) of Object;

  TReportParent = class
  private
    FReportStyle: TReportStyle;
    FReportName: String;
    FReportStatus: TReportStatus;
    FEnableStatus: Boolean;
    FReportTitle: String;
    FSavePath: String;
    FDatas: TList;

    function GetDataCount: Integer;
    function GetDataItem(Index: Integer): Pointer;
  protected

    FExcel: TExcelReport;

    FReportMessage: String;
    FTotalProgress: Integer;
    FCurProgress: Integer;
    FPhaseProgress: Integer;

    FVersion: Integer;
    FSaveAsHtml: Boolean;

    function SaveReport: Boolean;

    procedure FillRangeNoInc(iRow, iCol, iIncRow, iIncCol: Integer; bCombine: Boolean;
      sValue: String);
    procedure FillRangeIncCol(iRow, iIncRow, iIncCol: Integer; bCombine: Boolean;
      sValue: String; var iCol: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    property ReportName: String read FReportName write FReportName;
    property ReportTitle: String read FReportTitle write FReportTitle;
    property SavePath: String read FSavePath write FSavePath;
    property ReportStyle: TReportStyle read FReportStyle write FReportStyle;
    property ReportStatus: TReportStatus read FReportStatus write FReportStatus;
    property EnableStatus: Boolean read FEnableStatus write FEnableStatus;
    property DataCount: Integer read GetDataCount;
    property Items[Index: Integer]: Pointer read GetDataItem;
    property Version: Integer read FVersion write FVersion;
    property SaveAsHtml: Boolean read FSaveAsHtml write FSaveAsHtml;

    function AddData(AData: Pointer): Integer;
    procedure DeleteData(Index: Integer);
    procedure ClearAllDatas;
    procedure FreeAllDatas;

    function LoadFromStream(AStream: TStream): boolean; virtual;
    procedure SaveToStream(AStream: TStream); virtual;

    function BuildReport: Boolean; virtual;
    function AddParam(AParam: Pointer): Boolean; virtual;
  end;

const
  CSNetworkIndexNames: array [TNetworkIndex] of string = ('Coverage Rate',
    'Voice Quality', 'Call Success Rate', 'Drop Call Rate', 'Handover Success Rate',
    'TA', 'Voice Up', 'Voice Down', 'FTP Download Speed(KB/s)', 'FTP Drop Rate');
  CSCNNetworkIndexNames: array [TNetworkIndex] of string = ('覆盖率', '话音质量',
    '呼叫成功率', '掉话率', '切换成功率', 'TA', '语音评估上行平均值',
    '语音评估下行平均值', 'FTP下载速率(KB/s)', 'FTP掉线比');
  CINetworkIndexCount = 10;

  CSReportStyle: array[TReportStyle] of string = ('Default', 'Daily Report',
    'Summary Report', 'Compare Report', 'JX Custom Report', 'SMS Test Report','Benchmarking Report','Supplementary Report','GMCC Word Report','Challenge Target Report','China Mobile GPRS Report');

  function GetReportStyleByName(sName: String): TReportStyle;

implementation

uses uFunc, Excel_TLB;

function GetReportStyleByName(sName: String): TReportStyle;
var
  AStyle: TReportStyle;
begin
  result := rsUniversal;
  for AStyle := Low(TReportStyle) to High(TReportStyle) do
    if CSReportStyle[AStyle] = sName then
    begin
      result := AStyle;
      break;
    end;
end;

{ TReportParent }

function TReportParent.AddParam(AParam: Pointer): Boolean;
begin
  result := True;
end;

function TReportParent.AddData(AData: Pointer): Integer;
begin
  result := FDatas.Add(AData);
end;

function TReportParent.BuildReport: Boolean;
begin
  result := False;
end;

procedure TReportParent.ClearAllDatas;
begin
  FDatas.Clear;
end;

constructor TReportParent.Create;
begin
  CoInitialize(nil);
  FDatas := TList.Create;
  FEnableStatus := false;
  FReportMessage := '';
  FTotalProgress := CITotalProgress;
  FCurProgress := 0;
  FPhaseProgress := 0;
  FSavePath := ExtractFilePath(ParamStr(0));
  FReportStyle := rsUniversal;
  FSaveAsHtml := False;
  FVersion := 0;
  try
    FExcel := TExcelReport.Create(false);
    {$IFDEF DEBUG}
    FExcel.Visible := True;
    {$ELSE}
    FExcel.Visible := False;
    {$ENDIF}
  except
  end;
end;

procedure TReportParent.DeleteData(Index: Integer);
begin
  if (Index >= 0) and (Index < FDatas.Count) then
    FDatas.Delete(Index);
end;

destructor TReportParent.Destroy;
begin
  FDatas.Clear;
  FDatas.Free;
  FreeAndNil(FExcel);

  CoUninitialize;
  inherited;
end;

function TReportParent.GetDataCount: Integer;
begin
  result := 0;
  if Assigned(FDatas) then
    result := FDatas.Count;
end;

function TReportParent.GetDataItem(Index: Integer): Pointer;
begin
  result := nil;
  if (FDatas <> nil) and (Index >= 0) and (Index < FDatas.Count) then
    result := FDatas.Items[Index];
end;

function TReportParent.SaveReport: Boolean;
var
  sFileName: String;
begin
  result := False;
  sFileName := IncludeTrailingPathDelimiter(FSavePath);
  try
    if not DirectoryExists(sFileName) then
      if not CreateDir(sFileName) then exit;

    sFileName := sFileName + FReportName;
    if FileExists(sFileName + '.xls') then
      if not DeleteFile(sFileName + '.xls') then exit;
    sFileName := sFileName + '.xls';
    if FExcel <> nil then
    begin
      FExcel.Save(sFileName);

      if FSaveAsHtml then
      begin
        if FileExists(sFileName + '.html') then
          if not DeleteFile(sFileName + '.html') then exit;

        FExcel.Save(sFileName, xlHtml);
      end;
      result := True;
    end;
  except
    result := False;
  end;
end;

function TReportParent.LoadFromStream(AStream: TStream): boolean;
begin
  result := True;
  if AStream = nil then exit;
  try
    FReportName := ReadStringFromStream(AStream);
    FReportTitle := ReadStringFromStream(AStream);
    FSavePath := ReadStringFromStream(AStream);
  except
    result := False;
  end;
end;

procedure TReportParent.SaveToStream(AStream: TStream);
begin
  if AStream = nil then exit;
  WriteStringToStream(FReportName, AStream);
  WriteStringToStream(FReportTitle, AStream);
  WriteStringToStream(FSavePath, AStream);
end;

procedure TReportParent.FillRangeIncCol(iRow, iIncRow, iIncCol: Integer;
  bCombine: Boolean; sValue: String; var iCol: Integer);
var
  ACell: TFillRange;
  ARange: Variant;
begin
  ACell.FromCell.Row := iRow;
  ACell.FromCell.Col := iCol;
  ACell.ToCell.Row := iRow + iIncRow;
  ACell.ToCell.Col := iCol + iIncCol;
  if bCombine then
    FExcel.CombineCells(ACell);
  ARange := FExcel.GetRange(ACell);
  ARange.Value := sValue;

  Inc(iCol, iIncCol + 1);
end;

procedure TReportParent.FillRangeNoInc(iRow, iCol, iIncRow,
  iIncCol: Integer; bCombine: Boolean; sValue: String);
var
  ACell: TFillRange;
  ARange: Variant;
begin
  ACell.FromCell.Row := iRow;
  ACell.FromCell.Col := iCol;
  ACell.ToCell.Row := iRow + iIncRow;
  ACell.ToCell.Col := iCol + iIncCol;
  if bCombine then
    FExcel.CombineCells(ACell);
  ARange := FExcel.GetRange(ACell);
  ARange.Value := sValue;
end;

procedure TReportParent.FreeAllDatas;
var
  i: Integer;
begin
  for i := Pred(FDatas.Count) downto 0 do
    ClearObjectList(FDatas, False);
end;

end.
