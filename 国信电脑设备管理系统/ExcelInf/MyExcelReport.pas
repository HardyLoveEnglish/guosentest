{-----------------------------------------------------------------------------
 Unit Name: MyExcelReport
 Author:    ZJB
 Project:   Fleet Statistic DingLi  Comnuniations Inc.
 Purpose:   Excel report
 History:
-----------------------------------------------------------------------------}


unit MyExcelReport;

interface

uses
  Classes, Windows, ComObj, ActiveX, Variants, Excel_TLB, Graphics, SysUtils,
  Math, jpeg;

const
  cTitleColor1 = 37; //$00FFCC99;RGB(153,204,255)
  cTitleColor2 = 36; //$0099FFFF;RGB(255,255,153)
  cTitleColor3 = 22; //$008080FF;RGB(255,128,128)

  //Excel 2003以上版本
  xlWorkbookDefault = 51;

type
  TExcelReport = class;

  TFileFormat = (ffXLS, ffHTM);

  TBorderWeight = (bwHairline,bwMedium,bwThick,bwThin);
  TBorderLineStyle = (blContinuous, blDash, blDashDot, blDashDotDot,
                      blDot, blDouble, blSlantDashDot, blLine, blNone);
  //水平对齐方式
  THAlignment = (haGeneral, haLeft, haRight, haCenter);
  //垂直对齐方式
  TVAlignment = (vaGeneral, vaTop, vaBottom, vaCenter);

  PCellProperty = ^TCellProperty;
  TCellProperty = record
     Text: string;
     Font:  TFont;
     Background: TColor;
     Align: THAlignment;
     Applyed: boolean;
     BorderColor: TColor;
     BorderWeight: TBorderWeight;
     BorderLineStyle: TBorderLineStyle;
  end;

  PFillCell = ^TFillCell;
  TFillCell = record
    Row: integer;
    Col: integer;
  end;

  PFillRange = ^TFillRange;
  TFillRange = record
    FromCell, ToCell: TFillCell;
  end;

  PFillFrmaeColor = ^TFillFrameColor;
  TFillFrameColor = record
    Color: TColor;
    Lefted: boolean;
    Righted: boolean;
    Toped: boolean;
    Bottomed: boolean;
    BandWidth: integer;
  end;

  //
  TOneColChart = record
    XValues: String;
    Values: String;
    Name: String;
  end;
  TColChartList = array of TOneColChart;
  //
  TMultiColsChart = record
    SourceSheetName: String;
    SheetName: String;
    Title: String;
    XAxisTitle: String;
    YAxisTitle: String;
    MultiCols: TColChartList;
  end;

  TChartOption = record
    ChartType: Cardinal;
    DisLegend: Boolean;
    LegendPos: Cardinal;
    DisAvgLine: Boolean;
    DisData: Boolean;
  end;


  TExcelReport = class
  private
    FXlApp, FXlBook, FXlSheet, FXlSheets : Variant;

    FVisible: boolean;
    FActiveSheetNo: integer;
    FFillFrameColor: TFillFrameColor;
    FCaption: string;
    FExcelValided: boolean;
    FShowMess: boolean;
    procedure SetVisible(const Value: boolean);
    procedure SetActiveSheetNo(const Value: integer);
    procedure SetFillFrameColor(const Value: TFillFrameColor);
    procedure SetCaption(const Value: string);
    function  GetLastRow: integer;
    function  GetLastCol: integer;
    function  GetCol: integer;
    function  GetRow: integer;
    function  GetFirstCol: integer;
    function  GetFirstRow: integer;
    function  GetSheetsCaption(SheetNo: integer): string;
    procedure SetActiveSheetCaption(const Value: string);
    procedure SetSheetsCaption(SheetNo: integer; const Value: string);
    function  GetActiveSheetCaption: string;
    procedure SetDefaultFont;
    procedure SetShowMess(const Value: boolean);
    function  GetSheetCount: integer;
    function GetStyles: Variant;
    function VIsInt(v: Variant): Boolean;
    function VIsFloat(v: Variant): Boolean;
    function VIsDateTime(v: Variant): Boolean;
  public
    constructor create(aShowMess: boolean);
    destructor  destroy;override;

    procedure HighLightCurrentRow(const RowIndex: Integer; ColStart: Integer; ColEnd: Integer);
    //增加选项BCreate来标识是否重新创建新的Excel fansheng 2008-1-22
    function   Open(BCreate: Boolean = False): boolean;
    function   OpenFile(FileName: string; BCreate: Boolean = False): boolean;
    function   GenerateDestFile(TemplateFile: string; DestFile: string): Boolean;
    function   OpenFileEx(TemplateFile: string; DestFile: string;  BCreate: Boolean = False): Boolean;
    procedure  Close(SaveAll: boolean);
    procedure  SaveEx(FileName: string; Format: XlFileFormat = xlWorkbookDefault);
    procedure Save(FileName: string; Format: XlFileFormat = xlNormal);
    // Added by Administrator 2012-5-11 13:48:00 增加删除批注的方法
    procedure  ClearComments;

    procedure  NewSheet;
    procedure  CopyCurrentToLast(NewSheetName: string);
    procedure  ClearSheetData;
    procedure  ClearSheets;

    procedure SetRangeFonts(const ARange: Variant;
       const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer = 9); overload;
    procedure SetRangeFontsExEx(const ARange: Variant;
       const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer; ABackGroupInvalid: Boolean = False;
       ABackGroup: Integer = cTitleColor1); overload;
    procedure SetRangeFontsExEx(const fr: TFillRange;
       const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer; ABackGroupInvalid: Boolean = False;
       ABackGroup: Integer = cTitleColor1); overload;
    procedure SetRangeFonts(const RowStart, RowEnd, ColStart, ColEnd: Integer;
       const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer = 9); overload;

    procedure SetRangeFonts(const ARange: Variant; const AColor: TColor; const ASize: Integer = 9); overload;
    procedure SetRangeFonts(const AFillRange: TFillRange; const AColor: TColor; const ASize: Integer = 9); overload;

    procedure SetRangeFontsEx(const ARange: TFillRange;
      const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer; ABackGroup: Integer;
      const FontName: TFontDataName); overload;
    procedure SetRangeFontsEx(const RowStart, RowEnd, ColStart, ColEnd: Integer;
       const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer;
       ABackGroup: Integer; const FontName: TFontDataName); overload;

    procedure SetOutPutFormat(const FillRange: TFillRange; FormatStr: string = '@'); overload;
    procedure SetOutPutFormat(const ARange: Variant; const FormatStr: string = '@'); overload;
    procedure SetOutPutFormat(const RowStart, RowEnd, ColStart, ColEnd: Integer;
      const FormatStr: string = '@'); overload;

    function SetRangeRowHeight(Range: TFillRange; Height: single): boolean;
    function __SetRangeRowHeight(Range: variant; Height: single): boolean;

    function  Copy(Range: TFillRange): boolean;
    function  _Copy(Range: Variant): boolean;

    function CopyRangeEx(SrcRange, DstRange: TFillRange): Boolean;
    function  CopyRange(SrcRange, DstRange: TFillRange): boolean;
    function  _CopyRange(SrcRange, DstRange: variant): boolean;

    function  InsertRowCount(Range: TFillRange; Count: integer): boolean;
    function  _InsertRowCount(Range: variant; Count: integer): boolean;

    function  InsertRow(Range: TFillRange): boolean;
    function  _InsertRow(Range: variant): boolean;
    function InsertRowExt(iRow: Integer): Boolean;
    function InsertRowM(iRow, iRowNum: Integer): Boolean;

    function  InsertCol(Range: TFillRange): boolean;
    function  _InsertCol(Range: variant): boolean;


    function GetRange(ColStart: Integer; ColEnd: Integer; RowStart: Integer; RowEnd: Integer): Variant; overload;
    function GetRange(FillRange: TFillRange): Variant; overload;    //选择范围
    function  GetRangeData(FillRange: TFillRange): Variant;
    function  _GetRangeData(Range: variant): variant;

    function  FillProperty(FillRange: TFillRange; CellProperty: TCellProperty): boolean;
    function  _FillProperty(Range: variant; CellProperty: TCellProperty): boolean;

    function  SetRowHeight(Row: integer; Height: integer): boolean;
    function  SetColWidth(Col: Integer; Width: single): boolean;

    function  CombineCells(FillRange: TFillRange): boolean; overload;  //合并单元格
    function  CombineCells(const RowS, ColS, RowE, ColE: Integer): Boolean; overload;
    function  _CombineCells(Range: variant): boolean;

    function  FillData(FillRange: TFillRange; arrVar: Variant): boolean; //填充数据

    function  _FillData(Range: Variant; arrVar: variant): boolean;

    function SetRangeWrapText(AFillRange: TFillRange; bWrap: Boolean): Boolean; overload;
    function SetRangeWrapText(sRow: Integer; sCol: Integer; eRow: Integer; eCol: Integer; bWrap: Boolean): Boolean; overload;
    function GetRangeStyle(FillRange: TFillRange): Variant;
    function SetRangeStyle(FillRange: TFillRange; AStyle: Variant): Boolean;

    function GetFillRange(const ColStart, ColEnd, RowStart, RowEnd: Integer): TFillRange;
    function  FillColor(FillRange: TFillRange; Color: TColor): boolean; overload;
    function  FillColor(RowStart, RowEnd, ColStart, ColEnd: Integer; Color: TColor): Boolean; overload;
    function  _FillColor(Range: Variant; Color: TColor): boolean;

    function  SetRangeFont(FillRange: TFillRange; Font: TFont): boolean;
    function  _SetRangeFont(Range: Variant; Font: TFont): boolean;
    function SetSheetFont(AFont: TFont): Boolean;
    function  SetRangeBorder(FillRange: TFillRange;
                             BorderColor: TColor;
                             BorderWeight: TBorderWeight;
                             BorderLineStyle: TBorderLineStyle; Inner: boolean = false): Boolean; overload;

    function  SetRangeBorder(SRow: Integer;
                             SCol: Integer;
                             ERow: Integer;
                             ECol: Integer;
                             BorderColor: TColor;
                             BorderWeight: TBorderWeight;
                             BorderLineStyle: TBorderLineStyle; Inner: boolean = false): Boolean; overload;
    function  _SetRangeBorder(Range: Variant;
                             BorderColor: TColor;
                             BorderWeight: TBorderWeight;
                             BorderLineStyle: TBorderLineStyle; Inner: boolean = false): boolean ;

    {* 下面两个方法对于OFFICE2003及以下版本有效 *}
    function  SetRangeAlign(FillRange: TFillRange; Align: THAlignment): boolean;
    function  _SetRangeAlign(Range: Variant; Align: THAlignment): boolean;
    {* 该函数针对Excel2007-2010有效 *}
    function SetRangeAlignDefault(FillRange: TFillRange): Boolean; overload;
    function SetRangeAlignDefault(sRow: Integer; sCol: Integer; eRow: Integer; eCol: Integer): Boolean; overload;

    function  SetHorizontalAlignment(FillRange: TFillRange; Align: THAlignment): boolean;
    function  _SetHorizontalAlignment(Range: Variant; Align: THAlignment): boolean;

    function  SetVerticalAlignment(FillRange: TFillRange; Align: THAlignment): boolean;
    function  _SetVerticalAlignment(Range: Variant; Align: THAlignment): boolean;

    function  FillPicture(Bmp: TBitmap; Left, Top: integer): boolean; overload;
    function  FillPicture(Bmp: TBitmap; const RowStart, RowEnd, ColStart, ColEnd: integer): boolean; overload;

    {* 尝试增加JPG的支持 *}
    function FillPictureJPGFormat(AJPEG: TJPEGImage; const RowStart, RowEnd, ColStart, ColEnd: Integer): Boolean; overload;

    function  FillChart(frData, frRangeX: TFillRange; ChartType: Cardinal	; Rect: TRect; Name: string): boolean;
    function  _FillChart(RangeData: variant; Axis: variant; ChartType: Cardinal	; Rect: TRect; Name: string): boolean;
    //读取内容
    function ReadText(ARow, ACol: Integer): Variant;
    {* 增加几个函数，以方便对Excel的灵活操作 *}
    procedure TypeText(ARow, ACol: Integer; v: Variant); overload;
    procedure TypeText(ARow, ACol: Integer; AText: string); overload;
    procedure TypeText(ARow, ACol: Integer; AText: string; AFontName: string); overload;
    procedure TypeText(ARow, ACol: Integer; AText: string; AFontName: string; AColor: TColor); overload;
    procedure TypeText(ARow, ACol: Integer; AText: string; AFontName: string; AColor: TColor; ASize: Integer);overload;
    procedure TypeText(ARow, ACol: Integer; AText: string; AFontName: string; AColor: TColor; ASize: Integer; AStyle: TFontStyles); overload;
    procedure SetCellFont(ARow, ACol: Integer; AFontName: string); overload;
    procedure ValidInt(ARow, ACol: Integer; AValue: Int64; AZoomRate: Integer = 1; const AFormat: string = ''; const AInvalid: string = 'N/A');
    procedure ValidFloat(ARow, ACol: Integer; AValue: Double; const AZoomRate: Double = 1; const AFormat: string = '0.000'; const AInvalid: string = 'N/A');
    procedure SetCellFont(ARow, ACol: Integer; AFontName: string; AColor: TColor); overload;
    procedure SetCellFont(ARow, ACol: Integer; AFontName: string; AColor: TColor; ASize: Integer); overload;
    procedure SetCellFont(ARow, ACol: Integer; AFontName: string; AColor: TColor; ASize: Integer; AStyle: TFontStyles); overload;
    procedure SetCellFont(ARow, ACol: Integer; AColor: TColor); overload;
    procedure SetCellFont(ARow, ACol: Integer; AStyle: TFontStyles); overload;
    procedure SetRangeBorders(ARange: Variant; const HAlignment: Int64 = xlCenter); overload;
    procedure SetRangeBorders(const sCol, sRow, eCol, eRow: Integer; const HAlignment: Int64 = xlCenter); overload;
    //增加对存在的图标进行操作的函数 fansheng 2007-1-22
    function SetChartDataValue(Index: Integer; FillRange: TFillRange): Boolean;
    {* 设置对齐方式 *}
    function SetRangeAlignMent(FillRange: TFillRange; hAlign: THAlignment = haGeneral; vAlign: TVAlignment = vaGeneral): Boolean;

    function SetChartXValue(Index: Integer; FillRange: TFillRange): Boolean;

    function  FillMultiColsChart(Rect: TRect; ChartType: Cardinal; Data: TMultiColsChart): Boolean;
    function FillCustomChart(ARect: TRect; ChartOption: TChartOption; Data: TMultiColsChart): Boolean;

    function  SetCellFormula(FormulaString : ShortString; RowNum, ColNum: Integer): Boolean;
    function  SetRangeFormula(FillRange: TFillRange; FormulaString : ShortString): Boolean;
    function  _SetRangeFormula(Range: variant; FormulaString : ShortString): Boolean;

    procedure Sort(SortRange, BaseRange: TFillRange; SortOrder: XlSortOrder);
    procedure _Sort(SortRange, BaseRange: Variant; SortOrder: XlSortOrder);

    //New Added Items
    procedure SetCellFont_NSN(ARow1, ARow2: Integer; ACol1, ACol2: string;
      AColor: TColor; AStyle: TFontStyles; ABackgroup: Integer);

    procedure SetRangeBorders_NSN(ARange: string; const HAlignment: Int64 = xlCenter); overload;
    procedure SetRangeBorders_NSN(ARange: Variant; const HAlignment: Int64 = xlCenter); overload;
    procedure SetRangeBorders_NSN(RowS, ColS, RowE, ColE: Integer; const HAlignment: Int64 = xlCenter); overload;

    function  GetChartRect(FillRange: TFillRange): TRect;

    {* 增加一个简单的3D饼图 *}
    function AddBasic_3DPie(ChartRowStart: Integer; ChartColStart: Integer; ChartRowEnd: Integer;
      ChartColEnd: Integer; DataRange: TFillRange; LegendRange: TFillRange; sChartTitle: string): Boolean; overload;


    function  GotoLastRow: boolean;
    function  GotoLastCol: boolean;
    function  GotoTopRow: boolean;
    function  GotoLeftMoreCol: boolean;
    function  SetColumnWidth(ColNum, ColumnWidth: Integer): Boolean;
    function  SelectCell(RowNum, ColNum: integer): boolean;
    function IndexSheetByCaption(sCaption: String): Integer;

    property  LastRow: integer read GetLastRow;
    property  LastCol: integer read GetLastCol;
    property  FirstRow: integer read GetFirstRow;
    property  FirstCol: integer read GetFirstCol;
    property  Row: integer read GetRow;
    property  Col: integer read GetCol;

    property  ExcelValided: boolean read FExcelValided;
    property  Visible: boolean read FVisible write SetVisible;
    property  ActiveSheetNo: integer read FActiveSheetNo write SetActiveSheetNo;
    property  ActiveSheetCaption: string read GetActiveSheetCaption write SetActiveSheetCaption;
    property  SheetsCaption[SheetNo: integer]: string read GetSheetsCaption write SetSheetsCaption;
    property  FillFrameColor: TFillFrameColor read FFillFrameColor write SetFillFrameColor;
    property  Caption: string  read FCaption write SetCaption;
    property  Sheet: variant read FXlSheet;
    property  ShowMess: boolean  read FShowMess write SetShowMess;
    property  SheetCount: integer read GetSheetCount;
    property  Styles: Variant read GetStyles;
    property  CurSheet: Variant read FXlSheet;
  end;

