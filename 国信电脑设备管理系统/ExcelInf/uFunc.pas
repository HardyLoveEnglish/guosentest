//******************************************************************************
//                        Ding-Li Pilot RCU v 1.0
//               (c) Ding-Li Communications Inc. 1997-2001
//                          ALL RIGHTS RESERVED
//******************************************************************************

//Written Ding-Li Communications Inc.
//Subject:  RCU Server
//Version 1.00
//Release for
//Platform: Delphi 5, Win9x, NT ,2000Pro
//Date:  2002.2
//Last update:
//Release:
//Author:zjb.

{------------------------------------------------------------------------------}
{	Test data file access calss.
{------------------------------------------------------------------------------}
{ A component to encapsulate the RCU test data access.                         }
{                                                                              }
{ Copyright 2001-2001, Ding-Li Pilot Stuff.  All Rights Reserved.              }
{                                                                              }
{ Copyright:                                                                   }
{ All Ding-Li Pilot Stuff (hereafter "DPS") source code is copyrighted by      }
{ Ding-Li Communications Inc. (hereafter "author"), and shall remain the       }
{ exclusive property of the author.                                            }
{                                                                              }
{                                                                              }
{ Restrictions:                                                                }
{ Without the express written consent of the author, you may not:              }
{                                                                              }
{ Warranty:                                                                    }
{                                                                              }
{ Support:                                                                     }
{ Support is provided via the DPS Support Forum, which is a web-based message  }
{ system.  You can find it at http://www.dingli.com/discus/                    }
{                                                                              }
{ Clarifications:                                                              }
{                                                                              }
{------------------------------------------------------------------------------}
{: This unit provides ...

  Note: some good function delcare

}
unit uFunc;

interface
uses
  Forms, Dialogs, Windows, Sysutils, classes, {$ifdef windows}FileCtrl,{$endif}
  comobj, shlobj, ActiveX, strUtils,Controls, StdCtrls, Graphics, CommCtrl,
  WinSvc, Comctrls, Math, CheckLst, TypInfo, Menus, DateUtils;

type
  TEventType = (evtError,evtWarning,evtInformation,evtAuditSuccess,evtAuditFailure);

{Dlg}
procedure ErrorDlg(Mess: string);overload; {Show Error Message}
procedure InfoDlg(Mess: string); overload;{Show infomation Message}
procedure ErrorDlg(Mess: string; const Args: array of const);overload; {Show Error Message}
procedure InfoDlg(Mess: string; const Args: array of const);overload; {Show infomation Message}
function  ComfirmDlg(Mess: string): boolean;overload;
function  ComfirmDlg(Mess: string; const Args: array of const): boolean; overload;
function  DeleteDlg: boolean;

{Show Comfirm Dlg if ok then reuslt := true}
procedure IntDlg(Int: integer);
procedure DateDlg(Date: TDatetime);

function MyOpenDlg(Filter, Ext: string; out str: string): boolean;
function MySaveDlg(Filter, Ext: string; out str: string; FileName: string = ''): boolean;

{Get the temp file in system's temp folder}
function  GetSystemTempFile: string;
procedure WriteToTempFile(FileName: string; Buf: string);overload;

procedure WriteToTempFile(FileName: string; Int: Integer); overload;
procedure WriteToTempFile(FileName: string; Buf: string; Int: Integer); overload;

procedure WriteToTempFile(FileName: string; f: Double); overload;
procedure WriteToTempFile(FileName: string; Buf: string; f: Double); overload;

procedure WriteToTempFile(FileName: string; b: boolean); overload;
procedure WriteToTempFile(FileName: string; Buf: string; b: boolean); overload;

procedure WriteToTempFile_Date(FileName: string; D: TDateTime); overload;
procedure WriteToTempFile_Date(FileName: string; Buf: string; D: TDateTime); overload;
procedure WriteToTempFile_Date(FileName: string; Buf: string; i: integer; D: TDateTime); overload;

function  IsFileInUse(fName: string): boolean; {is the file is used}

function WithoutBackslash(s: string): string; {Exclude '\'}
function WithBackSlash(s: string): string; {Include '\'}
function capfirst(value:string):string;
{Capitalise first character of each word, lowercase remaining chars}
{example: capfirst('bOrLANd delPHi FOR windOWs') = 'Borland Delphi For Windows'}
function striptags(value:string):string;
{strip HTML tags from value}
{example: striptags('<TR><TD Align="center">Hello World</TD>') = 'Hello World'}

function strRepeat(c:char;l:integer):string;
{returns a string containing l of character c.}
{example: strs('=',12) = '============'}
function ExtractToken(var line: string; sep: char): string;
function FastEOL(str: PChar): PChar; register;
function ExtractLine(var text: PChar): string;


function CoverBin(Value: integer): string;
function MyIntToHEX(Value: Integer): string;
function SToHEX(S: string): string;

function FToStr(f: double): string; {format float to str}
function DToStr(d: TDateTime): string; {format Date time to str }

function SToI(s: string; default: integer): integer;
function SToS(s: string; default: Single): single;


function SToBool(s: string): boolean;{string to boolean}
function BooltoS(b: boolean): string; {boolean to string}


function IToStr(i: integer): string; {integer to string}
function StrToI(s: string): integer; {string to integer}

function  StrEqual(const src, Des: string): boolean; {to check if two string equal}
procedure GetStringList(s, sub: string; Ls: TStringList);

procedure ClearObjectList(var Ls: TList); overload; {clear the object in list}
procedure ClearObjectList(var Ls: TStringList); overload;
procedure ClearThreadList(var Ls: TList;  AndFree: boolean = true);
{clear the object in stringlist}
procedure ClearObjectList(var Ls: TList; AndFree: boolean); overload;
{clear the object in list}
procedure ClearObjectList(var Ls: TStringList; AndFree: boolean); overload;
{clear the object in stringlist}
procedure ClearList(var Ls: TList); overload;
{Just Clear and Free TList not contain Object}
procedure ClearList(var Ls: TStringList); overload;
{Just Clear and Free TStringList not contain Object}

procedure ClearMenu(Menu: TMainMenu);overload;
procedure ClearMenu(Menu: TPopupMenu);overload;
procedure ClearMenu(Menu: TMenuItem); overload;

function AddTimes(const D, T: TDateTime): TDateTime;
function AddHours(const D: TDateTime; const N: integer): TDateTime;
function AddMinutes(const D: TDateTime; const N: Integer): TDateTime;
{Time to add some minutes}
function AddMSec(const D: TDateTime; const N: integer): TDateTime;
function AddSec(const D: TDateTime; const N: integer): TDateTime;
function AddDays (const D : TDateTime; const N : Integer) : TDateTime;
function AddWeeks (const D : TDateTime; const N : Integer) : TDateTime;
function AddMonths (const D : TDateTime; const N : Integer) : TDateTime;
function AddYears (const D : TDateTime; const N : Integer) : TDateTime;


function  IsSunday (const D : TDateTime) : Boolean;
function  IsMonday (const D : TDateTime) : Boolean;
function  IsTuesday (const D : TDateTime) : Boolean;
function  IsWedneday (const D : TDateTime) : Boolean;
function  IsThursday (const D : TDateTime) : Boolean;
function  IsFriday (const D : TDateTime) : Boolean;
function  IsSaturday (const D : TDateTime) : Boolean;
function  IsWeekend (const D : TDateTime) : Boolean;

function  IsNumber(const sNumber: String): Boolean;

function  DayOfYear (const Ye, Mo, Da : Word) : Integer; overload;
function  DayOfYear (const D : TDateTime) : Integer; overload;
function  DaysInMonth (const Ye, Mo : Word) : Integer; overload;
function  DaysInMonth (const D : TDateTime) : Integer; overload;
function  DaysInYear (const Ye : Word) : Integer; overload;
function  DaysInYear (const D : TDateTime) : Integer; overload;

function  DiffMilliseconds (const D1, D2 : TDateTime) : Int64;
function  DiffSeconds (const D1, D2 : TDateTime) : Integer;
function  DiffMinutes (const D1, D2 : TDateTime) : Integer;
function  DiffHours (const D1, D2 : TDateTime) : Integer;
function  DiffDays (const D1, D2 : TDateTime) : Integer;
function  DiffWeeks (const D1, D2 : TDateTime) : Integer;
function  DiffMonths (const D1, D2 : TDateTime) : Integer;
function  DiffYears (const D1, D2 : TDateTime) : Integer;
function  ZeroMissSeconds(const d1: TDateTime): TDateTime;

//bISO = True ±íÊ¾´ÓÐÇÆÚÒ»ÖÁÐÇÆÚÌì£¬·ñÔò±íÊ¾´ÓÐÇÆÚÌìÖÁÐÇÆÚÁù£»Added by weier.huang on 2005-03-24
function FirstDayOfWeek(const D: TDateTime; bISO: Boolean): TDateTime;
function LastDayOfWeek(const D: TDateTime; bISO: Boolean): TDateTime;
function FirstDayOfMonth (const D : TDateTime) : TDateTime;
function LastDayOfMonth (const D : TDateTime) : TDateTime;
function FirstDayOfSeason(const D: TDateTime): TDateTime;
function LastDayOfSeason(const D: TDateTime): TDateTime;
function FirstDayOfYear (const D : TDateTime) : TDateTime;
function LastDayOfYear (const D : TDateTime) : TDateTime;

function  FirstTimeOfDay(D: TDateTime): TDateTime;
function  LastTimeOfDay(D: TDateTime): TDateTime;
function  WeekNumber (const D : TDateTime) : Integer;

function  GetFirstDayByWeekDay(D: TDateTime; WeekDay: integer): TDateTime;
function  GetFirstDayByMonthDay(D: TDateTime; Day: integer): TDateTime;
function  GetFirstDayBySeasonDay(D: TDateTime): TDateTime;

function GetGSMTime(const Sec: integer; const uSec: integer): TDateTime;
function SetLocalSytemTime(NewTime: double): boolean;
function TruncMscSecond(const D: TDateTime): TDateTime;
function GetSecond(const D: TDateTime): integer;
function GetMSecond(const D: TDateTime): integer;
{ Converts GMT Time to Local Time                                              }
function GMTTimeToLocalTime (const D : TDateTime) : TDateTime; overload;
function GMTTimeToLocalTime(Const D: TDateTime; TimeZoneOffset: Integer): TDateTime; overload;
{ Converts Local Time to GMT Time                                              }
function LocalTimeToGMTTime (const D : TDateTime) : TDateTime; overload;
function LocalTimeToGMTTime(const D: TDateTime; TimeZoneOffset: Integer): TDateTime; overload;
function GMTNow: TDateTime;
function GetOnlyDate(dt: TDateTime): TDateTime;
function GetOnlyTime(dt: TDateTime): TDateTime;

function Padr(OrigStr: string; ResuLen: integer; InstChar: string): string;
{Fill string Right}
function Padl(OrigStr: string; ResuLen: integer; InstChar: string): string;
{Fill String Left}
function GetGUID: string; {Get the Guid to string}
function NewGUID: TGUID; {Get the GUID}

function BinSearch(IntArray: array of integer; low, High: integer; key:
  integer): integer; {Quick search binSearch}
procedure BinSort(var Ls: TStringList); {Quick Sort the stringList}

{Service op}
function Open_Service(ServiceName: string; var hSC, hSRV: Longint): boolean;
function Close_Service(var hSC: longint): boolean;
function Start_Service(var hSRV: longint): boolean;
function Stop_Service(var hSRV: longInt): boolean;
function GetStatus_Service(var hSRV: longInt): SERVICE_STATUS;

{Muti cpu support}
function GetNumberOfProceessor: integer;
function GetProcessID: Cardinal;
procedure GetProcessMask(ProcessID: Cardinal; var ProcessMask, SystemMask: Cardinal);

procedure ComparePattern(St1, St2: string; var Check: Boolean);

function  StrLenPas(tStr:PChar):integer; // is so fast
function GetSubList(aLine: string; aSub: string; ls: TStringList; uppercased: boolean): boolean;

{ListView op}
procedure SetListViewAllCheck( Lvw: TListView; CheckedAll: boolean);
procedure SetListViewBackCheck(Lvw: TListView);

procedure SetCheckListBoxAllCheck( Clb: TCheckListBox; CheckedAll: boolean);
procedure SetCheckListBoxBackCheck(Clb: TCheckListBox);

procedure LVCheckOnlySingle(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

function GetCheckItem(Lvw: TListView): TListItem;
function GetCheckItems(Lvw: TListView;
  var LiArr: array of TListItem): integer;
function GetAllItems(lvw: TListView;
  var LiArr: array of TListItem): integer;
procedure GetSelectedItems(lvw: TListView;
  var LiArr: array of TListItem);
procedure ClearListView(lvw: TListView);
procedure ClearListBox(lb: TListBox);

function  ControlAtPosEx(Father:TControl; const Pos: TPoint): TControl;

procedure SetTreeNodeChildStatesImage(Node: TTreeNode);
procedure SetTreeNodeParentStatesImage(Node: TTreeNode; StateIndex: integer);

procedure MyControlEnableState(Control: TWinControl; Value: boolean; Colored: boolean = true); overload;
procedure MyControlEnableState(Control: array of TWinControl; Value: boolean; Colored: boolean = true); overload;
procedure MyContorlSetFocus(Control: TWinControl);
procedure MyEditNAState(ed: TEdit);

function  GetDynamicColor(index: integer): TColor;
function  CompareTime(t1, t2: double): boolean;
function  CheckFloat(s: string): boolean;
function  CheckInt(s: string): boolean;
function  CheckDir(s: string): boolean;

function  CreateDynPageControl(pgc: TPageControl; Caption: string; Tag: integer): TTabSheet;
procedure FreeDynPageControl(pgc: TPageControl);

function  IsValidFileName(FileName:string):Boolean;
function  ReplaceFileName(FileName: string): string;
function  UniqueFilename(path:string):string;
function  GetTempFile(const prefix: string): string;
function  GetTempUniqueFileName(FileName: string): string;

function  ReadStringFromStream(Stream: TStream): string;
procedure WriteStringToStream(s: string; Stream: TStream);

procedure Delay(iTime: cardinal);
procedure SetImageIndex(Node: TTreeNode; Index: integer);
function  CorrectRound(x: Extended): LongInt;
function  GetLineIndexValue(s, Sub: string; Index: integer): string;
procedure MyQuickSort(const List: TList; const Compare: TListSortCompare);

//object op
function  Is_Object(Obj: TObject): Boolean;
function  IsClass(Cls: TClass): LongBool; register;
procedure SaveFree(pobj: pointer);     // Usage:    SaveFree(@Object)
procedure SaveFreeMem(pptr: pointer);  // Usage: SaveFreeMem(@Pointer)

function  GetRange(FromRange, ToRange: integer): double; overload;
function  GetRange(FromRange, ToRange: double): double; overload;
function  RandomRangeValue(Values: array of Integer): integer;
function  GetConditionCount(FromPercent, ToPercent: double;
   Total: integer): integer;

function  GetArrayFormatString_Caption(strs: array of string): string;
function  GetArrayFormatString_Data(strs: array of string; FromIndex: integer): string;

function  SmartFloatToStr(f: double): string;

function  RemoveLastInvalidChar(s: string; ch: char): string;
procedure MyDrawTab(pgc: TPageControl;Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);

function CheckEditInt(ctr: TCustomEdit; Mess: string = ''; Focus: boolean = true): boolean; overload;
function CheckEditInt(pgc: TPageControl; Index:integer; ctr: TCustomEdit;
  Mess: string = ''; Focus: boolean = true): boolean; overload;
function CheckEditHEX(pgc: TPageControl; Index:integer; ctr: TCustomEdit;
  Mess: string = ''; Focus: boolean = true): boolean;
function GetFileSize(const Filename: String): Integer;
function StrSimilar (s1, s2: string): Integer;
function Caculat_ErlandB(Traffic, Loss: single): integer;
function GetPathName(s: string): string;
function GetFileNameWithoutExt(s: string): string;
function WriteEventLog(Description: string = ''; ApplicationTitle:string = 'EricZeng';
         const AType: TEventType = evtInformation;
         const Category: Word = 0; const ID: LongWord = 0): boolean;
function GetListBoxText(lb: TListBox): string;
procedure SetListBoxText(lb: TListBox; s: string);
function MyZeroEndString(var Str: string): Integer;
function SameDouble(d1, d2: double): boolean;
function GetSubItemLeft(lvw: TListView; SubItem: integer): integer;
function CheckListItemData(li: TListItem): boolean;

function DateTime2Str(dtStart, dtEnd: TDateTime): String;
function Date2Str(dtStart, dtEnd: TDateTime): String;
function GetSpleepTime(Tick: integer): integer;

function StreamToStr(AStream: TStream): String;
function StrToStream(strData: String): TStream;

//return free size of specified disk;
function GetDiskFreeSize(sPath: String): Int64;

const
  CSNotValideKey = -9999;
  CSNotValideKeyStr = '-9999';
  CSIniMaxValue = -99999;
  CSIniMinValue = 99999;

const
  OneDay = 1.0;
  OneHour = OneDay / 24.0;
  OneMinute = OneHour / 60.0;
  OneSecond = OneMinute / 60.0;
  OneMillisecond = OneSecond / 1000.0;

const
  CsErrorDouble = '%s: invalid float';
  CsErrorInterger = '%s: invalid integer';

type TColorEntry = record
       Name: PChar;
       case Boolean of
         True: (R, G, B, reserved: Byte);
         False: (Color: COLORREF);
     end;

const DefaultColorCount = 40;
      // these colors are the same as used in Office 97/2000
      DefaultColors : array[0..DefaultColorCount - 1] of TColorEntry = (

        (Name: 'Red'; Color: $0000FF),
        (Name: 'Light Orange'; Color: $0099FF),
        (Name: 'Lime'; Color: $00CC99),
        (Name: 'Sea Green'; Color: $669933),
        (Name: 'Aqua'; Color: $CCCC33),
        (Name: 'Light Blue'; Color: $FF6633),
        (Name: 'Violet'; Color: $800080),
        (Name: 'Grey-40%'; Color: $969696),

        (Name: 'Dark Red'; Color: $000080),
        (Name: 'Orange'; Color: $0066FF),
        (Name: 'Dark Yellow'; Color: $008080),
        (Name: 'Green'; Color: $008000),
        (Name: 'Teal'; Color: $808000),
        (Name: 'Blue'; Color: $FF0000),
        (Name: 'Blue-Gray'; Color: $996666),
        (Name: 'Gray-50%'; Color: $808080),

        (Name: 'Black'; Color: $000000),
        (Name: 'Brown'; Color: $003399),
        (Name: 'Olive Green'; Color: $003333),
        (Name: 'Dark Green'; Color: $003300),
        (Name: 'Dark Teal'; Color: $663300),
        (Name: 'Dark blue'; Color: $800000),
        (Name: 'Indigo'; Color: $993333),
        (Name: 'Gray-80%'; Color: $333333),

        (Name: 'Pink'; Color: $FF00FF),
        (Name: 'Gold'; Color: $00CCFF),
        (Name: 'Yellow'; Color: $00FFFF),
        (Name: 'Bright Green'; Color: $00FF00),
        (Name: 'Turquoise'; Color: $FFFF00),
        (Name: 'Sky Blue'; Color: $FFCC00),
        (Name: 'Plum'; Color: $663399),
        (Name: 'Gray-25%'; Color: $C0C0C0),

        (Name: 'Rose'; Color: $CC99FF),
        (Name: 'Tan'; Color: $99CCFF),
        (Name: 'Light Yellow'; Color: $99FFFF),
        (Name: 'Light Green'; Color: $CCFFCC),
        (Name: 'Light Turquoise'; Color: $FFFFCC),
        (Name: 'Pale Blue'; Color: $FFCC99),
        (Name: 'Lavender'; Color: $FF99CC),
        (Name: 'White'; Color: $FFFFFF)
      );

      SysColorCount = 25;
      SysColors : array[0..SysColorCount - 1] of TColorEntry = (
        (Name: 'system color: scroll bar'; Color: COLORREF(clScrollBar)),
        (Name: 'system color: background'; Color: COLORREF(clBackground)),
        (Name: 'system color: active caption'; Color: COLORREF(clActiveCaption)),
        (Name: 'system color: inactive caption'; Color: COLORREF(clInactiveCaption)),
        (Name: 'system color: menu'; Color: COLORREF(clMenu)),
        (Name: 'system color: window'; Color: COLORREF(clWindow)),
        (Name: 'system color: window frame'; Color: COLORREF(clWindowFrame)),
        (Name: 'system color: menu text'; Color: COLORREF(clMenuText)),
        (Name: 'system color: window text'; Color: COLORREF(clWindowText)),
        (Name: 'system color: caption text'; Color: COLORREF(clCaptionText)),
        (Name: 'system color: active border'; Color: COLORREF(clActiveBorder)),
        (Name: 'system color: inactive border'; Color: COLORREF(clInactiveBorder)),
        (Name: 'system color: application workspace'; Color: COLORREF(clAppWorkSpace)),
        (Name: 'system color: highlight'; Color: COLORREF(clHighlight)),
        (Name: 'system color: highlight text'; Color: COLORREF(clHighlightText)),
        (Name: 'system color: button face'; Color: COLORREF(clBtnFace)),
        (Name: 'system color: button shadow'; Color: COLORREF(clBtnShadow)),
        (Name: 'system color: gray text'; Color: COLORREF(clGrayText)),
        (Name: 'system color: button text'; Color: COLORREF(clBtnText)),
        (Name: 'system color: inactive caption text'; Color: COLORREF(clInactiveCaptionText)),
        (Name: 'system color: button highlight'; Color: COLORREF(clBtnHighlight)),
        (Name: 'system color: 3D dark shadow'; Color: COLORREF(cl3DDkShadow)),
        (Name: 'system color: 3D light'; Color: COLORREF(cl3DLight)),
        (Name: 'system color: info text'; Color: COLORREF(clInfoText)),
        (Name: 'system color: info background'; Color: COLORREF(clInfoBk))
      );

type TBadUnallocProc=procedure(BadObject: TObject; CallAddr: Pointer);

const BadUnalloc:TBadUnallocProc=nil;

var
  MaxFillLen: integer;

implementation

procedure ErrorDlg(Mess: string); {Show Error Message}
begin
  {$ifdef __ActiveX}
  MessageBox(0, PChar(Mess), Pchar(Application.Title), MB_ICONERROR);
  {$else}
  Application.MessageBox(Pchar(Mess), Pchar(Application.title), MB_ICONERROR)
  {$endif}
end;

procedure InfoDlg(Mess: string);
begin
  {$ifdef __ActiveX}
  MessageBox(0, PChar(Mess), Pchar(Application.Title), MB_ICONINFORMATION);
  {$else}
  Application.MessageBox(pchar(Mess), PChar(Application.Title),
    MB_ICONINFORMATION);
  {$endif}
end;

procedure DateDlg(Date: TDatetime);
begin
  InfoDlg(FormatDateTime('YY-MM-DD HH:NN:SS', date));
end;

procedure ErrorDlg(Mess: string; const Args: array of const);overload; {Show Error Message}
begin
  ErrorDlg(Format(Mess, Args));
end;

procedure InfoDlg(Mess: string; const Args: array of const);overload; {Show infomation Message}
begin
  InfoDlg(Format(Mess, Args));
end;

function ComfirmDlg(Mess: string): boolean;
{Show Comfirm Dlg if ok then reuslt := true}
begin
  result := false;
  {$ifdef __ActiveX}
  if MessageBox(0, PChar(Mess), Pchar(Application.Title),
    MB_ICONQUESTION + MB_YESNO) = IDYes then
  {$else}
  if Application.MessageBox(pchar(Mess), PChar(Application.Title),
    MB_ICONQUESTION + MB_YESNO) = IDYes then
  {$endif}

    result := true;
end;

function  ComfirmDlg(Mess: string; const Args: array of const): boolean; overload;
begin
  result := ComfirmDlg(Format(Mess, args));
end;

function  DeleteDlg: boolean;
begin
  result := ComfirmDlg('Are you sure to delete it?');
end;

procedure IntDlg(Int: integer);
begin
  InfoDlg('Result is (int) :' + IToStr(Int));
end;

function MyOpenDlg(Filter, Ext: string; out str: string): boolean;
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(nil);
  try
    Dlg.DefaultExt := Ext;
    Dlg.Filter := Filter;
    result := Dlg.Execute;
    if result then str := Dlg.FileName;
  finally
    if assigned(Dlg) then FreeAndNil(Dlg);
  end;
end;

function MySaveDlg(Filter, Ext: string; out str: string; FileName: string = ''): boolean;
var
  dlg: TSaveDialog;
begin
  dlg := TSaveDialog.Create(nil);
  try
    Dlg.DefaultExt := Ext;
    Dlg.Options := Dlg.Options + [ofOverwritePrompt];
    Dlg.Filter := Filter;
    Dlg.FileName := FileName;
    result := Dlg.Execute;

    if result then str := Dlg.FileName;
  finally
    if assigned(Dlg) then FreeAndNil(Dlg);
  end;
end;

function WithoutBackslash(s: string): string;
begin
  result := ExcludeTrailingPathDelimiter(s);
end;

function WithBackSlash(s: string): string;
begin
  result := IncludeTrailingPathDelimiter(s);
end;

function capfirst(value:string):string;
var
i:integer;
s:string;
begin
  if (length(value)>0) then
    begin
    s:=uppercase(value[1]);
    for i:=2 to length(value) do
      if (value[i-1] in [' ', ',', ':', ';', '.', '(', '-']) then
        s:=s+uppercase(value[i])
      else
        s:=s+lowercase(value[i]);
    end;
  result:=s;
end;

function striptags(value:string):string;
var
  i:integer;
  s:string;
begin
  i:=1;
  s:='';
  while i<=length(value) do
  begin
    if value[i]='(' then
      repeat
        inc(i)
      until ((value[i]=')') or (i=length(value)))
    else
      s:=s+value[i];
    inc(i);
  end;
  result:=s;
end;

function strRepeat(c:char;l:integer):string;
var
  i: integer;
begin
  result:='';
  for i:=1 to l do
    result:=result+c;
end;

function ExtractToken(var line: string; sep: char): string;
var p: integer;
begin
  asm
    mov edx,line ; mov edx,[edx]
    mov ah,sep
    or edx,edx; jz @end
    xor ecx,ecx
  @et_cy:
    mov al,byte ptr [edx+ecx]
    cmp al,ah ; je @found
    or al,al  ; jz @end
    inc ecx
    jmp @et_cy

  @end:
    xor ecx,ecx ; dec ecx  // -1
  @found:
    mov p,ecx
  end;
  if p<0 then begin
    Result:=line; line:='';
  end else begin
    Result:=Copy(line,1,p);
    Delete(line,1,p+1);
  end;
end;
function FastEOL(str: PChar): PChar; assembler;
asm //             EAX->ESI
  push esi
  mov esi,eax
  mov edx,$00000D0A        // DL=$0A  DH=$0D
  or esi,esi ; jz @ret_esi
@fe_cy:
  lodsb
  or al,al ; je @ret_esi_m1
  cmp al,dl ; je @ret_esi_m1
  cmp al,dh ; jne @fe_cy
@ret_esi_m1:
  dec esi
@ret_esi:
  mov eax,esi
  pop esi
end;


function ExtractLine(var text: PChar): string;
var ple: PChar;
begin
  if (text=nil) or (text^=#0) then begin
    Result:=''; exit;
  end;
  ple:=FastEOL(text);
  SetString(Result,text,ple-text);
  if ple^=#13 then inc(ple);
  if ple^=#10 then inc(ple);
  text:=ple;
end;


function MyIntToHEX(Value: Integer): string;
var
  B: Byte;
  I: Integer;
begin
  Result := '';
  for I := 8 downto 1 do
  begin
    B := Byte(Value) and $F;
    Value := Value shr 4;
    if B > 9 then B := B - 10 + $41 else B := B + $30;
    if Result = '' then Result := Char(B) else Insert(Char(B), Result, 1);
  end;
end;

function CoverBin(Value: integer): string;
var
  b: byte;
  i: integer;
begin
  result := '';
  b := 0;
  for I:= 8 downto 1 do
  begin
    case I of
     8 :  b := (Value and $80) shr 7;
     7 :  b := (Value and $40) shr 6;
     6 :  b := (Value and $20) shr 5;
     5 :  b := (Value and $10) shr 4;
     4 :  b := (Value and $8) shr 3;
     3 :  b := (Value and $4) shr 2;
     2 :  b := (Value and $2) shr 1;
     1 :  b := (Value and $1);
    end;
    result := result + Inttostr(b);
  end;
end;


function SToHEX(S: string): string;
var
  B1, B2: Byte;
  I: Integer;
begin
  Result := '';
  if Length(S) = 0 then Exit;
  for I := 1 to Length(S) do
  begin
    B1 := Byte(S[I]);
    B2 := B1 and $F;
    B1 := (B1 shr 4) and $F;
    if B2 > 9 then B2 := B2 - 10 + $41 else B2 := B2 + $30;
    if B1 > 9 then B1 := B1 - 10 + $41 else B1 := B1 + $30;
    Result := Result + Char(B1) + Char(B2) + ' ';
  end;
end;

function IsFileInUse(fName: string): boolean;
var
  HFileRes: HFILE;
begin
  try
    //or GENERIC_WRITE
    HFileRes := CreateFile(pchar(fName), GENERIC_READ ,
      0 {this is the trick!}, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    Result := (HFileRes = INVALID_HANDLE_VALUE);
    if not Result then
      CloseHandle(HFileRes);
  except
    result := true;
  end;
end;

procedure ClearThreadList(var Ls: TList; AndFree: boolean = true); overload;
var
  i: integer;
begin
  if not assigned(Ls) then exit;
  for i := Ls.Count - 1 downto 0 do
  begin
    if assigned(Ls.Items[i]) then
      TThread(Ls.Items[i]).Terminate;
  end;

  Ls.Clear;
  if AndFree then
    FreeAndNil(Ls);
end;

procedure ClearObjectList(var Ls: TList); overload; {clear the object in list}
var
  i: integer;
begin
  if not assigned(Ls) then exit;
  for i :=  Ls.Count - 1 downto 0 do
  begin
    if assigned(Ls.Items[i]) then
      TObject(Ls.Items[i]).Free;
  end;
  Ls.Clear;
  FreeAndNil(Ls);
end;

procedure ClearObjectList(var Ls: TStringList); overload;
{clear the object in stringlist}
var
  i: integer;
begin
  if not assigned(Ls) then exit;
  try
    Ls.BeginUpdate;
    for i := Ls.Count - 1 downto 0 do
    begin
      if assigned(Ls.objects[i]) then
        TObject(Ls.objects[i]).free;
    end;
    Ls.Clear;
  finally
    Ls.EndUpdate;
  end;
  FreeAndNil(Ls);
end;

procedure ClearObjectList(var Ls: TList; AndFree: boolean); overload;
{clear the object in list}
var
  i: integer;
begin
  if not assigned(Ls) then exit;
  for i := Ls.Count - 1 downto 0 do
  begin
    if assigned(Ls.Items[i]) then
      TObject(Ls.Items[i]).Free;
  end;
  Ls.Clear;
  if AndFree then
    FreeAndNil(Ls);
end;

procedure ClearObjectList(var Ls: TStringList; AndFree: boolean); overload;
{clear the object in stringlist}
var
  i: integer;
begin
  if not assigned(Ls) then exit;
  try
    Ls.BeginUpdate;
    for i := Ls.Count - 1 downto 0 do
    begin
      if assigned(Ls.objects[i]) then
        TObject(Ls.objects[i]).free;
    end;
    Ls.Clear;
  finally
    Ls.EndUpdate;
  end;
  if AndFree then
    FreeAndNil(Ls);
end;


function FToStr(f: double): string;
begin
  result := FloatToStrF(f, ffGeneral, 10, 2);
end;


function DToStr(d: TDateTime): string;
begin
  result := FormatDateTime('yyyy-mm-dd hh:nn:ss', d);
end;

function SToI(s: string; default: integer): integer;
begin
  try
    result := StrToInt(s);
  except
    result := Default;
  end;
end;

function SToS(s: string; default: Single): single;
begin
  try
    result := StrToFloat(s);
  except
    result := Default;
  end;
end;

function SToBool(s: string): boolean; {string to boolean}
begin
  result := false;
  if uppercase(s) = 'TRUE' then result := true;
  if result then exit;
  if uppercase(s) = '1' then result := true;
end;

function BooltoS(b: boolean): string; {boolean to string}
begin
  result := 'FALSE';
  if b then result := 'TRUE';
end;

function IToStr(i: integer): string; {integer to string}
begin
  try
    result := Inttostr(i);
  except
    result := CSNotValideKeyStr;
  end;
end;

function StrToI(s: string): integer; {string to integer}
begin
  try
    result := strToInt(s);
  except
    result := CSNotValideKey;
  end;
end;

function StrEqual(const src, Des: string): boolean;
begin
  result := UpperCase(src) = UpperCase(Des);
end;

procedure GetStringList(s, sub: string; Ls: TStringList);
var
  iPos, SubLen: integer;
  Cy: string;
begin
  if s = '' then exit;
  if sub = '' then exit;
  if ls = nil then exit;
  subLen := Length(Sub);
  while s <> ''  do
  begin
    iPos := Pos(sub, s);
    if iPos > 0 then
    begin
      CY := System.Copy(s, 1, iPos - SubLen);
      System.Delete(s, 1, iPos);
    end
    else
    begin
      Cy := s;
      s  := '';
    end;
    try
      if CY <> '' then
        Ls.Add(CY);
    except
    end;
  end;
end;

procedure ClearList(var Ls: TList);
begin
  if Ls = nil then exit;
  Ls.Clear;
  FreeAndNil(Ls);
end;

procedure ClearList(var Ls: TStringList);
begin
  if Ls = nil then exit;
  Ls.Clear;
  FreeAndNil(Ls);
end;
function AddTimes(const D, T: TDateTime): TDateTime;
var
  Hour, Min, Sec, Msec: Word;
begin
   DecodeTime(T, Hour, Min, Sec, Msec);
   result := AddHours(D, Hour);
   result := AddMinutes(result, Min);
   result := AddSec(result, Sec);
   result := AddMSec(Result, Msec);
end;

function AddHours(const D: TDateTime; const N: integer): TDateTime;
begin
  result := D + OneHour * N;
end;

function AddMinutes(const D: TDateTime; const N: Integer): TDateTime;
begin
  Result := D + OneMinute * N;
end;

function AddMSec(const D: TDateTime; const N: integer): TDateTime;
begin
  result := D + OneMillisecond * N;
end;

function AddSec(const D: TDateTime; const N: integer): TDateTime;
begin
  result := D + OneSecond * N;
end;

function AddDays (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + N;
  End;
function AddWeeks (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + N * 7 * OneDay;
  End;

function AddMonths (const D : TDateTime; const N : Integer) : TDateTime;
var Ye, Mo, Da : Word;
    IMo : Integer;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Inc (Ye, N div 12);
    IMo := Mo;
    Inc (IMo, N mod 12);
    if IMo > 12 then
      begin
        Dec (IMo, 12);
        Inc (Ye);
      end else
      if IMo < 1 then
        begin
          Inc (IMo, 12);
          Dec (Ye);
        end;
    Mo := IMo;
    Da := Min (Da, DaysInMonth (Ye, Mo));
    Result := EncodeDate (Ye, Mo, Da) + Frac (D);
  End;

function AddYears (const D : TDateTime; const N : Integer) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Inc (Ye, N);
    Da := Min (Da, DaysInMonth (Ye, Mo));
    Result := EncodeDate (Ye, Mo, Da);
  End;


function IsSunday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 1;
  End;

function IsMonday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 2;
  End;

function IsTuesday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 3;
  End;

function IsWedneday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 4;
  End;

function IsThursday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 5;
  End;

function IsFriday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 6;
  End;

function IsSaturday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 7;
  End;

function IsWeekend (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) in [1, 7];
  End;

function IsWeekday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) in [2..6];
  End;

function FirstDayOfWeek(const D: TDateTime; bISO: Boolean): TDateTime;
var
  iDay: Word;
begin
  if bISO then
    iDay := DayOfTheWeek(D)
  else
    iDay := DayOfWeek(D);
  result := D - iDay + 1;
end;

function LastDayOfWeek(const D: TDateTime; bISO: Boolean): TDateTime;
var
  iDay: Word;
begin
  if bISO then
    iDay := DayOfTheWeek(D)
  else
    iDay := DayOfWeek(D);
  result := D + (7 - iDay);
end;

function LastDayOfMonth (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, Mo, DaysInMonth (Ye, Mo));
  End;

function FirstDayOfMonth (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, Mo, 1);
  End;

function FirstDayOfSeason(const D: TDateTime): TDateTime;
var
  iYear, iMonth, iDay : Word;
begin
  DecodeDate (D, iYear, iMonth, iDay);
  iDay := 1;
  case iMonth of
    1, 2, 3:
        iMonth := 1;
    4, 5, 6:
        iMonth := 4;
    7, 8, 9:
        iMonth := 7;
    10, 11, 12:
        iMonth := 10;
  end;
  result := EncodeDate(iYear, iMonth, iDay);
end;

function LastDayOfSeason(const D: TDateTime): TDateTime;
var
  iYear, iMonth, iDay : Word;
begin
  DecodeDate (D, iYear, iMonth, iDay);
  iDay := 1;
  case iMonth of
    1, 2, 3:
        iMonth := 1;
    4, 5, 6:
        iMonth := 4;
    7, 8, 9:
        iMonth := 7;
    10, 11, 12:
        iMonth := 10;
  end;
  result := EncodeDate(iYear, iMonth, DaysInMonth(iYear, iMonth));
end;

function LastDayOfYear (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, 12, 31);
  End;

function FirstDayOfYear (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, 1, 1);
  End;

function  FirstTimeOfDay(D: TDateTime): TDateTime;
var Ye, Mo, Da : Word;
begin
  DecodeDate (D, Ye, Mo, Da);
  result := EncodeDateTime(Ye, Mo, Da, 0, 0, 0 ,0);
end;

function  LastTimeOfDay(D: TDateTime): TDateTime;
var Ye, Mo, Da : Word;
begin
  DecodeDate (D, Ye, Mo, Da);
  result := EncodeDateTime(Ye, Mo, Da, 23, 59, 59 ,999);
end;

const
  DaysInNonLeapMonth : Array [1..12] of Integer = (
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  CumDaysInNonLeapMonth : Array [1..12] of Integer = (
    0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);

function DayOfYear (const Ye, Mo, Da : Word) : Integer; overload;
  Begin
    Result := CumDaysInNonLeapMonth [Mo] + Da;
    if (Mo > 2) and IsLeapYear (Ye) then
      Inc (Result);
  End;

function DayOfYear (const D : TDateTime) : Integer; overload;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := DayOfYear (Ye, Mo, Da);
  End;

function DaysInMonth (const Ye, Mo : Word) : Integer;
  Begin
    Result := DaysInNonLeapMonth [Mo];
    if (Mo = 2) and IsLeapYear (Ye) then
      Inc (Result);
  End;

function DaysInMonth (const D : TDateTime) : Integer;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := DaysInMonth (Ye, Mo);
  End;

function DaysInYear (const Ye : Word) : Integer;
  Begin
    if IsLeapYear (Ye) then
      Result := 366 else
      Result := 365;
  End;

function DaysInYear (const D : TDateTime) : Integer;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := DaysInYear (Ye);
  End;

function DiffMilliseconds (const D1, D2 : TDateTime) : Int64;
  Begin
    Result := Trunc ((D2 - D1) / OneMillisecond);
  End;

function DiffSeconds (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc ((D2 - D1) / OneSecond);
  End;

function DiffMinutes (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc ((D2 - D1) / OneMinute);
  End;

function DiffHours (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc ((D2 - D1) / OneHour);
  End;

function DiffDays (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc (D2 - D1);
  End;

function DiffWeeks (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc (D2 - D1) div 7;
  End;

function DiffMonths (const D1, D2 : TDateTime) : Integer;
var Ye1, Mo1, Da1 : Word;
    Ye2, Mo2, Da2 : Word;
    ModMonth1,
    ModMonth2     : TDateTime;
  Begin
    DecodeDate (D1, Ye1, Mo1, Da1);
    DecodeDate (D2, Ye2, Mo2, Da2);
    Result := (Ye2 - Ye1) * 12 + (Mo2 - Mo1);
    ModMonth1 := Da1 + Frac (D1);
    ModMonth2 := Da2 + Frac (D2);
    if (D2 > D1) and (ModMonth2 < ModMonth1) then
      Dec (Result);
    if (D2 < D1) and (ModMonth2 > ModMonth1) then
      Inc (Result);
  End;

function DiffYears (const D1, D2 : TDateTime) : Integer;
var Ye1, Mo1, Da1 : Word;
    Ye2, Mo2, Da2 : Word;
    ModYear1,
    ModYear2      : TDateTime;
  Begin
    DecodeDate (D1, Ye1, Mo1, Da1);
    DecodeDate (D2, Ye2, Mo2, Da2);
    Result := Ye2 - Ye1;
    ModYear1 := Mo1 * 31 + Da1 + Frac (Da1);
    ModYear2 := Mo2 * 31 + Da2 + Frac (Da2);
    if (D2 > D1) and (ModYear2 < ModYear1) then
      Dec (Result);
    if (D2 < D1) and (ModYear2 > ModYear1) then
      Inc (Result);
  End;

function  ZeroMissSeconds(const d1: TDateTime): TDateTime;
var
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: word;
begin
  DecodeDateTime(d1, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
  result := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, 0);
end;

function  WeekNumber (const D : TDateTime) : Integer;
  Begin
    Result := (DiffDays (FirstDayOfYear (D), D) div 7) + 1;
  End;

function  GetFirstDayByWeekDay(D: TDateTime; WeekDay: integer): TDateTime;
begin
  result := D - DayOfWeek (D) + WeekDay;
  result := trunc(result);
end;

function  GetFirstDayByMonthDay(D: TDateTime; Day: integer): TDateTime;
var
  Ye, Mo, Da : Word;
begin
  DecodeDate (D, Ye, Mo, Da);
  if Da < Day then Dec(Mo);
  Da := Day;
  result := EncodeDate(Ye, Mo, Da);
end;

function  GetFirstDayBySeasonDay(D: TDateTime): TDateTime;
var
  Ye, Mo, Da : Word;
begin
  DecodeDate (D, Ye, Mo, Da);
  Da := 1;
  case Mo of
    1, 2, 3:
        Mo := 1;
    4, 5, 6:
        Mo := 4;
    7, 8, 9:
        Mo := 7;
    10, 11, 12:
        Mo := 10;
  end;
  result := EncodeDate(Ye, Mo, Da);
end;

function Padr(OrigStr: string; ResuLen: integer; InstChar: string): string;
var
  OrigLen, InstLoop: integer;
begin
  OrigStr := trim(OrigStr);
  OrigLen := length(OrigStr);
  InstLoop := ResuLen - OrigLen;
  while InstLoop > 0 do
  begin
    OrigStr := OrigStr + InstChar;
    dec(InstLoop);
  end;
  result := OrigStr;
end;

function Padl(OrigStr: string; ResuLen: integer; InstChar: string): string;
var
  OrigLen, InstLoop: integer;
begin
  OrigStr := trim(OrigStr);
  OrigLen := length(OrigStr);
  InstLoop := ResuLen - OrigLen;
  while InstLoop > 0 do
  begin
    OrigStr := InstChar + OrigStr;
    dec(InstLoop);
  end;
  result := OrigStr;
end;

function GetGUID: string;
var
  id: tguid;
begin
  if CoCreateGuid(id) = s_ok then
    result := GuidToString(id);
end;

function NewGUID: TGUID; {Get the GUID}
var
  ID: TGUID;
begin
  if CoCreateGuid(id) = s_ok then
    result := ID;
end;

function BinSearch(IntArray: array of integer; low, High: integer; key:
  integer): integer;
var
  mid: integer;
  MidValue: integer;
begin
  result := -1;
  while (Low <= High) do
  begin
    Mid := Trunc((High + Low) / 2);
    MIdvalue := IntArray[Mid];
    if key = Midvalue then
    begin
      result := Mid;
      Break;
    end
    else
      if Key < Midvalue then
        High := Mid - 1
      else
        Low := Mid + 1;
  end;
end;

procedure BinSort(var Ls: TStringList);
var
  value, Ori: integer;
  Temp: TStringList;
  i, k: integer;
  bFound: boolean;
begin
  if Ls = nil then exit;
  if Ls.Count <= 1 then exit;
  Temp := TStringList.Create;
  Temp.Add(Ls.strings[0]);
  for i := 1 to Ls.Count - 1 do
  begin
    value := StrToInt(Ls.strings[i]);
    bFound := false;
    for k := 0 to temp.Count - 1 do
    begin
      Ori := StrToInt(Temp.strings[k]);
      if Ori > Value then
      begin
        bFound := true;
        Temp.Insert(k, Ls.strings[i]);
        break;
      end;
    end;
    if not bFound then
      Temp.Add(Ls.strings[i]);
  end;
  Ls.Clear;
  for i := 0 to Temp.Count - 1 do
    Ls.Add(temp.strings[i]);
  if assigned(temp) then
    FreeAndNil(Temp);
end;

function Open_Service(ServiceName: string; var hSC, hSRV: Longint): boolean;
var
  ComputerName: array[0..255] of char;
  Len: DWord;
  s: string;
begin
  Fillchar(ComputerName, sizeof(ComputerName), 0);
  GetComputerName(ComputerName, Len);
  s := ComputerName;
  result := false;
  if ComputerName = '' then exit;
  if ServiceName = '' then exit;
  try
    hSC := OpenSCManager(Pchar(s), SERVICES_ACTIVE_DATABASE,
      SC_MANAGER_ALL_ACCESS);
    if hsc = 0 then exit;
    hSRV := OpenService(hSC, pchar(ServiceName), SERVICE_ALL_ACCESS);
    result := hSRV <> 0;
  except
    result := false;
  end;
end;

function Close_Service(var hSC: longint): boolean;
begin
  result := false;
  if hSC <> 0 then
    result := CloseServiceHandle(hSC);
end;

function Start_Service(var hSRV: longint): boolean;
var
  p: pchar;
begin
  result := StartService(hSRV, 0, p);
end;

function Stop_Service(var hSRV: longInt): boolean;
var
  p: SERVICE_STATUS;
begin
  result := ControlService(hSRV, SERVICE_CONTROL_STOP, p);
end;

function GetStatus_Service(var hSRV: longInt): SERVICE_STATUS;
begin
  QueryServiceStatus(hSRV, result);
end;

function GetGSMTime(const Sec: integer; const uSec: integer): TDateTime;
var
  D, T: TDateTime;
  Year, Month, Day: word;
  Hour, Min, Second: word;
begin
  Year := 1970;
  Month := 1;
  Day := 1;
  Hour := 0;
  Min := 0;
  Second := 0;
  D := EncodeDate(Year, Month, Day);
  T := EncodeTime(Hour, Min, Second, 0);
  result := D + T + Sec * OneSecond + uSec * OneMillisecond;
end;

function  GetSystemTempFile: string;
var
  buf: array[0..MAX_PATH] of char;
  bufPath: array[0..MAX_PATH] of char;
  path: string;
begin
  try
    FillChar(buf,sizeof(buf),0);
    GetTempPath(Sizeof(bufPath) ,bufPath);
    GetTempFileName(BufPath, 'VTM', 0, buf);
    path := strPas(buf);
    result := path;
  except
    result := '';
  end;
end;

function GetNumberOfProceessor: integer;
var
  SysInfo: TSystemInfo;
begin
  FillChar(SysInfo, Sizeof(TSystemInfo), 0);
  GetSystemInfo(SysInfo);
  result := SysInfo.dwNumberOfProcessors;
  if result <= 0 then
    result := -1;
end;

function GetProcessID: Cardinal;
begin
  result := GetCurrentProcess();
end;

procedure GetProcessMask(ProcessID: Cardinal; var ProcessMask, SystemMask: Cardinal);
begin
  GetProcessAffinityMask(ProcessID, ProcessMask, SystemMask);
end;

function SetLocalSytemTime(NewTime: double): boolean;
var
  SysTime: TSystemTime;
begin
  try
    DateTimeToSystemTime(NewTime, SysTime);
    SetLocalTime(SysTime);
    result := true;
  except
    result := false;
  end;
end;

function TruncMscSecond(const D: TDateTime): TDateTime;
var
  H, M, S, N: word;
begin
  DecodeTime(D, h, M, S, N);
  if N <= 500 then
    result := D - OneMillisecond * N
  else
    result := D + OneMillisecond * (1000 - N);
end;

function GetSecond(const D: TDateTime): integer;
var
  H, M, S, N: word;
begin
  DecodeTime(D, h, M, S, N);
  result := S;
end;

function GetMSecond(const D: TDateTime): integer;
var
  H, M, S, N: word;
begin
  DecodeTime(D, h, M, S, N);
  result := N;
end;

procedure ComparePattern(St1, St2: string; var Check: Boolean);
var
  Hlp1, Hlp2: string;
  Pos1: Integer;
begin
  Check:=True;
  while Length(St1)>0 do
  begin
    Pos1:=Pos('?', St1);

    if (Pos1=0) then
    begin
      if CompareStr(St1, St2)<>0 then Check:=False;
      Delete(St1, 1, Length(St1));
      Delete(St2, 1, Length(St2));
    end;

    if (Pos1>0) then
    begin
      Hlp1:=Copy(St1,1,Pos1-1);
      Hlp2:=Copy(St2,1,Pos1-1);
      if CompareStr(Hlp1, Hlp2)<>0 then Check:=False;
      Delete(St1,1,Pos1);
      if Pos1>Length(St2) then Check:=False;
      Delete(St2,1,Pos1);
    end;

    if Check=False then Break;

  end;
  if CompareStr(St1, St2)<>0 then Check:=False;
end;

procedure WriteToTempFile(FileName: string; Buf: string);
var
  F: TextFile;
begin
  try
  if not FileExists(FileName) then
  begin
    AssignFile(F, FileName);
    Rewrite(F);
  end
  else
  begin
    AssignFile(F, FileName);
    Reset(F);
    Append(F);
  end;
  WriteLn(F, Buf);
  finally
    CloseFile(F);
  end;
end;

procedure WriteToTempFile_Date(FileName: string; D: TDateTime);
begin
  WriteToTempFile(FileName, FormatDateTime('YYYY-MM-DD HH:NN:SS:ZZZ', D));
end;

procedure WriteToTempFile_Date(FileName: string; Buf: string; D: TDateTime);
begin
  WriteToTempFile(FileName, Format('%s: %s', [Buf,FormatDateTime('YYYY-MM-DD HH:NN:SS:ZZZ', D)]));
end;

procedure WriteToTempFile_Date(FileName: string; Buf: string; i: integer; D: TDateTime);
begin
  WriteToTempFile_Date(FileName, Format('%s, %d', [Buf, i]), d);
end;

procedure WriteToTempFile(FileName: string; Int: Integer);
begin
  WriteToTempFile(FileName, Format('%d', [int]));
end;

procedure WriteToTempFile(FileName: string; Buf: string; Int: Integer);
begin
  WriteToTempFile(FileName, Format('%s, %d', [Buf, int]));
end;

procedure WriteToTempFile(FileName: string; f: Double);
begin
  WriteToTempFile(FileName, Format('%.3f', [f]));
end;

procedure WriteToTempFile(FileName: string; Buf: string; f: Double);
begin
  WriteToTempFile(FileName, Format('%s, %.3f', [Buf, f]));
end;

procedure WriteToTempFile(FileName: string; b: boolean); overload;
begin
  WriteToTempFile(FileName, BoolToStr(b, true));
end;

procedure WriteToTempFile(FileName: string; Buf: string; b: boolean); overload;
begin
  WriteToTempFile(FileName, Format('%s, %s', [Buf, BoolToStr(b, true)]));
end;

function StrLenPas(tStr:PChar):integer;
var
  p:^cardinal;
  q:pchar;
  bytes,r1,r2:cardinal;
begin
  p:=pointer(tStr);
  repeat
    q:=pchar(p^);
    r2:=cardinal(@q[-$01010101]);
    r1:=cardinal(q) xor $FFFFFFFF;
    bytes:=r1 and r2;
    inc(p);
  until (bytes and $80808080)<>0;
  result:=integer(p)-integer(tStr)-4;
  if (bytes and $00008080)=0 then
  begin
    bytes:=bytes shr 16;
    inc(result,2);
  end;
  if (bytes and $80)=0 then
    inc(result);
end;

function GetSubList(aLine: string; aSub: string; ls: TStringList;
 uppercased: boolean): boolean;
var
  iPos: integer;
  s: string;
begin
  result := false;
  if aLine = '' then exit;
  if aSub = '' then exit;
  if Ls = nil then exit;
  iPos := Pos(aSub, aLine);
  if iPos = 0 then exit;

  try
    while iPos > 0 do
    begin
      s := Copy(aLine, 1, iPos - Length(aSub));
      if uppercased then s := uppercase(s);
      Ls.Add(s);
      System.Delete(aLine, 1, iPos);
      iPos := Pos(aSub, aLine);
    end;
    if aLine <> '' then
    begin
      if uppercased then s := uppercase(aline);
      ls.Add(s);
    end;
    result := true;
  except
    result := false;
  end;
end;

procedure SetListViewAllCheck(Lvw: TListView; CheckedAll: boolean);
var
  i: integer;
begin
  if Lvw = nil then exit;
  Lvw.Items.BeginUpdate;
  try
    for i:= 0 to Lvw.Items.Count - 1 do
      Lvw.Items.Item[i].Checked := CheckedAll;
  finally
    Lvw.Items.EndUpdate;
  end;
end;

procedure SetListViewBackCheck(Lvw: TListView);
var
  i: integer;
begin
  if Lvw = nil then exit;
  Lvw.Items.BeginUpdate;
  try
    for i:= 0 to Lvw.Items.Count - 1 do
     Lvw.Items.Item[i].Checked := not Lvw.Items.Item[i].Checked;
  finally
    Lvw.Items.EndUpdate;
  end;
end;

procedure SetCheckListBoxAllCheck( Clb: TCheckListBox; CheckedAll: boolean);
var
  i: integer;
begin
  if Clb = nil then exit;
  Clb.Items.BeginUpdate;
  try
    for i:= 0 to Clb.Items.Count - 1 do
      Clb.Checked[i] := CheckedAll;
  finally
    Clb.Items.EndUpdate;
  end;
end;

procedure SetCheckListBoxBackCheck(Clb: TCheckListBox);
var
  i: integer;
begin
  if Clb = nil then exit;
  Clb.Items.BeginUpdate;
  try
    for i:= 0 to Clb.Items.Count - 1 do
     Clb.Checked[i] := not Clb.Checked[i];
  finally
    Clb.Items.EndUpdate;
  end;
end;

procedure LVCheckOnlySingle(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  HitTests: THitTests;
  i: integer;
  ListItem: TListItem;
  Lv: TListView;
begin
  if not (Sender is TListView) then exit;
  Lv := Sender as TListView;
  ListItem := Lv.GetItemAt(X, y);
  if ListItem = nil then exit;
  HitTests := LV.GetHitTestInfoAt(X, y);
  if  (htOnStateIcon in HitTests) then
  begin

    //
    Lv.Items.BeginUpdate;
    try
      for i:= 0 to Lv.Items.Count - 1 do
        if Lv.Items.Item[i] <> ListItem then
          if Lv.Items.Item[i].Checked then
          begin
            Lv.Items.Item[i].Checked := false;
            Lv.Items.Item[i].Selected := false;
          end;
    finally
      Lv.Items.EndUpdate;
    end;
  end;
end;


function GetCheckItems(Lvw: TListView;
  var LiArr: array of TListItem): integer;
var
  i: integer;
begin
  result := 0;
  if Lvw = nil then exit;
  for i := 0 to Lvw.Items.Count - 1 do
    if Lvw.Items.Item[i].Checked then
    begin
      LiArr[i] := Lvw.Items[i];
      inc(result);
    end;
end;

function GetAllItems(lvw: TListView;
  var LiArr: array of TListItem): integer;
var
  i: integer;
begin
  result := 0;
  if Lvw = nil then exit;
  result := lvw.Items.Count;
  for i := 0 to Lvw.Items.Count - 1 do
      LiArr[i] := Lvw.Items[i];
end;

procedure GetSelectedItems(lvw: TListView;
  var LiArr: array of TListItem);
var
  i: integer;
begin
  if Lvw = nil then exit;
  for i := 0 to Lvw.Items.Count - 1 do
    if Lvw.Items.Item[i].Selected then
      LiArr[i] := Lvw.Items[i];
end;

procedure ClearListView(lvw: TListView);
begin
  if lvw = nil then exit;
  lvw.Items.BeginUpdate;
  try
    lvw.Items.Clear;
  finally
    lvw.Items.EndUpdate;
  end;
end;

procedure ClearListBox(lb: TListBox);
begin
  if lb = nil then exit;
  lb.Items.BeginUpdate;
  try
    lb.Items.Clear;
  finally
    lb.Items.EndUpdate;
  end;
end;

function GetCheckItem(Lvw: TListView): TListItem;
var
  i: integer;
begin
  result := nil;
  if Lvw = nil then exit;
  for i:= 0 to  Lvw.Items.Count - 1 do
   if Lvw.Items[i].Checked then
   begin
     result := Lvw.Items[i];
     break;
   end;
end;

function  ControlAtPosEx(Father:TControl; const Pos: TPoint): TControl;
var
  I: Integer;
  P: TPoint;
  OldResult : tControl;
begin
  With (Father as tWinControl) Do
  Begin
   for I := ControlCount - 1 downto 0 do
   begin
     Result := Controls[I];
     with Result do
     begin
       P := Point(Pos.X - Left, Pos.Y - Top);
       if PtInRect(ClientRect, P) then
       Begin
         IF (Result is TWinControl) Then
         Begin
           OldResult := Result;
           Result := ControlAtPosEx(Result,p);
           IF Result = NIL
             then result := oldResult;
         End;
         exit;
       End;
     end;
   end;
  Result := nil;
  End;
end;
{
//use example
 //TvMouseDown
var
  Node: TTreeNode;
  ht: THitTests;
begin
  if Button = mbLeft then
  begin
    ht := Tv.GetHitTestInfoAt(x, y);
    if not (htOnStateIcon in ht) then exit;
    Node := Tv.GetNodeAt(x, y);
    SetTreeNodeChildStatesImage(Node);
  end;
end;

}

procedure SetTreeNodeChildStatesImage(Node: TTreeNode);
var
  Level, StateIndex: integer;
  ParentNode: TTreeNode;
  TV: TTreeView;
begin
  if Node = nil then exit;
  TV := TTreeView(Node.TreeView);
  if TV = nil then exit;
  TV.Items.BeginUpdate;
  try
    Level := Node.Level;
    ParentNode := Node.Parent;
    StateIndex := Node.StateIndex;
    case StateIndex of
      1:  StateIndex := 2;
      2:  StateIndex := 1;
      3:  StateIndex := 2;
     else
       exit;
    end;

    while Node <> nil do
    begin
      Node.StateIndex := StateIndex;
      Node := Node.GetNext;
      if Node = nil then break;
      if Node.Level <= Level then break;
    end;
    SetTreeNodeParentStatesImage(ParentNode, StateIndex);
  finally
    TV.Items.EndUpdate;
  end;
end;

procedure SetTreeNodeParentStatesImage(Node: TTreeNode; StateIndex: integer);
var
  i, OldStateIndex: integer;
  HaveDiff: boolean;
begin
  if Node = nil then exit;
  if (Node.StateIndex = -1) or (Node.StateIndex = 0) then exit;
  OldStateIndex:= Node.StateIndex;
  if OldStateIndex = StateIndex then exit;
  HaveDiff := false;
  for i:= 0 to Node.Count - 1 do
  begin
    if Node.Item[i].StateIndex <> StateIndex then
    begin
      HaveDiff := true;
      break;
    end;
  end;
  if HaveDiff then Node.StateIndex := 3
  else  Node.StateIndex := StateIndex;
  SetTreeNodeParentStatesImage(Node.Parent, Node.StateIndex);
end;

type
  TWinControlAccess = class(TWinControl);

procedure MyControlEnableState(Control: TWinControl; Value: boolean; Colored: boolean = true);
const
  ccEnabled = clWindow;
  ccDisabled = clBtnFace;
begin
  if Control = nil then exit;
  if Control.Enabled = Value then exit;
  Control.Enabled := Value;
  if not Colored then exit;
  if Control is TCustomCheckBox then Value := false;
  if Control is TRadioButton then Value := false;
  
  if GetPropInfo(Control, 'Color') <> nil then
  case Value of
   true:
       TWinControlAccess(Control).Color := ccEnabled;
   false:
       TWinControlAccess(Control).Color := ccDisabled;
  end;
end;

procedure MyControlEnableState(Control: array of TWinControl; Value: boolean; Colored: boolean = true); overload;
var
  i: integer;
begin
  for i:= Low(Control) to High(Control) do
    MyControlEnableState(Control[i], Value, Colored);
end;

procedure MyContorlSetFocus(Control: TWinControl);
begin
  if Control = nil then exit;
  if not Control.Enabled then exit;
  if not Control.Visible then exit;
  Control.SetFocus;
end;

procedure MyEditNAState(ed: TEdit);
begin
  if ed = nil then exit;
  ed.Text := 'N/A';
  MyControlEnableState(ed, false);
end;

function  GetDynamicColor(index: integer): TColor;
begin
  result := clred;
  if index < DefaultColorCount then
    result := DefaultColors[Index].Color;
end;

function GMTBias : Integer;
var TZI : TTimeZoneInformation;
begin
  if GetTimeZoneInformation (TZI) = TIME_ZONE_ID_DAYLIGHT then
    Result := TZI.DaylightBias else
    Result := 0;
  Result := Result + TZI.Bias;
end;

{ Converts GMT Time to Local Time                                              }
function GMTTimeToLocalTime (const D : TDateTime) : TDateTime;
begin
    Result := D - GMTBias / (24 * 60);
end;

function GMTTimeToLocalTime(Const D: TDateTime; TimeZoneOffset: Integer): TDateTime;
begin
  //LocalTime = GMTTime + TimeZoneOffset;
  //TimeZoneOffsetµ¥Î»Îª·ÖÖÓ£»
  Result := D + TimeZoneOffset * OneMinute;
end;

{ Converts Local Time to GMT Time                                              }
function LocalTimeToGMTTime (const D : TDateTime) : TDateTime;
begin
    Result := D + GMTBias / (24 * 60);
end;

function LocalTimeToGMTTime(const D: TDateTime; TimeZoneOffset: Integer): TDateTime; 
begin
  //GMTTime = LocalTime - TimeZoneOffset;
  //TimeZoneOffsetµ¥Î»Îª·ÖÖÓ£»
  Result := D - TimeZoneOffset * OneMinute;
end;

function GMTNow: TDateTime;
begin
  result := LocalTimeToGMTTime(now);
end;

function GetOnlyDate(dt: TDateTime): TDateTime;
var
  y, m, d: word;
begin
  DecodeDate(dt, y, m, d);
  result := EncodeDate(y, m, d);
end;

function GetOnlyTime(dt: TDateTime): TDateTime;
var
  hh,  mm, ss, msec: word;
begin
  DecodeTime(dt, hh, mm, ss, msec);
  result := EncodeTime(hh,  mm, ss, msec);
end;


function  CompareTime(t1, t2: double): boolean;
begin
  result := abs(t1 - t2) < 10E-6;
end;

procedure ClearMenu(Menu: TMainMenu);
var
  i: integer;
  Item : TMenuItem;
begin
  if Menu = nil then exit;
  try
    for i:= Menu.Items.Count - 1 downto 0 do
    begin
       Item := Menu.Items.Items[i];
       Menu.Items.Delete(i);
       ClearMenu(Item);
       Item.Free;
    end;
  except
  end;
end;

procedure ClearMenu(Menu: TPopupMenu);
var
  i: integer;
  Item : TMenuItem;
begin
  if Menu = nil then exit;
  try
    for i:= Menu.Items.Count - 1 downto 0 do
    begin
       Item := Menu.Items.Items[i];
       Menu.Items.Delete(i);
       ClearMenu(Item);
       Item.Free;
    end;
  except
  end;
end;

procedure ClearMenu(Menu: TMenuItem);
var
  i: integer;
  Item: TMenuItem;
begin
  if Menu = nil then exit;
  for i:= Menu.Count - 1 downto 0 do
  begin
    Item := Menu.Items[i];
    Menu.Delete(i);;
    ClearMenu(Item);
    Item.Free;
  end;
end;

function  CheckFloat(s: string): boolean;
begin
  try
    strToFloat(s);
    result := true;
  except
    result := false;
    raise Exception.Create(Format(CsErrorDouble, [s]));
  end;
end;

function  CheckInt(s: string): boolean;
begin
  try
    strToInt(s);
    result := true;
  except
    result := false;
    raise Exception.Create(Format(CsErrorInterger, [s]));
  end;
end;

procedure FreeDynPageControl(pgc: TPageControl);
begin
  if pgc = nil then exit;
  with pgc do
    while PageCount > 0 do
    begin
       RemoveControl(Pages[0]);
       Pages[0].Free;
    end;
end;

function CreateDynPageControl(pgc: TPageControl; Caption: string; Tag: integer): TTabSheet;
begin
  result := nil;
  if pgc = nil then exit;
  result := TTabSheet.Create(pgc);
  result.Caption := Caption;
  result.Tag := Tag;
  result.PageControl := pgc;
end;


function CheckDir(s: string): boolean;
begin
  result := true;
  try
    s := ExtractFilePath(s);
    if not DirectoryExists(s) then
      if not ForceDirectories(s) then
        result := false;
  except
    result := false;
  end;
end;

function IsValidFileName(FileName:string):Boolean;
var
  i: integer;
begin
  Result:= True;
  for i:=1 to Length(FileName) do
  begin
    case FileName[i] of
      '<','>','?','[',']',':','*','|':Result:=False;
    else
      Result:=True;
    end;
    if not result then break;
  end;
end;

function  ReplaceFileName(FileName: string): string;
const
  pl = '';
  ReplaceFlags: TReplaceFlags = [rfReplaceAll, rfIgnoreCase];
begin
  result := FileName;
  result := StringReplace(result, '<', pl, ReplaceFlags);
  result := StringReplace(result, '>', pl, ReplaceFlags);
  result := StringReplace(result, '?', pl, ReplaceFlags);
  result := StringReplace(result, '[', pl, ReplaceFlags);
  result := StringReplace(result, ']', pl, ReplaceFlags);
  result := StringReplace(result, ':', pl, ReplaceFlags);
  result := StringReplace(result, '*', pl, ReplaceFlags);
  result := StringReplace(result, '|', pl, ReplaceFlags);
end;

function UniqueFilename(path:string):string;
var
  c:char;
begin
 repeat
   result:='';
   randomize;
     repeat
     c:=chr(random(43)+47);
     if (length(result)=8) then result:=result+'.' else
       if (c in ['0'..'9','A'..'Z']) then result:=result+c;
     until length(result)=12;
     result:=WithBackSlash(path)+result;
 until not (fileexists(result));
end;

function GetTempFile(const prefix: string): string;
var
  path,pref3: string;
  ppref: PChar;
const sDefPrefix='dfs';
begin
  SetLength(path,255);
  SetLength(path,GetTempPath(255,@path[1]));
  SetLength(Result,255);
  Result[1]:=#0;
  case length(prefix) of
    0: ppref:=PChar(sDefPrefix);
    1,2: begin
      pref3:=prefix;
      while length(pref3)<3 do pref3:=pref3+'_';
      ppref:=PChar(pref3);
    end;
    3: ppref:=PChar(prefix);
    else begin
      pref3:=Copy(prefix,1,3);
      ppref:=PChar(pref3);
    end;
  end;
  GetTempFileName(PChar(path),ppref,0,PChar(Result));
  SetLength(Result,StrLen(PChar(Result)));
end;


procedure Delay(iTime: cardinal);
var
  iStart: cardinal;
begin
  iStart := GetTickCount;
  while GetTickCount < iStart + itime do
  begin
    Sleep(10);
    Application.ProcessMessages;
  end;
end;

function  ReadStringFromStream(Stream: TStream): string;
var
  temp: string;
  i: integer;
begin
  result := '';
  if Stream = nil then exit;
  Stream.Read(i, sizeof(i));
  if i <= 0 then exit;
  SetLength(temp, i);
  try

    Stream.read(temp[1], i);
    result := temp;
  finally
    SetLength(temp, 0);
  end;
end;

procedure WriteStringToStream(s: string; Stream: TStream);
var
  i: integer;
begin
  if stream = nil then exit;
  i := Length(s);
  Stream.Write(i, sizeof(i));
  if i = 0 then exit;
  Stream.Write(s[1], i);
end;

procedure SetImageIndex(Node: TTreeNode; Index: integer);
begin
  if Node = nil then exit;
  Node.ImageIndex := Index;
  Node.SelectedIndex := Index;
end;

function CorrectRound(x: Extended): LongInt;
begin
  Result := Trunc(x);
  if (Frac(x) >= 0.5) then
    Result := Result + 1;
end;

function  GetLineIndexValue(s, Sub: string; Index: integer): string;
var
  iPos, i : integer;
begin
  iPos := Pos(Sub, s);
  i := 0;
  result := '';
  while (iPos > 0) do
  begin
    if i = index then
    begin
      result := System.Copy(s, 1, iPos - Length(Sub));
      inc(i);
      break;
    end;
    inc(i);
    System.Delete(s, 1, iPos);
    iPos := Pos(Sub, s);
  end;
  if (i = index) and (s <> '') and (result = '') then result := s;
end;

procedure QuickSort1(const List: TList; const Compare: TListSortCompare;
const L: Integer; const R: Integer);
var
  I: Integer;
  J: Integer;
  Temp: Pointer;
begin
  I := L - 1;
  J := R;
  repeat
    Inc(I);
    while (Compare(List[I], List[R]) < 0) do
      Inc(I);
    Dec(J);
    while (J > 0) do
    begin
      Dec(J);
      if (Compare(List[J], List[R]) <= 0) then
        Break;
    end;
    if (I >= J) then
      Break;
    Temp := List[I];
    List[I] := List[J];
    List[J] := Temp;
  until (False);
  
  Temp := List[I];
  List[I] := List[R];
  List[R] := Temp;
end;


procedure MyQuickSort(const List: TList; const Compare: TListSortCompare);
begin
  QuickSort1(List, Compare, 0, List.Count - 1);
end;

function Is_Object(Obj: TObject): Boolean;
type PClass=^TClass;
begin
  Result:=(Obj<>nil) and IsClass(PClass(Obj)^);
end;

function IsClass(Cls: TClass): LongBool;
type PPChar=^PChar;
var pname: PChar;
    par: TClass;
const clsMax=40; // maximální délka názvu tøídy:
begin
  Result:=False;
  try
    // Ovìøíme, že vùbec lze èíst VMT:
    if IsBadReadPtr(PChar(Cls)+vmtIntfTable,-vmtIntfTable) then exit;
    if IsBadCodePtr(PChar(Cls)+vmtDestroy) then exit;
    // Název tøídy objektu:
    pname:=PPChar(PChar(Cls)+vmtClassName)^;
    //!SpeedUp! if IsBadReadPtr(pname,4) then exit;
    if (not ((pname+1)^ in ['T','t'])) or  // Object class-name doesn't start with "T" !
       (ord(pname^)>clsMax)                // Class-name too long !
    then exit;
    par:=Cls.ClassParent;
    // Parent class:
    if par=nil then begin
      // Class has no parent... Only TObject should have no parent!
      Result:=(StrIComp(pname+1,'TObject')=0);
      exit;
    end;
    //!SpeedUp! if IsBadReadPtr(PChar(par)+vmtIntfTable,-vmtIntfTable) then exit;
    // Parent class-name:
    pname:=PPChar(PChar(par)+vmtClassName)^;
    //!SpeedUp! if IsBadReadPtr(pname,4) then exit;
    if (not ((pname+1)^ in ['T','t'])) or  // Object class-name doesn't start with "T" !
       (ord(pname^)>clsMax)                // Class-name too long !
    then exit;
  except Result:=False; exit; end;
  // OK:
  Result:=True;
end;

{$ifdef TOHLE_TO_ASI_TAK_DELA:}
procedure SaveFree(pobj: pointer);
type PObject=^TObject;
var obj: TObject;
begin
  if pobj=nil then exit;
  obj:=PObject(pobj)^;
  PObject(pobj)^:=nil;
  if (obj<>nil) and (IsClass(obj.ClassType)) then obj.Free;
end;
{$else -> CHYTREJSI_ZPUSOB}

procedure SaveFree(pobj: pointer); assembler;
asm
  or eax,eax ; jz @done // if pobj=nil then exit;
  mov ecx,[eax]         // obj:=PObject(pobj)^;
  xor edx,edx
  mov [eax],edx         // PObject(pobj)^:=nil;
  mov eax,ecx           // if obj=nil then exit;
  test eax,eax
  je @done
  mov ecx,[eax]  // ECX = VMT
  cmp ecx,3 ; je @Error // zmena proti TObject.Free: Prevent message:   Access violation.... read of address FFFFFFFF
  push ebx
  push ecx
  mov  ebx,eax   // EBX = object
  mov  eax,ecx   // EAX = VMT
  call IsClass
  test eax,eax   // tested later:
  mov  eax,ebx   // EAX = object
  pop  ecx       // ECX = VMT
  pop  ebx
  jz   @Error    // flag from   test eax,eax   before
@free:
  MOV     DL,1
  CALL    dword ptr [ECX].vmtDestroy
  jmp     @done
@Error:
  //call bad-handler:
  mov     edx,[esp]-4
  //mov     &ExceptAddr,edx
  mov     ecx,BadUnalloc
  test    ecx,ecx
  jz      @done
  call    ecx
@done:
end;
{$endif}

procedure SaveFreeMem(pptr: pointer);
type
  PPointer=^Pointer;
var ptr: Pointer;
begin
  if pptr=nil then exit;
  ptr:=PPointer(pptr)^;
  PPointer(pptr)^:=nil;
  if ptr<>nil then FreeMem(ptr);
end;

function  GetRange(FromRange, ToRange: integer): double;
begin
  result := RandomRange(FromRange, ToRange);
  Randomize;
  result := result + Random;
end;

function  GetRange(FromRange, ToRange: double): double;
var
  f1, f2: double;
begin
  f1 := FromRange - trunc(FromRange);
  f2 := ToRange - trunc(ToRange);
  result := GetRange(trunc(FromRange), trunc(ToRange));
  Randomize;
  if result < FromRange then
    result := result + f1 + Random;
  if result >= ToRange then
    result := result - f2;
end;

function  RandomRangeValue(Values: array of Integer): integer;
var
  index: integer;
begin
  Randomize;
  Index := RandomRange(0, Length(Values) -1);
  result := Values[index];
end;

function  GetConditionCount(FromPercent, ToPercent: double;
   Total: integer): integer;
var
  iCount, kCount, i: integer;
begin
  result := 0;
  iCount := trunc(Total * FromPercent);
  kCount := Trunc(Total * ToPercent);
  for i:= iCount to kCount do
    if i / Total > FromPercent then
    begin
      result := i ;
      break;
    end;
end;

const
  ccparChar = ' ';
function  GetArrayFormatString_Caption(strs: array of string): string;
var
  i: integer;
begin
  result := '';
  MaxFillLen := 0;
  for i:= low(strs) to high(strs) do
    MaxFillLen := Max(MaxFillLen, Length(strs[i]));

  MaxFillLen := Max(MaxFillLen, Length('MM-DD HH:NN:SS'));

  for i:= Low(strs) to High(strs) do
     result := result + Padr(uppercase(strs[i]), MaxFillLen, ccparChar);
end;

function  GetArrayFormatString_Data(strs: array of string; FromIndex: integer): string;
var
  i: integer;
begin
  result := '';

  if FromIndex >= 1 then
    for i:= 1 to FromIndex do
      result := result + Padr('', MaxFillLen, ccparChar);

  for i:= Low(strs) to High(Strs) do
    result := result + Padr(uppercase(strs[i]), MaxFillLen, ccparChar);
end;

function  SmartFloatToStr(f: double): string;
var
  s: string;
  i, index: integer;
  bStart: boolean;
begin
  s := Format('%.3f', [f]);
  result := s ;
  index := Length(s);
  bStart := false;
  while true do
  begin
    if index = 0 then    //if at first char
    begin
      bStart := false;
      break;
    end;

    if s[index] = '.' then  //if at .
    begin
      i := index;
      break;
    end;

    if s[index] = '0' then
    begin
      bStart := true;
      i := Index;
    end
    else if bStart then
      break;

    dec(index);
  end;

  if not bStart then exit;
  System.Delete(s, i, Length(s));
  result := s;
end;


function  RemoveLastInvalidChar(s: string; ch: char): string;
begin
  if s = '' then exit;
  if s[Length(s)] = ch then
    setLength(s, Length(s) -1 );
  result := s;
end;


procedure MyDrawTab(pgc: TPageControl;Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  x,y : Integer;
  sr : string;
begin
  if Active then
  begin
    Control.Canvas.Brush.Color := clBtnShadow;
    Control.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    Control.Canvas.Brush.Color := clBtnFace;
    Control.Canvas.Font.Style := [fsUnderline];
  end;

  sr := Copy(pgc.Pages[TabIndex].Caption,2,MaxInt);
  x := (((Rect.Right-Rect.Left)-Control.Canvas.TextWidth(sr))div 2)+Rect.Left;
  y := (((Rect.Bottom-Rect.Top)-Control.Canvas.TextHeight(sr))div 2)+Rect.Top;

  Control.Canvas.TextRect(Rect,x,y,sr);

  if Active then
  begin
    Control.Canvas.Font.Style := [fsUnderline,fsBold];
    sr := Copy(pgc.Pages[TabIndex].Caption,2,1);
    Control.Canvas.TextOut(x,y,sr);
  end;
end;

function CheckEditInt(ctr: TCustomEdit; Mess: string = '';
  Focus: boolean = true): boolean;
var
  i: integer;
begin
  result := false;
  if ctr = nil then exit;
  try
    i := StrToInt(ctr.Text);
    result := true;
  except
    result := false;
    if Focus then
    begin
      ctr.SelectAll;
      ctr.SetFocus;
    end;

    if Mess <> '' then
      ErrorDlg(Mess)
    else
      ErrorDlg('%s is not valid number', [ctr.text]);
  end;
end;

function CheckEditInt(pgc: TPageControl; Index:integer; ctr: TCustomEdit;
  Mess: string = ''; Focus: boolean = true): boolean;
var
  i: integer;
begin
  result := false;
  if ctr = nil then exit;
  try
    i := StrToInt(ctr.Text);
    result := true;
  except
    result := false;
    if Focus then
    begin
      pgc.ActivePageIndex := Index;
      ctr.SelectAll;
      ctr.SetFocus;
    end;

    if Mess <> '' then
      ErrorDlg(Mess)
    else
      ErrorDlg('%s is not valid number', [ctr.text]);

  end;
end;

function CheckEditHEX(pgc: TPageControl; Index:integer; ctr: TCustomEdit;
  Mess: string = ''; Focus: boolean = true): boolean;
var
  i: integer;
  s: string;
begin
  result := false;
  if ctr = nil then exit;
  try
    s := '$' + ctr.Text;
    i := StrToInt(s);
    result := true;
  except
    if Focus then
    begin
      pgc.ActivePageIndex := Index;
      ctr.SelectAll;
      ctr.SetFocus;
    end;

    if Mess <> '' then
      raise Exception.Create(Mess)
    else
      raise Exception.CreateFmt('%s is not valid number', [ctr.text]);

  end;
end;

function GetFileSize(const Filename: String): Integer;
var
  SR: TSearchRec;
begin
  if FindFirst(Filename, faAnyFile, SR) = 0 then Result := SR.Size
    else Result := -1;
  FindClose(SR);
end;

function StrSimilar (s1, s2: string): Integer;
var hit: Integer; // Number of identical chars
    p1, p2: Integer; // Position count
    l1, l2: Integer; // Length of strings
    pt: Integer; // for counter
    diff: Integer; // unsharp factor
    hstr: string; // help var for swapping strings
    // Array shows is position is already tested
    test: array [1..255] of Boolean;
begin
 // Test Length and swap, if s1 is smaller
 // we alway search along the longer string
 if Length(s1) < Length(s2) then begin
  hstr:= s2; s2:= s1; s1:= hstr;
 end;
 // store length of strings to speed up the function
 l1:= Length (s1);
 l2:= Length (s2);
 p1:= 1; p2:= 1; hit:= 0;
 // calc the unsharp factor depending on the length 
 // of the strings. Its about a third of the length
 diff:= Max (l1, l2) div 3 + ABS (l1 - l2);
 // init the test array
 for pt:= 1 to l1 do test[pt]:= False;
 // loop through the string
 repeat
  // position tested?
  if not test[p1] then begin
   // found a matching character?
   if (s1[p1] = s2[p2]) and (ABS(p1-p2) <= diff) then begin
    test[p1]:= True;
    Inc (hit); // increment the hit count
    // next positions
    Inc (p1); Inc (p2);
    if p1 > l1 then p1:= 1;
   end else begin
    // Set test array
    test[p1]:= False;
    Inc (p1);
    // Loop back to next test position if end of the string
    if p1 > l1 then begin
     while (p1 > 1) and not (test[p1]) do Dec (p1);
     Inc (p2)
    end;
   end;
  end else begin
   Inc (p1); 
   // Loop back to next test position if end of string
   if p1 > l1 then begin
    repeat Dec (p1); until (p1 = 1) or test[p1];
    Inc (p2);
   end;
  end;
 until p2 > Length(s2);
 // calc procentual value
 Result:= 100 * hit DIV l1;
end;

function Caculat_ErlandB(Traffic, Loss: single): integer;
var
  b: single;
  n: integer;
begin
  result := 1;
  b := 1;
  while true do
  begin
    b := ((Traffic * b) / result ) / (1 + Traffic * b / result);
    if b <= Loss then
      break;
    inc(result);
  end;
  n := result ;
  result := (n div 8) ;
  if n mod 8 <> 0 then
    inc(result);
end;

function GetPathName(s: string): string;
var
  I, k: Integer;
begin
  result := '';
  if s = '' then exit;
  I := LastDelimiter(PathDelim + DriveDelim, s);
  if i <= 0 then exit;
  for k:= i - 1 downto 0 do
  begin
     if s[k] = PathDelim then
       break;
  end;
  result := Copy(s, k + 1, i - k - 1 )
end;

function GetFileNameWithoutExt(s: string): string;
var
  iPos: integer;
begin
  result := ExtractFileName(s);
  iPos := pos('.', result);
  SetLength(result, iPos - 1);
end;

function WriteEventLog(Description: string = ''; ApplicationTitle:string = 'EricZeng';
         const AType: TEventType = evtInformation;
         const Category: Word = 0; const ID: LongWord = 0): boolean;
var
  EventSourceHandle: THandle;
  UserName: PChar;
  UserNameSize: LongWord;
  SID: Pointer;
  SIDSize: LongWord;
  Domain: PChar;
  DomainSize: LongWord;
  SIDUse: SID_NAME_USE;
  LineN: word;
  DescriptionP: Pointer;
const
  NewLineChars = Chr($0D) + Chr($0A);
  WordEventType: array [TEventType] of Word = (EVENTLOG_ERROR_TYPE,
                                               EVENTLOG_WARNING_TYPE,
                                               EVENTLOG_INFORMATION_TYPE,
                                               EVENTLOG_AUDIT_SUCCESS,
                                               EVENTLOG_AUDIT_FAILURE);
begin
  result := false;
  EventSourceHandle := 0;
  EventSourceHandle := RegisterEventSource(nil, PChar(ApplicationTitle));
  try
    if EventSourceHandle = 0 then exit;
    UserName := nil;
    SID := nil;
    Domain := nil;

    if Description <> '' then begin
      Description := NewLineChars + NewLineChars + Description;
      DescriptionP := PChar(Description);
      LineN := 1;
    end else
      LineN := 0;

    UserNameSize := 64;
    ReallocMem(UserName,UserNameSize + 1);
    while not GetUserName(UserName,UserNameSize) do begin
      if GetLastError <> ERROR_INSUFFICIENT_BUFFER then exit;
      UserNameSize := UserNameSize + 64;
      ReallocMem(UserName,UserNameSize + 1);
    end;
    SIDSize := 64;
    DomainSize := 64;
    ReallocMem(SID,SIDSize);
    ReallocMem(Domain,DomainSize);
    while not LookupAccountName(nil,UserName,SID,SIDSize,Domain,DomainSize,SIDUse) do begin
      if GetLastError <> ERROR_INSUFFICIENT_BUFFER then exit;
      ReallocMem(SID,SIDSize);
      ReallocMem(Domain,DomainSize);
    end;

    result := ReportEvent(EventSourceHandle,WordEventType[AType],
      Category,ID,SID,LineN,0,@DescriptionP,nil);
  finally
    ReallocMem(Domain,0);
    ReallocMem(SID,0);
    ReallocMem(UserName,0);
    if EventSourceHandle <> 0 then
      DeregisterEventSource(EventSourceHandle);
  end;
end;

function GetListBoxText(lb: TListBox): string;
var
  i: integer;
begin
  result := '';
  if lb = nil then exit;
  for i:= 0 to lb.Count - 1 do
  begin
    result := result + lb.Items.Strings[i];
    if i <> lb.Count - 1 then
      result := result + #9;
  end;
end;

procedure SetListBoxText(lb: TListBox; s: string);
var
  iPos: integer;
  tmp: string;
begin
  if lb = nil then exit;
  if s = '' then exit;
  lb.Items.BeginUpdate;
  try
    lb.Items.Clear;
    iPos := Pos(#9, s);
    while ipos > 0 do
    begin
      tmp := Copy(s, 1, iPos - 1);
      if Trim(tmp) <> '' then
        lb.Items.Add(tmp);
      Delete(s, 1, iPos);
      iPos := Pos(#9, s);
    end;
    if Trim(s) <> '' then
      lb.Items.Add(s);
  finally
    lb.Items.EndUpdate;
  end;
end;

function MyZeroEndString(var Str: string): Integer;
var
  i: integer;
begin
  result := Length(str);
  for i:= 1 to Length(str) - 1 do
  begin
    if str[i] = #0 then
    begin
      SetLength(str, i - 1);
      result := i - 1;
      break;
    end;
  end;
end;

function SameDouble(d1, d2: double): boolean;
begin
  result := Format('.8f', [d1]) = Format('.8f', [d2])
end;

function GetTempUniqueFileName(FileName: string): string;
var
  sc: integer;
  Name: string;

begin
  Name := ExtractFileName(FileName);
  result := FileName;
  sc := 1;
  while FileExists(result) do
  begin
    inc(sc);
    result := WithBackSlash( ExtractFilePath(FileName) ) +
    Format('%d-%s', [sc, Name]);
  end;
end;

function GetSubItemLeft(lvw: TListView; SubItem: integer): integer;
var
  i: integer;
begin
  result := 0;
  if lvw = nil then exit;
  if SubItem > lvw.Columns.Count then exit;
  for i:= 0 to SubItem -1 do
    inc(Result, lvw.Column[i].Width);
end;

function CheckListItemData(li: TListItem): boolean;
begin
  result := (li <> nil) and (li.Data <> nil);
end;

function  IsNumber(const sNumber: String): Boolean;
const
  CNumberChars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '-'];
var
  i: Integer;
begin
  result := True;
  for i := 1 to Length(sNumber) do
  begin
    if not (sNumber[i] in CNumberChars) then
    begin
      result := False;
      break;
    end;
  end;
end;

function DateTime2Str(dtStart, dtEnd: TDateTime): String;
begin
  result := FormatDateTime('YY-MM-DD HH:NN:SS', dtStart);
  result := result + '~' + FormatDateTime('YY-MM-DD HH:NN:SS', dtEnd);
end;

function Date2Str(dtStart, dtEnd: TDateTime): String;
begin
  if GetOnlyDate(dtStart) = GetOnlyDate(dtEnd) then
    result := FormatDateTime('YYYY-MM-DD', dtStart)
  else
    result := FormatDateTime('YYYY-MM-DD', dtStart) + '~' +
      FormatDateTime('YYYY-MM-DD', dtEnd);
end;

function GetSpleepTime(Tick: integer): integer;
const CILessOneSecDealy = 500;
begin
  case Tick of
    1..10 : result := (12 - tick - 1) * 1000;
    11    : result := CILessOneSecDealy;
    13..18: result := (20 - tick - 1) * 1000;
    19    : result := CILessOneSecDealy;
    21..30: result := (32 - tick - 1) * 1000;
    31    : result := CILessOneSecDealy;
    33..38: result := (40 - tick - 1) * 1000;
    39    : result := CILessOneSecDealy;
    41..50: result := (52 - tick - 1) * 1000;
    51    : result := CILessOneSecDealy;
    52..58: result := (60 - tick - 1) * 1000;
    59    : result := CILessOneSecDealy
    else
      result := CILessOneSecDealy;
  end;
end;

function StreamToStr(AStream: TStream): String;
var
  temp: string;
  i: integer;
begin
  result := '';
  if AStream = nil then exit;
  AStream.Position := 0;
  i := AStream.Size;
  if i <= 0 then exit;
  SetLength(temp, i);
  try
    AStream.read(temp[1], i);
    result := temp;
  finally
    SetLength(temp, 0);
  end;
end;

function StrToStream(strData: String): TStream;
var
  i: integer;
begin
  result := TMemoryStream.Create;
  try
    result.Position := 0;
    i := Length(strData);
    if i > 0 then
      result.Write(strData[1], i);
  except
  end;
end;

function GetDiskFreeSize(sPath: String): Int64;
var
  iDrive: Byte;
  sDrive: Char;
  iIndex: Integer;
begin
  result := -1;
  iIndex := Pos(':', sPath);
  if iIndex > 1 then
  begin
    sDrive := UpCase(sPath[iIndex - 1]);
    iDrive := Ord(sDrive) - 64;
    result := DiskFree(iDrive);
  end;
end;

end.
