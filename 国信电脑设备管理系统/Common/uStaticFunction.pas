{*********************************************************************}
{               Common Function & Utilities Unit                      }
{      (C) Copyright Kingron 1998 - 2004, All rights reserved.        }
{            Web page : http://kingron.delphibbs.com                  }
{                Mail : Kingron@163.net                               }
{*********************************************************************}
{  DateUtils: More datetime function like SameTime/SameDate
{  StrUtils:  More powerful function for string routeing
{  Math : more powerful function
{=====================================================================}
{  如果要把本单元生成DLL，请新建一个工程，类似下面：                  }
{  library lyhUtils;                                                  }
{                                                                     }
{  uses                                                               }
{    ShareMem,  SysUtils,  Classes,  lyhTools in 'lyhTools.pas';      }
{                                                                     }
{  {$R *.res}
{                                                                     }
{  begin                                                              }
{  end.                                                               }
{  并定义工程编译条件 _EXPORTS_;_DLL_                                 }
{---------------------------------------------------------------------}
{  如果直接使用本单元，不想采取DLL方式，这按如下方式：                }
{  请在Project Options中定义编译条件 _DLL_                            }
{  这样代码会直接编译到EXE中，不需要DLL运行                           }
{  默认会以连接代码方式，不采取DLL方式进行编译，若不需要，请去掉      }
{  下面的 $DEFINE _DLL_ 指令                                          }
{=====================================================================}
{$WARNINGS OFF}
unit uStaticFunction;

interface

uses Windows, SysUtils, Classes, Types, ShlObj, ActiveX, Graphics;

const
  DLL = 'lyhUtils.dll';
  shdocvw = 'shdocvw.dll';

  {$D 'Copyright(C) 2004, Kingron, All rights reserved.'}
  {$IFNDEF _DLL_}
  {$DEFINE _DLL_}
  {$ENDIF}
resourcestring
  SConfirm = 'Confirm';
  SError = 'Error';
  SInformation = 'Info';
  SDays = ' Day(s) ';
  SHours = ' Hour(s) ';
  SMinutes = ' Minute(s) ';
  SSeconds = ' Second(s) ';
  SYears = ' Year(s) ';
  SMonths = ' month(s) ';
  SMilliseconds = ' Millisecond(s) ';
  SBytes = ' Byte(s)';

  SErrBrowseComputer = 'Unable open browse computer dialog';
  SErrReadStream = 'Error read stream';
  SPressAnyKey = 'Press any key to continue...';
  SErrDataType = 'Data type mismatch';
  SErrLoadDLL = 'Can''t load library:';
  SErrBadSet = 'Bad set: ';
  SErrBadFormat = 'Bad format string';
  SErrOutOfPointer = 'Insufficent pointers for format specifiers!';
  SErrBoolValue = '''%s'' is not a valid boolean value.';
  SErrBinString = #13'Invalid binary string :"%s"'#13;

const
  CSBoolValues: array[Boolean] of string = ('0', '1');
  CSBoolString: array[Boolean] of string = ('false', 'true');
  CSBoolChioce: array[Boolean] of string = ('no', 'yes');

  CrLf = #13#10;
  DblCrLf = CrLf + CrLf;

  SHFMT_ID_DEFAULT = $FFFF;

  { Formating options }
  SHFMT_OPT_QUICKFORMAT = $0000;
  SHFMT_OPT_FULL = $0001;
  SHFMT_OPT_SYSONLY = $0002;
  // Error codes
  SHFMT_ERROR = $FFFFFFFF;
  SHFMT_CANCEL = $FFFFFFFE;
  SHFMT_NOFORMAT = $FFFFFFFD;
  DEFAULT_GUID: TGUID = '{00000000-0000-0000-0000-000000000000}';

  rfAllNoCase = [rfReplaceAll, rfIgnoreCase];

  CSHexTable: array[0..15] of string = (
    '0000', '0001', '0010', '0011',
    '0100', '0101', '0110', '0111',
    '1000', '1001', '1010', '1011',
    '1100', '1101', '1110', '1111'
    );

const
  CSIDL_INTERNET = $0001;
  CSIDL_PROGRAMS = $0002;
  CSIDL_CONTROLS = $0003;
  CSIDL_PRINTERS = $0004;
  CSIDL_PERSONAL = $0005;
  CSIDL_FAVORITES = $0006;
  CSIDL_STARTUP = $0007;
  CSIDL_RECENT = $0008;
  CSIDL_SENDTO = $0009;
  CSIDL_BITBUCKET = $000A;
  CSIDL_STARTMENU = $000B;
  CSIDL_DESKTOPDIRECTORY = $0010;
  CSIDL_DRIVES = $0011;
  CSIDL_NETWORK = $0012;
  CSIDL_NETHOOD = $0013;
  CSIDL_FONTS = $0014;
  CSIDL_TEMPLATES = $0015;
  CSIDL_COMMON_STARTMENU = $0016;
  CSIDL_COMMON_PROGRAMS = $0017;
  CSIDL_COMMON_STARTUP = $0018;
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  CSIDL_APPDATA = $001A;
  CSIDL_PRINTHOOD = $001B;
  CSIDL_ALTSTARTUP = $001D;
  CSIDL_COMMON_ALTSTARTUP = $001E;
  CSIDL_COMMON_FAVORITES = $001F;
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_COOKIES = $0021;
  CSIDL_HISTORY = $0022;
  CSIDL_COMMON_APPDATA = $0023;
  CSIDL_WINDOWS = $0024;
  CSIDL_SYSTEM = $0025;
  CSIDL_PROGRAM_FILES = $0026;
  CSIDL_MYPICTURES = $0027;
  CSIDL_PROFILE = $0028;
  CSIDL_SYSTEMX86 = $0029;
  CSIDL_PROGRAM_FILESX86 = $002A;
  CSIDL_PROGRAM_FILES_COMMON = $002B;
  CSIDL_PROGRAM_FILES_COMMONX86 = $002C;
  CSIDL_COMMON_TEMPLATES = $002D;
  CSIDL_COMMON_DOCUMENTS = $002E;
  CSIDL_COMMON_ADMINTOOLS = $002F;
  CSIDL_ADMINTOOLS = $0030;
  CSIDL_CONNECTIONS = $0031;
  CSIDL_COMMON_MUSIC = $0035;
  CSIDL_COMMON_PICTURES = $0036;
  CSIDL_COMMON_VIDEO = $0037;
  CSIDL_RESOURCES = $0038;
  CSIDL_RESOURCES_LOCALIZED = $0039;
  CSIDL_COMMON_OEM_LINKS = $003A;
  CSIDL_CDBURN_AREA = $003B;
  CSIDL_COMPUTERSNEARME = $003D;

  CSIDL_FLAG_PER_USER_INIT = $00800;
  CSIDL_FLAG_NO_ALIAS = $001000;
  CSIDL_FLAG_DONT_VERIFY = $004000;
  CSIDL_FLAG_CREATE = $008000;
  CSIDL_FLAG_MASK = $00FF00;

const
  CODEPAGE_Thai = 0874;
  CODEPAGE_Japanese = 0932;
  CODEPAGE_Chinese_PRC = 0936;
  CODEPAGE_Korean = 0949;
  CODEPAGE_Chinese_Taiwan = 0950;
  CODEPAGE_UniCode = 1200;
  CODEPAGE_Windows_31_EastEurope = 1250;
  CODEPAGE_Windows_31_Cyrillic = 1251;
  CODEPAGE_Windows_31_Latin1 = 1252;
  CODEPAGE_Windows_31_Greek = 1253;
  CODEPAGE_Windows_31_Turkish = 1254;
  CODEPAGE_Hebrew = 1255;
  CODEPAGE_Arabic = 1256;
  CODEPAGE_Baltic = 1257;

const
  {$EXTERNALSYM PRINTACTION_OPEN}
  PRINTACTION_OPEN           = 0;
  {$EXTERNALSYM PRINTACTION_PROPERTIES}
  PRINTACTION_PROPERTIES     = 1;
  {$EXTERNALSYM PRINTACTION_NETINSTALL}
  PRINTACTION_NETINSTALL     = 2;
  {$EXTERNALSYM PRINTACTION_NETINSTALLLINK}
  PRINTACTION_NETINSTALLLINK = 3;
  {$EXTERNALSYM PRINTACTION_TESTPAGE}
  PRINTACTION_TESTPAGE       = 4;
  {$EXTERNALSYM PRINTACTION_OPENNETPRN}
  PRINTACTION_OPENNETPRN     = 5;
  {$EXTERNALSYM PRINTACTION_DOCUMENTDEFAULTS}
  PRINTACTION_DOCUMENTDEFAULTS = 6;
  {$EXTERNALSYM PRINTACTION_SERVERPROPERTIES}
  PRINTACTION_SERVERPROPERTIES = 7;


const
  { ShRun Dialog Flag }
  RFF_NOBROWSE = 1; //Removes the browse button.
  RFF_NODEFAULT = 2; // No default item selected.
  RFF_CALCDIRECTORY = 4; // Calculates the working directory from the file name.
  RFF_NOLABEL = 8; // Removes the edit box label.
  RFF_NOSEPARATEMEM = 14; // Removes the Separate Memory Space check box (Windows NT only).

type
  TChars = set of char;
  Float = type Single;
  IntRec = packed record
    case integer of
      0: (Value: integer);
      1: (Lo, Hi: Word);
      2: (Words: array[0..1] of Word);
      3: (Bytes: array[0..3] of Byte);
  end;

  TDisplayProc = procedure(const Line: string) of object;
  TFileSplitProgress = procedure(Percent: integer);
  TFindFileProc = procedure(const FileName: string; Info: TSearchRec);
  TSelectDirectoryProc = function(const Directory: string): Boolean;

  TDlgTemplateEx = packed record
    dlgTemplate: DLGITEMTEMPLATE;
    ClassName: string;
    Caption: string;
  end;

  TMD5Ctx = record
    State: array[0..3] of Integer;
    Count: array[0..1] of Integer;
    case Integer of
      0: (BufChar: array[0..63] of Byte);
      1: (BufLong: array[0..15] of Integer);
  end;

{#}////////////////////////////////////////////////////////////////////////////
//       String/Text Function & procedure
////////////////////////////////////////////////////////////////////////////{#}
{ 把单词第一个字母大写 }
function StrHash(const SoureStr: string): Cardinal;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StrHash; {$ENDIF}{#}

{ 把单词第一个字母大写 }
function Capitalize(const s : string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Capitalize; {$ENDIF}{#}

  { 把Pascal字符串变成C格式的字符串，例如'a\b'--> 'a\\b' }
function PascalStringToC(const s: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PascalStringToC; {$ENDIF}{#}

{ 把C的转义字符串转换成Delphi字符串 }
function CStringToPascal(const s: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CStringToPascal; {$ENDIF}{#}

{ 把二进制数据按十六进制进行显示 }
procedure ShowDataAsHex(Data: PChar; Count: Cardinal; CallBack: TDisplayProc); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShowDataAsHex; {$ENDIF}{#}

{ 读取资源字符串，可以支持本地化，例如返回IDOK="确定" }
function LoadStringEx(hInstance: HINST; const ID: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LoadStringEx; {$ENDIF}{#}

{ 判断Value是否在Args中 }
function GetStringIndex(const Value: string; const Args: array of string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetStringIndex; {$ENDIF}{#}

{ 返回Sub在Source在中出现的次数 }
function StrSubCount(const Source, Sub: string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StrSubCount; {$ENDIF}{#}

{ 反转一个字符串 }
function ReverseString(const s: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ReverseString; {$ENDIF}{#}

{ 删除指定字符串中指定的字符集 }
function DeleteChars(var S: string; Chars: TChars): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DeleteChars; {$ENDIF}{#}

{ 检查S中的每一个字符是否在Chars中的集合中，是：返回True，若有任意一个不在，返回False }
function CheckChars(const S: string; const Chars: TChars): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckChars; {$ENDIF}{#}

{ 返回中文大写数字 }
function CnNumber(Number: Double): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CnNumber; {$ENDIF}{#}

{ 返回中文的拼音首字母 }
function CnPYIndex(const CnString: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CnPYIndex; {$ENDIF}{#}

{ 返回大写金额中文 }
function CnCurrency(Cur: Currency): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CnCurrency; {$ENDIF}{#}

{ 返回指定字符串中Ch从右边开始第Count次出现的位置 }
function RightPos(s: string; ch: char; count: integer = 1): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RightPos; {$ENDIF}{#}

{ 返回Sub在Source中第Index出现的位置 }
function PosEx(const Source, Sub: string; Index: Integer = 1): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PosEx; {$ENDIF}{#}

{ 返回SubStr在S中第N个字符后开始出现的位置 }
function PosEx2(const substr: AnsiString; const s: AnsiString; const Start: Integer): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PosEx2; {$ENDIF}{#}

{ 字符串的模糊匹配，支持通配符*和?，通配符可以出现多次 }
function MatchPattern(Source, SubStr: PChar): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MatchPattern; {$ENDIF}{#}

{ 字符串的模糊匹配，支持通配符*和?，通配符可以出现多次 }
function MatchPatternEx(InpStr, Pattern: PChar): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MatchPatternEx; {$ENDIF}{#}

{ 返回Text中的单词的个数 }
function WordCount(const Text: string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WordCount; {$ENDIF}{#}

{ 返回Text中中文字符的个数 }
function CnWordCount(Text: string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CnWordCount; {$ENDIF}{#}

{ 返回指定长度的随机的字符串 }
function GetRandomString(Len: Integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetRandomString; {$ENDIF}{#}

{ 格式化Value为指定宽度Width的字符串 }
function FixFormat(const Width: integer; const Value: Double): string; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FixFormat(const Width: integer; const Value: Double); {$ENDIF}{#}

{ 格式化Value为指定宽度Width的字符串 }
function FixFormat(const Width: integer; const Value: integer): string; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FixFormat(const Width: integer; const Value: integer); {$ENDIF}{#}

{ 分隔字符串，ch为分隔符，Source需要分隔的字符串 }
procedure SplitStringList(const source, ch: string; pList: TStrings);stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'SplitStringList';{$ENDIF}{$IFDEF _EXPORTS_} exports procedure SplitStringList(const source, ch: string; pList: TStrings) name 'SplitStringList'; {$ENDIF}{#}

{ 分隔字符串，ch为分隔符，Source需要分隔的字符串 }
function SplitString(const source, ch: string): TStringDynArray; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'SplitString';{$ENDIF}{$IFDEF _EXPORTS_} exports SplitString(const source, ch: string) name 'SplitString'; {$ENDIF}{#}

{ 分隔字符串，ch为分隔符，Source需要分隔的字符串 }
procedure SplitString(const source, ch: string; Results: TStrings); overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'SplitString2';{$ENDIF}{$IFDEF _EXPORTS_} exports SplitString(const source, ch: string; Results: TStrings) name 'SplitString2'; {$ENDIF}{#}

{ 按掩码分割字符串 }
function SplitStringEx(const Source, Mask: string; R: TStrings): Boolean;
{#}{$IFNDEF _DLL_}external DLL name 'SplitString2';{$ENDIF}{$IFDEF _EXPORTS_} exports SplitStringEx; {$ENDIF}{#}

{ 把字符串中的单词提取出来 }
procedure SplitTextToWords(const S: string; words: Tstrings);
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SplitTextToWords; {$ENDIF}{#}

{ 把ANSI字符串转换成Unicode编码字符串 }
function AnsiToUnicode(const Ansi: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AnsiToUnicode; {$ENDIF}{#}

{ 把Unicode字符串转换成ANSI编码 }
function UnicodeToAnsi(const Unicode: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UnicodeToAnsi; {$ENDIF}{#}

{ 把Int转换成字符串，不使用Format来做，效率高一些 }
function IntToStr2(int: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IntToStr2; {$ENDIF}{#}

{ 把Str转换成整数 }
function StrToInt2(const str: string; out int: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StrToInt2; {$ENDIF}{#}

{ 替换Str中的所有的FromChar为ToChar }
function TranslateChar(const Str: string; FromChar, ToChar: Char): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports TranslateChar; {$ENDIF}{#}

{ 返回Source中Flag1和Flag2中的字符串，包括Flag1，Flag2本身 }
function ExtractString(const Source, sBegin, sEnd: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ExtractString; {$ENDIF}{#}

{ 返回Source中对应Name的值 }
function ExtractValue(const Source, Name: string; const Serperator: string = '='): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ExtractValue; {$ENDIF}{#}

{ 去除字符串S中首尾指定的字符Ch，类似于Trim函数 }
function TrimChar(S: string; Ch: Char): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports TrimChar; {$ENDIF}{#}

{ 效率更高的字符串替换函数，会替换所有的字符串 }
function FastReplace(var aSourceString: string; const aFindString, aReplaceString: string; CaseSensitive: Boolean = False): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FastReplace; {$ENDIF}{#}

{ 判断从Source中的StartPosition后是否存在Pattern，返回其位置 }
function InString(StartPosition: Cardinal; const Source, Pattern: string): Cardinal; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports InString; {$ENDIF}{#}

{ 判断从Source中的StartPosition后是否存在Pattern，返回其位置，反转比较！ }
function InStringReverse(StartPosition: Cardinal; const Source, Pattern: string): Cardinal; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports InStringReverse; {$ENDIF}{#}

{ 返回两个字符串的近似程度，返回百分比0~100 }
function StrSimilar(s1, s2: string): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StrSimilar; {$ENDIF}{#}

{ 快速的字符串替换函数，替换所有，不分大小写 }
function ReplaceString(S: string; const Old, New: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ReplaceString; {$ENDIF}{#}

{ 全角字符转换成半角字符 }
function WidthFullToHalf(Source: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WidthFullToHalf; {$ENDIF}{#}

{ 半角字符转换成全角字符 }
function WidthHalfToFull(Source: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WidthHalfToFull; {$ENDIF}{#}

{ 返回字符串中Seperator左边的字符串，例如LeftPart('ab|cd','|')='ab' }
function LeftPart(Source, Seperator: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LeftPart; {$ENDIF}{#}

{ 返回字符串中Seperator右边的字符串，例如RightPart('ab|cd','|')='cd' }
function RightPart(Source, Seperator: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RightPart; {$ENDIF}{#}

{ 按Seperator分割Source，返回第Index(From 0)部分，例如：Part('ab|cd|ef','|',1)='cd' }
function Part(Source, Seperator: string; Index: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Part; {$ENDIF}{#}

{ 整理合并区间文本字符串：TidyLimit('1-2,2-3,5,7,8,12-45') = '1-3,5,7-8,12-45' }
function TidyLimit(mLimitText: string; mDelimiter: Char = ','; mLimitLine: string = '-'): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports TidyLimit; {$ENDIF}{#}

{ 排序字符串 }
function SortString(mStr: string; mDesc: Boolean = True): string;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SortString; {$ENDIF}{#}

{ 类似C语言中sprintf的函数 }
function sprintf(const Format: string; Args: array of const): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SPrintf; {$ENDIF}{#}

{ 从URI中提取域名或者IP }
function GetHostFromURI(const URI: string): string;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetHostFromURI; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Encrypt/Decrypt function
//////////////////////////////////////////////////////////////////////////////

{ 比较两个字符串的MD5结果是否一致 }
function MD5Match(const S, MD5Value: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MD5Match; {$ENDIF}{#}

{ 返回指定字符串的MD5散列值 }
function MD5String(const Value: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MD5String; {$ENDIF}{#}

procedure MD5Init(var MD5Context: TMD5Ctx);
procedure MD5Update(var MD5Context: TMD5Ctx; const Data: PChar; Len: integer);
function MD5Final(var MD5Context: TMD5Ctx): string;
function MD5Print(D: string): string;

{ 对文件求MD5散列值 }
function MD5File(FileName: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MD5File; {$ENDIF}{#}

{ 简单的数据加密，配合DecryptData使用 }
function EncryptData(Data: PChar; Len: integer; Key: DWORD): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EncryptData; {$ENDIF}{#}

{ 简单的数据解密，配合EncryptData使用 }
function DecryptData(Data: PChar; Len: integer; Key: DWORD): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DecryptData; {$ENDIF}{#}

{ 简单的数据加密，配合DecryptData使用 }
function EncryptString(Data: string; Key: DWORD): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EncryptString; {$ENDIF}{#}

{ 简单的数据解密，配合EncryptData使用 }
function DecryptString(Data: string; Key: DWORD): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DecryptString; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Check & Valid function
//////////////////////////////////////////////////////////////////////////////

{ 检查字符串是否是回文字符串 }
function IsReversString(const S: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsReversString; {$ENDIF}{#}

{ 检查一个字符串是否是空的字符串，空串是指首字符和末字符中不包含非空白字符的字符串！ }
function IsEmptyStr(const Str: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsEmptyStr; {$ENDIF}{#}

{ 判断Ch是否是大写字母 }
function IsUpper(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsUpper; {$ENDIF}{#}

{ 判断Ch是否是小写字母 }
function IsLower(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsLower; {$ENDIF}{#}

{ 判断Ch是否是英文字母 }
function IsAlpha(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsAlpha; {$ENDIF}{#}

{ 判断Ch是否是字母或者数字字符 }
function IsAlNum(ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsAlNum; {$ENDIF}{#}

{ 判断Ch是否是标点字符 }
function IsPunct(ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsPunct; {$ENDIF}{#}

{ 判断Ch是否是数字 }
function IsDigit(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsDigit; {$ENDIF}{#}

{ 判断Ch是否是控制字符 }
function IsControl(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsControl; {$ENDIF}{#}

{ 判断Ch是否是图形字符 }
function IsGraph(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsGraph; {$ENDIF}{#}

{ 判断Ch是否是可打印字符 }
function IsPrint(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsPrint; {$ENDIF}{#}

{ 判断Ch是否是空白字符 }
function IsSpace(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsSpace; {$ENDIF}{#}

{ 判断Ch是否是十六进制数字字符 }
function IsXDigit(const Ch: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsXDigit; {$ENDIF}{#}

{ 判断一个字符串是否是整数 }
function IsInteger(const S: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsInteger; {$ENDIF}{#}

{ 判断字符串是否是浮点数 }
function IsFloat(const S: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsFloat; {$ENDIF}{#}

{ 返回字符串的CRC32值 }
function CRC32(Buffer: PChar; Len: integer): DWORD; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CRC32; {$ENDIF}{#}

{ 判断字符串是否是合法的信用卡号 }
function IsValidCreditCard(c: string): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsValidCreditCard; {$ENDIF}{#}

{ 判断字符串是否是合法的ISBN }
function IsISBN(ISBN: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsISBN; {$ENDIF}{#}

{ 判断字符串是否是合法的IP地址，不检查IP是否可以访问！ }
function IsValidIP(const IP: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsValidIP; {$ENDIF}{#}

{ 判断字符串是否是合法的Email地址，不检查帐户是否有效！ }
function IsValidEmail(const Value: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsValidEmail; {$ENDIF}{#}

{ 判断字符串是否是合法的文件名 }
function IsValidFileName(FileName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsValidFileName; {$ENDIF}{#}

{ 判断是否是在远程桌面中运行 }
function IsRemoteSession: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsRemoteSession; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Shell Function & Procedure
//////////////////////////////////////////////////////////////////////////////
{ 使用Shell方式返回文件名列表 }
procedure ShGetFiles(Files: TStrings; Folder: string; SubDir: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShGetFiles; {$ENDIF}{#}

{ 创建快捷方式对话框 }
procedure DlgNewLinkHere(Location: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgNewLinkHere; {$ENDIF}{#}

{ 创建一个快捷方式 }
function CreateShortCut(const sourcefilename, Arguments, DestFileName: string): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CreateShortCut; {$ENDIF}{#}

{ 从LNK文件中找出对应的磁盘文件的的文件名 }
function ResolveLink(const LnkFileName: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ResolveLink; {$ENDIF}{#}

{ 返回一个指定文件路径的PItemIDList }
function GetPIDLFromPath(const Path: string): PItemIDList; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetPIDLFromPath; {$ENDIF}{#}

{ 判断一个IDList是否是一个文件夹 }
function IsFolder(ShellFolder: IShellFolder; ID: PItemIDList): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsFolder; {$ENDIF}{#}

{ 从一个ItemIDList返回其对应路径字符串 }
function GetPathFromPIDL(Pid: PItemIDList): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetPathFromPIDL; {$ENDIF}{#}{ Retrun string of PID }

{ 从ItemIDList返回在系统图标列表中的ImageIndex }
function GetImgIndexFromPIDL(pidl: PItemIDList): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetImgIndexFromPIDL; {$ENDIF}{#}

{ 返回ItemIDList中下一个ItemID }
function NextPIDL(IDList: PItemIDList): PItemIDList; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports NextPIDL; {$ENDIF}{#}

{ 返回一个ItemIDList的大小 }
function GetPIDLSize(IDList: PItemIDList): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetPIDLSize; {$ENDIF}{#}

{ 创建一个PItemIDList }
function CreatePIDL(Size: Integer): PItemIDList; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CreatePIDL; {$ENDIF}{#}

{ 复制一个PItemIDList }
function CopyPIDL(IDList: PItemIDList): PItemIDList; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CopyPIDL; {$ENDIF}{#}

{ 连接两个PItemIDList }
function ConcatPIDL(IDList1, IDList2: PItemIDList): PItemIDList; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ConcatPIDL; {$ENDIF}{#}

{ 释放一个PItemIDList }
procedure FreePidl(pidl: PItemIDList); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FreePidl; {$ENDIF}{#}

{ 返回系统特殊文件夹对应的路径 }
function GetSpecialFolderPath(CSIDL: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSpecialFolderPath; {$ENDIF}{#}

{ 打开系统特殊文件夹 }
procedure OpenSpecialFolder(CSIDL_Folder: integer); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports OpenSpecialFolder; {$ENDIF}{#}

{ 返回指定扩展名对应的图标 }
function GetAssociatedIcon(const AExtension: string; ASmall: Boolean): HIcon; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetAssociatedIcon; {$ENDIF}{#}

{ 打开任务栏属性对话框 }
procedure DlgTaskBarProperties;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgTaskBarProperties; {$ENDIF}{#}

{ 复制文件到剪切板，多个文件名用#0字符分割，最后以两个#0字符表示结束 }
procedure CopyFilesToClipboard(FileList: string);
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgTaskBarProperties; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Printer function & Procedure
//////////////////////////////////////////////////////////////////////////////
{ 保存全局的打印机信息 }
procedure SavePrinterInfo(APrinterName: PChar; ADestStream: TStream); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SavePrinterInfo; {$ENDIF}{#}

{ 读取全局打印机信息 }
procedure LoadPrinterInfo(APrinterName: PChar; ASourceStream: TStream); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LoadPrinterInfo; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Windows/Control function & Procedure
//////////////////////////////////////////////////////////////////////////////

function RegAndCreateWindow(const ClassName, Caption: string; WndProc : TFNWndProc): HWND;

{ 使用颜色通道透明窗体 }
procedure ColorUpdateLayeredWindow(Wnd: HWND; BMP: TBitmap; TransColor: COLORREF);
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ColorUpdateLayeredWindow; {$ENDIF}{#}

{ 使用Alpha通道透明窗体 }
procedure AlphaUpdateLayeredWindow(Wnd: HWND; Bmp: TBitmap; Alpha: Byte); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AlphaUpdateLayeredWindow; {$ENDIF}{#}

{ 设置Edit只能输入数字 }
procedure SetEditNumber(EditWnd: HWND; const NumberOnly: Boolean = True); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetEditNumber; {$ENDIF}{#}

{ 把一个指定窗口提到前台 }
function ForceForegroundWindow(hWnd: HWND): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ForceForegroundWindow; {$ENDIF}{#}

{ 在指定位置弹出窗口的系统菜单 }
procedure PopWindowMenu(hWnd: HWND; P: TPoint); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PopWindowMenu; {$ENDIF}{#}

{ 设置一个窗口中在最前，不会闪烁！ }
procedure SetWindowOnTop(const hWnd: HWND; const OnTop: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetWindowOnTop; {$ENDIF}{#}

{ 让控件开始移动 }
procedure MoveControl(WinControl: HWND); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MoveControl; {$ENDIF}{#}

{ 允许/禁止 一个控件 }
procedure EnableControl(hWnd: hWnd; Enable: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EnableControl; {$ENDIF}{#}

{ 圆滑一个空间的边角 }
procedure RoundedControl(hWnd: HWND); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RoundedControl; {$ENDIF}{#}

{ 最小化一个窗口 }
procedure MinWindow(hWnd: HWND); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MinWindow; {$ENDIF}{#}

{ 最大化一个窗口 }
procedure MaxWindow(hWnd: HWND); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MaxWindow; {$ENDIF}{#}

{ 恢复一个窗口 }
procedure RestoreWindow(hWnd: HWND); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RestoreWindow; {$ENDIF}{#}

{ 设置控件为多行风格 }
procedure SetControlMultiLine(const hWnd: HWND; const Enable: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetControlMultiLine; {$ENDIF}{#}

{ 返回指定窗口的类名 }
function GetWindowClassName(hWnd: HWND): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetWindowClassName; {$ENDIF}{#}

{ 返回窗口的标题 }
function GetWindowCaption(hWnd: HWND): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetWindowCaption; {$ENDIF}{#}

{ 指定控件显示一个气球提示 }
procedure ShowBalloonTip(hWnd: HWND; Icon: integer; Title: pchar; Text: PChar; const DelayTime: DWORD=$F0F0F0; const BkColor: COLORREF = 0; const Color: COLORREF = 0); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShowBalloonTip; {$ENDIF}{#}

{ 返回任务管理器的窗口句柄 }
function GetTaskmanWindow: HWND; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetTaskmanWindow; {$ENDIF}{#}

{ 返回桌面ListView的句柄 }
function GetDesktopListViewWnd: HWND;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetDesktopListViewWnd; {$ENDIF}{#}

{ 返回整个系统中当前拥有焦点的控件的句柄 }
function GetSysFocusControl: HWND; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSysFocusControl; {$ENDIF}{#}

{ 返回任务栏是否自动隐藏 }
function IsTaskbarAutoHide: boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsTaskbarAutoHide; {$ENDIF}{#}

{ 返回任务栏是否总在最前 }
function IsTaskbarAlwaysOnTop: boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsTaskbarAlwaysOnTop; {$ENDIF}{#}

{ 判断一个窗口是否“没有响应”}
function IsWindowResponing(hWnd: HWND; const TimeOut: integer = 2000): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsWindowResponing; {$ENDIF}{#}

{ 显示/隐藏任务管理器窗口 }
procedure ShowTaskmanWindow(bValue: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShowTaskmanWindow; {$ENDIF}{#}

{ 返回系统托盘的句柄 }
function GetSysTrayWnd: HWND; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSysTrayWnd; {$ENDIF}{#}

{ 返回系统任务栏任务按钮列表的句柄 }
function GetSysTaskbarListWnd: HWND; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSysTaskbarListWnd; {$ENDIF}{#}

{ 返回工具栏指定按钮文字对应按钮的矩形区域 }
function GetToolBarButtonRect(hWnd: HWND; Title: string): TRect; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetToolBarButtonRect; {$ENDIF}{#}

{ 返回系统托盘区的矩形范围 }
function GetSysTrayIconRect(Text: string): TRect; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSysTrayIconRect; {$ENDIF}{#}

{ 返回任务栏中对应任务的任务栏按钮的矩形区域 }
function GetTaskBarButtonRect(Title: string): TRect; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetTaskBarButtonRect; {$ENDIF}{#}

{ 返回系统当前鼠标的坐标 }
function CurrMousePos: TPoint; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CurrMousePos; {$ENDIF}{#}

{ 刷新系统托盘 }
procedure RefreshTrayIcon;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RefreshTrayIcon; {$ENDIF}{#}

function CascadeWindowsEx(const Owner: HWND; const R: TRect; const WinHWNDs : array of HWND): Integer;

//////////////////////////////////////////////////////////////////////////////
//       Date/Time function & procedure
//////////////////////////////////////////////////////////////////////////////
{ 判断是否是新的一天 }
function IsNewDay(var LastTime: TDateTime): Boolean;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsNewDay; {$ENDIF}{#}

{ 判断是否同一天 }
function SameDate(Const ATime,BTime: TDateTime): Boolean;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SameDate; {$ENDIF}{#}

{ 返回当前系统的GMT/UTC时间 }
function GMTNow: TDateTime; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GMTNow; {$ENDIF}{#}

{ 转换本地时间为UTC时间 }
function LocaleToGMT(const Value: TDateTime): TDateTime; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LocaleToGMT; {$ENDIF}{#}

{ 转换UTC时间为本地时间 }
function GMTToLocale(const Value: TDateTime): TDateTime; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GMTToLocale; {$ENDIF}{#}

{ 相减两个时间，返回相差的分钟数 }
function SubTimeToMinutes(StartT, EndT: TDateTime): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SubTimeToMinutes; {$ENDIF}{#}

{ 返回两个时间之间相差的秒数 }
function SubTimeToSeconds(StartT, EndT: TDateTime): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SubTimeToSeconds; {$ENDIF}{#}

{ 返回两个时间的毫秒数差 }
function SubTimeToMSeconds(StartT, EndT: TDateTime): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SubTimeToMSeconds; {$ENDIF}{#}

{ 返回一个人的年龄，截止当前年份 }
function GetAge(Birthday: TDateTime): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetAge; {$ENDIF}{#}

{ 判断两个时间是否相同 }
function SameTime(const Time1, Time2: TDateTime): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SameTime; {$ENDIF}{#}

{ 判断两个时间是否接近，精确到秒 }
function NearTime(const Time1, Time2: TDateTime; const Offset_MSec: integer = 1): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports NearTime; {$ENDIF}{#}

{ 毫秒数转换成 ?天?时?分?秒的字符串 }
function MSecondsToString(MSeconds: int64): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MSecondsToString; {$ENDIF}{#}

{ 返回浮点数的？天？时？分？秒的字符串 }
function DateTimeToStringEx(Value: TDateTime; const ShortFormat: Boolean=False): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DateTimeToStringEx; {$ENDIF}{#}

{ 按格式转换一个字符串为TDateTime，例如StrToDateTimeFmt('yyyymmnnhhssnn','20040601102359') }
function StringToDateTime(const DateTimeFormat, DateTimeStr: string): TDateTime; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StringToDateTime; {$ENDIF}{#}

{ 秒数转换成 ?天?时?分?秒的字符串 }
function SecondsToString(Seconds: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SecondsToString; {$ENDIF}{#}

{ FileTime转换成年月日时分秒格式 }
function FileTimeToString(Value: _FILETIME): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FileTimeToString; {$ENDIF}{#}

{ 检查指定的时间是否是指定的星期，例如：CheckWeekDay(Now, 2)检查当天是否是星期二 }
function CheckWeekDay(const ADateTime: TDateTime; Day_WeekDay: Byte): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckWeekDay; {$ENDIF}{#}

{ 转换Unix时间为DateTime格式时间 }
function UnixToDateTimeEx(Seconds, uSeconds: Int64): TDateTime; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UnixToDateTimeEx; {$ENDIF}{#}

{ 转换一个DateTime为秒数和微秒数两个部分，返回结果高位1970年1月1日0：0：0秒的秒数 }
function DateTimeToUnixEx(const ATime: TDateTime; out Seconds, uSeconds : Cardinal): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DateTimeToUnixEx; {$ENDIF}{#}

{ 转换一个DateTime为分钟数 }
function DateTimeToMinutes(ADateTime: TDateTime): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DateTimeToMinutes; {$ENDIF}{#}

{ 转换一个DateTime为秒数 }
function DateTimeToSeconds(ADateTime: TDateTime): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DateTimeToSeconds; {$ENDIF}{#}

{ 转换一个DateTime为毫秒数 }
function DateTimeToMSeconds(ADateTime: TDateTime): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DateTimeToMSeconds; {$ENDIF}{#}

function TimeToFileName(const T: TDateTime): string;

//////////////////////////////////////////////////////////////////////////////
//       GUID function & procedure
//////////////////////////////////////////////////////////////////////////////
{ 判断两个GUID是否相同 }
function SameGUID(const ID1, ID2: TGUID): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SameGUID(const ID1, ID2: TGUID); {$ENDIF}{#}

{ 判断两个GUID是否相同 }
function SameGUID(const ID1: TGUID; const ID2: string): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SameGUID(const ID1: TGUID; const ID2: string); {$ENDIF}{#}

{ 判断两个GUID是否相同 }
function SameGUID(const ID1, ID2: string): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SameGUID(const ID1, ID2: string); {$ENDIF}{#}

{ 动态生成一个GUID }
function GetGUID: TGUID; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetGUID; {$ENDIF}{#}

{ 返回一个动态生成的GUID的字符串 }
function GetGUIDString: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetGUIDString; {$ENDIF}{#}

{ 判断一个字符串是否是一个合法的GUID }
function IsGUID(const S: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsGUID; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Dialog function & procedure
//////////////////////////////////////////////////////////////////////////////
{ 默认对话框处理程序 }
function DefDialogProc(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DefDialogProc; {$ENDIF}{#}

{ 显示一个自定义对话框 }
function DialogBoxEx(const Controls: array of TDlgTemplateEx; const DlgProc: Pointer = nil): integer;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DialogBoxEx; {$ENDIF}{#}

{ 显示一个输入文本对话框 }
function InputBoxEx(const ACaption, AHint, ADefault: string; out Text: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports InputBoxEx; {$ENDIF}{#}

{ 显示确认对话框 }
function DlgConfirm(const Msg: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgConfirm; {$ENDIF}{#}

{ 支持参数的确认对话框 }
function DlgConfirmEx(const Msg: string; Args: array of const): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgConfirmEx; {$ENDIF}{#}

{ 显示一个信息框 }
procedure DlgInfo(const Msg: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgInfo; {$ENDIF}{#}

{ 支持参数的确认对话框 }
procedure DlgInfoEx(const Msg: string; Args: array of const); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgInfoEx; {$ENDIF}{#}

{ 显示一个错误对话框 }
procedure DlgError(const Msg: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgError; {$ENDIF}{#}

{ 支持参数的错误信息对话框 }
procedure DlgErrorEx(const Msg: string; Args: array of const); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgErrorEx; {$ENDIF}{#}

{ 显示最近一次API操作的错误信息 }
procedure DlgLastError; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgLastError; {$ENDIF}{#}

{ 封装的MessageBox }
function MsgBox(const Msg: string; const Title: string = 'Info'; dType: integer = MB_OK + MB_ICONINFORMATION): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MsgBox; {$ENDIF}{#}

{ 显示打开文件对话框 }
function DlgOpen(var AFileName: string; AInitialDir, AFilter: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgOpen; {$ENDIF}{#}

{ 显示保存文件对话框 }
function DlgSave(var AFileName: string; AInitialDir, AFilter: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgSave; {$ENDIF}{#}

{ 选择目录对话框，很好用的哦 }
function SelectDirectoryEx(var Path: string; const Caption, Root: string; BIFs: DWORD = $59; Callback: TSelectDirectoryProc = nil; const FileName: string = ''): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SelectDirectoryEx; {$ENDIF}{#}

{ 选择计算机对话框 }
function SelectComputer(DialogTitle: string; var CompName: string; bNewStyle: Boolean): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SelectComputer; {$ENDIF}{#}

{ 显示浏览域计算机对话框 }
function BrowserDomainComputer: WideString; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BrowserDomainComputer; {$ENDIF}{#}

{ 显示系统的选择通讯录对话框，并返回选择的联系人列表 }
procedure GetMailAddress(Wab: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetMailAddress; {$ENDIF}{#}

{ 显示系统的打开方式对话框 }
function DlgOpenWith(hwnd: hWnd; param2: Integer; filename: PAnsiChar; param4: Integer): Bool; stdcall;

{ 显示系统的文件属性对话框 }
procedure DlgProperties(const FileName: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgProperties; {$ENDIF}{#}

{ 显示系统的选择图标对话框 }
function DlgSelectIcon(FileName: string; var Index: integer): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgSelectIcon; {$ENDIF}{#}

{ 显示系统的选择颜色对话框 }
function DlgSelectColor(const InitColor: integer): Integer;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DlgSelectColor; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Clipboard/Stream/Drive/File/Path/directory function & procedure
/////////////////////////////////////////////////////////////////////////////

{ 搜索文件是否存在，本函数会搜索当前目录，系统目录，Path目录等，存在返回True }
function SearchFileEx(const Filename: String): Boolean;

{ 文件映射 }
function MappingFile(const FileName: string; const FILE_MAP_MODE: DWORD; const Offset: Int64 = 0; const Size : Int64 = 0): Pointer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MappingFile; {$ENDIF}{#}

{ 返回文件的MIME类型 }
function GetMIMETypeFromFile(const AFile: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetMIMETypeFromFile; {$ENDIF}{#}

{ 根据MIME类型返回对应的默认文件名 }
function GetExtFromMIMEType(const MIMEType: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetExtFromMIMEType; {$ENDIF}{#}

{ 备份文件 }
function BackupFile(const Filename: string; MaxFile : Integer = 5): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BackupFile; {$ENDIF}{#}

function GetLongPathName(lpszShortPath: LPCTSTR; lpszLongPath: LPTSTR; cchBuffer: DWORD): DWORD; stdcall;

{ 返回段文件名 }
function GetShortFileName(const FileName: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetShortFileName; {$ENDIF}{#}

{ 返回长文件名 }
function GetLongFileName(const FileName: string): string;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetLongFileName; {$ENDIF}{#}

{ 更改文件名后缀，支持Windows长文件名，Delphi本身的有BUG }
function ChangeFileExtEx(const FileName: string; const Ext: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ChangeFileExtEx; {$ENDIF}{#}

{ 移动文本文件指针 }
procedure SeekTextFile(var T: TextFile; N: integer); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SeekTextFile; {$ENDIF}{#}

{ 返回文件版本信息 }
function GetFileVersion(const FileName: string; Ident: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetFileVersion; {$ENDIF}{#}

{ 保存剪切板所有内容到文件 }
procedure SaveClipboardToFile(FileName: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SaveClipboardToFile; {$ENDIF}{#}

{ 从文件中读取内容到剪切板，配合SaveClipboardToFile使用 }
procedure LoadClipboardFromFile(FileName: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LoadClipboardFromFile; {$ENDIF}{#}

{ 保存剪切板所有内容到流 }
procedure SaveClipboardToStream(Stream: TStream); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SaveClipboardToStream; {$ENDIF}{#}

{ 从流中读取内容到剪切板，配合SaveClipboardToStream使用 }
procedure LoadClipboardFromStream(Stream: TStream); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LoadClipboardFromStream; {$ENDIF}{#}

{ 返回一个指定目录下指定文件的文件名集合 }
procedure GetFileList(Files: TStrings; Folder, FileSpec: string; SubDir: Boolean = True; CallBack: TFindFileProc = nil); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetFileList; {$ENDIF}{#}

{ 返回目录的大小 }
function GetDirSize(Folder, FileSpec: string; SubDir: Boolean = True): Int64;

{ 返回指定文件的CRC32校验结果 }
function CRC32File(const FileName: string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CRC32File; {$ENDIF}{#}

{ 压缩长文件名为C:\abc\...\Test.doc类似的文件名 }
function PackFileName(const fn: string; const len: integer = 67): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PackFileName; {$ENDIF}{#}

{ 返回指定文件的大小，支持超大文件 }
function FileSizeEx(const FileName: string): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FileSizeEx; {$ENDIF}{#}

{ 在硬盘上面创建文件 }
procedure CreateFileOnDisk(FileName: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CreateFileOnDisk; {$ENDIF}{#}

{ 在硬盘上面创建指定大小的文件 }
function CreateFileOnDiskEx(FileName: string; Size: Int64): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CreateFileOnDiskEx; {$ENDIF}{#}

{ 复制文件，利用Shell函数来做的 }
function CopyFiles(const Dest: string; const Files: TStrings; const UI: Boolean = False): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CopyFiles; {$ENDIF}{#}

{ 复制目录，利用Shell函数来做的 }
function CopyDirectory(const Source, Dest: string; const UI: Boolean = False): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CopyDirectory; {$ENDIF}{#}

{ 移动文件，Shell方式 }
function MoveFiles(DestDir: string; const Files: TStrings; const UI: Boolean = False): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MoveFiles; {$ENDIF}{#}

{ 重命名目录，Shell方式 }
function RenameDirectory(const OldName, NewName: string): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RenameDirectory; {$ENDIF}{#}

{ 删除目录，Shell方式 }
function DeleteDirectory(const DirName: string; const UI: Boolean = False): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DeleteDirectory; {$ENDIF}{#}

{ 清除目录，Shell方式 }
function ClearDirectory(const DirName: string; const IncludeSub, ToRecyle: Boolean): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ClearDirectory; {$ENDIF}{#}

{ 删除文件，Shell方式 }
function DeleteFiles(const Files: TStrings; const ToRecyle: Boolean = True): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DeleteFiles; {$ENDIF}{#}

{ 分割文件 }
function SplitFile(SourceFile: TFileName; SizeofFiles: Integer; OnProgress: TFileSplitProgress = nil; OutDir: string = ''): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SplitFile; {$ENDIF}{#}

{ 合并多个文件为一个文件，配合SpitFile使用 }
function UnSplitFile(FileName, CombinedFileName: TFileName): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UnSplitFile; {$ENDIF}{#}

{ 判断文件是否正在使用 }
function IsFileInUse(const FileName: string): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsFileInUse; {$ENDIF}{#}

{ 判断给定的文件名指定是否是文件 }
function IsFile(const FileSpec: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsFile; {$ENDIF}{#}

{ 判断给定的文件名指定是否是文件 }
function IsDirectory(const FileSpec: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsDirectory; {$ENDIF}{#}

{ 在文件中扫描指定的字符串 }
function ScanFile(const FileName: string; const Sub: string; caseSensitive: Boolean): Longint; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ScanFile; {$ENDIF}{#}

{ 返回一个临时文件名 }
function GetTempFileNameEx(const Path: string = ''; const Prefix3: string = '~~~'; const Create: Boolean = False): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetTempFileNameEx; {$ENDIF}{#}

{ 返回系统临时文件目录 }
function TempPath: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports TempPath; {$ENDIF}{#}

{ 返回系统的系统目录 }
function SystemPath: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SystemPath; {$ENDIF}{#}

{ 返回Windows目录 }
function WindowsPath: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SystemPath; {$ENDIF}{#}

{ 压缩多个文件为一个文件 }
procedure CompressFiles(Files: TStrings; const Filename: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CompressFiles; {$ENDIF}{#}

{ 解压缩多个文件，配合CompressFiles使用 }
procedure DecompressFiles(const Filename, DestDirectory: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DecompressFiles; {$ENDIF}{#}

{ 返回文件的创建/修改/访问时间 }
function GetFileTimeEx(FileName: string; const uFlag: Char = 'm'): TDateTime; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetFileTimeEx; {$ENDIF}{#}

{ 设置文件的创建/修改/访问时间 }
function SetFileTimeEx(const FileName: string; const ATime: TDateTime; TimeType: Char = 'm'): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetFileTimeEx; {$ENDIF}{#}

{ 保存字符串到流中 }
function SaveStringToStream(Stream: TStream; const Str: string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SaveStringToStream; {$ENDIF}{#}

{ 从流中读取字符串，必须配合SaveStringToStream使用 }
function LoadStringFromStream(Stream: TStream): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LoadStringFromStream; {$ENDIF}{#}

function LoadPChar(Stream: TStream): PChar; stdcall;

function SavePChar(Stream: TStream; Data: PChar; Len: Integer): Boolean; stdcall;

{ 写入字符串到流中，并回车换行 }
function SaveStringToStreamLn(Stream: TStream; Msg: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SaveStringToStreamLn; {$ENDIF}{#}

{ 从流中读取一行字符串，可以指定结束符，默认回车换行符 }
function LoadStringFromStreamLn(Stream: TStream; Terminator: string = CrLf): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LoadStringFromStreamLn; {$ENDIF}{#}

{ 保存一段数据到文件中 }
function WriteToFile(Data: PChar; Len: integer; FileName: string; Appended: Boolean): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WriteToFile; {$ENDIF}{#}

{ 保存字符串到文件中 }
function SaveStringToFile(Text: string; FileName: string; Appended: Boolean): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SaveStringToFile; {$ENDIF}{#}

{ 从文件里面读取整个文件数据 }
function ReadFromFile(FileName: string): string; stdcall; overload;

{ 从文件里面读取文件数据，需要自己分配内存！ }
function ReadFromFile(FileName: string; var Buf; Size: Integer; const Pos: Integer = 0): Integer; overload;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ReadFromFile; {$ENDIF}{#}

{ 返回当前应用程序路径 }
function AppPath: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AppPath; {$ENDIF}{#}

{ 返回执行模块文件名 }
function AppFile: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AppFile; {$ENDIF}{#}

{ 返回当前可执行模块对应的指定扩展名的同名文件 }
function AppFileExt(Ext: string = '.ini'): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AppFileExt; {$ENDIF}{#}

{ 删除可执行模块本身 }
procedure DeleteSelf; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DeleteSelf; {$ENDIF}{#}

{ 彻底清除文件 }
function WipeFile(const FileName: string; const WipeCount: integer = 7): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WipeFile; {$ENDIF}{#}

{ 转换Unix文件名为DOS/Windows文件 }
function UnixPathToDosPath(const Path: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UnixPathToDosPath; {$ENDIF}{#}

{ 转换DOS/Windows文件名为Unix文件名 }
function DosPathToUnixPath(const Path: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DosPathToUnixPath; {$ENDIF}{#}

{ 清除指定目录下的所有文件 }
procedure ClearDirFiles(const FileSpec: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ClearDirFiles; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Graph function & procedure
//////////////////////////////////////////////////////////////////////////////

{ 转换字体为字符串和转换字符串为字体，用于保存INI和字体信息 }
function FontToString(TextAttr: TFont): string;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FontToString; {$ENDIF}{#}

procedure StringToFont(Str: string; TextAttr: TFont);
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StringToFont; {$ENDIF}{#}

{ 返回矩形的中心坐标 }
function RectCenter(ARect: TRect): TPoint; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RectCenter; {$ENDIF}{#}

{ 判断指定点是否在一系列点所封闭的区域内 }
function PtInPolygon(p: TPoint; Fence: array of TPoint): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PtInPolygon; {$ENDIF}{#}

{ 根据字体名，创建字体 }
function MakeFont(FontName: string; Size, Bold: integer; StrikeOut, Underline, Italy: Boolean): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MakeFont; {$ENDIF}{#}

{ 设置指定控件的字体 }
procedure SetFont(hWnd: HWND; Font: HFONT); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetFont; {$ENDIF}{#}

{ 返回当前桌面颜色深度，例如24位还是32位 }
function ScreenColors: Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ScreenColors; {$ENDIF}{#}

{ 返回当前屏幕指定的点的颜色 }
function GetScreenPixel(const Pt: TPoint): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetScreenPixel; {$ENDIF}{#}

{ 返回当前鼠标下的点的颜色 }
function ColorUnderMouse: integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ColorUnderMouse; {$ENDIF}{#}

{ 转换TColor为RGB格式 }
function ColorToRGB(Color: Integer): Longint; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ColorToRGB; {$ENDIF}{#}

{ 转换TColor为HTML格式的色彩表示 }
function TColorToHtml(const Color: Integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports TColorToHtml; {$ENDIF}{#}

{ 转换HTML色彩为TColor }
function HtmlToTColor(Color: string): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports HtmlToTColor; {$ENDIF}{#}

function HTMLCodeToChar(s : string): WideString; stdcall;

//////////////////////////////////////////////////////////////////////////////
//       System/Infomation function & procedure
//////////////////////////////////////////////////////////////////////////////


{ 以指定用户身份运行程序 }
function CreateProcessAsUser(const Cmd, User, Password: widestring): Boolean;

{ 解码微软数字产品id }
function DecodeMicrosoftDigitalProductID(const DigitalProductID: PChar; Len : Integer): string;

{ 返回Windows安装序列号 }
function GetWindowsProductID: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetWindowsProductID; {$ENDIF}{#}

function GetOfficeXPProductID: string;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetOfficeXPProductID; {$ENDIF}{#}

{ 检测桌面是否已经锁定 }
function IsWorkstationLocked: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsWorkstationLocked; {$ENDIF}{#}

{ 返回当前系统的CPU的个数 }
function GetCPUCount: integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetCPUCount; {$ENDIF}{#}

{ 返回CPU信息 }
function GetCPUInfo(const Index: Integer = 0): string;

{ 返回CPU厂商 }
function GetCPUVendor : string;

{ 返回当前系统CPU的运行速度，不一定是标称速度 }
function GetCPUSpeed: Double; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetCPUSpeed; {$ENDIF}{#}

function GetCPUCurrentSpeed: string;

{ 返回当前计算机的名字 }
function GetComputerNameEx: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetComputerNameEx; {$ENDIF}{#}

{ 返回当前登录用户名 }
function GetUserName: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetUserName; {$ENDIF}{#}

{ 设置机器的时间 }
function SetMachineTime(LocaleTime: TDateTime): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetMachineTime; {$ENDIF}{#}

{ 返回当前OS的版本字符串，类似： 5.1, 4.90 }
function WinVer: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WinVer; {$ENDIF}{#}

{ 检查Windows版本是否和指定版本一致 }
function CheckWinVer(Major, Minor: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckWinVer; {$ENDIF}{#}

{ 判断当前OS是否是Windows 9x }
function IsWin9x: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsWin9x; {$ENDIF}{#}

{ 判断当前系统是否是Windows 2000 }
function IsWin2K: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsWin2K; {$ENDIF}{#}

{ 判断当前系统是否是Windows XP }
function IsWinXP: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsWinXP; {$ENDIF}{#}

{ 判断当前系统是否是Windows 2003 }
function IsWin2003: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsWin2003; {$ENDIF}{#}

{ 返回当前系统版本描述字符串 }
function GetWinVerString: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetWinVerString; {$ENDIF}{#}

{ 重建系统图标缓存 }
function ReBuildIcon: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ReBuildIcon; {$ENDIF}{#}

{ 创建系统还原点，For WinXP }
function CreateRestorePoint(Memo: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CreateRestorePoint; {$ENDIF}{#}

{ 判断当前用户是否是超级管理员 }
function IsAdministrator: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsAdministrator; {$ENDIF}{#}

{ 获取系统特权列表 }
procedure GetSystemPrivileges(Privileges: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSystemPrivileges; {$ENDIF}{#}

{ 为当前进程打开/禁止某个指定的系统特权 }
function EnablePrivilege(PrivName: string; bEnable: Boolean): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EnablePrivilege; {$ENDIF}{#}

{ 返回系统帐户列表 }
procedure GetAccountList(List: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetAccountList; {$ENDIF}{#}

{ 返回指定字体的可用字体大小列表 }
procedure GetFontSizeList(FontName: string; Sizes: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetFontSizeList; {$ENDIF}{#}

{ 返回当前进程列表 }
procedure GetCurrentApps(Names: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetCurrentApps; {$ENDIF}{#}

{ 关闭系统 }
function ShutDownSystem(const uType, Countdown: integer; Msg: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShutDownSystem; {$ENDIF}{#}

{ 关闭系统 }
function ShutDownSystemEx(const Computer, Msg: string; const Timeout: integer; Force, Reboot: Boolean): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShutDownSystemEx; {$ENDIF}{#}

{ 放弃关机 }
function AbortShutdown(const Computer: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AbortShutdown; {$ENDIF}{#}

{ 返回当前系统内存使用状态 }
function GetSystemMemoryStatus: TMemoryStatus; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSystemMemoryStatus; {$ENDIF}{#}

{ 返回当前系统信息 }
function GetSystemInfoEx: _SYSTEM_INFO; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSystemInfoEx; {$ENDIF}{#}

{ 根据用户名返回用户的SID }
function GetUserNameFromSID(SID: PSID): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetUserNameFromSID; {$ENDIF}{#}

{ 返回系统Idle时间：多久没有鼠标、键盘动作的时间，单位：毫秒 }
function GetIdleTime: DWord; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetIdleTime; {$ENDIF}{#}

{ 返回当前进程的线程数 }
function GetCurrentProcessThreadNum:integer;

{ 返回系统CPU的使用率，百分数 }
function GetCPUUsage(var liOldIdleTime, liOldSystemTime: LARGE_INTEGER): string;

//////////////////////////////////////////////////////////////////////////////
//       Math/alogrith function & Procedure
//////////////////////////////////////////////////////////////////////////////

{ 浮点数转换为经纬度字符串 }
function AngleXToStr(Value: Double; LeadZero: Boolean): string;
function AngleYToStr(Value: Double; LeadZero: Boolean): string;

{ 转换操作符为字符串 }
function OperatorToStr(const Op : Integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports OperatorToStr; {$ENDIF}{#}

{ 转换字符串为Delphi定义的OP常量 }
function StrToOperator(const s : string): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StrToOperator; {$ENDIF}{#}

{ 求 X ^ Y mod Z 的值 }
function PowerMod(Base, Exponent, Modulus: LongWord): LongWord;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PowerMod; {$ENDIF}{#}

{ 根据经纬度返回两点之间的距离 }
function GetSphericDistance(const Lat1Deg, Lon1Deg, Lat2Deg, Lon2Deg: Double; const Radius: Double = 6376736.6684): Double; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSphericDistance; {$ENDIF}{#}

{ 返回两点之间的距离 }
function GetDistance(P1, P2: TPoint): integer; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'GetDistancePoint';{$ENDIF}{$IFDEF _EXPORTS_} exports GetDistance(P1, P2: TPoint) name 'GetDistancePoint'; {$ENDIF}{#}

{ 返回两点之间的距离，(x1,y1)-(x2,y2) }
function GetDistance(X1, Y1, X2, Y2: integer): integer; overload stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'GetDistanceXY';{$ENDIF}{$IFDEF _EXPORTS_} exports GetDistance(X1, Y1, X2, Y2: integer) name 'GetDistanceXY'; {$ENDIF}{#}

{ 返回两点之间距离的平方 }
function GetDistance2(P1, P2: TPoint): integer; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'GetDistance2Point';{$ENDIF}{$IFDEF _EXPORTS_} exports GetDistance2(P1, P2: TPoint) name 'GetDistance2Point'; {$ENDIF}{#}

{ 返回两点之间距离的平方 }
function GetDistance2(X1, Y1, X2, Y2: integer): integer; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'GetDistance2XY';{$ENDIF}{$IFDEF _EXPORTS_} exports GetDistance2(X1, Y1, X2, Y2: integer) name 'GetDistance2XY'; {$ENDIF}{#}

{ 返回最大公因子/最大公约数 }
function GCD(a, b: integer): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GCD; {$ENDIF}{#}

{ 返回最小公倍数 }
function LCM(a, b: integer): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LCM; {$ENDIF}{#}

{ 判断指定值是否则在指定区间 }
function Between(const Value, LowGate, HighGate: integer): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'BetweenInt';{$ENDIF}{$IFDEF _EXPORTS_} exports Between(const Value, LowGate, HighGate: integer) name 'BetweenInt'; {$ENDIF}{#}

{ 判断指定值是否则在指定区间 }
function Between(const Value, LowGate, HighGate: Double): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'BetweenDbl';{$ENDIF}{$IFDEF _EXPORTS_} exports Between(const Value, LowGate, HighGate: Double) name 'BetweenDbl'; {$ENDIF}{#}

{ 判断指定值是否则在指定区间 }
function Between(const Value, LowGate, HighGate: string): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'BetweenStr';{$ENDIF}{$IFDEF _EXPORTS_} exports Between(const Value, LowGate, HighGate: string) name 'BetweenStr'; {$ENDIF}{#}

{ 判断指定值是否则在指定区间 }
function BetweenEx(const V1, V2, LowGate, HighGate: integer): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'BetweenExInt';{$ENDIF}{$IFDEF _EXPORTS_} exports BetweenEx(const V1, V2, LowGate, HighGate: integer) name 'BetweenExInt'; {$ENDIF}{#}

{ 判断指定值是否则在指定区间 }
function BetweenEx(const V1, V2, LowGate, HighGate: Double): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'BetweenExDbl';{$ENDIF}{$IFDEF _EXPORTS_} exports BetweenEx(const V1, V2, LowGate, HighGate: Double) name 'BetweenExDbl'; {$ENDIF}{#}

{ 判断指定值是否则在指定区间 }
function BetweenEx(const V1, V2, LowGate, HighGate: string): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'BetweenExStr';{$ENDIF}{$IFDEF _EXPORTS_} exports BetweenEx(const V1, V2, LowGate, HighGate: string) name 'BetweenExStr'; {$ENDIF}{#}

{ 判断两个区间是否有交集 }
function InterSect(V1, V2, LowG, HighG: Double): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'InterSectDbl';{$ENDIF}{$IFDEF _EXPORTS_} exports InterSect(V1, V2, LowG, HighG: Double) name 'InterSectDbl'; {$ENDIF}{#}

{ 判断两个区间是否有交集 }
function InterSect(V1, V2, LowG, HighG: integer): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports InterSect(V1, V2, LowG, HighG: integer); {$ENDIF}{#}

{ 修正Delphi四舍五入的BUG的Round函数 }
function RoundEx(Value: Extended): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RoundEx; {$ENDIF}{#}

{ 向上四舍五入取整 }
function RoundUp(Value: Extended): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RoundUp; {$ENDIF}{#}

{ 向下四舍五入取整 }
function RoundDown(Value: Extended): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RoundDown; {$ENDIF}{#}

{ 返回整数中的第N个字节 }
function GetByteFromInt(const AInt, AOffset: Integer): Byte;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetByteFromInt; {$ENDIF}{#}

{ 检查指定位是否为1，是，返回True，否则，返回False }
function CheckBit(const Value: DWORD; const BitFrom0: Byte): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckBit; {$ENDIF}{#}

{ 返回Value第N位的值 }
function GetBit(const Value: DWORD; const BitFrom0: Byte): Byte; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetBit; {$ENDIF}{#}

{ 设置指定的位为1，Value：需要设置的值，BitFrom0：需要设定的位，从0开始 }
function BitOn(Value: dword; const BitFrom0: byte): dword; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BitOn; {$ENDIF}{#}

{ 设置指定的位为0，Value：需要设置的值，BitFrom0：需要设置的位，从0开始 }
function BitOff(const Value: dword; const BitFrom0: Byte): dword; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BitOff; {$ENDIF}{#}

{ 交换高低字节 }
function xhl(const b: Byte): Byte; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'xhlByte';{$ENDIF}{$IFDEF _EXPORTS_} exports xhl(const b: Byte) name 'xhlByte'; {$ENDIF}{#}

{ 交换高低字节 }
function xhl(const W: Word): Word; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'xhlWord';{$ENDIF}{$IFDEF _EXPORTS_} exports xhl(const W: Word) name 'xhlWord'; {$ENDIF}{#}

{ 交换高低字节 }
function xhl(const DW: DWord): Dword; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'xhlDWord';{$ENDIF}{$IFDEF _EXPORTS_} exports xhl(const DW: DWord) name 'xhlDWord'; {$ENDIF}{#}

{ 算术（循环）左移 }
function ROL(val: LongWord; shift: Byte): LongWord; assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ROL; {$ENDIF}{#}

{ 算术（循环）右移 }
function ROR(val: LongWord; shift: Byte): LongWord; assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ROR; {$ENDIF}{#}

{ 快速排序一个列表 }
procedure QuickSort(AList: TList; CompareProc: TListSortCompare); overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'QuickSortList';{$ENDIF}{$IFDEF _EXPORTS_} exports QuickSort(AList: TList; CompareProc: TListSortCompare) name 'QuickSortList'; {$ENDIF}{#}

{ 快速排序一个列表 }
procedure QuickSort(AList: array of Pointer; CompareProc: TListSortCompare); overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL name 'QuickSortArray';{$ENDIF}{$IFDEF _EXPORTS_} exports QuickSort(AList: array of Pointer; CompareProc: TListSortCompare) name 'QuickSortArray'; {$ENDIF}{#}

{ 二分法查找 }
function BinSearch(IntArray: array of integer; Value: integer): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BinSearch; {$ENDIF}{#}

{ 给定若干数字和结果，求得到结果的表达式，类似加减乘除求24的算法 }
function SearchExpression(mNumbers: array of Integer; mDest: Integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SearchExpression; {$ENDIF}{#}

{ 字符串表示的数字的加 }
function AddEx(A, B: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AddEx; {$ENDIF}{#}

{ 字符串表示的减 }
function SubEx(A, B: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SubEx; {$ENDIF}{#}

{ 字符串的乘 }
function MultEx(A, B: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MultEx; {$ENDIF}{#}

{ 字符串的除法 }
function DivEx(A, B: string; n: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DivEx; {$ENDIF}{#}

{ 计算给定表达式的结果 }
function Calc(mText: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Calc; {$ENDIF}{#}

{ 求给定序列的所有排列组合 }
function PermutationCombination(mArr: array of string; mStrings: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PermutationCombination; {$ENDIF}{#}

{ 求整数的阶乘 }
function IntPower(Base, Exponent: Integer): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IntPower; {$ENDIF}{#}

{ 十进制整数转换成任意进制 }
function IntToDigit(mNumber: Integer; mScale: Byte; mLength: Integer = 0): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IntToDigit; {$ENDIF}{#}

{ 任意进制转换成十进制整数 }
function DigitToInt(mDigit: string; mScale: Byte): DWORD; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DigitToInt; {$ENDIF}{#}

{ 转换二进制字符串为整数 }
function BinToInt(const Bin: string): DWORD; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BinToInt; {$ENDIF}{#}

{ 转换整数为二进制串 }
function IntToBin(const Int: DWORD): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IntToBin; {$ENDIF}{#}

{ 任意进制转换 }
function BaseConvert(NumIn: string; BaseIn: Byte; BaseOut: Byte): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BaseConvert; {$ENDIF}{#}

{ 返回费波纳切数 }
function Fibonacci(const N: integer): Int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Fibonacci; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Network/Internet function & procedure
//////////////////////////////////////////////////////////////////////////////

{ 判断给定的计算机名/IP是不是本机 }
function IsLocalComputer(const Computer: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsLocalComputer; {$ENDIF}{#}

{ 判断网络是否已经连接 }
function IsConnectNet: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsConnectNet; {$ENDIF}{#}

{ 返回当前局域网内的SQL服务器列表 }
function GetSQLServerList(List: TStrings): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetSQLServerList; {$ENDIF}{#}

{ 返回指定计算机的所有的共享资源列表 }
function GetShareResources(Computer: string; List: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetShareResources; {$ENDIF}{#}

{ 返回指定工作组的所有的计算机列表 }
function GetGroupComputers(GroupName: string; List: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetGroupComputers; {$ENDIF}{#}

{ 返回工作组列表 }
function GetWorkGroupList(List: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetWorkGroupList; {$ENDIF}{#}

{ 返回连接到当前计算机的所有网络连接的远端计算机列表 }
procedure GetNetSessions(ComputerNames: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetNetSessions; {$ENDIF}{#}

{ 判断是否连接上了互联网 }
function InternetConnected: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports InternetConnected; {$ENDIF}{#}

{ ICMP方式的Ping测试 }
function IcmpPing(IpAddr: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IcmpPing; {$ENDIF}{#}

{ 返回网络类型列表 }
function GetNetTypeList(List: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetNetTypeList; {$ENDIF}{#}

{ 发送信息到指定计算机，类似net send命令 }
function NetSend(dest, Source, Msg: string): Longint; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports NetSend; {$ENDIF}{#}

{ 关闭本机的所有网络连接 }
function NetCloseAll: boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports NetCloseAll; {$ENDIF}{#}

{ 建立一个到远程计算机的Session }
function NetConnect(const Computer, User, Password: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports NetConnect; {$ENDIF}{#}

{ 获取域控制器服务器名字 }
function GetPDCName: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetPDCName; {$ENDIF}{#}

{ 返回域名字 }
function GetDomainName: AnsiString; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetDomainName; {$ENDIF}{#}

{ 返回网络适配器个数 }
function AdapterCount: Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AdapterCount; {$ENDIF}{#}

{ 返回指定网卡的MAC地址 }
function GetMacAddress(AdapterNum: Integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetMacAddress; {$ENDIF}{#}

{ 返回本机IP地址 }
function LocalIP: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LocalIP; {$ENDIF}{#}

{ 转换IP为主机名 }
function IPToHost(IPAddr: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IPToHost; {$ENDIF}{#}

{ 转换主机为IP地址 }
function HostToIP(Name: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports HostToIP; {$ENDIF}{#}

{ 判断TCP/IP协议是否已经安装}
function IsIPInstalled: boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsIPInstalled; {$ENDIF}{#}

{ 打开指定URL }
procedure OpenURL(const URL: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports OpenURL; {$ENDIF}{#}

{ 打开指定URL }
procedure OpenExplorer(const FileSpec: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports OpenExplorer; {$ENDIF}{#}

{ 通过MAPI发送电子邮件，支持附件 }
procedure SendMail(Subject, Body, RecvAddress: string; Attachs: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SendMail; {$ENDIF}{#}

{ 改良的URL解码函数，支持%uXXXX方式 }
function URLDecode(psSrc: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports URLDecode; {$ENDIF}{#}

function URLEncode(const psSrc: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports URLEncode; {$ENDIF}{#}

{ HTML编码，把一个字符串变成HTML格式的语法，例如<font>替换为&lt;font&gt }
function HTMLEncode(const Source: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports HTMLEncode; {$ENDIF}{#}

{ HTML解码，把一个HTML字符串转换成原始数据，例如'&lt;font&gt'='<font>' }
function HTMLDecode(const Source: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports HTMLDecode; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Service function & procedure
//////////////////////////////////////////////////////////////////////////////
{ 启动指定服务 }
function ServiceStart(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceStart; {$ENDIF}{#}

{ 停止指定服务 }
function ServiceStop(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceStop; {$ENDIF}{#}

{ 关闭指定服务 }
function ServiceShutdown(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceShutdown; {$ENDIF}{#}

{ 返回指定服务状态 }
function ServiceStatus(const ServiceName: string; const Computer: PChar = nil): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceStatus; {$ENDIF}{#}

{ 返回指定服务状态的文字描述 }
function ServiceStatusDescription(Service_Status: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceStatusDescription; {$ENDIF}{#}

{ 判断指定服务是否正在运行 }
function ServiceRunning(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceRunning; {$ENDIF}{#}

{ 判断指定服务是否处于停止运行状态 }
function ServiceStopped(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceStopped; {$ENDIF}{#}

{ 返回指定服务的显示名字 }
function ServiceDisplayName(const ServiceName: string; const Computer: PChar = nil): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceDisplayName; {$ENDIF}{#}

{ 返回指定服务对应的可执行模块文件名 }
function ServiceFileName(const ServiceName: string; const Computer: PChar = nil): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceFileName; {$ENDIF}{#}

{ 返回指定服务的描述信息 }
function ServiceDescription(const ServiceName: string; const Computer: PChar = nil): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceDescription; {$ENDIF}{#}

{ 返回系统所有的服务名称列表 }
procedure ServiceNames(Names: TStrings; DisplayNames: TStrings = nil; const Service_Type: integer = $30; const Computer: PChar = nil); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceNames; {$ENDIF}{#}

{ 控制系统服务，可以指定代码 }
function ServiceControl(const ServiceName: string; const ControlCode: integer; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceControl; {$ENDIF}{#}

{ 删除系统服务 }
function ServiceDelete(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceDelete; {$ENDIF}{#}

{ 判断系统服务是否存在 }
function ServiceExists(const ServiceName: string; const Computer: PChar = nil): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ServiceExists; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Registry/INI file function & procedure
//////////////////////////////////////////////////////////////////////////////
const
  CSHKeyNames: array[HKEY_CLASSES_ROOT..HKEY_DYN_DATA] of string = (
    'HKEY_CLASSES_ROOT', 'HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE', 'HKEY_USERS',
    'HKEY_PERFORMANCE_DATA', 'HKEY_CURRENT_CONFIG', 'HKEY_DYN_DATA');

  { 转换HKEY为字符串 }
function HKEYToStr(const Key: HKEY): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports HKEYToStr; {$ENDIF}{#}

{ 转换字符串为HKEY }
function StrToHKEY(const KEY: string): HKEY; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StrToHKEY; {$ENDIF}{#}

{ 从完整注册表路径中提取HKEY }
function RegExtractHKEY(const Reg: string): HKEY; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegExtractHKEY; {$ENDIF}{#}

{ 从完整字符串中提取注册表SubKey }
function RegExtractSubKey(const Reg: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegExtractSubKey; {$ENDIF}{#}

{ 导出注册表 }
function RegExportToFile(const RootKey: HKEY; const SubKey, FileName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegExportToFile; {$ENDIF}{#}

{ 导入注册表 }
function RegImportFromFile(const RootKey: HKEY; const SubKey, FileName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegImportFromFile; {$ENDIF}{#}

{ 读取注册表中指定的字符串 }
function RegReadString(const RootKey: HKEY; const SubKey, ValueName: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegReadString; {$ENDIF}{#}

{ 写入字符串到注册表中 }
function RegWriteString(const RootKey: HKEY; const SubKey, ValueName, Value: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegWriteString; {$ENDIF}{#}

{ 读取注册表中指定的字符串 }
function RegReadMultiString(const RootKey: HKEY; const SubKey, ValueName: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegReadMultiString; {$ENDIF}{#}

{ 写入字符串到注册表中 }
function RegWriteMultiString(const RootKey: HKEY; const SubKey, ValueName, Value: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegWriteMultiString; {$ENDIF}{#}

{ 注册表读取整数 }
function RegReadInteger(const RootKey: HKEY; const SubKey, ValueName: string): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegReadInteger; {$ENDIF}{#}

{ 注册表写入整数 }
function RegWriteInteger(const RootKey: HKEY; const SubKey, ValueName: string; const Value: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegWriteInteger; {$ENDIF}{#}

{ 注册表读取二进制数据 }
function RegReadBinary(const RootKey: HKEY; const SubKey, ValueName: string; Data: PChar; out Len: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegReadBinary; {$ENDIF}{#}

{ 注册表写入二进制 }
function RegWriteBinary(const RootKey: HKEY; const SubKey, ValueName: string; Data: PChar; Len: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegWriteBinary; {$ENDIF}{#}

{ 判断注册表是否存在指定值 }
function RegValueExists(const RootKey: HKEY; const SubKey, ValueName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegValueExists; {$ENDIF}{#}

{ 注册表主键是否存在 }
function RegKeyExists(const RootKey: HKEY; const SubKey: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegKeyExists; {$ENDIF}{#}

{ 删除注册表主键 }
function RegKeyDelete(const RootKey: HKEY; const SubKey: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegKeyDelete; {$ENDIF}{#}

{ 删除注册表值 }
function RegValueDelete(const RootKey: HKEY; const SubKey, ValueName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegValueDelete; {$ENDIF}{#}

{ 获取注册表指定主键下所有的键值名列表 }
function RegGetValueNames(const RootKey: HKEY; const SubKey: string; Names: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegGetValueNames; {$ENDIF}{#}

{ 获取注册表中指定主键下所有子主键名列表 }
function RegGetKeyNames(const RootKey: HKEY; const SubKey: string; Names: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegGetKeyNames; {$ENDIF}{#}

{ 读取INI中字符串 }
function IniReadString(const IniFile, Section, ValueName, Default: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IniReadString; {$ENDIF}{#}

{ 写入字符串到INI }
function IniWriteString(const IniFile, Section, ValueName, Value: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IniWriteString; {$ENDIF}{#}

{ 读取INI中二进制数据，数据会被文本化 }
function IniReadBinary(const IniFile, Section, ValueName: string; Data: PChar; Len: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IniReadBinary; {$ENDIF}{#}

{ 写入二进制数据到INI中，数据会被文本化 }
function IniWriteBinary(const IniFile, Section, ValueName: string; Data: PChar; Len: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IniWriteBinary; {$ENDIF}{#}

{ 从INI中读取整数数据 }
function IniReadInteger(const IniFile, Section, ValueName: string; Default: integer): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IniReadInteger; {$ENDIF}{#}

function IniReadBool(const IniFile, Section, ValueName: string; Default: Boolean): Boolean;

{ 写入整数数据到INI中 }
function IniWriteInteger(const IniFile, Section, ValueName: string; Value: integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IniWriteInteger; {$ENDIF}{#}

{ 注册一个文件类型 }
procedure RegisterFileType(AExt, AType, ADescription, AExe, AIcon: string; const AOpt: string = 'Open'); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RegisterFileType; {$ENDIF}{#}

{ 取消注册一个文件类型 }
function UnRegisterFileType(AExt: string; const AOpt: string = 'open'): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UnRegisterFileType; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Console function & procedure
//////////////////////////////////////////////////////////////////////////////

{ 返回命令行指定的参数 }
function GetCommandLineSwitch(Switch: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetCommandLineSwitch; {$ENDIF}{#}

{ 运行DOS命令，并返回其输出结果 }
function ExecAndOutput(const Prog, CommandLine,Dir: String;var ExitCode:DWORD): String; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ExecAndOutput; {$ENDIF}{#}

{ 在控制台中运行DOS命令，不打开新的DOS窗口，就在本控制台窗口中运行 }
function ConRunDosCmd(const Cmd: string; const InterCmd: Boolean = False;
  const WorkDir: string = ''; const Input: THandle = 0;
  const Output: THandle = 0; const TimeOut: DWORD = INFINITE): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ConRunDosCmd; {$ENDIF}{#}

{ 是否在控制台中运行程序，必须在控制台第一行调用，并保存返回值！ }
function IsOnConsole: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsOnConsole; {$ENDIF}{#}

{ 是否允许控制台回显输入字符 }
function EnableEcho(const Enable: Boolean): Cardinal; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EnableEcho; {$ENDIF}{#}

{ 清除控制台屏幕 }
procedure ClearScreen; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ClearScreen; {$ENDIF}{#}

{ 判断是否有键按下 }
function KeyPressed: Char; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports KeyPressed; {$ENDIF}{#}

{ 清除输入缓冲区 }
procedure ClearInputBuffer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ClearInputBuffer; {$ENDIF}{#}

{ 提示“按任意键继续” }
procedure PressAnyKey; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PressAnyKey; {$ENDIF}{#}

{ 移动控制台输入光标位置 }
procedure GotoXY(X, Y: Word); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GotoXY; {$ENDIF}{#}

{ 返回当前光标位置 }
function WhereXY: TCoord; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WhereXY; {$ENDIF}{#}

{ 返回当前光标X坐标 }
function WhereX: SmallInt; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WhereX; {$ENDIF}{#}

{ 返回当前光标Y坐标 }
function WhereY: SmallInt; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WhereY; {$ENDIF}{#}

{ 设置屏幕颜色 }
function SetColor(Color: Word): DWORD; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetColor; {$ENDIF}{#}

{ 读取控制台密码 }
function ReadPassword(const MaskChar: Char = '*'): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ReadPassword; {$ENDIF}{#}

{ 写入控制台屏幕文本并换行，可以指定颜色，颜色参考控制台API的定义 }
procedure WriteEx(const S: string; Color: Word); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WriteEx; {$ENDIF}{#}

{ 写入控制台屏幕文本并换行，可以指定颜色，颜色参考控制台API的定义 }
procedure WriteLnEx(const S: string; Color: Word); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WriteLnEx; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       MultiMedia function & procedure
//////////////////////////////////////////////////////////////////////////////
{ 发送MCI命令 }
function SendMCICommand(Cmd: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SendMCICommand; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Memory manager function & procedure
//////////////////////////////////////////////////////////////////////////////
{ 整理当前进程内存显示 }
procedure DefragProcessMemory; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DefragProcessMemory; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Variant/OLE/Automatic/ActiveX/Com function & procedure
//////////////////////////////////////////////////////////////////////////////

function CreateComObjectFromDll(CLSID: TGUID; DllHandle: THandle): IUnknown; stdcall;

{ 动态根据名字来调用Dispatch的方法，支持动态传递参数 }
function DispatchMethodInvoke(Disp: IDispatch; const MethodName: string; Params: array of const; var VarResult: Variant): Boolean;

{ 转换Variant为可显示字符串 }
function VariantToString(V : Variant): string;

{ 连接/返回指定的对象 }
function GetObject(const ObjectName: string): OleVariant; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetObject; {$ENDIF}{#}

function CheckCOMInstalled(const Name : string): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckCOMInstalled(const Name : string); {$ENDIF}{#}

function CheckCOMInstalled(const CLSID : TGUID): Boolean; overload; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckCOMInstalled(const CLSID: TGUID); {$ENDIF}{#}

{ 设置Office Application对象的是否允许屏幕更新、显示对话框、允许交互（For Word,Excel Only） }
procedure UpdateOfficeUI(OfficeApp: OleVariant; Enabled: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UpdateOfficeUI; {$ENDIF}{#}

{ 替换Word文档中的字符串 }
procedure WordReplaceText(WordDoc: Variant; const Old, New: string; const ReplaceFlags: TReplaceFlags); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WordReplaceText; {$ENDIF}{#}

{ 返回WQL语句的集合对象 }
function WMIQuery(const WQL: string; const Computer: string = ''; const User: string = ''; const Password: string = ''): IEnumVariant; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WMIQuery; {$ENDIF}{#}

{ 返回WMI对象的属性列表 }
function WMIDumpProperties(WQLObj: OleVariant; Properites: TStrings): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WMIDumpProperties; {$ENDIF}{#}

{ 计算表达式，运行脚本语句 }
function RunScript(const Script: string; const Language: string = 'vbscript'): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports RunScript; {$ENDIF}{#}

//////////////////////////////////////////////////////////////////////////////
//       Other function & procedure
//////////////////////////////////////////////////////////////////////////////

{ 输出调试信息到调试器 } 
procedure DebugPrint(const s: string);

{ 输出调试信息到调试器 } 
procedure DebugPrintEx(const s: string; values: array of const);

{ 设置运行时条件断点，仅在调试器中运行！ }
procedure DebugBreak(Condition: Boolean);

{ 检测是否有调试器存在 }
function IsDebuggerPresent: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsDebuggerPresent; {$ENDIF}{#}

{ 返回类的祖先列表 }
function GetClassParentTree(AClass: TObject): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetClassParentTree; {$ENDIF}{#}

{ 检查Value是否在数组中，在，返回True，否则返回False }
function CheckValueInArray(const Value: integer; ValueArray: array of integer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CheckValueInArray; {$ENDIF}{#}

function CheckCardinalInArray(const Value: Cardinal; ValueArray: array of Cardinal): Boolean;

{ 转换数组为 1;2;3;....的形式 }
function ArrayToString(const Values: array of integer; const Seperator: string = ';'): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ArrayToString; {$ENDIF}{#}

{ 连接任意的数据为字符串 }
function ConcatEx(Args: array of const): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ConcatEx; {$ENDIF}{#}

{ 释放并置空一个对象指针 }
procedure FreeAndNilEx(var Obj); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports FreeAndNilEx; {$ENDIF}{#}

{ 清除List列表，并同时清除列表中附加对象 }
procedure ClearList(List: TList); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ClearList; {$ENDIF}{#}

{ 扩展的SetLength，同时会对字符串填充空字符 }
procedure SetLengthEx(var S: string; Len: integer); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetLengthEx; {$ENDIF}{#}

{ 写入系统日志 }
function WriteEventLog(const FromApp, Msg: string; const EventID: DWORD = 0; const EventLog_Type: Word = 4): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WriteEventLog; {$ENDIF}{#}

{ 注册系统日志消息文件 }
function RegisterEventlogSource(const FromApp, ResourceFile: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WriteEventLog; {$ENDIF}{#}

{ 执行一个外部程序并等待他的结束 }
function WinExecAndWait32(FileName: string; Visibility: integer; TimeOut: DWORD): integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports WinExecAndWait32; {$ENDIF}{#}

{ 强制PC喇叭发声的函数，支持Win9x/NT }
function BeepEx(Freq: Word; Delay: DWORD): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BeepEx; {$ENDIF}{#}

{ 延时指定时间，非阻塞方式，可以同时处理消息！ }
procedure Delay(MSecs: Cardinal); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Delay; {$ENDIF}{#}

{ 高精度延时函数，纳秒级 }
function DelayEx(const nSecond: Int64): Boolean;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DelayEx; {$ENDIF}{#}

{ 延时指定的毫秒，不会转让CPU时间，会占用大量CPU }
procedure BusyDelay(MSecs: DWORD); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BusyDelay; {$ENDIF}{#}

{ 更新老的身份证ID为新的18位的ID }
function UpdateIDCardNumber(OldID: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports UpdateIDCardNumber; {$ENDIF}{#}

{ 强行杀死进程 }
function KillTask(const ExeName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports KillTask; {$ENDIF}{#}

{ 判断某个进程是否存在 }
function ProcessExists(exeFileName: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ProcessExists; {$ENDIF}{#}

{ 关闭指定应用程序 }
function CloseApplication(const hWnd: HWND): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CloseApplication; {$ENDIF}{#}

{ 设置系统环境变量 }
function SetGlobalEnvironment(const Name, Value: string; const User: Boolean = True): boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetGlobalEnvironment; {$ENDIF}{#}

{ 环境变量列表 }
procedure GetEnvironmentList(const List: TStrings); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetEnvironmentList; {$ENDIF}{#}

{ 返回系统中当前脱字符位置，像素 }
function GetCaretPosition(var APoint: TPoint): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetCaretPosition; {$ENDIF}{#}

{ 安装屏幕保护程序 }
procedure InstallScreenSaver(const FileName: string); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports InstallScreenSaver; {$ENDIF}{#}

{ 检查SoftIce是否在运行 }
function IsSoftIceRunning: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsSoftIceRunning; {$ENDIF}{#}

{ 对抗调试的函数，原理：检查Parent进程是否为资源管理器或者服务 }
procedure CheckParentProc(const Path: string);

procedure UnAsmCode;

{ 清除IE缓冲数据，包括Cookie和Cache }
procedure ClearIECache; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ClearIECache; {$ENDIF}{#}

{ 返回指定键的Lock状态 }
function GetKeyLock(VK: word): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetKeyLock; {$ENDIF}{#}

{ 切换指定Key的指示灯状态 }
procedure TaggleKeyLock(VKey: Integer); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports TaggleKeyLock; {$ENDIF}{#}

{ 生成语言ID }
function MakeLangID(const Pre, Sub: Byte): word; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MakeLangID; {$ENDIF}{#}

{ 生成本地语言ID }
function MakeLCID(const lgid, srtid: word): dword; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports MakeLCID; {$ENDIF}{#}

{ 设置屏幕分辨率 }
function SetScreenResolution(Width, Height: DWord): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SetScreenResolution; {$ENDIF}{#}

{ 返回最近一次API调用的错误信息字符串 }
function GetLastErrorString: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetLastErrorString; {$ENDIF}{#}

{ 类似C语言中的sscanf函数 }
function sscanf(Data: string; Format: string; const Args: array of const): Integer; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports sscanf; {$ENDIF}{#}

{ 判断一个指针是否是一个类 }
function IsClass(Address: Pointer): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsClass; {$ENDIF}{#}

{ 判断一个指针是否是一个对象实例 }
function IsObject(Address: Pointer): Boolean; assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsObject; {$ENDIF}{#}

//==============================================================================
//  Convert/Code/Decode function/procedure
//==============================================================================
{ 判断数据是否是文本数据 }
function IsText(Data: PChar; Len: Integer): Boolean;

{ 把二进制数据十六进制化 }
function DataToHex(Data: PChar; Len: integer): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DataToHex; {$ENDIF}{#}

{ 把十六进制文本转换成对应的二进制数据，配合DataToHex使用 }
function HexToData(const HexStr: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports HexToData; {$ENDIF}{#}

{ 把Byte个数转换成可以显示的信息：n Bytes | n MBs | n GBs  }
function BytesToString(const i64Size: Int64): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BytesToString; {$ENDIF}{#}

{ 按Base64方式编码一个字符串 }
function Base64Encode(mSource: string; mAddLine: Boolean = True): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Base64Encode; {$ENDIF}{#}

{ 按Base64方式解码一个字符串 }
function Base64Decode(mCode: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Base64Decode; {$ENDIF}{#}

{ 转换Bool变量为字符串： True|False }
function BoolToString(const Value: Boolean): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports BoolToString; {$ENDIF}{#}{ Bool To String(True,False) }

{ 转换字符串为Bool值，支持多个方式！ }
function StringToBool(const Value: string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StringToBool; {$ENDIF}{#}

{ 转换字符串为Bool值，支持多个方式！ }
function StringToBoolDef(const Value: string; const Default: Boolean = False): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StringToBoolDef; {$ENDIF}{#}

{ 解码GSM短消息 }
function GSMDecodeSMS(PDU: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GSMDecodeSMS; {$ENDIF}{#}

{ 转换金额为本地字符串形式，如： ￥150.00 }
function CurrencyToString(Curr: Currency): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CurrencyToString; {$ENDIF}{#}

{ 简体中文转换为繁体中文 }
function Simplified2Traditional(mSimplified: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Simplified2Traditional; {$ENDIF}{#}

{ 繁体中文转换为简体中文 }
function Traditional2Simplified(mTraditional: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports Traditional2Simplified; {$ENDIF}{#}

{ 转换代码页 }
function ConvertCodePage(const Text: WideString; const CodePage_To: UINT): WideString; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ConvertCodePage; {$ENDIF}{#}

{ 转换整数IP地址为字符串IP }
function IPToString(const IP: Cardinal): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IPToString; {$ENDIF}{#}

{ 转换字符串IP地址为整数IP地址 }
function StringToIP(const IP: string): Cardinal; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports StringToIP; {$ENDIF}{#}

//==============================================================================
//  Hardware function/procedure
//==============================================================================
{ 判断指定驱动器是否是光驱 }
function IsCDRom(Drive: char): longbool; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsCDRom; {$ENDIF}{#}

{ 关闭光驱 }
function CloseCD: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CloseCD; {$ENDIF}{#}

{ 弹出光驱 }
function EjectCD: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EjectCD; {$ENDIF}{#}

{ 绝对磁盘读取 }
function DiskRead(iHD, iSector: integer; pData: Pointer; iLen: integer): DWORD; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DiskRead; {$ENDIF}{#}

{ 返回硬盘硬件序列号 }
function GetHDSerialNo: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetHDSerialNo; {$ENDIF}{#}

{ 检查磁盘是否在驱动器中 }
function DiskInDrive(Drive: Char): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DiskInDrive; {$ENDIF}{#}

{ 判断是否是有效的COM }
function IsValidCom(Port: PChar): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports IsValidCom; {$ENDIF}{#}

{ 返回系统所有的逻辑驱动器列表，如acdef }
function LogicalDrives: string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports LogicalDrives; {$ENDIF}{#}

{ 禁止CPU ID 特性 }
procedure DisableCPUID; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DisableCPUID; {$ENDIF}{#}

{ 检查系统是否支持MMX }
function SupportsMMX: Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SupportsMMX; {$ENDIF}{#}

{ 返回自CPU开机之后的CPU运行周期数，超毫秒级精度 }
function GetTickCountEx: int64; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports GetTickCountEx; {$ENDIF}{#}

{ 读取指定端口数据 }
function PortIn(IOport: word): byte; assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PortIn; {$ENDIF}{#}

{ 读取指定端口数据 }
function PortInW(IOport: word): word; assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PortInW; {$ENDIF}{#}

{ 写入数据到指定端口 }
procedure PortOut(IOport: word; Value: byte); assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PortOut; {$ENDIF}{#}

{ 写入数据到指定端口 }
procedure PortOutW(IOport: word; Value: word); assembler; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports PortOutW; {$ENDIF}{#}

{ 返回磁盘序列号 }
function DiskSerialNumber(Drv: string): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports DiskSerialNumber; {$ENDIF}{#}

function GetDiskSize(const Disk: Integer): Int64;

function GetVolumeSize(const Disk: Char): Int64;

//==============================================================================
//  Message/Event function/procedure
//==============================================================================
{ 模拟按键 }
procedure SendKey(key: Word; const shift: TShiftState; specialkey: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SendKey; {$ENDIF}{#}

{ 发送指定按键到指定窗口 }
procedure SendKeyEx(hWindow: HWnd; key: Word; const shift: TShiftState; specialkey: Boolean); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports SendKeyEx; {$ENDIF}{#}

{ 处理本线程的消息，转让控制权 }
procedure ProcessMessages; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ProcessMessages; {$ENDIF}{#}

{ 清空键盘消息队列 }
procedure EmptyKeyQueue; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EmptyKeyQueue; {$ENDIF}{#}

{ 清空鼠标消息队列 }
procedure EmptyMouseQueue; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports EmptyMouseQueue; {$ENDIF}{#}

//==============================================================================
//   VCL/Class/Object functions
//==============================================================================
{ 克隆一个对象的指定属性到另外一个对象 }
function CloneProperties(SourceComp, TargetComp: TObject; Properties: array of string): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CloneProperties; {$ENDIF}{#}

{ 克隆对象 }
function CloneObject(SourceComp, TargetComp: TObject): Boolean; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports CloneObject; {$ENDIF}{#}

//==============================================================================
//       UnDocument API or other APIs
//==============================================================================
function BlockInput(fBlockit: BOOL): BOOL; stdcall;  { Block mouse/keyboard }
function RegisterServiceProcess(ProcessID: Longint; const Hide: LongBool): dword; stdcall;
function DoAddToFavDlg(Handle: THandle; UrlPath: PChar; UrlPathSize: Cardinal; Title: PChar;
  TitleSize: Cardinal; FavIDLIST: pItemIDList): Bool; stdcall;
procedure DoOrganizeFavDlg(h: hwnd; path: pchar); stdcall;

{ 显示添加到收藏夹对话框 }
function AddToFavoriteEx(const URL, Title: string; const Path: string = ''): string; stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports AddToFavoriteEx; {$ENDIF}{#}

function SHEmptyRecycleBin(Wnd: HWND; LPCTSTR: PChar; DWORD: Word): Integer; stdcall;
function SHUpdateRecycleBinIcon(): boolean; stdcall;
function SHFileProperties(handle: hwnd; uflags: dword; name: pchar; str: pchar): dword; stdcall;
function SHFormatDrive(Handle: HWND; Drive, ID, SHFMT_Options: Word): LongInt; stdcall;
function SHInvokePrinterCommand(wnd: HWND; PRINTACTION_Action: UINT; lpBuf1: PChar; lpBuf2: PChar; fModal: BOOL): BOOL; stdcall;

{ 显示运行对话框 }
procedure ShowRunDialog(Dir, Title, Hint: PWideChar; RFF_Flag: integer; const Icon: HICON = 0); stdcall;
{#}{$IFNDEF _DLL_}external DLL;{$ENDIF}{$IFDEF _EXPORTS_} exports ShowRunDialog; {$ENDIF}{#}

{ 读取程序中的资源，以字符串的形式返回 }
function LoadResourceAsString(const ResName, ResType: PChar): string;

//==============================================================================
// SHLWAPI Define
//==============================================================================
function PathAddBackslash(pszPath: LPSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathAddBackslashA';
function PathAddExtension(pszPath: LPSTR; pszExt: LPCSTR): Bool; stdcall; external 'shlwapi.dll' name 'PathAddExtensionA';
function PathAppend(pszPath: LPSTR; pMore: LPCSTR): Bool; stdcall; external 'shlwapi.dll' name 'PathAppendA';
function PathBuildRoot(szRoot: LPSTR; iDrive: integer): LPSTR; stdcall; external 'shlwapi.dll' name 'PathBuildRootA';
function PathCanonicalize(pszBuf: LPSTR; pszPath: LPCSTR): Bool; stdcall; external 'shlwapi.dll' name 'PathCanonicalizeA';
function PathCombine(szDest: LPSTR; lpszDir: LPCSTR; lpszFile: LPCSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathCombineA';
function PathCompactPath(hDC: HDC; lpszPath: Pchar; dx: integer): BOOL; stdcall; external 'shlwapi.dll' name 'PathCompactPathA';
function PathCompactPathEx(pszOut: LPSTR; pszSrc: LPCSTR; cchMax: Uint; dwFlags: DWORD): BOOL; stdcall; external 'shlwapi.dll' name 'PathCompactPathExA';
function PathCommonPrefix(pszFile1: LPCSTR; pszFile2: LPCSTR; achPath: LPSTR): integer; stdcall; external 'shlwapi.dll' name 'PathCommonPrefixA';
function PathFileExists(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathFileExistsA';
function PathFindExtension(pszPath: LPCSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathFindExtensionA';
function PathFindFileName(pszPath: LPCSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathFindFileNameA';
function PathFindNextComponent(pszPath: LPCSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathFindNextComponentA';
function PathGetArgs(pszPath: LPCSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathGetArgsA';
function PathGetCharType(ch: UCHAR): Uint; stdcall; external 'shlwapi.dll' name 'PathGetCharTypeA';
function PathGetDriveNumber(pszPath: LPCSTR): integer; stdcall; external 'shlwapi.dll' name 'PathGetDriveNumberA';
function PathIsDirectory(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsDirectoryA';
function PathIsFileSpec(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsFileSpecA';
function PathIsPrefix(pszPrefix: LPCSTR; pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsPrefixA';
function PathIsRelative(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsRelativeA';
function PathIsRoot(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsRootA';
function PathIsSameRoot(pszPath1: LPCSTR; pszPath2: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsSameRootA';
function PathIsUNC(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsUNCA';
function PathIsUNCServer(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsUNCServerA';
function PathIsUNCServerShare(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsUNCServerShareA';
function PathIsContentType(pszPath: LPCSTR; pszContentType: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsContentTypeA';
function PathIsURL(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsURLA';
function PathMakePretty(pszPath: LPSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathMakePrettyA';
function PathMatchSpec(pszFile: LPCSTR; pszSpec: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathMatchSpecA';
function PathParseIconLocation(pszIconFile: LPSTR): integer; stdcall; external 'shlwapi.dll' name 'PathParseIconLocationA';
procedure PathQuoteSpaces(lpsz: LPSTR); stdcall; external 'shlwapi.dll' name 'PathQuoteSpacesA';
function PathRelativePathTo(pszPath: LPSTR; pszFrom: LPCSTR; dwAttrFrom: DWORD; pszTo: LPCSTR; dwAttrTo: DWORD): BOOL; stdcall; external 'shlwapi.dll' name 'PathRelativePathToA';
procedure PathRemoveArgs(pszPath: LPSTR); stdcall; external 'shlwapi.dll' name 'PathRemoveArgsA';
function PathRemoveBackslash(pszPath: LPSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathRemoveBackslashA';
procedure PathRemoveBlanks(pszPath: LPSTR); stdcall; external 'shlwapi.dll' name 'PathRemoveBlanksA';
procedure PathRemoveExtension(pszPath: LPSTR); stdcall; external 'shlwapi.dll' name 'PathRemoveExtensionA';
function PathRemoveFileSpec(pszPath: LPSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathRemoveFileSpecA';
function PathRenameExtension(pszPath: LPSTR; pszExt: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathRenameExtensionA';
function PathSearchAndQualify(pszPath: LPCSTR; pszBuf: LPSTR; cchBuf: Uint): BOOL; stdcall; external 'shlwapi.dll' name 'PathSearchAndQualifyA';
procedure PathSetDlgItemPath(hDlg: HWND; id: integer; pszPath: LPCSTR); stdcall; external 'shlwapi.dll' name 'PathSetDlgItemPathA';
function PathSkipRoot(pszPath: LPCSTR): LPSTR; stdcall; external 'shlwapi.dll' name 'PathSkipRootA';
procedure PathStripPath(pszPath: LPSTR); stdcall; external 'shlwapi.dll' name 'PathStripPathA';
function PathStripToRoot(pszPath: LPSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathStripToRootA';
procedure PathUnquoteSpaces(lpsz: LPSTR); stdcall; external 'shlwapi.dll' name 'PathUnquoteSpacesA';
function PathMakeSystemFolder(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathMakeSystemFolderA';
function PathUnmakeSystemFolder(pszPath: LPCSTR): BOOL; stdcall; external 'shlwapi.dll' name 'PathUnmakeSystemFolderA';
function PathIsSystemFolder(pszPath: LPCSTR; dwAttrb: DWORD): BOOL; stdcall; external 'shlwapi.dll' name 'PathIsSystemFolderA';
//==============================================================================
//  End SHLWAPI Define
//==============================================================================

implementation

{$IFDEF _DLL_}
uses
  Wininet, ShellAPI, ComObj, Messages, WinSock, TlHelp32, WinSvc,
  CommDlg, CommCtrl, NB30, ZLib, StrUtils, PSAPI, TypInfo, Math, Mapi, WinSpool,
  DateUtils, MMSystem, ClipBrd, Registry, Variants;

var
  ShareData: string; /// 用于临时存储数据的共享变量，主要用于回调函数中！

function NetUserEnum(ServerName: PWideChar; Level, Filter: DWORD; var Buffer: Pointer;
  PrefMaxLen: DWORD; var EntriesRead, TotalEntries, ResumeHandle: DWORD): Longword; stdcall; external 'netapi32.dll';

function NetApiBufferFree(pBuffer: PByte): Longint; stdcall; external 'netapi32.dll';

{#}////////////////////////////////////////////////////////////////////////////
//       String/Text Function & procedure
////////////////////////////////////////////////////////////////////////////{#}

function StrHash(const SoureStr: string): Cardinal;
const
  cLongBits = 32;
  cOneEight = 4;
  cThreeFourths = 24;
  cHighBits = $F0000000;
var
  I: Integer;
  P: PChar;
  Temp: Cardinal;
begin
  Result := 0;
  P := PChar(SoureStr);

  I := Length(SoureStr);
  while I > 0 do
  begin
    Result := (Result shl cOneEight) + Ord(P^);
    Temp := Result and cHighBits;
    if Temp <> 0 then
      Result := (Result xor (Temp shr cThreeFourths)) and (not cHighBits);
    Dec(I);
    Inc(P);
  end;
end;

function Capitalize(const s : string): string;
{
  把单词第一个字母大写
  未检测断词处理
}
var
  pPrev, pCurr: PChar;
begin
  Result := s;
  pCurr := PChar(Result);
  pPrev := ' ';
  while pCurr^ <> '' do
  begin
    if not (pPrev^ in ['_', '0'..'9', 'a'..'z', 'A'..'Z']) then
      pCurr^ := UpCase(pCurr^);
    pPrev := pCurr;
    Inc(pCurr);
  end;
end;

function PascalStringToC(const s: string): string;
{
  把一个字符串变成C格式的字符串，支持转义符
}
var
  pS, pEnd: PChar;
  n: string;
begin
  pS := PChar(S);
  pEnd := pS + Length(s);
  while pS <= pEnd do
  begin
    case pS^ of
      #7: Result := Result + '\a';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #11: Result := Result + '\v';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
      '\', '"', '''':
        begin
          result := result + '\';
          result := result + pS^;
        end;
      '#': /// #000, #$FF,支持两种方式!
        try
          n := Copy(pS, 2, 3);
          if (Length(n) = 3) and (StrToInt(n) in [0..255]) then
          begin
            Result := Result + '\x' + IntToHex(StrToInt(n), 2);
            Inc(pS, 3);
          end
          else
            Result := Result + pS^;
        except
          Result := Result + pS^;
        end;
    else
      Result := Result + pS^;
    end;
    Inc(pS);
  end;
end;

function CStringToPascal(const s: string): string;
var
  pS: PChar;
  n: string;
  pEnd: PChar;
begin
  pS := PChar(S);
  pEnd := pS + Length(s);
  while pS <= pEnd do
    if pS^ = '\' then
    begin
      case (pS + 1)^ of
        #0: Break;
        'a': // \a
          begin
            Inc(pS);
            Result := Result + #7;
          end;
        'b': // \b
          begin
            Inc(pS);
            Result := Result + #8;
          end;
        'f': // \f
          begin
            Inc(pS);
            Result := Result + #12;
          end;
        'n': // \n
          begin
            Inc(pS);
            Result := Result + #10;
          end;
        'r': // \r
          begin
            Inc(pS);
            Result := Result + #13;
          end;
        't': // \t
          begin
            Inc(pS);
            Result := Result + #9;
          end;
        'v': // \v
          begin
            Inc(pS);
            Result := Result + #11;
          end;
        '''': // \'
          begin
            Inc(pS);
            Result := Result + '''';
          end;
        '"': // \"
          begin
            Inc(pS);
            Result := Result + '"';
          end;
        '\': // \\
          begin
            Inc(pS);
            Result := Result + '\';
          end;
        'x': // \xNN, Hex notation
          begin
            n := Copy(pS, 3, 2);
            if (Length(n) = 2) then
            try
              Result := Result + Chr(StrToInt('$' + n));
              Inc(pS, 3);
            except
              Result := Result + '\';
            end
            else
              Result := Result + '\';
          end;
        '0'..'7': // \nnn, octal notation
          begin
            n := Copy(pS, 2, 3);
            if (Length(n) = 3) and (n[2] in ['0'..'7']) and (n[3] in ['0'..'7']) then
            begin
              Result := Result + Chr((Ord(n[1]) - $30) shl 6
                + (Ord(n[2]) - $30) shl 3
                + (Ord(n[3]) - $30));
              Inc(pS, 3);
            end
            else
              Result := Result + '\';
          end;
      else
        Result := Result + pS^;
      end;
      Inc(pS);
    end
    else
    begin
      Result := Result + pS^;
      Inc(pS);
    end;
end;

procedure ShowDataAsHex(Data: PChar; Count: Cardinal; CallBack: TDisplayProc);
{
  ShowDataAsHex用于把给定的数据转换成十六进制的格式显示：
  左边是地址，中间是十六进制，右边是ASCII，类似UltraEdit的十六进制编辑功能
  Data：需要显示的数据
  Count：数据个数
  CallBack：用于处理一行数据的回调过程
}
var
  line: string[84];
  i: Cardinal;
  p: PChar;
  nStr: string[8];
const
  posStart = 1;
  binStart = 11;
  ascStart = 61;
  HexChars: PChar = '0123456789ABCDEF';
begin
  p := Data;
  line := '';
  for i := 0 to Count - 1 do
  begin
    if (i mod 16) = 0 then
    begin
      if Length(line) > 0 then CallBack(line);
      FillChar(line, SizeOf(line), ' ');
      line[0] := Chr(72);
      nStr := Format('%.8X', [i]);
      Move(nStr[1], line[posStart], Length(nStr));
      line[posStart + 8] := ':';
    end;
    if p[i] >= ' ' then
      line[i mod 16 + ascStart] := p[i]
    else
      line[i mod 16 + ascStart] := '.';
    line[binStart + 3 * (i mod 16)] := HexChars[(Ord(p[i]) shr 4) and $F];
    line[binStart + 3 * (i mod 16) + 1] := HexChars[Ord(p[i]) and $F];
  end;
  CallBack(line);
end;

function LoadStringEx(hInstance: HINST; const ID: integer): string;
{
  LoadStringEx用于提供类似LoadString的功能，但是有所扩充，主要是可以传递一些
  ID???，可以返回系统当前语言对应的文字，需要Win2K以上OS支持
}
const
  MAX_LEN = 255;
var
  hUser: HMODULE;
begin
  SetLength(Result, MAX_LEN);
  if hInstance <> 0 then
    LoadString(HInstance, IDOK, PChar(Result), MAX_LEN)
  else
  begin
    hUser := GetModuleHandle('user32.dll');
    case ID of
      IDOK: LoadString(hUser, 800, PChar(Result), MAX_LEN);
      IDCANCEL: LoadString(hUser, 801, PChar(Result), MAX_LEN);
      IDABORT: LoadString(hUser, 802, PChar(Result), MAX_LEN);
      IDRETRY: LoadString(hUser, 803, PChar(Result), MAX_LEN);
      IDIGNORE: LoadString(hUser, 804, PChar(Result), MAX_LEN);
      IDYES: LoadString(hUser, 805, PChar(Result), MAX_LEN);
      IDNO: LoadString(hUser, 806, PChar(Result), MAX_LEN);
      IDCLOSE: LoadString(hUser, 807, PChar(Result), MAX_LEN);
      IDHELP: LoadString(hUser, 808, PChar(Result), MAX_LEN);
      IDTRYAGAIN: LoadString(hUser, 809, PChar(Result), MAX_LEN);
      IDCONTINUE: LoadString(hUser, 810, PChar(Result), MAX_LEN);
    end;
  end;
end;

function GetStringIndex(const Value: string; const Args: array of string): integer;
{
  返回Value在Args中的索引位置，找不到，返回-1
}
begin
  for Result := Low(Args) to High(Args) do
    if SameText(Value, Args[Result]) then Exit;
  Result := -1;
end;

function StrSubCount(const Source, Sub: string): integer;
{
  返回Sub在Source在中出现的次数
}
var
  Buf: PChar;
  i: integer;
  Len: integer;
begin
  Result := 0;
  Buf := PChar(Source);
  i := Pos(Sub, Buf);
  Len := Length(Sub);
  while i <> 0 do
  begin
    Inc(Result);
    Inc(Buf, Len + i - 1);
    i := Pos(Sub, Buf);
  end;
end; { StrSubCount }

function ReverseString(const s: string): string;
{
  反转字符串S并返回反转后的字符串，Delphi6本身有这个函数
}
var
  i, len: Integer;
begin
  len := Length(s);
  SetLength(Result, len);
  for i := len downto 1 do
    Result[len - i + 1] := s[i];
end;

function DeleteChars(var S: string; Chars: TChars): string;
{
  删除S中所有出现的指定的字符，Chars是需要删除的字符集合
}
var
  i: integer;
begin
  for i := Length(S) downto 1 do
    if S[i] in Chars then Delete(S, i, 1);
  Result := S;
end;

function CheckChars(const S: string; const Chars: TChars): Boolean;
{
  检查S中的每一个字符是否在Chars中的集合中
  是：返回True，若有任意一个不在，返回False
}
var
  i: integer;
begin
  Result := False;
  for i := 1 to Length(S) do
    if not (S[i] in Chars) then Exit;
  Result := True;
end;

function CnNumber(Number: Double): string;
{
  转换数值为中文大写，例如123返回壹佰贰拾叁
}
const
  SDaXie: array['0'..'9'] of string = ('零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖');
  SDanWei: array[0..15] of string = ('', '拾', '佰', '仟', '万', '拾', '佰', '仟',
    '亿', '拾', '佰', '仟', '万', '拾', '佰', '仟');
  SOverFlow = '数值太大';
  SNegative = '负';
var
  S: string;
  i, L: integer;
begin
  S := FormatFloat('0', Abs(Number));
  L := Length(S);
  if L > High(SDanWei) - Low(SDanWei) + 1 then raise Exception.Create(SOverFlow);
  for i := L downto 1 do
  begin
    if S[i] <> '0' then // 2,6,10,14
      Result := SDaXie[S[i]] + SDanWei[L - i] + Result
    else if (L - i + 1) in [5, 9, 13, 17] then
      Result := SDanWei[L - i] + Result
    else
      Result := SDaXie['0'] + Result;
  end;
  while Pos(SDaXie['0'] + SDaXie['0'], Result) > 0 do
    Result := stringreplace(Result, SDaXie['0'] + SDaXie['0'], SDaXie['0'], [rfReplaceAll]);
  while pos('零万', Result) > 0 do
    Result := stringreplace(Result, '零万', '万', [rfReplaceAll]); //上万亿后可能两个'零万'
  Result := stringreplace(Result, '零亿', '亿', []);
  Result := stringreplace(Result, '亿万', '亿', []);
  if Copy(Result, Length(Result) - 1, 2) = '零' then Delete(Result, Length(Result) - 1, 2);
  if Number < 0 then Result := SNegative + Result;
end;

function CnPYIndex(const CnString: string): string;
{
  返回中文的拼音首字母
}
const
  ChinaCode: array[0..25, 0..1] of Integer = ((1601, 1636), (1637, 1832), (1833, 2077),
    (2078, 2273), (2274, 2301), (2302, 2432), (2433, 2593), (2594, 2786), (9999, 0000),
    (2787, 3105), (3106, 3211), (3212, 3471), (3472, 3634), (3635, 3722), (3723, 3729),
    (3730, 3857), (3858, 4026), (4027, 4085), (4086, 4389), (4390, 4557), (9999, 0000),
    (9999, 0000), (4558, 4683), (4684, 4924), (4925, 5248), (5249, 5589));
var
  i, j, HzOrd: integer;
begin
  i := 1;
  while i <= Length(CnString) do
  begin
    if (CnString[i] >= #160) and (CnString[i + 1] >= #160) then
    begin
      HzOrd := (Ord(CnString[i]) - 160) * 100 + Ord(CnString[i + 1]) - 160;
      for j := 0 to 25 do
      begin
        if (HzOrd >= ChinaCode[j][0]) and (HzOrd <= ChinaCode[j][1]) then
        begin
          Result := Result + char(byte('A') + j);
          break;
        end;
      end;
      Inc(i);
    end
    else
      Result := Result + CnString[i];
    Inc(i);
  end;
end;

function CnCurrency(Cur: Currency): string;
{
  转换金额Cur为中文大写
}
const
  SDaXie: array[0..9] of string = ('零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖');
  SDanWei: array[0..17] of string = ('分', '角', '圆', '拾', '佰', '仟', '万', '拾', '佰', '仟',
    '亿', '拾', '佰', '仟', '万', '拾', '佰', '仟');
  SOverFlow = '数值太大';
  SNegative = '(负)';
var
  daxie, danwei: string;
  i, j: integer;
  rmb: int64;
begin
  rmb := Abs(Round(Cur * 100));
  if rmb >= 1E18 then raise Exception.Create(SOverFlow);
  i := 0;
  while rmb > 0 do
  begin
    j := rmb mod 10;
    daxie := SDaXie[j];
    danwei := SDanWei[i];
    if j <> 0 then Result := daxie + danwei + Result; //该位上不为0
    if (j = 0) and (not (i in [2, 6, 10, 14])) then //该位为0，是一般位
      Result := daxie + Result;
    if (j = 0) and (i in [2, 6, 10, 14]) then //该位为0，是敏感位
      Result := danwei + Result;
    inc(i);
    rmb := rmb div 10;
  end;
  while Pos('零零', Result) > 0 do
    Result := stringreplace(Result, '零零', '零', [rfReplaceAll]);
  Result := stringreplace(Result, '零圆', '圆', []);
  while pos('零万', Result) > 0 do
    Result := stringreplace(Result, '零万', '万', [rfReplaceAll]); //上万亿后可能两个'零万'
  Result := stringreplace(Result, '零亿', '亿', []);
  Result := stringreplace(Result, '角零', '角整', []);
  if copy(Result, length(Result) - 3, 4) = '圆零' then //最后两位是圆零.
    Result := stringreplace(Result, '圆零', '圆整', []); //小数点后
  Result := stringreplace(Result, '亿万', '亿', []);
  if Cur < 0 then Result := SNegative + Result;
end;

function RightPos(s: string; ch: char; count: integer = 1): integer;
{
  返回Ch在S中从右边开始第Count次出现的位置
}
var
  i, n: integer;
begin
  n := 0;
  for i := length(s) downto 1 do
  begin
    if s[i] = ch then inc(n);
    if n = count then break;
  end;
  result := i;
end;

function PosEx(const Source, Sub: string; Index: Integer = 1): Integer;
{
  PosEx返回Sub在Source第Index次出现的位置，若找不到指定次数的位置，返回0
}
var
  I, J, K, L: Integer;
  T: PChar;
begin
  Result := 0;
  T := PChar(Source);
  K := 0;
  L := Length(Sub);
  for I := 1 to Index do
  begin
    J := Pos(Sub, T);
    if J <= 0 then Exit;
    Inc(T, J + L - 1);
    Inc(K, J + L - 1);
  end;
  Dec(K, L - 1);
  Result := K;
end; { PosEx }

function PosEx2(const substr: AnsiString; const s: AnsiString; const Start: Integer): Integer;
{
  返回SubStr在S中第Start个字符之后出现的位置
}
type
  StrRec = record
    allocSiz: Longint;
    refCnt: Longint;
    length: Longint;
  end;
const
  skew = sizeof(StrRec);
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{       ECX     Pointer to start      //cs      }
{     <-EAX     Position of substr in s or 0    }

        TEST    EAX,EAX
        JE      @@noWork
        TEST    EDX,EDX
        JE      @@stringEmpty
        TEST    ECX,ECX
        JE      @@stringEmpty

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX            { Point ESI to  }
        MOV     EDI,EDX            { Point EDI to  }

        MOV     EBX,ECX
        MOV     ECX,[EDI-skew].StrRec.length
        PUSH    EDI                { remembers position to calculate index }

        CMP     EBX,ECX
        JG      @@fail

        MOV     EDX,[ESI-skew].StrRec.length    { EDX = bstr }

        DEC     EDX                { EDX = Length(substr) -   }
        JS      @@fail             { < 0 ? return             }
        MOV     AL,[ESI]           { AL = first char of       }
        INC     ESI                { Point ESI to 2'nd char of substr }
        SUB     ECX,EDX            { #positions in s to look  }
                                   { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
        DEC     EBX
        SUB     ECX,EBX
        JLE     @@fail
        ADD     EDI,EBX

@@loop:
        REPNE   SCASB
        JNE     @@fail
        MOV     EBX,ECX            { save outer loop                }
        PUSH    ESI                { save outer loop substr pointer }
        PUSH    EDI                { save outer loop s              }

        MOV     ECX,EDX
        REPE    CMPSB
        POP     EDI                { restore outer loop s pointer      }
        POP     ESI                { restore outer loop substr pointer }
        JE      @@found
        MOV     ECX,EBX            { restore outer loop nter    }
        JMP     @@loop

@@fail:
        POP     EDX                { get rid of saved s nter    }
        XOR     EAX,EAX
        JMP     @@exit

@@stringEmpty:
        XOR     EAX,EAX
        JMP     @@noWork

@@found:
        POP     EDX                { restore pointer to first char of s    }
        MOV     EAX,EDI            { EDI points of char after match        }
        SUB     EAX,EDX            { the difference is the correct index   }
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
@@noWork:
end;

function MatchPattern(Source, SubStr: PChar): Boolean;
{
  字符串的模糊匹配，支持通配符*和?
}
begin
  if 0 = StrComp(SubStr, '*') then
    Result := True
  else if (Source^ = Chr(0)) and (SubStr^ <> Chr(0)) then
    Result := False
  else if Source^ = Chr(0) then
    Result := True
  else
  begin
    case SubStr^ of
      '*':
        if MatchPattern(Source, @SubStr[1]) then
          Result := True
        else
          Result := MatchPattern(@Source[1], SubStr);
      '?': Result := MatchPattern(@Source[1], @SubStr[1]);
    else
      if Source^ = SubStr^ then
        Result := MatchPattern(@Source[1], @SubStr[1])
      else
        Result := False;
    end;
  end;
end;

function MatchPatternEx(InpStr, Pattern: PChar): Boolean;
{*****************************************************************}
{* This function implements a subset of regular expression based *}
{* search and is based on the translation of PattenMatch() API   *}
{* of common.c in MSDN Samples\VC98\sdk\sdktools\tlist           *}
{*****************************************************************}
{* MetaChars are  :                                              *}
{*            '*' : Zero or more chars.                          *}
{*            '?' : Any one char.                                *}
{*         [adgj] : Individual chars (inclusion).                *}
{*        [^adgj] : Individual chars (exclusion).                *}
{*          [a-d] : Range (inclusion).                           *}
{*         [^a-d] : Range (exclusion).                           *}
{*       [a-dg-j] : Multiple ranges (inclusion).                 *}
{*      [^a-dg-j] : Multiple ranges (exclusion).                 *}
{*  [ad-fhjnv-xz] : Mix of range & individual chars (inclusion). *}
{* [^ad-fhjnv-xz] : Mix of range & individual chars (exclusion). *}
{*****************************************************************}
begin
  result := true;
  while (True) do
  begin
    case Pattern[0] of
      #0:
        begin
          //End of pattern reached.
          Result := (InpStr[0] = #0); //TRUE if end of InpStr.
          Exit;
        end;

      '*':
        begin //Match zero or more occurances of any char.
          if (Pattern[1] = #0) then
          begin
            //Match any number of trailing chars.
            Result := True;
            Exit;
          end
          else
            Inc(Pattern);

          while (InpStr[0] <> #0) do
          begin
            //Try to match any substring of InpStr.
            if (MatchPattern(InpStr, Pattern)) then
            begin
              Result := True;
              Exit;
            end;

            //Continue testing next char...
            Inc(InpStr);
          end;
        end;

      '?':
        begin //Match any one char.
          if (InpStr[0] = #0) then
          begin
            Result := False;
            Exit;
          end;

          //Continue testing next char...
          Inc(InpStr);
          Inc(Pattern);
        end;

      '[':
        begin //Match given set of chars.
          if (Pattern[1] in [#0, '[', ']']) then
          begin
            //Invalid Set - So no match.
            Result := False;
            Exit;
          end;

          if (Pattern[1] = '^') then
          begin
            //Match for exclusion of given set...
            Inc(Pattern, 2);
            Result := True;
            while (Pattern[0] <> ']') do
            begin
              if (Pattern[1] = '-') then
              begin
                //Match char exclusion range.
                if (InpStr[0] >= Pattern[0]) and (InpStr[0] <= Pattern[2]) then
                begin
                  //Given char failed set exclusion range.
                  Result := False;
                  Break;
                end
                else
                  Inc(Pattern, 3);
              end
              else
              begin
                //Match individual char exclusion.
                if (InpStr[0] = Pattern[0]) then
                begin
                  //Given char failed set element exclusion.
                  Result := False;
                  Break;
                end
                else
                  Inc(Pattern);
              end;
            end;
          end
          else
          begin
            //Match for inclusion of given set...
            Inc(Pattern);
            Result := False;
            while (Pattern[0] <> ']') do
            begin
              if (Pattern[1] = '-') then
              begin
                //Match char inclusion range.
                if (InpStr[0] >= Pattern[0]) and (InpStr[0] <= Pattern[2]) then
                begin
                  //Given char matched set range inclusion.
                  // Continue testing...
                  Result := True;
                  Break;
                end
                else
                  Inc(Pattern, 3);
              end
              else
              begin
                //Match individual char inclusion.
                if (InpStr[0] = Pattern[0]) then
                begin
                  //Given char matched set element inclusion.
                  // Continue testing...
                  Result := True;
                  Break;
                end
                else
                  Inc(Pattern);
              end;
            end;
          end;

          if (Result) then
          begin
            //Match was found. Continue further.
            Inc(InpStr);
            //Position Pattern to char after "]"
            while (Pattern[0] <> ']') and (Pattern[0] <> #0) do
              Inc(Pattern);
            if (Pattern[0] = #0) then
            begin
              //Invalid Pattern - missing "]"
              Result := False;
              Exit;
            end
            else
              Inc(Pattern);
          end
          else
            Exit;
        end;

    else
      begin //Match given single char.
        if (InpStr[0] <> Pattern[0]) then
        begin
          Result := False;
          Break;
        end;

        //Continue testing next char...
        Inc(InpStr);
        Inc(Pattern);
      end;
    end;
  end;
end;

function WordCount(const Text: string): integer;
{
  统计并返回Text的单词个数
}
  function Seps(As_Arg: Char): Boolean;
  begin
    Seps := As_Arg in [#0..#$1F, ' ', '.', ',', '?', ':', ';', '(', ')', '/', '\'];
  end;
var
  Ix: Word;
begin
  Result := 0;
  Ix := 1;
  while Ix <= Length(Text) do
  begin
    while (Ix <= Length(Text)) and (Seps(Text[Ix])) do
      Inc(Ix);
    if Ix <= Length(Text) then
    begin
      Inc(Result);
      while (Ix <= Length(Text)) and (not Seps(Text[Ix])) do
        Inc(Ix);
    end;
  end;
end;

function CnWordCount(Text: string): integer;
{
  返回Text的中文字数
}
var
  wis: WideString;
begin
  wis := WideString(Text);
  Result := Length(Text) - Length(wis);
end;

function GetRandomString(Len: Integer): string;
{
  获取指定长度Len的随机字符串
}
var
  i: integer;
begin
  Randomize;
  SetLength(Result, Len);
  for i := 1 to Len do
    Result[i] := Chr($20 + Random(127 - $20));
end;

function FixFormat(const Width: integer; const Value: Double): string; overload;
{
  格式化Value为指定宽度Width的字符串
}
var
  Len: integer;
begin
  Len := Length(IntToStr(Trunc(Value)));
  Result := Format('%*.*f', [Width, Width - Len, Value]);
end;

function FixFormat(const Width: integer; const Value: integer): string; overload;
{
  格式化Value为指定宽度的字符串，不足的位数，自动补0
}
begin
  Result := Format('%.*d', [Width, Value]);
end;


{-------------------------------------------------------------------------------
  过程名:    SplitStringList
  作者:      黄晟楠
  日期:      2006.12.07
  参数:      const source, ch: string; pList: TStrings
  返回值:    无
  功能：     分隔字符串，ch为分隔符，Source需要分隔的字符串
              将结果添加进pList中。
-------------------------------------------------------------------------------}
procedure SplitStringList(const source, ch: string; pList: TStrings);
var
  pTmp: pchar;
  pCh: PChar;
  p: PChar;
  i,j: integer;
  s: string;
  iChLen: Integer;
begin
  if (Length(Source)= 0) or not Assigned(pList) then
    exit;
  i:= 0;
  iChLen:= Length(ch);
  pTmp := pchar(source+ ch);
  pCh:= PChar(ch);

  p:= StrPos(pTmp,pCh);
  if p<> nil then
  begin
    Inc(p,iChLen);
    i:= p- pTmp;
  end;
  pList.BeginUpdate;
  while i> 0 do
  begin
    j:= i- iChLen;
    SetLength(s,i- iChLen);
    if j> 0 then
    begin
      s:= StrLCopy(PChar(s),pTmp,i- iChLen);
      plist.Add(s);
    end;
    pTmp:= p;
    p:= StrPos(pTmp,pCh);
    if p<> nil then
    begin
      Inc(p,iChLen);
      i:= p- pTmp;
    end
    else if pTmp<> nil then   //保证最后一段字符也能被查找到
      i:= StrLen(pTmp)+ iChLen
    else
      i:=0;
  end;
  pList.EndUpdate;
end;

function SplitString(const source, ch: string): TStringDynArray;
{
  分隔字符串，ch为分隔符，Source需要分隔的字符串
}
var
  temp: pchar;
  i: integer;
begin
  Result := nil;
  if Source = '' then exit;
  temp := pchar(source);
  i := pos(ch, temp);
  while i <> 0 do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := copy(temp, 0, i - 1);
    inc(temp, Length(Ch) + i - 1);
    i := AnsiPos(ch, temp);
  end;
  SetLength(Result, Length(Result) + 1);
  Result[Length(Result) - 1] := Temp;
end;

procedure SplitString(const source, ch: string; Results: TStrings);
{
  分隔字符串，ch为分隔符，Source需要分隔的字符串
}
begin
  Results.CommaText := '"' + StringReplace(source, ch, '","', [rfReplaceAll]) + '"';
end;

function SplitStringEx(const Source, Mask: string; R: TStrings): Boolean;
{
  按掩码分割字符串，例如
   SplitStringEx('Clinton20030412FNewyork','nnnnnnnddddddddsaaaaaaa')返回：
   Clinton
   20030412
   F
   Newyork
}
var
  S: string;
  i: integer;
begin
  Result := False;
  if (Length(Source) < Length(Mask)) or (Mask = '') then Exit;

  S := Source[1];
  for i := 2 to Length(Mask) do
  begin
    if Mask[i] = Mask[i - 1] then
    begin
      S := S + Source[i];
    end
    else
    begin
      R.Add(S);
      S := Source[i];
    end;
  end;
  if S <> '' then R.Add(S);
end;

procedure SplitTextToWords(const S: string; words: Tstrings);
{
  提取字符串S中的所有单词
}
var
  startpos, endpos: Integer;
begin
  Assert(Assigned(words));
  startpos := 1;
  while startpos <= Length(S) do
  begin
    // skip non-letters
    while (startpos <= Length(S)) and not IsCharAlpha(S[startpos]) do
      Inc(startpos);
    if startpos <= Length(S) then
    begin
      // find next non-letter
      endpos := startpos + 1;
      while (endpos <= Length(S)) and IsCharAlpha(S[endpos]) do
        Inc(endpos);
      words.Add(Copy(S, startpos, endpos - startpos));
      startpos := endpos + 1;
    end; { If }
  end; { While }
end; { SplitTextIntoWords }

function AnsiToUnicode(const Ansi: string): string;
{
  把ANSI字符串转换成Unicode编码字符串
}
var
  s: string;
  i: integer;
  j, k: string[2];
  a: array[1..1000] of char;
begin
  s := '';
  StringToWideChar(Ansi, @(a[1]), 500);
  i := 1;
  while ((a[i] <> #0) or (a[i + 1] <> #0)) do
  begin
    j := IntToHex(Integer(a[i]), 2);
    k := IntToHex(Integer(a[i + 1]), 2);
    s := s + k + j;
    i := i + 2;
  end;
  Result := s;
end;

function UnicodeToAnsi(const Unicode: string): string;
{
  把Unicode字符串转换成ANSI编码
}
var
  s: widestring;
  i: integer;
  j, k: string[2];

  function ReadHex(AString: string): integer;
  begin
    Result := StrToInt('$' + AString)
  end;

begin
  i := 1;
  s := '';
  while i < Length(Unicode) + 1 do
  begin
    j := Copy(Unicode, i + 2, 2);
    k := Copy(Unicode, i, 2);
    i := i + 4;
    s := s + Char(ReadHex(j)) + Char(ReadHex(k));
  end;
  if s <> '' then
  begin
    S := S + #0#0#0#0;
    s := WideCharToString(@s[1]);
  end
  else
    s := '';
  Result := s;
end;

function IntToStr2(int: integer): string;
{
  把Int转换成字符串，不使用Format来做，效率高一些
}
begin
  if int = 0 then
    Result := '0'
  else
    while int > 0 do
    begin
      Result := chr($30 + int mod 10) + Result;
      int := int div 10;
    end;
  if int > 0 then Result := chr($30 + int mod 10) + Result;
end; { IntToStr2 }

function StrToInt2(const str: string; out int: integer): Boolean;
{
  把Str转换成整数
}
var
  i: integer;
begin
  Result := False;
  Int := Ord(Str[Length(Str)]) - 30;
  if not (Int in [0..9]) then exit;
  for i := Length(Str) - 1 downto 1 do
    if Str[i] in ['0'..'9'] then
      Int := Int + (Ord(Str[i]) - 30) * 10
    else
      Exit;
  Result := True;
end; { StrToInt2 }

function TranslateChar(const Str: string; FromChar, ToChar: Char): string;
{
  替换Str中的所有的FromChar为ToChar
}
var
  I: Integer;
begin
  Result := Str;
  for I := 1 to Length(Result) do
    if Result[I] = FromChar then
      Result[I] := ToChar;
end; { TranslateChar }

function ExtractString(const Source, sBegin, sEnd: string): string;
{
  返回Source中Flag1和Flag2中的字符串，返回结果包括Flag1，Flag2本身
}
var
  Pos1: integer;
  Pos2: integer;
begin
  Pos1 := Pos(sBegin, Source);
  if Pos1 = 0 then Exit;
  Pos2 := Pos(sEnd, Source);
  if Pos2 = 0 then Exit;
  Result := Copy(Source, Pos1, Pos2 - Pos1 + Length(sEnd));
end;

function ExtractValue(const Source, Name: string; const Serperator: string = '='): string;
{
  返回Source中"="对应的Value的值，例如
  ExtractValue('Command=Login') = 'Login'
}
begin
  if SameText(LeftPart(Source, Serperator), Name) then
    Result := RightPart(Source, Serperator)
  else
    Result := '';
end;

function TrimChar(S: string; Ch: Char): string;
{
  去除字符串S中首尾指定的字符Ch，类似于Trim函数
  S：需要处理的字符串，CH需要去除的字符
  函数返回处理后的字符串
  Ex: TrimChar(',0,5,20,',',')='0,5,20'
}
var
  iStart, iEnd: integer;
begin
  if S = '' then Exit;
  iStart := 1;
  while S[iStart] = Ch do
    Inc(iStart);
  iEnd := Length(S);
  while S[iEnd] = ch do
    Dec(iEnd);
  S := Copy(S, iStart, iEnd - iStart + 1);
  Result := S;
end;

function FastPos(
  const aSourceString, aFindString: string;
  const aSourceLen, aFindLen, StartPos: integer
  ): integer;
var
  SourceLen: integer;
begin
  // Next, we determine how many bytes we need to
  // scan to find the "start" of aFindString.
  SourceLen := aSourceLen;
  SourceLen := SourceLen - aFindLen;
  if (StartPos - 1) > SourceLen then
  begin
    Result := 0;
    Exit;
  end;
  SourceLen := SourceLen - StartPos;
  SourceLen := SourceLen + 2;
  // The ASM starts here.
  asm
    // Delphi uses ESI, EDI, and EBX a lot,
    // so we must preserve them.
    push ESI
    push EDI
    push EBX
    // Get the address of sourceString[1]
    // and Add (StartPos-1).
    // We do this for the purpose of finding
    // the NEXT occurrence, rather than
    // always the first!
    mov EDI, aSourceString
    add EDI, StartPos
    Dec EDI
    // Get the address of aFindString.
    mov ESI, aFindString
    // Note how many bytes we need to
    // look through in aSourceString
    // to find aFindString.
    mov ECX, SourceLen
    // Get the first char of aFindString;
    // note how it is done outside of the
    // main loop, as it never changes!
    Mov  Al, [ESI]
    // Now the FindFirstCharacter loop!
    @ScaSB:
    // Get the value of the current
    // character in aSourceString.
    // This is equal to ah := EDI^, that
    // is what the [] are around [EDI].
    Mov  Ah, [EDI]
    // Compare this character with aDestString[1].
    cmp  Ah,Al
    // If they're not equal we don't
    // compare the strings.
    jne  @NextChar
    // If they're equal, obviously we do!
    @CompareStrings:
    // Put the length of aFindLen in EBX.
    mov  EBX, aFindLen
    // We DEC EBX to point to the end of
    // the string; that is, we don't want to
    // add 1 if aFindString is 1 in length!
    dec  EBX

    // add by ShengQuanhu
    // If EBX is zero, then we've successfully
    // compared each character; i.e. it's A MATCH!
    // It will be happened when aFindLen=1
    Jz @EndOfMatch
    //add end

//Here's another optimization tip. People at this point usually PUSH ESI and
//so on and then POP ESI and so forth at the end-instead, I opted not to chan
//ge ESI and so on at all. This saves lots of pushing and popping!
    @CompareNext:
    // Get aFindString character +
    // aFindStringLength (the last char).
    mov  Al, [ESI+EBX]
    // Get aSourceString character (current
    // position + aFindStringLength).
    mov  Ah, [EDI+EBX]
    // Compare them.
    cmp  Al, Ah
    Jz   @Matches
    // If they don't match, we put the first char
    // of aFindString into Al again to continue
    // looking for the first character.
    Mov  Al, [ESI]
    Jmp  @NextChar
    @Matches:
    // If they match, we DEC EBX (point to
    // previous character to compare).
    Dec  EBX
    // If EBX <> 0 ("J"ump "N"ot "Z"ero), we
    // continue comparing strings.
    Jnz  @CompareNext

    //add by Shengquanhu
    @EndOfMatch:
    //add end

    // If EBX is zero, then we've successfully
    // compared each character; i.e. it's A MATCH!
    // Move the address of the *current*
    // character in EDI.
    // Note, we haven't altered EDI since
    // the first char was found.
    mov  EAX, EDI
    // This is an address, so subtract the
    // address of aSourceString[1] to get
    // an actual character position.
    sub  EAX, aSourceString
    // Inc EAX to make it 1-based,
    // rather than 0-based.
    inc  EAX
    // Put it into result.
    mov  Result, EAX
    // Finish this routine!
    jmp  @TheEnd
    @NextChar:
//This is where I jump to when I want to continue searching for the first char
//acter of aFindString in aSearchString:
    // Point EDI (aFindString[X]) to
    // the next character.
    Inc  EDI
    // Dec ECX tells us that we've checked
    // another character, and that we're
    // fast running out of string to check!
    dec  ECX
    // If EBX <> 0, then continue scanning
    // for the first character.

    //add by shengquanhu
    //if ah is chinese char,jump again
    jz   @Result0
    cmp  ah, $80
    jb   @ScaSB
    Inc  EDI
    Dec  ECX
    //add by shengquanhu end

    jnz  @ScaSB

    //add by shengquanhu
    @Result0:
    //add by shengquanhu end

    // If EBX = 0, then move 0 into RESULT.
    mov  Result,0
    // Restore EBX, EDI, ESI for Delphi
    // to work correctly.
    // Note that they're POPped in the
    // opposite order they were PUSHed.
    @TheEnd:
    pop  EBX
    pop  EDI
    pop  ESI
  end;
end;

//This routine is an identical copy of FastPOS except where commented! The ide
//a is that when grabbing bytes, it ANDs them with $df, effectively making the
//m lowercase before comparing. Maybe this would be quicker if aFindString was
// made lowercase in one fell swoop at the beginning of the function, saving a
//n AND instruction each time.

function FastPosNoCase(
  const aSourceString, aFindString: string;
  const aSourceLen, aFindLen, StartPos: integer
  ): integer;
var
  SourceLen: integer;
begin
  SourceLen := aSourceLen;
  SourceLen := SourceLen - aFindLen;
  if (StartPos - 1) > SourceLen then
  begin
    Result := 0;
    Exit;
  end;
  SourceLen := SourceLen - StartPos;
  SourceLen := SourceLen + 2;
  asm
    push ESI
    push EDI
    push EBX

    mov EDI, aSourceString
    add EDI, StartPos
    Dec EDI
    mov ESI, aFindString
    mov ECX, SourceLen
    Mov  Al, [ESI]

    //add by shengquanhu:just modified the lowercase 'a'..'z'
    cmp Al, $7A
    ja @ScaSB

    cmp Al, $61
    jb @ScaSB
    //end------------------------------------------

    // Make Al uppercase.
    and  Al, $df

    @ScaSB:
    Mov  Ah, [EDI]

    //add by shengquanhu:just modified the lowercase 'a'..'z'
    cmp Ah, $7A
    ja @CompareChar

    cmp Ah, $61
    jb @CompareChar
    //end------------------------------------------

    // Make Ah uppercase.
    and  Ah, $df

    @CompareChar:
    cmp  Ah,Al
    jne  @NextChar
    @CompareStrings:
    mov  EBX, aFindLen
    dec  EBX

    //add by ShengQuanhu
    Jz   @EndOfMatch
    //add end

    @CompareNext:
    mov  Al, [ESI+EBX]
    mov  Ah, [EDI+EBX]

    //add by shengquanhu:just modified the lowercase 'a'..'z'
    cmp Ah, $7A
    ja @LowerAh

    cmp Al, $61
    jb @LowerAh
    //end------------------------------------------

    // Make Al and Ah uppercase.
    and  Al, $df

    //add by shengquanhu:just modified the lowercase 'a'..'z'
    @LowerAh:
    cmp Ah, $7A
    ja @CompareChar2

    cmp Ah, $61
    jb @CompareChar2
    //end------------------------------------------

    and  Ah, $df

    @CompareChar2:
    cmp  Al, Ah
    Jz   @Matches
    Mov  Al, [ESI]

    //add by shengquanhu:just modified the lowercase 'a'..'z'
    cmp Al, $7A
    ja @NextChar

    cmp Al, $61
    jb @NextChar
    //end------------------------------------------

    // Make Al uppercase.
    and  Al, $df
    Jmp  @NextChar
    @Matches:
    Dec  EBX
    Jnz  @CompareNext

    //add by Shengquanhu
    @EndOfMatch:
    //add end

    mov  EAX, EDI
    sub  EAX, aSourceString
    inc  EAX
    mov  Result, EAX
    jmp  @TheEnd
    @NextChar:
    Inc  EDI
    dec  ECX
    //add by shengquanhu
    //if ah is chinese char,jump again
    jz   @Result0
    cmp  ah, $80
    jb   @ScaSB
    Inc  EDI
    Dec  ECX
    //add by shengquanhu end
    jnz  @ScaSB
    @Result0:
    mov  Result,0
    @TheEnd:
    pop  EBX
    pop  EDI
    pop  ESI
  end;
end;

procedure MyMove(const Source; var Dest; Count: Integer);
asm
  // Note: When this function is called,
  // Delphi passes the parameters as follows:
  // ECX = Count
  // EAX = Const Source
  // EDX = Var Dest
  // If there are no bytes to copy, just quit
  // altogether; there's no point pushing registers.
  cmp   ECX,0
  Je    @JustQuit
  // Preserve the critical Delphi registers.
  push  ESI
  push  EDI
  // Move Source into ESI (generally the
  // SOURCE register).
  // Move Dest into EDI (generally the DEST
  // register for string commands).
  // This might not actually be necessary,
  // as I'm not using MOVsb etc.
  // I might be able to just use EAX and EDX;
  // there could be a penalty for not using
  // ESI, EDI, but I doubt it.
  // This is another thing worth trying!
  mov   ESI, EAX
  mov   EDI, EDX
  // The following loop is the same as repNZ
  // MovSB, but oddly quicker!
    @Loop:
  // Get the source byte.
  Mov   AL, [ESI]
  // Point to next byte.
  Inc   ESI
  // Put it into the Dest.
  mov   [EDI], AL
  // Point dest to next position.
  Inc   EDI
  // Dec ECX to note how many we have left to copy.
  Dec   ECX
  // If ECX <> 0, then loop.
  Jnz   @Loop
  // Another optimization note.
  // Many people like to do this.
  // Mov AL, [ESI]
  // Mov [EDI], Al
  // Inc ESI
  // Inc ESI
  //There's a hidden problem here. I won't go into too much detail, but the Pe
  //ntium can continue processing instructions while it's still working out the
  // result of INC ESI or INC EDI. If, however, you use them while they're stil
  //l being calculated, the processor will stop until they're calculated (a pen
  //alty). Therefore, I alter ESI and EDI as far in advance as possible of using
  // them.
  // Pop the critical Delphi registers
  // that we've altered.
  pop   EDI
  pop   ESI
  @JustQuit:
end;

function FastReplace(var aSourceString: string; const aFindString, aReplaceString: string;
  CaseSensitive: Boolean = False): string;
type
  TFastPosProc = function(const aSourceString, aFindString: string;
    const aSourceLen, aFindLen, StartPos: integer): integer;
var
  // Size already passed to SetLength,
  // the REAL size of RESULT.
  ActualResultLen,
    // Position of aFindString is aSourceString.
  CurrentPos,
    // Last position the aFindString was found at.
  LastPos,
    // Bytes to copy (that is, lastpos to this pos).
  BytesToCopy,
    // The "running" result length, not the actual one.
  ResultLen,
    // Length of aFindString, to save
// calling LENGTH repetitively.
  FindLen,
    // Length of aReplaceString, for the same reason.
  ReplaceLen,
    SourceLen: Integer;
  // This is where I explain the
  // TYPE TFastPosProc from earlier!
  FastPosProc: TFastPosProc;
begin
  //As this function has the option of being case-insensitive, I'd need to call
  // either FastPOS or FastPOSNoCase. The problem is that you'd have to do this
  // within a loop. This is a bad idea, since the result never changes throughou
  //t the whole operation-in which case we can determine it in advance, like so
  //:
  if CaseSensitive then
    FastPosProc := FastPOS
  else
    FastPOSProc := FastPOSNoCase;
  // I don't think I actually need
  // this, but I don't really mind!
  Result := '';
  // Get the lengths of the strings.
  FindLen := Length(aFindString);
  ReplaceLen := Length(aReplaceString);
  SourceLen := Length(aSourceString);
  // If we already have room for the replacements,
  // then set the length of the result to
  // the length of the SourceString.
  if ReplaceLen <= FindLen then
    ActualResultLen := SourceLen
  else
    // If not, we need to calculate the
    // worst-case scenario.
    // That is, the Source consists ONLY of
    // aFindString, and we're going to replace
    // every one of them!
    ActualResultLen :=
      SourceLen +
      (SourceLen * ReplaceLen div FindLen) +
      ReplaceLen;
  // Set the length of Result; this
  // will assign the memory, etc.
  SetLength(Result, ActualResultLen);
  CurrentPos := 1;
  ResultLen := 0;
  LastPos := 1;
  //Again, I'm eliminating an IF statement in a loop by repeating code-this ap
  //proach results in very slightly larger code, but if ever you can trade some
  //memory in exchange for speed, go for it!
  if ReplaceLen > 0 then
  begin
    repeat
      // Get the position of the first (or next)
      // aFindString in aSourceString.
      // Note that there's no If CaseSensitive,
      // I just call FastPOSProc, which is pointing
      // to the correct pre-determined routine.
      CurrentPos :=
        FastPosProc(aSourceString, aFindString,
        SourceLen, FindLen, CurrentPos);
      // If 0, then we're finished.
      if CurrentPos = 0 then break;
      // Number of bytes to copy from the
      // source string is CurrentPos - lastPos,
      // i.e. " cat " in "the cat the".
      BytesToCopy := CurrentPos - LastPos;
      // Copy chars from aSourceString
      // to the end of Result.
      MyMove(aSourceString[LastPos],
        Result[ResultLen + 1], BytesToCopy);
      // Copy chars from aReplaceString to
      // the end of Result.
      MyMove(aReplaceString[1],
        Result[ResultLen + 1 + BytesToCopy], ReplaceLen);
      // Remember, using COPY would copy all of
      // the data over and over again.
      // Never fall into this trap (like a certain
      // software company did).
      // Set the running length to
      ResultLen := ResultLen +
        BytesToCopy + ReplaceLen;
      // Set the position in aSourceString to where
      // we want to continue searching from.
      CurrentPos := CurrentPos + FindLen;
      LastPos := CurrentPos;
    until false;
  end
  else
  begin
    // You might have noticed If ReplaceLen > 0.
    // Well, if ReplaceLen = 0, then we're deleting the
    // substrings, rather than replacing them, so we
    // don't need the extra MyMove from aReplaceString.
    repeat
      CurrentPos := FastPos(aSourceString,
        aFindString, SourceLen, FindLen, CurrentPos);
      if CurrentPos = 0 then break;
      BytesToCopy := CurrentPos - LastPos;
      MyMove(aSourceString[LastPos],
        Result[ResultLen + 1], BytesToCopy);
      ResultLen := ResultLen +
        BytesToCopy + ReplaceLen;
      CurrentPos := CurrentPos + FindLen;
      LastPos := CurrentPos;
    until false;
  end;
  //Now that we've finished doing all of the replaces, I just need to adjust th
  //e length of the final result:
  Dec(LastPOS);
  //Now I set the length to the Length plus the bit of string left. That is, " m
  //at" when replacing "the" in "sat on the mat".
  SetLength(Result, ResultLen + (SourceLen - LastPos));
  // If there's a bit of string dangling, then
  // add it to the end of our string.
  if LastPOS + 1 <= SourceLen then
    MyMove(aSourceString[LastPos + 1],
      Result[ResultLen + 1], SourceLen - LastPos);
  aSourceString := Result;
end;

function InString(StartPosition: Cardinal; const Source, Pattern: string): Cardinal;
{
  判断Pattern是否在Source中，从StartPosition后开始查找！返回找到的位置
}
asm
  push esi
  push edi
  push ebx

  test StartPosition,-1
  je @fw
  inc StartPosition
  @fw:

  mov edi,dword ptr  [Source]
  mov esi,dword ptr  [Pattern]

  mov edx,dword ptr [edi-4]
  mov ebx,dword ptr  [esi-4]
  lea edx, [edx+edi] //max source pointer
  lea ebx, [ebx+esi] //max pattern pointer
  dec edx
  dec ebx

  add edi,StartPosition
  dec edi
  mov eax,edi
  add eax,dword ptr  [esi-4]
  dec eax
  cmp eax,edx
  ja @Er

  @1:
  mov esi,dword ptr  [Pattern]
  @2:
  movzx ecx,byte ptr [edi]
  movzx eax,byte ptr [esi]
  or ecx,32
  or eax,32
  sub ecx,eax
  jz @Prov
  @ProvKraj:
  inc edi
  cmp edi,edx
  ja @Er
  jmp @1

  @Prov:
  cmp esi,ebx
  jne @Nije

  sub ebx,dword ptr  [Pattern]
  sub edi,ebx
  sub edi,dword ptr  [Source]
  mov eax,edi
  inc eax
  pop ebx
  pop edi
  pop esi
  pop ebp
  ret 12

  @Nije:
  inc edi
  inc esi
  cmp edi,edx
  jbe @2

  @Er:
  xor eax,eax
  pop ebx
  pop edi
  pop esi
  pop ebp
  ret 12
end;

function InStringReverse(StartPosition: Cardinal; const Source, Pattern: string): Cardinal;
{
  判断Pattern是否在Source中反向比较！，从StartPosition后开始查找！返回找到的位置
}
asm
  push esi
  push edi
  push ebx

  mov edx,dword ptr  [Source] //max source pointer
  mov ebx,dword ptr  [Pattern] //max pattern pointer

  mov edi,dword ptr [edx-4]
  mov esi,dword ptr  [ebx-4]

  test StartPosition,-1
  jne @fw
  mov eax,edi
  sub eax,esi
  inc eax
  mov StartPosition,eax

  @fw:
  lea esi, [ebx+esi]
  dec esi

  mov edi,edx
  add edi,StartPosition
  add edi,dword ptr  [ebx-4]
  lea edi, [edi-2]

  mov ecx,edx
  add ecx,dword ptr [edx-4]
  dec ecx
  cmp edi,ecx
  ja @Er
  ////////////////////////////////

  @1:
  mov esi,dword ptr  [Pattern]
  add esi,dword ptr [esi-4]
  dec esi
  @2:
  movzx ecx,byte ptr [edi]
  movzx eax,byte ptr [esi]
  or ecx,32
  or eax,32
  sub ecx,eax
  jz @Prov
  @ProvKraj:
  dec edi
  cmp edi,edx
  jb @Er
  jmp @1

  @Prov:
  cmp esi,ebx
  jne @Nije

  sub edi,dword ptr  [Source]
  mov eax,edi
  inc eax
  pop ebx
  pop edi
  pop esi
  pop ebp
  ret 12

  @Nije:
  dec edi
  dec esi
  cmp edi,edx
  jae @2

  @Er:
  xor eax,eax
  pop ebx
  pop edi
  pop esi
  pop ebp
  ret 12
end;

function StrSimilar(s1, s2: string): Integer;
{
  比较两个字符串，返回两个字符串的相似程度：返回值 [0-100]
  例：
  'John' and 'John' = 100%
  'John' and 'Jon' = 75%
  'Jim' and 'James' = 40%
  "Luke Skywalker" and 'Darth Vader' = 0%
}
var
  hit: Integer; // Number of identical chars
  p1, p2: Integer; // Position count
  l1, l2: Integer; // Length of strings
  pt: Integer; // for counter
  diff: Integer; // unsharp factor
  hstr: string; // help var for swapping strings
  // Array shows is position is already tested
  test: array[1..255] of Boolean;
begin
  // Test Length and swap, if s1 is smaller
  // we alway search along the longer string
  if Length(s1) < Length(s2) then
  begin
    hstr := s2;
    s2 := s1;
    s1 := hstr;
  end;
  // store length of strings to speed up the function
  l1 := Length(s1);
  l2 := Length(s2);
  p1 := 1;
  p2 := 1;
  hit := 0;
  // calc the unsharp factor depending on the length
  // of the strings.  Its about a third of the length
  diff := Max(l1, l2) div 3 + ABS(l1 - l2);
  // init the test array
  for pt := 1 to l1 do
    test[pt] := False;
  // loop through the string
  repeat
    // position tested?
    if not test[p1] then
    begin
      // found a matching character?
      if (s1[p1] = s2[p2]) and (ABS(p1 - p2) <= diff) then
      begin
        test[p1] := True;
        Inc(hit); // increment the hit count
        // next positions
        Inc(p1);
        Inc(p2);
        if p1 > l1 then p1 := 1;
      end
      else
      begin
        // Set test array
        test[p1] := False;
        Inc(p1);
        // Loop back to next test position if end of the string
        if p1 > l1 then
        begin
          while (p1 > 1) and not (test[p1]) do
            Dec(p1);
          Inc(p2)
        end;
      end;
    end
    else
    begin
      Inc(p1);
      // Loop back to next test position if end of string
      if p1 > l1 then
      begin
        repeat Dec(p1);
        until (p1 = 1) or test[p1];
        Inc(p2);
      end;
    end;
  until p2 > Length(s2);
  // calc procentual value
  Result := 100 * hit div l1;
end;

function ReplaceString(S: string; const Old, New: string): string;
{
  替换S中所有的Old子串为New子串，返回结果为替换后的字符串
  不区分大小写！
}
begin
  Result := FastReplace(S, Old, New, False);
end;

function WidthFullToHalf(Source: string): string;
{
  全角字符串转换成半角字符串
}
var
  Buf: PChar;
begin
  GetMem(Buf, Length(Source));
  LCMapString(GetSystemDefaultLCID, LCMAP_HALFWIDTH, PChar(Source), Length(Source), Buf, Length(Source));
  Result := PChar(Buf);
end;

function WidthHalfToFull(Source: string): string;
{
  半角字符串转换成全角字符串
}
var
  Buf: PChar;
begin
  GetMem(Buf, Length(Source) * 2);
  LCMapString(GetSystemDefaultLCID, LCMAP_FULLWIDTH, PChar(Source), Length(Source), Buf, Length(Source) * 2);
  Result := PChar(Buf);
end;

function LeftPart(Source, Seperator: string): string;
{
  返回字符串中Seperator左边的字符串，例如LeftPart('ab|cd','|')='ab'
  只返回第一个Seperator的左右字符串，若找不到Seperator，则返回整个字符串
}
var
  iPos: integer;
begin
  iPos := Pos(Seperator, Source);
  if iPos > 0 then
    Result := Copy(Source, 1, iPos - 1)
  else
    Result := Source;
end;

function RightPart(Source, Seperator: string): string;
{
  返回字符串中Seperator右边边的字符串，例如RightPart('ab|cd','|')='ab'
  只返回第一个Seperator的右边字符串，若找不到Seperator，则返回整个字符串
}
var
  iPos: integer;
begin
  iPos := Pos(Seperator, Source);
  if iPos > 0 then
    Result := Copy(Source, iPos + Length(Seperator), Length(Source) - iPos)
  else
    Result := Source;
end;

function Part(Source, Seperator: string; Index: integer): string;
{
  按Seperator分割Source，返回第Index部分，例如：Part('ab|cd|ef','|',1)='cd'
}
var
  SS: TStringDynArray;
begin
  SS := SplitString(Source, Seperator);
  if Between(Index, Low(SS), High(SS)) then
    Result := SS[Index]
  else
    Result := '';
end;

function TidyLimit(mLimitText: string; mDelimiter: Char = ','; mLimitLine: string = '-'): string;
{
  整理合并区间文本字符串：TidyLimit('1-2,2-3,5,7,8,12-45') = '1-3,5,7-8,12-45'
}
type
  TLimit = record
    rMin, rMax: Extended;
  end;
  PLimit = ^TLimit;
var
  I, J: Integer;
  T: Integer;
  P: PLimit;
  vLimit: TLimit;
begin
  Result := '';
  if mLimitLine = '' then Exit;
  with TStringList.Create do
  try
    Delimiter := mDelimiter;
    DelimitedText := mLimitText;

    ///////Begin 处理字符串
    for I := 0 to Count - 1 do
    begin
      New(P);
      T := Pos(mLimitLine, Strings[I]);
      if T > 0 then
      begin
        P^.rMin := StrToFloatDef(LeftPart(Strings[I], mLimitLine), 0);
        P^.rMax := StrToFloatDef(RightPart(Strings[I], mLimitLine), 0);
      end
      else
      begin
        P^.rMin := StrToFloatDef(Strings[I], 0);
        P^.rMax := P^.rMin;
      end;
      Objects[I] := TObject(P);
    end;
    ///////End 处理字符串

    ///////Begin 合并区域
    for I := Count - 1 downto 0 do
    begin
      vLimit := PLimit(Objects[I])^;
      for J := I - 1 downto 0 do
      begin
        P := PLimit(Objects[J]);
        if Max(vLimit.rMin, P^.rMin) <= Min(vLimit.rMax, P^.rMax) then
        begin //相交
          P^.rMin := Min(vLimit.rMin, P^.rMin);
          P^.rMax := Max(vLimit.rMax, P^.rMax);
          Dispose(PLimit(Objects[I]));
          Delete(I);
          Break;
        end;
      end;
    end;
    ///////End 合并区域

    ///////Begin 输出字符、释放资源
    for I := 0 to Count - 1 do
    begin
      P := PLimit(Objects[I]);
      if P^.rMin = P^.rMax then
        Result := Format('%s,%s', [Result, FloatToStr(P^.rMin)])
      else
        Result := Format('%s,%s%s%s',
          [Result, FloatToStr(P^.rMin), mLimitLine, FloatToStr(P^.rMax)]);
      Dispose(P);
    end;
    ///////End 输出字符、释放资源
  finally
    Free;
  end;
  Delete(Result, 1, 1);
end; { TidyLimit }

function SortString(mStr: string; mDesc: Boolean = True): string;
{
  排序字符串，返回排序后的字符串
}
var
  I, J: Integer;
  T: Char;
begin
  for I := 1 to Length(mStr) - 1 do
    for J := I + 1 to Length(mStr) do
      if (mDesc and (mStr[I] > mStr[J])) or
        (not mDesc and (mStr[I] < mStr[J])) then
      begin
        T := mStr[I];
        mStr[I] := mStr[J];
        mStr[J] := T;
      end;
  Result := mStr;
end; { StringSort }

function sprintf(const Format: string; Args: array of const): string; stdcall;
{
  类似C语言中sprintf的函数，请参考MSDN中的wvsprintf函数
Support Format:
  %[-][#][0][width][.precision]type
type Value Meaning
  c        Single character. This value is interpreted as type WCHAR if the calling
           application defines Unicode and as type __wchar_t otherwise.
  C        Single character. This value is interpreted as type __wchar_t if the calling
           application defines Unicode and as type WCHAR otherwise.
  d        Signed decimal integer. This value is equivalent to i.
  hc, hC   Single character. The wsprintf function ignores character arguments
           with a numeric value of zero. This value is always interpreted as
           type __wchar_t, even when the calling application defines Unicode.
  hd       Signed short integer argument.
  hs, hS   String. This value is always interpreted as type LPSTR, even when the
           calling application defines Unicode.
  hu       Unsigned short integer.
  i        Signed decimal integer. This value is equivalent to d.
  lc, lC   Single character. The wsprintf function ignores character arguments
           with a numeric value of zero. This value is always interpreted as
           type WCHAR, even when the calling application does not define Unicode.
  ld       Long signed integer. This value is equivalent to li.
  li       Long signed integer. This value is equivalent to ld.
  ls, lS   String. This value is always interpreted as type LPWSTR, even when the
           calling application does not define Unicode. This value is equivalent to ws.
  lu       Long unsigned integer.
  lx, lX   Long unsigned hexadecimal integer in lowercase or uppercase.
  p        Windows 2000/XP: Pointer. The address is printed using hexadecimal.
  s        String. This value is interpreted as type LPWSTR when the calling
           application defines Unicode and as type LPSTR otherwise.
  S        String. This value is interpreted as type LPSTR when the calling
           application defines Unicode and as type LPWSTR otherwise.
  u        Unsigned integer argument.
  x, X     Unsigned hexadecimal integer in lowercase or uppercase.
}
var
  OutPutBuffer: array[0..1023] of char;
  ArgsBuffers: array of PChar;
  i: integer;
begin
  Result := Format;
  if Length(Args) = 0 then Exit;

  SetLength(ArgsBuffers, Length(Args));
  for i := Low(Args) to High(Args) do
  begin
    ArgsBuffers[i] := Args[i].VPointer;
  end;

  ZeroMemory(@OutPutBuffer[0], SizeOf(OutPutBuffer));
  SetString(Result, OutPutBuffer, wvsprintf(OutPutBuffer, PChar(Format), @ArgsBuffers[0]));
end;

function GetHostFromURI(const URI: string): string;
{
  从URI中提取域名或者IP
  例如：
  http://www.abc.com/abc.txt/aaa/?13.net 返回 www.abc.com
  ftp://www.abc.com/down/abc.txt 返回 www.abc.com
}
const
  CSProtocalSep = '://';
var
  B, E : Integer;
begin
  B := Pos(CSProtocalSep,  URI);
  B := IfThen(B = 0, 1, B + Length(CSProtocalSep));
  E := B;
  while (E <= Length(URI)) and (URI[E] <> '/') do Inc(E);
  Result := Copy(URI, B, E - B); 
end;


//////////////////////////////////////////////////////////////////////////////
//       Encrypt/Decrypt function
//////////////////////////////////////////////////////////////////////////////
procedure MD5Init(var MD5Context: TMD5Ctx);
begin
  FillChar(MD5Context, SizeOf(TMD5Ctx), #0);
  with MD5Context do
  begin
    State[0] := Integer($67452301);
    State[1] := Integer($EFCDAB89);
    State[2] := Integer($98BADCFE);
    State[3] := Integer($10325476);
  end;
end;

procedure MD5Transform(var Buf: array of LongInt; const Data: array of LongInt);
var
  A, B, C, D: LongInt;

  procedure Round1(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
  begin
    Inc(W, (Z xor (X and (Y xor Z))) + Data);
    W := (W shl S) or (W shr (32 - S));
    Inc(W, X);
  end;

  procedure Round2(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
  begin
    Inc(W, (Y xor (Z and (X xor Y))) + Data);
    W := (W shl S) or (W shr (32 - S));
    Inc(W, X);
  end;

  procedure Round3(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
  begin
    Inc(W, (X xor Y xor Z) + Data);
    W := (W shl S) or (W shr (32 - S));
    Inc(W, X);
  end;

  procedure Round4(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
  begin
    Inc(W, (Y xor (X or not Z)) + Data);
    W := (W shl S) or (W shr (32 - S));
    Inc(W, X);
  end;
begin
  A := Buf[0];
  B := Buf[1];
  C := Buf[2];
  D := Buf[3];

  Round1(A, B, C, D, Data[0] + Longint($D76AA478), 7);
  Round1(D, A, B, C, Data[1] + Longint($E8C7B756), 12);
  Round1(C, D, A, B, Data[2] + Longint($242070DB), 17);
  Round1(B, C, D, A, Data[3] + Longint($C1BDCEEE), 22);
  Round1(A, B, C, D, Data[4] + Longint($F57C0FAF), 7);
  Round1(D, A, B, C, Data[5] + Longint($4787C62A), 12);
  Round1(C, D, A, B, Data[6] + Longint($A8304613), 17);
  Round1(B, C, D, A, Data[7] + Longint($FD469501), 22);
  Round1(A, B, C, D, Data[8] + Longint($698098D8), 7);
  Round1(D, A, B, C, Data[9] + Longint($8B44F7AF), 12);
  Round1(C, D, A, B, Data[10] + Longint($FFFF5BB1), 17);
  Round1(B, C, D, A, Data[11] + Longint($895CD7BE), 22);
  Round1(A, B, C, D, Data[12] + Longint($6B901122), 7);
  Round1(D, A, B, C, Data[13] + Longint($FD987193), 12);
  Round1(C, D, A, B, Data[14] + Longint($A679438E), 17);
  Round1(B, C, D, A, Data[15] + Longint($49B40821), 22);

  Round2(A, B, C, D, Data[1] + Longint($F61E2562), 5);
  Round2(D, A, B, C, Data[6] + Longint($C040B340), 9);
  Round2(C, D, A, B, Data[11] + Longint($265E5A51), 14);
  Round2(B, C, D, A, Data[0] + Longint($E9B6C7AA), 20);
  Round2(A, B, C, D, Data[5] + Longint($D62F105D), 5);
  Round2(D, A, B, C, Data[10] + Longint($02441453), 9);
  Round2(C, D, A, B, Data[15] + Longint($D8A1E681), 14);
  Round2(B, C, D, A, Data[4] + Longint($E7D3FBC8), 20);
  Round2(A, B, C, D, Data[9] + Longint($21E1CDE6), 5);
  Round2(D, A, B, C, Data[14] + Longint($C33707D6), 9);
  Round2(C, D, A, B, Data[3] + Longint($F4D50D87), 14);
  Round2(B, C, D, A, Data[8] + Longint($455A14ED), 20);
  Round2(A, B, C, D, Data[13] + Longint($A9E3E905), 5);
  Round2(D, A, B, C, Data[2] + Longint($FCEFA3F8), 9);
  Round2(C, D, A, B, Data[7] + Longint($676F02D9), 14);
  Round2(B, C, D, A, Data[12] + Longint($8D2A4C8A), 20);

  Round3(A, B, C, D, Data[5] + Longint($FFFA3942), 4);
  Round3(D, A, B, C, Data[8] + Longint($8771F681), 11);
  Round3(C, D, A, B, Data[11] + Longint($6D9D6122), 16);
  Round3(B, C, D, A, Data[14] + Longint($FDE5380C), 23);
  Round3(A, B, C, D, Data[1] + Longint($A4BEEA44), 4);
  Round3(D, A, B, C, Data[4] + Longint($4BDECFA9), 11);
  Round3(C, D, A, B, Data[7] + Longint($F6BB4B60), 16);
  Round3(B, C, D, A, Data[10] + Longint($BEBFBC70), 23);
  Round3(A, B, C, D, Data[13] + Longint($289B7EC6), 4);
  Round3(D, A, B, C, Data[0] + Longint($EAA127FA), 11);
  Round3(C, D, A, B, Data[3] + Longint($D4EF3085), 16);
  Round3(B, C, D, A, Data[6] + Longint($04881D05), 23);
  Round3(A, B, C, D, Data[9] + Longint($D9D4D039), 4);
  Round3(D, A, B, C, Data[12] + Longint($E6DB99E5), 11);
  Round3(C, D, A, B, Data[15] + Longint($1FA27CF8), 16);
  Round3(B, C, D, A, Data[2] + Longint($C4AC5665), 23);

  Round4(A, B, C, D, Data[0] + Longint($F4292244), 6);
  Round4(D, A, B, C, Data[7] + Longint($432AFF97), 10);
  Round4(C, D, A, B, Data[14] + Longint($AB9423A7), 15);
  Round4(B, C, D, A, Data[5] + Longint($FC93A039), 21);
  Round4(A, B, C, D, Data[12] + Longint($655B59C3), 6);
  Round4(D, A, B, C, Data[3] + Longint($8F0CCC92), 10);
  Round4(C, D, A, B, Data[10] + Longint($FFEFF47D), 15);
  Round4(B, C, D, A, Data[1] + Longint($85845DD1), 21);
  Round4(A, B, C, D, Data[8] + Longint($6FA87E4F), 6);
  Round4(D, A, B, C, Data[15] + Longint($FE2CE6E0), 10);
  Round4(C, D, A, B, Data[6] + Longint($A3014314), 15);
  Round4(B, C, D, A, Data[13] + Longint($4E0811A1), 21);
  Round4(A, B, C, D, Data[4] + Longint($F7537E82), 6);
  Round4(D, A, B, C, Data[11] + Longint($BD3AF235), 10);
  Round4(C, D, A, B, Data[2] + Longint($2AD7D2BB), 15);
  Round4(B, C, D, A, Data[9] + Longint($EB86D391), 21);

  Inc(Buf[0], A);
  Inc(Buf[1], B);
  Inc(Buf[2], C);
  Inc(Buf[3], D);
end;

procedure MD5Update(var MD5Context: TMD5Ctx; const Data: PChar; Len: integer);
var
  Index, t: Integer;
begin
  //Len := Length(Data);
  with MD5Context do
  begin
    T := Count[0];
    Inc(Count[0], Len shl 3);
    if Count[0] < T then
      Inc(Count[1]);
    Inc(Count[1], Len shr 29);
    T := (T shr 3) and $3F;
    Index := 0;
    if T <> 0 then
    begin
      Index := T;
      T := 64 - T;
      if Len < T then
      begin
        Move(Data, Bufchar[Index], Len);
        Exit;
      end;
      Move(Data, Bufchar[Index], T);
      MD5Transform(State, Buflong);
      Dec(Len, T);
      Index := T;
    end;
    while Len > 64 do
    begin
      Move(Data[Index], Bufchar, 64);
      MD5Transform(State, Buflong);
      Inc(Index, 64);
      Dec(Len, 64);
    end;
    Move(Data[Index], Bufchar, Len);
  end
end;

function MD5Final(var MD5Context: TMD5Ctx): string;
var
  Cnt: Word;
  P: Byte;
  D: array[0..15] of Char;
  i: Integer;
begin
  for I := 0 to 15 do
    Byte(D[I]) := I + 1;
  with MD5Context do
  begin
    Cnt := (Count[0] shr 3) and $3F;
    P := Cnt;
    BufChar[P] := $80;
    Inc(P);
    Cnt := 64 - 1 - Cnt;
    if Cnt > 0 then
      if Cnt < 8 then
      begin
        FillChar(BufChar[P], Cnt, #0);
        MD5Transform(State, BufLong);
        FillChar(BufChar, 56, #0);
      end
      else
        FillChar(BufChar[P], Cnt - 8, #0);
    BufLong[14] := Count[0];
    BufLong[15] := Count[1];
    MD5Transform(State, BufLong);
    Move(State, D, 16);
    Result := '';
    for i := 0 to 15 do
      Result := Result + Char(D[i]);
  end;
  FillChar(MD5Context, SizeOf(TMD5Ctx), #0)
end;

function MD5Print(D: string): string;
var
  I: byte;
const
  Digits: array[0..15] of char =
  ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
begin
  Result := '';
  for I := 0 to 15 do
    Result := Result + Digits[(Ord(D[I + 1]) shr 4) and $0F] + Digits[Ord(D[I + 1]) and $0F];
end;

function MD5Match(const S, MD5Value: string): Boolean;
begin
  Result := SameText(MD5String(S), MD5Value);
end;

function MD5String(const Value: string): string;
{
  把Value进行计算MD5散列值
}
var
  MD5Context: TMD5Ctx;
begin
  MD5Init(MD5Context);
  MD5Update(MD5Context, PChar(Value), Length(Value));
  Result := MD5Print(MD5Final(MD5Context));
end;

function MD5File(FileName: string): string;
{
  求文件的MD5散列值
}
var
  FileHandle: THandle;
  MapHandle: THandle;
  ViewPointer: pointer;
  Context: TMD5Ctx;
begin
  MD5Init(Context);
  FileHandle := CreateFile(pChar(FileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
  try
    MapHandle := CreateFileMapping(FileHandle, nil, PAGE_READONLY, 0, 0, nil);
    if MapHandle <> 0 then
    try
      ViewPointer := MapViewOfFile(MapHandle, FILE_MAP_READ, 0, 0, 0);
      if ViewPointer <> nil then
      try
        MD5Update(Context, ViewPointer, GetFileSize(FileHandle, nil));
      finally
        UnmapViewOfFile(ViewPointer);
      end;
    finally
      CloseHandle(MapHandle);
    end;
  finally
    CloseHandle(FileHandle);
  end;
  Result := MD5Print(MD5Final(Context));
end;

const
  SeedA = $00002090; /// 常量，你可以修改
  SeedB = $20900000; /// 常量，你可以修改

function EncryptData(Data: PChar; Len: integer; Key: DWORD): string;
{
  简单的数据加密，配合DecryptData使用
}
var
  i: integer;
  ps, pr: PByte;
begin
  SetLength(Result, Len);
  ps := PByte(Data);
  pr := PByte(PChar(Result));
  for i := 1 to Len do
  begin
    pr^ := ps^ xor (Key shr 8);
    Key := (pr^ + Key) * SeedA + SeedB;
    Inc(pr);
    Inc(ps);
  end
end;

function DecryptData(Data: PChar; Len: integer; Key: DWORD): string;
{
  简单字符串解密，配合EncryptData使用
}
var
  i: integer;
  ps, pr: PByte;
begin
  SetLength(Result, Len);
  ps := PByte(Data);
  pr := PByte(PChar(Result));
  for i := 1 to Len do
  begin
    pr^ := ps^ xor (Key shr 8);
    Key := (ps^ + Key) * SeedA + SeedB;
    Inc(pr);
    Inc(ps);
  end
end;

function EncryptString(Data: string; Key: DWORD): string;
{
  简单的数据加密，配合DecryptData使用
}
begin
  Result := EncryptData(PChar(Data), Length(Data), Key);
end;

function DecryptString(Data: string; Key: DWORD): string;
{
  简单的数据解密，配合EncryptData使用
}
begin
  Result := DecryptData(PChar(Data), Length(Data), Key);
end;

//////////////////////////////////////////////////////////////////////////////
//       Check & Valid function
//////////////////////////////////////////////////////////////////////////////

function IsANSI(const Ch: char): Boolean;
begin
  Result := not (Ch in [#0..#9, #11..#12, #14..#31]); 
end;

function IsReversString(const S: string): Boolean;
{
  检查是否是回文字符串
}
var
  i, L: integer;
begin
  Result := False;
  L := Length(S);
  for i := 1 to L div 2 do
    if S[i] <> S[L - i + 1] then Exit;
  Result := True;
end;

function IsEmptyStr(const Str: string): Boolean;
begin
  Result := Trim(Str) = '';
end;

function IsUpper(const Ch: Char): Boolean;
{
  判断Ch是否是大写字母
}
begin
  Result := ch in ['A'..'Z'];
end;

function IsLower(const Ch: Char): Boolean;
{
 判断Ch是否是小写字母
}
begin
  Result := ch in ['a'..'z'];
end;

function IsAlpha(const Ch: Char): Boolean;
{
 判断Ch是否是英文字母
}
begin
  Result := islower(ch) or isupper(ch);
end;

function IsAlNum(ch: Char): Boolean;
{
  判断Ch是否是字母或者数字字符
}
begin
  Result := isalpha(ch) or isdigit(ch);
end;

function IsPunct(ch: Char): Boolean;
{
  判断是否是标点字符
}
begin
  Result := isprint(ch) and (not (isspace(ch) or isalnum(ch)));
end;

function IsDigit(const Ch: Char): Boolean;
{
  判断Ch是否是数字
}
begin
  Result := ch in ['0'..'9'];
end;

function IsControl(const Ch: Char): Boolean;
{
  判断Ch是否是控制字符
}
begin
  Result := ch in [#$00..#$1F, #$7F];
end;

function IsGraph(const Ch: Char): Boolean;
{
  判断Ch是否是图形字符
}
begin
  Result := ch in [#$21..#$7E];
end;

function IsPrint(const Ch: Char): Boolean;
{
  判断Ch是否是可打印字符
}
begin
  Result := ch in [#$20..#$7E];
end;

function IsSpace(const Ch: Char): Boolean;
{
  判断Ch是否是空白字符
}
begin
  Result := Ch in [#32, #8, #13, #10];
end;

function IsXDigit(const Ch: Char): Boolean;
{
  判断Ch是否是十六进制数字字符
}
begin
  Result := ch in ['0'..'9', 'a'..'f', 'A'..'F'];
end;

function IsInteger(const S: string): Boolean;
{
  判断字符串S是否是一个合法的整数，是，返回True，否则返回False
}
begin
  try
    StrToInt(S);
    Result := True;
  except
    Result := False;
  end;
end;

function IsFloat(const S: string): Boolean;
{
  判断字符串S是否是一个合法的浮点数，是，返回True，否则返回False
}
begin
  try
    StrToFloat(S);
    Result := True;
  except
    Result := False;
  end;
end;

function CRC32(Buffer: PChar; Len: integer): DWORD;
{
  对数据进行CRC32校验，Buffer为需要校验的数据，Len表明数据的长度，返回值为CRC32值
}
const
  Table: array[0..255] of DWORD =
  ($00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);
var
  i: Word;
begin
  Result := $FFFFFFFF;
  for i := 0 to Len - 1 do
    Result := (Result shr 8) xor Table[Byte(Buffer[i]) xor (Result and $000000FF)];
  Result := not Result;
end;

function IsValidCreditCard(c: string): Integer;
{-------------------------------------------------
  判断一个Credit Card是否有效
  Returns:
   0  : Card is invalid or unknown
   1  : Card is a valid AmEx
   2  : Card is a valid Visa
   3  : Card is a valid MasterCard
 -------------------------------------------------}
var
  card: string[21];
  Vcard: array[0..21] of Byte absolute card;
  Xcard: Integer;
  Cstr: string[21];
  y, x: Integer;
begin
  Cstr := '';
  FillChar(Vcard, 22, #0);
  card := c;
  for x := 1 to 20 do
    if (Vcard[x] in [48..57]) then
      Cstr := Cstr + chr(Vcard[x]);
  card := '';
  card := Cstr;
  Xcard := 0;
  if not odd(Length(card)) then
    for x := (Length(card) - 1) downto 1 do
    begin
      if odd(x) then
        y := ((Vcard[x] - 48) * 2)
      else
        y := (Vcard[x] - 48);
      if (y >= 10) then
        y := ((y - 10) + 1);
      Xcard := (Xcard + y)
    end
  else
    for x := (Length(card) - 1) downto 1 do
    begin
      if odd(x) then
        y := (Vcard[x] - 48)
      else
        y := ((Vcard[x] - 48) * 2);
      if (y >= 10) then
        y := ((y - 10) + 1);
      Xcard := (Xcard + y)
    end;
  x := (10 - (Xcard mod 10));
  if (x = 10) then
    x := 0;
  if (x = (Vcard[Length(card)] - 48)) then
    Result := Ord(Cstr[1]) - Ord('2')
  else
    Result := 0
end;

function IsISBN(ISBN: string): Boolean;
{
  判断ISBN是否是合法的ISBN号码
}
var
  Number, CheckDigit: string;
  CheckValue, CheckSum, Err: Integer;
  i, Cnt: Word;
begin
  {取得检验数字}
  CheckDigit := Copy(ISBN, Length(ISBN), 1);
  {Get rest of ISBN, minus check digit and its hyphen}
  Number := Copy(ISBN, 1, Length(ISBN) - 2);

  {ISBN长度必须为11，并且组成数字必须介于9和9或X}
  if (Length(Number) = 11) and (Pos(CheckDigit, '0123456789X') > 0) then
  begin
    {Get numeric value for check digit}
    if (CheckDigit = 'X') then
      CheckSum := 10
    else
      Val(CheckDigit, CheckSum, Err);
    {Iterate through ISBN remainder, applying decode algorithm}
    Cnt := 1;

    for i := 1 to 12 do
    begin
      {如果当前字符介于0~9，则不包含连字符}
      if (Pos(Number[i], '0123456789') > 0) then
      begin
        Val(Number[i], CheckValue, Err);
        {Algorithm for each character in ISBN remainder, Cnt is the nth
        character so processed}
        CheckSum := CheckSum + CheckValue * (11 - Cnt);
        Inc(Cnt);
      end;
    end;

    {校验最后的值能否被11整除}
    if (CheckSum mod 11 = 0) then
      IsISBN := True
    else
      IsISBN := False;
  end
  else
    IsISBN := False;
end;

function IsValidIP(const IP: string): Boolean;
{
  判断字符串IP是否是一个合法的IP地址（不验证是否可以访问得到）
  是，返回True，否则返回False
}
var
  Ar: TStringDynArray;
  i: integer;
begin
  Result := False;
  Ar := SplitString(IP, '.');
  if Length(Ar) <> 4 then Exit;
  for i := Low(Ar) to High(Ar) do
  try
    if not (StrToInt(Ar[i]) in [0..255]) then Exit;
  except
    Exit;
  end;
  Result := True;
end;

function IsValidEmail(const Value: string): Boolean;
{
  判断字符串Value是否是一个合法的Email地址，是，返回True，否则返回False
}

  function CheckAllowed(const s: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Length(s) do
      if not (s[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.']) then Exit;
    Result := True;
  end;

var
  i: Integer;
  NamePart, ServerPart: string;
begin
  Result := False;
  i := Pos('@', Value);
  if i = 0 then Exit;
  NamePart := Copy(Value, 1, i - 1);
  ServerPart := Copy(Value, i + 1, Length(Value));
  if (Length(NamePart) = 0) or ((Length(ServerPart) < 5)) then Exit;
  i := Pos('.', ServerPart);
  if (i = 0) or (i > (Length(serverPart) - 2)) then Exit;
  Result := CheckAllowed(NamePart) and CheckAllowed(ServerPart);
end;

function IsValidFileName(FileName: string): Boolean;
{
  判断FileName是否是合法的文件名，是，返回True,否则，返回False;
}
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(FileName) do
    if FileName[i] in ['<', '>', '?', '/', '\', ':', '*', '|', '"'] then
    begin
      Result := False;
      Exit;
    end;
end;

function IsRemoteSession: Boolean;
{
  检测是否在远程桌面下运行~~~~~~
}
const
  sm_RemoteSession = $1000; { from WinUser.h }
begin
  Result := GetSystemMetrics(sm_RemoteSession) <> 0;
end;

//////////////////////////////////////////////////////////////////////////////
//       Printer function & Procedure
//////////////////////////////////////////////////////////////////////////////

procedure SavePrinterInfo(APrinterName: PChar; ADestStream: TStream);
var
  HPrinter: THandle;
  InfoSize,
    BytesNeeded: Cardinal;
  PI2: PPrinterInfo2;
  PrinterDefaults: TPrinterDefaults;
begin
  with PrinterDefaults do
  begin
    DesiredAccess := PRINTER_ACCESS_USE;
    pDatatype := nil;
    pDevMode := nil;
  end;
  if OpenPrinter(APrinterName, HPrinter, @PrinterDefaults) then
  try
    SetLastError(0);
    //Determine the number of bytes to allocate for the PRINTER_INFO_2 construct...
    if not GetPrinter(HPrinter, 2, nil, 0, @BytesNeeded) then
    begin
      //Allocate memory space for the PRINTER_INFO_2 pointer (PrinterInfo2)...
      PI2 := AllocMem(BytesNeeded);
      try
        InfoSize := SizeOf(TPrinterInfo2);
        if GetPrinter(HPrinter, 2, PI2, BytesNeeded, @BytesNeeded) then
          ADestStream.Write(PChar(PI2)[InfoSize], BytesNeeded - InfoSize);
      finally
        FreeMem(PI2, BytesNeeded);
      end;
    end;
  finally
    ClosePrinter(HPrinter);
  end;
end;

procedure LoadPrinterInfo(APrinterName: PChar; ASourceStream: TStream);
var
  HPrinter: THandle;
  InfoSize,
    BytesNeeded: Cardinal;
  PI2: PPrinterInfo2;
  PrinterDefaults: TPrinterDefaults;
begin
  with PrinterDefaults do
  begin
    DesiredAccess := PRINTER_ACCESS_USE;
    pDatatype := nil;
    pDevMode := nil;
  end;
  if OpenPrinter(APrinterName, HPrinter, @PrinterDefaults) then
  try
    SetLastError(0);
    //Determine the number of bytes to allocate for the PRINTER_INFO_2 construct...
    if not GetPrinter(HPrinter, 2, nil, 0, @BytesNeeded) then
    begin
      //Allocate memory space for the PRINTER_INFO_2 pointer (PrinterInfo2)...
      PI2 := AllocMem(BytesNeeded);
      try
        InfoSize := SizeOf(TPrinterInfo2);
        if GetPrinter(HPrinter, 2, PI2, BytesNeeded, @BytesNeeded) then
        begin
          PI2.pSecurityDescriptor := nil;
          ASourceStream.ReadBuffer(PChar(PI2)[InfoSize], BytesNeeded - InfoSize);
          // Apply settings to the printer
          if DocumentProperties(0, hPrinter, APrinterName, PI2.pDevMode^,
            PI2.pDevMode^, DM_IN_BUFFER or DM_OUT_BUFFER) = IDOK then
          begin
            SetPrinter(HPrinter, 2, PI2, 0); // Ignore the result of this call...
          end;
        end;
      finally
        FreeMem(PI2, BytesNeeded);
      end;
    end;
  finally
    ClosePrinter(HPrinter);
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//       Windows/Control function & Procedure
//////////////////////////////////////////////////////////////////////////////

function RegAndCreateWindow(const ClassName, Caption: string; WndProc : TFNWndProc): HWND;
var
  c : TWndClass;
begin
  ZeroMemory(@c, SizeOf(c));
  c.lpfnWndProc := WndProc;
  c.hInstance := HInstance;
  c.hbrBackground := 16;
  c.lpszClassName := PChar(ClassName);
  if Windows.RegisterClass(c) <> 0 then
  Result := CreateWindow(c.lpszClassName,
                         PChar(Caption),
                         WS_OVERLAPPEDWINDOW,
                         CW_USEDEFAULT,
                         CW_USEDEFAULT,
                         CW_USEDEFAULT,
                         CW_USEDEFAULT,
                         CW_USEDEFAULT,
                         CW_USEDEFAULT,
                         HInstance,
                         nil);
end;

function UpdateLayeredWindow(hWnd: HWND;
  hdcDst: HDC; Dst: PPoint; const size: PSize;
  hdcSrc: HDC; Src: PPoint;
  crKey: COLORREF;
  pblend: PBlendFunction;
  dwFlags: DWORD): BOOL; stdcall;
type
  TUpdateLayeredWindow = function (hWnd: THandle;  hdcDst: HDC; Dst: PPoint; const size: PSize;
            hdcSrc: HDC; Src: PPoint;  crKey: COLORREF;  pblend: PBlendFunction;
            dwFlags: DWORD): BOOL; stdcall; //external 'user32.dll';
var
  Func : TUpdateLayeredWindow;
  M : HMODULE;
begin
  Result := False;
  M := GetModuleHandle(user32);
  if M = 0 then Exit;

  Func := GetProcAddress(M, 'UpdateLayeredWindow');
  if @Func = nil then Exit;
  Result := Func(hWnd, hdcDst, Dst, size, hdcSrc, Src, crKey, pblend, dwFlags);
end;

procedure ColorUpdateLayeredWindow(Wnd: HWND; BMP: TBitmap; TransColor: COLORREF);
var
  R: TRect;
  S: TSize;
  P: TPoint;
begin
  GetWindowRect(Wnd, R);
  P := Point(0, 0);
  S.cx := Bmp.Width;
  S.cY := Bmp.Height;
  SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_LAYERED);
  UpdateLayeredWindow(Wnd, 0, @R.TopLeft, @S, Bmp.Canvas.Handle, @P, TransColor, nil, ULW_COLORKEY);
end;
//
procedure AlphaUpdateLayeredWindow(Wnd: HWND; Bmp: TBitmap; Alpha: Byte);
var
  P: TPoint;
  R: TRect;
  S: TSize;
  BF: _BLENDFUNCTION;
begin
  GetWindowRect(Wnd, R);
  P := Point(0, 0);
  S.cx := Bmp.Width;
  S.cY := Bmp.Height;
  bf.BlendOp := AC_SRC_OVER;
  bf.BlendFlags := 0;
  bf.SourceConstantAlpha := Alpha;
  bf.AlphaFormat := AC_SRC_ALPHA;
  SetWindowLong(wnd, GWL_EXSTYLE, GetWindowLong(wnd, GWL_EXSTYLE) or WS_EX_LAYERED);
  UpdateLayeredWindow(wnd, 0, @R.TopLeft, @S, Bmp.Canvas.Handle, @P, 0, @BF, ULW_ALPHA);
end;

procedure SetEditNumber(EditWnd: HWND; const NumberOnly: Boolean = True);
{
  设置Edit只能输入数字
}
begin
  if NumberOnly then
    SetWindowLong(EditWnd, GWL_STYLE, GetWindowLong(EditWnd, GWL_STYLE) or ES_NUMBER)
  else
    SetWindowLong(EditWnd, GWL_STYLE, GetWindowLong(EditWnd, GWL_STYLE) and (not ES_NUMBER));
end;

function ForceForegroundWindow(hWnd: HWND): Boolean;
{
  强制把窗口hWnd显示到最前面，而不仅仅是闪烁窗口的任务栏按钮，支持所有的Win OS
}
var
  hCurWnd: THandle;
begin
  hCurWnd := GetForegroundWindow;
  AttachThreadInput(GetWindowThreadProcessId(hCurWnd, nil), GetCurrentThreadId, True);
  Result := SetForegroundWindow(hWnd);
  AttachThreadInput(GetWindowThreadProcessId(hCurWnd, nil), GetCurrentThreadId, False);
end;

procedure PopWindowMenu(hWnd: HWND; P: TPoint);
{
  在P点弹出指定窗口的系统控制菜单
}
begin
  SendMessage(hWnd, $313, 0, MakeLong(P.X, P.Y));
end;

procedure SetWindowOnTop(const hWnd: HWND; const OnTop: Boolean);
{
  设置窗口hWnd是否总在最前
}
begin
  if OnTop then
    SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
  else
    SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure MoveControl(WinControl: HWND);
{
  移动控件/窗口
}
const
  SM = $F012;
begin
  ReleaseCapture;
  SendMessage(WinControl, WM_SYSCOMMAND, SM, 0);
end;

procedure EnableControl(hWnd: hWnd; Enable: Boolean);
{
  允许/禁止一个窗口、控件，这样可以使有的控件不会变颜色哦，例如Edit！
}
begin
  if Enable then
    SetWindowLong(hWnd, GWL_STYLE, (not WS_DISABLED) and GetWindowLong(hWnd, GWL_STYLE))
  else
    SetWindowLong(hWnd, GWL_STYLE, WS_DISABLED or GetWindowLong(hWnd, GWL_STYLE));
end;

procedure RoundedControl(hWnd: HWND);
{
  设置指定控件的边框为圆角矩形形状
}
var
  R: TRect;
  Rgn: HRGN;
begin
  GetWindowRect(hWnd, R);
  ScreenToClient(hWnd, R.TopLeft);
  ScreenToClient(hWnd, R.BottomRight);
  rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
  SendMessage(hWnd, EM_GETRECT, 0, lParam(@r));
  InflateRect(R, -5, -5);
  SendMessage(hWnd, EM_SETRECTNP, 0, lParam(@r));
  SetWindowRgn(hWnd, rgn, True);
  InvalidateRgn(hWnd, rgn, True);
  DeleteObject(Rgn);
end;

procedure MinWindow(hWnd: HWND);
{
  最小化指定控件或者窗口
}
begin
  SendMessage(hWnd, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure MaxWindow(hWnd: HWND);
{
  最大化指定窗口或者控件
}
begin
  SendMessage(hWnd, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
end;

procedure RestoreWindow(hWnd: HWND);
{
  恢复指定窗口或者控件为正常状态
}
begin
  SendMessage(hWnd, WM_SYSCOMMAND, SC_RESTORE, 0);
end;

procedure SetControlMultiLine(const hWnd: HWND; const Enable: Boolean);
{
  设置指定控件为多行/单行文本风格，Enable=True为多行风格
}
begin
  if Enable then
    SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) or BS_MULTILINE)
  else
    SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) and not BS_MULTILINE);
end;

function GetWindowClassName(hWnd: HWND): string;
{
   返回指定窗口的类名
}
begin
  SetLength(Result, 255);
  GetClassName(hWnd, PChar(Result), Length(Result));
end;

function GetWindowCaption(hWnd: HWND): string;
{
  返回指定窗口的窗口标题文字
}
begin
  SetLength(Result, GetWindowTextLength(hWnd) + 1);
  GetWindowText(hWnd, PChar(Result), Length(Result));
  Result := PChar(Result);
end;

type
  TBalloonThread = class(TThread)
  private
    FHWND: HWND;
    FIcon: Integer;
    FTitle: PChar;
    FText: PChar;
    FDelayTime: DWORD;
    FBkColor, FColor: COLORREF;
    procedure Execute; override;
  public
    constructor Create(hWnd: HWND; Icon: integer; Title: pchar; Text: PChar;
     const DelayTime: DWORD=6000; const BkColor: COLORREF = 0; const Color: COLORREF = 0);
  end;

  { TBalloonThread }

constructor TBalloonThread.Create(hWnd: HWND; Icon: integer; Title,
  Text: PChar; const DelayTime: DWORD; const BkColor, Color: COLORREF);
begin
  FHWND := hWnd;
  FIcon := Icon;
  FTitle := Title;
  FText := Text;
  FDelayTime := DelayTime;
  FBkColor := BkColor;
  FColor := Color;
  inherited Create(False);
  FreeOnTerminate := True;
end;

procedure TBalloonThread.Execute;
const
  TOOLTIPS_CLASS = 'tooltips_class32';
  TTS_BALLOON = $40;
  TTM_SETTITLE = (WM_USER + 32);
type
  TOOLINFO = packed record
    cbSize: integer;
    uFlags: integer;
    hwnd: THandle;
    uId: integer;
    rect: TRect;
    hinst: THandle;
    lpszText: PChar;
    lParam: integer;
  end;
var
  ti: TOOLINFO;
  WndTip: THandle;
begin
  WndTip := CreateWindow(TOOLTIPS_CLASS, nil,
    WS_POPUP or TTS_NOPREFIX or TTS_BALLOON or TTS_ALWAYSTIP,
    0, 0, 0, 0, FHWND, 0, HInstance, nil);
  if WndTip <> 0 then
  begin
    SetWindowPos(WndTip, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    ti.cbSize := SizeOf(ti);
    ti.uFlags := TTF_CENTERTIP or TTF_TRANSPARENT or TTF_SUBCLASS;
    ti.hwnd := FHWND;
    ti.lpszText := FText;
    Windows.GetClientRect(FhWnd, ti.rect);
    SendMessage(WndTip, TTM_ADDTOOL, 1, integer(@ti));
    SendMessage(WndTip, TTM_SETTIPBKCOLOR, FBkColor, 0);
    SendMessage(WndTip, TTM_SETTIPTEXTCOLOR, FColor, 0);
    SendMessage(WndTip, TTM_SETTITLE, FIcon mod 4, Integer(FTitle));
    SendMessage(WndTip, TTM_TRACKACTIVATE, 1, Integer(@ti));
    Delay(FDelayTime);
    DestroyWindow(WndTip);
  end;
end;


procedure ShowBalloonTip(hWnd: HWND; Icon: integer; Title: pchar; Text: PChar;
   const DelayTime: DWORD=$F0F0F0; const BkColor: COLORREF = 0; const Color: COLORREF = 0);
{
  显示一个气球提示信息，hWnd需要显示的控件，Icon气球提示的图标，Title，标题，Text文本内容
}
begin
  TBalloonThread.Create(hWnd, Icon, Title, Text, DelayTime, BkColor, Color);
end;

function GetTaskmanWindow: HWND;
{
  返回任务管理器窗口的句柄
}
type
  TGetTaskmanWindow = function(): HWND; stdcall;
var
  hUser32: THandle;
  GetTaskmanWindow: TGetTaskmanWindow;
begin
  Result := 0;
  hUser32 := GetModuleHandle('user32.dll');
  if (hUser32 > 0) then
  begin
    @GetTaskmanWindow := GetProcAddress(hUser32, 'GetTaskmanWindow');
    if Assigned(GetTaskmanWindow) then
    begin
      Result := GetTaskmanWindow;
    end;
  end;
end;

function GetDesktopListViewWnd: HWND;
begin
  Result := GetDesktopWindow;
  Result := FindWindowEx(Result, 0, 'Progman', nil);
  Result := FindWindowEx(Result, 0, 'SHELLDLL_DefView', nil);
  Result := FindWindowEx(Result, 0, 'SysListView32', nil);
end;

function GetSysFocusControl: HWND;
{
  返回系统当前拥有输入焦点的控件句柄
}
var
  hFgWin, FgThreadID: Integer;
begin
  hFgWin := GetForegroundWindow;
  FgThreadID := GetWindowThreadProcessID(hFgWin, nil);
  if AttachThreadInput(GetCurrentThreadID, FgThreadID, True) then
  begin
    Result := GetFocus;
    AttachThreadInput(GetCurrentThreadID, FgThreadID, False);
  end
  else
    Result := GetFocus;
end;

function IsTaskbarAutoHide: boolean;
{
  判断任务栏是否自动隐藏
}
var
  ABData: TAppBarData;
begin
  ABData.cbSize := sizeof(ABData);
  Result := (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_AUTOHIDE) > 0;
end;

function IsTaskbarAlwaysOnTop: boolean;
{
  判断任务栏是否总在最前
}
var
  ABData: TAppBarData;
begin
  ABData.cbSize := sizeof(ABData);
  Result := (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_ALWAYSONTOP) > 0;
end;

function IsWindowResponing(hWnd: HWND; const TimeOut: integer = 2000): Boolean;
{
  判断指定的窗口是否有响应
}
var
  Res: DWORD;
begin
  Result := SendMessageTimeout(hWnd, WM_NULL, 0, 0, SMTO_ABORTIFHUNG, TimeOut, Res) <> 0;
end;

procedure ShowTaskmanWindow(bValue: Boolean);
{
  显示/隐藏任务管理器窗口
}
var
  hTaskmanWindow: Hwnd;
begin
  hTaskmanWindow := GetTaskmanWindow;
  if hTaskmanWindow <> 0 then ShowWindow(GetParent(hTaskmanWindow), Ord(bValue));
end;

function GetSysTrayWnd: HWND;
{
  返回系统托盘的句柄，适合于WinXP以上版本
}
begin
  Result := FindWindow('Shell_TrayWnd', nil);
  Result := FindWindowEx(Result, 0, 'TrayNotifyWnd', nil);
  Result := FindWindowEx(Result, 0, 'SysPager', nil);
  Result := FindWindowEx(Result, 0, 'ToolbarWindow32', nil);
end;

function GetSysTaskbarListWnd: HWND;
{
  返回系统任务栏按钮列表工具栏的句柄
}
begin
  Result := FindWindow('Shell_TrayWnd', nil);
  Result := FindWindowEx(Result, 0, 'ReBarWindow32', nil);
  Result := FindWindowEx(Result, 0, 'MSTaskSwWClass', nil);
  if WinVer >= '5.1' then /// Win XP or Higher
    Result := FindWindowEx(Result, 0, 'ToolbarWindow32', nil)
  else
    Result := FindWindowEx(Result, 0, 'SysTabControl32', nil);
end;

function GetToolBarButtonRect(hWnd: HWND; Title: string): TRect;
{
  返回指定工具栏对应的按钮指定文本的矩形区域
  hWnd:工具栏句柄，Title：需要返回矩形区域的按钮文字
  返回值：指定按钮的边界矩形，屏幕坐标
}
var
  C, i: integer;
  Info: _TBBUTTON;
  Item: tagTCITEM;
  Buff: PChar;
  S: array[0..1024] of char;
  PID: THandle;
  PRC: THandle;
  R: Cardinal;
begin
  FillChar(Result, SizeOf(Result), 0);
  if hWnd = 0 then Exit;
  GetWindowThreadProcessId(hWnd, @PID);
  PRC := OpenProcess(PROCESS_VM_OPERATION or PROCESS_VM_READ or PROCESS_VM_WRITE, False, PID);
  Buff := VirtualAllocEx(PRC, nil, 4096, MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);

  if Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]) >= '5.1' then {// Is Windows XP or Higher}
  begin
    C := SendMessage(hWnd, TB_BUTTONCOUNT, 0, 0);
    for i := 0 to C - 1 do
    begin
      FillChar(Info, SizeOf(Info), 0);
      WriteProcessMemory(PRC, Buff, @Info, SizeOf(Info), R);

      SendMessage(hWnd, TB_GETBUTTON, i, integer(Buff));
      ReadProcessMemory(PRC, Buff, @Info, SizeOf(Info), R);

      SendMessage(hWnd, TB_GETBUTTONTEXT, Info.idCommand, integer(integer(@Buff[0]) + SizeOf(Info)));
      ReadProcessMemory(PRC, Pointer(integer(@Buff[0]) + SizeOf(Info)), @S[0], SizeOf(S), R);
      if SameText(StrPas(S), Title) and not Boolean(SendMessage(hWnd, TB_ISBUTTONHIDDEN, Info.idCommand, 0)) then
      begin
        SendMessage(hWnd, TB_GETRECT, Info.idCommand, integer(integer(@Buff[0]) + SizeOf(Info)));
        ReadProcessMemory(PRC, Pointer(integer(@Buff[0]) + SizeOf(Info)), @Result, SizeOf(Result), R);

        Windows.ClientToScreen(hWnd, Result.TopLeft);
        Windows.ClientToScreen(hWnd, Result.BottomRight);

        Break;
      end;
    end;
  end
  else
  begin
    C := SendMessage(hWnd, TCM_GETITEMCOUNT, 0, 0);
    for i := 0 to C - 1 do
    begin
      with Item do
      begin
        mask := TCIF_TEXT;
        dwState := 0;
        dwStateMask := 0;
        cchTextMax := 2048;
        pszText := PChar(integer(Buff) + SizeOf(Item) * 4);
        iImage := 0;
        lParam := 0;
      end;
      WriteProcessMemory(PRC, Buff, @Item, SizeOf(Item), R);
      SendMessage(hWnd, TCM_GETITEM, i, Integer(Buff));

      ReadProcessMemory(PRC, Buff, @Item, SizeOf(Item), R);
      ReadProcessMemory(PRC, PChar(integer(Buff) + SizeOf(Item) * 4), @S[0], SizeOf(S), R);

      if SameText(S, Title) then
      begin
        SendMessage(hWnd, TCM_GETITEMRECT, i, integer(Buff));
        ReadProcessMemory(PRC, Buff, @Result, SizeOf(Result), R);

        Windows.ClientToScreen(hWnd, Result.TopLeft);
        Windows.ClientToScreen(hWnd, Result.BottomRight);
        Break;
      end;
    end;
  end;

  VirtualFreeEx(PRC, Buff, 0, MEM_RELEASE);
  CloseHandle(PRC);
end;

function GetSysTrayIconRect(Text: string): TRect;
{
  返回系统托盘中指定文字的图标的矩形区域。
  例如返回音量控制图标的矩形区域：
  GetSysTrayIconRect('音量');
}
begin
  Result := GetToolBarButtonRect(GetSysTrayWnd, Text);
end;

function GetTaskBarButtonRect(Title: string): TRect;
{
  返回指定Title的窗口按钮在任务栏的按钮的矩形区域
  例如返回当前程序的任务栏按钮矩形：
  GetTaskBarButtonRect(Application.Title);
}
begin
  Result := GetToolBarButtonRect(GetSysTaskbarListWnd, Title);
end;

function CurrMousePos: TPoint;
{
  返回当前系统鼠标的位置坐标
}
begin
  FillChar(Result, SizeOf(Result), 0);
  GetCursorPos(Result);
end;

procedure RefreshTrayIcon;
{
  刷新系统托盘图标
}
var
 hwndTrayToolBar : HWND;
 rTrayToolBar : tRect;
 x , y : Word;
begin
 hwndTrayToolBar := GetSysTrayWnd;

 Windows.GetClientRect(hwndTrayToolBar, rTrayToolBar);
 x := 0;
 while x < rTrayToolBar.right do
 begin
   y := 0;
   while y < rTrayToolBar.bottom do
   begin
     SendMessage(hwndTrayToolBar , WM_MOUSEMOVE, 0, MAKELPARAM(x,y) );
     inc(y,8);
   end;
   inc(x, 8);
 end;
end;

function CascadeWindowsEx(const Owner: HWND; const R: TRect; const WinHWNDs : array of HWND): Integer;
{
  排列多个窗口
  例如：CascadeWindowsEx(Handle, BoundsRect, [Form2.Handle, Form3.Handle, Form4.Handle]); 
}
var
 OldParent: array of HWND;
 i : integer;
begin
 SetLength(OldParent, Length(WinHWNDs));
 for i:=Low(OldParent) to High(OldParent) do
 begin
   OldParent[i] := GetParent(WinHWNDs[i]);
   Windows.SetParent(WinHWNDs[i], Owner);
 end;
 Result := CascadeWindows(Owner, MDITILE_SKIPDISABLED, @R, Length(WinHWNDs), @WinHWNDs[0]);
 /// Restore
 for i:=Low(OldParent) to High(OldParent) do
   Windows.SetParent(WinHWNDs[i], OldParent[i]);
end;


//////////////////////////////////////////////////////////////////////////////
//       Date/Time function & procedure
//////////////////////////////////////////////////////////////////////////////

function IsNewDay(var LastTime: TDateTime): Boolean;
{
  判断是否是新的一天了，必须传递LastTime
  支持时间倒回去！
}
var
  T: TDateTime;
begin
  T := Now;
  Result := Abs(Trunc(T) - Trunc(LastTime)) >= 1;
  LastTime := T;
end;
function SameDate(Const ATime,BTime: TDateTime): Boolean;
{
  判断是否是同一天！
}
var
  T: TDateTime;
begin
  Result := Abs(Trunc(ATime) - Trunc(ATime)) >= 1;
end;
function GMTNow: TDateTime;
{
  返回当前的系统的GMT/UTC时间
}
var
  TimeRec: TSystemTime;
begin
  GetSystemTime(TimeRec);
  Result := SystemTimeToDateTime(TimeRec);
end;

const
  MinsPerDay = 24 * 60;

function GetGMTBias: Integer;
var
  info: TTimeZoneInformation;
  Mode: DWord;
begin
  Mode := GetTimeZoneInformation(info);
  Result := info.Bias;
  case Mode of
    TIME_ZONE_ID_INVALID: RaiseLastOSError;
    TIME_ZONE_ID_STANDARD: Result := Result + info.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Result := Result + info.DaylightBias;
  end;
end;

function LocaleToGMT(const Value: TDateTime): TDateTime;
{
  把本地时间Value转换成GMT/UTC时间
}
begin
  Result := Value + (GetGMTBias / MinsPerDay);
end;

function GMTToLocale(const Value: TDateTime): TDateTime;
{
  把GMT/UTC时间Value转换成本地时间
}
begin
  Result := Value - (GetGMTBias / MinsPerDay);
end;

function SubTimeToMinutes(StartT, EndT: TDateTime): integer;
{
  返回两个时间分钟之差，StartT应该少于EndT，否则返回负数值
}
begin
  Result := Round((EndT - StartT) * 24 * 60);
end;

function SubTimeToSeconds(StartT, EndT: TDateTime): integer;
{
  返回两个时间的秒数之差，StartT应该小于Endt，否则返回负数值
}
begin
  Result := Round((EndT - StartT) * 24 * 60 * 60);
end;

function SubTimeToMSeconds(StartT, EndT: TDateTime): integer;
{
  返回两个时间的毫秒数之差，StartT应该小于EndT，否则返回负数值
}
begin
  Result := Round((EndT - StartT) * 24 * 60 * 60 * 1000);
end;

function GetAge(Birthday: TDateTime): Integer;
{
   返回Birthday相对于当前日期的年龄值
}
var
  Month, Day, Year, CurrentYear, CurrentMonth, CurrentDay: Word;
begin
  DecodeDate(Birthday, Year, Month, Day);
  DecodeDate(Now, CurrentYear, CurrentMonth, CurrentDay);

  if (Year = CurrentYear) and (Month = CurrentMonth) and (Day = CurrentDay) then
  begin
    Result := 0;
  end
  else
  begin
    Result := CurrentYear - Year;
    if (Month > CurrentMonth) then
      Dec(Result)
    else
    begin
      if Month = CurrentMonth then
        if (Day > CurrentDay) then
          Dec(Result);
    end;
  end;
end;

function SameTime(const Time1, Time2: TDateTime): Boolean;
{
  比较两个时间是否相等，Delphi 6本身有这个函数，精确到毫秒
}
begin
  Result := Abs(Frac(Time1) - Frac(Time2)) < 1 / MSecsPerDay;
end;

function NearTime(const Time1, Time2: TDateTime; const Offset_MSec: integer = 1): Boolean;
{
  检查两个时间是否相近似，Offset为精度，默认1毫秒精确到秒
}
begin
  Result := Abs(Time - Time2) < (1 / MSecsPerDay * Offset_MSec);
end;

function MSecondsToString(MSeconds: int64): string;
{
  毫秒转换成XX天XX小时XX分钟XX秒的格式
}
const
  MSecPerDay: Integer = 1000 * 60 * 60 * 24;
  MSecPerHour: Integer = 1000 * 60 * 60;
  MSecPerMinute: Integer = 1000 * 60;
  MSecPerSecond: integer = 1000;
var
  D, H, M, S: integer;
begin
  D := MSeconds div MSecPerDay;
  MSeconds := MSeconds mod MSecPerDay;
  if D > 0 then Result := IntToStr(D) + SDays;

  H := MSeconds div MSecPerHour;
  MSeconds := MSeconds mod MSecPerHour;
  if H > 0 then Result := Result + IntToStr(H) + SHours;

  M := MSeconds div MSecPerMinute;
  MSeconds := MSeconds mod MSecPerMinute;
  if M > 0 then Result := Result + IntToStr(M) + SMinutes;

  S := MSeconds div MSecPerSecond;
  if S > 0 then Result := Result + IntToStr(S) + SSeconds;
end;

function DateTimeToStringEx(Value: TDateTime; const ShortFormat: Boolean=False): string;
{
  DateTime转换成X天X小时X分钟X秒的格式
}
var
  D, H, M, S: integer;
begin
  if SameValue(Value, 0) then Exit;
  
  D := Trunc(Value);
  Value := Value - D;
  H := Trunc(Value * 24);
  Value := Value - 1 / 24 * H;
  M := Trunc(Value * 24 * 60);
  Value := Value - 1 / (24 * 60) * M;
  S := Trunc(Value * 24 * 60 * 60);

  if ShortFormat then
    Result := Format('%.2d:%.2d:%.2d', [D * 24 + H,M,S])
  else
  begin
    if D > 0 then Result := IntToStr(D) + SDays;
    if H > 0 then Result := Result + IntToStr(H) + SHours;
    if M > 0 then Result := Result + IntToStr(M) + SMinutes;
    if S > 0 then Result := Result + IntToStr(S) + SSeconds;
  end;
end;

function StringToDateTime(const DateTimeFormat, DateTimeStr: string): TDateTime;
{
  按格式转换一个字符串为TDateTime，例如StrToDateTimeFmt('yyyymmddhhssnn','20040601102359')
}
// =============================================================================
// Evaluate a date time string into a TDateTime obeying the
// rules of the specified DateTimeFormat string
// eg. DateTimeStrEval('dd-MMM-yyyy hh:nn','23-May-2002 12:34)
//
// NOTE : One assumption I have to make that DAYS,MONTHS,HOURS and
//        MINUTES have a leading ZERO or SPACE (ie. are 2 chars long)
//        and MILLISECONDS are 3 chars long (ZERO or SPACE padded)
//
// Supports DateTimeFormat Specifiers
//
// d    the day as a number with a leading zero or not (1-31).
// dd    the day as a number with a leading zero or space (01-31).
// ddd the day as an abbreviation (Sun-Sat)
// dddd the day as a full name (Sunday-Saturday)
// m    the month as a number with a leading zero or nor (1-12).
// mm    the month as a number with a leading zero or space (01-12).
// mmm the month as an abbreviation (Jan-Dec)
// mmmm the month as a full name (January-December)
// yy    the year as a two-digit number (00-99).
// yyyy the year as a four-digit number (0000-9999).
// hh    the hour with a leading zero or space (00-23)
// nn    the minute with a leading zero or space (00-59).
// ss    the second with a leading zero or space (00-59).
// zzz the millisecond with a leading zero (000-999).
// ampm  Specifies am or pm flag hours (0..12)
// ap    Specifies a or p flag hours (0..12)
//
//
// Delphi 6 Specific in DateUtils can be translated to ....
//
// YearOf()
//
// function YearOf(const AValue: TDateTime): Word;
// var LMonth, LDay : word;
// begin
//   DecodeDate(AValue,Result,LMonth,LDay);
// end;
//
// TryEncodeDateTime()
//
// function TryEncodeDateTime(const AYear,AMonth,ADay,AHour,AMinute,ASecond,
//                            AMilliSecond : word;
//                            out AValue : TDateTime): Boolean;
// var LTime : TDateTime;
// begin
//   Result := TryEncodeDate(AYear, AMonth, ADay, AValue);
//   if Result then begin
//     Result := TryEncodeTime(AHour, AMinute, ASecond, AMilliSecond, LTime);
//     if Result then
//       AValue := AValue + LTime;
//   end;
// end;
//
// =============================================================================
var
  i, ii, iii: integer;
  Retvar: TDateTime;
  Tmp, Fmt, Data, Mask, Spec: string;
  Year, Month, Day, Hour, Minute, Second, MSec: word;
  AmPm: integer;
  s : string; /// Buffer , By Kingron
begin
  Year := 1;
  Month := 1;
  Day := 1;
  Hour := 0;
  Minute := 0;
  Second := 0;
  MSec := 0;
  Fmt := UpperCase(DateTimeFormat);
  Data := UpperCase(DateTimeStr);
  i := 1;
  Mask := '';
  AmPm := 0;

  while i <= length(Fmt) do
  begin
    if Fmt[i] in ['A', 'P', 'D', 'M', 'Y', 'H', 'N', 'S', 'Z'] then
    begin
      // Start of a date specifier
      Mask := Fmt[i];
      ii := i + 1;

      // Keep going till not valid specifier
      while true do
      begin
        if ii > length(Fmt) then Break; // End of specifier string
        Spec := Mask + Fmt[ii];

        if (Spec = 'D') or (Spec = 'DD') or (Spec = 'DDD') or (Spec = 'DDDD') or
          (Spec = 'M') or (Spec = 'MM') or (Spec = 'MMM') or (Spec = 'MMMM') or
          (Spec = 'YY') or (Spec = 'YYY') or (Spec = 'YYYY') or
          (Spec = 'HH') or (Spec = 'NN') or (Spec = 'SS') or
          (Spec = 'ZZ') or (Spec = 'ZZZ') or (Spec = 'AP') or
          (Spec = 'AM') or (Spec = 'AMP') or (Spec = 'AMPM') then
        begin
          Mask := Spec;
          inc(ii);
        end
        else
        begin
          // End of or Invalid specifier
          Break;
        end;
      end;

      // Got a valid specifier ? - evaluate it from data string
      if (Mask <> '') and (length(Data) > 0) then
      begin
        // Day 1..31
        if (Mask = 'DD') or (Mask = 'D') then
        begin
          if (Length(Data) >= 2) and (Data[2] in ['0'..'9']) then
            s := copy(Data, 1, 2)
          else
            s := Copy(Data, 1, 1);
          Day := StrToIntDef(trim(s), 0);
          delete(Data, 1, Length(s));
          //if (Mask = 'D') and (Length(s) > 1) then Dec(ii);
        end;

        // Day Sun..Sat (Just remove from data string)
        if Mask = 'DDD' then delete(Data, 1, 3);

        // Day Sunday..Saturday (Just remove from data string LEN)
        if Mask = 'DDDD' then
        begin
          Tmp := copy(Data, 1, 3);
          for iii := 1 to 7 do
          begin
            if Tmp = Uppercase(copy(LongDayNames[iii], 1, 3)) then
            begin
              delete(Data, 1, length(LongDayNames[iii]));
              Break;
            end;
          end;
        end;

        // Month 1..12
        if (Mask = 'MM') or (Mask = 'M') then
        begin
          if (Length(Data) >= 2) and (Data[2] in ['0'..'9']) then
            s := copy(Data, 1, 2)
          else
            s := Copy(Data, 1, 1);
          Month := StrToIntDef(trim(s), 0);
          delete(Data, 1, Length(s));
          //if (Mask = 'M') and (Length(s) > 1) then Dec(ii);
        end;

        // Month Jan..Dec
        if Mask = 'MMM' then
        begin
          Tmp := copy(Data, 1, 3);
          for iii := 1 to 12 do
          begin
            if Tmp = Uppercase(copy(LongMonthNames[iii], 1, 3)) then
            begin
              Month := iii;
              delete(Data, 1, 3);
              Break;
            end;
          end;
        end;

        // Month January..December
        if Mask = 'MMMM' then
        begin
          Tmp := copy(Data, 1, 3);
          for iii := 1 to 12 do
          begin
            if Tmp = Uppercase(copy(LongMonthNames[iii], 1, 3)) then
            begin
              Month := iii;
              delete(Data, 1, length(LongMonthNames[iii]));
              Break;
            end;
          end;
        end;

        // Year 2 Digit
        if Mask = 'YY' then
        begin
          Year := StrToIntDef(copy(Data, 1, 2), 0);
          delete(Data, 1, 2);
          if Year < TwoDigitYearCenturyWindow then
            Year := (YearOf(Date) div 100) * 100 + Year
          else
            Year := (YearOf(Date) div 100 - 1) * 100 + Year;
        end;

        // Year 4 Digit
        if Mask = 'YYYY' then
        begin
          Year := StrToIntDef(copy(Data, 1, 4), 0);
          delete(Data, 1, 4);
        end;

        // Hours
        if Mask = 'HH' then
        begin
          Hour := StrToIntDef(trim(copy(Data, 1, 2)), 0);
          delete(Data, 1, 2);
        end;

        // Minutes
        if Mask = 'NN' then
        begin
          Minute := StrToIntDef(trim(copy(Data, 1, 2)), 0);
          delete(Data, 1, 2);
        end;

        // Seconds
        if Mask = 'SS' then
        begin
          Second := StrToIntDef(trim(copy(Data, 1, 2)), 0);
          delete(Data, 1, 2);
        end;

        // Milliseconds
        if (Mask = 'ZZ') or (Mask = 'ZZZ') then
        begin
          MSec := StrToIntDef(trim(copy(Data, 1, 3)), 0);
          delete(Data, 1, 3);
        end;

        // AmPm A or P flag
        if (Mask = 'AP') then
        begin
          if Data[1] = 'A' then
            AmPm := -1
          else
            AmPm := 1;
          delete(Data, 1, 1);
        end;

        // AmPm AM or PM flag
        if (Mask = 'AM') or (Mask = 'AMP') or (Mask = 'AMPM') then
        begin
          if copy(Data, 1, 2) = 'AM' then
            AmPm := -1
          else
            AmPm := 1;
          delete(Data, 1, 2);
        end;

        Mask := '';
        i := ii;
      end
      else
        i := ii;
    end
    else
    begin
      // Remove delimiter from data string
      if length(Data) > 1 then delete(Data, 1, 1);
      inc(i);
    end;
  end;

  if AmPm = 1 then Hour := Hour + 12;
  if not TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, MSec, Retvar) then
    Retvar := 0.0;
  Result := Retvar;
end;

function SecondsToString(Seconds: integer): string;
{
  秒数转换成mm:ss的格式
}
begin
  Result := TimeToStr(Seconds / 86400);
end;

function FileTimeToString(Value: _FILETIME): string; { Convert File Time To display string }
var
  SysTime: _SYSTEMTIME;
begin
  FileTimeToSystemTime(Value, SysTime);
  with SysTime do
  begin
    Dec(wYear, 1601);
    Dec(wMonth, 1);
    Dec(wDay, 1);
    if wYear > 0 then
      Result := IntToStr(wYear) + SYears;

    if wMonth > 0 then
      Result := Result + IntToStr(wMonth) + SMonths;

    if whour > 0 then
      Result := Result + IntToStr(whour) + SHours;

    if wminute > 0 then
      Result := Result + IntToStr(wminute) + SMinutes;

    if wsecond > 0 then
      Result := Result + IntToStr(wsecond) + SSeconds;

    if wMilliseconds > 0 then
      Result := Result + IntToStr(wMilliseconds) + SMilliseconds;
  end;
end;

function CheckWeekDay(const ADateTime: TDateTime; Day_WeekDay: Byte): Boolean;
{
  检查指定的时间是否是指定的星期，例如：CheckWeekDay(Now, 2)检查当天是否是星期二
  Day_WeekDay: [1..7]，如果和指定星期相同，返回True，否则返回False
}
begin
  Result := DayOfWeek(ADateTime) = Day_WeekDay;
end;

function UnixToDateTimeEx(Seconds, uSeconds: Int64): TDateTime;
{
  转换Unix时间为DateTime格式时间
  Unix时间为一个Int64类型数据，为从1970年1月1号经过的秒数
  Seconds为经过的秒数，uSeconds为附加的微秒时间，这样可以支持更高精度
}
begin
  Result := UnixDateDelta + (Seconds + uSeconds / 1000000) / SecsPerDay;
end;

function DateTimeToUnixEx(const ATime: TDateTime; out Seconds, uSeconds : Cardinal): Int64;
{
  转换一个DateTime为秒数和微秒数两个部分，返回结果低位1970年1月1日0：0：0秒的秒数
  高位为剩余的微妙数
}
var
  Delta : Double;
begin
	Delta := (ATime - UnixDateDelta) * SecsPerDay;
  Seconds := Trunc(Delta);
  uSeconds := Round(Frac(Delta) * 1000000);
  Int64Rec(Result).Lo := Seconds;
  Int64Rec(Result).Hi := uSeconds;
end;

function DateTimeToMinutes(ADateTime: TDateTime): Int64;
{
  转换DateTime为分钟数，例如 0.5 = 720; 2.0 = 2880；
}
begin
  Result := Trunc(ADateTime * MinsPerDay);
end;

function DateTimeToSeconds(ADateTime: TDateTime): Int64;
{
  转换一个DateTime为毫秒数
}
begin
  Result := Trunc(ADateTime * SecsPerDay);
end;

function DateTimeToMSeconds(ADateTime: TDateTime): Int64;
{
  转换一个DateTime为毫秒数
}
begin
  Result := Trunc(ADateTime * MSecsPerDay);
end;

function TimeToFileName(const T: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh-nn-ss', T);
end;

//////////////////////////////////////////////////////////////////////////////
//       GUID function & procedure
//////////////////////////////////////////////////////////////////////////////

function SameGUID(const ID1, ID2: TGUID): Boolean; overload;
{
  判断两个GUID是否相等
}
begin
  Result := CompareMem(@ID1, @ID2, SizeOf(ID1));
end;

function SameGUID(const ID1: TGUID; const ID2: string): Boolean; overload;
{
  判断两个GUID是否相等
}
begin
  Result := SameGUID(ID1, StringToGUID(ID2));
end;

function SameGUID(const ID1, ID2: string): Boolean; overload;
{
  判断两个GUID是否相等
}
begin
  Result := SameGUID(StringToGUID(ID1), StringToGUID(ID2));
end;

function GetGUID: TGUID;
{
  动态返回一个GUID
}
begin
  CoCreateGuid(Result);
end;

function GetGUIDString: string;
{
  动态返回一个GUID字符串
}
begin
  Result := GUIDToString(GetGUID);
end;

function IsGUID(const S: string): Boolean;
{
  判断一个字符串是否是合法的GUID
}
begin
  try
    StringToGUID(S);
    Result := True;
  except
    Result := False;
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//       Dialog function & procedure
//////////////////////////////////////////////////////////////////////////////

function DefDialogProc(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): integer; stdcall;
{

}
var
  Icon: HICON;
  i: integer;
  C: array of TDlgTemplateEx;
  Font: HFONT;
begin
  Result := 0;
  C := nil;
  Font := 0;
  Icon := 0;
  case Msg of
    WM_INITDIALOG:
      begin
        C := Pointer(lParam);
        Font := MakeFont('宋体', 12, 0, False, False, False);
        for i := Succ(Low(C)) to High(C) do
        begin
          SetWindowText(GetDlgItem(Wnd, C[i].dlgTemplate.id), PChar(C[i].Caption));
          SetFont(GetDlgItem(Wnd, C[i].dlgTemplate.id), Font);
        end;
        Icon := LoadIcon(HInstance, 'mainicon');
        SendMessage(Wnd, WM_SETICON, ICON_BIG, IfThen(Icon <> 0, Icon, LoadIcon(0, IDI_WARNING)));
        Result := 1;
      end;
    WM_NOTIFY:
      {case LOWORD(wParam) of

      end };
    WM_COMMAND:
      case LOWORD(wParam) of
        IDOK, IDCANCEL:
          begin
            DeleteObject(Font);
            DestroyIcon(Icon);
            EndDialog(Wnd, wParam);
          end;
      else
        Result := LoWord(wParam);
      end;
    WM_CLOSE:
      begin
        DeleteObject(Font);
        DestroyIcon(Icon);
        EndDialog(Wnd, wParam);
      end;
    WM_HELP:
      begin
        DlgInfo('Copyright(C) Kingron, 2004, Dialog powered by DialogBoxEx.');
      end;
  end;
end;

function DialogBoxEx(const Controls: array of TDlgTemplateEx; const DlgProc: Pointer = nil): integer;
{
  使用内存模版数据显示一个对话框，Controls定义对话框外观和对话框项目数据，
  如何使用本函数，请参考DlgInputText函数，其为完整演示。
  函数返回Controls中选择的对应项的ID，例如点击OK，则返回OK按钮的ID
}
  function lpwAlign(lpIn: DWORD): DWORD;
  begin
    Result := lpIn + 3;
    Result := Result shr 2;
    Result := Result shl 2;
  end;

var
  hgbl: HGLOBAL; /// 用于DiaologBoxInDirect的内存数据块
  lpdt: PDLGTEMPLATE; /// 对话框模版数据结构
  lpwd: ^TWordArray;
  lpwsz: LPWSTR;
  lpdit: PDLGITEMTEMPLATE; /// 对话框条目模版数据
  nchar: BYTE;
  i: Integer;
begin
  Result := 0;
  if Length(Controls) = 0 then Exit;

  hgbl := GlobalAlloc(GMEM_ZEROINIT, 4096);
  if hgbl = 0 then Exit;

  /// define dialog
  lpdt := GlobalLock(hgbl);
  lpdt.style := Controls[0].dlgTemplate.style and (not DS_SETFONT);
  lpdt.dwExtendedStyle := Controls[0].dlgTemplate.dwExtendedStyle;
  lpdt.cdit := Length(Controls) - 1;
  lpdt.x := Controls[0].dlgTemplate.x;
  lpdt.y := Controls[0].dlgTemplate.y;
  lpdt.cx := Controls[0].dlgTemplate.cx;
  lpdt.cy := Controls[0].dlgTemplate.cy;
  lpwd := Pointer(DWORD(lpdt) + SizeOf(TDlgTemplate));
  lpwd[0] := 0;
  lpwd[1] := 0;
  lpwsz := Pointer(DWORD(lpwd) + 4);
  nchar := MultiByteToWideChar(CP_ACP, 0, PChar(Controls[0].Caption), Length(Controls[0].Caption), lpwsz, 50) + 1;
  lpwd := Pointer(DWORD(lpwsz) + nchar * 2);
  lpwd := Pointer(lpwAlign(DWORD(lpwd))); // align DLGITEMTEMPLATE on DWORD boundary

  for i := Succ(Low(Controls)) to High(Controls) do
  begin /// Define Controls
    lpdit := Pointer(lpwd);
    lpdit.x := Controls[i].dlgTemplate.x;
    lpdit.y := Controls[i].dlgTemplate.y;
    lpdit.cx := Controls[i].dlgTemplate.cx;
    lpdit.cy := Controls[i].dlgTemplate.cy;
    lpdit.style := Controls[i].dlgTemplate.style;
    lpdit.id := Controls[i].dlgTemplate.id;
    lpwd := Pointer(DWORD(lpdit) + SizeOf(TDlgItemTemplate));
    lpwsz := Pointer(DWORD(lpwd));
    nchar := MultiByteToWideChar(CP_ACP, 0, PChar(Controls[i].ClassName), Length(Controls[i].ClassName), lpwsz, 50) + 1;
    lpwd := Pointer(DWORD(lpwsz) + nchar * 2);
    lpwd[0] := 0;
    lpwd := Pointer(lpwAlign(DWORD(lpwd) + 2)); // align DLGITEMTEMPLATE on DWORD boundary
  end;

  GlobalUnlock(hgbl);
  if DlgProc = nil then
    Result := DialogBoxIndirectParam(hInstance, PDlgTemplate(hgbl)^, GetActiveWindow, @DefDialogProc, Integer(@Controls))
  else
    Result := DialogBoxIndirectParam(hInstance, PDlgTemplate(hgbl)^, GetActiveWindow, DlgProc, Integer(@Controls));
  GlobalFree(hgbl);
end;

function InputBoxEx(const ACaption, AHint, ADefault: string; out Text: string): Boolean;
{
  输入对话框，纯API编程
}

  function DialogProc(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): integer; stdcall;
  begin
    Result := 0;
    case Msg of
      WM_COMMAND:
        begin
          case LOWORD(wParam) of
            ID_OK:
              begin
                ShareData := GetWindowCaption(GetDlgItem(Wnd, 101));
              end;
          end;
        end;
    end;
    if Result = 0 then /// 处理所有其他未处理消息
      Result := CallWindowProc(@DefDialogProc, Wnd, Msg, wParam, lParam);
  end;

var
  Controls: array of TDlgTemplateEx;
begin
  SetLength(Controls, 5);

  with Controls[0], dlgTemplate do /// 定义对话框外观
  begin
    style := DS_CENTER or DS_CONTEXTHELP
      or WS_SYSMENU or WS_DLGFRAME or WS_CAPTION or WS_VISIBLE;
    x := 0;
    y := 0;
    cx := 200;
    cy := 75;
    Caption := ACaption;
  end;

  with Controls[1], dlgTemplate do /// Hint label
  begin
    ClassName := 'EDIT';
    Caption := AHint + #13#10'Press Ctrl + Enter to enter a new line';
    style := ES_MULTILINE or ES_LEFT or WS_VISIBLE or ES_READONLY;
    dwExtendedStyle := 0;
    x := 10;
    y := 5;
    cx := 180;
    cy := 15;
    id := 100;
  end;

  with Controls[2], dlgTemplate do /// Edit Box
  begin
    ClassName := 'EDIT';
    Caption := ADefault;
    style := ES_MULTILINE or ES_AUTOVSCROLL
      or WS_VISIBLE or WS_BORDER or WS_TABSTOP or WS_VSCROLL;
    dwExtendedStyle := 0;
    x := 10;
    y := 25;
    cx := 180;
    cy := 30;
    id := 101;
  end;

  with Controls[3], dlgTemplate do /// OK Button
  begin
    ClassName := 'BUTTON';
    Caption := '&OK';
    style := WS_VISIBLE or WS_TABSTOP or BS_DEFPUSHBUTTON;
    dwExtendedStyle := 0;
    x := 125;
    y := 60;
    cx := 30;
    cy := 12;
    id := ID_OK;
  end;

  with Controls[4], dlgTemplate do /// OK Button
  begin
    ClassName := 'BUTTON';
    Caption := '&Cancel';
    style := WS_VISIBLE or WS_TABSTOP;
    dwExtendedStyle := 0;
    x := 160;
    y := 60;
    cx := 30;
    cy := 12;
    id := ID_CANCEL;
  end;
  Result := DialogBoxEx(Controls, @DialogProc) = ID_OK;
  if Result then Text := ShareData;
end;

function DlgConfirm(const Msg: string): Boolean;
{
  显示确认对话框，如果用户点击确定，返回True，否则False
}
begin
  Result := MessageBox(GetActiveWindow, PChar(Msg), PChar(SConfirm), MB_YESNO + MB_ICONQUESTION) = IDYES;
end;

function DlgConfirmEx(const Msg: string; Args: array of const): Boolean;
{
  确认对话框，可以支持参数输入，例如：
  if DlgConfig('Are you sure delete file %s ?',[AFileName]) then
}
begin
  Result := DlgConfirm(Format(Msg, Args));
end;

procedure DlgInfo(const Msg: string);
{
  简单的显示信息对话框
}
begin
  MsgBox(Msg);
end;

procedure DlgInfoEx(const Msg: string; Args: array of const);
{
  简单的显示信息对话框，支持参数
}
begin
  DlgInfo(Format(Msg, Args));
end;

procedure DlgError(const Msg: string);
{
  显示错误信息对话框
}
begin
  MsgBox(Msg, PChar(SError), MB_ICONERROR + MB_OK);
end;

procedure DlgErrorEx(const Msg: string; Args: array of const);
{
  显示错误信息对话框，支持参数
}
begin
  DlgError(Format(Msg, Args));
end;

procedure DlgLastError;
{
  显示最后一次Win API错误信息
}
begin
  DlgError(GetLastErrorString);
end;

function MsgBox(const Msg: string; const Title: string = 'Info'; dType: integer = MB_OK + MB_ICONINFORMATION): integer;
{
  显示一个信息对话框，和ShowMessage功能相同，不过用MessageBox API来实现，个人认为好于ShowMessage
  可以支持图标，支持多个按钮。
}
begin
  Result := MessageBox(GetActiveWindow, PChar(Msg), PChar(Title), dType);
end;

function DlgOpen(var AFileName: string; AInitialDir, AFilter: string): Boolean;
{
  显示打开文件对话框，并返回用户选择的文件名
  参数：
    AFileName：输入、输出参数，输入为初始化的文件名，输出为用户选择的文件名
    AInitialDir：初始化目录
    AFilter：过滤字符串，要求用#0字符分隔各个项目并用#0#0结尾，例如如果需要用户
             选择可能文件为Txt或者Log文件，那么可以这样写
             '文本文件和日志文件(*.Txt;*.Log)|*.Txt;*.Log|所有文件(*.*)|*.*'
    返回值：用户点击取消则返回False，否则返回True，AFileName为用户选择的文件名
}
var
  info: TOpenFilename;
  lpstrFile: array[0..2048] of char;
begin
  FillChar(Info, SizeOf(Info), 0);
  StrPCopy(lpstrFile, AFileName);

  info.lStructSize := sizeof(info);
  info.hWndOwner := GetActiveWindow;
  info.lpstrFilter := PChar(StringReplace(AFilter, '|', #0, [rfReplaceAll]) + #0#0);
  info.lpstrFile := lpstrFile;
  info.nMaxFile := SizeOf(lpstrFile);
  info.lpstrInitialDir := PChar(AInitialDir);
  Result := GetOpenFileName(info);
  if Result then AFileName := lpstrFile;
end;

function DlgSave(var AFileName: string; AInitialDir, AFilter: string): Boolean;
{
  显示保存文件对话框，并返回用户选择的文件名
  参数：
    AFileName：输入、输出参数，输入为初始化的文件名，输出为用户选择的文件名
    AInitialDir：初始化目录
    AFilter：过滤字符串，要求用#0字符分隔各个项目并用#0#0结尾，例如如果需要用户
             选择可能文件为Txt或者Log文件，那么可以这样写
             '文本文件和日志文件(*.Txt;*.Log)|*.Txt;*.Log|所有文件(*.*)|*.*'
    返回值：用户点击取消则返回False，否则返回True，AFileName为用户选择的文件名
}
var
  info: TOpenFilename;
  lpstrFile: array[0..2048] of char;
begin
  FillChar(Info, SizeOf(Info), 0);
  StrPCopy(lpstrFile, AFileName);

  info.lStructSize := sizeof(info);
  info.hWndOwner := GetActiveWindow;
  info.lpstrFilter := PChar(StringReplace(AFilter, '|', #0, [rfReplaceAll]) + #0#0);
  info.lpstrFile := lpstrFile;
  info.nMaxFile := SizeOf(lpstrFile);
  info.lpstrInitialDir := PChar(AInitialDir);
  Result := GetSaveFileName(info);
  if Result then AFileName := lpstrFile;
end;

function SelectDirectoryEx(var Path: string; const Caption, Root: string; BIFs: DWORD = $59;
  Callback: TSelectDirectoryProc = nil; const FileName: string = ''): Boolean;
{
  调用标准的Windows浏览目录对话框并返回用户选择的目录路径，并且可以强制用户选择
  的目录中必须包含某个文件
  参数：
    Path：输入、输出，输入作为初始化选择的目录，输出为用户选择的目录路径
    Caption：给用户的提示信息
    Root：作为根目录的目录，如果为空，则可以选择任意目录，不为空则用户只能选择
          Root目录或者其子目录，不能选择其它的目录
    BIF：控制用户能够选择目录的类型，例如是选择计算机还是打印机还是文件还是任意的
         ShellObject以及对话框的外观，例如是不是有新建文件夹按钮等
    FileName：如果为空，那么用户可以选择任意目录，否则的话，用户选择的目录必须包含
         文件FileName
    返回值：用户点击了Ok返回True，否则返回False
}
const
  BIF_NEWDIALOGSTYLE = $0040;
type
  TMyData = packed record
    IniPath: PChar;
    FileName: PChar;
    Proc: TSelectDirectoryProc;
    Flag: DWORD;
  end;
  PMyData = ^TMyData;

  function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam: Cardinal; lpData: Cardinal): integer; stdcall;
  var
    PathName: array[0..MAX_PATH] of char;
  begin
    case uMsg of
      BFFM_INITIALIZED:
        SendMessage(Hwnd, BFFM_SETSELECTION, Ord(True), integer(PMyData(lpData).IniPath));
      BFFM_SELCHANGED:
        begin
          SHGetPathFromIDList(PItemIDList(lParam), @PathName);
          SendMessage(hwnd, BFFM_SETSTATUSTEXT, 0, LongInt(PChar(@PathName)));
          if Assigned(PMyData(lpData).Proc) then
            SendMessage(hWnd, BFFM_ENABLEOK, 0, Ord(PMyData(lpData).Proc(PathName)))
          else if PMyData(lpData).FileName <> nil then
            SendMessage(hWnd, BFFM_ENABLEOK, 0,
                        Ord(FileExists(IncludeTrailingPathDelimiter(PathName) + PMyData(lpData).FileName)))
          else if (BIF_VALIDATE and PMyData(lpData).Flag) = BIF_VALIDATE then
            SendMessage(hWnd, BFFM_ENABLEOK, 0, Ord(DirectoryExists(PathName)));
        end;
    end;
    Result := 0;
  end;

var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Dummy: LongWord;
  Data: TMyData;
begin
  Result := False;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(GetActiveWindow, nil, POleStr(WideString(Root)), Dummy, RootItemIDList, Dummy);
      end;

      with BrowseInfo do
      begin
        hwndOwner := GetActiveWindow;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIFs;
        lpfn := @BrowseCallbackProc;
        Data.IniPath := PChar(Path);
        Data.Flag := BIFs;
        if FileName <> '' then
          Data.FileName := PChar(FileName)
        else
          Data.FileName := nil;
        Data.Proc := Callback;
        lParam := Integer(@Data);
      end;
      ItemIDList := ShBrowseForFolder(BrowseInfo);
      Result := ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Path := IncludeTrailingPathDelimiter(StrPas(Buffer));
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

function SelectComputer(DialogTitle: string; var CompName: string; bNewStyle: Boolean): Boolean;
{
  显示浏览计算机对话框，CompName：返回的计算机名字
  // bNewStyle: If True, this code will try to use the "new"
  // BrowseForFolders UI on Windows 2000/XP
}
const
  BIF_USENEWUI = 28;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ComputerName: array[0..MAX_PATH] of Char;
  ShellMalloc: IMalloc;
begin
  if Failed(SHGetSpecialFolderLocation(GetActiveWindow, CSIDL_NETWORK, ItemIDList)) then
    raise Exception.Create(SErrBrowseComputer);
  try
    FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
    BrowseInfo.hwndOwner := GetActiveWindow;
    BrowseInfo.pidlRoot := ItemIDList;
    BrowseInfo.pszDisplayName := ComputerName;
    BrowseInfo.lpszTitle := PChar(DialogTitle);
    if bNewStyle then
      BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER or BIF_USENEWUI
    else
      BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER;
    Result := SHBrowseForFolder(BrowseInfo) <> nil;
    if Result then CompName := ComputerName;
  finally
    if Succeeded(SHGetMalloc(ShellMalloc)) then
      ShellMalloc.Free(ItemIDList);
  end;
end;

function SystemFocusDialog(hwndOwner: HWND; dwSelectionFlag: UINT;
  wszName: PWideChar; dwBufSize: DWORD; var bOKPressed: Boolean;
  wszHelpFile: PWideChar; dwContextHelpId: DWORD): DWORD; stdcall; external 'ntlanman.dll' Name 'I_SystemFocusDialog';

function BrowserDomainComputer: WideString;
const
  FOCUSDLG_DOMAINS_ONLY = 1;
  FOCUSDLG_SERVERS_ONLY = 2;
  FOCUSDLG_SERVERS_DOMAINS = 3;
  FOCUSDLG_BROWSE_LOGON_DOMAIN = $00010000;
  FOCUSDLG_BROWSE_WKSTA_DOMAIN = $00020000;
  FOCUSDLG_BROWSE_OTHER_DOMAINS = $00040000;
  FOCUSDLG_BROWSE_TRUSTING_DOMAINS = $00080000;
  FOCUSDLG_BROWSE_WORKGROUP_DOMAINS = $00100000;
  FOCUSDLG_BROWSE_ALL_DOMAINS = FOCUSDLG_BROWSE_LOGON_DOMAIN or
    FOCUSDLG_BROWSE_WKSTA_DOMAIN or FOCUSDLG_BROWSE_OTHER_DOMAINS or
    FOCUSDLG_BROWSE_TRUSTING_DOMAINS or FOCUSDLG_BROWSE_WORKGROUP_DOMAINS;
var
  dwError: DWORD;
  R: Boolean;
  Buff: array[0..MAX_COMPUTERNAME_LENGTH] of WideChar;
begin
  dwError := SystemFocusDialog(GetActiveWindow, FOCUSDLG_SERVERS_DOMAINS or
    FOCUSDLG_BROWSE_ALL_DOMAINS, Buff, SizeOf(Buff), R, nil, 0);
  Result := Buff;
  if dwError <> NO_ERROR then Exit;
end;

procedure GetMailAddress(Wab: TStrings);
{
  显示系统的通讯录对话框，并返回用户选择的电子邮件地址
}
var
  lpRecip: TMapiRecipDesc;
  intRecips: ULONG;
  lpRecips: PMapiRecipDesc;
  i: Integer;
  hMapi: PLHANDLE;
begin
  if (MapiLogOn(0, nil, nil, MAPI_LOGON_UI, 0, @hMapi) = SUCCESS_SUCCESS) then
  begin
    if (MAPIAddress(0, GetActiveWindow, '', 1, '', 0, lpRecip, 0, 0, @intRecips,
      lpRecips) = SUCCESS_SUCCESS) then
    begin
      for i := 0 to intRecips - 1 do
        Wab.Add(PMapiRecipDesc(PChar(lpRecips) +
          i * SizeOf(TMapiRecipDesc))^.lpszAddress + ',' + PMapiRecipDesc(PChar(lpRecips) +
          i * SizeOf(TMapiRecipDesc))^.lpszName);
      MAPIFreeBuffer(lpRecips)
    end;
    Wab.Text := StringReplace(Wab.Text, 'SMTP:', '', rfAllNoCase);
  end;
end;

procedure DlgProperties(const FileName: string);
var
  sei: TShellExecuteInfo;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.Wnd := GetActiveWindow;
  sei.cbSize := SizeOf(sei);
  sei.lpFile := PChar(FileName);
  sei.lpVerb := 'properties';
  sei.fMask := SEE_MASK_INVOKEIDLIST;
  ShellExecuteEx(@sei);
end;

{ 显示更改图标对话框 }

{$WARN SYMBOL_PLATFORM	OFF}

function ShowChangeIconDialogA(hWnd: HWND; Filename: pchar; uBuffSize: integer; var index: integer): integer; stdcall; external 'Shell32.dll' index 62;

function ShowChangeIconDialogW(hWnd: HWND; Filename: pwidechar; uBuffSize: integer; var index: integer): integer; stdcall; external 'Shell32.dll' index 62;
{$WARN SYMBOL_PLATFORM	ON}

function DlgSelectIcon;
{
  显示选择图标对话框
}
var
  BuffW: array[0..MAX_PATH] of Widechar;
  BuffA: array[0..MAX_PATH] of Char;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    StringToWideChar(FileName, BuffW, SizeOf(BuffW));
    Result := ShowChangeIconDialogW(GetActiveWindow, BuffW, SizeOf(BuffW), Index);
    FileName := WideCharToString(BuffW);
  end
  else
  begin
    StrPCopy(BuffA, FileName);
    Result := ShowChangeIconDialogA(GetActiveWindow, BuffA, SizeOf(BuffA), Index);
    FileName := StrPas(BuffA);
  end;
end;

function DlgSelectColor(const InitColor: integer): Integer;
{
  颜色选择对话框
}
const
  CCColors: array[0..15] of integer = (
    $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF,
    $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF,
    $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF,
    $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF);
var
  CC: tagCHOOSECOLOR;
begin
  FillChar(CC, SizeOf(CC), 0);
  CC.lpCustColors := @CCColors;
  CC.lpCustColors^ := ColorToRGB(InitColor);
  CC.rgbResult := CC.lpCustColors^;
  CC.lStructSize := SizeOf(CC);
  CC.hWndOwner := GetActiveWindow;
  CC.hInstance := HInstance;
  CC.Flags := CC_RGBINIT or CC_FULLOPEN;
  if ChooseColor(CC) then
    Result := CC.rgbResult
  else
    Result := InitColor;
end;

//////////////////////////////////////////////////////////////////////////////
//       Stream/Drive/File/Path/directory function & procedure
//////////////////////////////////////////////////////////////////////////////

function SearchFileEx(const Filename: String): Boolean;
var
  Buf : array[0..MAX_PATH] of Char;
  P : PChar;
begin
  Result := SearchPath(nil, PChar(Filename), nil, SizeOf(Buf), Buf, P) = 0;
end;

function MappingFile(const FileName: string; const FILE_MAP_MODE: DWORD; const Offset: Int64 = 0; const Size: Int64 = 0): Pointer;
{
  文件映射，返回映射后的指针，使用后必须使用UnmapViewOfFile对返回的指针取消映射
  Offset表明从文件中那个地方开始映射，默认从文件头开始
  Size表明映射大小，默认为0即映射整个文件：注意文件大小不能超过4GB
}
var
  hFile, hMapHandle: THandle;
begin
  Result := nil;

  hFile := CreateFile(pchar(FileName), GENERIC_ALL, FILE_SHARE_READ,
    nil, OPEN_ALWAYS, FILE_FLAG_SEQUENTIAL_SCAN or FILE_FLAG_RANDOM_ACCESS, 0);
  if hFile = 0 then Exit;

  hMapHandle := CreateFileMapping(hFile, nil, PAGE_READWRITE,
                                  Int64Rec(Size).Hi, Int64Rec(Size).Lo, nil);
  if hMapHandle = 0 then
  begin
    CloseHandle(hFile);
    Exit;
  end;
  CloseHandle(hFile);
  Result := MapViewOfFile(hMapHandle, FILE_MAP_MODE, Int64Rec(Offset).Hi, Int64Rec(Offset).Lo, Size);
  CloseHandle(hMapHandle);
end;

function GetMIMETypeFromFile(const AFile: string): string;
{
  返回文件的MIME类型
  注意：为了性能文件没有扫描注册表MIME\Database下的所有列表，可能漏掉部分MIME
}
var
  Ext: string;
begin
  Result := 'application/octet-stream';
  Ext := ExtractFileExt(AFile);
  if RegValueExists(HKEY_CLASSES_ROOT, Ext, 'Content Type') then
    Result := RegReadString(HKEY_CLASSES_ROOT, Ext, 'Content Type');
end;

function GetExtFromMIMEType(const MIMEType: string): string; stdcall;
{
  根据MIME类型返回对应的默认文件名
  注意：为了性能没有扫描所有的注册的文件类型！
}
begin
  if RegValueExists(HKEY_CLASSES_ROOT, 'MIME\Database\Content Type\' + MIMEType, 'Extension') then
    Result := RegReadString(HKEY_CLASSES_ROOT, 'MIME\Database\Content Type\' + MIMEType, 'Extension');
end;

function BackupFile(const Filename: string; MaxFile : Integer = 5): Boolean; stdcall;
{
  备份文件
  FileName为需要备份的文件名，MaxFile为备份的最大文件数，超过的则最老的被删除！
}
var
  FFileName, BakFileName : string;
  iFile: integer;
begin
  FFileName := ChangeFileExt(Filename, '');
  BakFileName := Format('%s.%d.bak', [FFileName, MaxFile]);
  if FileExists(BakFileName) then DeleteFile(BakFileName);
  for iFile := Pred(MaxFile) downto 1 do
  begin
    BakFileName := Format('%s.%d.bak', [FFileName, iFile]);
    if FileExists(BakFileName) then RenameFile(BakFileName, Format('%s.%d.bak', [FFileName, iFile + 1]))
  end;
  Result := CopyFile(PChar(Filename), PChar(Format('%s.1.bak', [FFileName])), False);
end;

function GetShortFileName(const FileName: string): string;
var
  Buffer: array[0..MAX_PATH] of char;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  GetShortPathName(PChar(FileName), Buffer, SizeOf(Buffer));
  Result := StrPas(Buffer);
end;

function GetLongFileName(const FileName: string): string;
var
  Buffer: array[0..MAX_PATH] of char;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  GetLongPathName(PChar(FileName), Buffer, SizeOf(Buffer));
  Result := StrPas(Buffer);
end;

function ChangeFileExtEx(const FileName: string; const Ext: string): string;
{
  更改文件名后缀，支持Windows长文件名，Delphi本身的有BUG，如果文件名包含双引号
  则使用Delphi自带的会导致新文件名只有一半引号！
}
begin
  Result := StringReplace(ChangeFileExt(FileName, Ext), '"', '', [rfReplaceAll]);
end;

procedure SeekTextFile(var T: TextFile; N: integer);
{
  移动文本文件指针
}
begin
  with TTextRec(T) do
  begin
    BufPos := 0;
    FileSeek(Handle, N, 0);
    BufEnd := FileRead(Handle, BufPtr^, BufSize);
  end;
end;

function GetClipBoardText: string;
begin
  Result := Clipboard.AsText;
end;

function SetClipBoardText(const Text: string): Boolean;
begin
  Clipboard.AsText := Text;
  Result := True;
end;

function GetFileVersion(const FileName: string; Ident: string): string;
{
  返回指定文件的指定版本信息，例如：
  GetFileVersion('C:\Windows\Explorer.exe','CompanyName') 返回Microsoft Corparation

  Ident Can PreDefine as below:
  Comments InternalName ProductName
  CompanyName LegalCopyright ProductVersion
  FileDescription LegalTrademarks PrivateBuild
  FileVersion OriginalFilename SpecialBuild
}
var
  VersionInfo: Pointer;
  InfoSize: DWORD;
  InfoPointer: Pointer;
  Translation: PDWORD;
  VersionValue: string;
  unused: DWORD;
begin
  unused := 0;

  InfoSize := GetFileVersionInfoSize(pchar(FileName), unused);
  if InfoSize = 0 then Exit;

  GetMem(VersionInfo, InfoSize);
  if GetFileVersionInfo(pchar(FileName), 0, InfoSize, VersionInfo) then
  begin
    VerQueryValue(VersionInfo, '\VarFileInfo\Translation', Pointer(Translation), InfoSize);
    VersionValue := Format('\StringFileInfo\%.4x%.4x\%s', [LoWord(Translation^), HiWord(Translation^), Ident]);
    VerQueryValue(VersionInfo, PChar(VersionValue), InfoPointer, InfoSize);
    if InfoSize > 0 then
      Result := PChar(InfoPointer);
  end;
  FreeMem(VersionInfo);
end;

procedure SaveClipboardToFile(FileName: string);
{
  保存剪切版内容到文件
}
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(FileName, fmCreate);
  try
    SaveClipboardToStream(FS);
  finally
    FS.Free;
  end;
end;

procedure LoadClipboardFromFile(FileName: string);
{
  从文件中读取数据到剪切版
}
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadClipboardFromStream(FS);
  finally
    FS.Free;
  end;
end;

procedure SaveClipboardToStream(Stream: TStream);
{
  保存剪切版内容到流
}
var
  FormatCount, i, iSize: integer;
  hData: THandle;
  hMem: Pointer;
  PrevFormat: Cardinal;
  Buffer: array[0..255] of char;
begin
  PrevFormat := 0;
  OpenClipboard(GetActiveWindow);

  FormatCount := CountClipboardFormats;
  Stream.Write(FormatCount, SizeOf(FormatCount));

  for i := 1 to FormatCount do
  begin
    iSize := 0;
    FillChar(Buffer, SizeOf(Buffer), 0);

    PrevFormat := EnumClipboardFormats(PrevFormat);
    GetClipboardFormatName(PrevFormat, Buffer, SizeOf(Buffer));

    SaveStringToStream(Stream, StrPas(Buffer));
    Stream.Write(PrevFormat, SizeOf(PrevFormat));

    hData := GetClipboardData(PrevFormat);
    if hData <> 0 then
    begin
      hMem := GlobalLock(hData);
      iSize := GlobalSize(hData);
      Stream.Write(iSize, SizeOf(iSize));
      Stream.Write(hMem^, iSize);
      GlobalUnlock(hData);
    end
    else
    begin
      Stream.Write(iSize, SizeOf(iSize));
    end;
  end;
  CloseClipboard;
end;

procedure LoadClipboardFromStream(Stream: TStream);
{
  读取流内容到剪切版
}
var
  i, iSize, FormatCount: integer;
  Format: Cardinal;
  hMem: THandle;
  hData: Pointer;
  FormatName: string;
  Buffer: array[0..255] of char;
begin
  OpenClipboard(GetActiveWindow);
  EmptyClipboard;
  Stream.Read(FormatCount, SizeOf(FormatCount));

  for i := 1 to FormatCount do
  begin
    FormatName := LoadStringFromStream(Stream);
    Stream.Read(Format, SizeOf(Format));

    FillChar(Buffer, SizeOf(Buffer), 0);
    GetClipboardFormatName(Format, Buffer, SizeOf(Buffer));
    if CompareStr(StrPas(Buffer), FormatName) <> 0 then /// New Format
      Format := RegisterClipboardFormat(PChar(FormatName))
    else
      RegisterClipboardFormat(PChar(FormatName));

    if Stream.Read(iSize, SizeOf(iSize)) <> SizeOf(iSize) then
      raise Exception.Create(SErrReadStream);
    hMem := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, iSize);
    hData := GlobalLock(hMem);
    Stream.Read(hData^, iSize);
    GlobalUnlock(hMem);
    SetClipboardData(Format, hMem);
    GlobalFree(hMem);
  end;
  CloseClipboard;
end;

procedure GetFileList(Files: TStrings; Folder, FileSpec: string; SubDir: Boolean = True; CallBack: TFindFileProc = nil);
{
  获取文件名列表
  Files：用来保存返回的文件名列表
  Folder：需要扫描的文件夹
  FileSpec：文件名，支持通配符*和?
  SubDir：是否包含子目录下的文件
}
var
  SRec: TSearchRec; //Required for Find* functions.
  FFolder: string;
begin
  FFolder := IncludeTrailingPathDelimiter(Folder);
  if FindFirst(FFolder + FileSpec, faAnyFile, SRec) = 0 then
  begin
    repeat
      if Assigned(CallBack) then CallBack(FFolder + SRec.Name, SRec);
      if ((SRec.Attr and faDirectory) <> faDirectory) and (SRec.Name[1] <> '.') then
        Files.Add(FFolder + SRec.Name);
    until FindNext(SRec) <> 0;
    FindClose(SRec);
  end;

  if SubDir then
    if FindFirst(FFolder + '*', faDirectory, SRec) = 0 then
    begin
      repeat
        if ((SRec.Attr and faDirectory) = faDirectory) and (SRec.Name[1] <> '.') then
          GetFileList(Files, FFolder + SRec.Name, FileSpec, SubDir, CallBack);
      until FindNext(SRec) <> 0;
      FindClose(SRec);
    end;
end;

function GetDirSize(Folder, FileSpec: string; SubDir: Boolean = True): Int64;
{
  获取目录大小
  Folder：需要扫描的文件夹
  FileSpec：文件名，支持通配符*和?
  SubDir：是否包含子目录下的文件
}
var
  SRec: TSearchRec; //Required for Find* functions.
  FFolder: string;
begin
  Result := 0;
  FFolder := IncludeTrailingPathDelimiter(Folder);
  if FindFirst(FFolder + FileSpec, faAnyFile, SRec) = 0 then
  begin
    repeat
      if ((SRec.Attr and faDirectory) <> faDirectory) and (SRec.Name[1] <> '.') then
        Result := Result + SRec.FindData.nFileSizeHigh * (Int64(MAXDWORD) + 1) + SRec.FindData.nFileSizeLow;
    until FindNext(SRec) <> 0;
    FindClose(SRec);
  end;

  if SubDir then
    if FindFirst(FFolder + '*', faDirectory, SRec) = 0 then
    begin
      repeat
        if ((SRec.Attr and faDirectory) = faDirectory) and (SRec.Name[1] <> '.') then
          Result := Result + GetDirSize(FFolder + SRec.Name, FileSpec, SubDir);
      until FindNext(SRec) <> 0;
      FindClose(SRec);
    end;
end;

function CRC32File(const FileName: string): integer;
{
  求指定文件的CRC32校验码，返回指定校验码
}
begin
  DWORD(Result) := $FFFFFFFF;
  with TMemoryStream.Create do
  try
    LoadFromFile(FileName);
    if Size > 0 then Result := CRC32(Memory, Size);
  finally
    Free;
  end;
end { CRC32File };

function PackFileName(const fn: string; const len: integer = 67): string;
{
  返回类似C:\...\abc\demo.txt'的文件名
  FN：原文件名，  Len：指定的长度
}
var
  name, path, drv: string;
  buf: array[0..MAX_PATH] of char;
begin
  result := expandfilename(fn);
  if (len >= length(result)) then exit;
  name := extractfilename(result);
  drv := extractfiledrive(result);
  path := copy(extractfilepath(result), 3, length(result) - 3);
  if length(name) > len - 7 then
  begin
    GetShortPathName(pchar(fn), buf, MAX_PATH);
    name := ExtractFileName(buf);
    result := drv + path + name;
    if length(result) < len then exit;
  end;
  repeat
    delete(path, RightPos(path, '\', 2), length(path) - rightpos(path, '\', 2));
    result := drv + path + '...\' + name;
  until length(result) <= len;
end;

function FileSizeEx(const FileName: string): Int64;
{
  返回文件FileName的大小，支持超大文件
}
var
  Info: TWin32FindData;
  Hnd: THandle;
begin
  Result := -1;
  Hnd := FindFirstFile(PChar(FileName), Info);
  if (Hnd <> INVALID_HANDLE_VALUE) then
  begin
    Windows.FindClose(Hnd);
    Int64Rec(Result).Lo := Info.nFileSizeLow;
    Int64Rec(Result).Hi := Info.nFileSizeHigh;
  end;
end;

procedure CreateFileOnDisk(FileName: string);
{
  在磁盘上面创建指定的文件
}
begin
  if not FileExists(FileName) then FileClose(FileCreate(FileName));
end;

function CreateFileOnDiskEx(FileName: string; Size: Int64): Boolean;
{
  在硬盘上面快速创建指定文件大小的文件，支持超大文件
  成功返回True，若文件不存在或磁盘空间不足返回False
  注意：TFileStream不支持超过2GB的文件，本函数可以超过2GB的文件
}
var
  F: HFILE;
begin
  Result := not FileExists(FileName);
  if Result then
  begin
    F := FileCreate(FileName, 0);
    Result := F <> INVALID_HANDLE_VALUE;
    if not Result then Exit;
    SetFilePointer(F, Int64Rec(Size).Lo, @Int64Rec(Size).Hi, FILE_BEGIN);
    SetEndOfFile(F);
    Result := GetLastError = 0;
    FileClose(F);
  end;
end;

function CopyFiles(const Dest: string; const Files: TStrings; const UI: Boolean = False): Boolean;
{
  复制文件对话框
}
var
  fo: TSHFILEOPSTRUCT;
  i: integer;
  FFiles: string;
begin
  for i := 0 to Files.Count - 1 do
    FFiles := FFiles + Files[i] + #0;
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_COPY;
    pFrom := PChar(FFiles + #0);
    pTo := pchar(Dest + #0);
    if UI then
      fFlags := FOF_ALLOWUNDO
    else
      fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR or FOF_ALLOWUNDO;
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function CopyDirectory(const Source, Dest: string; const UI: Boolean = False): boolean;
{
  复制目录对话框
}
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_COPY;
    pFrom := PChar(source + #0);
    pTo := PChar(Dest + #0);
    if UI then
      fFlags := FOF_ALLOWUNDO
    else
      fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR;
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function MoveFiles(DestDir: string; const Files: TStrings; const UI: Boolean = False): Boolean;
{
  移动文件对话框
}
var
  fo: TSHFILEOPSTRUCT;
  i: integer;
  FFiles: string;
begin
  for i := 0 to Files.Count - 1 do
    FFiles := FFiles + Files[i] + #0;
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_MOVE;
    pFrom := PChar(FFiles + #0);
    pTo := pchar(DestDir + #0);
    if UI then
      fFlags := FOF_ALLOWUNDO
    else
      fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR or FOF_ALLOWUNDO;
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function RenameDirectory(const OldName, NewName: string): boolean;
{
  重名名目录
}
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_RENAME;
    pFrom := PChar(OldName + #0);
    pTo := pchar(NewName + #0);
    fFlags := FOF_NOCONFIRMATION + FOF_SILENT + FOF_ALLOWUNDO;
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function DeleteDirectory(const DirName: string; const UI: Boolean = False): Boolean;
{
   删除目录
}
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_DELETE;
    pFrom := PChar(DirName + #0);
    pTo := #0#0;
    fFlags := FOF_NOCONFIRMATION + FOF_SILENT;
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function ClearDirectory(const DirName: string; const IncludeSub, ToRecyle: Boolean): Boolean;
{
  清除目录
}
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_DELETE;
    pFrom := PChar(DirName + '\*.*' + #0);
    pTo := #0#0;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI
      or (Ord(not IncludeSub) * FOF_FILESONLY)
      or (ORd(ToRecyle) or FOF_ALLOWUNDO);
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function DeleteFiles(const Files: TStrings; const ToRecyle: Boolean = True): Boolean;
{
   删除文件,可以删除到回收站中
}
var
  fo: TSHFILEOPSTRUCT;
  i: integer;
  FFiles: string;
begin
  for i := 0 to Files.Count - 1 do
    FFiles := FFiles + Files[i] + #0;
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := GetActiveWindow;
    wFunc := FO_DELETE;
    pFrom := PChar(FFiles + #0);
    pTo := nil;
    if ToRecyle then
      fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION
    else
      fFlags := FOF_NOCONFIRMATION;
  end;
  Result := (SHFileOperation(fo) = 0);
end;

function SplitFile(SourceFile: TFileName; SizeofFiles: Integer; OnProgress: TFileSplitProgress = nil; OutDir: string = ''): Boolean;
{
  分割文件，SourceFile，需要分割的文件，SizeOfFiles，分割后的单个文件的大小
}
var
  i: Word;
  fs, sStream: TFileStream;
  SplitFileName: string;
  Percent: integer;
begin
  fs := TFileStream.Create(SourceFile, fmOpenRead or fmShareDenyWrite);
  try
    for i := 1 to Trunc(fs.Size / SizeofFiles) + 1 do
    begin
      SplitFileName := Format('%s.Part%d.SPF', [SourceFile, i]);
      if OutDir <> '' then
        SplitFileName := IncludeTrailingPathDelimiter(OutDir) + ExtractFileName(SplitFileName);
      sStream := TFileStream.Create(SplitFileName, fmCreate or fmShareExclusive);
      try
        if fs.Size - fs.Position < SizeofFiles then
          SizeofFiles := fs.Size - fs.Position;
        sStream.CopyFrom(fs, SizeofFiles);
        Percent := Round((fs.Position / fs.Size) * 100);
        if Assigned(OnProgress) then OnProgress(Percent);
      finally
        sStream.Free;
      end;
    end;
  finally
    fs.Free;
  end;
  Result := True;
end;

function UnSplitFile(FileName, CombinedFileName: TFileName): Boolean;
{
  合并若干个文件到一个文件
}
var
  i: integer;
  fs, sStream: TFileStream;
begin
  i := 1;
  fs := TFileStream.Create(CombinedFileName, fmCreate or fmShareExclusive);
  try
    while FileExists(FileName) do
    begin
      sStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
      try
        fs.CopyFrom(sStream, 0);
      finally
        sStream.Free;
      end;
      Inc(i);
      FileName := ChangeFileExt(FileName, '.' + FormatFloat('000', i));
    end;
  finally
    fs.Free;
  end;
  Result := True;
end;

function IsFileInUse(const FileName: string): boolean;
{
  判断文件FileName是否正在被打开/使用
}
var
  HFileRes: HFILE;
begin
  if not FileExists(FileName) then
  begin
    Result := False;
    Exit;
  end;

  try
    HFileRes := CreateFile(pchar(FileName), GENERIC_READ,
      0 {this is the trick!}, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    Result := (HFileRes = INVALID_HANDLE_VALUE);
    if not Result then
      CloseHandle(HFileRes);
  except
    Result := true;
  end;
end;

function IsFile(const FileSpec: string): Boolean;
var
  Rec: TSearchRec;
begin
  FindFirst(FileSpec, faAnyFile, Rec);
  Result := Rec.Attr and faDirectory <> faDirectory;
  FindClose(Rec);
end;

function IsDirectory(const FileSpec: string): Boolean;
var
  Rec: TSearchRec;
begin
  FindFirst(FileSpec, faAnyFile, Rec);
  Result := Rec.Attr and faDirectory = faDirectory;
  FindClose(Rec);
end;

function ScanFile(const FileName: string; const Sub: string; caseSensitive: Boolean): Longint;
{
  在文件FileName中扫描Sub出现的位置，CaseSensitive表明是否区分大小写
}
const
  BufferSize = $8001; { 32K+1 bytes }
var
  pBuf, pEnd, pScan, pPos: PChar;
  filesize: LongInt;
  bytesRemaining: LongInt;
  bytesToRead: Integer;
  F: file;
  SearchFor: PChar;
  oldMode: Word;
begin
  { assume failure }
  Result := -1;
  if (Length(Sub) = 0) or (Length(FileName) = 0) then Exit;
  SearchFor := nil;
  pBuf := nil;
  { open file as binary, 1 byte recordsize }
  AssignFile(F, FileName);
  oldMode := FileMode;
  FileMode := 0; { read-only access }
  Reset(F, 1);
  FileMode := oldMode;
  try { allocate memory for buffer and pchar search string }
    SearchFor := StrAlloc(Length(Sub) + 1);
    StrPCopy(SearchFor, Sub);
    if not caseSensitive then { convert to upper case }
      AnsiUpper(SearchFor);
    GetMem(pBuf, BufferSize);
    filesize := System.Filesize(F);
    bytesRemaining := filesize;
    pPos := nil;
    while bytesRemaining > 0 do
    begin
      { calc how many bytes to read this round }
      if bytesRemaining >= BufferSize then
        bytesToRead := Pred(BufferSize)
      else
        bytesToRead := bytesRemaining;
      { read a buffer full and zero-terminate the buffer }
      BlockRead(F, pBuf^, bytesToRead, bytesToRead);
      pEnd := @pBuf[bytesToRead];
      pEnd^ := #0;
      pScan := pBuf;
      while pScan < pEnd do
      begin
        if not caseSensitive then { convert to upper case }
          AnsiUpper(pScan);
        pPos := StrPos(pScan, SearchFor); { search for substring }
        if pPos <> nil then
        begin { Found it! }
          Result := FileSize - bytesRemaining + Longint(pPos) - Longint(pBuf);
          Break;
        end;
        pScan := StrEnd(pScan);
        Inc(pScan);
      end;
      if pPos <> nil then Break;
      bytesRemaining := bytesRemaining - bytesToRead;
      if bytesRemaining > 0 then
      begin
        Seek(F, FilePos(F) - Length(Sub));
        bytesRemaining := bytesRemaining + Length(Sub);
      end;
    end; { While }
  finally
    CloseFile(F);
    if SearchFor <> nil then StrDispose(SearchFor);
    if pBuf <> nil then FreeMem(pBuf, BufferSize);
  end;
end; { ScanFile }

function GetTempFileNameEx(const Path: string = ''; const Prefix3: string = '~~~'; const Create: Boolean = False): string;
{
  返回一个临时文件名
  Path：制定临时文件名的目录
  Prefix3：指定临时文件名的前缀，最多三个字符
  Create：是否创建临时文件
}
var
  F: integer;
begin
  Randomize;
  SetLength(Result, MAX_PATH);
  repeat
    if Create then
      F := 0
    else
      F := Random(MaxInt);
    if Path = '' then
      Windows.GetTempFileName(PChar(TempPath), PChar(Prefix3), F, PChar(Result))
    else if Path = '.' then
      Windows.GetTempFileName(PChar(GetCurrentDir), PChar(Prefix3), F, PChar(Result))
    else
      Windows.GetTempFileName(PChar(Path), PChar(Prefix3), F, PChar(Result));
  until not FileExists(Result) or Create;
  Result := PChar(Result);
end;

function TempPath: string;
{
  返回临时文件夹目录路径
}
begin
  SetLength(Result, GetTempPath(0, PChar(Result)));
  GetTempPath(Length(Result), PChar(Result));
end;

function SystemPath: string;
{
  返回系统文件夹所在路径
}
begin
  SetLength(Result, GetSystemDirectory(nil, 0));
  GetSystemDirectory(PChar(Result), Length(Result));
  Result := PChar(Result);
end;

function WindowsPath: string;
begin
  Result := GetSpecialFolderPath(CSIDL_WINDOWS);
end;

procedure CompressFiles(Files: TStrings; const Filename: string);
{
  压缩多个文件到指定文件中
}
var
  infile, outfile, tmpFile: TFileStream;
  compr: TCompressionStream;
  i, l: Integer;
  s: string;

begin
  if Files.Count > 0 then
  begin
    outFile := TFileStream.Create(Filename, fmCreate);
    try
      { the number of files }
      l := Files.Count;
      outfile.Write(l, SizeOf(l));
      for i := 0 to Files.Count - 1 do
      begin
        infile := TFileStream.Create(Files[i], fmOpenRead);
        try
          { the original filename }
          s := ExtractFilename(Files[i]);
          l := Length(s);
          outfile.Write(l, SizeOf(l));
          outfile.Write(s[1], l);
          { the original filesize }
          l := infile.Size;
          outfile.Write(l, SizeOf(l));
          { compress and store the file temporary}
          tmpFile := TFileStream.Create('tmp', fmCreate);
          compr := TCompressionStream.Create(clMax, tmpfile);
          try
            compr.CopyFrom(infile, l);
          finally
            compr.Free;
            tmpFile.Free;
          end;
          { append the compressed file to the destination file }
          tmpFile := TFileStream.Create('tmp', fmOpenRead);
          try
            outfile.CopyFrom(tmpFile, 0);
          finally
            tmpFile.Free;
          end;
        finally
          infile.Free;
        end;
      end;
    finally
      outfile.Free;
    end;
    DeleteFile('tmp');
  end;
end;

procedure DecompressFiles(const Filename, DestDirectory: string);
{
  从指定文件中解压缩多个文件，该文件必须用CompressFiles压缩！
}
var
  dest, s: string;
  decompr: TDecompressionStream;
  infile, outfile: TFilestream;
  i, l, c: Integer;
begin
  // IncludeTrailingPathDelimiter (D6/D7 only)
  dest := IncludeTrailingPathDelimiter(DestDirectory);

  infile := TFileStream.Create(Filename, fmOpenRead);
  try
    { number of files }
    infile.Read(c, SizeOf(c));
    for i := 1 to c do
    begin
      { read filename }
      infile.Read(l, SizeOf(l));
      SetLength(s, l);
      infile.Read(s[1], l);
      { read filesize }
      infile.Read(l, SizeOf(l));
      { decompress the files and store it }
      s := dest + s; //include the path
      outfile := TFileStream.Create(s, fmCreate);
      decompr := TDecompressionStream.Create(infile);
      try
        outfile.CopyFrom(decompr, l);
      finally
        outfile.Free;
        decompr.Free;
      end;
    end;
  finally
    infile.Free;
  end;
end;

function GetFileTimeEx(FileName: string; const uFlag: Char = 'm'): TDateTime;
{
  返回指定文件FileName的时间，支持创建时间、修改时间、访问时间
  uFlag可以为：C--创建时间，M--修改时间，A--访问时间
}
var
  ffd: TWin32FindData;
  lft: _SYSTEMTIME;
  h: THandle;
begin
  Result := 0;
  h := FindFirstFile(PChar(FileName), ffd);
  if h = INVALID_HANDLE_VALUE then Exit;
  case uFlag of
    'C', 'c': FileTimeToSystemTime(ffd.ftCreationTime, lft);
    'M', 'm': FileTimeToSystemTime(ffd.ftLastWriteTime, lft);
    'A', 'a': FileTimeToSystemTime(ffd.ftLastAccessTime, lft);
  else
    FileTimeToSystemTime(ffd.ftLastAccessTime, lft);
  end;
  SystemTimeToTzSpecificLocalTime(nil, lft, lft);
  Result := SystemTimeToDateTime(lft);
  windows.FindClose(h);
end;

function SetFileTimeEx(const FileName: string; const ATime: TDateTime; TimeType: Char = 'm'): Boolean;
{
  设置指定文件FileName的时间，支持创建时间、修改时间、访问时间
  TimeType可以为： C--创建时间，M--修改时间，A--访问时间
}
var
  Handle: THandle;
  FileTime: TFileTime;
  SysTime: _SYSTEMTIME;
begin
  Result := False;
  DateTimeToSystemTime(ATime, SysTime);
  if not SystemTimeToFileTime(SysTime, FileTime) then Exit;
  Handle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ,
    nil, OPEN_EXISTING, 0, 0);
  if Handle = INVALID_HANDLE_VALUE then Exit;
  case TimeType of
    'C', 'c': Result := SetFileTime(Handle, @FileTime, nil, nil);
    'A', 'a': Result := SetFileTime(Handle, nil, @FileTime, nil);
    'M', 'm': Result := SetFileTime(Handle, nil, nil, @FileTime);
  end;
  CloseHandle(Handle);
end;

function SaveStringToStream(Stream: TStream; const Str: string): integer;
{
  写入字符串到流中，Stream：将写入的流，Str：写入的字符串
  返回值：返回写入的字节数，-1表示出现错误
}
var
  L: integer;
begin
  Result := -1;
  L := Length(Str);
  if Stream.Write(L, SizeOf(L)) = SizeOf(L) then
    Result := Stream.Write(PChar(Str)^, L);
end;

function LoadStringFromStream(Stream: TStream): string;
{
  从流中加在字符串
}
var
  L: integer;
begin
  L := 0;
  if Stream.Read(L, SizeOf(L)) <> SizeOf(L) then Exit;
  SetLength(Result, L);
  FillChar(PChar(Result)^, L, 0);
  if Stream.Read(PChar(Result)^, L) <> L then Result := '';
end;

function LoadPChar(Stream: TStream): PChar;
var
  L : Integer;
begin
  L := Stream.Read(L, SizeOf(L));
  GetMem(Result, L);
  Stream.Read(Result^, L);
end;

function SavePChar(Stream: TStream; Data: PChar; Len: Integer): Boolean; 
begin
  Stream.Write(Len, SizeOf(Len));
  Result := Stream.Write(Data^, Len) = Len;
end;

function SaveStringToStreamLn(Stream: TStream; Msg: string): Boolean;
{
  在流Stream中写入字符串，并写入回车换行符，成功返回True，否则返回False；
}
var
  TmpStr: string;
begin
  TmpStr := Msg + CrLf;
  Result := Stream.Write(PChar(TmpStr)^, Length(TmpStr)) = Length(TmpStr);
end;

function LoadStringFromStreamLn(Stream: TStream; Terminator: string = CrLF): string;
{
  从流中读取一行，碰到回车换行为止，找不到则返回流中当前位置后的所有数据
}
var
  Ch: Char;
begin
  while Stream.Read(Ch, SizeOf(Ch)) = SizeOf(Ch) do
  begin
    Result := Result + Ch;
    if Pos(Terminator, Result) > 0 then Break;
  end;
end;

function WriteToFile(Data: PChar; Len: integer; FileName: string; Appended: Boolean): integer;
{
  写入数据到指定文件，Data，需要写入的数据，Len，写入的字节数
  FileName：需要写入的文件名，Appended：是否追加到最后，否则重写整个文件
  返回写入的字节数
}
begin
  if not FileExists(FileName) then CreateFileOnDisk(FileName);
  with TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite) do
  try
    if Appended then
      Seek(0, soFromEnd)
    else
      Size := 0;
    Result := Write(Data^, Len);
  finally
    Free;
  end;
end;

function ReadFromFile(FileName: string; var Buf; Size: Integer; const Pos: Integer = 0): Integer; overload;
{
  从文件里面指定位置读取数据，返回读取的字节数！
}
begin
  Result := -1;
  if not FileExists(FileName) then Exit;
  
  with TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite) do
  try
    Seek(Pos, soFromBeginning);
    Result := Read(Buf, Size);
  finally
    Free;
  end;   
end;

function SaveStringToFile(Text: string; FileName: string; Appended: Boolean): integer;
{
  保存字符串到文件中
}
begin
  Result := WriteToFile(PChar(Text), Length(Text), FileName, Appended);
end;

function ReadFromFile(FileName: string): string;
{
  读取整个文件并返回整个内容，不做内存检查哦，注意！
}
begin
  if not FileExists(FileName) then Exit;
  with TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone) do
  try
    SetLength(Result, Size);
    Read(PChar(Result)^, Length(Result));
  finally
    Free;
  end;
end;

function AppPath: string;
{
  返回本应用程序的路径
}
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(AppFile));
end;

function AppFile: string;
{
  返回可执行模块的文件名，支持DLL！
}
var
  Buff: array[0..MAX_PATH] of char;
begin
  GetModuleFileName(HInstance, Buff, SizeOf(Buff));
  Result := StrPas(Buff);
end;

function AppFileExt(Ext: string): string;
{
  返回当前可执行程序的同名的指定扩展名的文件名，包含路径,默认扩展名为INI
}
begin
  Result := ChangeFileExt(ParamStr(0), Ext);
end;

procedure DeleteSelf;
{
  删除可执行文件本身，自己删除自己，请在程序的退出之前调用
}
var
  BatchFile: TextFile;
  BatchFileName: string;
  ProcessInfo: TProcessInformation;
  StartUpInfo: TStartupInfo;
begin
  BatchFileName := ExtractFilePath(ParamStr(0)) + '_deleteme.bat';

  AssignFile(BatchFile, BatchFileName);
  Rewrite(BatchFile);

  Writeln(BatchFile, ':try');
  Writeln(BatchFile, 'del "' + ParamStr(0) + '"');
  Writeln(BatchFile,
    'if exist "' + ParamStr(0) + '"' + ' goto try');
  Writeln(BatchFile, 'del %0');
  CloseFile(BatchFile);

  FillChar(StartUpInfo, SizeOf(StartUpInfo), $00);
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartUpInfo.wShowWindow := SW_HIDE;

  if CreateProcess(nil, PChar(BatchFileName), nil, nil,
    False, IDLE_PRIORITY_CLASS, nil, nil, StartUpInfo, ProcessInfo) then
  begin
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
end;

function WipeFile(const FileName: string; const WipeCount: integer = 7): Boolean;
const
  MAX_BUFFER = 1024 * 4;
var
  Buffer: array[0..MAX_BUFFER - 1] of char;
  i: integer;
  FileSize, Remind: Int64;
  FFile: integer;

  procedure RandomBuffer;
  var
    i: integer;
  begin
    for i := Low(Buffer) to High(Buffer) do
      Buffer[i] := Chr(Random(256));
  end;

begin
  Result := False;
  if not FileExists(FileName) then Exit;
  FileSize := FileSizeEx(FileName);

  FFile := FileOpen(FileName, fmOpenReadWrite or fmShareDenyWrite);
  for i := 1 to WipeCount do
  begin
    Remind := FileSize;
    FileSeek(FFile, 0, soFromBeginning);
    while Remind > 0 do
    begin
      RandomBuffer;
      if Remind < SizeOf(Buffer) then
        FileWrite(FFile, Buffer, Remind)
      else
        FileWrite(FFile, Buffer, Sizeof(Buffer));
      Dec(Remind, SizeOf(Buffer));
    end;
    FlushFileBuffers(FFile);
  end;

  FileClose(FFile);
  Result := DeleteFile(FileName);
end;

function UnixPathToDosPath(const Path: string): string;
{
  转换Unix文件名为DOS/Windows文件
}
begin
  Result := TranslateChar(Path, '/', '\');
end;

function DosPathToUnixPath(const Path: string): string;
{
  转换DOS/Windows文件名为Unix文件名
}
begin
  Result := TranslateChar(Path, '\', '/');
end;

procedure ClearDirFiles(const FileSpec: string);
{
  清除指定目录下的所有指定的文件，不处理子目录，速度很快，不保留到回收站！
  正在使用的文件不会被删除！
  警告：该过程不会提示确认删除，请谨慎使用本函数！
  本函数仅适用于Win2k及其以上版本OS
  例如：ClearDirFiles('C:\Temp\*.xml');将删除C:\Temp下所有的XML文件
}
begin
  WinExec(PChar('cmd /c del /q "' + FileSpec + '"'), SW_HIDE);
end;

//////////////////////////////////////////////////////////////////////////////
//       Graph/GDI function & procedure
//////////////////////////////////////////////////////////////////////////////
function FontToString(TextAttr: TFont): string;
begin
  with TextAttr do
    Result := Format('%.8x%.8x%.4x%.4x%.1x%.2x%.1x%.4x%s', [Color, Height, Size,
      Ord(Pitch), Byte(Pitch), CharSet, Byte(Style), Length(Name), Name]);
end;

procedure StringToFont(Str: string; TextAttr: TFont);
var
  Buff: string;
begin
  if Length(Str) < 33 then raise Exception.Create('Error Font Format String');

  Buff := Copy(Str, 1, 8);
  TextAttr.Color := StrToInt('$' + Buff);

  Buff := Copy(Str, 9, 8);
  TextAttr.Height := StrToInt('$' + Buff);

  Buff := Copy(Str, 17, 4);
  TextAttr.Size := StrToInt('$' + Buff);

  Buff := Copy(Str, 21, 4);
  TextAttr.Pitch := TFontPitch(StrToInt('$' + Buff));

  Buff := Copy(Str, 25, 1);
  TextAttr.Pitch := TFontPitch(StrToInt('$' + Buff));

  Buff := Copy(Str, 26, 2);
  TextAttr.Charset := TFontCharSet(StrToInt('$' + Buff));

  Buff := Copy(Str, 28, 1);
  TextAttr.Style := TFontStyles(Byte(StrToInt('$' + Buff)));

  Buff := Copy(Str, 29, 4);
  TextAttr.Name := Copy(Str, 33, StrToInt('$' + Buff));
end;

function RectCenter(ARect: TRect): TPoint;
{
  返回矩形的中心坐标
}
begin
  Result.X := ARect.Left + (ARect.Right - ARect.Left) div 2;
  Result.Y := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
end; { RectCenter }

function PtInPolygon(p: TPoint; Fence: array of TPoint): boolean;
{
  栅栏算法：判断点P是否在封闭区域Fence内，Fence为一组坐标点
}
var
  ar: integer;
  i, j: integer;
begin
  ar := 0;
  for i := Low(Fence) to High(Fence) do
  begin
    j := IfThen(i = High(Fence), 0, i + 1);
    //如果在所站点的水平方向上有栅栏存在
    if ((((p.y >= Fence[i].y) and (p.y < fence[j].y)) or
      ((p.y >= fence[j].y) and (p.y < fence[i].y))) and
      //且栅栏在我的右方
      (p.x < (fence[j].x - fence[i].x) * (p.y - fence[i].y) / (fence[j].y - fence[i].y) + fence[i].x)) then
      ar := Ar + 1;
  end;
  result := (Ar and $1) > 0;
end;

(*
// 判别点(x,y)是否落在多边形内
// 多边形坐标在 xys 中,点数在 nn 中

function isPtInRegion(x, y: single; xys: PXYArray; nn: integer): boolean;
var
  ii, ncross: integer;
  yt, x0, y0, x1, y1, x2, y2: single;
begin
  ncross := 0;
  x0 := x;
  y0 := y;
  for ii := 0 to nn - 2 do
  begin
    x1 := xys^[ii].X;
    y1 := xys^[ii].Y;
    x2 := xys^[ii + 1].X;
    y2 := xys^[ii + 1].Y;
    if ((x0 >= x1) and (x0 = x2) and (x00) and ((ncross mod 2) = 1)) then
      Result := True
    else
      Result := FALSE;
  end;
end;
*)

function GetAreaOfPolygon(Points: array of TPointF): Single;
{
  积分法求多边形面积：Points为多边形各顶点坐标数组
}
var
  Area: Single;
  i: integer;
begin
  Area := 0;
  for i := Low(Points) to High(Points) - 1 do
    Area := Area + (Points[i].y + Points[i + 1].y) * (Points[i].x - Points[i + 1].x) / 2;
  Result := Abs(Area);
end;

function MakeFont(FontName: string; Size, Bold: integer; StrikeOut, Underline, Italy: Boolean): integer;
{
  创建指定的字体
}
begin
  Result := CreateFont(Size, 0, 0, 0, Bold,
    Ord(Italy), Ord(UnderLine), Ord(StrikeOut),
    DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
    DEFAULT_PITCH or FF_DONTCARE, PChar(FontName));
end; { MakeFont }

procedure SetFont(hWnd: HWND; Font: HFONT);
{
  设置控件的字体为指定的字体
}
begin
  SendMessage(hWnd, WM_SETFONT, Font, 0);
end; { SetFont }

function ScreenColors: Integer;
{
  返回当前屏幕的颜色深度
}
var
  vDC: hDC;
begin
  vDC := GetDC(0);
  try
    Result := 1 shl (GetDeviceCaps(vDC, PLANES) * GetDeviceCaps(vDC, BITSPIXEL));
  finally
    ReleaseDC(0, vDC);
  end;
end;

function GetScreenPixel(const Pt: TPoint): integer;
{
  返回当前屏幕上指定点的颜色,返回值为TColor。
}
var
  dc: HDC;
begin
  dc := GetDC(0);
  Result := GetPixel(dc, Pt.X, Pt.Y);
  ReleaseDC(0, dc);
end;

function ColorUnderMouse: integer;
begin
  Result := GetScreenPixel(CurrMousePos);
end;

function ColorToRGB(Color: Integer): Longint;
{
  转换TColor为RGB格式
}
begin
  if Color < 0 then
    Result := GetSysColor(Color and $000000FF)
  else
    Result := Color;
end;

function TColorToHtml(const Color: Integer): string;
{
  转换TColor为HTML格式的颜色表示
}
var
  iRgb: Longint;
  iHtml: Longint;
begin
  // convert system colors to rgb colors
  iRgb := ColorToRGB(Color);
  // change BBGGRR to RRGGBB
  iHtml := ((iRgb and $0000FF) shl 16) or // shift red to the left
  (iRgb and $00FF00) or // green keeps the place
  ((iRgb and $FF0000) shr 16); // shift blue to the right
  // create the html string
  Result := '#' + IntToHex(iHtml, 6);
end;

function HtmlToTColor(Color: string): Integer;
{
  转换HTML颜色为TColor格式的颜色表示，或者字符串表示
  // converts an html color string to a color,
  // can raise an EConvertError exception
  // #0000FF -> clBlue
}
var
  iHtml: Longint;
begin
  // remove the preceding '#'
  if (Length(Color) > 0) and (Color[1] = '#') then
    Delete(Color, 1, 1);
  // convert html string to integer
  iHtml := StrToInt('$' + Color);
  // change RRGGBB to BBGGRR
  Result := ((iHtml and $FF0000) shr 16) or // shift red to the right
  (iHtml and $00FF00) or // green keeps the place
  ((iHtml and $0000FF) shl 16); // shift blue to the left
end;

function HTMLCodeToChar(s : string): WideString;
{
  转化类似 &#nnnn; 的代码为Unicode字符
}
begin
  s := StringReplace(s, '&#', '', []);
  s := StringReplace(s, ';', '', []);
  Result := WideChar(StrToInt(s));
end;

//////////////////////////////////////////////////////////////////////////////
//       Shell Function & Procedure
//////////////////////////////////////////////////////////////////////////////

{-------------------------------------------------------------------------------
  过程名:    GetDisplayName
  作者:      Kingron
  日期:      2004.03.26
  参数:      Folder: IShellFolder; PIDL: PItemIDList; ForParsing: Boolean
  返回值:    string
  说明:      根据Folder返回PIDL的DisplayName
-------------------------------------------------------------------------------}

function GetDisplayName(Folder: IShellFolder; PIDL: PItemIDList; ForParsing: Boolean): string;
var
  StrRet: TStrRet;
  P: PChar;
  Flags: Integer;
begin
  result := '';
  if ForParsing then
    Flags := SHGDN_FORPARSING
  else
    Flags := SHGDN_NORMAL;
  Folder.GetDisplayNameOf(pidl, flags, StrRet);
  case StrRet.uType of
    STRRET_CSTR:
      SetString(Result, StrRet.cStr, StrLen(StrRet.cStr));
    STRRET_OFFSET:
      begin
        P := @PIDL.mkid.abID[StrRet.uOffset - sizeof(PIDL.mkid.cb)];
        SetString(Result, P, PIDL.mkid.cb - StrRet.UOffset);
      end;
  else
    Result := StrRet.pOleStr;
  end;
end;

procedure ShGetFiles(Files: TStrings; Folder: string; SubDir: Boolean);
{-------------------------------------------------------------------------------
  过程名:    ShGetFiles
  作者:      Kingron
  日期:      2004.03.26
  参数:      Files: TStrings; Folder: string; SubDir: Boolean
             Files: 存储返回的文件名列表
             Folder: 需要获取的文件名的目录
             SubDir: 是否包含子目录下的文件
  返回值:    无
  说明:      利用Shell获取文件名列表
-------------------------------------------------------------------------------}
var
  PID: PItemIDList;
  Desktop, ChildFolder: IShellFolder;
  EnumIDList: IEnumIDList;
  Fetched: DWORD;
begin
  /// 获取桌面的Shell对象
  SHGetDesktopFolder(Desktop);
  /// 获取指定目录的PID
  PID := GetPIDLFromPath(Folder);
  /// 绑定ShellFolder和PID，返回绑定后的ShellFolder对象
  Desktop.BindToObject(PID, nil, IID_IShellFolder, ChildFolder);
  if not Assigned(ChildFolder) then
  begin
    FreePIDL(PID);
    Exit;
  end;

  /// 扫描所有的对象
  if Succeeded(ChildFolder.EnumObjects(GetActiveWindow,
    SHCONTF_INCLUDEHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS, EnumIDList)) then
    while EnumIDList.Next(1, PID, Fetched) = S_OK do /// 枚举所有的PID
    begin
      if IsFolder(ChildFolder, PID) then
      begin /// 如果是目录
        if SubDir then
          ShGetFiles(Files, IncludeTrailingPathDelimiter(Folder) + GetDisplayName(ChildFolder, PID, False), SubDir);
      end
      else
        Files.Add(IncludeTrailingPathDelimiter(Folder) + GetDisplayName(ChildFolder, PID, False));

      CoTaskMemFree(PID); // Remember to free PIDLs!
    end;
  FreePidl(PID);
end;

{-------------------------------------------------------------------------------
  过程名:    DlgNewLinkHere
  作者:      Kingron
  日期:      2004.03.26
  参数:      Location: string，需要创建快捷方式的存储目录
  返回值:    无
  说明:      调用创建快捷方式对话框
-------------------------------------------------------------------------------}

procedure DlgNewLinkHere(Location: string);
var
  DLLProc: procedure(OwnerWindow: HWND; DLLInstance: HINST;
    CommandLine: PChar; Show: Integer); stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  pLoc: PChar;
  LibHandle: HINST;
begin
  LibHandle := LoadLibrary('APPWIZ.CPL');
  if LibHandle <> 0 then
  try
    @DLLProc := GetProcAddress(LibHandle, 'NewLinkHere');
    if @DLLProc <> nil then
    begin
      GetMem(pLoc, 1024);
      FillChar(pLoc^, 1024, 0);
      if Length(Location) > 0 then
        Move(Location[1], pLoc^, Length(Location));
      DLLProc(GetActiveWindow, LibHandle, pLoc, SW_SHOW);
      FreeMem(pLoc);
    end;
  finally
    FreeLibrary(LibHandle);
  end;
end;

function CreateShortCut(const sourcefilename, Arguments, DestFileName: string): boolean;
{
  创建快捷方式：SourceFileName为需要创建快捷方式的文件，可以为任意文件名
                Arguments：为快捷方式的参数，对于可执行文件是有用的
                DestFileName：生成的快捷方式的文件名，如果为空则在SourceFileName
                相同目录下生成一个同名快捷方式
}
var
  anobj: IUnknown;
  shlink: IShellLink;
  pFile: IPersistFile;
  wFileName: widestring;
begin
  wFileName := destfilename;
  anobj := CreateComObject(CLSID_SHELLLINK);
  shlink := anobj as IShellLink;
  pFile := anobj as IPersistFile;
  shlink.SetPath(pchar(sourcefilename));
  shlink.SetArguments(pchar(Arguments));
  shlink.SetShowCmd(1);
  if DestFileName = '' then
    wFileName := ChangeFileExt(sourcefilename, 'lnk');
  result := succeeded(pFile.Save(pwchar(wFileName), false));
end;

function ResolveLink(const LnkFileName: string): string;
{
  从LNK文件中找出对应的磁盘文件的的文件名
}
var
  link: IShellLink;
  storage: IPersistFile;
  filedata: TWin32FindData;
  buf: array[0..MAX_PATH] of Char;
  widepath: WideString;
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, link));
  OleCheck(link.QueryInterface(IPersistFile, storage));
  widepath := LnkFileName;
  Result := 'unable to resolve link';
  if Succeeded(storage.Load(@widepath[1], STGM_READ)) then
    if Succeeded(link.Resolve(GetActiveWindow, SLR_NOUPDATE)) then
      if Succeeded(link.GetPath(buf, sizeof(buf), filedata, SLGP_UNCPRIORITY)) then
        Result := buf;
  storage := nil;
  link := nil;
end;

function GetPIDLFromPath(const Path: string): PItemIDList;
{
  返回指定Path对应的PItemIDList，在调用SH函数的时候经常用到PItemIDList哦
}
var
  IDesktopFolder: IShellFolder;
  Dummy: Cardinal;
begin
  SHGetDesktopFolder(IDesktopFolder);
  IDesktopFolder.ParseDisplayName(GetActiveWindow, nil, POleStr(WideString(Path)), Dummy, Result, Dummy);
end;

function GetPathFromPIDL(Pid: PItemIDList): string;
{
  根据PItemIDList返回指定的Path
}
begin
  SetLengthEx(Result, 1024);
  ShGetPathFromIDList(PID, PChar(Result));
end;

function IsFolder(ShellFolder: IShellFolder; ID: PItemIDList): Boolean;
{
  判断ID是否是一个文件夹，是，返回True
}
var
  Flags: UINT;
begin
  Flags := SFGAO_FOLDER;
  ShellFolder.GetAttributesOf(1, ID, Flags);
  Result := SFGAO_FOLDER and Flags <> 0;
end;

function GetImgIndexFromPIDL(pidl: PItemIDList): integer;
{
  返回指定PItemIDList在系统图标里面对应的Index
}
const
  Flags = SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_ICON or SHGFI_SMALLICON;
var
  FileInfo: TSHFileInfo;
begin
  if SHGetFileInfo(PChar(pidl), 0, FileInfo, SizeOf(TSHFileInfo), Flags) = 0 then
    Result := -1
  else
    Result := FileInfo.iIcon;
end;

function NextPIDL(IDList: PItemIDList): PItemIDList;
{
   返回指定PItemIDList对应的下一个PItemIDList
}
begin
  Result := IDList;
  Inc(PChar(Result), IDList^.mkid.cb);
end;

function GetPIDLSize(IDList: PItemIDList): Integer;
{
  返回指定PItemIDList对应的大小，返回值：字节大小
}
begin
  Result := 0;
  if Assigned(IDList) then
  begin
    Result := SizeOf(IDList^.mkid.cb);
    while IDList^.mkid.cb <> 0 do
    begin
      Result := Result + IDList^.mkid.cb;
      IDList := NextPIDL(IDList);
    end;
  end;
end;

function CreatePIDL(Size: Integer): PItemIDList;
{
  创建并返回一个指定字节大小的PItemIDList，Size：大小，按字节
}
var
  Malloc: IMalloc;
  HR: HResult;
begin
  Result := nil;
  HR := SHGetMalloc(Malloc);
  if Failed(HR) then Exit;
  try
    Result := Malloc.Alloc(Size);
    if Assigned(Result) then
      FillChar(Result^, Size, 0);
  finally
  end;
end;

function CopyPIDL(IDList: PItemIDList): PItemIDList;
{
  复制并返回一个PItemIDList
}
var
  Size: Integer;
begin
  Size := GetPIDLSize(IDList);
  Result := CreatePIDL(Size);
  if Assigned(Result) then CopyMemory(Result, IDList, Size);
end;

function ConcatPIDL(IDList1, IDList2: PItemIDList): PItemIDList;
{
  连接两个PItemIDList，返回连接后的PItemIDList
}
var
  cb1, cb2: Integer;
begin
  if Assigned(IDList1) then
    cb1 := GetPIDLSize(IDList1) - SizeOf(IDList1^.mkid.cb)
  else
    cb1 := 0;
  cb2 := GetPIDLSize(IDList2);
  Result := CreatePIDL(cb1 + cb2);
  if Assigned(Result) then
  begin
    if Assigned(IDList1) then CopyMemory(Result, IDList1, cb1);
    CopyMemory(PChar(Result) + cb1, IDList2, cb2);
  end;
end;

procedure FreePidl(pidl: PItemIDList);
{
  释放一个指定的PItemIDList
}
(*  There another method
var
  allocator: IMalloc;
begin
  if Succeeded(shlobj.SHGetMalloc(allocator)) then
  begin
    allocator.Free(pidl);
    {$IFDEF VER90}
    allocator.Release;
    {$ENDIF}
  end;
end;
*)
begin
  CoTaskMemFree(pidl);
end;

function GetSpecialFolderPath(CSIDL: integer): string;
{
  返回系统特殊目录的路径，CSIDL指定特殊目录类型
}
var
  pidl: PItemIDList;
  buf: array[0..MAX_PATH] of char;
begin
  Result := '';
  if Succeeded(ShGetSpecialFolderLocation(GetActiveWindow, CSIDL, pidl)) then
  begin
    if ShGetPathfromIDList(pidl, buf) then Result := buf;
    CoTaskMemFree(pidl);
  end;

  if (Result <> '') and (Result[Length(Result)] <> '\') then Result := Result + '\';
end;

procedure OpenSpecialFolder(CSIDL_Folder: integer);
{
  打开指定的系统目录，例如网上邻居、控制面板、打印机、网络或拨号连接等
}
var
  exInfo: TShellExecuteInfo;
begin
  // initialize all fields to 0
  FillChar(exInfo, SizeOf(exInfo), 0);
  with exInfo do
  begin
    cbSize := SizeOf(exInfo); // required!
    fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_IDLIST;
    Wnd := GetActiveWindow;
    nShow := SW_SHOWNORMAL;
    lpVerb := 'open';
    ShGetSpecialFolderLocation(GetActiveWindow, CSIDL_Folder, PItemIDLIst(lpIDList));
  end;
  ShellExecuteEx(@exInfo);
  CoTaskMemFree(exinfo.lpIDList);
end;

function GetAssociatedIcon(const AExtension: string; ASmall: Boolean): HIcon;
{
  返回对应的扩展名所对应的图标句柄，在显示文件类型图标的时候有用
  AExtension：扩展名，必须包含"."
  ASmall：指明是否返回小图标
}
var
  Info: TSHFileInfo;
  Flags: Cardinal;
begin
  if ASmall then
    Flags := SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES
  else
    Flags := SHGFI_ICON or SHGFI_LARGEICON or SHGFI_USEFILEATTRIBUTES;

  SHGetFileInfo(PChar(AExtension), FILE_ATTRIBUTE_NORMAL, Info, SizeOf(TSHFileInfo), Flags);
  Result := Info.hIcon;
end;

procedure DlgTaskBarProperties;
begin
  WinExec('rundll32.exe shell32.dll,Options_RunDLL 1', SW_SHOW);
end;

procedure CopyFilesToClipboard(FileList: string);
{
  复制文件到剪切板，
}
var
  DropFiles: PDropFiles;
  hGlobal: THandle;
  iLen: Integer;
begin
  iLen := Length(FileList) + 2;
  FileList := FileList + #0#0;
  hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT,
    SizeOf(TDropFiles) + iLen);
  if (hGlobal = 0) then raise Exception.Create('Could not allocate memory.');
  begin
    DropFiles := GlobalLock(hGlobal);
    DropFiles^.pFiles := SizeOf(TDropFiles);
    Move(FileList[1], (PChar(DropFiles) + SizeOf(TDropFiles))^, iLen);
    GlobalUnlock(hGlobal);
    SetClipboardData(CF_HDROP, hGlobal);
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//       System/Infomation function & procedure
//////////////////////////////////////////////////////////////////////////////

type
  _STARTUPINFOW = record
    cb: DWORD;
    lpReserved: LPWSTR;
    lpDesktop: LPWSTR;
    lpTitle: LPWSTR;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: WORD;
    cbReserved2: WORD;
    lpReserved2: Pointer;
    hStdInput: THANDLE;
    hStdOutput: THANDLE;
    hStdError: THANDLE;
  end;

function CreateProcessWithLogonW(lpUsername, lpDomain, lpPassword: LPCWSTR;
  dwLogonFlags: DWORD; lpApplicationName: LPCWSTR; lpCommandLine: LPWSTR;
  dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: LPCWSTR;
  const lpStartupInfo: _STARTUPINFOW; var lpProcessInformation: PROCESS_INFORMATION): BOOL; stdcall; external 'advapi32.dll';

function CreateProcessAsUser(const Cmd, User, Password: widestring): Boolean;
var
  si: _STARTUPINFOW;
  pif: PROCESS_INFORMATION;
begin
  FillChar(si, SizeOf(si), 0);
  si.cb := SizeOf(si);
  si.dwFlags  := STARTF_USESHOWWINDOW;
  si.wShowWindow := SW_SHOWNORMAL;
  si.lpReserved := nil;
  si.lpDesktop := 'winsta0\default';

  Result := CreateProcessWithLogonW(PWidechar(User),
                                    'LYH',
                                    PWideChar(Password),
                                    1{LOGON_WITH_PROFILE},
                                    PWideChar(Cmd),
                                    nil,
                                    CREATE_DEFAULT_ERROR_MODE,
                                    nil,
                                    nil,
                                    si,
                                    pif);
end;

function DecodeMicrosoftDigitalProductID(const DigitalProductID: PChar; Len : Integer): string;
{
  解码微软产品数字ID为可显示字符串，DigitalProcuctID存储在注册表中
  微软许多产品都使用同样的方式来存储，例如Windows的安装序列号，Office的安装序列号等
}
const
  charset = 'BCDFGHJKMPQRTVWXY2346789';
var
  c: array[0..14] of Byte;
  i ,j : Integer;
  a: Cardinal;
begin
  /// 产品数据为第$34字节开始的连续15个字节
  if Len > $34 + 15 then
  begin
    /// 复制第34字节后的15字节数据到缓冲区
    Move(DigitalProductID[$34], c, SizeOf(c));
    for i:= 25 downto 1 do
    begin
      a := 0;
      for j := 14 downto 0 do
      begin
        a := a shl $08;
        Inc(a, c[j]);
        c[j] := (a div $18) and $FF;
        a := a mod $18;
      end;
      if (i mod 5 = 0) and (Result <> '') then Result := '-' + Result;
      Result := charset[a + 1] + Result;
    end;
  end
  else Result := 'N/A';
end;

function GetWindowsProductID: string;
{
  返回Windows的安装序列号
}
const
  RegistryKey = 'Software\Microsoft\Windows NT\CurrentVersion';
  RegistryVal = 'DigitalProductId';
var
  L: Integer;
  b: PChar;
begin
  /// 产品数据为第$34字节开始的连续15个字节
  b := GetMemory(1);
  if RegReadBinary(HKEY_LOCAL_MACHINE, RegistryKey, RegistryVal, b, L) then
    Result := DecodeMicrosoftDigitalProductID(b, L);
end;

function GetOfficeXPProductID: string;
{
  返回Office XP的安装序列号
}
const
  RegistryKey = 'SOFTWARE\MICROSOFT\Office\10.0\Registration';
  RegistryVal = 'DigitalProductId';
var
  L: Integer;
  b: PChar;
begin
  /// 产品数据为第$34字节开始的连续15个字节
  b := GetMemory(1);
  if RegReadBinary(HKEY_LOCAL_MACHINE, RegistryKey, RegistryVal, b, L) then
    Result := DecodeMicrosoftDigitalProductID(b, L);
end;

function IsWorkstationLocked: Boolean;
{
  检测桌面是否已经锁定
}
var
  hDesktop: HDESK;
begin
  Result := False;
  hDesktop := OpenDesktop('default',
    0,
    False,
    DESKTOP_SWITCHDESKTOP);
  if hDesktop <> 0 then
  begin
    Result := not SwitchDesktop(hDesktop);
    CloseDesktop(hDesktop);
  end;
end;

function GetCPUCount: integer;
{
  返回系统CPU的个数，注意：一个至强物理CPU会作为两个返回
}
begin
  Result := GetSystemInfoEx.dwNumberOfProcessors;
end;

function GetCPUInfo(const Index: Integer = 0): string;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('Hardware\Description\System\CentralProcessor\' + IntToStr(Index), False) then
    begin
      if IsWin9x then
        Result := ReadString('VendorIdentifier') + ', ' + ReadString('Identifier')
      else
        Result := Format('%s(%.3fGHz), %s', [Trim(ReadString('ProcessorNameString')),
         ReadInteger('~MHz')/1024, ReadString('Identifier')]);
    end;
  finally
    Free;
  end;
end;

function GetCPUVendor : string;
type
  TVendor = array[0..11] of char;

  function _CPUVendor : TVendor; assembler; register;
  asm
    PUSH    EBX {Save affected register}
    PUSH    EDI
    MOV     EDI,EAX {@Result (TVendor)}
    MOV     EAX,0
    DW      $A20F {CPUID Command}
    MOV     EAX,EBX
    XCHG EBX,ECX     {save ECX result}
    MOV ECX,4
  @1:
    STOSB
    SHR     EAX,8
    LOOP    @1
    MOV     EAX,EDX
    MOV ECX,4
  @2:
    STOSB
    SHR     EAX,8
    LOOP    @2
    MOV     EAX,EBX
    MOV ECX,4
  @3:
    STOSB
    SHR     EAX,8
    LOOP    @3
    POP     EDI {Restore registers}
    POP     EBX
  end;

begin
  Result := _CPUVendor;
end;

function GetCPUSpeed: Double;
{
  返回CPU的速度，根据运算能力得到，不一定是标称速度
}
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  try
    PriorityClass := GetPriorityClass(GetCurrentProcess);
    Priority := GetThreadPriority(GetCurrentThread);
    SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
    Sleep(10);
    asm
      dw 310Fh // rdtsc
      mov TimerLo, eax
      mov TimerHi, edx
    end;
    Sleep(DelayTime);
    asm
      dw 310Fh // rdtsc
      sub eax, TimerLo
      sbb edx, TimerHi
      mov TimerLo, eax
      mov TimerHi, edx
    end;
    SetThreadPriority(GetCurrentThread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
    Result := TimerLo / (1000.0 * DelayTime);
  except
    Result := 0;
  end;
end;

function GetCPUCurrentSpeed: string;
{
  返回CPU当前的速度
}
var
  V : IEnumVARIANT;
  P : OleVariant;
  R : Cardinal;
begin
  V := WMIQuery('select CurrentClockSpeed from Win32_Processor');
  if V.Next(1, P, R) = S_OK then
    Result := P.Properties_.Item('CurrentClockSpeed').Value;
  Result := Result + '~MHz';
end;

function GetComputerNameEx: string;
{
  返回计算机名
}
var
  buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Windows.GetComputerName(@buffer, Size);
  Result := StrPas(buffer);
end;

function GetUserName: string;
{
  返回当前用户名
}
var
  Len: Cardinal;
  Buffer: array[0..512] of char;
begin
  Len := SizeOf(Buffer);
  Windows.GetUserName(Buffer, Len);
  Result := StrPas(Buffer);
end;

function SetMachineTime(LocaleTime: TDateTime): boolean;
{
  设置本地机器的时间，LocaleTime为本地时间
}
var
  SysTime: TSystemTime;
begin
  DateTimeToSystemTime(LocaleTime, SysTime);
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    EnablePrivilege('SeSystemtimePrivilege', True);
  SetLocalTime(SysTime);
  if WinVer < '5.0' then PostMessage(HWND_BROADCAST, WM_TIMECHANGE, 0, 0);
  Result := True;
end;

function WinVer: string;
{
  返回Windows版本信息字符串，格式：X.X，例：5.1
}
begin
  Result := Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]);
end;

function CheckWinVer(Major, Minor: integer): Boolean;
{
  根据主版本号，次版本号进行检查是否与当前OS版本相符，相符，返回True
}
begin
  Result := (Major = Win32MajorVersion) and (Minor = Win32MinorVersion);
end;

function IsWin9x: Boolean;
{
  判断OS是否是Win9x，是：返回True
}
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and (WinVer < '5.0');
end;

function IsWin2K: Boolean;
{
  判断OS是否是Win2k，是：返回True
}
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and (WinVer = '5.0');
end;

function IsWinXP: Boolean;
{
  判断OS是否是WinXP，是：返回True
}
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and (WinVer = '5.1');
end;

function IsWin2003: Boolean;
{
  判断OS是否是Win 2003，是：返回True
}
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and (WinVer = '5.2');
end;

function GetWinVerString: string;
{
  返回Windows OS的版本描述字符串，包含SP
}
var
  S, SN: string;
begin
  S := Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]);
  case Win32Platform of
    VER_PLATFORM_WIN32S: SN := '3.1x running Win32s';
    VER_PLATFORM_WIN32_WINDOWS:
      if S < '4.10' then
        SN := '95'
      else if S < '4.90' then
        SN := '98'
      else
        SN := 'Me';
    VER_PLATFORM_WIN32_NT:
      if S < '5.0' then
        SN := 'NT'
      else if S < '5.1' then
        SN := '2000'
      else if S < '5.2' then
        SN := 'XP'
      else
        SN := 'Server 2003 family';
  end;
  if Win32CSDVersion <> '' then
    Result := Format('Windows %s(%s),Version %s(Build %d)', [SN, Win32CSDVersion, S, Win32BuildNumber])
  else
    Result := Format('Windows %s,Version %s(Build %d)', [SN, S, Win32BuildNumber])
end;

function ReBuildIcon: Boolean;
{
  重建系统图标缓存
}
const
  KEY_NAME = 'Control Panel\Desktop\WindowMetrics';
  KEY_VALUE = 'Shell Icon Size';
var
  strDataRet, strDataRet2: string;

  procedure BroadcastChanges;
  var
    success: DWORD;
  begin
    SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, SPI_SETNONCLIENTMETRICS,
      0, SMTO_ABORTIFHUNG, 10000, success);
  end;

begin
  Result := False;
  strDataRet := RegReadString(HKEY_CURRENT_USER, KEY_NAME, KEY_VALUE);
  if strDataRet <> '' then
  begin
    strDataRet2 := IntToStr(StrToInt(strDataRet) - 1);
    if RegWriteString(HKEY_CURRENT_USER, KEY_NAME, KEY_VALUE, strDataRet2) then
      BroadcastChanges;
    if RegWriteString(HKEY_CURRENT_USER, KEY_NAME, KEY_VALUE, strDataRet) then
      BroadcastChanges;
    Result := True;
  end;
end;

function CreateRestorePoint(Memo: string): Boolean;
{
  创建一个系统返回点，适合于WinXP
}
var
  SC, SR: OLEVariant;
begin
  try
    SC := CreateOLEObject('MSScriptControl.ScriptControl');
    SC.Language := 'VBScript';
    SR := SC.Eval('getobject("winmgmts:\\.\root\default:Systemrestore")');
    Result := SR.CreateRestorePoint(Memo, 0, 100) = 0;
  except
    Result := False;
  end;
end;

function IsAdministrator: Boolean;
{
  判断当前用户是否是超级管理员
}
const
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  SECURITY_NT_AUTHORITY: array[0..5] of Byte = (0, 0, 0, 0, 0, 5);
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
  end;
  if bSuccess then
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
      ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(_SID_IDENTIFIER_AUTHORITY(SECURITY_NT_AUTHORITY), 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
      {$R-}
      for x := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
      {$R+}
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;

procedure GetSystemPrivileges(Privileges: TStrings);
{
  返回系统特权列表，包括描述，特权名和描述之间用：分隔
}
const
  TokenSize = 800; //  (SizeOf(Pointer)=4 *200)
var
  hToken: THandle;
  pTokenInfo: PTOKENPRIVILEGES;
  ReturnLen: Cardinal;
  i: Integer;
  PrivName: PChar;
  DisplayName: PChar;
  NameSize: Cardinal;
  DisplSize: Cardinal;
  LangId: Cardinal;
begin
  GetMem(pTokenInfo, TokenSize);
  if not OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) or
    not GetTokenInformation(hToken, TokenPrivileges, pTokenInfo, TokenSize, ReturnLen) then
    Exit;
  GetMem(PrivName, 255);
  GetMem(DisplayName, 255);
  for i := 0 to pTokenInfo.PrivilegeCount - 1 do
  begin
    DisplSize := 255;
    NameSize := 255;
    {$R-}
    LookupPrivilegeName(nil, pTokenInfo.Privileges[i].Luid, PrivName, Namesize);
    {$R+}
    LookupPrivilegeDisplayName(nil, PrivName, DisplayName, DisplSize, LangId);
    Privileges.Add(PrivName + ':' + DisplayName);
  end;
  FreeMem(PrivName);
  FreeMem(DisplayName);
  FreeMem(pTokenInfo);
end;

function EnablePrivilege(PrivName: string; bEnable: Boolean): Boolean;
{
  允许/禁止指定的系统特权，PrivName：需要设置的特权名称
  返回值：成功设置返回True，否则False
}
var
  hToken: Cardinal;
  TP: TOKEN_PRIVILEGES;
  Dummy: Cardinal;
begin
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);
  TP.PrivilegeCount := 1;
  LookupPrivilegeValue(nil, pchar(PrivName), TP.Privileges[0].Luid);

  if bEnable then
    TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
  else
    TP.Privileges[0].Attributes := 0;
  AdjustTokenPrivileges(hToken, False, TP, SizeOf(TP), nil, Dummy);
  Result := GetLastError = ERROR_SUCCESS;
  CloseHandle(hToken);
end;

procedure GetAccountList(List: TStrings);
{
  返回系统帐户名列表
}
type
  USER_INFO_1 = record
    usri1_name: LPWSTR;
    usri1_password: LPWSTR;
    usri1_password_age: DWORD;
    usri1_priv: DWORD;
    usri1_home_dir: LPWSTR;
    usri1_comment: LPWSTR;
    usri1_flags: DWORD;
    usri1_script_path: LPWSTR;
  end;
  lpUSER_INFO_1 = ^USER_INFO_1;
var
  EntiesRead: integer;
  TotalEntries: DWORD;
  UserInfo: lpUSER_INFO_1;
  lpBuffer: Pointer;
  ResumeHandle: DWORD;
  Counter: Integer;
  NetApiStatus: LongWord;
begin
  ResumeHandle := 0;
  repeat
    NetApiStatus := NetUserEnum(nil, 1, 0, lpBuffer, 0, DWORD(EntiesRead), TotalEntries, ResumeHandle);
    UserInfo := lpBuffer;

    for Counter := 0 to EntiesRead - 1 do
    begin
      List.Add(WideCharToString(UserInfo^.usri1_name) + ^I + UserInfo^.usri1_comment);
      Inc(UserInfo);
    end;

    NetApiBufferFree(lpBuffer);
  until (NetApiStatus <> ERROR_MORE_DATA);
end;

procedure GetFontSizeList(FontName: string; Sizes: TStrings);
{
  返回指定字体的可用字号列表
}

  function EnumFontsSize(var LogFont: TLogFont; var TextMetric: TTextMetric;
    FontType: Integer; Data: Pointer): Integer; stdcall;
    {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
begin
  TStrings(Data).Add(IntToStr(LogFont.lfHeight));
  Result := 1;
end;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, PChar(FontName), @EnumFontsSize, Pointer(Sizes));
  ReleaseDC(0, DC);
end;

procedure GetCurrentApps(Names: TStrings);
{
  返回当前运行的进程的可执行文件名称列表
}
var
  ContinueLoop: BOOL;
  SnapshotHandle, hProcess: THandle;
  ProcessEntry32: TProcessEntry32;
  Buffer: array[0..MAX_PATH] of char;
begin
  SnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  ProcessEntry32.dwSize := Sizeof(ProcessEntry32);
  ContinueLoop := Process32First(SnapshotHandle, ProcessEntry32);
  while ContinueLoop do
  begin
    hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ProcessEntry32.th32ProcessID);
    FillChar(Buffer, SizeOf(Buffer), 0);
    if GetModuleFileNameEx(hProcess, 0, Buffer, SizeOf(Buffer)) > 0 then
      Names.Add(StrPas(Buffer))
    else
      Names.Add(ProcessEntry32.szExeFile);
    ContinueLoop := Process32Next(SnapshotHandle, ProcessEntry32);
  end;
  CloseHandle(SnapshotHandle);
end;

function ShutDownSystem(const uType, Countdown: integer; Msg: string): Boolean;
{
  关闭系统，uType指定关闭类型，具体其功能参考MSDN
}
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    EnablePrivilege('SeShutdownPrivilege', True);
  if Countdown > 0 then
    Result := InitiateSystemShutdown(nil, PChar(Msg) , countdown, False, uType = EWX_REBOOT)
  else
    Result := ExitWindowsEx(uType, 0);
end;

function ShutDownSystemEx(const Computer, Msg: string; const Timeout: integer; Force, Reboot: Boolean): Boolean;
{
  关闭远程系统系统，在使用之前，必须建立一个Net session。
}
begin
  EnablePrivilege('SeShutdownPrivilege', True);
  Result := InitiateSystemShutdown(PChar(Computer), PChar(Msg), Timeout, Force, Reboot);
  EnablePrivilege('SeShutdownPrivilege', False);
end;

function AbortShutdown(const Computer: string): Boolean;
{
  放弃关闭系统
}
begin
  EnablePrivilege('SeShutdownPrivilege', True);
  Result := AbortSystemShutdown(PChar(Computer));
end;

function GetSystemMemoryStatus: TMemoryStatus;
{
  返回系统内存状态
}
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.dwLength := SizeOf(Result);
  GlobalMemoryStatus(Result);
end;

function GetSystemInfoEx: _SYSTEM_INFO;
{
  返回系统信息
}
begin
  FillChar(Result, SizeOf(Result), 0);
  GetSystemInfo(Result);
end;

function GetUserNameFromSID(SID: PSID): string;
var
  UserName, DomainName: array[0..MAX_PATH] of char;
  Dummy: Cardinal;
begin
  Result := '?';
  if SID = nil then Exit;
  LookupAccountSid(nil, SID, UserName, Dummy, DomainName, Dummy, Dummy);
  Result := Format('\\%s\%s', [StrPas(DomainName), StrPas(UserName)]);
end;

function GetIdleTime: DWord;
{
  返回系统Idle时间：多久没有鼠标、键盘动作的时间，单位：毫秒
}
var
  LInput: TLastInputInfo;
begin
  LInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LInput);
  Result := GetTickCount - LInput.dwTime;
end;

function GetCurrentProcessThreadNum:integer;
var
  FSnapshotHandle:THandle;
  FThreadEntry32: TThreadEntry32;
  Ret : BOOL;
  myProcessID:thandle;
  ThreadNum:integer;
begin
  /// 返回当前进程的线程数
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
  FThreadEntry32.dwSize:=Sizeof(FThreadEntry32);
  Ret:=Thread32First(FSnapshotHandle,FThreadEntry32);
  ThreadNum := 0;
  while Ret do
  begin
    myProcessID := FThreadEntry32.th32OwnerProcessID;
    if myProcessID = GetCurrentProcessID then
        ThreadNum := ThreadNum + 1;
     Ret:=Thread32Next(FSnapshotHandle,FThreadEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Result := ThreadNum;
end;


function Li2Double(x: LARGE_INTEGER): Double;
begin
  Result := x.HighPart * 4.294967296E9 + x.LowPart
end;

function GetCPUUsage(var liOldIdleTime, liOldSystemTime: LARGE_INTEGER): string;
{
  返回CPU的利用率
}
type
  TSystem_Basic_Information = packed record
    dwUnknown1: DWORD;
    uKeMaximumIncrement: ULONG;
    uPageSize: ULONG;
    uMmNumberOfPhysicalPages: ULONG;
    uMmLowestPhysicalPage: ULONG;
    uMmHighestPhysicalPage: ULONG;
    uAllocationGranularity: ULONG;
    pLowestUserAddress: Pointer;
    pMmHighestUserAddress: Pointer;
    uKeActiveProcessors: ULONG;
    bKeNumberProcessors: byte;
    bUnknown2: byte;
    wUnknown3: word;
  end;

  TSystem_Performance_Information = packed record
    liIdleTime: LARGE_INTEGER; {LARGE_INTEGER}
    dwSpare: array[0..75] of DWORD;
  end;

  TSystem_Time_Information = packed record
    liKeBootTime: LARGE_INTEGER;
    liKeSystemTime: LARGE_INTEGER;
    liExpTimeZoneBias: LARGE_INTEGER;
    uCurrentTimeZoneId: ULONG;
    dwReserved: DWORD;
  end;

  TNtQuerySystemInformation = function(infoClass: DWORD; buffer: Pointer; bufSize: DWORD; var returnSize: Dword): DWORD; stdcall;
var
  NtQuerySystemInformation: TNtQuerySystemInformation;
  SysBaseInfo: TSystem_Basic_Information;
  SysPerfInfo: TSystem_Performance_Information;
  SysTimeInfo: TSystem_Time_Information;
  status: DWORD; {long}
  dbSystemTime: Double;
  dbIdleTime: Double;
begin
  Result := '<N/A>';

  NtQuerySystemInformation := GetProcAddress(GetModuleHandle('ntdll.dll'), 'NtQuerySystemInformation');
  if @NtQuerySystemInformation = nil then Exit;
  
  if (NtQuerySystemInformation(0, @SysBaseInfo, SizeOf(SysBaseInfo), status) <> 0)
    or (NtQuerySystemInformation(3, @SysTimeInfo, SizeOf(SysTimeInfo), status) <> 0)
    or (NtQuerySystemInformation(2, @SysPerfInfo, SizeOf(SysPerfInfo), status) <> 0) then Exit;

  if liOldIdleTime.QuadPart <> 0 then
  begin
    // CurrentValue = NewValue - OldValue
    dbIdleTime := Li2Double(SysPerfInfo.liIdleTime) - Li2Double(liOldIdleTime);
    dbSystemTime := Li2Double(SysTimeInfo.liKeSystemTime) - Li2Double(liOldSystemTime);

    // CurrentCpuIdle = IdleTime / SystemTime
    dbIdleTime := dbIdleTime / dbSystemTime;

    // CurrentCpuUsage% = 100 - (CurrentCpuIdle * 100) / NumberOfProcessors
    dbIdleTime := 100.0 - dbIdleTime * 100.0 / SysBaseInfo.bKeNumberProcessors{ + 0.5};

    // Show Percentage
    Result := FormatFloat('0.00 %',dbIdleTime);
  end;
  liOldIdleTime := SysPerfInfo.liIdleTime;
  liOldSystemTime := SysTimeInfo.liKeSystemTime;
end;

//////////////////////////////////////////////////////////////////////////////
//       Math function & Procedure
//////////////////////////////////////////////////////////////////////////////

const 
  CsAngleDegree = '°';
  CsAngleMinute = '′';
  CsAngleSecond = '″';
  CSCoordShortTitle: array[boolean, boolean] of string = (('W', 'E'), ('S', 'N'));

function AngleXToStr(Value: Double; LeadZero: Boolean): string;
var
  Plus: Boolean;
  sFormat: string;
begin
  Result := '';
  if Value = 0 then Exit;
  
  Plus := Value >= 0;
  Value := Abs(Value);
  if LeadZero then sFormat := '%s%0.3d%s' else sFormat := '%s%d%s';
  Result := Format(sFormat, [CSCoordShortTitle[False, Plus], Trunc(Value), CsAngleDegree]);

  Value := Abs(Value - Int(Value)) * 60.0;
  if LeadZero then sFormat := '%s%0.2d%s' else sFormat := '%s%d%s';
  Result := Format(sFormat, [Result, Trunc(Value), CsAngleMinute]);

  Value := (Value - Int(Value)) * 60.0;
  if LeadZero then sFormat := '%s%5.2f%s' else sFormat := '%s%0.2f%s';
  Result := Format(sFormat, [Result, Value, CsAngleSecond]);
end;

function AngleYToStr(Value: Double; LeadZero: Boolean): string;
var
  Plus: Boolean;
  sFormat: string;
begin
  Result := '';
  if Value = 0 then Exit;

  Plus := Value >= 0;
  Value := Abs(Value);

  if LeadZero then sFormat := '%s%0.2d%s' else sFormat := '%s%d%s';
  Result := Format(sFormat, [CSCoordShortTitle[True, Plus], Trunc(Value), CsAngleDegree]);

  Value := Abs(Value - Int(Value)) * 60.0;
  if LeadZero then sFormat := '%s%0.2d%s' else sFormat := '%s%d%s';
  Result := Format(sFormat, [Result, Trunc(Value), CsAngleMinute]);

  Value := (Value - Int(Value)) * 60.0;
  if LeadZero then sFormat := '%s%5.2f%s' else sFormat := '%s%0.2f%s';
  Result := Format(sFormat, [Result, Value, CsAngleSecond]);
end; 

const
  CSOperator : array[opAdd..opCmpGE] of string=(
    '+', '-', '*', '/',
    'div', 'mod', 'shl', 'shr',
    'and', 'or', 'xor', 'cmp',
    '-', 'not',
    '=', '<>', '<', '<=', '>', '>=');

function OperatorToStr(const Op : Integer): string;
{
  转换操作符为字符串
}
begin
  Result := CSOperator[Op];
end;

function StrToOperator(const s : string): Integer;
{
  转换字符串为Delphi定义的OP常量
}
begin
  for Result := Low(CSOperator) to High(CSOperator) do
    if SameText(CSOperator[Result], s) then Exit;
  Result := -1;
end;

function PowerMod(Base, Exponent, Modulus: LongWord): LongWord;
{
  求 X^Y mod Z的值，支持超大的数啊，例如求2^103 mod 147的值
}
begin
  Result := 1;
  while Exponent > 0 do
  begin
    if (Exponent and 1) <> 0 then
      Result := Result * Base mod Modulus;
    Base := Base * Base mod Modulus;
    Exponent := Exponent shr 1;
  end;
end;

function GetSphericDistance(const Lat1Deg, Lon1Deg, Lat2Deg, Lon2Deg: Double; const Radius: Double = 6376736.6684): Double;
{
  根据经纬度计算两点之间的坐标，其中Lat1,Lon1Deg,Lat2Deg,Lon2Deg为经纬度坐标
  Radius为球体半径，若要计算地球上面两点距离，则应该是6376736.6684（米）
  注意：计算的距离是假定是一个完全正规的球体！
  支持经纬度正负数表示，Lat1Deg为纬度！
}
var
  Lat1Rad, Lon1Rad, Lat2Rad, Lon2Rad: Double;
begin
  Result := 0;
  if SameValue(Lat1Deg, Lat2Deg) and SameValue(Lon1Deg, Lon2Deg) then Exit;
  
  Lat1Rad := DegToRad(Lat1Deg);
  Lon1Rad := DegToRad(Lon1Deg);
  Lat2Rad := DegToRad(Lat2Deg);
  Lon2Rad := DegToRad(Lon2Deg);
  Result := Radius * ArcCos(Sin(Lat1Rad) *
    Sin(Lat2Rad) +
    Cos(Lat1Rad) *
    Cos(Lat2Rad) *
    Cos(Lon2Rad - Lon1Rad));
end;

function GetDistance(P1, P2: TPoint): integer; overload;
{
  返回点P1和P2之间的距离
}
var
  dx, dy: integer;
begin
  dx := Abs(P1.X - P2.X);
  dy := Abs(P1.Y - P2.Y);
  Result := Round(SQRT(dx * dx + dy * dy));
end;

function GetDistance(X1, Y1, X2, Y2: integer): integer; overload;
{
  返回点(X1,Y1)和(X2,Y2)之间的距离
}
var
  dx, dy: integer;
begin
  dx := Abs(X1 - X2);
  dy := Abs(Y1 - Y2);
  Result := dx * dx + dy * dy;
end;

function GetDistance2(P1, P2: TPoint): integer; overload; { Return Distance SQR of P1,P2 }
{
  返回点P1和P2之间的距离的平方值
}
var
  dx, dy: integer;
begin
  dx := Abs(P1.X - P2.X);
  dy := Abs(P1.Y - P2.Y);
  Result := dx * dx + dy * dy;
end;

function GetDistance2(X1, Y1, X2, Y2: integer): integer; overload;
{
  返回点(X1,Y1)和(X2,Y2)之间的距离的平方值
}
var
  dx, dy: integer;
begin
  dx := Abs(X1 - X2);
  dy := Abs(Y1 - Y2);
  Result := dx * dx + dy * dy;
end;

function GCD(a, b: integer): integer;
{
  返回a和b的最大公因子（公约数）
}
var
  Rest: Integer;
begin
  repeat
    Rest := a mod b;
    a := b;
    b := Rest;
  until Rest = 0;
  Result := Abs(a);
end;

function LCM(a, b: integer): integer;
{
  返回a和b的最小公倍数
}
begin
  Result := a;
  if a = b then Exit;
  while Result mod b <> 0 do
    Inc(Result, a);
end;

function Between(const Value, LowGate, HighGate: integer): Boolean; overload;
{
  判断Value是否在[LowGate,HighGate]内，是：返回True，否，返回False;
}
begin
  Result := (Value >= LowGate) and (Value <= HighGate);
end;

function Between(const Value, LowGate, HighGate: Double): Boolean; overload;
{
  判断Value是否在[LowGate,HighGate]内，是：返回True，否，返回False;
}
begin
  Result := (Value >= LowGate) and (Value <= HighGate);
end;

function Between(const Value, LowGate, HighGate: string): Boolean; overload;
{
  判断Value是否在[LowGate,HighGate]内，是：返回True，否，返回False;
}
begin
  Result := (Value >= LowGate) and (Value <= HighGate);
end;

function BetweenEx(const V1, V2, LowGate, HighGate: integer): Boolean; overload;
{
  判断[V1,V2]是否在[LowGate,HighGate]内，是：返回True，否，返回False;
}
begin
  Result := (V1 >= LowGate) and (V1 <= HighGate) and (V2 >= V1) and (V2 <= HighGate);
end;

function BetweenEx(const V1, V2, LowGate, HighGate: Double): Boolean; overload;
{
  判断[V1,V2]是否在[LowGate,HighGate]内，是：返回True，否，返回False;
}
begin
  Result := (V1 >= LowGate) and (V1 <= HighGate) and (V2 >= V1) and (V2 <= HighGate);
end;

function BetweenEx(const V1, V2, LowGate, HighGate: string): Boolean; overload;
{
  判断[V1,V2]是否在[LowGate,HighGate]内，是：返回True，否，返回False;
}
begin
  Result := (V1 >= LowGate) and (V1 <= HighGate) and (V2 >= V1) and (V2 <= HighGate);
end;

function InterSect(V1, V2, LowG, HighG: Double): Boolean; overload;
{
  判断[V1,V2]和[LowG,HighG]是否有交集，有：返回True，无：返回False;
}
begin
  Result := not ((V1 > HighG) or (V2 < LowG));
end;

function InterSect(V1, V2, LowG, HighG: integer): Boolean; overload;
{
  判断[V1,V2]和[LowG,HighG]是否有交集，有：返回True，无：返回False;
}
begin
  Result := not ((V1 > HighG) or (V2 < LowG));
end;

function RoundEx(Value: Extended): Int64;
{
  修正Delphi四舍五入的BUG的Round函数
}
  procedure Set8087CW(NewCW: Word);
  asm
    MOV     Default8087CW,AX
    FNCLEX
    FLDCW   Default8087CW
  end;

const
  RoundUpCW = $1B32;
var
  OldCW: Word;
begin
  OldCW := Default8087CW;
  try
    Set8087CW(RoundUpCW);
    Result := Round(Value);
  finally
    Set8087CW(OldCW);
  end;
end;

function RoundUp(Value: Extended): Int64;
{
  向上四舍五入取整
}
var
  OldCW: TFPURoundingMode;
begin
  OldCW := GetRoundMode;
  try
    SetRoundMode(rmUp);
    Result := Round(Value);
  finally
    SetRoundMode(OldCW);
  end;
end;

function RoundDown(Value: Extended): Int64;
{
  向下四舍五入取整
}
var
  OldCW: TFPURoundingMode;
begin
  OldCW := GetRoundMode;
  try
    SetRoundMode(rmDown);
    Result := Round(Value);
  finally
    SetRoundMode(OldCW);
  end;
end;

function GetByteFromInt(const AInt, AOffset: Integer): Byte;
begin
  if (AOffset < 0) or (AOffset > 3) then
    raise ERangeError.Create('Out of range');  
  Result := IntRec(AInt).Bytes[AOffset];
end;

function CheckBit(const Value: DWORD; const BitFrom0: Byte): Boolean;
{
  检查指定位是否为1，是，返回True，否则，返回False
  Value，主要检查的值，BitFrom0，检查的位，从0开始
}
begin
  result := ((Value shr BitFrom0) and 1) = 1;
end;

function GetBit(const Value: DWORD; const BitFrom0: Byte): Byte;
begin
  Result := (Value shr BitFrom0) and 1;
end;

function BitOn(Value: dword; const BitFrom0: byte): dword;
{
  设置指定的位为1，Value：需要设置的值，BitFrom0：需要设定的位，从0开始
}
begin
  result := Value or (1 shl BitFrom0);
end;

function BitOff(const Value: dword; const BitFrom0: Byte): dword;
{
  设置指定的位为0，Value：需要设置的值，BitFrom0：需要设置的位，从0开始
}
begin
  result := Value xor (1 shr BitFrom0);
end;

function xhl(const B: Byte): Byte; overload;
{
  交换高低字节
}
asm
  rol al, 4   /// 循环左移4位即可
end;

function xhl(const W: word): word; overload;
{
  交换高低字节
}
asm
  // xchg ah,al
  rol ax, 8   /// 循环左移8位即可
end;

function xhl(const DW: DWord): Dword; overload;
{
  交换高低字节
}
asm
  rol eax, 16    /// 循环左移16位即可
end;

function ROL(val: LongWord; shift: Byte): LongWord; assembler;
{
  算术（循环）左移
}
asm
  mov  eax, val;
  mov  cl, shift;
  rol  eax, cl;
end;

function ROR(val: LongWord; shift: Byte): LongWord; assembler;
{
  算术（循环）右移
}
asm
  mov  eax, val;
  mov  cl, shift;
  ror  eax, cl;
end;

procedure QuickSort(AList: TList; CompareProc: TListSortCompare);
{
  快速排序一个列表
}
  procedure FQuickSort(SortList: PPointerList; L, R: Integer; SCompare: TListSortCompare);
  var
    I, J: Integer;
    P, T: Pointer;
  begin
    repeat
      I := L;
      J := R;
      P := SortList^[(L + R) shr 1];
      repeat
        while SCompare(SortList^[I], P) < 0 do
          Inc(I);
        while SCompare(SortList^[J], P) > 0 do
          Dec(J);
        if I <= J then
        begin
          T := SortList^[I];
          SortList^[I] := SortList^[J];
          SortList^[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        FQuickSort(SortList, L, J, SCompare);
      L := I;
    until I >= R;
  end;
begin
  if Assigned(AList) and (AList.Count > 1) then
    FQuickSort(AList.List, 0, AList.Count - 1, CompareProc);
end;

procedure QuickSort(AList: array of Pointer; CompareProc: TListSortCompare);
  procedure FQuickSort(SortList: array of Pointer; L, R: Integer; SCompare: TListSortCompare);
  var
    I, J: Integer;
    P, T: Pointer;
  begin
    repeat
      I := L;
      J := R;
      P := SortList[(L + R) shr 1];
      repeat
        while SCompare(SortList[I], P) < 0 do
          Inc(I);
        while SCompare(SortList[J], P) > 0 do
          Dec(J);
        if I <= J then
        begin
          T := SortList[I];
          SortList[I] := SortList[J];
          SortList[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        FQuickSort(SortList, L, J, SCompare);
      L := I;
    until I >= R;
  end;
begin
  if Length(AList) > 1 then
    FQuickSort(AList, Low(AList), High(AList), CompareProc);
end;

function BinSearch(IntArray: array of integer; Value: integer): integer;
{
  二分查找法，返回Value在IntArray中的索引，IntArray必须已经升序排序
}
var
  mid, MidValue, L, H: integer;
begin
  result := -1;
  L := Low(IntArray);
  H := High(IntArray);
  while (L <= H) do
  begin
    Mid := Trunc((H + L) / 2);
    MIdvalue := IntArray[Mid];
    if Value = Midvalue then
    begin
      result := Mid;
      Break;
    end
    else if Value < Midvalue then
      H := Mid - 1
    else
      L := Mid + 1;
  end;
end;

function SearchExpression(mNumbers: array of Integer; mDest: Integer): string;
{
  类似加减乘除求24的代码
  修改:Zswang
  日期:2003-03-17
  支持:wjhu111@21cn.com
  例： SearchExpression([5, 5, 5, 1], 24);
}
const
  cPrecision = 1E-6;
var
  vNumbers: array of Extended;
  vExpressions: array of string;
  vLength: Integer;

  function fSearchExpression(mLevel: Integer): Boolean;
  var
    I, J: Integer;
    A, B: Extended;
    vExpA, vExpB: string;
  begin
    Result := True;
    if (mLevel <= 1) and (Abs(vNumbers[0] - mDest) <= cPrecision) then Exit;

    for I := 0 to mLevel - 1 do
    begin
      for J := I + 1 to mLevel - 1 do
      begin
        A := vNumbers[I];
        B := vNumbers[J];
        vNumbers[J] := vNumbers[mLevel - 1];

        vExpA := vExpressions[I];
        vExpB := vExpressions[J];
        vExpressions[J] := vExpressions[mLevel - 1];

        vExpressions[I] := '(' + vExpA + '+' + vExpB + ')';
        vNumbers[I] := A + B;
        if fSearchExpression(mLevel - 1) then Exit;
        vExpressions[I] := '(' + vExpA + '-' + vExpB + ')';
        vNumbers[I] := A - B;
        if fSearchExpression(mLevel - 1) then Exit;
        vExpressions[I] := '(' + vExpB + '-' + vExpA + ')';
        vNumbers[I] := B - A;
        if fSearchExpression(mLevel - 1) then Exit;
        vExpressions[I] := '(' + vExpA + '*' + vExpB + ')';
        vNumbers[I] := A * B;
        if fSearchExpression(mLevel - 1) then Exit;
        if B <> 0 then
        begin
          vExpressions[I] := '(' + vExpA + '/' + vExpB + ')';
          vNumbers[I] := A / B;
          if fSearchExpression(mLevel - 1) then Exit;
        end;
        if A <> 0 then
        begin
          vExpressions[I] := '(' + vExpB + '/' + vExpA + ')';
          vNumbers[I] := B / A;
          if fSearchExpression(mLevel - 1) then Exit;
        end;
        vNumbers[I] := A;
        vNumbers[J] := B;
        vExpressions[I] := vExpA;
        vExpressions[J] := vExpB;
      end;
    end;
    Result := False;
  end;

var
  I: Integer;
begin
  vLength := Length(mNumbers);
  SetLength(vNumbers, vLength);
  SetLength(vExpressions, vLength);
  for I := 0 to vLength - 1 do
  begin
    vNumbers[I] := mNumbers[I];
    vExpressions[I] := IntToStr(mNumbers[I]);
  end;
  if fSearchExpression(vLength) then
    Result := vExpressions[0]
  else
    Result := '';
  vNumbers := nil;
  vExpressions := nil;
end;

function AddEx(A, B: string): string;
{
  无限位数加法，支持小数！
  作者： ZSWang
  返回：A + B
}
var
  I: Integer;
  T: Integer;
begin
  Result := '';
  if Pos('.', A) <= 0 then A := A + '.'; //没有有小数点补小数点
  if Pos('.', B) <= 0 then B := B + '.'; //没有有小数点补小数点
  I := Max(Length(LeftPart(A, '.')), Length(LeftPart(B, '.'))); //整数部分最大长度
  A := DupeString('0', I - Length(LeftPart(A, '.'))) + A; //整数前补0
  B := DupeString('0', I - Length(LeftPart(B, '.'))) + B; //整数前补0
  T := Max(Length(RightPart(A, '.')), Length(RightPart(B, '.'))); //小数部分最大长度
  A := A + DupeString('0', T - Length(RightPart(A, '.'))); //小数后补0
  B := B + DupeString('0', T - Length(RightPart(B, '.'))); //小数后补0
  I := I + T + 1; //计算总长度//小数长度和整数长度加上小数点长度
  T := 0; //进位数初始化
  for I := I downto 1 do //从后向前扫描
    if [A[I], B[I]] <> ['.'] then
    begin //不是小数点时
      T := StrToIntDef(A[I], 0) + T; //累加当前数位
      T := StrToIntDef(B[I], 0) + T; //累加当前数位
      Result := IntToStr(T mod 10) + Result; //计算当前数位上的数字
      T := T div 10; //计算进位数
    end
    else
      Result := '.' + Result; //加上小数点
  if T <> 0 then Result := IntToStr(T mod 10) + Result; //处理进位数
  while Pos('0', Result) = 1 do
    Delete(Result, 1, 1); //排除整数前无效的0
  while Copy(Result, Length(Result), 1) = '0' do
    Delete(Result, Length(Result), 1); //排除小数后无效的0
  if Copy(Result, Length(Result), 1) = '.' then
    Delete(Result, Length(Result), 1); //排除无效小数点
  if Copy(Result, 1, 1) = '.' then Result := '0' + Result; //处理无0小数情况
  if (Result = '') then Result := '0'; //处理空字符情况
end; { AddEx }

function SubEx(A, B: string): string;
{
  无限位数减法，支持小数
  返回：B - A
  作者：ZSWang，EHomsoft
}
var
  I: Integer;
  T: Integer;
  TemNumA: string;
  minus: Boolean;
begin
  Result := '';
  if Pos('.', A) <= 0 then A := A + '.'; //没有有小数点补小数点
  if Pos('.', B) <= 0 then B := B + '.'; //没有有小数点补小数点
  I := Max(Length(LeftPart(A, '.')), Length(LeftPart(B, '.'))); //整数部分最大长度
  A := DupeString('0', I - Length(LeftPart(A, '.'))) + A; //整数前补0
  B := DupeString('0', I - Length(LeftPart(B, '.'))) + B; //整数前补0
  T := Max(Length(RightPart(A, '.')), Length(RightPart(B, '.'))); //小数部分最大长度
  if ((Length(LeftPart(A, '.'))) < (Length(LeftPart(B, '.')))) or (((Length(LeftPart(A, '.'))) = (Length(LeftPart(B, '.')))) and (B < A)) then
  begin
    TemNumA := A;
    A := B + DupeString('0', T - Length(RightPart(B, '.'))); //小数后补0
    B := TemNumA + DupeString('0', T - Length(RightPart(TemNumA, '.'))); //小数后补0
    minus := True;
  end
  else
  begin
    A := A + DupeString('0', T - Length(RightPart(A, '.'))); //小数后补0
    B := B + DupeString('0', T - Length(RightPart(B, '.'))); //小数后补0
    minus := False;
  end;
  I := I + T + 1; //计算总长度//小数长度和整数长度加上小数点长度
  T := 0; //进位数初始化
  for I := I downto 1 do //从后向前扫描
    if [A[I], B[I]] <> ['.'] then
    begin //不是小数点时
      T := StrToIntDef(A[I], 0) - T; //累加当前数位
      T := StrToIntDef(B[I], 0) - T; //累加当前数位
      if (T < 0) and (I <> 1) then
      begin
        T := T + 10;
        Result := IntToStr(T mod 10) + Result; //计算当前数位上的数字
        T := -1; //计算进位数
      end
      else
      begin
        Result := IntToStr(T mod 10) + Result; //计算当前数位上的数字
        T := T div 10; //计算进位数
      end;
    end
    else
      Result := '.' + Result; //加上小数点
  if T <> 0 then Result := IntToStr(T mod 10) + Result; //处理进位数
  while Pos('0', Result) = 1 do
    Delete(Result, 1, 1); //排除整数前无效的0
  while Copy(Result, Length(Result), 1) = '0' do
    Delete(Result, Length(Result), 1); //排除小数后无效的0
  if Copy(Result, Length(Result), 1) = '.' then
    Delete(Result, Length(Result), 1); //排除无效小数点
  if Copy(Result, 1, 1) = '.' then Result := '0' + Result; //处理无0小数情况
  if (Result = '') then Result := '0'; //处理空字符情况
  if minus then Result := '-' + Result;
end;

function MultEx(A, B: string): string;
{
  无限位数乘法
  作者：ZSWang
  返回： A * B
}

  function fMult(mNumber: string; mByte: Byte): string; { 无限位数乘法子函数 }
  var
    I: Integer;
    T: Integer;
  begin
    Result := '';
    T := 0;
    for I := Length(mNumber) downto 1 do
    begin //从后向前扫描
      T := StrToIntDef(mNumber[I], 0) * mByte + T; //累加当前数位
      Result := IntToStr(T mod 10) + Result; //计算当前数位上的数字
      T := T div 10; //计算进位数
    end;
    if T <> 0 then Result := IntToStr(T mod 10) + Result; //处理进位数
  end; { fMult }

var
  I: Integer;
  vDecimal: Integer; //小数位数
  T: string;
begin
  Result := '';
  ///////Begin 处理小数
  if Pos('.', A) <= 0 then A := A + '.'; //没有有小数点补小数点
  if Pos('.', B) <= 0 then B := B + '.'; //没有有小数点补小数点
  vDecimal := Length(RightPart(A, '.')) + Length(RightPart(B, '.')); //计算小数位数
  A := LeftPart(A, '.') + RightPart(A, '.'); //删除小数点
  B := LeftPart(B, '.') + RightPart(B, '.'); //删除小数点
  ///////End 处理小数
  T := '';
  for I := Length(B) downto 1 do
  begin
    Result := AddEx(Result, fMult(A, StrToIntDef(B[I], 0)) + T);
    T := T + '0';
  end;
  Insert('.', Result, Length(Result) - vDecimal + 1);
  while Pos('0', Result) = 1 do
    Delete(Result, 1, 1); //排除整数前无效的0
  while Copy(Result, Length(Result), 1) = '0' do
    Delete(Result, Length(Result), 1); //排除小数后无效的0
  if Copy(Result, Length(Result), 1) = '.' then
    Delete(Result, Length(Result), 1); //排除无效小数点
  if Copy(Result, 1, 1) = '.' then Result := '0' + Result; //处理无0小数情况
  if (Result = '') then Result := '0'; //处理空字符情况
end; { MultEx }

function DivEx(A, B: string; n: integer): string;
{
  无限位数除法
  返回：B / A
  作者：ZSWang
}

  function vDecimal(mNumber: string): integer;
  var
    m, x: integer;
  begin
    x := 0;
    if Pos('.', mNumber) <= 0 then
    begin
      for m := Length(mNumber) downto 1 do
      begin
        if mNumber[m] = '0' then
          x := x + 1
        else
          Break;
      end;
      Result := -x;
    end
    else
      Result := Length(RightPart(mNumber, '.'));
  end;

  function formatnum(mNumber: string): string;
  var
    m: integer;
    TemStr: string;
  begin
    Result := '';
    for m := 1 to Length(mNumber) do
    begin
      if mNumber[m] = '.' then
        Result := Result + '.'
      else
        Result := Result + IntToStr(StrToIntDef(mNumber[m], 0));
    end;
    while Pos('0', Result) = 1 do
      Delete(Result, 1, 1); //排除整数前无效的0
    if Pos('.', Result) <= 0 then Result := Result + '.'; //没有有小数点补小数点
    TemStr := RightPart(Result, '.');
    while Copy(TemStr, Length(TemStr), 1) = '0' do
      Delete(TemStr, Length(TemStr), 1); //排除小数后无效的0
    Result := LeftPart(Result, '.') + '.' + TemStr;
    if Copy(Result, Length(Result), 1) = '.' then Delete(Result, Length(Result), 1); //排除无效小数点
    if Result[1] = '.' then Result := '0' + Result;
    if (Result = '') then Result := '0';
  end;

  function formatnum2(mNumber: string): string;
  begin
    Result := mNumber;
    if Pos('.', Result) <= 0 then Result := Result + '.';
    Result := LeftPart(Result, '.') + RightPart(Result, '.');
    while Pos('0', Result) = 1 do
      Delete(Result, 1, 1);
    while Copy(Result, Length(Result), 1) = '0' do
      Delete(Result, Length(Result), 1);
  end;

var
  I, J, t, v, y, Len: Integer;
  TemSub, TemNum: string;
begin
  Result := '';
  A := formatnum(A);
  B := formatnum(B);
  v := vDecimal(A) - vDecimal(B);
  A := formatnum2(A);
  B := formatnum2(B);
  if B = '' then
    Result := 'Err'
  else if A = '' then
    Result := '0'
  else
  begin
    I := 0;
    if Length(A) > Length(B) then
      Len := Length(B)
    else
      Len := Length(A);
    if Copy(A, 1, Len) >= Copy(B, 1, Len) then
      J := Length(B)
    else
      J := Length(B) + 1;
    for y := 1 to J do
    begin
      if Length(A) >= y then
        TemSub := TemSub + A[y]
      else
      begin
        TemSub := TemSub + '0';
        v := v + 1;
      end;
    end;
    while I <= n do
    begin
      if TemSub[1] > B[1] then
        t := StrToInt(TemSub[1]) div StrToInt(B[1])
      else
        t := StrToInt(TemSub[1] + TemSub[2]) div StrToInt(B[1]);
      TemNum := MultEx(B, IntToStr(t));
      while (Length(TemNum) > Length(TemSub)) or ((Length(TemNum) = Length(TemSub)) and (TemNum > TemSub)) do
      begin
        t := t - 1;
        TemNum := MultEx(B, IntToStr(t));
      end;
      Result := Result + IntToStr(t);
      I := I + 1;
      TemSub := SubEx(TemSub, TemNum);
      if (TemSub = '0') and (Length(A) < J) then
      begin
        v := v + 1;
        Break;
      end;
      if TemSub = '0' then TemSub := '';
      J := J + 1;
      if Length(A) >= J then
      begin
        TemSub := TemSub + A[J];
      end
      else
      begin
        TemSub := TemSub + '0';
        v := v + 1;
      end;
    end;
    if Length(A) >= J then
      v := v - (Length(A) - J) - 1
    else
      v := v - 1;
    while Copy(Result, Length(Result), 1) = '0' do
    begin
      v := v - 1;
      Delete(Result, Length(Result), 1);
    end;
    if v > Length(Result) then
      Result := '.' + DupeString('0', v - Length(Result)) + Result
    else if v > 0 then
      Insert('.', Result, Length(Result) - v + 1);
    if v < 0 then Result := Result + DupeString('0', 0 - v);
    if Copy(Result, 1, 1) = '.' then Result := '0' + Result;
  end;
end; { DivEx }

function Calc(mText: string): string;
{
  计算简单的数学表达式，支持加减乘除，括号
  作者: ZSWang
}

  procedure Bracket(mText: string; var nLStr, nCStr, nRStr: string);
  var
    L, R: Integer;
    I: Integer;
    B: Boolean;
  begin
    nLStr := '';
    nCStr := '';
    nRStr := '';
    B := True;
    L := 0;
    R := 0;
    for I := 1 to Length(mText) do
      if B then
      begin
        if mText[I] = '(' then
          Inc(L)
        else if mText[I] = ')' then
          Inc(R);
        if L = 0 then
          nLStr := nLStr + mText[I]
        else if L > R then
          nCStr := nCStr + mText[I]
        else
          B := False;
      end
      else
        nRStr := nRStr + mText[I];
    Delete(nCStr, 1, 1);
  end; { Bracket }

var
  vText: string;

  function fCalc(mText: string): string;
  var
    vLStr, vCStr, vRStr: string;
    I, J, K, L: Integer;
  begin
    L := Length(mText);
    if Pos('(', mText) > 0 then
    begin
      Bracket(mText, vLStr, vCStr, vRStr);
      Result := fCalc(vLStr + fCalc(vCStr) + vRStr);
      //              ~
    end
    else if (Pos('+', mText) > 0) or (Pos('-', mText) > 0) then
    begin
      I := Pos('+', mText);
      J := Pos('-', mText);
      if I = 0 then I := L;
      if J = 0 then J := L;
      K := Min(I, J);
      vLStr := Copy(mText, 1, Pred(K));
      vRStr := Copy(mText, Succ(K), L);
      if vLStr = '' then vLStr := '0';
      if vRStr = '' then vRStr := '0';
      if I = K then
        Result := FloatToStr(StrToFloat(fCalc(vLStr)) + StrToFloat(fCalc(vRStr)))
      else
        Result := FloatToStr(StrToFloat(fCalc(vLStr)) - StrToFloat(fCalc(vRStr)))
    end
    else if (Pos('*', mText) > 0) or (Pos('/', mText) > 0) then
    begin
      I := Pos('*', mText);
      J := Pos('/', mText);
      if I = 0 then I := L;
      if J = 0 then J := L;
      K := Min(I, J);
      vLStr := Copy(mText, 1, Pred(K));
      vRStr := Copy(mText, Succ(K), L);
      if vLStr = '' then vLStr := '0';
      if vRStr = '' then vRStr := '0';
      if I = K then
        Result := FloatToStr(StrToFloat(fCalc(vLStr)) * StrToFloat(fCalc(vRStr)))
      else
        Result := FloatToStr(StrToFloat(fCalc(vLStr)) / StrToFloat(fCalc(vRStr)))
    end
    else if Pos('_', mText) = 1 then
      Result := FloatToStr(-StrToFloat(fCalc(Copy(mText, 2, L))))
    else
      Result := FloatToStr(StrToFloat(mText));
  end;
var
  I, L: Integer;
begin
  vText := '';
  L := Length(mText);
  for I := 1 to L do
    if (mText[I] = '-') and (I < L) and (not (mText[Succ(I)] in ['+', '-', '(', ')'])) then
      if (I = 1) or ((I > 1) and (mText[Pred(I)] in ['*', '/'])) then
        vText := vText + '_'
      else if ((I > 1) and (mText[Pred(I)] in ['+', '-'])) or
      ((I > 1) and (mText[Pred(I)] = ')') and (I < L) and
        (not (mText[Succ(I)] in ['+', '-', '(', ')']))) then
        vText := vText + '+_'
      else
        vText := vText + mText[I]
    else
      vText := vText + mText[I];
  Result := fCalc(vText);
end; { Calc }

function PermutationCombination(mArr: array of string; mStrings: TStrings): Boolean;
{
  对mArr中的每一个元素进行排列组合，所有可能的组合保存在mString中
  作者：ZSWang
  例：PermutationCombination(['ACDE', 'FGH', 'IJKL', 'MNO', 'PQRST'], Memo1.Lines)
}
var
  I, J: Integer;
  T: string;
  S: string;
begin
  Result := False;
  if not Assigned(mStrings) then Exit;
  mStrings.Clear;
  T := '';
  for I := Low(mArr) to High(mArr) do
    if mArr[I] <> '' then
    begin
      T := T + mArr[I][1];
      S := S + mArr[I][Length(mArr[I])];
    end
    else
      Exit;
  while T <> S do
  try
    mStrings.Add(T);
    J := Length(S);
    for I := High(mArr) downto Low(mArr) do
    begin
      if Pos(T[J], mArr[I]) >= Length(mArr[I]) then
        T[J] := mArr[I][1]
      else
      begin
        T[J] := mArr[I][Pos(T[J], mArr[I]) + 1];
        Break;
      end;
      Dec(J);
    end;
    mStrings.Add(S);
  except
    Exit;
  end;
  Result := True;
end; { PermutationCombination }

const
  cScaleChar = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

function IntPower(Base, Exponent: Integer): Integer;
{
  返回Base的Exponent次方
}
var
  I: Integer;
begin
  Result := 1;
  for I := 1 to Exponent do
    Result := Result * Base;
end; { IntPower }

function IntToDigit(mNumber: Integer; mScale: Byte; mLength: Integer = 0): string;
{
  返回整数的进制表示;mScale指定多少进制;mLength指定长度,长度不足时向前补0
}
var
  I, J: Integer;
begin
  Result := '';
  I := mNumber;
  while (I >= mScale) and (mScale > 1) do
  begin
    J := I mod mScale;
    I := I div mScale;
    Result := cScaleChar[J + 1] + Result;
  end;
  Result := cScaleChar[I + 1] + Result;
  for I := 1 to mLength - Length(Result) do
    Result := '0' + Result;
end; { IntToDigit }

function DigitToInt(mDigit: string; mScale: Byte): DWORD;
{
  返回进制表示转换成整数;mScale指定多少进制
}
var
  I: Byte;
  L: Integer;
begin
  Result := 0;
  mDigit := UpperCase(mDigit);
  L := Length(mDigit);
  for I := 1 to L do
    Result := Result + DWORD((Pos(mDigit[L - I + 1], cScaleChar) - 1) * (IntPower(mScale, I - 1)));
end; { DigitToInt }

function BinToInt(const Bin: string): DWORD;
begin
  if (not CheckChars(Bin, ['0', '1'])) or (Length(Bin) > 32) then
    raise Exception.CreateFmt(SErrBinString, [Bin]);
  Result := DigitToInt(Bin, 2);
end;

function IntToBin(const Int: DWORD): string;
{
  转换整数为二进制串
}
const
  S: array[0..1] of char = ('0', '1');
var
  i: Byte;
  P: PChar;
  B: array[0..3] of Byte absolute Int;
begin
  Result := '0';
  if Int = 0 then Exit;

  for i := 7 downto 0 do
    Result := Result + S[(Int shr i) and 1];
  P := PChar(Result);
  while P^ = '0' do
    Inc(P);
  Result := P;
end;

function BaseConvert(NumIn: string; BaseIn: Byte; BaseOut: Byte): string;
{
  任意进制之间进行转换
  NumIn：需要转换的字符串
  BaseIn：需要转换字符串的基，BaseOut：转出的基
  例:  BaseConvert('FFFF', 16, 10); returns '65535'
}
var
  i: integer;
  currentCharacter: char;
  CharacterValue: Integer;
  PlaceValue: Integer;
  RunningTotal: Double;
  Remainder: Double;
  BaseOutDouble: Double;
  NumInCaps: string;
  s: string;
begin
  if (NumIn = '') or (BaseIn < 2) or (BaseIn > 36) or (BaseOut < 1) or (BaseOut > 36) then
  begin
    Result := SError;
    Exit;
  end;

  NumInCaps := UpperCase(NumIn);
  PlaceValue := Length(NumInCaps);
  RunningTotal := 0;

  for i := 1 to Length(NumInCaps) do
  begin
    PlaceValue := PlaceValue - 1;
    CurrentCharacter := NumInCaps[i];
    CharacterValue := 0;
    if (Ord(CurrentCharacter) > 64) and (Ord(CurrentCharacter) < 91) then
      CharacterValue := Ord(CurrentCharacter) - 55;

    if CharacterValue = 0 then
      if (Ord(CurrentCharacter) < 48) or (Ord(CurrentCharacter) > 57) then
      begin
        BaseConvert := SError;
        Exit;
      end
      else
        CharacterValue := Ord(CurrentCharacter);

    if (CharacterValue < 0) or (CharacterValue > BaseIn - 1) then
    begin
      BaseConvert := SError;
      Exit;
    end;
    RunningTotal := RunningTotal + CharacterValue * (Power(BaseIn, PlaceValue));
  end;

  while RunningTotal > 0 do
  begin
    BaseOutDouble := BaseOut;
    Remainder := RunningTotal - (int(RunningTotal / BaseOutDouble) * BaseOutDouble);
    RunningTotal := (RunningTotal - Remainder) / BaseOut;

    if Remainder >= 10 then
      CurrentCharacter := Chr(Trunc(Remainder + 55))
    else
    begin
      s := IntToStr(trunc(remainder));
      CurrentCharacter := s[Length(s)];
    end;
    Result := CurrentCharacter + Result;
  end;
end;

function Fibonacci(const N: integer): Int64;
{
  Fibonacci integers are defined as:
  Fibonacci Zahlen sind wie folgt definiert:

  fib[n+2] = fib[n+1] + fib[n];
  fib[1] = 1;
  fib[0] = 1;

  Example/Beispiel: fib[4] = fib[3] + fib[2] = fib[2] + fib[1] + fib[1] + fib[0] =
                    fib[1] + fib[0] + fib[1] + fib[1] + fib[0] = 5

  返回一个斐波纳切数，非递规方式
  递规方式如下：
  function fibrec(n: Integer): Integer;
  var
    temp: Integer;
  begin
    temp := 0;
    if (n = 0) then temp := 1;
    if (n = 1) then temp := 1;
    if (n > 1) then temp := fibrec(n - 1) + fibrec(n - 2);
    Result := temp;
  end;
}
var
  a, b, temp: Int64;
  i: integer;
begin
  temp := 1;
  a := 1;
  b := 1;
  for i := 1 to n - 1 do
  begin
    temp := a + b;
    a := b;
    b := temp;
  end;
  Result := temp;
end;

//////////////////////////////////////////////////////////////////////////////
//       Console function & procedure
//////////////////////////////////////////////////////////////////////////////

function GetCommandLineSwitch(Switch: string): string; stdcall;
{
  返回命令行指定的参数
  Switch 开关选项，Options：返回该选项对应的参数
  例如：命令行 Cmd.exe -s:c:\abc.txt -oC:\abc.out -d
  可以分别调用：
    GetCommandLineSwitch("-s:", buf); --> buf返回C:\abc.txt
    GetCommandLineSwitch("-o", buf); --> buf返回c:\abc.out
  找到对应的Switch，则函数返回true
}
var
  CmdLine, p: LPSTR;
  pStart: Integer;
  QuoteRef : Boolean;
begin
  Result := '';
  QuoteRef := False;  // 对有引号的参数的处理
  CmdLine := GetCommandLineA();

  pStart := AnsiPos(Switch, CmdLine);
  if pStart = 0 then Exit;

  p := CmdLine;
  Inc(p, pStart + Length(Switch) - 1);
  while (p^ <> #0) do
  begin
    if p^ = '"' then
      if QuoteRef then
        Break
      else
      begin
        QuoteRef := True;
        Inc(p);
        Continue;
      end;
        
    if P^ = ' ' then
      if not QuoteRef then
        Break;

    Result := Result + P^;
    Inc(p);
  end;
end;

function ExecAndOutput(const Prog, CommandLine,Dir: String;var ExitCode:DWORD): String;
  procedure CheckResult(b: Boolean);
  begin
    if not b then
       Raise Exception.Create(SysErrorMessage(GetLastError));
  end;

var
  HRead,HWrite:THandle;
  StartInfo:TStartupInfo;
  ProceInfo:TProcessInformation;
  b:Boolean;
  sa:TSecurityAttributes;
  inS:THandleStream;
  sRet:TStrings;
  p : PChar;
begin
  Result := '';
  FillChar(sa,sizeof(sa),0);
  //设置允许继承，否则在NT和2000下无法取得输出结果
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := True;
  sa.lpSecurityDescriptor := nil;
  b := CreatePipe(HRead,HWrite,@sa,0);
  CheckResult(b);
  if Dir <> '' then P := PChar(Dir) else P := nil;

  FillChar(StartInfo,SizeOf(StartInfo),0);
  StartInfo.cb := SizeOf(StartInfo);
  StartInfo.wShowWindow := SW_HIDE;
  //使用指定的句柄作为标准输入输出的文件句柄,使用指定的显示方式
  StartInfo.dwFlags     := STARTF_USESTDHANDLES+STARTF_USESHOWWINDOW;
  StartInfo.hStdError   := HWrite;
  StartInfo.hStdInput   := GetStdHandle(STD_INPUT_HANDLE);//HRead;
  StartInfo.hStdOutput  := HWrite;

  if Prog <> '' then
  b := CreateProcess(PChar(Prog),//lpApplicationName: PChar
         PChar(CommandLine),    //lpCommandLine: PChar
         nil,    //lpProcessAttributes: PSecurityAttributes
         nil,    //lpThreadAttributes: PSecurityAttributes
         True,    //bInheritHandles: BOOL
         CREATE_NEW_CONSOLE,
         nil,
         P,
         StartInfo,
         ProceInfo    )
  else
    b := CreateProcess(nil,//lpApplicationName: PChar
         PChar(CommandLine),    //lpCommandLine: PChar
         nil,    //lpProcessAttributes: PSecurityAttributes
         nil,    //lpThreadAttributes: PSecurityAttributes
         True,    //bInheritHandles: BOOL
         CREATE_NEW_CONSOLE,
         nil,
         P,
         StartInfo,
         ProceInfo    );

  CheckResult(b);
  WaitForSingleObject(ProceInfo.hProcess,INFINITE);
  GetExitCodeProcess(ProceInfo.hProcess,ExitCode);

  inS := THandleStream.Create(HRead);
  if inS.Size>0 then
  begin
    sRet := TStringList.Create;
    sRet.LoadFromStream(inS);
    Result := sRet.Text;
    sRet.Free;
  end;
  inS.Free;

  CloseHandle(HRead);
  CloseHandle(HWrite);
end;

function ConRunDosCmd(const Cmd: string;
  const InterCmd: Boolean = False;
  const WorkDir: string = '';
  const Input: THandle = 0;
  const Output: THandle = 0;
  const TimeOut: DWORD = INFINITE): Integer;
{ 在控制台本身中运行DOS命令,输入输出在控制台本身中 }
{ returns -1 if the Exec failed, otherwise returns the process' }
{ exit code when the process terminates.                        }
var
  pWorkDir: array[0..MAX_PATH] of Char;
  pCmdLine: array[0..1024] of Char;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar(StartupInfo, Sizeof(StartupInfo), 0);
  if InterCmd then
    StrPCopy(pCmdLine, 'cmd /c ' + Cmd)
  else
    StrPCopy(pCmdLine, Cmd);
  if DirectoryExists(WorkDir) then
    StrPCopy(pWorkDir, WorkDir)
  else
    StrPCopy(pWorkDir, GetCurrentDir);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.hStdInput := IfThen(Input = 0, GetStdHandle(STD_INPUT_HANDLE), Input);
  StartupInfo.hStdOutput := IfThen(Output = 0, GetStdHandle(STD_OUTPUT_HANDLE), Output);
  StartupInfo.wShowWindow := SW_SHOWNORMAL;
  if not CreateProcess(nil,
    pCmdLine, nil, nil, False, NORMAL_PRIORITY_CLASS, nil,
    pWorkDir, StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo
    ) then { pointer to PROCESS_INF }
    Result := -1
  else
  begin
    case WaitforSingleObject(ProcessInfo.hProcess, TimeOut) of
      WAIT_TIMEOUT: TerminateProcess(ProcessInfo.hProcess, Cardinal(Result));
    else
      GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
    end;
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;

function InputHandle: THandle;
begin
  Result := GetStdHandle(STD_INPUT_HANDLE);
end;

function OutputHandle: THandle;
begin
  Result := GetStdHandle(STD_OUTPUT_HANDLE);
end;

function IsOnConsole: Boolean;
{
  判断程序是否是在控制台下面运行，还是单独直接打开，必须在程序的第一行调用本函数
  并且保存返回的值，否则可能判断发生错误！
}
var
  sbi: TConsoleScreenBufferInfo;
  h: THandle;
begin
  h := OutputHandle;
  GetConsoleScreenBufferInfo(h, sbi);
  Result := not (sbi.dwCursorPosition.X > 0) and (sbi.dwCursorPosition.Y > 0);
end;

function EnableEcho(const Enable: Boolean): Cardinal;
{
  指定是否回显输入的字符，例如需要输入密码，不需要显示的情况
  Enable：True，回显，False，不回显
  返回值：返回被修改前的控制台模式
}
begin
  GetConsoleMode(InputHandle, Result);
  if Enable then
    SetConsoleMode(InputHandle, Result or ENABLE_ECHO_INPUT)
  else
    SetConsoleMode(InputHandle, Result and not ENABLE_ECHO_INPUT);
end;

procedure ClearScreen;
{
  清屏
}
var
  sbi: TConsoleScreenBufferInfo;
  h: hwnd;
  Cord: _COORD;
  R: Cardinal;
begin
  h := OutputHandle;
  GetConsoleScreenBufferInfo(h, sbi);
  Cord.X := 0;
  Cord.Y := 0;
  FillConsoleOutputCharacter(h, ' ', sbi.dwSize.X * sbi.dwSize.Y, Cord, R);
  SetConsoleCursorPosition(h, Cord);
end;

function KeyPressed: Char;
{
  判断是否有任意键（不包括功能键！）按下，返回按下的键的字符
  没有按键返回空字符
}
var
  NumberOfEvents: DWORD;
  NumRead: DWORD;
  InputRec: TInputRecord;
begin
  Result := #0;
  NumberOfEvents := 0;
  GetNumberOfConsoleInputEvents(InputHandle, NumberOfEvents);
  if NumberOfEvents > 0 then
  begin
    if PeekConsoleInput(InputHandle, InputRec, 1, NumRead) then
    begin
      ReadConsoleInput(InputHandle, InputRec, 1, NumRead);
      if (InputRec.EventType = KEY_EVENT) and
        (InputRec.Event.KeyEvent.bKeyDown) then
      begin
        Result := InputRec.Event.KeyEvent.AsciiChar;
      end
    end;
  end;
end;

procedure ClearInputBuffer;
var
  NumberOfEvents: DWORD;
  NumRead, i: DWORD;
  InputRec: TInputRecord;
begin
  GetNumberOfConsoleInputEvents(InputHandle, NumberOfEvents);
  for i := 1 to NumberOfEvents do
    ReadConsoleInput(InputHandle, InputRec, 1, NumRead);
end;

function GetChar: Char;
{
  判断是否有任意键（不包括功能键！）按下，返回按下的键的字符
}
var
  OldMode: Cardinal;
  BufferSize: Cardinal;
  Console: THandle;
begin
  Console := InputHandle;
  GetConsoleMode(Console, OldMode); { 获取原模式 }
  SetConsoleMode(Console, OldMode and not (ENABLE_LINE_INPUT or ENABLE_ECHO_INPUT));
  ReadConsole(Console, @Result, 1, BufferSize, nil);
  SetConsoleMode(Console, OldMode); { 恢复原来模式 }
end;

procedure PressAnyKey;
{
  提示按任意键继续!
}
var
  BufferSize: Cardinal;
begin
  WriteConsole(OutputHandle, PChar(SPressAnyKey),
    Length(SPressAnyKey), BufferSize, nil);
  GetChar;
end;

procedure GotoXY(X, Y: Word);
{
  移动输入光标焦点到指定的坐标范围
}
var
  Coord: _COORD;
begin
  Coord.X := X;
  Coord.Y := Y;
  SetConsoleCursorPosition(OutputHandle, Coord);
end;

function WhereXY: TCoord;
{
  获取当前光标位置
}
var
  Info: _CONSOLE_SCREEN_BUFFER_INFO;
begin
  GetConsoleScreenBufferInfo(OutputHandle, Info);
  Result := Info.dwCursorPosition;
end;

function WhereX: SmallInt;
{
  返回当前光标X坐标：结果范围 0~25
}
begin
  Result := WhereXY.X;
end;

function WhereY: SmallInt;
{
  返回当前光标Y坐标：结果范围 0~80
}
begin
  Result := WhereXY.Y;
end;

function SetColor(Color: Word): DWORD;
{
  设置输出文本颜色
}
var
  Info: CONSOLE_SCREEN_BUFFER_INFO;
  C: THandle;
begin
  C := OutputHandle;
  GetConsoleScreenBufferInfo(C, Info);
  Result := Info.wAttributes;
  SetConsoleTextAttribute(C, Color);
end;

function ReadPassword(const MaskChar: Char = '*'): string;
{
  读取密码，可以使用MaskChar，返回密码字符串
}
var
  C: Char;
begin
  while True do
  begin
    C := KeyPressed;
    case C of
      #0: Sleep(5);
      #13: Break;
      #8:
        if Length(Result) > 0 then
        begin
          Delete(Result, Length(Result), 1);
          GotoXY(WhereX - 1, WhereY);
          Write(' ');
          GotoXY(WhereX - 1, WhereY);
        end;
    else
      Result := Result + C;
      Write(MaskChar);
    end;
  end;
end;

procedure WriteEx(const S: string; Color: Word);
{
  写入控制台屏幕文本，可以指定颜色，颜色参考控制台API的定义
}
var
  Written: DWord;
  TmpAtt: TConsoleScreenBufferInfo;
  OldAtt: Word;
  Console: THandle;
begin
  Console := OutputHandle;
  GetConsoleScreenBufferInfo(Console, TmpAtt);
  OldAtt := TmpAtt.wAttributes; /// 保存原来的文本属性

  SetConsoleTextAttribute(Console, Color); /// 设定颜色
  WriteConsole(Console, PChar(S), Length(S), Written, nil);
  /// 恢复原来的颜色
  SetConsoleTextAttribute(Console, OldAtt);
end;

procedure WriteLnEx(const S: string; Color: Word);
{
  写入控制台屏幕文本，可以指定颜色，颜色参考控制台API的定义
}
var
  c: TCoord;
  ci: TCharInfo;
  sr: TSmallRect;
  TmpAtt: TConsoleScreenBufferInfo;
  Written: DWord;
  OldAtt: Word;
  Console: THandle;
begin
  Console := OutputHandle;
  GetConsoleScreenBufferInfo(Console, TmpAtt);
  OldAtt := TmpAtt.wAttributes; /// 保存原来的文本属性

  SetConsoleTextAttribute(Console, Color); /// 设定颜色
  WriteConsole(Console, PChar(S), Length(S), Written, nil);

  /// 处理换行
  GetConsoleScreenBufferInfo(Console, TmpAtt);
  if TmpAtt.dwCursorPosition.Y >= Pred(TmpAtt.dwSize.Y) then
  begin /// Win98，窗口滚动有问题，必须修正
    // 滚动范围
    sr.Left := 0;
    sr.Top := 1;
    sr.Right := TmpAtt.dwSize.X;
    sr.Bottom := TmpAtt.dwSize.Y;
    // 滚动的新坐标，本处为向上滚动一行
    c.X := 0;
    c.Y := 0;
    // 以空格，前文字属性填充滚动出来的空白
    ci.UniCodeChar := #32;
    ci.Attributes := OldAtt;
    ScrollConsoleScreenBuffer(Console, sr, nil, c, ci);

    c.X := 0;
    c.Y := TmpAtt.srWindow.Bottom;
    SetConsoleCursorPosition(Console, c);
  end
  else
  begin /// 未到最后一行，不需要做任何处理
    c.X := 0;
    c.Y := TmpAtt.dwCursorPosition.Y + 1;
    SetConsoleCursorPosition(Console, c);
  end;

  /// 恢复原来的颜色
  SetConsoleTextAttribute(Console, OldAtt);
end;

//////////////////////////////////////////////////////////////////////////////
//       MultiMedia function & procedure
//////////////////////////////////////////////////////////////////////////////

function SendMCICommand(Cmd: string): Boolean;
{
  发送MCI命令，并处理错误代码显示错误信息
}
var
  RetVal: Integer;
  ErrMsg: array[0..254] of char;
begin
  RetVal := mciSendString(PChar(Cmd), nil, 0, 0);
  Result := RetVal = 0;
  if RetVal <> 0 then
  begin
    {get message for returned value}
    mciGetErrorString(RetVal, ErrMsg, 255);
    DlgError(StrPas(ErrMsg));
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//       Memory manager function & procedure
//////////////////////////////////////////////////////////////////////////////

procedure DefragProcessMemory;
{
  更新内存的显示:
  随便打开一个窗体，然后再其主窗体最小化；发现内存突然少了许多～～
  随便创建一个窗体，显示后立即将其释放；发现总会有一不部分内存会占用不被释放～～
  只要不最小化主窗体，这样的内存占用就越来越大～～
}
begin
  SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
end;

//////////////////////////////////////////////////////////////////////////////
//       OLE/ActiveX/Com function & procedure
//////////////////////////////////////////////////////////////////////////////

function CreateComObjectFromDll(CLSID: TGUID; DllHandle: THandle): IUnknown;
var
  Factory: IClassFactory;
  DllGetClassObject: function(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
begin
  Result := nil;
  DllGetClassObject := GetProcAddress(DllHandle, 'DllGetClassObject');
  if Assigned(DllGetClassObject) then
  begin
    DllGetClassObject(CLSID, IClassFactory, Factory);
    Factory.CreateInstance(nil, IUnknown, Result);
  end;
end;

function DispatchMethodInvoke(Disp: IDispatch; const MethodName: string; Params: array of const; var VarResult: Variant): Boolean;
Var
  ArgErr : DWord ;
  P: TDispParams;
  id: Integer;
  ExcepInfo: TExcepInfo;

  N: Widestring;
  Args : array[0..63] of TVariantArg;
  i : Integer;
  L : Integer;
begin
  try
    N := StringToOleStr(MethodName);
    OleCheck(Disp.GetIDsOfNames(GUID_NULL, @N, 1, LOCALE_USER_DEFAULT, @id));

    FillChar(Args, SizeOf(Args),0);
    FillChar(P,SizeOf(P),0);
    L := High(Params);

    for i := Low(Args) to High(Args) do
    begin
      Args[i].vt := VT_ERROR;
      Args[i].scode := DISP_E_PARAMNOTFOUND;
    end;

    for i := High(Params) downto Low(Params) do
      case Params[i].VType of
        vtAnsiString:
          begin
            Args[L - i].vt := VT_BSTR;
            Args[L - i].bstrVal := StringToOleStr(Params[i].VPChar);
          end;
        vtBoolean:
          begin
            Args[L - i].vt := VT_BOOL;
            Args[L - i].vbool := Params[i].VBoolean;
          end;
        vtInteger:
          begin
            Args[L - i].vt := VT_INT;
            Args[L - i].intVal := Params[i].VInteger;
          end;
        vtVariant:
          if VarIsEmptyParam(Params[i].VVariant^) then
          begin
            Args[L - i].vt := VT_ERROR;
            Args[L - i].scode := DISP_E_PARAMNOTFOUND;
          end else
          begin
            Args[L - i].vt := VT_VARIANT;
            Args[L - i].pvarVal := Params[i].VVariant;
          end;
        /// ...

        else
          Args[L - i].vt := VT_ERROR;
          Args[L - i].scode := DISP_E_PARAMNOTFOUND;
      end;

    P.rgvarg := @Args;
    P.cArgs := Length(Params);
    P.cNamedArgs := 0;

    OleCheck(Disp.Invoke(id, GUID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, P, @VarResult, @ExcepInfo, @ArgErr));
    Result := True;
  except
    Result := False;
  end;
end;

function VariantToString(V : Variant): string;
begin
  Result := '';
  case TVarData(V).VType of
    varSmallint, varInteger, varSingle, varDouble, varOleStr,
    varError, varShortInt, varByte, varWord, varLongWord, varInt64, varString,
    varBoolean :
      Result := V;
    varDate : Result := DateTimeToStr(V.Date);
    varCurrency : Result := CurrToStr(V.VCurrency);
    varDispatch: Result := '(Dispatch)';
    varUnknown: Result := '(Unknown)';
    varAny: Result := '(Any)';
    varArray: Result := '(Var Array)';
    varNull: Result :='(NULL)';
    varVariant: Result := '(Variant)';
    //8204: Result := V.VPointer;
  else
    Result := '(N/A)';
  end;
end;

function GetObject(const ObjectName: string): OleVariant; stdcall;
{
  连接/返回指定的对象，失败返回NULL
  例如： WordApp := GetObject('Word.Application');
}
begin
  Result := 0;
  try
    Result := GetActiveOleObject(ObjectName);
  except
    Result := CreateOleObject(ObjectName);
  end;
end;


function CheckCOMInstalled(const Name : string): Boolean; overload;
{
  检查指定的COM接口是否存在或安装，存在则返回True，否则返回False
}
begin
  try
    Result := CreateOleObject(Name) <> nil;
  except
    Result := False;
  end;
end;

function CheckCOMInstalled(const CLSID : TGUID): Boolean; overload;
{
  检查指定的COM接口是否存在或安装，存在则返回True，否则返回False
}
begin
  try
    Result := CreateComObject(CLSID) <> nil;
  except
    Result := False;
  end;
end;

procedure UpdateOfficeUI(OfficeApp: OleVariant; Enabled: Boolean);
{
  设置Office Application对象的是否允许屏幕更新、显示对话框、允许交互
  支持Word和Excel
}
begin
  OfficeApp.Interactive := Enabled;
  OfficeApp.DisplayAlerts := Enabled;
  OfficeApp.ScreenUpdating := Enabled;
end;

procedure WordReplaceText(WordDoc: Variant; const Old, New: string; const ReplaceFlags: TReplaceFlags); stdcall;
{
  替换Word文档中的字符串
}
var
  v : OleVariant;
begin
  v := not (rfIgnoreCase in ReplaceFlags);
  WordDoc.Range.Find.Execute(
    Old, /// 被替换的字符串
    v, /// 是否区分大小写
    , /// 全字匹配
    , /// 是否使用通配符
    , /// 是否查找同音字词
    , /// 是否查找单词的各种形式（如进行时，过去时等）
    , /// 查找方向，如是否是向下搜索
    , /// 是否回绕查找，即找不到从开头重新查找
    , /// 是否是查找格式
    New, /// 替换后的文本
    IfThen(rfReplaceAll in ReplaceFlags, 2, 1), /// 替换标志，一个，全部，还是不替换？
    );
end;

function WMIQuery(const WQL: string; const Computer: string = ''; const User: string = ''; const Password: string = ''): IEnumVariant;
{
  返回WQL语句的集合对象，用法如下：
  var
    Enum : IEnumVariant;
    Obj : OleVariant;
    V : Cardinal;
  ...
    Enum := WMIQuery('select * from win32_process');
    while Enum.Next(1,Obj, V) = S_OK do
    begin
      /// Obj.Properties_.Item('ExePath').Value;...
      /// Obj.Properties_.Item('ExePath').Name;...
      /// Obj.Name
      /// Obj.Value
      /// ...
    end;
}
var
  Locator, Service, ObjectSet: OleVariant;
begin
  Locator := CreateOleObject('WbemScripting.SWbemLocator');
  if IsLocalComputer(Computer) then
    Service := Locator.ConnectServer()
  else
    Service := Locator.ConnectServer(Computer, 'root\cimv2', Computer + '\' + User, Password);
  ObjectSet := Service.ExecQuery(WQL);
  Result := IUnknown(ObjectSet._NewEnum) as IEnumVariant;
end;

function WMIDumpProperties(WQLObj: OleVariant; Properites: TStrings): Boolean;
var
  Enum: IEnumVariant;
  Obj : OleVariant;
  V : Cardinal;
begin
  Properites.BeginUpdate;
  Result := True;
  Enum := IUnknown(WQLObj.Properties_._NewEnum) as IEnumVariant;
  while Enum.Next(1, Obj, V) = S_OK do
  try
    //VType := VarTypeAsText(VarType(Prop));
    Properites.Add(Format('%s=%s',[Obj.Name, VariantToString(Obj.Value)]));
  except
    Properites.Add(Format('%s=(Error Get Property Value)',[Obj.Name]));
  end;
  Properites.EndUpdate;
end;

function RunScript(const Script: string; const Language: string = 'vbscript'): string;
var
  MSScripter: OleVariant;
begin
  MSScripter := CreateOLEObject('MSScriptControl.ScriptControl');
  MSScripter.Language := Language;
  MSScripter.SitehWnd := GetActiveWindow;
  Result := MSScripter.Eval(Script);
  VarClear(MSScripter);
end;

//////////////////////////////////////////////////////////////////////////////
//       Other function & procedure
//////////////////////////////////////////////////////////////////////////////

procedure DebugPrint(const s: string);
{
  输出调试信息
}
begin
  OutputDebugString(PChar(s));
end;

procedure DebugPrintEx(const s: string; values: array of const);
{
  输出调试信息,可以带参数,参考Format
}
begin
  OutputDebugString(PChar(Format(s, values)));
end;

{$WARN SYMBOL_PLATFORM  OFF}
procedure DebugBreak(Condition: Boolean);
{
  运行时快速条件断点,比Delphi设置的条件断点快几个数量级
}
asm
  cmp DebugHook, $01
  setz dl
  test dl, al
  jz @@exit
  Int 3
@@exit:
end;
{$WARN SYMBOL_PLATFORM ON}

function IsDebuggerPresent: Boolean; 
type
  TProcIsDebuggerPresent = function: BOOL; stdcall;
var
  ProcIsDebuggerPresent: Pointer;
  Kernel32: HINST;
begin
  Result := False;
  Kernel32 := LoadLibrary('Kernel32.dll');
  if Kernel32 <> 0 then
  begin
    ProcIsDebuggerPresent := GetProcAddress(Kernel32, 'IsDebuggerPresent');
    if ProcIsDebuggerPresent <> nil then
      Result := TProcIsDebuggerPresent(ProcIsDebuggerPresent);
  end;
end;

function GetClassParentTree(AClass: TObject): string; stdcall;
{
  返回类的祖先列表，倒序排列
}
var
  Ref : TClass;
begin
  Result := AClass.ClassName;
  Ref := AClass.ClassParent;
  while Ref <> nil do
  begin
    Result := Result + '-' + Ref.ClassName;
    Ref := Ref.ClassParent;
  end;
end;

function CheckValueInArray(const Value: integer; ValueArray: array of integer): Boolean;
{
  检查Value是否在数组中，在，返回True，否则返回False
}
var
  i: integer;
begin
  Result := True;
  for i := Low(ValueArray) to High(ValueArray) do
    if Value = ValueArray[i] then Exit;
  Result := False;
end;

function CheckCardinalInArray(const Value: Cardinal; ValueArray: array of Cardinal): Boolean;
{
  检查Value是否在数组中，在，返回True，否则返回False
}
var
  i: integer;
begin
  Result := True;
  for i := Low(ValueArray) to High(ValueArray) do
    if Value = ValueArray[i] then Exit;
  Result := False;
end;

{ 转换数组为 1;2;3;....的形式 }

function ArrayToString(const Values: array of integer; const Seperator: string = ';'): string;
var
  i: integer;
begin
  if Length(Values) <= 0 then Exit;
  Result := IntToStr(Values[0]);
  for i := Pred(Low(Values)) to High(Values) do
    Result := Result + Seperator + IntToStr(Values[i]);
end;

function ConcatEx(Args: array of const): string;
{
  连接若干数据，数据可以为任意基本类型，返回一个字符串。
}
  function VarToStr(V: Variant): string;
  begin
    Result := V;
  end;
var
  i: integer;
begin
  Result := '';
  for i := Low(Args) to High(Args) do
    case Args[i].VType of
      vtInteger: Result := Result + IntToStr(Args[i].VInteger);
      vtBoolean: Result := Result + BoolToString(Args[i].VBoolean);
      vtChar: Result := Result + Args[i].VChar;
      vtExtended: Result := Result + FloatToStr(Args[i].VExtended^);
      vtString: Result := Result + Args[i].VString^;
      vtPChar: Result := Result + Args[i].VPChar;
      vtWideChar: Result := Result + Args[i].VWideChar;
      vtPWideChar: Result := Result + Args[i].VPWideChar^;
      vtAnsiString: Result := Result + AnsiString(Args[i].VAnsiString);
      vtCurrency: Result := Result + CurrencyToString(Args[i].VCurrency^);
      vtVariant: Result := Result + VarToStr(Args[i].VVariant^);
      vtWideString: Result := Result + WideString(Args[i].VWideString);
      vtInt64: Result := Result + IntToStr(Args[i].VInt64^);
    end;
end;

procedure FreeAndNilEx(var Obj);
begin
  if Assigned(Pointer(Obj)) then FreeAndNil(Obj);
end;

procedure ClearList(List: TList);
{
  清除List中的Object对象
}
var
  i: integer;
begin
  if not assigned(List) then exit;
  for i := Pred(List.Count) downto 0 do
    if Assigned(List[i]) then TObject(List[i]).Free;
  List.Clear;
end;

procedure Delay(MSecs: Cardinal);
{
  延时指定的MSecs毫秒，同时处理消息，即用户可以进行其它的操作
}
var
  targettime: Cardinal;
  Msg: TMsg;
begin
  targettime := GetTickCount + msecs;
  while targettime > GetTickCount do
  begin
    if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    begin
      if Msg.message = WM_QUIT then
      begin
        PostMessage(Msg.hwnd, WM_QUIT, 0, 0);
        Exit;
      end;
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end
    else Sleep(1);
  end;
end;

function DelayEx(const nSecond: Int64): Boolean;
{
  高精度延时函数，达到纳秒级
  若系统支持高精度计数，返回True，否则返回False
}
var
  hrRes, hrT1, hrT2, dif: Int64;
begin
  Result := False;
  if QueryPerformanceFrequency(hrRes) then
  begin
    Result := True;
    QueryPerformanceCounter(hrT1);
    repeat
      QueryPerformanceCounter(hrT2);
      dif := (hrT2 - hrT1) * 1000 * 1000 * 1000 div hrRes;
    until dif > nSecond;
  end;
end;

procedure BusyDelay(MSecs: DWORD);
{
  延时指定的毫秒，不会转让CPU时间，会占用大量CPU
}
var
  CurTime: LongWord;
begin
  CurTime := GetTickCount;
  while (GetTickCount < (CurTime + MSecs)) do
end;

function KillTask(const ExeName: string): Boolean;
{
  强制终止ExeName对应的应用程序
}
var
  lppe: TProcessEntry32;
  SH, PID: THandle;
  Found: boolean;
begin
  Result := False;
  EnablePrivilege('SeDebugPrivilege', True);
  lppe.dwSize := SizeOf(lppe);
  SH := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  found := Process32First(SH, lppe);
  while found do
  begin
    if SameText(ExeName, lppe.szExeFile) then
    begin
      PID := OpenProcess(PROCESS_ALL_ACCESS, true, lppe.th32ProcessID);
      Result := TerminateProcess(PID, DWORD(-1));
      CloseHandle(PID);
    end;
    found := Process32Next(SH, lppe);
  end;
  EnablePrivilege('SeDebugPrivilege', False);
end;

function ProcessExists(exeFileName: string): Boolean;
{
  判断某个进程是否存在
}
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function CloseApplication(const hWnd: HWND): Boolean;
{
  关闭指定程序
}
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWnd, WM_CLOSE, 0, 0, SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);
  if IsWindow(hWnd) then
    SendMessageTimeout(hWnd, WM_QUERYENDSESSION, 0, LPARAM(ENDSESSION_LOGOFF), SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);
  if IsWindow(hWnd) then
  begin
    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWnd, @hprocessID);
    if hprocessID <> 0 then
    begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION, False, hprocessID);
      if processHandle <> 0 then
      begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
      end;
    end;
  end;
  Result := IsWindow(hWnd);
end;

function UpdateIDCardNumber(OldID: string): string; { Update Old ID Card Number to New }
{
  更新15位身份证为新的18身份证格式
}
const
  W: array[1..18] of integer = (7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1);
  A: array[0..10] of char = ('1', '0', 'x', '9', '8', '7', '6', '5', '4', '3', '2');
var
  i, j, S: integer;
  NewID: string;
begin
  if Length(OldID) <> 15 then Exit;
  NewID := OldID;
  Insert('19', NewID, 7);
  S := 0;
  try
    for i := 1 to 17 do
    begin
      j := StrToInt(NewID[i]) * W[i];
      S := S + j;
    end;
  except
    result := '';
    exit;
  end;
  S := S mod 11;
  Result := NewID + A[S];
end;

function SetGlobalEnvironment(const Name, Value: string; const User: Boolean = True): boolean;
{
  设置系统环境变量
}
resourcestring
  REG_MACHINE_LOCATION = 'System\CurrentControlSet\Control\Session Manager\Environment';
  REG_USER_LOCATION = 'Environment';
begin
  if User then { User Environment Variable }
    Result := RegWriteString(HKEY_CURRENT_USER, REG_USER_LOCATION, Name, Value)
  else { System Environment Variable }
    Result := RegWriteString(HKEY_LOCAL_MACHINE, REG_MACHINE_LOCATION, Name, Value);
  if Result then
  begin
    { Update Current Process Environment Variable }
    SetEnvironmentVariable(pchar(Name), pchar(Value));
    { Send Message To All Top Window for Refresh }
    SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, integer(Pchar('Environment')));
  end;
end; { SetGlobalEnvironment }

procedure GetEnvironmentList(const List: TStrings);
{
  返回环境变量列表
}
var
  Buf, p : PChar;
begin
  Buf := GetEnvironmentStrings;
  p := Buf;
  while p^ <> #0 do
  begin
     List.Add(p);
     Inc(p, StrLen(p) + 1);
  end;
  FreeEnvironmentStrings(Buf);
end;

function GetCaretPosition(var APoint: TPoint): Boolean;
{
  返回系统当前脱字符的位置
}
var
  w: HWND;
  aID, mID: DWORD;
begin
  Result := False;
  w := GetForegroundWindow;
  if w <> 0 then
  begin
    aID := GetWindowThreadProcessId(w, nil);
    mID := GetCurrentThreadid;
    if aID <> mID then
    begin
      if AttachThreadInput(mID, aID, True) then
      begin
        w := GetFocus;
        if w <> 0 then
        begin
          Result := GetCaretPos(APoint);
          Windows.ClientToScreen(w, APoint);
        end;
        AttachThreadInput(mID, aID, False);
      end;
    end;
  end;
end;

procedure InstallScreenSaver(const FileName: string);
{
  安装屏幕保护程序FileName为屏幕保护程序文件名
}
begin
  { Set this screensaver as default screensaver and open the properties dialog}
  ShellExecute(GetActiveWindow, 'open', PChar('rundll32.exe'),
    PChar('desk.cpl,InstallScreenSaver ' + FileName), nil, SW_SHOWNORMAL);
end;

//////////////////////////////////////////////////////////////////////////////
//       Service function & procedure
//////////////////////////////////////////////////////////////////////////////

function ServiceStart(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  启动服务
}
var
  SCM, SCH: SC_Handle;
  P: PChar;
begin
  Result := False;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      Result := StartService(SCH, 0, P);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceStop(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  停止服务
}
var
  SCM, SCH: SC_Handle;
  ServiceStatus: TServiceStatus;
begin
  Result := False;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      Result := ControlService(SCH, SERVICE_CONTROL_STOP, ServiceStatus);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceShutdown(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  关闭服务
}
var
  SCM, SCH: SC_Handle;
  ServiceStatus: TServiceStatus;
begin
  Result := False;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      Result := ControlService(SCH, SERVICE_CONTROL_SHUTDOWN, ServiceStatus);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceStatus(const ServiceName: string; const Computer: PChar = nil): integer;
{
  返回指定服务的状态
}
var
  SCM, SCH: SC_Handle;
  ServiceStatus: TServiceStatus;
begin
  Result := 0;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      QueryServiceStatus(SCH, ServiceStatus);
      Result := ServiceStatus.dwCurrentState;
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceStatusDescription(Service_Status: integer): string;
{
  返回指定服务状态的文字描述：Stopped,Running...
}
begin
  case Service_Status of
    SERVICE_STOPPED: Result := 'Stopped';
    SERVICE_START_PENDING: Result := 'Starting';
    SERVICE_STOP_PENDING: Result := 'Stopping';
    SERVICE_RUNNING: Result := 'Running';
    SERVICE_CONTINUE_PENDING: Result := 'Continue';
    SERVICE_PAUSE_PENDING: Result := 'Pause';
    SERVICE_PAUSED: Result := 'Paused';
  else
    Result := 'Unknow';
  end;
end;

function ServiceRunning(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  判断指定服务是否正在运行
}
begin
  Result := ServiceStatus(ServiceName, Computer) = SERVICE_RUNNING;
end;

function ServiceStopped(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  判断指定服务是否停止运行
}
begin
  Result := ServiceStatus(ServiceName, Computer) = SERVICE_STOPPED;
end;

function ServiceDisplayName(const ServiceName: string; const Computer: PChar = nil): string;
{
  返回指定服务的显示名称
}
var
  SCM, SCH: SC_Handle;
  L: DWORD;
begin
  Result := '';
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      GetServiceDisplayName(SCM, PChar(ServiceName), nil, L);
      SetLength(Result, L);
      GetServiceDisplayName(SCM, PChar(ServiceName), PChar(Result), L);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceFileName(const ServiceName: string; const Computer: PChar = nil): string;
{
  返回指定服务对应的可执行文件名称
}
var
  SCM, SCH: SC_Handle;
  ServiceConfig: PQueryServiceConfig;
  R: DWORD;
begin
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      QueryServiceConfig(SCH, nil, 0, R); // Get Buffer Length
      GetMem(ServiceConfig, R + 1);
      QueryServiceConfig(SCH, ServiceConfig, R + 1, R);
      Result := ServiceConfig.lpBinaryPathName;
      Result := StringReplace(Result, '"', '', [rfReplaceAll]);
      FreeMem(ServiceConfig);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function QueryServiceConfig2(hService: SC_HANDLE; dwInfoLevel: DWORD;
  lpBuffer: PChar; cbBufSize: DWORD; var pcbBytesNeeded: DWORD): BOOL;
  stdcall; external advapi32 name 'QueryServiceConfig2A';

function ServiceDescription(const ServiceName: string; const Computer: PChar = nil): string;
{
  返回指定服务的描述信息
}
const
  SERVICE_CONFIG_DESCRIPTION = $00000001;
type
  TServiceDescription = packed record
    lpDescription: LPSTR;
  end;
  PServiceDescription = ^TServiceDescription;
var
  SCM, SCH: SC_Handle;
  P: PServiceDescription;
  R: DWORD;
begin
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      QueryServiceConfig2(SCH, SERVICE_CONFIG_DESCRIPTION, nil, 0, R); // Get Buffer Length
      GetMem(P, R + 1);
      QueryServiceConfig2(SCH, SERVICE_CONFIG_DESCRIPTION, PChar(P), R + 1, R);
      Result := P.lpDescription;
      FreeMem(P);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

procedure ServiceNames(Names: TStrings; DisplayNames: TStrings = nil;
  const Service_Type: integer = $30; const Computer: PChar = nil);
{
  返回系统服务列表，Names：用于接收返回的服务名称列表，
  DisplayName：用于接收返回的对应显示名称列表，
  uType：需要返回那些类型服务名称列表，可以为SERVICE_DRIVER,SERVICE_WIN32,SERVICE_ALL
}
type
  TEnumServices = array[0..0] of TEnumServiceStatus;
  PEnumServices = ^TEnumServices;
var
  SCM: SC_Handle;
  Services: PEnumServices;
  Len: Cardinal;
  ServiceCount, ResumeHandle, i: Cardinal;
begin
  ResumeHandle := 0;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  Len := 0;
  ServiceCount := 0;
  Services := nil;
  try
    Names.BeginUpdate;
    if Assigned(DisplayNames) then DisplayNames.BeginUpdate;

    if SCM <> 0 then
    begin
      EnumServicesStatus(SCM, Service_Type, SERVICE_STATE_ALL,
        Services[0], 0, Len, ServiceCount, ResumeHandle);
      GetMem(Services, Len);
      EnumServicesStatus(SCM, SERVICE_DRIVER or SERVICE_WIN32, SERVICE_STATE_ALL,
        Services[0], Len, Len, ServiceCount, ResumeHandle);
      for i := 0 to ServiceCount - 1 do
      begin
        Names.Add(Services[i].lpServiceName);
        if Assigned(DisplayNames) then DisplayNames.Add(Services[i].lpDisplayName);
      end;
      FreeMem(Services);
    end;
  finally
    Names.EndUpdate;
    if Assigned(DisplayNames) then DisplayNames.EndUpdate;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceControl(const ServiceName: string; const ControlCode: integer; const Computer: PChar = nil): Boolean;
{
  控制系统服务，可以指定代码: ControlCode 必须在 [128,255]
}
var
  SCM, SCH: SC_Handle;
  ServiceStatus: TServiceStatus;
begin
  Result := False;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      Result := ControlService(SCH, ControlCode, ServiceStatus);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceDelete(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  删除系统服务
}
var
  SCM, SCH: SC_Handle;
begin
  Result := False;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    if SCH <> 0 then
    begin
      Result := DeleteService(SCH);
      CloseServiceHandle(SCH);
    end;
    CloseServiceHandle(SCM);
  end;
end;

function ServiceExists(const ServiceName: string; const Computer: PChar = nil): Boolean;
{
  判断系统服务是否存在，存在返回True，否则返回False
}
var
  SCM, SCH: SC_Handle;
begin
  Result := False;
  if IsLocalComputer(Computer) then
    SCM := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS)
  else
    SCM := OpenSCManager(Computer, nil, SC_MANAGER_ALL_ACCESS);
  if SCM <> 0 then
  begin
    SCH := OpenService(SCM, PChar(ServiceName), SERVICE_ALL_ACCESS);
    Result := ERROR_SERVICE_DOES_NOT_EXIST <> GetLastError;
    if SCH <> 0 then CloseServiceHandle(SCH);
    CloseServiceHandle(SCM);
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//       Registry/INI file function & procedure
//////////////////////////////////////////////////////////////////////////////

function HKEYToStr(const Key: HKEY): string;
begin
  if (Key < HKEY_CLASSES_ROOT) or (Key > HKEY_DYN_DATA) then
    Result := ''
  else
    Result := CSHKeyNames[HKEY_CLASSES_ROOT];
end;

function StrToHKEY(const KEY: string): HKEY;
begin
  for Result := Low(CSHKeyNames) to High(CSHKeyNames) do
    if SameText(CSHKeyNames[Result], KEY) then
      Exit;
  Result := $FFFFFFFF;
end;

function RegExtractHKEY(const Reg: string): HKEY;
{
  从完整注册表路径中提取HKEY
}
begin
  Result := StrToHKEY(LeftPart(Reg, '\'));
end;

function RegExtractSubKey(const Reg: string): string;
{
  从完整字符串中提取注册表SubKey
}
begin
  Result := RightPart(Reg, '\');
end;

function RegExportToFile(const RootKey: HKEY; const SubKey, FileName: string): Boolean;
{
  导出注册表到文件
}
var
  Key: HKEY;
begin
  Result := False;
  EnablePrivilege('SeBackupPrivilege', True);
  if ERROR_SUCCESS = RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_ALL_ACCESS, Key) then
  begin
    Result := RegSaveKey(Key, PChar(FileName), nil) = ERROR_SUCCESS;
    RegCloseKey(Key);
  end;
end;

function RegImportFromFile(const RootKey: HKEY; const SubKey, FileName: string): Boolean;
{
  导入注册表
}
begin
  EnablePrivilege('SeBackupPrivilege', True);
  Result := RegLoadKey(RootKey, PChar(SubKey), PChar(FileName)) = ERROR_SUCCESS;
end;

function RegReadString(const RootKey: HKEY; const SubKey, ValueName: string): string;
var
  Key: HKEY;
  T: DWORD;
  L: DWORD;
begin
  if ERROR_SUCCESS = RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_ALL_ACCESS, Key) then
  begin
    if ERROR_SUCCESS = RegQueryValueEx(Key, PChar(ValueName), nil, @T, nil, @L) then
    begin
      if T <> REG_SZ then raise Exception.Create(SErrDataType);
      SetLength(Result, L);
      RegQueryValueEx(Key, PChar(ValueName), nil, @T, PByte(PChar(Result)), @L);
    end;
    SetString(Result, PChar(Result), L - 1);
    RegCloseKey(Key);
  end;
end;

function RegReadInteger(const RootKey: HKEY; const SubKey, ValueName: string): integer;
var
  Key: HKEY;
  T: DWORD;
  L: DWORD;
begin
  if ERROR_SUCCESS = RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_ALL_ACCESS, Key) then
  begin
    if ERROR_SUCCESS = RegQueryValueEx(Key, PChar(ValueName), nil, @T, nil, @L) then
    begin
      if T <> REG_DWORD then raise Exception.Create(SErrDataType);
      RegQueryValueEx(Key, PChar(ValueName), nil, @T, @Result, @L);
    end;
    RegCloseKey(Key);
  end;
end;

function RegReadBinary(const RootKey: HKEY; const SubKey, ValueName: string; Data: PChar; out Len: integer): Boolean;
{
  从注册表中读取二进制数据
  RootKey：指定主分支
  SubKey：子键的名字
  ValueName：键名，可以为空，为空即表示默认值
  Data：保存读取到的数据
  Len：读取到的数据的长度
}
var
  Key: HKEY;
  T: DWORD;
begin
  Result := False;
  if ERROR_SUCCESS = RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_ALL_ACCESS, Key) then
  begin
    if ERROR_SUCCESS = RegQueryValueEx(Key, PChar(ValueName), nil, @T, nil, @Len) then
    begin
      ReallocMem(Data, Len);
      Result := ERROR_SUCCESS = RegQueryValueEx(Key, PChar(ValueName), nil, @T, PByte(Data), @Len);
    end;
    RegCloseKey(Key);
  end;
end;

function RegWriteString(const RootKey: HKEY; const SubKey, ValueName, Value: string): Boolean;
{
  写入一个字符串到注册表中
  RootKey：指定主分支
  SubKey：子键的名字
  ValueName：键名，可以为空，为空即表示写入默认值
  Value：数据
}
var
  Key: HKEY;
  R: DWORD;
begin
  Result := (ERROR_SUCCESS = RegCreateKeyEx(RootKey, PChar(SubKey), 0, 'Data',
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Key, @R)) and
    (ERROR_SUCCESS = RegSetValueEx(Key, PChar(ValueName), 0, REG_SZ, PChar(Value), Length(Value)));
  RegCloseKey(Key);
end;

function RegReadMultiString(const RootKey: HKEY; const SubKey, ValueName: string): string;
{
  读取注册表中指定的多字符串
}
var
  Key: HKEY;
  T: DWORD;
  L: DWORD;
begin
  if ERROR_SUCCESS = RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_ALL_ACCESS, Key) then
  begin
    if ERROR_SUCCESS = RegQueryValueEx(Key, PChar(ValueName), nil, @T, nil, @L) then
    begin
      if T <> REG_MULTI_SZ then raise Exception.Create(SErrDataType);
      SetLength(Result, L);
      RegQueryValueEx(Key, PChar(ValueName), nil, @T, PByte(PChar(Result)), @L);
    end;
    SetString(Result, PChar(Result), L);
    RegCloseKey(Key);
  end;
end;

function RegWriteMultiString(const RootKey: HKEY; const SubKey, ValueName, Value: string): Boolean;
{
  写入字符串到注册表中
  Value为#0分隔的多行字符串，最后以双#0#0结尾
}
var
  Key: HKEY;
  R: DWORD;
begin
  Result := (ERROR_SUCCESS = RegCreateKeyEx(RootKey, PChar(SubKey), 0, 'Data',
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Key, @R)) and
    (ERROR_SUCCESS = RegSetValueEx(Key, PChar(ValueName), 0, REG_MULTI_SZ, PChar(Value), Length(Value)));
  RegCloseKey(Key);
end;

function RegWriteInteger(const RootKey: HKEY; const SubKey, ValueName: string; const Value: integer): Boolean;
{
  写入一个整数到注册表中
  RootKey：指定主分支
  SubKey：子键的名字
  ValueName：键名，可以为空，为空即表示写入默认值
  Value：数据
}
var
  Key: HKEY;
  R: DWORD;
begin
  Result := (ERROR_SUCCESS = RegCreateKeyEx(RootKey, PChar(SubKey), 0, 'Data',
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Key, @R)) and
    (ERROR_SUCCESS = RegSetValueEx(Key, PChar(ValueName), 0, REG_DWORD, @Value, SizeOf(Value)));
  RegCloseKey(Key);
end;

function RegWriteBinary(const RootKey: HKEY; const SubKey, ValueName: string; Data: PChar; Len: integer): Boolean;
{
  从注册表中读取二进制数据
}
var
  Key: HKEY;
  R: DWORD;
begin
  Result := (ERROR_SUCCESS = RegCreateKeyEx(RootKey, PChar(SubKey), 0, 'Data',
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Key, @R)) and
    (ERROR_SUCCESS = RegSetValueEx(Key, PChar(ValueName), 0, REG_BINARY, Data, Len));
  RegCloseKey(Key);
end;

function RegValueExists(const RootKey: HKEY; const SubKey, ValueName: string): Boolean;
{
  判断注册表中是否存在指定的键名
}
var
  Key: HKEY;
  Dummy: DWORD;
begin
  Result := False;
  if ERROR_SUCCESS = RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_READ, Key) then
  begin
    Result := ERROR_SUCCESS = RegQueryValueEx(Key, PChar(ValueName), nil, @Dummy, nil, @Dummy);
    RegCloseKey(Key);
  end;
end;

function RegKeyExists(const RootKey: HKEY; const SubKey: string): Boolean;
{
  判断注册表中是否存在指定的键
}
var
  Key: HKEY;
begin
  Result := RegOpenKey(RootKey, PChar(SubKey), Key) = ERROR_SUCCESS;
  if Result then RegCloseKey(Key);
end;

function RegKeyDelete(const RootKey: HKEY; const SubKey: string): Boolean;
{
  删除注册表中指定的主键
}
begin
  Result := RegDeleteKey(RootKey, PChar(SubKey)) = ERROR_SUCCESS;
end;

function RegValueDelete(const RootKey: HKEY; const SubKey, ValueName: string): Boolean;
{
  删除注册表中指定的键值
}
var
  RegKey: HKEY;
begin
  Result := False;
  if RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_SET_VALUE, RegKey) = ERROR_SUCCESS then
  begin
    Result := RegDeleteValue(RegKey, PChar(ValueName)) = ERROR_SUCCESS;
    RegCloseKey(RegKey);
  end
end;

function RegGetValueNames(const RootKey: HKEY; const SubKey: string; Names: TStrings): Boolean;
{
  返回注册表中指定主键下的所有的键名列表
}
var
  RegKey: HKEY;
  I: DWORD;
  Size: DWORD;
  NumSubKeys: DWORD;
  NumSubValues: DWORD;
  MaxSubValueLen: DWORD;
  ValueName: string;
begin
  Result := False;
  if RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_READ, RegKey) = ERROR_SUCCESS then
  begin
    if RegQueryInfoKey(RegKey, nil, nil, nil, @NumSubKeys, nil, nil, @NumSubValues, @MaxSubValueLen, nil, nil, nil) = ERROR_SUCCESS then
    begin
      SetLength(ValueName, MaxSubValueLen + 1);
      if NumSubValues <> 0 then
        for I := 0 to NumSubValues - 1 do
        begin
          Size := MaxSubValueLen + 1;
          RegEnumValue(RegKey, I, PChar(ValueName), Size, nil, nil, nil, nil);
          Names.Add(PChar(ValueName));
        end;
      Result := True;
    end;
    RegCloseKey(RegKey);
  end;
end;

function RegGetKeyNames(const RootKey: HKEY; const SubKey: string; Names: TStrings): Boolean;
{
  返回注册表中指定主键下的所有子键的名称列表
}
var
  RegKey: HKEY;
  I: DWORD;
  Size: DWORD;
  NumSubKeys: DWORD;
  MaxSubKeyLen: DWORD;
  KeyName: string;
begin
  Result := False;
  if RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_READ, RegKey) = ERROR_SUCCESS then
  begin
    if RegQueryInfoKey(RegKey, nil, nil, nil, @NumSubKeys, @MaxSubKeyLen, nil, nil, nil, nil, nil, nil) = ERROR_SUCCESS then
    begin
      SetLength(KeyName, MaxSubKeyLen + 1);
      if NumSubKeys <> 0 then
        for I := 0 to NumSubKeys - 1 do
        begin
          Size := MaxSubKeyLen + 1;
          RegEnumKeyEx(RegKey, I, PChar(KeyName), Size, nil, nil, nil, nil);
          Names.Add(PChar(KeyName));
        end;
      Result := True;
    end;
    RegCloseKey(RegKey);
  end
end;

function IniReadString(const IniFile, Section, ValueName, Default: string): string;
var
  Buff: array[0..2047] of char;
begin
  SetString(Result, Buff, GetPrivateProfileString(PChar(Section), PChar(ValueName),
    PChar(Default), Buff, SizeOf(Buff), PChar(IniFile)));
end;

function IniWriteString(const IniFile, Section, ValueName, Value: string): Boolean;
begin
  Result := WritePrivateProfileString(PChar(Section), PChar(ValueName), PChar(Value), PChar(IniFile));
end;

function IniReadBinary(const IniFile, Section, ValueName: string; Data: PChar; Len: integer): Boolean;
begin
  Result := GetPrivateProfileStruct(PChar(Section), PChar(ValueName), Data, Len, PChar(IniFile));
end;

function IniWriteBinary(const IniFile, Section, ValueName: string; Data: PChar; Len: integer): Boolean;
begin
  Result := WritePrivateProfileStruct(PChar(Section), PChar(ValueName), Data, Len, PChar(IniFile));
end;

function IniReadInteger(const IniFile, Section, ValueName: string; Default: integer): integer;
begin
  try
    Result := StrToInt(IniReadString(IniFile, Section, ValueName, IntToStr(Default)));
  except
    Result := Default;
  end;
end;

function IniReadBool(const IniFile, Section, ValueName: string; Default: Boolean): Boolean;
begin
  try
    Result := StringToBoolDef(IniReadString(IniFile, Section, ValueName, BoolToStr(Default)), Default);
  except
    Result := Default;
  end;
end;

function IniWriteInteger(const IniFile, Section, ValueName: string; Value: integer): Boolean;
begin
  Result := IniWriteString(IniFile, Section, ValueName, IntToStr(Value));
end;

procedure RegisterFileType(AExt, AType, ADescription, AExe, AIcon: string; const AOpt: string = 'Open');
{
  注册文件类型
  AExt：需要注册的文件扩展名，需要包括'.'，例如：.txt
  AType：文件类型，例如：TextFile
  ADescription：该文件类型的描述，例如：Plan text file
  AExe：用来打开的Exe程序，例如：%SystemRoot%\Notepad.exe
  AIcon：文件类型对应的图标，例如：%SystemRoot%\Notepad.exe,1
         分为两个部分，用逗号分隔，第一部分为文件名，第二部分为索引
         也可以为Ico文件名
}
begin
  if AType = '' then
    AType := RegReadString(HKEY_CLASSES_ROOT, AExt, '')
  else
    RegWriteString(HKEY_CLASSES_ROOT, AExt, '', AType);

  if ADescription <> '' then
    RegWriteString(HKEY_CLASSES_ROOT, AType, '', ADescription);

  if AIcon <> '' then
    RegWriteString(HKEY_CLASSES_ROOT, AType + '\DefaultIcon', '', AIcon);

  RegWriteString(HKEY_CLASSES_ROOT, Format('%s\Shell\%s\Command', [AType, AOpt]), '',
    Format('"%s" "%%1"', [AExe]));
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

function UnRegisterFileType(AExt: string; const AOpt: string = 'open'): Boolean;
{
  取消注册一个文件类型，AExt必须包含'.'
}
var
  s: string;
begin
  Result := False;
  if RegKeyExists(HKEY_CLASSES_ROOT, AExt) then
  begin
    s := RegReadString(HKEY_CLASSES_ROOT, AExt, '');
    Result := RegKeyDelete(HKEY_CLASSES_ROOT, s + '\Shell\' + AOpt);
  end;
end;

function IsSoftIceRunning: Boolean;
var
  hFile: THandle;
  SICE: string;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    SICE := '\\.\NTICE'
  else
    SICE := '\\.\SICE';
  hFile := CreateFile(PChar(SICE), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(hFile);
    Result := True;
  end;
end;

procedure CheckParentProc(const Path: string);
var //检查自己的进程的父进程
  Pn: TProcesseNtry32;
  sHandle: THandle;
  H, ExplProc, ParentProc: Hwnd;
  Found: Boolean;
begin
  H := 0;
  ExplProc := 0;
  ParentProc := 0;
  //得到所有进程的列表快照
  sHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  Pn.dwSize := SizeOf(Pn);
  Found := Process32First(sHandle, Pn); //查找进程
  while Found do //遍历所有进程
  begin
    if Pn.th32ProcessID = GetCurrentProcessId then
    begin
      ParentProc := Pn.th32ParentProcessID; //得到父进程的进程ID
      //父进程的句柄
      H := OpenProcess(PROCESS_ALL_ACCESS, True, Pn.th32ParentProcessID);
    end
    else if Pos(Pn.szExeFile, Path) > 0 then
      ExplProc := Pn.th32ProcessID;      //Explorer的PID
    Found := Process32Next(sHandle, Pn); //查找下一个
  end;
  //嗯，父进程不是Explorer，是调试器……
  if ParentProc <> ExplProc then
  begin
    TerminateProcess(H, 0); //杀之！除之而后快耶！ :)
    //你还可以加上其它什么死机代码来消遣消遣这位可爱的Cracker :)
  end;
end;

procedure UnAsmCode;
{
  简单的花指令，对抗破解
  本代码无法静态反汇编
}
asm
  Push eax;
  mov eax, 209h;
  jnz @@a1
  db 90h
  jz @@a1
@@a1:
  mov al, 1
  pop eax;
end;

procedure SetLengthEx(var S: string; Len: integer);
begin
  SetLength(S, Len);
  FillChar(PChar(S)^, Len, 0);
end;

function WriteEventLog(const FromApp, Msg: string; const EventID: DWORD = 0; const EventLog_Type: Word = 4): Boolean;
{
  写入Windows Event Log
}
var
  EHwnd: THandle;
  Buffer: Pchar;
begin
  Result := False;
  EHwnd := RegisterEventSource(nil, PChar(FromApp));
  if EHwnd = 0 then exit;
  Buffer := pchar(Msg);
  Result := ReportEvent(EHwnd, EventLog_Type, 0, EventID, nil, 1, 0, @Buffer, nil);
  DeregisterEventSource(EHwnd);
end;

function RegisterEventlogSource(const FromApp, ResourceFile: string): Boolean;
begin
  Result := RegWriteInteger(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + FromApp,
                  'TypesSupported', 7)
            and RegWriteString(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + FromApp,
                  'EventMessageFile', ResourceFile);
end;

{-------------------------------------------------------------------------------
  过程名:    WinExecAndWait32
  作者:      Kingron
  日期:      2004.03.25
  参数:      FileName: string; Visibility: integer; TimeOut: integer
  返回值:    integer
  说明:      运行一个进程，并等待其结束
             FileName为命令行；Visibility：是否可见；TimeOut：运行超时
-------------------------------------------------------------------------------}

function WinExecAndWait32(FileName: string; Visibility: integer; TimeOut: DWORD): integer;
{ returns -1 if the Exec failed, otherwise returns the process' }
{ exit code when the process terminates.                        }
var
  zAppName: array[0..512] of char;
  zCurDir: array[0..255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, { pointer to command line string }
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    false, { handle inheritance flag }
    CREATE_NEW_CONSOLE or { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil, { pointer to new environment block }
    nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo) then { pointer to PROCESS_INF }
    Result := -1
  else
  begin
    case WaitforSingleObject(ProcessInfo.hProcess, TimeOut) of
      WAIT_TIMEOUT: TerminateProcess(ProcessInfo.hProcess, Cardinal(Result));
    else
      GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
    end;
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//       Network/Internet function & procedure
//////////////////////////////////////////////////////////////////////////////

function IsLocalComputer(const Computer: string): Boolean;
{
  判断给定的计算机名/IP是不是本机
}
begin
  Result := SameText(Computer, 'localhost') or SameText('127.0.0.1', Computer)
    or SameText(Computer, GetComputerNameEx) or SameText(Computer, LocalIP)
    or SameText(Computer, '.') or IsEmptyStr(Trim(Computer));
end;

function IsConnectNet: Boolean;
{
  判断是否连接到了网络，是，返回True
}
begin
  Result := GetSystemMetrics(SM_NETWORK) <> 0;
end;

function GetSQLServerList(List: TStrings): boolean;
{
  返回当前的SQL Server服务器的列表，需要SQLDMO支持
}
var
  i: integer;
  SQLServer: Variant;
  ServerList: Variant;
begin
  try
    SQLServer := CreateOleObject('SQLDMO.Application');
    ServerList := SQLServer.ListAvailableSQLServers;
    for i := 1 to Serverlist.Count do
      list.Add(Serverlist.item(i));
    Result := True;
  finally
    VarClear(SQLServer);
    VarClear(ServerList);
  end;
end;

function GetShareResources(Computer: string; List: TStrings): Boolean;
type
  TNetResourceArray = ^TNetResource; //网络类型的数组
var
  i: Integer;
  Buf: Pointer;
  Temp: TNetResourceArray;
  lphEnum: THandle;
  NetResource: TNetResource;
  Count, BufSize, Res: DWord;
begin
  Result := False;
  if copy(Computer, 0, 2) <> '\\' then
    Computer := '\\' + Computer;
  FillChar(NetResource, SizeOf(NetResource), 0);
  NetResource.lpRemoteName := @Computer[1];

  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY,
    RESOURCEUSAGE_CONNECTABLE, @NetResource, lphEnum);
  if Res <> NO_ERROR then exit;
  BufSize := 8192;
  GetMem(Buf, BufSize);
  while True do
  begin
    Count := $FFFFFFFF;
    BufSize := 8192;
    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
    if Res = ERROR_NO_MORE_ITEMS then break;
    if (Res <> NO_ERROR) then Exit;
    Temp := TNetResourceArray(Buf);
    for i := 0 to Count - 1 do
    begin
      List.Add(Temp^.lpRemoteName);
      Inc(Temp);
    end;
  end;
  Res := WNetCloseEnum(lphEnum); //关闭一次列举
  if Res <> NO_ERROR then exit; //执行失败
  Result := True;
  FreeMem(Buf);
end;

function GetGroupComputers(GroupName: string; List: TStrings): Boolean;
type
  TNetResourceArray = ^TNetResource; //网络类型的数组
var
  i: Integer;
  Buf: Pointer;
  Temp: TNetResourceArray;
  lphEnum: THandle;
  NetResource: TNetResource;
  Count, BufSize, Res: DWord;
begin
  Result := False;
  FillChar(NetResource, SizeOf(NetResource), 0); //初始化网络层次信息
  NetResource.lpRemoteName := @GroupName[1]; //指定工作组名称
  NetResource.dwDisplayType := RESOURCEDISPLAYTYPE_SERVER; //类型为服务器（工作组）
  NetResource.dwUsage := RESOURCEUSAGE_CONTAINER;
  NetResource.dwScope := RESOURCETYPE_DISK; //列举文件资源信息
  //获取指定工作组的网络资源句柄
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
    RESOURCEUSAGE_CONTAINER, @NetResource, lphEnum);
  if Res <> NO_ERROR then Exit; //执行失败
  BufSize := 8192; //缓冲区大小设置为8K
  GetMem(Buf, BufSize); //申请内存，用于获取工作组信息
  while True do {//列举指定工作组的网络资源}
  begin
    Count := $FFFFFFFF; //不限资源数目
    BufSize := 8192; //缓冲区大小设置为8K
    //获取计算机名称
    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
    if Res = ERROR_NO_MORE_ITEMS then break; //资源列举完毕
    if (Res <> NO_ERROR) then Exit; //执行失败
    Temp := TNetResourceArray(Buf);
    for i := 0 to Count - 1 do {//列举工作组的计算机名称}
    begin
      //获取工作组的计算机名称，+2表示删除"\\"，如\\wangfajun=>wangfajun
      List.Add(Temp^.lpRemoteName + 2);
      inc(Temp);
    end;
  end;
  Res := WNetCloseEnum(lphEnum); //关闭一次列举
  if Res <> NO_ERROR then exit; //执行失败
  Result := True;
  FreeMem(Buf);
end;

function GetWorkGroupList(List: TStrings): Boolean;
type
  TNetResourceArray = ^TNetResource; //网络类型的数组
var
  NetResource: TNetResource;
  Buf: Pointer;
  Count, BufSize, Res: DWORD;
  lphEnum: THandle;
  p: TNetResourceArray;
  i, j: SmallInt;
  NetworkTypeList: TList;
begin
  Result := False;
  NetworkTypeList := TList.Create;
  //获取整个网络中的文件资源的句柄，lphEnum为返回名柄
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
    RESOURCEUSAGE_CONTAINER, nil, lphEnum);
  if Res <> NO_ERROR then exit; //Raise Exception(Res);//执行失败
  //获取整个网络中的网络类型信息
  Count := $FFFFFFFF; //不限资源数目
  BufSize := 8192; //缓冲区大小设置为8K
  GetMem(Buf, BufSize); //申请内存，用于获取工作组信息
  Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
  //资源列举完毕                    //执行失败
  if (Res = ERROR_NO_MORE_ITEMS) or (Res <> NO_ERROR) then Exit;
  P := TNetResourceArray(Buf);
  for i := 0 to Count - 1 do {//记录各个网络类型的信息}
  begin
    NetworkTypeList.Add(p);
    Inc(P);
  end;
  Res := WNetCloseEnum(lphEnum); //关闭一次列举
  if Res <> NO_ERROR then exit;
  for j := 0 to NetworkTypeList.Count - 1 do {//列出各个网络类型中的所有工作组名称}
  begin //列出一个网络类型中的所有工作组名称
    NetResource := TNetResource(NetworkTypeList.Items[J]^); //网络类型信息
    //获取某个网络类型的文件资源的句柄，NetResource为网络类型信息，lphEnum为返回名柄
    Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
      RESOURCEUSAGE_CONTAINER, @NetResource, lphEnum);
    if Res <> NO_ERROR then break; //执行失败
    while true do {//列举一个网络类型的所有工作组的信息}
    begin
      Count := $FFFFFFFF; //不限资源数目
      BufSize := 8192; //缓冲区大小设置为8K
      GetMem(Buf, BufSize); //申请内存，用于获取工作组信息
      //获取一个网络类型的文件资源信息，
      Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
      //资源列举完毕                   //执行失败
      if (Res = ERROR_NO_MORE_ITEMS) or (Res <> NO_ERROR) then break;
      P := TNetResourceArray(Buf);
      for i := 0 to Count - 1 do {//列举各个工作组的信息}
      begin
        List.Add(StrPAS(P^.lpRemoteName)); //取得一个工作组的名称
        Inc(P);
      end;
    end;
    Res := WNetCloseEnum(lphEnum); //关闭一次列举
    if Res <> NO_ERROR then break; //执行失败
  end;
  Result := True;
  FreeMem(Buf);
  NetworkTypeList.Destroy;
end;

procedure GetNetSessions(ComputerNames: TStrings);
const
  MaxNetArrayItems = 512;
type
  TSessionInfo50 = packed record
    sesi50_cname: PChar; //remote computer name (connection id in Netware)
    sesi50_username: PChar;
    sesi50_key: DWORD; // used to delete session (not used in Netware)
    sesi50_num_conns: Word;
    sesi50_num_opens: Word; //not available in Netware
    sesi50_time: DWORD;
    sesi50_idle_time: DWORD; //not available in Netware
    sesi50_protocol: Char;
    padl: Char;
  end;

  TNetSessionEnum = function(const pszServer: PChar; sLevel: SmallInt;
    pbBuffer: Pointer; cbBuffer: Word; var pcEntriesRead: Word;
    var pcTotalAvail: Word): DWORD; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
var
  SessionInfo: array[0..MaxNetArrayItems] of TSessionInfo50;
  EntriesRead, TotalAvail: Word;
  I: Integer;
  Str: string;
  NetSessionEnum: TNetSessionEnum;
  LibHandle: THandle;
begin
  LibHandle := LoadLibrary('SVRAPI.DLL');
  if LibHandle <> 0 then
  try
    @NetSessionEnum := GetProcAddress(LibHandle, 'NetSessionEnum');
    if (@NetSessionEnum <> nil) then
      if NetSessionEnum(nil, 50, @SessionInfo, Sizeof(SessionInfo), EntriesRead, TotalAvail) = 0 then
        for I := 0 to EntriesRead - 1 do
          with SessionInfo[I] do
          begin
            SetString(Str, sesi50_cname, StrLen(sesi50_cname));
            ComputerNames.Add(Str);
          end;
  finally
    FreeLibrary(LibHandle);
  end;
end;

function InternetConnected: Boolean;
const
  INTERNET_CONNECTION_MODEM = 1; // local system uses a modem to connect to the Internet.
  INTERNET_CONNECTION_LAN = 2; // local system uses a local area network to connect to the Internet.
  INTERNET_CONNECTION_PROXY = 4; // local system uses a proxy server to connect to the Internet.
  INTERNET_CONNECTION_MODEM_BUSY = 8; // local system's modem is busy with a non-Internet connection.
var
  dwConnectionTypes: DWORD;
begin
  dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
end;

function IcmpPing(IpAddr: string): Boolean;
type
  PIPOptionInformation = ^TIPOptionInformation;
  TIPOptionInformation = packed record
    TTL: Byte; // Time To Live (used for traceroute)
    TOS: Byte; // Type Of Service (usually 0)
    Flags: Byte; // IP header flags (usually 0)
    OptionsSize: Byte; // Size of options data (usually 0, max 40)
    OptionsData: PChar; // Options data buffer
  end;

  PIcmpEchoReply = ^TIcmpEchoReply;
  TIcmpEchoReply = packed record
    Address: DWord; // replying address
    Status: DWord; // IP status value (see below)
    RTT: DWord; // Round Trip Time in milliseconds
    DataSize: Word; // reply data size
    Reserved: Word;
    Data: Pointer; // pointer to reply data buffer
    Options: TIPOptionInformation; // reply options
  end;

  TIcmpCreateFile = function: THandle; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  TIcmpCloseHandle = function(IcmpHandle: THandle): Boolean; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  TIcmpSendEcho = function(
    IcmpHandle: THandle;
    DestinationAddress: DWord;
    RequestData: Pointer;
    RequestSize: Word;
    RequestOptions: PIPOptionInformation;
    ReplyBuffer: Pointer;
    ReplySize: DWord;
    Timeout: DWord
    ): DWord; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}

const
  Size = 32;
  TimeOut = 1000;
var
  wsadata: TWSAData;
  Address: DWord; // Address of host to contact
  HostName, HostIP: string; // Name and dotted IP of host to contact
  Phe: PHostEnt; // HostEntry buffer for name lookup
  BufferSize, nPkts: Integer;
  pReqData, pData: Pointer;
  pIPE: PIcmpEchoReply; // ICMP Echo reply buffer
  IPOpt: TIPOptionInformation; // IP Options for packet to send
const
  IcmpDLL = 'icmp.dll';
var
  hICMPlib: HModule;
  IcmpCreateFile: TIcmpCreateFile;
  IcmpCloseHandle: TIcmpCloseHandle;
  IcmpSendEcho: TIcmpSendEcho;
  hICMP: THandle; // Handle for the ICMP Calls
begin
  // initialise winsock
  Result := True;
  if WSAStartup(2, wsadata) <> 0 then
  begin
    Result := False;
    Exit;
  end;
  // register the icmp.dll stuff
  hICMPlib := loadlibrary(icmpDLL);
  if hICMPlib = 0 then Exit;
  @ICMPCreateFile := GetProcAddress(hICMPlib, 'IcmpCreateFile');
  @IcmpCloseHandle := GetProcAddress(hICMPlib, 'IcmpCloseHandle');
  @IcmpSendEcho := GetProcAddress(hICMPlib, 'IcmpSendEcho');
  if (@ICMPCreateFile = nil) or (@IcmpCloseHandle = nil) or (@IcmpSendEcho = nil) then
  begin
    Result := False;
    halt;
  end;
  hICMP := IcmpCreateFile;
  if hICMP = INVALID_HANDLE_VALUE then
  begin
    Result := False;
    halt;
  end;
  // ------------------------------------------------------------
  Address := inet_addr(PChar(IpAddr));
  if (Address = DWord(INADDR_NONE)) then
  begin
    Phe := GetHostByName(PChar(IpAddr));
    if Phe = nil then
      Result := False
    else
    begin
      Address := longint(plongint(Phe^.h_addr_list^)^);
      HostName := Phe^.h_name;
      HostIP := StrPas(inet_ntoa(TInAddr(Address)));
    end;
  end
  else
  begin
    Phe := GetHostByAddr(@Address, 4, PF_INET);
    if Phe = nil then Result := False;
  end;

  if Address = DWord(INADDR_NONE) then
  begin
    Result := False;
  end;
  // Get some data buffer space and put something in the packet to send
  BufferSize := SizeOf(TICMPEchoReply) + Size;
  GetMem(pReqData, Size);
  GetMem(pData, Size);
  GetMem(pIPE, BufferSize);
  FillChar(pReqData^, Size, $AA);
  pIPE^.Data := pData;

  // Finally Send the packet
  FillChar(IPOpt, SizeOf(IPOpt), 0);
  IPOpt.TTL := 64;
  NPkts := IcmpSendEcho(hICMP, Address, pReqData, Size, @IPOpt, pIPE, BufferSize, TimeOut);
  if NPkts = 0 then Result := False;

  // Free those buffers
  FreeMem(pIPE);
  FreeMem(pData);
  FreeMem(pReqData);

  // --------------------------------------------------------------
  IcmpCloseHandle(hICMP);
  FreeLibrary(hICMPlib);
  // free winsock
  if WSACleanup <> 0 then Result := False;
end;

function GetNetTypeList(List: TStrings): Boolean;
type
  TNetResourceArray = ^TNetResource; //网络类型的数组
var
  p: TNetResourceArray;
  Buf: Pointer;
  i: SmallInt;
  lphEnum: THandle;
  Count, BufSize, Res: DWORD;
begin
  Result := False;
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
    RESOURCEUSAGE_CONTAINER, nil, lphEnum);
  if Res <> NO_ERROR then exit; //执行失败
  Count := $FFFFFFFF; //不限资源数目
  BufSize := 8192; //缓冲区大小设置为8K
  GetMem(Buf, BufSize); //申请内存，用于获取工作组信息
  Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize); //获取网络类型信息
  //资源列举完毕                    //执行失败
  if (Res = ERROR_NO_MORE_ITEMS) or (Res <> NO_ERROR) then Exit;
  P := TNetResourceArray(Buf);
  for i := 0 to Count - 1 do {//记录各个网络类型的信息}
  begin
    List.Add(p^.lpRemoteName);
    Inc(P);
  end;
  Res := WNetCloseEnum(lphEnum); //关闭一次列举
  if Res <> NO_ERROR then exit; //执行失败
  Result := True;
  FreeMem(Buf); //释放内存
end;

function NetSend(dest, Source, Msg: string): Longint; overload;
type
  TNetMessageBufferSendFunction = function(servername, msgname, fromname: PWideChar;
    buf: PWideChar; buflen: Cardinal): Longint;
  stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
var
  NetMessageBufferSend: TNetMessageBufferSendFunction;
  SourceWideChar: PWideChar;
  DestWideChar: PWideChar;
  MessagetextWideChar: PWideChar;
  Handle: THandle;
begin
  Handle := LoadLibrary('NETAPI32.DLL');
  if Handle = 0 then
  begin
    Result := GetLastError;
    Exit;
  end;
  @NetMessageBufferSend := GetProcAddress(Handle, 'NetMessageBufferSend');
  if @NetMessageBufferSend = nil then
  begin
    Result := GetLastError;
    Exit;
  end;

  MessagetextWideChar := nil;

  try
    GetMem(MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1);
    GetMem(DestWideChar, 20 * SizeOf(WideChar) + 1);
    StringToWideChar(Msg, MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1);
    StringToWideChar(Dest, DestWideChar, 20 * SizeOf(WideChar) + 1);

    if Source = '' then
      Result := NetMessageBufferSend(nil, DestWideChar, nil,
        MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1)
    else
    begin
      GetMem(SourceWideChar, 20 * SizeOf(WideChar) + 1);
      StringToWideChar(Source, SourceWideChar, 20 * SizeOf(WideChar) + 1);
      Result := NetMessageBufferSend(nil, DestWideChar, SourceWideChar,
        MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1);
      FreeMem(SourceWideChar);
    end;
  finally
    FreeMem(MessagetextWideChar);
    FreeLibrary(Handle);
  end;
end;

function NetCloseAll: boolean;
const
  NETBUFF_SIZE = $208;
type
  NET_API_STATUS = DWORD;
  LPByte = PByte;
const
  SVRAPI = 'svrapi.dll';
var
  dwNetRet: DWORD;
  i: integer;
  dwEntries: DWORD;
  dwTotalEntries: DWORD;
  szClient: LPWSTR;
  dwUserName: DWORD;
  Buff: array[0..NETBUFF_SIZE - 1] of byte;
  Adword: array[0..NETBUFF_SIZE div 4 - 1] of dword;
  NetSessionEnum: function(ServerName: LPSTR; Reserved: DWORD; Buf: LPByte; BufLen: DWORD;
    ConnectionCount: LPDWORD; ConnectionToltalCount: LPDWORD): NET_API_STATUS; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  NetSessionDel: function(ServerName: LPWSTR; UncClientName: LPWSTR; UserName: dword): NET_API_STATUS; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  LibHandle: THandle;
begin
  Result := false;
  try
    { 加载 DLL }
    LibHandle := LoadLibrary(PChar(SVRAPI));
    try
      { 如果加载失败，LibHandle = 0.}
      if LibHandle = 0 then
        raise Exception.Create(SErrLoadDLL + SVRAPI);
      { DLL 加载成功，取得到 DLL 输出函数的连接然后调用 }
      @NetSessionEnum := GetProcAddress(LibHandle, 'NetSessionEnum');
      @NetSessionDel := GetProcAddress(LibHandle, 'NetSessionDel');

      if (@NetSessionEnum = nil) or (@NetSessionDel = nil) then
        Exit
      else
      begin
        dwNetRet := NetSessionEnum(nil, $32, @Buff,
          NETBUFF_SIZE, @dwEntries,
          @dwTotalEntries);
        if dwNetRet = 0 then
        begin
          Result := true;
          for i := 0 to dwTotalEntries - 1 do
          begin
            Move(Buff, Adword, NETBUFF_SIZE);
            szClient := LPWSTR(Adword[0]);
            dwUserName := Adword[2];
            dwNetRet := NetSessionDel(nil, szClient, dwUserName);
            if (dwNetRet <> 0) then
            begin
              Result := false;
              break;
            end;
            Move(Buff[26], Buff[0], NETBUFF_SIZE - (i + 1) * 26);
          end
        end
        else
          Result := false;
      end;
    finally
      FreeLibrary(LibHandle); // Unload the DLL.
    end;
  except
  end;
end;

function NetConnect(const Computer, User, Password: string): Boolean;
var
  Info: _NETRESOURCE;
begin
  /// 关闭当前的连接
  WNetCancelConnection2(PChar('\\' + Computer), 0, True);

  /// 建立新的连接
  FillChar(Info, SizeOf(Info), 0);
  with Info do
  begin
    dwScope := RESOURCE_CONNECTED;
    dwType := RESOURCETYPE_ANY;
    dwDisplayType := RESOURCEDISPLAYTYPE_GENERIC;
    lpRemoteName := PChar('\\' + Computer);
  end;
  Result := WNetAddConnection2(Info, PChar(Password), PChar(User), CONNECT_INTERACTIVE) = NO_ERROR;
end;

function GetPDCName: string;
const
  NTlib = 'NETAPI32.DLL';
type
  NET_API_STATUS = DWORD;
var
  NTNetGetDCName: function(Server, Domain: pWideChar; DC: pWideChar): NET_API_STATUS; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  NTNetApiBufferFree: function(lpBuffer: Pointer): NET_API_STATUS; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  pDomain: array[0..255] of WideChar;
  LibHandle: THandle;
begin
  Result := '';
  LibHandle := LoadLibrary(NTlib);
  if LibHandle = 0 then
    raise Exception.Create('Unable to map library: ' + NTlib);
  try
    @NTNetGetDCName := GetProcAddress(Libhandle, 'NetGetDCName');
    @NTNetApiBufferFree := GetProcAddress(Libhandle, 'NetApiBufferFree');
    if NTNetGetDCName(nil, nil, pDomain) = 0 then Result := WideCharToString(pDomain);
  finally
    FreeLibrary(Libhandle);
  end;
end;

function GetDomainName: AnsiString;
type
  WKSTA_INFO_100 = record
    wki100_platform_id: Integer;
    wki100_computername: PWideChar;
    wki100_langroup: PWideChar;
    wki100_ver_major: Integer;
    wki100_ver_minor: Integer;
  end;

  WKSTA_USER_INFO_1 = record
    wkui1_username: PChar;
    wkui1_logon_domain: PChar;
    wkui1_logon_server: PChar;
    wkui1_oth_domains: PChar;
  end;
type
  //Win9X ANSI prototypes from RADMIN32.DLL and RLOCAL32.DLL

  TWin95_NetUserGetInfo = function(ServerName, UserName: PChar; Level: DWORD; var BfrPtr: Pointer): Integer; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  TWin95_NetApiBufferFree = function(BufPtr: Pointer): Integer; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  TWin95_NetWkstaUserGetInfo = function(Reserved: PChar; Level: Integer; var BufPtr: Pointer): Integer; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}

  //WinNT UNICODE equivalents from NETAPI32.DLL

  TWinNT_NetWkstaGetInfo = function(ServerName: PWideChar; level: Integer; var BufPtr: Pointer): Integer; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}
  TWinNT_NetApiBufferFree = function(BufPtr: Pointer): Integer; stdcall;
  {$IFNDEF _DLL_}external DLL;
  {$ENDIF}

  function IsWinNT: Boolean;
  var
    VersionInfo: TOSVersionInfo;
  begin
    VersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
    Result := GetVersionEx(VersionInfo);
    if Result then
      Result := VersionInfo.dwPlatformID = VER_PLATFORM_WIN32_NT;
  end;
var

  Win95_NetUserGetInfo: TWin95_NetUserGetInfo;
  Win95_NetWkstaUserGetInfo: TWin95_NetWkstaUserGetInfo;
  Win95_NetApiBufferFree: TWin95_NetApiBufferFree;

  WinNT_NetWkstaGetInfo: TWinNT_NetWkstaGetInfo;
  WinNT_NetApiBufferFree: TWinNT_NetApiBufferFree;

  WSNT: ^WKSTA_INFO_100;
  WS95: ^WKSTA_USER_INFO_1;

  EC: DWORD;
  hNETAPI: THandle;
begin
  try
    if IsWinNT then
    begin
      hNETAPI := LoadLibrary('NETAPI32.DLL');
      if hNETAPI <> 0 then
      begin
        @WinNT_NetWkstaGetInfo := GetProcAddress(hNETAPI, 'NetWkstaGetInfo');
        @WinNT_NetApiBufferFree := GetProcAddress(hNETAPI, 'NetApiBufferFree');

        EC := WinNT_NetWkstaGetInfo(nil, 100, Pointer(WSNT));
        if EC = 0 then
        begin
          Result := WideCharToString(WSNT^.wki100_langroup);
          WinNT_NetApiBufferFree(Pointer(WSNT));
        end;
      end;
    end
    else
    begin
      hNETAPI := LoadLibrary('RADMIN32.DLL');
      if hNETAPI <> 0 then
      begin
        @Win95_NetApiBufferFree := GetProcAddress(hNETAPI, 'NetApiBufferFree');
        @Win95_NetUserGetInfo := GetProcAddress(hNETAPI, 'NetUserGetInfoA');
        @Win95_NetWkstaUserGetInfo := GetProcAddress(hNETAPI, 'NetWkstaUserGetInfoA');

        EC := Win95_NetWkstaUserGetInfo(nil, 1, Pointer(WS95));
        if EC = 0 then
        begin
          Result := WS95^.wkui1_logon_domain;
          Win95_NetApiBufferFree(Pointer(WS95));
        end;
      end;
      if hNETAPI <> 0 then FreeLibrary(hNETAPI);
    end;
  finally
  end;
end;

function AdapterCount: Integer;
var
  Ncb: TNCB;
  uRetCode: Char;
  lEnum: TLanaEnum;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  with NCB do
  begin
    ncb_command := Char(NCBENUM);
    ncb_buffer := @lEnum;
    ncb_length := SizeOf(lEnum);
  end;
  uRetCode := Netbios(@Ncb);
  if uRetCode <> #0 then
    Result := -1
  else
    Result := Ord(lenum.length);
end;

function GetMacAddress(AdapterNum: Integer): string;
type
  TAStat = record
    Adapt: TAdapterStatus;
    NameBuff: array[0..30] of TNameBuffer;
  end;
var
  Ncb: TNCB;
  uRetCode: Char;
  Adapter: TAStat;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  with NCB do
  begin
    ncb_command := Char(NCBRESET);
    ncb_lana_num := Char(AdapterNum);
  end;
  uRetCode := Netbios(@Ncb);
  if uRetCode <> #0 then Exit;
  FillChar(NCB, SizeOf(NCB), 0);
  with NCB do
  begin
    ncb_command := Char(NCBASTAT);
    ncb_lana_num := Char(AdapterNum);
    StrCopy(ncb_callname, '*                ');
    ncb_buffer := @Adapter;
    ncb_length := sizeof(Adapter);
  end;
  uRetCode := Netbios(@Ncb);
  if uRetCode <> #0 then Exit;
  with Adapter.Adapt do
    Result := Format('%.2x-%.2x-%.2x-%.2x-%.2x-%.2x', [Ord(adapter_address[0]), Ord(adapter_address[1]),
      Ord(adapter_address[2]), Ord(adapter_address[3]), Ord(adapter_address[4]), Ord(adapter_address[5])]);
end;

function LocalIP: string;
{
  返回本机IP地址字符串
}
begin
  Result := HostToIP('');
end;

function IPToHost(IPAddr: string): string;
{
  转换指定IP为机器名或者域名
}
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  WSAStartup($101, WSAData);
  SockAddrIn.sin_addr.s_addr := inet_addr(PChar(IPAddr));
  HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
  if HostEnt <> nil then result := StrPas(Hostent^.h_name);
  WSACleanup;
end;

function HostToIP(Name: string): string;
{
  转换机器名或者域名为IP地址
}
var
  R: Integer;
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  SockAddr: TSockAddrIn;
begin
  Result := '';
  R := WSAStartup(MakeWord(1, 1), WSAData);
  if R = 0 then
  try
    HostEnt := GetHostByName(PChar(Name));
    if HostEnt <> nil then
    begin
      SockAddr.sin_addr.S_addr := Longint(PLongint(HostEnt^.h_addr_list^)^);
      Result := inet_ntoa(SockAddr.sin_addr);
    end;
  finally
    WSACleanup;
  end;
end;

function IsIPInstalled: boolean;
{
  返回TCP/IP协议是否安装
}
var
  WSData: TWSAData;
  ProtoEnt: PProtoEnt;
begin
  Result := True;
  try
    if WSAStartup(2, WSData) = 0 then
    begin
      ProtoEnt := GetProtoByName('IP');
      if ProtoEnt = nil then
        Result := False
    end;
  finally
    WSACleanup;
  end;
end;

procedure OpenURL(const URL: string);
begin
  ShellExecute(GetActiveWindow, 'open', PChar(URL), nil, nil, SW_SHOW);
end;

procedure OpenExplorer(const FileSpec: string);
begin
  ShellExecute(GetActiveWindow, 'open', 'explorer.exe', PChar('/e, /select,' + FileSpec), nil, SW_MAXIMIZE);
end;

procedure SendMail(Subject, Body, RecvAddress: string; Attachs: TStrings); overload;
{
  使用MSMAPI发送电子邮件，支持附件！
  Need M$ MS MAPI COM & License
}
var
  MM, MS: Variant;
  i: integer;
begin
  CoInitialize(nil);
  MM := CreateOleObject('MSMAPI.MAPIMessages');
  MS := CreateOleObject('MSMAPI.MAPISession');

  MS.DownLoadMail := False;
  MS.NewSession := False;
  MS.LogonUI := True;
  MS.SignOn;
  MM.SessionID := MS.SessionID;

  MM.Compose;
  MM.RecipIndex := 0;
  MM.RecipAddress := RecvAddress;
  MM.MsgSubject := Subject;
  MM.MsgNoteText := Body;

  for i := 0 to Attachs.Count - 1 do
  begin
    MM.AttachmentIndex := i;
    MM.AttachmentPathName := Attachs[i];
  end;
  MM.Send(True);
  MS.SignOff;
  VarClear(MS);
  VarClear(MM);
  CoUninitialize;
end;

function URLDecode(psSrc: string): string;
{
/// URLDecode modified by Kingron,
/// Support IE6 URL encode: %u3FE5%uA805test
  改进的URLDecode函数，支持%u3FE5test格式
}
var
  i: Integer;
  ESC: string[2];
  CharCode: integer;
  WESC: string[4];
begin
  Result := ''; { do not localize }
  psSrc := StringReplace(psSrc, '+', ' ', [rfReplaceAll]); {do not localize}
  i := 1;
  while i <= Length(psSrc) do
  begin
    if psSrc[i] <> '%' then { do not localize }
    begin {do not localize}
      Result := Result + psSrc[i]
    end
    else
    begin
      Inc(i);
      if (psSrc[i] = 'u') and (i > 1) and (psSrc[i - 1] = '%') then
      begin
        Inc(i);
        WESC := Copy(psSrc, i, 4);
        try
          CharCode := StrToInt('$' + WESC);
          if (CharCode > 0) and (CharCode < 65536) then
            Result := Result + WideChar(CharCode);
        except
        end;
        Inc(i, 3);
      end
      else
      begin
        ESC := Copy(psSrc, i, 2);
        Inc(i, 1);
        try
          CharCode := StrToInt('$' + ESC); {do not localize}
          if (CharCode > 0) and (CharCode < 256) then
            Result := Result + Char(CharCode);
        except
        end;
      end;
    end;
    Inc(i);
  end;
end;

function URLEncode(const psSrc: string): string;
const
  UnsafeChars = ' *#%<>{}'; {do not localize}
var
  i: Integer;
begin
  Result := ''; { do not localize }
  for i := 1 to Length(psSrc) do
  begin
    if (Pos(psSrc[i], UnsafeChars) > 0) or (psSrc[i] >= #$80) then
    begin
      Result := Result + '%' + IntToHex(Ord(psSrc[i]), 2); {do not localize}
    end
    else
    begin
      Result := Result + psSrc[i];
    end;
  end;
end;

const
  CSHTMLTags: array[0..2, 0..1] of string = (
    ('<', '&lt;'),
    ('>', '&gt;'),
    (#13#10, '<BR>')
    );

function HTMLEncode(const Source: string): string;
{
  HTML编码，把一个字符串变成HTML格式的语法，例如<font>替换为&lt;font&gt
}
var
  i: integer;
begin
  Result := Source;
  for i := Low(CSHTMLTags) to High(CSHTMLTags) do
    Result := ReplaceString(Result, CSHTMLTags[i, 0], CSHTMLTags[i, 1]);
end;

function HTMLDecode(const Source: string): string;
{
  HTML解码，把一个HTML字符串转换成原始数据，例如'&lt;font&gt'='<font>'
}
var
  i: integer;
begin
  Result := Source;
  for i := Low(CSHTMLTags) to High(CSHTMLTags) do
    Result := ReplaceString(Result, CSHTMLTags[i, 1], CSHTMLTags[i, 0]);
end;

function BeepEx(Freq: Word; Delay: DWORD): Boolean;
{
  PC喇叭发声，支持Win9x和NT平台
}
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := windows.Beep(Freq, Delay)
  else
  begin
    Result := Freq > 18;
    if not Result then Exit;
    Freq := 1193181 div Freq;
    asm
        mov al,0b6H
        out 43H,al
        mov ax, Freq
        //xchg al, ah
        out 42h,al
        xchg al, ah
        out 42h,al
        in  al,61H
        or  al,03H
        out 61H,al
    end;
    Sleep(Delay);
    asm
        in  al,61H
        and al,0fcH
        out 61H,al
    end;
  end;
end;

//==============================================================================

procedure ClearIECache;
var
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord;
  dwEntrySize: LongWord;
begin
  dwEntrySize := 0;
  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  if dwEntrySize > 0 then lpEntryInfo^.dwStructSize := dwEntrySize;
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if hCacheDir <> 0 then
    repeat
      DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
      FreeMem(lpEntryInfo, dwEntrySize);
      dwEntrySize := 0;
      FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
      GetMem(lpEntryInfo, dwEntrySize);
      if dwEntrySize > 0 then lpEntryInfo^.dwStructSize := dwEntrySize;
    until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize);
  FreeMem(lpEntryInfo, dwEntrySize);
  FindCloseUrlCache(hCacheDir);
end;

function GetKeyLock(VK: word): Boolean;
var
  KeyS: TKeyboardState;
begin
  Result := GetKeyboardState(KeyS) and (KeyS[VK] = 1);
end;

procedure TaggleKeyLock(VKey: integer);
{
  切换键盘指示灯，例：TaggleKeyLock(VK_NUMLOKC);
}
begin
  keybd_event(VKey, MapVirtualKey(VKey, 0), KEYEVENTF_EXTENDEDKEY or 0, 0);
  keybd_event(VKey, MapVirtualKey(VKey, 0), KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
end;

function MakeLangID(const Pre, Sub: Byte): word;
{
  翻译的SDK的宏，把Pre和Sub变换成一个语言ID
}
begin
  Result := Pre or (Sub shl 10);
end;

function MakeLCID(const lgid, srtid: word): dword;
begin
  Result := lgid or (srtid shl 16);
end;

function SetScreenResolution(Width, Height: DWord): Boolean;
{
  设置屏幕分辨率,Width,height分别指定屏幕的宽和高
  如果成功,返回True，否则返回False
}
var
  lpDevMode: TDeviceMode;
begin
  lpDevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
  lpDevMode.dmPelsWidth := Width;
  lpDevMode.dmPelsHeight := Height;
  Result := ChangeDisplaySettings(lpDevMode, 0) = DISP_CHANGE_SUCCESSFUL;
end;

function GetLastErrorString: string;
{
  获取最后一次API操作的错误信息
}
begin
  Result := SysErrorMessage(GetLastError);
end;

function sscanf(Data: string; Format: string; const Args: array of const): Integer;
{
  提供类似C语言中的sscanf类似的功能！基本上兼容C的格式，所支持的所有格式参考下面
  的英文注释信息
  例：
    var
      a,b:integer;
      ....
      sscanf('12, 13','%d %d',[@a,@b]);
  一下是原作者 Clinton R. Johnson 提供的注释
//
// (C) Clinton R. Johnson January 27, 1999.
//
// see accompanying readme.txt for terms and conditions of use.
//
// You may freely re-use and re-distribute this source code.
//
//*****************************************************************************
// Warning : My document writing skills are a little rusty.  Any C or C++
// reference provides excellent documentation for the scanf function.  There
// are only a few differences between the C and C++ implementation, and this
// implementation for Delphi.
//
// sscanf is a data parsing procedure.  It reads data from DATA, and places the
// values into arguments passed in ARGS.  Format is a series of format specifiers
// that indicate how to parse data from DATA.
//
//
// Format :
//          Format Specifiers
//          White space characters
//          Non White Space characters.
//
// Format Specifiers :
//
// Format specifiers start with a %, contain an optional storage specifier, an
// optional width specifier, and a field type specifier.  Strings and characters
// also have a additional SET specifer.  Text in the format string, which is not a
// format specifier, is LITTERAL text.  It must match exactly, AND IS CASE SENSITIVE.
//
// The only exception for format specifiers is %%, which matches a litteral % instead of
// indicating a format specifier.
//
//    Storage specifier :   *  - If * is included in the  format specifier, the
//                               field is parsed, checked for type but is not
//                               stored.
//    Width Specifier :     123 - If a numeric value is included between the
//                                % and the type specifier, the value indicates
//                                the maximum length of the data read from the
//                                string.  For character types, it is expected
//                                that the pointer passed points at an array
//                                large enough to hold the data.
//
//    Set Specifier :  [ab-c]  - A set of characters which are acceptable in
//                               the string or char.  This overrides the normal white
//                               space detection used to indicate the end of a string or
//                               array of chars.
//                               Set members are listed without break.
//                               Ranges can be indicated with a hyphen.  Ranges MUST be
//                               presented in accending order (a-z is valid, z-a is NOT).

//                               *** UNLIKE C, \ is used to indicate a litteral character.
//                               \[ - [
//                               \\ - \
//                               \] - ]
//                               \- - -
//
//                               Dashes which are the first or last character of
//                               the set are interpreted litterally as a member of the set.
//
//                               If the first character of the set is a ^, then the set is
//                               inverted and members are EXCLUDED from the set.
//
//                               ie :
//                                   []     DEFAULT SET- Accepts anything except whitespace.
//                                   [abc]  accepts a, b or c.
//                                   [^abc] accepts anything EXCEPT a,b or c.
//                                   [^]    accepts anything.  ** NOTE, this differs from C,C++.
//                                   [a-cA-C]  Accepts a,b,c,A,B, or C
//
//                               WARNING : SETS ARE CASE SENSITIVE.
//
//                               NOTE : C and C++ use the %[] format without type specifier
//                                      implies a CHAR type.  FOR THIS IMPLEMENTATION,
//                                      NO TYPE SPECIFIER IMPLIES A STRING TYPE.  The only
//                                      other valid specifer is c for char.
//                               ie :
//                                     %[abc]    -> String set
//                                     %[abc]c   -> char set, width of 1.
//                                     %4[abc]c  -> char set, max width of 4.
//                                     %[abc]s   -> String set, followed by a litteral s.
//
//  TYPE SEPECIFIERS

// Type + Data Type     + REQUIRED DATA TYPE
// -----+---------------+-------------------
//   c  | Char          | char
//   d  | INTEGER       | Integer (32 bit, signed)
//   e  | Extended      | Extended
//   f  | Extended      | Extended
//   g  | Extended      | Extended
//   h  | ShortInt      | ShortInt (16 bit, signed)
//   i  | Integer       | Int64 (64 bit, signed)
//   m  | Money         | Currency (may not contain currency symbol, must use standard +- sign indications)
//   n  | Number Read   | Integer -> Returns the # of chars read from DATA so far.
//   p  | Pointer       | Pointer  (32 bit pointer always)
//   s  | String        | Ansistring or shortstring
//   u  | Unsigned      | Cardinal  (32bit)
//   x  | Hex           | Integer or Cardinal (32bit value)
//
//  Integers can be Hex values.  Hex values can start with $ or 0x.  HEx values read with
// the %x format specifier do not need a leading $ or 0x, but it is accepted.
//
// ARGUMENTS
//                               All variables, with the exception of shortstrings are passed
//                               by reference (pointers).  This means that the risk of
//                               data corruption is high.  You must be absolutely sure you are
//                               passing a pointer to the correct data type, otherwise data
//                               corruption is likely.  (ie : passing a pointer to a Integer, when
//                               the return result is an array of 20 characters, or an extended).
//
//                               In order to pass a variable by refrence, preceed the variable
//                               name with an @ sign.
//
//                               ie :
//
//                               Var S1,S2 : String; i1 : Integer;
//
//                                    sscanf('Hello, World! 22','%s%s',[@s1,@s2,@i1])
//
//                               NOTE : It is highly recommended that you always use ANSIStrings
//                                      instead of ShortStrings.
//
//                               NOTE : NEVER pass shortstrings by reference, pass the variable
//                                      without a preceeding @.
//
//                               Var S1 : ShortString; S2 : String;
//
//                                    sscanf('Hello, World!','%s%s',[s1,@s2])
//
// Returns :  The # of results successfully returned.  Unlike C and C++, this implementation
//            never returns EOF (-1).
//
}
const
  WhiteSpace: set of Char = [#32, #8, #13, #10];
type
  TFieldType = (ftChar, ftSmallInt, ftInteger, ftInt64, ftFloating, ftCurrency, ftString,
    ftHex, ftPointer, ftCount, ftUnsigned, ftLitteral, ftWhiteSpace);

  procedure CreateSet(Source: string; var ResultSet: TSysCharSet);
    //*****************************************************************************
    // Creates a set of char from a set specifier.
    //
    //    Set Specifier :  'ab-c'  - A set is built from a source string.  It may contain
    //                               a series or characters, or ranges.
    //                               Series of characters are listed without break.
    //                               Ranges can be indicated with a hyphen.  Ranges MUST be
    //                               presented in accending order (a-z is valid, z-a is NOT).
    //                               You must use the '\' to indicate litteral characters,
    //                               This allows you to include the hypen character anywhere
    //                               without indiciating a range.
    //
    //                               '\\' -> '\'
    //                               '\-' -> '-'
    //
    //                               Dashes which are the first or last character of
    //                               the set are interpreted litterally as a member of the set.
    //
    //                               If the first character of the set is a ^, then the set is
    //                               inverted and members are EXCLUDED from the set.
    //
    //                               ie :
    //                                   ''     DEFAULT SET- Accepts anything except whitespace.
    //                                   'abc'  accepts a, b or c.
    //                                   '^abc' accepts anything EXCEPT a,b or c.
    //                                   '^'    accepts anything.  ** NOTE, this differs from C,C++.
    //                                   'a-cA-C'  Accepts a,b,c,A,B, or C
    //                                   'abc\-\\0-9' Accepts a,b,c,-,\,0,1,2,3,4,5,6,7,8,9
    //
    //                               WARNING : SETS ARE CASE SENSITIVE.
    //
  var
    At: Integer;

    function GetToken(IsLitteral: Boolean = false): Char;
    begin
      if (At <= Length(Source)) then
      begin
        Result := Source[At];
        Inc(at);
        if (not IsLitteral) then
        begin
          if (Result = '\') then // Litteral character.
            Result := GetToken(True);
          // Provides support for embeded control characters with the standard Pascal ^a format.
          // Removed because ^ has a special meaning for scanf sets.  Kept for future reference.
          (*      Else If (Result='^') Then
                Begin
                  Result := UpCase(GetToken(True));
                  If Not (Result in [#64..#95]) Then
                  Begin
                    Raise Exception.Create('BAD SET : '+Source);
                  End;
                  Result := Char(Byte(Result)-64);
                End; *)
        end;
      end
      else
        raise Exception.Create(SErrBadSet + Source);
    end;
  var
    Token: Char;
    EndToken: Char;
    LoopToken: Char;
    Negate: Boolean;
  begin
    ResultSet := [];
    At := 1;
    Negate := (Copy(Source, 1, 1) = '^');
    if Negate then
    begin
      Delete(Source, 1, 1);
      ResultSet := [#0..#255];
    end;
    while (At <= Length(Source)) do
    begin
      Token := GetToken;
      EndToken := Token;

      if (Copy(Source, At, 1) = '-') and (At <> Length(Source)) then {// This is a range.}
      begin
        Inc(At, 1); // Go past dash.

        if At > Length(Source) then
          raise Exception.Create(SErrBadSet + Source);
        EndToken := GetToken;
      end;

      if (EndToken < Token) then // Z-A is probably the result of a missing letter.
        raise Exception.Create(SErrBadSet + Source);

      for LoopToken := Token to EndToken do
        case Negate of
          False: Include(ResultSet, LoopToken);
          True: Exclude(ResultSet, LoopToken);
        end;
    end;
  end;

  function GetToken(Str: string; var At: Integer): Char;
  begin
    if At <= Length(Str) then
    begin
      Result := Str[At];
      Inc(At);
    end
    else
    begin
      At := Length(Str) + 1;
      raise Exception.Create(SErrBadFormat);
    end;
  end;

  function PeekToken(Str: string; var At: Integer): Char;
  begin
    if (At <= Length(Str)) then
      Result := Str[At]
    else
      Result := #0;
  end;

  function GetScanfToken(Format: string; var At: Integer): string;
  var
    Token: Char;
    TokenDone: Boolean;
    BuildingSet: Boolean;
  begin
    Token := GetToken(Format, At);
    if (Token = '%') then
    begin
      Result := Token;
      BuildingSet := False;
      TokenDone := False;
      repeat
        Token := GetToken(Format, At);
        Result := Result + Token;
        if (Token = '\') and (BuildingSet) then
        begin
          Token := GetToken(Format, At);
          Result := Result + Token;
        end
        else if (Token = '[') then
        begin
          BuildingSet := True;
        end
        else if (Token = ']') then
        begin
          BuildingSet := False;
          Token := PeekToken(Format, At);
          if Token in ['C', 'c'] then
          begin
            Token := GetToken(Format, At);
            Result := Result + Token;
          end;
          TokenDone := True;
        end
        else if (Token in ['*', '0'..'9']) or BuildingSet then
        begin
          // Data is accepted and added to the tag.
        end
        else
          TokenDone := True;
      until TokenDone;
    end
    else
    begin
      Result := Token;
      while (Token in WhiteSpace) do
      begin
        Token := PeekToken(Format, At);
        if (Token in WhiteSpace) then Token := GetToken(Format, At);
      end;
    end;
  end;

  procedure InterpretScanToken(ScanToken: string; var FieldType: TFieldType;
    var FieldWidth: Integer; var CharSet: TSysCharSet; var Stored: Boolean);
  var
    TokenChar: Char;
    At: Integer;
    EndAt: Integer;
    Frag: string;
    Token: Char;
  begin
    CharSet := [];
    if (Copy(ScanToken, 1, 1) = '%') then
    begin
      Delete(ScanToken, 1, 1);
      TokenChar := ScanToken[Length(ScanToken)];
      if (TokenChar <> ']') then
        Delete(ScanToken, Length(ScanToken), 1)
      else
        TokenChar := 's';
      At := Pos('[', ScanToken);
      if (At <> 0) then
      begin
        EndAt := At;
        Token := GetToken(ScanToken, EndAt);
        while (Token <> ']') do
        begin
          Token := GetToken(ScanToken, EndAt);
          if (Token = '\') then
          begin
            Token := GetToken(ScanToken, EndAt);
            if (Token = ']') then Token := #0; // Skip Litteral ]'s.
          end;
        end;
        Dec(EndAt);
        Frag := Copy(ScanToken, At + 1, EndAt - At - 1);
        Delete(ScanToken, At, EndAt - At + 1);
        CreateSet(Frag, CharSet);
      end
      else
        CharSet := [];
      At := Pos('*', ScanToken);
      Stored := (At = 0);
      if not Stored then Delete(ScanToken, At, 1);
      if (ScanToken <> '') then
      begin
        try
          FieldWidth := StrToInt(ScanToken);
        except
          raise Exception.Create(SErrBadFormat);
        end;
      end
      else
        FieldWidth := -1;
      case TokenChar of
        'c':
          begin
            FieldType := ftChar;
            if (FieldWidth = -1) then FieldWidth := 1;
          end;
        'd':
          begin
            FieldType := ftInteger;
            CharSet := ['0'..'9', '-'];
          end;
        'e', 'f', 'g':
          begin
            FieldType := ftFloating;
            CharSet := ['0'..'9', '.', '+', '-', 'E', 'e'];
          end;
        'i':
          begin
            FieldType := ftInt64;
            CharSet := ['0'..'9', '-'];
          end;
        'h':
          begin
            FieldType := ftSmallInt;
            CharSet := ['0'..'9', '-'];
          end;
        'm':
          begin
            FieldType := ftCurrency;
            CharSet := ['0'..'9', '-'];
          end;
        's':
          begin
            FieldType := ftString;
          end;
        'x':
          begin
            FieldType := ftHex;
            CharSet := ['0'..'9', '$', 'x', 'X', '-'];
          end;
        'p':
          begin
            FieldType := ftPointer; // All pointers are 32 bit.
            CharSet := ['0'..'9', '$', 'x', 'X', '-'];
          end;
        'u':
          begin
            FieldType := ftUnsigned;
            CharSet := ['0'..'9'];
          end;
        '%':
          begin
            FieldType := ftLitteral;
            if (FieldWidth <> -1) or (not Stored) or (CharSet <> []) then
              raise Exception.Create(SErrBadFormat);
            Stored := False;
          end;
      else
        raise Exception.Create(SErrBadFormat);
      end;
    end
    else
    begin
      if (ScanToken[1] in WhiteSpace) then
      begin
        FieldType := ftWhiteSpace;
        FieldWidth := -1;
        Stored := False;
        CharSet := [];
      end
      else
      begin
        FieldType := ftLitteral;
        FieldWidth := Length(ScanToken);
        Stored := False;
        CharSet := [];
      end;
    end;
  end;

  function GetDataToken(Data: string; var DataAt: Integer; var OutOfData: Boolean;
    FieldType: TFieldType; FieldWidth: Integer; CharSet: TSysCharSet): string;
  var
    Token: Char;
  begin
    OutOfData := False;
    Result := '';
    if (FieldType = ftChar) then
    begin
      try
        GetToken(Data, DataAt);
      except
        OutOfData := True;
        Exit; // Hit End of string.
      end;
    end
    else
    begin
      Token := #32;
      while (Token in WhiteSpace) do
      begin
        try
          Token := GetToken(Data, DataAt);
        except
          OutOfData := True;
          Exit; // Hit End of string.
        end;
      end;
      if (FieldType = ftWhiteSpace) then
      begin
        Dec(DataAt); // Unget the last token.
        Exit;
      end;
    end;

    if (CharSet = []) then
    begin
      CharSet := [#0..#255];
      if (FieldType <> ftChar) then CharSet := CharSet - WhiteSpace;
    end;

    Dec(DataAt); // Unget the last token.
    while ((FieldWidth = -1) or (Length(Result) < FieldWidth)) do {// Check Length}
    begin
      Token := PeekToken(Data, DataAt);
      if (Token in CharSet) then
      begin
        try
          Token := GetToken(Data, DataAt);
          Result := Result + Token;
        except
          Break;
        end;
      end
      else
        Break;
    end;
  end;

  function CheckFieldData(Data: string; FieldType: TFieldType): Boolean;
  begin
    try
      case FieldType of
        //      ftChar            : Begin End;
        ftSmallInt: StrToInt(Data);
        ftInteger: StrToInt(Data);
        ftInt64: StrToInt64(Data);
        ftFloating: StrToFloat(Data);
        ftCurrency: StrToFloat(Data);
        //      ftString          : Begin End;
        ftHex:
          begin
            if (AnsiUpperCase(Copy(Data, 1, 2)) = '0X') then Delete(Data, 1, 2);
            if (Copy(Data, 1, 1) <> '$') then Data := '$' + Data;
            StrToInt(Data)
          end;
        ftPointer: StrToInt(Data);
        //      ftCount           : Begin End;
        ftUnsigned: StrToInt64(Data);
      end;
      Result := True;
    except
      Result := False;
    end;
  end;

  function StoreData(Data: string; FieldType: TFieldType; FieldWidth: Integer;
    DataAt: Integer; P: Pointer; VType: Integer): Boolean;
  begin
    try
      case FieldType of
        ftChar:
          begin
            Move(Data[1], P^, FieldWidth);
          end;
        ftSmallInt: SmallInt(P^) := StrToInt(Data);
        ftInteger: Integer(P^) := StrToInt(Data);
        ftInt64: Int64(P^) := StrToInt64(Data);
        ftFloating: Extended(P^) := StrToFloat(Data);
        ftCurrency: Currency(P^) := StrToFloat(Data);
        ftString:
          begin
            if (VType = vtString) then
              ShortString(P^) := Data
            else
              string(P^) := Data;
          end;
        ftHex:
          begin
            if (AnsiUpperCase(Copy(Data, 1, 2)) = '0X') then Delete(Data, 1, 2);
            if (Copy(Data, 1, 1) <> '$') then Data := '$' + Data;
            Integer(P^) := StrToInt(Data)
          end;
        ftPointer: Integer(P^) := StrToInt(Data);
        ftCount:
          begin
          end;
        ftUnsigned: Cardinal(P^) := (StrToInt64(Data) and $FFFFFFFF);
      end;
      Result := True;
    except
      Result := False;
    end;
  end;

var
  At: Integer;
  DataAt: Integer;
  Results: Integer;
  ScanToken: string;
  StringToken: string;
  FieldType: TFieldType;
  FieldWidth: Integer;
  CharSet: TSysCharSet;
  Stored: Boolean;
  OutOfData: Boolean;
  P: Pointer;
begin
  At := 1;
  DataAt := 1;
  Results := 0;

  while At <= Length(format) do
  begin
    try
      ScanToken := GetScanfToken(Format, At);
      InterpretScanToken(ScanToken, FieldType, FieldWidth, CharSet, Stored);
    except
      Break;
    end;
    if FieldType <> ftCount then
      StringToken := GetDataToken(Data, DataAt, OutOfData, FieldType, FieldWidth, CharSet);

    if FieldType = ftLitteral then
      if StringToken <> ScanToken then
        Break;

    if not OutOfData then
    begin
      if not CheckFieldData(StringToken, FieldType) then Break;
      if Stored then
      begin
        if (Results + Low(Args)) > High(Args) then
          raise Exception.Create(SErrOutOfPointer);
        P := Args[Results + Low(Args)].VPointer;
        StoreData(StringToken, FieldType, FieldWidth, DataAt, P, Args[Results + Low(Args)].VType);
        Inc(Results);
      end;
    end;
  end;
  Result := Results;
end; { sscanf }

function IsClass(Address: Pointer): Boolean; assembler;
{
  判断指针是否是Class
}
  function IsClassFun(AAddress: Pointer): Boolean; assembler;
  asm
        CMP     AAddress, AAddress.vmtSelfPtr
        JNZ     @False
        MOV     Result, True
        JMP     @Exit
  @False:
        MOV     Result, False
  @Exit:
  end;
begin
  Result := IsClassFun(Address);
end;

function IsObject(Address: Pointer): Boolean; assembler;
{
  判断指针是否是对象
}
asm
// or IsClass(Pointer(Address^));
        MOV     EAX, [Address]
        CMP     EAX, EAX.vmtSelfPtr
        JNZ     @False
        MOV     Result, True
        JMP     @Exit
@False:
        MOV     Result, False
@Exit:
end;

//==============================================================================
//  Convert/Code/Decode function/procedure
//==============================================================================

function IsText(Data: PChar; Len: Integer): Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := 0 to Len - 1 do
    if Data[i] in [#0..#9, #11..#12, #14..#31] then
     Exit;
  Result := True;
end;

function DataToHex(Data: PChar; Len: integer): string;
{
  把指定的二进制数据转换成十六进制表示的字符串
}
begin
  SetLength(Result, Len shl 1);
  BinToHex(Data, PChar(Result), Len);
end;

function HexToData(const HexStr: string): string;
{
  转换十六进制字符串数据为字符串
}
begin
  SetLength(Result, Length(HexStr) shr 1);
  Classes.HexToBin(PChar(HexStr), PChar(Result), Length(Result));
end;

function BytesToString(const i64Size: Int64): string;
{
  转换文件大小为字符串描述
}
const
  i64GB = 1024 * 1024 * 1024;
  i64MB = 1024 * 1024;
  i64KB = 1024;
begin
  if i64Size div i64GB > 0 then
    Result := Format('%.2f GB', [i64Size / i64GB])
  else if i64Size div i64MB > 0 then
    Result := Format('%.2f MB', [i64Size / i64MB])
  else if i64Size div i64KB > 0 then
    Result := Format('%.2f KB', [i64Size / i64KB])
  else
    Result := IntToStr(i64Size) + SBytes;
end;

const
  cBase64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

function Base64Encode(mSource: string; mAddLine: Boolean = True): string;
{
  对mSource进行Base64编码，返回编码后的数据
}
var
  I, J: Integer;
  S: string;
begin
  Result := '';
  J := 0;
  for I := 0 to Length(mSource) div 3 - 1 do
  begin
    S := Copy(mSource, I * 3 + 1, 3);
    Result := Result + cBase64[Ord(S[1]) shr 2 + 1];
    Result := Result + cBase64[((Ord(S[1]) and $03) shl 4) + (Ord(S[2]) shr 4) + 1];
    Result := Result + cBase64[((Ord(S[2]) and $0F) shl 2) + (Ord(S[3]) shr 6) + 1];
    Result := Result + cBase64[Ord(S[3]) and $3F + 1];
    if mAddLine then
    begin
      Inc(J, 4);
      if J >= 76 then
      begin
        Result := Result + #13#10;
        J := 0;
      end;
    end;
  end;
  I := Length(mSource) div 3;
  S := Copy(mSource, I * 3 + 1, 3);
  case Length(S) of
    1:
      begin
        Result := Result + cBase64[Ord(S[1]) shr 2 + 1];
        Result := Result + cBase64[(Ord(S[1]) and $03) shl 4 + 1];
        Result := Result + cBase64[65];
        Result := Result + cBase64[65];
      end;
    2:
      begin
        Result := Result + cBase64[Ord(S[1]) shr 2 + 1];
        Result := Result + cBase64[((Ord(S[1]) and $03) shl 4) + (Ord(S[2]) shr 4) + 1];
        Result := Result + cBase64[(Ord(S[2]) and $0F) shl 2 + 1];
        Result := Result + cBase64[65];
      end;
  end;
end; { Base64Encode }

function Base64Decode(mCode: string): string;
{
  对mCode进行Base64解码，返回解码后的数据
}
var
  I, L: Integer;
  S: string;
begin
  Result := '';
  L := Length(mCode);
  I := 1;
  while I <= L do
  begin
    if Pos(mCode[I], cBase64) > 0 then
    begin
      S := Copy(mCode, I, 4);
      if (Length(S) = 4) then
      begin
        Result := Result + Chr((Pos(S[1], cBase64) - 1) shl 2 + (Pos(S[2], cBase64) - 1) shr 4);
        if S[3] <> cBase64[65] then
        begin
          Result := Result + Chr(((Pos(S[2], cBase64) - 1) and $0F) shl 4 + (Pos(S[3], cBase64) - 1) shr 2);
          if S[4] <> cBase64[65] then
            Result := Result + Chr(((Pos(S[3], cBase64) - 1) and $03) shl 6 + (Pos(S[4], cBase64) - 1));
        end;
      end;
      Inc(I, 4);
    end
    else
      Inc(I);
  end;
end; { Base64Decode }

function BoolToString(const Value: Boolean): string;
{
  BoolToString改进Delphi本身把布尔值显示成-1的小问题
}
begin
  Result := CSBoolString[Value];
end;

{$D-}
function StringToBool(const Value: string): Boolean;
{
  StringToBool用于改进Delphi本身的StrToBool，支持英文字符串，兼容StrToBool(0或者非0)
}
begin
  try
    if GetStringIndex(Value, ['true', 't', '.t.', '1', '-1', 'y', 'yes']) <> -1 then
      Result := True
    else if GetStringIndex(Value, ['false', 'f', '.f.', '0', 'n', 'no']) <> -1 then
      Result := False
    else Result := Boolean(StrToInt(Value));
  except
    raise EConvertError.CreateFmt(SErrBoolValue, [Value]);
  end;
end;
{$D+}

function StringToBoolDef(const Value: string; const Default: Boolean = False): Boolean; stdcall;
begin
  try
    Result := StringToBool(Value);
  except
    Result := Default;
  end;
end;

function GSMDecodeSMS(PDU: string): string;
{
  解码一个7-bit SMS (GSM 03.38) 为ASCII码
}
var
  OctetStr: string;
  OctetBin: string;
  Charbin: string;
  PrevOctet: string;
  Counter: integer;
  Counter2: integer;

  function HexCharToInt(HexToken: char): Integer;
  begin
    if HexToken > #97 then
      HexToken := Chr(Ord(HexToken) - 32);
    { use lowercase aswell }
    Result := 0;
    if (HexToken > #47) and (HexToken < #58) then { chars 0....9 }
      Result := Ord(HexToken) - 48
    else if (HexToken > #64) and (HexToken < #71) then { chars A....F }
      Result := Ord(HexToken) - 65 + 10;
  end;

  function HexCharToBin(HexToken: char): string;
  var
    DivLeft: integer;
  begin
    DivLeft := HexCharToInt(HexToken); { first HEX->BIN }
    Result := '';
    { Use reverse dividing }
    repeat { Trick; divide by 2 }
      if odd(DivLeft) then { result = odd ? then bit = 1 }
        Result := '1' + Result { result = even ? then bit = 0 }
      else
        Result := '0' + Result;

      DivLeft := DivLeft div 2; { keep dividing till 0 left and length = 4 }
    until (DivLeft = 0) and (length(Result) = 4); { 1 token = nibble = 4 bits }
  end;

  function HexToBin(HexNr: string): string;
    { only stringsize is limit of binnr }
  var
    Counter: integer;
  begin
    Result := '';

    for Counter := 1 to length(HexNr) do
      Result := Result + HexCharToBin(HexNr[Counter]);
  end;

begin
  PrevOctet := '';
  Result := '';

  for Counter := 1 to length(PDU) do
  begin
    if length(PrevOctet) >= 7 then { if 7 Bit overflow on previous }
    begin
      if BinToInt(PrevOctet) <> 0 then
        Result := Result + Chr(BinToInt(PrevOctet))
      else
        Result := Result + ' ';

      PrevOctet := '';
    end;

    if Odd(Counter) then { only take two nibbles at a time }
    begin
      OctetStr := Copy(PDU, Counter, 2);
      OctetBin := HexToBin(OctetStr);

      Charbin := '';
      for Counter2 := 1 to length(PrevOctet) do
        Charbin := Charbin + PrevOctet[Counter2];

      for Counter2 := 1 to 7 - length(PrevOctet) do
        Charbin := OctetBin[8 - Counter2 + 1] + Charbin;

      if BinToInt(Charbin) <> 0 then
        Result := Result + Chr(BinToInt(CharBin))
      else
        Result := Result + ' ';

      PrevOctet := Copy(OctetBin, 1, length(PrevOctet) + 1);
    end;
  end;
end;

function CurrencyToString(Curr: Currency): string;
{
  转换Curr为当前系统格式的字符串，例如12345.56变成￥12,345.56
}
var
  Buf: array[0..511] of char;
begin
  GetCurrencyFormat(LOCALE_SYSTEM_DEFAULT, 0, PChar(CurrToStr(Curr)), nil, Buf, SizeOf(Buf));
  Result := StrPas(Buf);
end;

function Simplified2Traditional(mSimplified: string): string;
{
  简体中文转换为繁体中文，仅支持Win2K以上版本
}
var
  L: Integer;
begin
  L := Length(mSimplified);
  SetLength(Result, L);
  LCMapString(GetUserDefaultLCID,
    LCMAP_TRADITIONAL_CHINESE, PChar(mSimplified), L, @Result[1], L);
end; { Simplified2Traditional }

function Traditional2Simplified(mTraditional: string): string;
{
  繁体中文转换为简体中文，仅支持Win2K以上版本
}
var
  L: Integer;
begin
  L := Length(mTraditional);
  SetLength(Result, L);
  LCMapString(GetUserDefaultLCID,
    LCMAP_SIMPLIFIED_CHINESE, PChar(mTraditional), L, @Result[1], L);
end; { Traditional2Simplified }

type
  IMLangConvertCharset = interface
    ['{D66D6F98-CDAA-11D0-B822-00C04FC9B31F}']
    function Initialize(uiSrcCodePage: UINT; uiDstCodePage: UINT; dwProperty: DWORD): HResult; stdcall;
    function GetSourceCodePage(out puiSrcCodePage: UINT): HResult; stdcall;
    function GetDestinationCodePage(out puiDstCodePage: UINT): HResult; stdcall;
    function GetProperty(out pdwProperty: DWORD): HResult; stdcall;
    function DoConversion(pSrcStr: PChar; var pcSrcSize: UINT; pDstStr: PChar; pcDstSize: PUINT): HResult; stdcall;
    function DoConversionToUnicode(pSrcStr: PChar; var pcSrcSize: UINT; pDstStr: PWChar; pcDstSize: PUINT): HResult; stdcall;
    function DoConversionFromUnicode(pSrcStr: PWChar; var pcSrcSize: UINT; pDstStr: PChar; var pcDstSize: UINT): HResult; stdcall;
  end;

function ConvertCodePage(const Text: WideString; const CodePage_To: UINT): WideString;
{
  转换代码页
}
const
  MLCONVCHARF_AUTODETECT = 1;
  MLCONVCHARF_ENTITIZE = 2;
  CLASS_MLANGCONVERTCHARSET: TGUID = '{D66D6F99-CDAA-11D0-B822-00C04FC9B31F}';
var
  ML: IMLangConvertCharset;
  L, Size: UINT;
  Dest: PChar;
begin
  ML := CreateComObject(CLASS_MLANGCONVERTCHARSET) as IMLangConvertCharset;
  ML.Initialize(CODEPAGE_UNICODE, CodePage_To, MLCONVCHARF_ENTITIZE);
  Size := 0;
  L := Length(Text);
  ML.DoConversionFromUnicode(PWideChar(Text), L, nil, Size);
  GetMem(Dest, Size);
  try
    ML.DoConversionFromUnicode(PWideChar(Text), L, Dest, Size);
    Result := Dest;
  finally
    FreeMem(Dest);
  end;
end;

function IPToString(const IP: Cardinal): string;
{
  转换整数IP地址为字符串IP地址
}
begin
  Result := IntToStr((IP and $FF000000) shr 24) + '.';
  Result := Result + IntToStr((IP and $00FF0000) shr 16) + '.';
  Result := Result + IntToStr((IP and $0000FF00) shr 8) + '.';
  Result := Result + IntToStr(IP and $000000FF);
end;

function StringToIP(const IP: string): Cardinal;
{
  转换字符串IP地址为整数IP地址
}
var
  SS: TStringDynArray;
begin
  Result := 0;
  SS := nil;

  if not IsValidIP(IP) then Exit;

  SS := SplitString(IP, '.');
  Result := StrToInt(SS[0]) shl 24
    + StrToInt(SS[1]) shl 16
    + StrToInt(SS[2]) shl 8
    + StrToInt(SS[3]);
end;

//==============================================================================
//  Hardware function/procedure
//==============================================================================

function IsCDRom(Drive: char): longbool;
{
  判断指定驱动器是否是光驱
}
var
  DrivePath: string;
begin
  DrivePath := Drive + ':\';
  result := LongBool(GetDriveType(PChar(DrivePath)) and DRIVE_CDROM);
end;

function CloseCD: Boolean;
{
  关闭光驱
}
begin
  Result := SendMCICommand('Set cdaudio door closed wait');
end;

function EjectCD: Boolean;
{
  弹出光驱
}
begin
  Result := SendMCICommand('Set cdaudio door open wait');
end;

function GetHDSerialNo: string;
{
  返回第一个硬盘的硬盘硬件序列号

  IDE Primary master时，  文件名为Scsi0，bDriveNumber为0
  IDE Primary slave 时，  文件名为Scsi0，bDriveNumber为1
  IDE Secondary master时，文件名为Scsi1，bDriveNumber为0
  IDE Secondary slave 时，文件名为Scsi1，bDriveNumber为1
}
type
  TSrbIoControl = packed record
    HeaderLength: ULONG;
    Signature: array[0..7] of Char;
    Timeout: ULONG;
    ControlCode: ULONG;
    ReturnCode: ULONG;
    Length: ULONG;
  end;
  SRB_IO_CONTROL = TSrbIoControl;
  PSrbIoControl = ^TSrbIoControl;

  TIDERegs = packed record
    bFeaturesReg: Byte; // Used for specifying SMART "commands".
    bSectorCountReg: Byte; // IDE sector count register
    bSectorNumberReg: Byte; // IDE sector number register
    bCylLowReg: Byte; // IDE low order cylinder value
    bCylHighReg: Byte; // IDE high order cylinder value
    bDriveHeadReg: Byte; // IDE drive/head register
    bCommandReg: Byte; // Actual IDE command.
    bReserved: Byte; // reserved. Must be zero.
  end;
  IDEREGS = TIDERegs;
  PIDERegs = ^TIDERegs;

  TSendCmdInParams = packed record
    cBufferSize: DWORD;
    irDriveRegs: TIDERegs;
    bDriveNumber: Byte;
    bReserved: array[0..2] of Byte;
    dwReserved: array[0..3] of DWORD;
    bBuffer: array[0..0] of Byte;
  end;
  SENDCMDINPARAMS = TSendCmdInParams;
  PSendCmdInParams = ^TSendCmdInParams;

  TIdSector = packed record
    wGenConfig: Word;
    wNumCyls: Word;
    wReserved: Word;
    wNumHeads: Word;
    wBytesPerTrack: Word;
    wBytesPerSector: Word;
    wSectorsPerTrack: Word;
    wVendorUnique: array[0..2] of Word;
    sSerialNumber: array[0..19] of Char;
    wBufferType: Word;
    wBufferSize: Word;
    wECCSize: Word;
    sFirmwareRev: array[0..7] of Char;
    sModelNumber: array[0..39] of Char;
    wMoreVendorUnique: Word;
    wDoubleWordIO: Word;
    wCapabilities: Word;
    wReserved1: Word;
    wPIOTiming: Word;
    wDMATiming: Word;
    wBS: Word;
    wNumCurrentCyls: Word;
    wNumCurrentHeads: Word;
    wNumCurrentSectorsPerTrack: Word;
    ulCurrentSectorCapacity: ULONG;
    wMultSectorStuff: Word;
    ulTotalAddressableSectors: ULONG;
    wSingleWordDMA: Word;
    wMultiWordDMA: Word;
    bReserved: array[0..127] of Byte;
  end;
  PIdSector = ^TIdSector;

const
  IDE_ID_FUNCTION = $EC;
  IDENTIFY_BUFFER_SIZE = 512;
  DFP_RECEIVE_DRIVE_DATA = $0007C088;
  IOCTL_SCSI_MINIPORT = $0004D008;
  IOCTL_SCSI_MINIPORT_IDENTIFY = $001B0501;
  DataSize = sizeof(TSendCmdInParams) - 1 + IDENTIFY_BUFFER_SIZE;
  BufferSize = SizeOf(SRB_IO_CONTROL) + DataSize;
  W9xBufferSize = IDENTIFY_BUFFER_SIZE + 16;
var
  hDevice: THandle;
  cbBytesReturned: DWORD;
  pInData: PSendCmdInParams;
  pOutData: Pointer; // PSendCmdOutParams
  Buffer: array[0..BufferSize - 1] of Byte;
  srbControl: TSrbIoControl absolute Buffer;

  procedure ChangeByteOrder(var Data; Size: Integer);
  var
    ptr: PChar;
    i: Integer;
    c: Char;
  begin
    ptr := @Data;
    for i := 0 to (Size shr 1) - 1 do
    begin
      c := ptr^;
      ptr^ := (ptr + 1)^;
      (ptr + 1)^ := c;
      Inc(ptr, 2);
    end;
  end;

begin
  FillChar(Buffer, BufferSize, #0);
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    with srbControl do
    begin
      Move('SCSIDISK', Signature, 8);
      Timeout := 2;
      Length := DataSize;
      ControlCode := IOCTL_SCSI_MINIPORT_IDENTIFY;
      HeaderLength := SizeOf(SRB_IO_CONTROL);
    end;

    pInData := PSendCmdInParams(PChar(@Buffer) + SizeOf(SRB_IO_CONTROL));
    pOutData := pInData;
    hDevice := CreateFile('\\.\PHYSICALDRIVE0', GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  end
  else
  begin
    pInData := PSendCmdInParams(@Buffer);
    pOutData := @pInData^.bBuffer;
    hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
  end;
  if hDevice = INVALID_HANDLE_VALUE then Exit;

  with pInData^ do
  begin
    cBufferSize := IDENTIFY_BUFFER_SIZE;
    bDriveNumber := 0;
    with irDriveRegs do
    begin
      bFeaturesReg := 0;
      bSectorCountReg := 1;
      bSectorNumberReg := 1;
      bCylLowReg := 0;
      bCylHighReg := 0;
      bDriveHeadReg := $A0;
      bCommandReg := IDE_ID_FUNCTION;
    end;
  end;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    DeviceIoControl(hDevice, IOCTL_SCSI_MINIPORT, @Buffer, BufferSize, @Buffer, BufferSize,
      cbBytesReturned, nil)
  else // Windows 95 OSR2, Windows 98
    DeviceIoControl(hDevice, DFP_RECEIVE_DRIVE_DATA, pInData, SizeOf(TSendCmdInParams) - 1, pOutData,
      W9xBufferSize, cbBytesReturned, nil);
  CloseHandle(hDevice);
  with PIdSector(PChar(pOutData) + 16)^ do
  begin
    ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
    Result := sSerialNumber;
  end;
end;

function DiskRead(iHD, iSector: integer; pData: Pointer; iLen: integer): DWORD;
{
  绝对磁盘读取，仅在Win 2K或更高版本使用
  iHD：需要读取的那个物理硬盘，第一个为0，以此类推
  iSector：从那个扇区开始读取，0表示第一个扇区，以此类推
  pData：保存读取的数据的
  iLen：读取数据的长度，单位：字节
}
var
  hFile: THandle;
  iPos: Int64;
begin
  Result := 0;
  if Win32Platform = VER_PLATFORM_WIN32_NT then { For NT or Higher }
  begin
    hFile := CreateFile(PChar('\\.\PhysicalDrive' + IntToStr(iHD)),
      GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
      OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, 0);
    if hFile = INVALID_HANDLE_VALUE then Exit;
    iPos := iSector * 512;
    SetFilePointer(hFile, Int64Rec(iPos).Lo, @Int64Rec(iPos).Hi, soFromBeginning);
    if GetLastError = 0 then ReadFile(hFile, pData^, iLen, Result, nil);
    CloseHandle(hFile);
  end;
end;

function DiskInDrive(Drive: Char): Boolean;
var
  ErrorMode: word;
begin
  Drive := UpCase(Drive);
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    if DiskSize(Ord(Drive) - $40) = -1 then
      DiskInDrive := False
    else
      DiskInDrive := True;
  finally
    SetErrorMode(ErrorMode);
  end;
end;

function IsValidCom(Port: PChar): Boolean;
{
  判断指定的端口是否有效
  例如：IsValidCom('COM1:');
}
var
  ComFile: THandle;
begin
  ComFile := CreateFile(Port, GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  Result := ComFile <> INVALID_HANDLE_VALUE;
  CloseHandle(ComFile);
end;

function LogicalDrives: string;
{
  返回系统当中的所有的逻辑驱动器列表，例如：ACDEFG
}
var
  drives: set of 0..31;
  drive: integer;
begin
  Result := '';
  DWORD(Drives) := Windows.GetLogicalDrives;
  for drive := 0 to 31 do
    if drive in drives then
      Result := Result + Chr(drive + Ord('A'));
end;

procedure DisableCPUID;
asm
  MOV ECX, 119H
  RDMSR
  or EAX, 00200000H
  WRMSR
end;

function SupportsMMX: Boolean;
{
  判断CPU是否支持MMX
}
begin
  Result := False;
  try
    asm
      push     eax
      push     ebx
      push     ecx
      push     edx
      pushfd
      pop      eax
      mov      ebx,eax
      xor      eax,$00200000
      push     eax
      popfd
      pushfd
      pop      eax
      xor      eax,ebx
      je       @NoMMX
      mov      eax,$01
      test     edx,$800000
      jz       @NoMMX
      mov byte ptr[Result],1

  @NoMMX:
      pop      edx
      pop      ecx
      pop      ebx
      pop      eax
    end;
  except;
  end;
end;

function GetTickCountEx: int64;
{
  返回自CPU开机之后的CPU运行周期数，超毫秒级精度
  注意：CPU越快，那么返回的数据所能表示运行的时间越短
        一般P4 2G最多能表示27天左右（未确定）？
}
asm
    DB $0F,$31 /// rdtsc
end;

function PortIn(IOport: word): byte; assembler;
{
  读取指定端口，读取一个字节，返回读取的值
  本函数仅在Win9x下使用
}
asm
  mov dx,ax
  in al,dx
end;

function PortInW(IOport: word): word; assembler;
{
  读取指定端口，读取两个个字节，返回读取的值
  本函数仅在Win9x下使用
}
asm
  mov dx,ax
  in ax,dx
end;

procedure PortOut(IOport: word; Value: byte); assembler;
{
  写入指定端口，写入一个字节
  本函数仅在Win9x下使用
}
asm
  xchg ax,dx
  out dx,al
end;

procedure PortOutW(IOport: word; Value: word); assembler;
{
  写入指定端口，写入两个个字节，IOPort指定端口号，Value为写入的数据
  本函数仅在Win9x下使用
}
asm
  xchg ax,dx
  out dx,ax
end;

function DiskSerialNumber(Drv: string): string;
{
  返回指定驱动器的卷标序列号，若返回"0000-0000"，表示失败
  例： DiskSerialNumber('C:');
}
var
  VolumeSerialNumber: DWORD;
  MaximumComponentLength: DWORD;
  FileSystemFlags: DWORD;
begin
  if Drv[Length(Drv)] = ':' then Drv := Drv + '\';
  GetVolumeInformation(pChar(Drv), nil, 0, @VolumeSerialNumber,
    MaximumComponentLength, FileSystemFlags, nil, 0);
  Result := Format('%.4x-%.4x', [HiWord(VolumeSerialNumber), LoWord(VolumeSerialNumber)]);
end;

const
  IOCTL_DISK_GET_PARTITION_INFO = $00074004;
type
  _PARTITION_INFORMATION = record
    StartingOffset: LARGE_INTEGER;
    PartitionLength: LARGE_INTEGER;
    HiddenSectors: DWORD;
    PartitionNumber: DWORD;
    PartitionType: BYTE;
    BootIndicator: ByteBool;
    RecognizedPartition: ByteBool;
    RewritePartition: ByteBool;
  end;

function GetDiskSize(const Disk: Integer): Int64;
{
  返回物理硬盘空间大小
}
var
  F : HFILE;
  Info : _PARTITION_INFORMATION;
  R : DWORD;
begin
  Result := 0;
  F := CreateFile(PChar(Format('\\.\PhysicalDrive%d', [Disk])),
                  GENERIC_READ,
                  FILE_SHARE_READ or FILE_SHARE_WRITE,
                  nil ,
                  OPEN_EXISTING,
                  FILE_FLAG_SEQUENTIAL_SCAN,
                  0);
  if F = INVALID_HANDLE_VALUE then Exit;
  if DeviceIoControl(F, IOCTL_DISK_GET_PARTITION_INFO, nil, 0, @Info, SizeOf(Info), R, nil) then
  begin
    Result := Int64(Info.PartitionLength);
  end;
  CloseHandle(F);
end;

function GetVolumeSize(const Disk: Char): Int64;
{
  返回逻辑磁盘大小
}
var
  F : HFILE;
  Info : _PARTITION_INFORMATION;
  R : DWORD;
begin
  Result := 0;
  F := CreateFile(PChar(Format('\\.\%s:', [Disk])),
                  GENERIC_READ,
                  FILE_SHARE_READ or FILE_SHARE_WRITE,
                  nil ,
                  OPEN_EXISTING,
                  FILE_FLAG_SEQUENTIAL_SCAN,
                  0);
  if F = INVALID_HANDLE_VALUE then Exit;
  if DeviceIoControl(F, IOCTL_DISK_GET_PARTITION_INFO, nil, 0, @Info, SizeOf(Info), R, nil) then
  begin
    Result := Int64(Info.PartitionLength);
  end;
  CloseHandle(F);
end;

//==============================================================================
//  Message/Event function/procedure
//==============================================================================

procedure SendKey(key: Word; const shift: TShiftState; specialkey: Boolean);
{
  模拟系统按键
  //Pressing the Left Windows Key
  PostKeyEx32(VK_LWIN, [], False);

  //Pressing the letter D
  PostKeyEx32(Ord('D'), [], False);

  //Pressing Ctrl-Alt-C
  PostKeyEx32(Ord('C'), [ssctrl, ssAlt], False);
}
{************************************************************
* Procedure PostKeyEx32
*
* Parameters:
*  key    : virtual keycode of the key to send. For printable
*           keys this is simply the ANSI code (Ord(character)).
*  shift  : state of the modifier keys. This is a set, so you
*           can set several of these keys (shift, control, alt,
*           mouse buttons) in tandem. The TShiftState type is
*           declared in the Classes Unit.
*  specialkey: normally this should be False. Set it to True to
*           specify a key on the numeric keypad, for example.
* Description:
*  Uses keybd_event to manufacture a series of key events matching
*  the passed parameters. The events go to the control with focus.
*  Note that for characters key is always the upper-case version of
*  the character. Sending without any modifier keys will result in
*  a lower-case character, sending it with [ssShift] will result
*  in an upper-case character!
// Code by P. Below
************************************************************}
type
  TShiftKeyInfo = record
    shift: Byte;
    vkey: Byte;
  end;
  byteset = set of 0..7;
const
  shiftkeys: array[1..3] of TShiftKeyInfo =
  ((shift: Ord(ssCtrl); vkey: VK_CONTROL),
    (shift: Ord(ssShift); vkey: VK_SHIFT),
    (shift: Ord(ssAlt); vkey: VK_MENU));
var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0), 0, 0);
  end; { For }
  if specialkey then
    flag := KEYEVENTF_EXTENDEDKEY
  else
    flag := 0;

  keybd_event(key, MapvirtualKey(key, 0), flag, 0);
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapvirtualKey(key, 0), flag, 0);

  for i := 3 downto 1 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0),
        KEYEVENTF_KEYUP, 0);
  end; { For }
end; { SendKey }

procedure SendKeyEx(hWindow: HWnd; key: Word; const shift: TShiftState; specialkey: Boolean);
{
  向指定窗口发送模拟按键
}
{************************************************************
 * Procedure PostKeyEx
 *
 * Parameters:
 *  hWindow: target window to be send the keystroke
 *  key    : virtual keycode of the key to send. For printable
 *           keys this is simply the ANSI code (Ord(character)).
 *  shift  : state of the modifier keys. This is a set, so you
 *           can set several of these keys (shift, control, alt,
 *           mouse buttons) in tandem. The TShiftState type is
 *           declared in the Classes Unit.
 *  specialkey: normally this should be False. Set it to True to
 *           specify a key on the numeric keypad, for example.
 *           If this parameter is true, bit 24 of the lparam for
 *           the posted WM_KEY* messages will be set.
 * Description:
 *  This procedure sets up Windows key state array to correctly
 *  reflect the requested pattern of modifier keys and then posts
 *  a WM_KEYDOWN/WM_KEYUP message pair to the target window. Then
 *  Application.ProcessMessages is called to process the messages
 *  before the keyboard state is restored.
 * Error Conditions:
 *  May fail due to lack of memory for the two key state buffers.
 *  Will raise an exception in this case.
 * NOTE:
 *  Setting the keyboard state will not work across applications
 *  running in different memory spaces on Win32 unless AttachThreadInput
 *  is used to connect to the target thread first.
 *Created: 02/21/96 16:39:00 by P. Below
 ************************************************************}
type
  TBuffers = array[0..1] of TKeyboardState;
var
  pKeyBuffers: ^TBuffers;
  lParam: LongInt;
begin
  if IsWindow(hWindow) then { check if the target window exists }
  begin
    { set local variables to default values }
    lParam := MakeLong(0, MapVirtualKey(key, 0));

    if specialkey then { modify lparam if special key requested }
      lParam := lParam or $1000000;

    New(pKeyBuffers); { allocate space for the key state buffers }
    try
      { Fill buffer 1 with current state so we can later restore it.
         Null out buffer 0 to get a "no key pressed" state. }
      GetKeyboardState(pKeyBuffers^[1]);
      FillChar(pKeyBuffers^[0], SizeOf(TKeyboardState), 0);

      if ssShift in shift then { set the requested modifier keys to "down" state in the buffer }
        pKeyBuffers^[0][VK_SHIFT] := $80;
      if ssAlt in shift then
      begin
        { Alt needs special treatment since a bit in lparam needs also be set }
        pKeyBuffers^[0][VK_MENU] := $80;
        lParam := lParam or $20000000;
      end;
      if ssCtrl in shift then pKeyBuffers^[0][VK_CONTROL] := $80;
      if ssLeft in shift then pKeyBuffers^[0][VK_LBUTTON] := $80;
      if ssRight in shift then pKeyBuffers^[0][VK_RBUTTON] := $80;
      if ssMiddle in shift then pKeyBuffers^[0][VK_MBUTTON] := $80;

      SetKeyboardState(pKeyBuffers^[0]); { make out new key state array the active key state map }
      { post the key messages }
      if ssAlt in Shift then
      begin
        PostMessage(hWindow, WM_SYSKEYDOWN, key, lParam);
        PostMessage(hWindow, WM_SYSKEYUP, key, DWORD(lParam) or $C0000000);
      end
      else
      begin
        PostMessage(hWindow, WM_KEYDOWN, key, lParam);
        PostMessage(hWindow, WM_KEYUP, key, DWORD(lParam) or $C0000000);
      end;

      ProcessMessages;

      SetKeyboardState(pKeyBuffers^[1]); { restore the old key state map }
    finally
      if pKeyBuffers <> nil then { free the memory for the key state buffers }
        Dispose(pKeyBuffers);
    end; { If }
  end;
end; { SendKeyEx }

procedure ProcessMessages;
{
  处理本线程的消息
}
var
  Msg: TMsg;
begin
  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

procedure EmptyKeyQueue;
{
  清空键盘消息队列
}
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do
end;

procedure EmptyMouseQueue;
{
  清空鼠标消息队列
}
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE or PM_NOYIELD) do
end;

//==============================================================================
//   VCL/Class/Object functions
//==============================================================================

function CloneProperties(SourceComp, TargetComp: TObject; Properties: array of string): Boolean;
{
  克隆指定属性，只能克隆Published部分的属性
  SourceComp：源控件，TargetComp：目的对象
  Properties：需要克隆的属性列表
}
var
  i: Integer;
begin
  Result := True;
  try
    for i := Low(Properties) to High(Properties) do
    begin
      if not IsPublishedProp(SourceComp, Properties[I]) then Continue;
      if not IsPublishedProp(TargetComp, Properties[I]) then Continue;
      if PropType(SourceComp, Properties[I]) <> PropType(TargetComp, Properties[I]) then
        Continue;
      case PropType(SourceComp, Properties[i]) of
        tkClass:
          SetObjectProp(TargetComp, Properties[i],
            GetObjectProp(SourceComp, Properties[i]));
        tkMethod:
          SetMethodProp(TargetComp, Properties[I], GetMethodProp(SourceComp,
            Properties[I]));
      else
        SetPropValue(TargetComp, Properties[i], GetPropValue(SourceComp, Properties[i]));
      end;
    end;
  except
    Result := False;
  end;
end;

function CloneObject(SourceComp, TargetComp: TObject): Boolean;
{
  克隆两个对象，克隆所有Published属性，不会克隆Name属性
  发生错误则返回False，否则返回True
}
var
  i: Integer;
  Properties: PPropList;
begin
  Result := True;
  try
    for i := 0 to GetPropList(SourceComp, Properties) - 1 do
    begin
      if LowerCase(Properties[i].Name) = 'name' then continue; ///do nothing for "Name".....
      if not IsPublishedProp(SourceComp, Properties[I].Name) then Continue;
      if not IsPublishedProp(TargetComp, Properties[I].Name) then Continue;
      if PropType(SourceComp, Properties[I].Name) <> PropType(TargetComp, Properties[I].Name) then
        Continue;
      case PropType(SourceComp, Properties[i].Name) of
        tkClass:
          SetObjectProp(TargetComp, Properties[i],
            GetObjectProp(SourceComp, Properties[i]));
        tkMethod:
          SetMethodProp(TargetComp, Properties[I], GetMethodProp(SourceComp,
            Properties[I]));
      else
        SetPropValue(TargetComp, Properties[i].Name, GetPropValue(SourceComp,
          Properties[i].Name));
      end;
    end;
  except
    Result := False;
  end;
end;

function AddToFavoriteEx(const URL, Title: string; const Path: string = ''): string;
var
  pidl: PItemIDList;
  FTitle: array[0..MAX_PATH] of char;
  UrlFile: array[0..MAX_PATH] of char;
begin
  if Path = '' then
    SHGetSpecialFolderLocation(0, CSIDL_FAVORITES, pidl)
  else
    pidl := GetPIDLFromPath(Path);
  StrPCopy(FTitle, Title);
  if DoAddToFavDlg(GetActiveWindow, UrlFile, SizeOf(UrlFile), FTitle, SizeOf(FTitle), pidl) then
  begin
    WritePrivateProfileString('InternetShortcut', 'URL', PChar(URL), UrlFile);
    Result := ChangeFileExt(FTitle, '');
  end;
  FreePidl(pidl);
end;

procedure SHRunDialgW(hWnd: HWND; Icon: HICON; lpstrDirectory: PWideChar;
  lpstrTitle: PWideChar; lpstrDescription: PWideChar; RFF_Flags: Longint); stdcall; external 'Shell32.dll'{$WARN SYMBOL_PLATFORM OFF}index 61{$WARN SYMBOL_PLATFORM ON};

procedure SHRunDialgA(hWnd: HWND; Icon: HICON; lpstrDirectory: PChar;
  lpstrTitle: PChar; lpstrDescription: PChar; RFF_Flags: Longint); stdcall; external 'Shell32.dll'{$WARN SYMBOL_PLATFORM OFF}index 61{$WARN SYMBOL_PLATFORM ON};

procedure ShowRunDialog(Dir, Title, Hint: PWideChar; RFF_Flag: integer; const Icon: HICON = 0);
{
  调用系统的运行对话框,在Win9x中，是ANSI版本，在XP/2K中，是UNICODE版
}
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SHRunDialgW(GetActiveWindow, Icon, PWideChar(Dir), PWideChar(Title), PWideChar(Hint), RFF_Flag);
  end
  else
  begin
    SHRunDialgA(GetActiveWindow, Icon, PChar(Dir), PChar(Title), PChar(Hint), RFF_Flag);
  end;
end;
{-------------------------------------------------------------------------------
  过程名:    LoadResourceAsString
  作者:      Kingron
  日期:      2006.09.06
  参数:      const ResName, ResType: string
  返回值:    string
  读取程序中的资源，以字符串的形式返回
-------------------------------------------------------------------------------}
function LoadResourceAsString(const ResName, ResType: PChar): string;
var
  r : HRSRC;
  m : THandle;
  p : PChar;
  s : Integer;
begin
  r := FindResource(0, PChar(ResName), ResType);
  if r = 0 then Exit;

  s := SizeofResource(0, r);
  if s <= 0 then Exit;

  m := LoadResource(0, r);
  if m = 0 then Exit;

  p := LockResource(m);
  SetLength(Result, s);
  Move(p^, PChar(Result)^, s);
  FreeResource(m);
end;
/// API Define
function DlgOpenWith; external shell32 name 'OpenAs_RunDLLA';
function GetLongPathName; external kernel32 name 'GetLongPathNameA';
function BlockInput; external user32 name 'BlockInput';
function RegisterServiceProcess; external Kernel32 name 'RegisterServiceProcess';
function DoAddToFavDlg; external shdocvw;
procedure DoOrganizeFavDlg; external shdocvw;
function SHEmptyRecycleBin; external 'Shell32.dll' name 'SHEmptyRecycleBinA';
function SHUpdateRecycleBinIcon; external 'shell32.dll' name 'SHUpdateRecycleBinIcon';
function SHFileProperties; external 'shell32.dll'{$WARN SYMBOL_PLATFORM OFF}index 178{$WARN SYMBOL_PLATFORM ON};
function SHFormatDrive; external 'shell32.dll' name 'SHFormatDrive';
function SHInvokePrinterCommand; external 'shell32.dll' name 'SHInvokePrinterCommandA';

{$ENDIF}
end.