const
   CSExcelNotInstall       = 'MS Excel is not installed!' ;
   CSOpenExcelOleError     = 'Error when opening OLE with MsExcel';


const
  vAlignment : array[THAlignment] of Cardinal = (xlHAlignGeneral, xlHAlignLeft,
    xlHAlignRight, xlHAlignCenter);
  vBorderWeight  : array [TBorderWeight] of Cardinal =
  ({xlHairline}$00000001,{xlMedium}$FFFFEFD6,{xlThick}$00000004,{xlThin}$00000002);

  //Value to Excel constants of Border line style...
  vBorderLineStyle: array [TBorderLineStyle] of integer =
  ({xlContinuous}1,{xlDash}-4115,{xlDashDot}4,{xlDashDotDot}5,
   {xlDot}-4118,{xlDouble}-4119,{xlSlantDashDot}13,{xlContinuous}1,{xlLineStyleNone}-4142);

   function GetRangeText(FillRange: TFillRange): string;
   function GetRangeTextFromOtherSheet(sSheetCaption: String; FillRange: TFillRange): String;
   function GetRowCount(FillRange: TFillRange): integer;
   function ColIntToStr(ColNum: Integer): string;
   function ColStrToInt(ColStr: ShortString): Integer;
   function IniCellProperty: TCellProperty;
   function ZeroFillRange: TFillRange;
   //返回水平的对齐方式
   function GetHAligmentValue(Align: THAlignment): Integer;
   //返回垂直对齐方式
   function GetVAligmentValue(vAlgin: TVAlignment): Integer;
   {* ColumnIndexToColumnName *}
   function ColIndexToColumnName(const ColIndex: Integer): string;

implementation

uses
  uFunc;

{-------------------------------------------------------------------------------
  过程名:    ColIndexToColumnName
  作者:      Administrator
  日期:      2012.10.29
  参数:      const ColIndex: Integer
  返回值:    string
  说明：     增加一个将列号转化为列名的方法
-------------------------------------------------------------------------------}
function ColIndexToColumnName(const ColIndex: Integer): string;
var
  i, tmpCol, modResult: Integer;
  AColName: string;
begin
  Result := EmptyStr;
  AColName := Result;
  tmpCol := ColIndex;
  while tmpCol > 0 do
  begin
    modResult := tmpCol mod 26;
    if modResult = 0 then
    begin
      AColName := AColName + 'Z';
      tmpCol := tmpCol div 26 - 1;
    end
    else
    begin
      AColName := AColName + Char(modResult - 1 + Ord('A'));
      tmpCol := tmpCol div 26;
    end;
  end;
  SetLength(Result, Length(AColName));
  for i := Length(AColName) downto 1 do
    Result[Length(AColName) - i + 1] := AColName[i];
end;

function GetHAligmentValue(Align: THAlignment): Integer;
begin
  case Align of
    haLeft:     Result := xlLeft;
    haRight:    Result := xlRight;
    haCenter:   Result := xlCenter;
    haGeneral:  Result := xlLeft;
  end;
end;

function GetVAligmentValue(vAlgin: TVAlignment): Integer;
begin
  case vAlgin of
    vaTop:     Result := xlTop;
    vaBottom:  Result := xlBottom;
    vaCenter:  Result := xlCenter;
    vaGeneral: Result := xlcenter;
  end;
end;

function GetRangeText(FillRange: TFillRange): string;
begin
  result :=  ColIntToStr(FillRange.FromCell.Col) +
             IntToStr(FillRange.FromCell.Row) +
             ':' +
             ColIntToStr(FillRange.ToCell.Col) +
             IntToStr(FillRange.ToCell.Row);
end;

function GetRangeTextFromOtherSheet(sSheetCaption: String; FillRange: TFillRange): String;
begin
  result :=  sSheetCaption + '!R' + IntToStr(FillRange.FromCell.Row) + 'C' +
             IntToStr(FillRange.FromCell.Col) + ':R' +
             IntToStr(FillRange.ToCell.Row) + 'C' + IntToStr(FillRange.ToCell.Col);
