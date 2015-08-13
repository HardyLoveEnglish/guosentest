unit uStaticFunction;

interface

uses
  SysUtils, Grids, Controls, Classes, uMyTools;

function GetOperaterResult(dTotalValue, dOneValue: Double): Double; overload;
function GetOperaterResult(dTotalValue, dOneValue: Integer): Integer; overload;
function GetPercentFormat(AValue: Double; ABitInt: Integer = 2): string;
function GetFloatFormat(AValue: Double; ABitInt: Integer = 4): string;
function FormatDBDate(Value: TDateTime): string;
function FormatDBDateTime(Value: TDateTime): string;
//------------------------------------------------------------------------------
//StringGrid排序函数
procedure GridQuickSort(Grid: TStringGrid; ACol: Integer; Order: Boolean ; NumOrStr: Boolean);
procedure StringGridTitleDown(Sender: TObject; 
 Button: TMouseButton;  X, Y: Integer); 
//------------------------------------------------------------------------------

implementation

function GetOperaterResult(dTotalValue, dOneValue: Double): Double; overload;
begin
  Result := dTotalValue + dOneValue;
end;

function GetOperaterResult(dTotalValue, dOneValue: Integer): Integer; overload;
begin
  Result := dTotalValue + dOneValue;
end;

function GetPercentFormat(AValue: Double; ABitInt: Integer = 2): string;
var
  sFormat: string;
begin
  sFormat := Format('%%.%df', [ABitInt]);
  Result := Format(sFormat, [(AValue * 100)]) + '%';
end;

function GetFloatFormat(AValue: Double; ABitInt: Integer = 4): string;
begin
  Result := Format('%%.%df', [ABitInt]);
  Result := Format(Result, [AValue]);
end;

function FormatDBDate(Value: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD', Value);
end;

function FormatDBDateTime(Value: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD HH:NN:SS.ZZZ', Value);
end;


//------------------------------------------------------------------------------

//StringGrid排序函数
// Added by zhbgt 2015-04-06 16:26:58
procedure GridQuickSort(Grid: TStringGrid; ACol: Integer; Order: Boolean ; NumOrStr: Boolean); 
(******************************************************************************) 
(*  函数名称：GridQuickSort                                                   *) 
(*  函数功能：给 StringGrid 的 ACol 列快速法排序    _/_/     _/_/  _/_/_/_/_/ *) 
(*  参数说明:                                          _/   _/        _/      *) 
(*            Order: True 从小到大                       _/          _/       *) 
(*                 : False 从大到小                     _/          _/        *) 
(*        NumOrStr : true 值的类型是Integer          _/_/        _/_/         *) 
(*                 : False 值的类型是String                                   *) 
(*  函数说明：对于日期，时间等类型数据均可按字符方式排序，                    *) 
(*                                                                            *) 
(*                                                                            *) 
(*                                             Author: YuJie  2001-05-27      *) 
(*                                             Email : yujie_bj@china.com     *) 
(******************************************************************************) 
   procedure MoveStringGridData(Grid: TStringGrid; Sou,Des :Integer ); 
   var 
     TmpStrList: TStringList ; 
     K : Integer ; 
   begin 
     try 
       TmpStrList :=TStringList.Create() ; 
       TmpStrList.Clear ; 
       for K := Grid.FixedCols to Grid.ColCount -1 do 
         TmpStrList.Add(Grid.Cells[K,Sou]) ; 
       Grid.Rows [Sou] := Grid.Rows [Des] ; 
       for K := Grid.FixedCols to Grid.ColCount -1 do 
         Grid.Cells [K,Des]:= TmpStrList.Strings[K] ; 
     finally 
       TmpStrList.Free ; 
     end; 
   end; 

   procedure QuickSort(Grid: TStringGrid; iLo, iHi: Integer); 
   var 
     Lo, Hi : Integer; 
     Mid: String ; 
   begin 
     Lo := iLo ; 
     Hi := iHi ; 
     Mid := Grid.Cells[ACol,(Lo + Hi) div 2]; 
     repeat 
       if Order and not NumOrStr then //按正序、字符排 
       begin 
         while Grid.Cells[ACol,Lo] < Mid do Inc(Lo); 
         while Grid.Cells[ACol,Hi] > Mid do Dec(Hi); 
       end ; 
       if not Order and not NumOrStr then //按反序、字符排 
       begin 
         while Grid.Cells[ACol,Lo] > Mid do Inc(Lo); 
         while Grid.Cells[ACol,Hi] < Mid do Dec(Hi); 
       end; 

       if NumOrStr then 
       begin 
         if Grid.Cells[ACol,Lo] = '' then Grid.Cells[ACol,Lo] := '0' ; 
         if Grid.Cells[ACol,Hi] = '' then Grid.Cells[ACol,Hi] := '0' ; 
         if Mid = '' then Mid := '0' ; 
         if Order then 
         begin //按正序、数字排 
           while StrToFloat(Grid.Cells[ACol,Lo]) < StrToFloat(Mid) do Inc(Lo); 
           while StrToFloat(Grid.Cells[ACol,Hi]) > StrToFloat(Mid) do Dec(Hi); 
         end else 
         begin //按反序、数字排 
           while StrToFloat(Grid.Cells[ACol,Lo]) > StrToFloat(Mid) do Inc(Lo); 
           while StrToFloat(Grid.Cells[ACol,Hi]) < StrToFloat(Mid) do Dec(Hi); 
         end; 
       end ; 
       if Lo <= Hi then 
       begin 
         MoveStringGridData(Grid, Lo, Hi) ; 
         Inc(Lo); 
         Dec(Hi); 
       end; 
     until Lo > Hi; 
     if Hi > iLo then QuickSort(Grid, iLo, Hi); 
     if Lo < iHi then QuickSort(Grid, Lo, iHi); 
   end; 

begin 
  try
    QuickSort(Grid, Grid.FixedRows, Grid.RowCount - 1 ) ;
  except
    on E: Exception do
      DlgError('系统在排序数据的时候遇到异常:'#13+E.message);
      //Application.MessageBox(Pchar('系统在排序数据的时候遇到异常:'#13+E.message+#13'请重试，如果该问题依然存在请与程序供应商联系！'),'系统错误',MB_OK+MB_ICONERROR) ;
  end;
end; 

procedure StringGridTitleDown(Sender: TObject; 
 Button: TMouseButton;  X, Y: Integer); 
(******************************************************************************) 
(*  函数名称：StringGridTitleDown                                             *) 
(*  函数功能：取鼠标点StringGrid 的列                _/_/     _/_/  _/_/_/_/_/ *) 
(*  参数说明:                                          _/   _/        _/      *) 
(*            Sender                                     _/          _/       *) 
(*                                                      _/          _/        *) 
(*                                                   _/_/        _/_/         *) 
(*                                                                            *) 
(*                                                                            *) 
(*                                             Author: YuJie  2001-05-27      *) 
(*                                             Email : yujie_bj@china.com     *) 
(******************************************************************************) 
var 
 I: Integer ; 
begin 
 if (Y > 0 ) and (y < TStringGrid(Sender).DefaultRowHeight * TStringGrid(Sender).FixedRows ) then 
 begin 
   if  Button = mbLeft then 
   begin 
     I := X div  TStringGrid(Sender).DefaultColWidth ; 
     //这个i 就是要排序得行了 
     // 下面调用上面的排序函数就可以了， 
     GridQuickSort(TStringGrid(Sender), I, False, True) ; 
   end; 
 end; 
end;

end.