end;


function GetRowCount(FillRange: TFillRange): integer;
begin
  try
    result := abs(FillRange.ToCell.Row - FillRange.FromCell.Row)
  except
    result := 0;
  end;
end;

function ColIntToStr(ColNum: Integer): string;
var
  ColStr    : ShortString;
  Multiplier: Integer;
  Remainder : Integer;
begin
  Result := '';
  if ColNum < 1   Then Exit;
  {$IFDEF OFFICE2003Protect}
  if ColNum > 256 Then Exit;
  {$ENDIF}
  Multiplier := ColNum div 26;
  Remainder  := ColNum Mod 26;
  if ColNum <= 26 Then
  begin
   ColStr[1] := ' ';
   if Remainder = 0 Then
     ColStr[2] := 'Z'
   else
     ColStr[2] := Chr(Remainder+64);
  end
  else
  begin
   if Remainder = 0 Then
   begin
     if Multiplier = 1 Then
     begin
       ColStr[1] := ' ';
       ColStr[2] := 'Z';
     end
     else
     begin
       ColStr[1] := Chr(Multiplier+64-1);
       ColStr[2] := 'Z';
     end;
   end
   else
   begin
     ColStr[1] := Chr(Multiplier+64);
     ColStr[2] := Chr(Remainder+64);
   end;
  end;
  if ColStr[1] = ' ' Then
    Result := Result + ColStr[2]
  else
    Result := Result + ColStr[1] + ColStr[2];

  Result := Result;
end;

function ColStrToInt(ColStr: ShortString): Integer;
var
  ColStrNew  : ShortString;
  i          : Integer;
  RetVal     : Integer;
  Multiplier : Integer;
  Remainder  : Integer;
begin
  RetVal := 1;
  Result := RetVal;
  ColStrNew := '';
  for i := 1 To Length(ColStr) do
  begin
   if ((Ord(ColStr[i]) >=  65)  and
      ( Ord(ColStr[i]) <=  90)) or
      ((Ord(ColStr[i]) >=  97)  and
      ( Ord(ColStr[i]) <= 122)) then
   begin
     ColStrNew := ColStrNew + UpperCase(ColStr[i]);
   end;
  end;
  if Length(ColStrNew) < 1 then Exit;
  if Length(ColStrNew) < 2 then
  begin
    RetVal := Ord(ColStrNew[1])-64;
  end
  else
  begin
    Multiplier := Ord(ColStrNew[1])-64;
    Remainder  := Ord(ColStrNew[2])-64;
    Retval     := (Multiplier * 26) + Remainder;
  end;
  Result := RetVal;
end;

function IniCellProperty: TCellProperty;
begin
  FillChar(Result, sizeof(Result), 0);
  result.Applyed := false;
  result.Text := '';

  result.BorderLineStyle := blNone;
  result.Background := clWhite;
  result.BorderColor := clBlack;
  result.BorderWeight := bwMedium;

  result.Align := haGeneral;
end;

function ZeroFillRange: TFillRange;
begin
  FillChar(Result, sizeof(result), 0);
end;

{ TExcelReport }

function TExcelReport.FillChart(frData, frRangeX: TFillRange;
  ChartType: Cardinal	; Rect: TRect; Name: string): boolean;
var
  RangeData: Variant;
  Axis: variant;
begin
  try
    Axis := GetRangeData(frRangeX);
    RangeData := GetRange(frData);
    _FillChart(RangeData, Axis, ChartType, Rect, Name);
    result := true;
  except
    result := false;
  end;
end;

procedure TExcelReport.ClearSheetData;
var
  Range: variant;
begin
  try
    Range := FXlSheet.Range['A1:IV65536']; // To assign range of all cells
    Range.ClearContents; // Clear values only
  except
  end;
end;

procedure TExcelReport.Close(SaveAll: boolean);
begin
  try
    if not VarIsEmpty(FXlApp) then
    begin   // We are connected with MsExcel
      //Modified by Administrator 2012-4-29 16:36:02 屏蔽
      FXlBook.Saved := True;
      if not VarIsEmpty(FXlBook) then
        FXlBook.Close;
      FActiveSheetNo := -1;
      FXlApp.ScreenUpdating := True;
      FXlApp.DisplayAlerts := True; // Discard unsaved changes
      FXlApp.Quit; // Close MsExcel
      VarClear(FXlSheet);
      VarClear(FXlSheets);
      VarClear(FXlBook);
      VarClear(FXlApp);
    end;
  except
  end;
end;

function TExcelReport.CombineCells(FillRange: TFillRange): boolean;
var
  Range: variant;
begin
  try
    Range := GetRange(FillRange);
    result := _CombineCells(Range);
  except
    result := false;
  end;
end;

constructor TExcelReport.create(aShowMess: boolean);
begin
  {$IFDEF DEBUG}
  FVisible := True;
  {$ELSE}
  FVisible := False;
  {$ENDIF}
  FActiveSheetNo := -1;
  FExcelValided := true;
  FShowMess := aShowMess;
end;

destructor TExcelReport.destroy;
begin
  Close(false);
  inherited;
end;


function TExcelReport.FillColor(FillRange: TFillRange;
  Color: TColor): boolean;
var
  ColorRange: variant;
begin
  result := false;
  if VarType(FXlSheet) <> VarDispatch then exit;
  try
    ColorRange := GetRange(FillRange);
    _FillColor(ColorRange, Color);
    result := true;
  except
    result := false;
  end;
end;

function TExcelReport.FillPicture(Bmp: TBitmap; Left, Top: integer): boolean;
var
  FileName: string;
  iWidth, iHeight: integer;
begin
  result := false;
  if Bmp = nil then exit;
  try
    result := true;
    iWidth := bmp.Width;
    iHeight := bmp.Height;
    FileName := GetSystemTempFile;
    try
      Bmp.SaveToFile(FileName);
      FXlSheet.Shapes.AddPicture(FileName , // FileName (included in sample)
                        true , // LinkToFile
                        true , // SaveWithDocument
                        Left , // Left
                        Top , // Top
                        iWidth , // Width
                        iHeight); // Height
    except
      result := false;
    end;
  except
   DeleteFile(PChar(FileName));
  end;
end;

function TExcelReport.FillData(FillRange: TFillRange; arrVar: Variant): boolean;
var
  Range: variant;
begin
  try
    Range := GetRange(FillRange);
    result := _FillData(Range, arrVar);
  except
    result := false;
  end;
end;

function TExcelReport.GetActiveSheetCaption: string;
begin
  result := '';
  if varType(FXLSheet) <> varDispatch then exit;
  try
    result := FXLSheet.Name;
  except
    result := '';
  end;
end;

function TExcelReport.GetCol: integer;
begin
 try
   Result := FXlApp.ActiveCell.Column;
 except
   Result := 1;
 end;
end;

function TExcelReport.GetFirstCol: integer;
var
  CurRow : Integer;
  CurCol : Integer;
begin
  Result := 1;
  try
    CurRow := FXlApp.ActiveCell.Row;
    CurCol := FXlApp.ActiveCell.Column;
    Result := CurRow;
    FXlApp.Selection.End[xlToLeft].Select;
    Result := FXlApp.ActiveCell.Column;
    FXlApp.ActiveSheet.Cells[CurRow, CurCol].Select;
  except
  end;
end;

function TExcelReport.SetRangeAlignMent(FillRange: TFillRange; hAlign: THAlignment;
  vAlign: TVAlignment): Boolean;
var
  v: Variant;
begin
  v := GetRange(FillRange);
  v.HorizontalAlignment := GetHAligmentValue(hAlign);
  v.VerticalAlignment := GetVAligmentValue(vAlign);
end;


function TExcelReport.VIsInt(v: Variant): Boolean;
begin
  Result := VarType(v) in [varSmallInt, varInteger, varBoolean, varShortInt,
                         varByte, varWord, varLongWord, varInt64];
end;

function TExcelReport.VIsFloat(v: Variant): Boolean;
begin
  Result := VarType(v) in [varSingle, varDouble, varCurrency];
end;

function TExcelReport.VIsDateTime(v: Variant): Boolean;
begin
  Result := VarType(v) = varDate;
end;

function TExcelReport.ReadText(ARow, ACol: Integer): Variant;
begin
  Result := FXlSheet.Cells[ARow, ACol].Value;
end;

{-------------------------------------------------------------------------------
  过程名:    TExcelReport.TypeText
  作者:      Administrator
  日期:      2012.10.12
  参数:      ARow, ACol: Integer; v: Variant
  返回值:    无
  说明：     增加输出Variant类型的变量
-------------------------------------------------------------------------------}
procedure TExcelReport.TypeText(ARow, ACol: Integer; v: Variant);
var
  sText: string;
begin
  sText := 'N/A';
  if not (VarIsNull(v) or VarIsEmpty(v)) then
  begin
    if VarIsStr(v) then
      sText := v
    else
    if VarIsNumeric(v) then
      sText := IntToStr(v)
    else
    if VarIsFloat(v) then
      sText := FloatToStr(v)
    else
    if VIsDateTime(v) then
      sText := Format('yyyy-mm-dd hh:mm:ss', [v]);
  end;
  TypeText(ARow, ACol, sText);
end;

{-------------------------------------------------------------------------------
  过程名:    TExcelReport.CopyCurrentToLast
  作者:      Administrator
  日期:      2012.10.11
  参数:      NewSheetName: string
  返回值:    无
  说明：     拷贝当前的Sheet到其后
-------------------------------------------------------------------------------}
procedure TExcelReport.CopyCurrentToLast(NewSheetName: string);
begin
  FXlSheet.Copy(, FXlSheet);
  (FXlSheet.Next).Name := NewSheetName;
  FActiveSheetNo := FXlSheets.Count;
  FXlSheet := FXlSheets.Item[FActiveSheetNo];
end;


procedure TExcelReport.Save(FileName: string; Format: XlFileFormat = xlNormal);
begin
  if varType(FxlApp) <> varDispatch then exit;
  try
    try
      if Format = xlNormal then
        FXlSheet.SaveAs(FileName)
      else
        FXlSheet.SaveAs(FileName, Format);
    except
      if Format = xlNormal then
        FXlSheet.SaveCopyAs(FileName)
      else
        FXlSheet.SaveCopyAs(FileName, Format);
    end;
  except
  end;
end;

function TExcelReport.OpenFileEx(TemplateFile, DestFile: string;
  BCreate: Boolean): Boolean;
begin
  Result := GenerateDestFile(TemplateFile, DestFile);
  if not Result then Exit;
  Result := OpenFile(DestFile, BCreate);
end;

function TExcelReport.GenerateDestFile(TemplateFile,
  DestFile: string): Boolean;
var
  sDestFileName: string;
begin
  Result := FileExists(TemplateFile);
  if not Result then Exit;
  if FileExists(DestFile) then
  begin
    DeleteFile(DestFile);
  end;
  if not DirectoryExists(ExtractFilePath(DestFile)) then
  begin
    Result := CreateDir(ExtractFilePath(DestFile));
    if not Result then Exit;
  end;
  //sDestFileName := Format('"%s"', [DestFile]);
  Result := CopyFileEx(PChar(TemplateFile), PChar(DestFile), nil, nil, nil, 0);
  if not Result then Exit;
end;

function TExcelReport.FillPictureJPGFormat(AJPEG: TJPEGImage; const RowStart,
  RowEnd, ColStart, ColEnd: Integer): Boolean;
var
  FileName: String;
  tempPath: string;
  Left, Top, Width, Height: Integer;
begin
  Result := False;
  if not Assigned(AJPEG) then Exit;
  Width := (ColEnd - ColStart) * 28;
  Height := (RowEnd - RowStart) * 12;
  Left := ColStart * 28;
  Top := RowStart * 12;
  //FileName := GetSystemTempFile;
  // Modified by shibiao.chen 2012/11/29 星期四 9:04:16 使用默认的临时文件
  //可能存在创建失败的情况，这里改为可执行所在路径下的临时文件
  FileName := ExtractFilePath(ParamStr(0)) + CreateClassID + '.tmp';
  if FileExists(FileName) then
    DeleteFile(FileName);
  //CreateFileOnDisk(FileName);
  try
    AJPEG.SaveToFile(FileName);
    FXlSheet.Shapes.AddPicture(FileName,
      True,
      True,
      Left,
      Top,
      Width,
      Height);
    {* 更新图片位置，防止图片出现Load不出来 *}
    {$IFDEF OFFICE2010}
    FXlSheet.Shapes.Range(Left, Top, Width, Height).ShapeRange.IncrementLeft := -0.1;
    FXlSheet.Shapes.Range(Left, Top, Width, Height).ShapeRange.IncrementLeft := -0.1;
    {$ENDIF}
    if FileExists(FileName) then
      DeleteFile(FileName);
  except
    if FileExists(FileName) then
      DeleteFile(FileName);
    Result := False;
  end;
end;
procedure TExcelReport.SetCellFont(ARow, ACol: Integer; AFontName: string;
  AColor: TColor; ASize: Integer; AStyle: TFontStyles);
begin
  SetCellFont(ARow, ACol, AFontName);
  SetCellFont(ARow, ACol, AColor);
  SetCellFont(ARow, ACol, ASize);
  SetCellFont(ARow, ACol, AStyle);
end;

procedure TExcelReport.SetCellFont(ARow, ACol: Integer; AColor: TColor);
begin
  FXlSheet.Cells[ARow, ACol].Font.Color := AColor;
end;

procedure TExcelReport.SetCellFont(ARow, ACol: Integer;
  AStyle: TFontStyles);
begin
  if fsBold in AStyle then
    FXlSheet.Cells[ARow, ACol].Font.Bold := True;
  if fsItalic in AStyle then
    FXlSheet.Cells[ARow, ACol].Font.Italic := True;
  if fsUnderLine in AStyle then
    FXlSheet.Cells[ARow, ACol].Font.UnderLine := True;
end;

procedure TExcelReport.SetCellFont(ARow, ACol: Integer; AFontName: string);
begin
  FXlSheet.Cells[ARow, ACol].Font.Name := AFontName;
end;

procedure TExcelReport.SetCellFont(ARow, ACol: Integer; AFontName: string;
  AColor: TColor);
begin
  SetCellFont(ARow, ACol, AFontName);
  SetCellFont(ARow, ACol, AColor);
end;

procedure TExcelReport.SetCellFont(ARow, ACol: Integer; AFontName: string;
  AColor: TColor; ASize: Integer);
begin
  SetCellFont(ARow, ACol, AFontName);
  SetCellFont(ARow, ACol, AColor);
  SetCellFont(ARow, ACol, ASize);
end;

procedure TExcelReport.SetRangeBorders(ARange: Variant;
  const HAlignment: Int64);
begin
  if HAlignment = xlLeft then
    ARange.HorizontalAllignment := xlLeft
  else
  if HAlignment = xlCenter then
    ARange.HorizontalAllignment := xlCenter
  else
  if HAlignment = xlright then
    ARange.HorizontalAllignment := xlRight;
  ARange.Borders.LineStyle := 1;
  ARange.Borders.Weight := 2;
end;

procedure TExcelReport.SetRangeBorders(const sCol, sRow, eCol,
  eRow: Integer; const HAlignment: Int64);
var
  vr: Variant;
begin

  SetRangeBorders(GetRange(sCol, eCol, sRow, eRow), HAlignment);
end;

procedure TExcelReport.TypeText(ARow, ACol: Integer; AText,
  AFontName: string; AColor: TColor; ASize: Integer; AStyle: TFontStyles);
begin
  TypeText(ARow, ACol, AText);
  SetCellFont(ARow, ACol, AFontName, AColor, ASize, AStyle);
end;

procedure TExcelReport.TypeText(ARow, ACol: Integer; AText,
  AFontName: string; AColor: TColor; ASize: Integer);
begin
  TypeText(ARow, ACol, AText);
  SetCellFont(ARow, ACol, AFontName, AColor, ASize);
end;

procedure TExcelReport.TypeText(ARow, ACol: Integer; AText: string);
begin
  FXlSheet.Cells[ARow, ACol].Value := AText;
end;

procedure TExcelReport.TypeText(ARow, ACol: Integer; AText,
  AFontName: string);
begin
  TypeText(ARow, ACol, AText);
  SetCellFont(ARow, ACol, AFontName);
end;

procedure TExcelReport.TypeText(ARow, ACol: Integer; AText,
  AFontName: string; AColor: TColor);
begin
  TypeText(ARow, ACol, AText);
  SetCellFont(ARow, ACol, AFontName, AColor);
end;

procedure TExcelReport.ValidFloat(ARow, ACol: Integer; AValue: Double;
  const AZoomRate: Double; const AFormat, AInvalid: string);
begin
  if (AValue <> -9999) and (AZoomRate <> 0) then
    FXlSheet.Cells[ARow, ACol].Value := AValue / AZoomRate
  else
    TypeText(ARow, ACol, AInvalid);
  FXlSheet.Cells[ARow, ACol].NumberFormatLocal := AFormat;
end;

procedure TExcelReport.ValidInt(ARow, ACol: Integer; AValue: Int64;
  AZoomRate: Integer; const AFormat, AInvalid: string);
  function IsTenMulti(Value: Integer): Boolean;
  var
    dValue: Double;
  begin
    dValue := Value;
    Result := True;
    if (dValue < 10) and (dValue <> 1) then
    begin
      Result := False;
      Exit;
    end;
    dValue := dValue / 10;
    while dValue > 1 do
    begin
      dValue := dValue / 10;
      Result := (dValue = Trunc(dValue));
      if not Result then Exit;
    end;
  end;
begin
  if (AValue <> -9999) and (AZoomRate <> 0) then
    FXlSheet.Cells[ARow, ACol].Value := AValue/AZoomRate
  else
    TypeText(ARow, ACol, AInvalid);
  if AFormat <> '' then
    FXlSheet.Cells[ARow, ACol].NumberFormatLocal := AFormat
  else
  if not IsTenMulti(AZoomRate) then
    FXlSheet.Cells[ARow, ACol].NumberFormatLocal := '0.000';
end;

function TExcelReport.FillColor(RowStart, RowEnd, ColStart,
  ColEnd: Integer; Color: TColor): Boolean;
begin
  Result := FillColor(GetFillRange(ColStart, ColEnd, RowStart, RowEnd), Color);
end;

function TExcelReport.GetFillRange(const ColStart, ColEnd, RowStart,
  RowEnd: Integer): TFillRange;
begin
  Result.FromCell.Row := RowStart;
  Result.FromCell.Col := ColStart;
  Result.ToCell.Row := RowEnd;
  Result.ToCell.Col := ColEnd;
end;


procedure TExcelReport.HighLightCurrentRow(const RowIndex: Integer;
  ColStart: Integer; ColEnd: Integer);
var
  ARange: Variant;
begin
  ARange := GetRange(ColStart, ColEnd, RowIndex, RowIndex);
  //Sheet.Range := ARange;
  //Sheet.Range.Interior.ColorIndex := 22;
end;

function TExcelReport.GetRange(ColStart, ColEnd, RowStart,
  RowEnd: Integer): Variant;
var
  RF: TFillRange;
begin
  RF.FromCell.Col := ColStart;
  RF.FromCell.Row := RowStart;
  RF.ToCell.Col := ColEnd;
  RF.ToCell.Row := RowEnd;
  GetRange(RF);
end;

procedure TExcelReport.SetRangeFonts(const ARange: Variant;
  const AColor: TColor; const ASize: Integer);
begin
  ARange.Font.Color := AColor;
  ARange.Font.Size := ASize;
end;

procedure TExcelReport.SetRangeFonts(const AFillRange: TFillRange;
  const AColor: TColor; const ASize: Integer);
var
  ARange: Variant;
begin
  ARange := GetRange(AFillRange);
  SetRangeFonts(ARange, AColor, ASize);
end;

procedure TExcelReport.SetOutPutFormat(const FillRange: TFillRange;
  FormatStr: string);
begin
  SetOutPutFormat(GetRange(FillRange), FormatStr);
end;

procedure TExcelReport.SetRangeFontsEx(const ARange: TFillRange;
  const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer;
  ABackGroup: Integer; const FontName: TFontDataName);
var
  Range: Variant;
begin
  Range := GetRange(ARange);
  SetRangeFonts(Range, AColor, AStyle, ASize);
  //Range.Interior.ColorIndex := ABackGroup;
  Range.Font.Name := FontName;
end;

procedure TExcelReport.SetRangeFontsEx(const RowStart, RowEnd, ColStart,
  ColEnd: Integer; const AColor: TColor; const AStyle: TFontStyles;
  const ASize: Integer; ABackGroup: Integer; const FontName: TFontDataName);
var
  FillRange: TFillRange;
begin
  FillRange.FromCell.Row := RowStart;
  FillRange.ToCell.Row := RowEnd;
  FillRange.FromCell.Col := ColStart;
  FillRange.ToCell.Col := ColEnd;
  SetRangeFontsEx(FillRange, AColor, AStyle, ASize, ABackGroup, FontName);
end;

function TExcelReport.FillPicture(Bmp: TBitmap; const RowStart, RowEnd,
  ColStart, ColEnd: integer): boolean;
var
  FileName: string;
  Left, Top, Width, Height: Integer;
begin
  Result := False;
  if not Assigned(Bmp) then Exit;
  try
    Width := (ColEnd - ColStart) * 50;
    Height := (RowEnd - RowStart) * 50;
    Left := ColStart * 50;
    Top := RowStart * 25;
    FileName := GetSystemTempFile;
    try
      Bmp.SaveToFile(FileName);
      FXlSheet.Shapes.AddPicture(FileName,
      True,
      True,
      Left,
      Top,
      Width,
      Height);
    except
      Result := False;
    end;
  except
    DeleteFile(PChar(FileName));
  end;
end;

procedure TExcelReport.SetOutPutFormat(const ARange: Variant;
  const FormatStr: string = '@');
begin
  ARange.NumberFormatLocal := FormatStr;
end;

procedure TExcelReport.SetOutPutFormat(const RowStart, RowEnd, ColStart,
  ColEnd: Integer; const FormatStr: string = '@');
var
  TmpFillRange: TFillRange;
begin
  TmpFillRange.FromCell.Row := RowStart;
  TmpFillRange.FromCell.Col := ColStart;
  TmpFillRange.ToCell.Row := RowEnd;
  TmpFillRange.ToCell.Col := ColEnd;
  SetOutPutFormat(GetRange(TmpFillRange), FormatStr);
end;

procedure TExcelReport.SetRangeFonts(const ARange: Variant;
  const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer = 9);
begin
  ARange.Font.Color := AColor;
  if fsBold in AStyle then
    ARange.Font.Bold := True;

  if ARange.Font.Size <> ASize then
    ARange.Font.Size := ASize;
end;

procedure TExcelReport.SetRangeFonts(const RowStart, RowEnd, ColStart,
  ColEnd: Integer;  const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer = 9);
var
  AFillRange: TFillRange;
begin
  AFillRange.FromCell.Row := RowStart;
  AFillRange.FromCell.Col := ColStart;
  AFillRange.ToCell.Row := RowEnd;
  AFillRange.ToCell.Col := ColEnd;
  SetRangeFonts(GetRange(AFillRange), AColor, AStyle, ASize);
end;

procedure TExcelReport._Sort(SortRange, BaseRange: Variant;
  SortOrder: XlSortOrder);
begin
  if (varType(SortRange) <> varDispatch) or (VarType(BaseRange) <> VarDispatch) then Exit;
  try
    SortRange.Sort(BaseRange, SortOrder);
  except
  end;
end;

procedure TExcelReport.Sort(SortRange, BaseRange: TFillRange;
  SortOrder: XlSortOrder);
var
  Range, BRange: variant;
begin
  Range := GetRange(SortRange);
  BRange := GetRange(BaseRange);
  if (VarType(Range) <> VarDispatch) or (VarType(BRange) <> VarDispatch) then Exit;
  try
    _Sort(Range, BRange, SortOrder);
  except
    ;
  end;
end;

function TExcelReport.SetRangeFormula(FillRange: TFillRange;
  FormulaString: ShortString): Boolean;
var
  Range: variant;
begin
  Result := False;
  Range := GetRange(FillRange);
  if VarType(Range) <> VarDispatch then Exit;
  try
    Result :=_SetRangeFormula(Range, FormulaString);
  except
    ;
  end;
end;

function TExcelReport.InsertRowM(iRow, iRowNum: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to iRowNum do
  begin
    Result := InsertRowExt(iRow);
    if not Result then Break;
  end;
end;


function TExcelReport.SetChartXValue(Index: Integer;
  FillRange: TFillRange): Boolean;
var
  Chart: Variant;
  sXValue: string;
begin
  Result := False;
  try
    if VarType(FXlSheet) <> VarDispatch then Exit;
    Chart := FXlSheet.ChartObjects(index).Chart;
    sXValue := Format('=''%s''!R%dC%d:R%dC%d', [ActiveSheetCaption, FillRange.FromCell.Row,
      FillRange.FromCell.Col, FillRange.ToCell.Row, FillRange.ToCell.Col]);
    Chart.SeriesCollection(1).XValues := sXValue;
    Result := True;
  except
    Result := False;
  end;
end;

function TExcelReport.SetChartDataValue(Index: Integer; FillRange: TFillRange): Boolean;
var
  Chart: Variant;
  sValue: string; 
begin
  Result := False;
  try
    if VarType(FXlSheet) <> VarDispatch then Exit;
    Chart := FXlSheet.ChartObjects(index).Chart;
    sValue := Format('=''%s''!R%dC%d:R%dC%d', [ActiveSheetCaption, FillRange.FromCell.Row,
      FillRange.FromCell.Col, FillRange.ToCell.Row, FillRange.ToCell.Col]);
    Chart.SeriesCollection(1).Values := sValue;
    Result := True;
  except
    Result := False;
  end;
end;

function TExcelReport.InsertRowExt(iRow: Integer): Boolean;
var
  ARow: Variant;
begin
  result := false;
  if varType(FXlApp) <> VarDispatch then exit;
  try
    ARow := FXlApp.ActiveSheet.Rows[iRow];
    result := _InsertRow(ARow);
  except
    result := false;
  end;
end;

function TExcelReport.SetSheetFont(AFont: TFont): Boolean;
var
  ARange: Variant;
begin
  result := false;
  if VarType(FXlSheet) <> VarDispatch then exit;
  try
    ARange := FXlSheet.Cells;
    result := _SetRangeFont(ARange, AFont);
  except
    result := false;
  end;
end;

function TExcelReport.IndexSheetByCaption(sCaption: String): Integer;
var
  i: Integer;
begin
  result := -1;
  try
    if varType(FXlSheets) <> VarDispatch then exit;
    for i := 1 to FXlSheets.Count do
      if FXlSheets.Item[i].Name = sCaption then
      begin
        result := i;
        break;
      end;
  except
  end;
end;

function TExcelReport._SetVerticalAlignment(Range: Variant;
  Align: THAlignment): boolean;
begin
  result := false;
  if varType(Range) <> varDispatch then exit;
  try
    Range.VerticalAlignment   := TOleEnum(vAlignment[Align]);
    result := true;
  except
  end;
end;

function TExcelReport.SetVerticalAlignment(FillRange: TFillRange;
  Align: THAlignment): boolean;
var
  Range: variant;
begin
  result := false;
  Range := GetRange(FillRange);
  if VarType(Range) <> VarDispatch then exit;
  try
    result :=_SetVerticalAlignment(Range, Align);
  except
  end;
end;

function TExcelReport.GetStyles: Variant;
begin
  VarClear(result);
  if not VarIsEmpty(FXlBook) then
    result := FXlBook.Styles;
end;

function TExcelReport.GetRangeStyle(FillRange: TFillRange): Variant;
var
  ARange: Variant;
begin
  result := varEmpty;
  try
    ARange := GetRange(FillRange);
    if not VarIsEmpty(ARange) then
      result := ARange.Style;
  except
  end;
end;

function TExcelReport.SetRangeStyle(FillRange: TFillRange;
  AStyle: Variant): Boolean;
var
  ARange: Variant;
begin
  result := True;
  try
    ARange := GetRange(FillRange);
    if not VarIsEmpty(ARange) then
      ARange.Style := AStyle;
  except
    Result := False;
  end;
end;

function TExcelReport.SetRangeWrapText(AFillRange: TFillRange;
  bWrap: Boolean): Boolean;
var
  ARange: Variant;
begin
  result := True;
  ARange := GetRange(AFillRange);
  try
    ARange.WrapText := bWrap;
  except
    result := False;
  end;
end;

function TExcelReport.FillCustomChart(ARect: TRect;
  ChartOption: TChartOption; Data: TMultiColsChart): Boolean;
var
  XlChart,Series: variant;
  i: Integer;
begin
  result := True;
  try
    XlChart := FXlSheet.ChartObjects.Add(ARect.Left, ARect.Top, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
    //XlChart := FXlSheet.ChartObjects[FXlSheet.ChartObjects.count];
    XlChart.Chart.ChartType := ChartOption.ChartType;

    for i := 0 to Length(Data.MultiCols) - 1 do
    begin
      Series := XlChart.Chart.SeriesCollection.NewSeries;
  //    XlChart.Chart.SeriesCollection.Add(RangeData);
 //     if i = 0 then
//      XlChart.Chart.SeriesCollection[i + 1].XValues := Data.MultiCols[i].XValues;
//      XlChart.Chart.SeriesCollection[i + 1].Values := Data.MultiCols[i].Values;
//      XlChart.Chart.SeriesCollection[i + 1].NAME:= Data.MultiCols[i].Name;
      Series.XValues := Data.MultiCols[i].XValues;
      Series.Values := Data.MultiCols[i].Values;
      Series.NAME:= Data.MultiCols[i].Name;
      Series.HasDataLabels := true;
      Series.HasLeaderLines := false;

      if ChartOption.ChartType = xlLineMarkers then
      begin
        Series.Border.Weight := xlThin;
        Series.Border.LineStyle := xlContinuous;
        Series.MarkerBackgroundColorIndex := xlAutomatic;
        Series.MarkerForegroundColorIndex := xlAutomatic;
        Series.MarkerStyle := xlDiamond;
        Series.Smooth := True;
        Series.MarkerSize := 6;
      end
      else if (i = Length(Data.MultiCols) - 1) and ChartOption.DisAvgLine then //最后一列为平均线
      begin
        Series.ChartType := xlLineMarkers;
        Series.Border.Weight := xlThin;
        Series.Border.LineStyle := xlContinuous;
        Series.MarkerBackgroundColorIndex := xlAutomatic;
        Series.MarkerForegroundColorIndex := xlAutomatic;
        Series.MarkerStyle := xlDiamond;
        Series.Smooth := True;
        Series.MarkerSize := 6;
      end;
    end;
//    FXlApp.Visible := True;
    try
      XlChart.Chart.Location(xlLocationAsObject, Data.SheetName);
    except
    end;
//    FXlApp.ScreenUpdating := True;
    XlChart.Chart.HasLegend := ChartOption.DisLegend;
    if ChartOption.DisLegend then
      XlChart.Chart.Legend.Position := ChartOption.LegendPos;
    XlChart.Chart.ApplyDataLabels(xlDataLabelsShowNone, False);
    XlChart.Chart.HasDataTable := false;

    if ChartOption.ChartType <> xl3DPie then
    begin
      XlChart.Chart.HasAxis(xlCategory, xlPrimary) := true;
      XlChart.Chart.HasAxis(xlValue, xlPrimary) := true;

      XlChart.Chart.HasTitle := True;
      XlChart.Chart.ChartTitle.Characters.Text := Data.Title;

      XlChart.Chart.Axes(xlCategory, xlPrimary).HasTitle := True;
      XlChart.Chart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text := Data.XAxisTitle;

      XlChart.Chart.Axes(xlValue, xlPrimary).HasTitle := True;
      XlChart.Chart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text := Data.YAxisTitle;
    end;
  except
    result := false;
  end;
end;


function TExcelReport.GetChartRect(FillRange: TFillRange): TRect;
var
  Range: variant;
begin
  FillChar(Result, sizeof(Result), 0);
  Range := GetRange(FillRange);

  with result do
  begin
    Left :=  Range.Left;
    Top  :=  Range.Top;
    Right := Range.Left + Range.Width;
    Bottom := Range.Top + Range.Height;
  end;
end;


function TExcelReport.FillMultiColsChart(Rect: TRect; ChartType: Cardinal; Data: TMultiColsChart): Boolean;
var
  XlChart: variant;
  i: Integer;
begin
  result := True;
  try
    FXlSheet.ChartObjects.Add(Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
    XlChart := FXlSheet.ChartObjects[FXlSheet.ChartObjects.Count];
    XlChart.Chart.ChartType := ChartType;

    for i := 0 to Length(Data.MultiCols) - 1 do
    begin
      XlChart.Chart.SeriesCollection.NewSeries;
  //    XlChart.Chart.SeriesCollection.Add(RangeData);
      XlChart.Chart.SeriesCollection.Item[i + 1].HasDataLabels := true;
      XlChart.Chart.SeriesCollection[i + 1].NAME:= Data.MultiCols[i].Name;
      XlChart.Chart.SeriesCollection[i + 1].HasLeaderLines := false;
      if i = 0 then
        XlChart.Chart.SeriesCollection[i + 1].XValues := Data.MultiCols[i].XValues;
      XlChart.Chart.SeriesCollection[i + 1].Values := Data.MultiCols[i].Values;
      XlChart.Chart.HasLegend := false;
    end;
    XlChart.Chart.Location(xlLocationAsObject, Data.SheetName);
    XlChart.Chart.HasLegend := true;
    XlChart.Chart.Legend.Position := xlCorner;
    XlChart.Chart.ApplyDataLabels(xlDataLabelsShowNone, False);
    XlChart.Chart.HasDataTable := True;
    XlChart.Chart.DataTable.ShowLegendKey := True;
    XlChart.Chart.ChartArea.Font.Size := 10;

    if ChartType <> xl3DPie then
    begin
      XlChart.Chart.HasAxis(xlCategory, xlPrimary) := true;
      XlChart.Chart.HasAxis(xlValue, xlPrimary) := true;

      XlChart.Chart.HasTitle := True;
      XlChart.Chart.ChartTitle.Characters.Text := Data.Title;

      XlChart.Chart.Axes(xlCategory, xlPrimary).HasTitle := True;
      XlChart.Chart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text := Data.XAxisTitle;

      XlChart.Chart.Axes(xlValue, xlPrimary).HasTitle := True;
      XlChart.Chart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text := Data.YAxisTitle;
    end;
  except
    result := false;
  end;
end;

function TExcelReport.__SetRangeRowHeight(Range: variant ;Height: single): boolean;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  Range.RowHeight := Height;
  result := true;
end;

function TExcelReport.SetRangeRowHeight(Range: TFillRange; Height: single): boolean;
begin
  result := __SetRangeRowHeight(GetRange(Range), Height);
end;

function TExcelReport._Copy(Range: Variant): boolean;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  Range.Select;
  Range.Copy;
  result := true;
end;

function TExcelReport.Copy(Range: TFillRange): boolean;
begin
  result := _Copy(GetRange(Range));
end;

function TExcelReport._InsertRowCount(Range: variant;
  Count: integer): boolean;
var
  i: integer;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  for i:= 0 to Count - 1 do
   result := Range.Insert(xlDown);
end;

function TExcelReport.InsertRowCount(Range: TFillRange;
  Count: integer): boolean;
begin
  result := _InsertRowCount(GetRange(Range), Count);
end;

function TExcelReport.OpenFile(FileName: string; BCreate: Boolean): boolean;
begin
  result := true;
  try
    //增加是否使用已存在的Excel的支持选项
    if BCreate then
    begin
      FXlApp  := CreateOleObject('Excel.Application');
    end
    else
    begin
      try
        FXlApp := GetActiveOleObject('Excel.Application');
      except
        FXlApp  := CreateOleObject('Excel.Application');
      end;
    end;

    if VarType(FXlApp) <> VarDispatch then
    begin
      if VarType(FXlApp) <> VarDispatch then FXlApp.Quit;
      if ShowMess then ErrorDlg(CSExcelNotInstall);
      Exit;
    end;
    FXLApp.DisplayAlerts := False;
    FXLApp.Workbooks.Open(FileName);
    FXlBook := FXlApp.WorkBooks[1];
    FXlSheets := FXlBook.Sheets;
    FXlSheet  := FXlSheets.Item[1];
    if FVisible then FXlApp.Visible := True;
    FActiveSheetNo := 0;
    FExcelValided := true;
  except
    result := False;
    FExcelValided := False;
    if VarType(FXlApp) <> VarDispatch then
      FXlApp.Quit;
    if ShowMess then ErrorDlg(CSOpenExcelOleError);
  end;
end;

function TExcelReport._InsertCol(Range: variant): boolean;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  Range.Insert(xlRight);
  result := true;
end;

function TExcelReport._InsertRow(Range: variant): boolean;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  result := Range.Insert(xlDown);
end;

function TExcelReport.InsertCol(Range: TFillRange): boolean;
begin
  result := _InsertCol(GetRange(Range));
end;

function TExcelReport.InsertRow(Range: TFillRange): boolean;
begin
  result := _InsertRow(GetRange(Range));
end;

function TExcelReport._GetRangeData(Range: variant): variant;
begin
  if VarType(Range) <> VarDispatch then exit;
  result := Range.Value;
end;


function TExcelReport._CopyRange(SrcRange, DstRange: variant): boolean;
begin
  result := false;
  if VarType(SrcRange) <> VarDispatch then exit;
  if VarType(DstRange) <> VarDispatch then exit;
  _FillData(DstRange,_GetRangeData(SrcRange));
  result := true;
end;

function TExcelReport.CopyRange(SrcRange, DstRange: TFillRange): boolean;
begin
  result := _CopyRange(GetRange(srcRange),GetRange(dstRange));
end;


function TExcelReport.SetHorizontalAlignment(FillRange: TFillRange;
  Align: THAlignment): boolean;
var
  Range: variant;
begin
  result := false;
  Range := GetRange(FillRange);
  if VarType(Range) <> VarDispatch then exit;
  try
    result :=_SetHorizontalAlignment(Range, Align);
  except
  end;
end;

procedure TExcelReport.ClearSheets;
begin
  if VarType(FXlApp) <> VarDispatch then // If we are not connected with MsExcel
    Open
  else if not VarIsEmpty(FXlBook) then // if connected with MsExcel
  begin
    if FXLBook.Sheets.Count > 1 then
      FXlSheet  := FXlBook.Sheets.Delete;
    FXlSheets := FXlApp.Sheets; // Array of Sheets
    FActiveSheetNo := FXlBook.Sheets.Count;
  end;
end;

function TExcelReport.GetSheetCount: integer;
begin
  result := FXlSheets.count
end;

procedure TExcelReport.SetShowMess(const Value: boolean);
begin
  FShowMess := Value;
end;

function TExcelReport.GetRangeData(FillRange: TFillRange): Variant;
begin
  result := _GetRangeData(GetRange(FillRange));
end;

function TExcelReport._SetHorizontalAlignment(Range: Variant;
  Align: THAlignment): boolean;
begin
  result := false;
  if varType(Range) <> varDispatch then exit;
  try
    Range.HorizontalAlignment := TOleEnum(vAlignment[Align]);
    result := true;
  except
  end;
end;

procedure TExcelReport.SetDefaultFont;
begin
  FxlApp.ActiveSheet.Rows.Font.Name := 'Arial';
  FxlApp.ActiveSheet.Rows.Font.Size := 9;
end;

function TExcelReport._FillChart(RangeData: variant; Axis: variant;
  ChartType: Cardinal	; Rect: TRect; Name: string): boolean;
var
  XlChart: variant;
begin
  result := false;
  if varType(RangeData) <> VarDispatch then exit;
  try
    FXlSheet.ChartObjects.Add(Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
    XlChart := FXlSheet.ChartObjects[FXlSheet.ChartObjects.Count];
    XlChart.Chart.ChartType := ChartType;
    XlChart.Chart.SeriesCollection.Add(RangeData);
    XlChart.Chart.SeriesCollection.Item[1].HasDataLabels := true;
    XlChart.Chart.SeriesCollection[1].NAME:=Name;
    XlChart.Chart.SeriesCollection[1].HasLeaderLines := false;
    XlChart.Chart.HasLegend := false;

    if ChartType <> xl3DPie then
    begin
      XlChart.Chart.HasAxis(xlCategory, xlPrimary) := true;
      XlChart.Chart.HasAxis(xlValue, xlPrimary) := false;
      XlChart.Chart.Axes(xlCategory, xlPrimary).AxisBetweenCategories := true;
      XlChart.Chart.Axes(xlCategory, xlPrimary).CategoryNames := Axis;
    end;
  except
    result := false;
  end;
end;


function TExcelReport._FillProperty(Range: variant;
  CellProperty: TCellProperty): boolean;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  try
    _FillData(Range, CellProperty.Text);
    if CellProperty.Applyed then
    begin
       _FillColor(Range, CellProperty.Background);
       _SetRangeFont(Range, CellProperty.Font);
       _SetRangeAlign(Range, CellProperty.Align);
       _SetRangeBorder(Range, CellProperty.BorderColor, CellProperty.BorderWeight,
                      CellProperty.BorderLineStyle)
    end;
    result := true;
  except
  end;
end;

function TExcelReport._CombineCells(Range: variant): boolean;
begin
  result := false;
  if VarType(Range) <> varDispatch then exit;
  try
    Range.Merge(false);
    result := true;
  except
    result := false;
  end;
end;

function TExcelReport._FillData(Range, arrVar: variant): boolean;
begin
  result := false;
  if VarType(Range) <> VarDispatch then exit;
  try
    try
      Range.value := arrVar;
      result := true;
    except
    end;
  finally
    VarClear(arrVar);
  end;
end;

function TExcelReport.SetRangeBorder(FillRange: TFillRange;
  BorderColor: TColor; BorderWeight: TBorderWeight;
  BorderLineStyle: TBorderLineStyle; Inner: boolean = false): boolean;
begin
  result := _SetRangeBorder(GetRange(FillRange), BorderColor,
                           BorderWeight, BorderLineStyle, Inner);
end;

function TExcelReport._SetRangeBorder(Range: Variant; BorderColor: TColor;
  BorderWeight: TBorderWeight; BorderLineStyle: TBorderLineStyle;
  Inner: boolean = false): boolean;
begin
  result :=false;
  if varType(Range) <> varDispatch then exit;
  try
    Range.Borders.LineStyle:=vBorderLineStyle[BorderLineStyle];
//     Range.Borders.Weight := vBorderWeight[BorderWeight];
    if Inner then
    begin
      Range.Borders.Color := BorderColor;
      Range.Borders.Item[xlDiagonalDown] := xlNone;
      Range.Borders.Item[xlDiagonalUp] := xlNone;
      Range.Borders.Item[xlEdgeLeft] := xlContinuous;
      Range.Borders.Item[xlEdgeTop] := xlContinuous;
      Range.Borders.Item[xlEdgeBottom] := xlContinuous;
      Range.Borders.Item[xlEdgeRight] := xlContinuous;
      Range.Borders.Item[xlInsideVertical] := xlContinuous;
      Range.Borders.Item[xlInsideHorizontal] := xlContinuous;
    end;
{
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
}
    result := true;
  except
  end;
end;


function TExcelReport.SetRangeAlign(FillRange: TFillRange;
  Align: THAlignment): boolean;
var
  Range: variant;
begin
  result := false;
  Range := GetRange(FillRange);
  if VarType(Range) <> VarDispatch then exit;
  try
    result :=_SetRangeAlign(Range, Align);
  except
  end;
end;

function TExcelReport._SetRangeAlign(Range: Variant;
  Align: THAlignment): boolean;
begin
  result := false;
  if varType(Range) <> varDispatch then exit;
  try
    Range.HorizontalAlignment := TOleEnum(vAlignment[Align]);
    Range.VerticalAlignment   := TOleEnum(vAlignment[Align]);
    result := true;
  except
  end;
end;

function TExcelReport._FillColor(Range: Variant; Color: TColor): boolean;
begin
  result := false;
  if varType(Range) <> varDispatch then exit;
  try
    Range.Interior.ColorIndex := Color;
    result := true;
  except
  end;
end;

function TExcelReport._SetRangeFont(Range: Variant; Font: TFont): boolean;
begin
  result := false;
  if varType(Range) <> varDispatch then exit;
  try
    Range.Font.Name := Font.Name;
    Range.Font.size := Font.Size;
    Range.Font.Color := Font.Color;
    Range.Font.Bold  := fsBold in Font.Style;
    Range.Font.Italic := fsItalic in Font.Style;
    Range.Font.Underline := fsUnderLine in Font.Style;
    result := true;
  except
  end;
end;

function TExcelReport.FillProperty(FillRange: TFillRange;
  CellProperty: TCellProperty): boolean;
var
  Range: variant;
begin
  try
    Range := GetRange(FillRange);
    result := _FillProperty(Range, CellProperty);
  except
    result := false;
  end;
end;


function TExcelReport.SetRangeFont(FillRange: TFillRange; Font: TFont): boolean;
var
  Range: variant;
begin
  result := false;
  Range := GetRange(FillRange);
  if VarType(Range) <> VarDispatch then exit;
  try
    result := _SetRangeFont(Range, Font);
  except
  end;
end;

function TExcelReport.GetFirstRow: integer;
Var
  CurRow : Integer;
  CurCol : Integer;
begin
  Result := 1;
  try
   CurRow := FXlApp.ActiveCell.Row;
   CurCol := FXlApp.ActiveCell.Column;
   Result := CurRow;
   FXlApp.Selection.End[xlUp].Select;
   Result := FXlApp.ActiveCell.Row;
   FXlApp.ActiveSheet.Cells[CurRow, CurCol].Select;
  except
  end;
end;

function TExcelReport._SetRangeFormula(Range: variant;
  FormulaString: ShortString): Boolean;
begin
  Result := False;
  if varType(Range) <> varDispatch then Exit;
  try
    Range.NumberFormatLocal := FormulaString;
    Result := True;
  except
  end;
end;

function TExcelReport.GetLastCol: integer;
Var
 CurRow : Integer;
 CurCol : Integer;
begin
 Result := 1;
 Try
   CurRow := FXlApp.ActiveCell.Row;
   CurCol := FXlApp.ActiveCell.Column;
   Result := CurCol;
   FXlApp.Selection.End[xlToRight].Select;
   Result := FXlApp.ActiveCell.Column;
   FXlApp.ActiveSheet.Cells[CurRow, CurCol].Select;
 except
 end;
end;

function TExcelReport.GetLastRow: integer;
Var
 CurRow : Integer;
 CurCol : Integer;
begin
 Result := 1;
 Try
   CurRow := FXlApp.ActiveCell.Row;
   CurCol := FXlApp.ActiveCell.Column;
   Result := CurRow;
   FXlApp.Selection.End[xlDown].Select;
   Result := FXlApp.ActiveCell.Row;
   FXlApp.ActiveSheet.Cells[CurRow, CurCol].Select;
 Except
 End;
end;

function TExcelReport.GetRow: integer;
begin
 try
   Result := FXlApp.ActiveCell.Row;
 except
   Result := 1;
 end;
end;

function TExcelReport.GetSheetsCaption(SheetNo: integer): string;
begin
  result := '';
  try
//    if varType(FXlApp) <> VarDispatch then exit;
//    result := FXlApp.WorkBooks[1].WorkSheets[SheetNo].Name;
    if varType(FXlSheets) <> VarDispatch then exit;
    if (SheetNo > 0) and (SheetNo <= FXlSheets.Count) then
//      result := FXlSheets[SheetNo].Name;
      result := FXlSheets.Item[SheetNo].Name;
  except
    result := '';
  end;
end;

function TExcelReport.GotoLastCol: boolean;
begin
 Result := True;
 try
   FXlApp.Selection.End[xlToRight].Select;
 except
   Result := False;
 End;
end;

function TExcelReport.GotoLastRow: boolean;
begin
 Result := True;
 try
   FXlApp.Selection.End[xlDown].Select;
 except
   Result := False;
 end;
end;

function TExcelReport.GotoLeftMoreCol: boolean;
begin
 Result := True;
 Try
   FXlApp.Selection.End[xlToLeft].Select;
 Except
   Result := False;
 End;
end;

function TExcelReport.GotoTopRow: boolean;
begin
 Result := True;
 Try
   FXlApp.Selection.End[xlUp].Select;
 Except
   Result := False;
 End;
end;

procedure TExcelReport.NewSheet;
begin
  if VarType(FXlApp) <> VarDispatch then // If we are not connected with MsExcel
    Open
//  else if not VarIsEmpty(FXlBook) then // if connected with MsExcel
  else if not VarIsEmpty(FXlSheets) then // if connected with MsExcel
  begin
//    FXlSheet  := FXlBook.Sheets.Add(,,1,xlWorksheet); // Active Sheet
                                 // xlChart, xlDialogSheet, xlExcel4IntlMacroSheet
                                 // xlExcel4MacroSheet, xlWorksheet
//    FXlSheets := FXlApp.Sheets; // Array of Sheets
//    FActiveSheetNo := FXlBook.Sheets.Count;
    FXlSheet  := FXlSheets.Add(, FXlSheet,1,xlWorksheet); // Active Sheet
    FActiveSheetNo := FXlSheets.Count;
  end;
end;

function TExcelReport.Open(BCreate: Boolean): boolean;
begin
  result := true;
  try
    if BCreate then
    begin
      FXlApp  := CreateOleObject('Excel.Application');
    end
    else
    begin
      try
        FXlApp := GetActiveOleObject('Excel.Application');
      except
        FXlApp  := CreateOleObject('Excel.Application');
      end;
    end;

    if VarType(FXlApp) <> VarDispatch then
    begin
      if VarType(FXlApp) <> VarDispatch then FXlApp.Quit;
      if ShowMess then ErrorDlg(CSExcelNotInstall);
      Exit;
    end;
    FXlApp.ScreenUpdating := False;
    FXLApp.DisplayAlerts := false;
    FXlBook := FXlApp.WorkBooks.Add(xlWBATWorksheet);
    FXlSheets := FXLBook.Sheets;
    FXlSheet  := FXlBook.Sheets[1];
    FXlApp.Visible := FVisible;
    FActiveSheetNo := 0;
    FExcelValided := true;
    SetDefaultFont;
  except
    result := false;
    FExcelValided := false;
    if VarType(FXlApp) <> VarDispatch then
      FXlApp.Quit;
    if ShowMess then ErrorDlg(CSOpenExcelOleError);
  end;
end;

procedure TExcelReport.SaveEx(FileName: string; Format: XlFileFormat = xlWorkbookDefault{xlAddIn} {xlExcel9795});
var
  sId: string;
begin
  sId := ExtractFileExt(FileName);
  if SameText(sId, '.xls') then
    Format := xlAddIn;

  if varType(FxlApp) <> varDispatch then exit;
  try
    FXlSheet.SaveAs(FileName, Format);
    FXlBook.close;
  except
    if Format = xlNormal then
      FXlSheet.SaveCopyAs(FileName)
    else
      FXlSheet.SaveCopyAs(FileName, Format);
  end;
end;

function TExcelReport.SelectCell(RowNum, ColNum: integer): boolean;
begin
 Result := True;
 try
   FXlApp.ActiveSheet.Cells[RowNum, ColNum].Select;
 except
   Result := False;
 end;
end;

function TExcelReport.GetRange(FillRange: TFillRange): variant;
var
  TextRange: string;
begin
  result := varEmpty;
  if VarType(FXlSheet) <> VarDispatch  then Exit;
  try
    TextRange := GetRangeText(FillRange);
    result := FXlSheet.Range[TextRange]; // Range Asign
  except
  end;
end;


procedure TExcelReport.SetActiveSheetCaption(const Value: string);
begin
  if varType(FXLSheet) <> varDispatch then exit;
  try
    FXlSheet.Name := value;
  except
  end;
end;

procedure TExcelReport.SetActiveSheetNo(const Value: integer);
begin
  FActiveSheetNo := Value;
  if FActiveSheetNo <= 0 then FActiveSheetNo := 1;

  if (FActiveSheetNo <= FXlSheets.count) then
  begin
//    FXlApp.WorkBooks[1].Sheets[FActiveSheetNo].Activate;
    FXlSheets.Item[FActiveSheetNo].Activate;
    FXlSheet := FXlSheets.Item[FActiveSheetNo];
  end
  else
    NewSheet;
end;

procedure TExcelReport.SetCaption(const Value: string);
begin
  FCaption := Value;
  if VarType(FXlApp) <> VarDispatch  then exit;
  FXlApp.Caption := FCaption;
end;

function TExcelReport.SetCellFormula(FormulaString: ShortString; RowNum,
  ColNum: Integer): Boolean;
begin
 Result := True;
 try
   FXlApp.ActiveSheet.Cells[RowNum, ColNum].Formula := FormulaString;
 except
   Result := False;
 end;
end;

function TExcelReport.SetColWidth(Col: integer; Width: single): boolean;
begin
  result := false;
  if varType(FXlApp) <> VarDispatch then exit;
  try
    FXlApp.ActiveSheet.Columns[Col].ColumnWidth := Width;
    result := true;
  except
    result := false;
  end;
end;

function TExcelReport.SetColumnWidth(ColNum,
  ColumnWidth: Integer): Boolean;
var
 RowWas : Integer;
 ColWas : Integer;
begin
 try
   RowWas := GetRow;
   ColWas := GetCol;
   SelectCell(1,ColNum);
   FXlApp.Selection.ColumnWidth := ColumnWidth;
   SelectCell(RowWas,ColWas);
   Result := True;
 except
   Result := False;
 end;
end;

procedure TExcelReport.SetFillFrameColor(const Value: TFillFrameColor);
begin
  FFillFrameColor := Value;
end;

function TExcelReport.SetRowHeight(Row, Height: integer): boolean;
begin
  result := false;
  if varType(FXlApp) <> VarDispatch then exit;
  try
    FXlApp.ActiveSheet.Rows[Row].RowHeight := Height;
    result := true;
  except
    result := false;
  end;
end;

procedure TExcelReport.SetSheetsCaption(SheetNo: integer;
  const Value: string);
begin
  try
    if varType(FXlSheets) <> VarDispatch then exit;
    if (SheetNo > 0) and (SheetNo <= FXlSheets.Count) then
      FXlSheets[SheetNo].Name := Value;
  except
  end;
end;

procedure TExcelReport.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  if VarType(FXlApp) <> VarDispatch  then exit;
  FXLApp.Visible := FVisible;
end;

procedure TExcelReport.SetRangeFontsExEx(const ARange: Variant;
       const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer; ABackGroupInvalid: Boolean = False;
       ABackGroup: Integer = cTitleColor1);
begin
  SetRangeFonts(ARange, AColor, AStyle, ASize);
  if ABackGroupInvalid then
    ARange.Interior.ColorIndex := ABackGroup;
end;

procedure TExcelReport.SetRangeFontsExEx(const fr: TFillRange;
  const AColor: TColor; const AStyle: TFontStyles; const ASize: Integer;
  ABackGroupInvalid: Boolean; ABackGroup: Integer);
var
  ARange: Variant;
begin
  ARange := GetRange(fr);
  SetRangeFontsExEx(ARange, AColor, AStyle, ASize, ABackGroupInvalid, ABackGroup);
end;

procedure TExcelReport.SetCellFont_NSN(ARow1, ARow2: Integer; ACol1,
  ACol2: string; AColor: TColor; AStyle: TFontStyles; ABackgroup: Integer);
var
  ARange: Variant;
begin
   ARange := FxlSheet.Range[Format('%s%d:%s%d', [ACol1, ARow1, ACol2, ARow2])];
  if fsBold in AStyle then
    ARange.Font.Bold := True;

  if fsItalic in AStyle then
    ARange.Font.Italic := True;

  if fsUnderline in AStyle then
    ARange.Font.Underline := True;

  ARange.Font.Color := AColor;
  ARange.Interior.ColorIndex := ABackgroup;
end;

procedure TExcelReport.SetRangeBorders_NSN(ARange: string;
  const HAlignment: Int64);
begin
  //SetRangeBorders_NSN(FXlSheet.Range[ARange], HAlignment);
end;

procedure TExcelReport.SetRangeBorders_NSN(ARange: Variant;
  const HAlignment: Int64);
begin
//  if HAlignment = xlLeft then
//    ARange.HorizontalAlignment := xlLeft
//  else if HAlignment = xlCenter then
//    ARange.HorizontalAlignment := xlCenter
//  else if HAlignment = xlRight then
//    ARange.HorizontalAlignment := xlRight;
  ARange.Borders.LineStyle := 1;
  ARange.Borders.Weight := 2;
end;

procedure TExcelReport.SetRangeBorders_NSN(RowS, ColS, RowE, ColE: Integer; const HAlignment: Int64 = xlCenter);
var
  v: Variant;
begin
  v := GetRange(ColS, ColE, RowS, RowE);
  SetRangeBorders_NSN(V, HAlignment);
end;

function TExcelReport.SetRangeAlignDefault(FillRange: TFillRange): Boolean;
var
  v: Variant;
begin
  Result := True;
  try
    v := GetRange(FillRange);
    v.HorizontalAlignment := xlLeft;
    v.VerticalAlignment := xlCenter;
  except
    Result := False;
  end;
end;

/// <summary>
/// 增加一个重载函数，方便使用
/// </summary>
/// <param name="sRow">开始的行号</param>
/// <param name="sCol">开始的列号</param>
/// <param name="eRow">结束的行号</param>
/// <param name="eCol">结束的列号</param>
/// <param name="bWrap">设置是否换行</param>
/// <returns>标志是否是否出错</returns>
function TExcelReport.SetRangeWrapText(sRow: Integer; sCol: Integer; eRow: Integer; eCol: Integer; bWrap: Boolean): Boolean;
var
  fr: TFillRange;
begin
  Result := True;
  try
    fr.FromCell.Row := sRow;
    fr.FromCell.Col := sCol;
    fr.ToCell.Row := eRow;
    fr.ToCell.Col := eCol;
    SetRangeWrapText(fr, bWrap);
  except
    Result := False;
  end;
end;

/// <summary>
/// 设置一个范围的边框
/// </summary>
/// <param name="SRow">开始的行号</param>
/// <param name="SCol">开始的列号</param>
/// <param name="ERow">结束的行号</param>
/// <param name="ECol">结束的列号</param>
/// <param name="BorderColor">边框颜色</param>
/// <param name="BorderWeight">边框Weight</param>
/// <param name="BorderLineStyle"></param>
/// <param name="Inner"></param>
/// <returns></returns>
function  TExcelReport.SetRangeBorder(SRow: Integer;
                             SCol: Integer;
                             ERow: Integer;
                             ECol: Integer;
                             BorderColor: TColor;
                             BorderWeight: TBorderWeight;
                             BorderLineStyle: TBorderLineStyle; Inner: boolean = false): Boolean;
var
  fr: TFillRange;
begin
  Result := True;
  try
    fr.FromCell.Row := SRow;
    fr.FromCell.Col := SCol;
    fr.ToCell.Row := ERow;
    fr.ToCell.Col := ECol;
    SetRangeBorder(fr, BorderColor, BorderWeight, BorderLineStyle, Inner);
  except
    Result := False;
  end;
end;

/// <summary>
/// 针对OFFICE2007有效的设置Excel对齐,默认为左对齐
/// </summary>
/// <param name="sRow">起始的行号</param>
/// <param name="sCol">起始的列号</param>
/// <param name="eRow">结束的行号</param>
/// <param name="eCol">结束的列号</param>
/// <returns>标记是否出错</returns>
function TExcelReport.SetRangeAlignDefault(sRow: Integer; sCol: Integer; eRow: Integer; eCol: Integer): Boolean;
var
  fr: TFillRange;
begin
  Result := True;
  try
    fr.FromCell.Row := SRow;
    fr.FromCell.Col := SCol;
    fr.ToCell.Row := ERow;
    fr.ToCell.Col := ECol;
    SetRangeAlignDefault(fr);
  except
    Result := False;
  end;
end;


{-------------------------------------------------------------------------------
  过程名:    TExcelReport.AddBasic_3DPie
  作者:      rainychan
  日期:      2011.11.28
  参数:      ChartRowStart: Integer; Chart图的起始行号
             ChartColStart: Integer; Chart图的起始列号
             ChartRowEnd: Integer;   Chart图的终止行号
             ChartColEnd: Integer;   Chart图的终止列号
             DataRange: TFillRange;  Chart图的数据区域，参考TFillRange的结构
             LegendRange: TFillRange; Chart图的类别区域
             sChartTitle: string;     Chart图的类别区域
  返回值:    Boolean：执行过程是否有异常
-------------------------------------------------------------------------------}
function TExcelReport.AddBasic_3DPie(ChartRowStart: Integer; ChartColStart: Integer; ChartRowEnd: Integer;
  ChartColEnd: Integer; DataRange: TFillRange; LegendRange: TFillRange; sChartTitle: string): Boolean;
var
  xlChart, xlSeries: Variant;
begin
  Result := False;
  try
    xlChart := FXlSheet.ChartObjects.Add(FXlSheet.Cells[ChartRowStart, ChartColStart].Left,
                                                FXlSheet.Cells[ChartRowStart, ChartColStart].Top,
                                                FXlSheet.Cells[ChartRowStart, ChartColEnd].Left - FXlSheet.Cells[ChartRowStart, ChartColStart].Left,
                                                FXlSheet.Cells[ChartRowEnd, ChartColStart].Top - FXlSheet.Cells[ChartRowStart, ChartColStart].Top);
    xlChart.Chart.ChartType := xl3dPie;
    xlSeries := xlChart.Chart.SeriesCollection.NewSeries;
    xlSeries.Values := Format('=''%s''!R%dC%d:R%dC%d',
                 [FxlSheet.Name, DataRange.FromCell.Row, DataRange.FromCell.Col, DataRange.ToCell.Row, DataRange.ToCell.Col]);
                 // Axes(xvCategory).
    xlChart.Chart.Axes(xlCategory).CategoryNames := Format('=''%s''!R%dC%d:R%dC%d',
                 [CurSheet.Name, LegendRange.FromCell.Row, LegendRange.FromCell.Col, LegendRange.ToCell.Row, LegendRange.ToCell.Col]);
    xlChart.Chart.HasTitle := True;
    if sChartTitle = '' then
      sChartTitle := 'Undefine';
    xlChart.Chart.ChartTitle.Text := sChartTitle;
    xlChart.Chart.SeriesCollection(1).ApplyDataLabels;
    xlChart.Chart.ChartTitle.Font.Size := 16;
    xlChart.Chart.ChartTitle.Font.Bold := True;
  except
    Result := False;
  end;
end;

function TExcelReport.CombineCells(const RowS, ColS, RowE,
  ColE: Integer): Boolean;
var
  fr: TFillRange;
begin
  fr.FromCell.Row := RowS;
  fr.FromCell.Col := ColS;
  fr.ToCell.Row := RowE;
  fr.ToCell.Col := ColE;
  Result := CombineCells(fr);
end;

procedure TExcelReport.ClearComments;
var
  iCir: Integer;
begin
  for iCir := 1 to FXlBook.Sheets.Count do
  begin
    FXLSheets.Item[iCir].Activate;
    FXLSheets.Item[iCir].Cells.Select;
    FXlApp.Selection.ClearComments;
    FXlSheets.Item[iCir].Cells[1, 1].Select;
  end;
end;

{* 完全拷贝Range，包含内容和格式 *}
// Added by shibiao.chen 2012-5-21 15:40:55
function TExcelReport.CopyRangeEx(SrcRange, DstRange: TFillRange): Boolean;
var
  vSrc, vDest: Variant;
begin
  vSrc := GetRange(SrcRange);
  vDest:= GetRange(DstRange);
  if varType(vSrc) <> VarDispatch then Exit;
  if varType(vDest) <> VarDispatch then Exit;
  vSrc.Copy;
  vSrc.Select;
  vDest.PasteSpecial;
end;

end.



