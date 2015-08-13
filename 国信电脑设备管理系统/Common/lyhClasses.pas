{*********************************************************************}
{               Common Object & Classes Unit                          }
{      (C) Copyright Kingron 1998 - 2003, All rights reserved.        }
{            Web page : http://kingron.delphibbs.com                  }
{                Mail : Kingron@163.net                               }
{*********************************************************************}
{  Powerful Classes
{=====================================================================}
{------------------------------------------------------------------------------}
{  Date: 2002.01.16
{  Last update: 2003.01.17
{  Author: Clark.Dong , Green.Wang , Kingron
{  Platform: Delphi 6 ,Wintel
{------------------------------------------------------------------------------}
{  Histroy & function:
{    1) TValueList: Support record,integer and other user define data type
{                   Auto memory manager
{    2) TObjectList: Support Object List,Auto memory manager
{    3) You can use DefaultSort method to sort List.
{       If the LowToHigh = True,The Method Compare Item By Low Bit to High Bit,
{       Asc : Sort Order? True = Asc order, False = Desc Order
{       LowToHigh:
{           False: use for MultiByte Data Type like Word,Integer,Int64 .....
{           True: use for SingleByte Data Type like array of char,string[N]
{------------------------------------------------------------------------------}
{  Warnning:
{    NOT use string in record when use TValueList to store record.
{        When use record,the record must be fixed size.
{    The DefaultSort Only use for x86 arch,
{        not use for Motorola and other cpu Architive
{    文件映射类没有完成！
{    增加Wier的文件映射类
{------------------------------------------------------------------------------}
unit lyhClasses;

interface

uses
  Windows, SysUtils, Classes, SyncObjs, StrUtils, uMyTools, Registry, Menus,
   IdTCPServer, IdTCPClient, ComObj, Word2000, Variants, ActiveX, Math;

/// 表达式计算对象
/// 复数对象

resourcestring
  SFileNotExist = 'File [%s] not exist!';
  SErrFileMap = 'Can''t Create File Mapping';
  SSparseBoundError = 'Error,Out of array bound,%d not between %d and %d';
  SMatrixBoundError = 'Error,Out of matrix bound, [%d,%d] not in [%d,%d]';
  SSizeError = 'Error, Access size(%d) too big, should between 0 and %d';
  SRead = 'read';
  SWrite = 'write';
  SErrSetItemSize = 'Can''t resize ItemSize when count > 0, Current Count:%d.';
  SErrStream = 'Stream %s error. Expect Size: %d,actual size: %d.';
  SErrOutBounds = 'Out of bounds,The value %d not between 0 and %d.';
  SErrClassType = 'Class type mismatch. Expect: %s , actual: %s';
  SUnableToConnect = 'Unable to connect to the registry on %s (%d)';

  c_msgstr = 'msgstr_san_{9BB1155F-1A06-4664-AB21-AB0A0C05A658}';

  c_emsamename = 'The global atom with the name of "%s" already exists';
  c_emdiskfull = 'The disk is full , it''s unable to Create the filemapping' +
    'with the Size of %d bytes and the Name of "%s"';
  c_emunknown = 'Unknown error occured when create file mapping with the name of "%s"';
  c_emprotect = 'The protect mode %d of filemapping is invalid with the name of "%s"';

type
  EValueList = class(Exception);
  EObjectList = class(Exception);

  { Value List Class,Can use for Integer,Int64,Float,Record... }
  { Auto memory manager,Auto Free memory                       }
  { 如果使用不包含String的记录，则很简单只要传递记录参数即可   }
  { 要修改数据的话，如果是固定大小记录，则可以使用
    with Items[i] do
    begin
      .....
    end;
    来直接修改，如果包含动态的，则需要使用GetItem(Index)函数来
    获取地址直接修改
    
    如果Record中包含String，则使用为如下：
     TStringRec = packed record
       S : PString;
       F : Integer;
     end;
     子类必须重载Delete方法，并添加释放代码
        Dispose(PStringRec(inherited Items[Index])^.S);
     添加：
      New(pS);
      New(pS.S);
      pS.S^ := '1234';
      pS.F := 0;
      s.Add(pS^);
      Dispose(pS);                                            
    使用:
      var
        p : PStringRec;
      begin
        p := s.Get(0);
        ShowMessage(p.S^);
        p.S1^ := GetRandomString(100);
      end;
  }

  TValueList = class(TList)
  private
    FItemSize: Integer;
    FTag: Integer;
    FData: Pointer;
    FName: string;
    FLock: TCriticalSection;
    FFileName: string;

    function MakePointerFromValue(const Value): Pointer;
    procedure SetItemSize(const Value: Integer);
  protected
    procedure DoSetItems(Index: integer; const Value);
    procedure DoAssign(Dest: TValueList); virtual;
  public
    property Data: Pointer read FData write FData;

    function Add(const Value): Integer; virtual; { Add Item By Value }
    function AddPointer(Item: Pointer): Integer; { Add Item By Pointer }
    procedure Insert(Index: Integer; const Value); virtual; { Insert Item By Value }
    procedure InsertPointer(Index: integer; Value: Pointer);
    procedure Delete(Index: Integer); virtual; { Delete Item By Position }
    function Remove(const Value): integer; virtual; { Delete Item By Value }
    procedure RemoveAll(const Item); { Delete All Item By Value }
    procedure Clear; override;
    function IndexOf(const Value): Integer;
    procedure FreeItem(Index: integer); { Free Item and Set nil }
    procedure Assign(Source: TValueList);
    function Duplicate: TValueList;
    function Equal(Item: TValueList): Boolean;
    { DefaultSort Only use for integer,word,int64.....not for record }
    { Asc: Order of Asc | Desc ? True = Asc order , False = Desc Order }
    procedure DefaultSort(const Asc: Boolean = True; const LowToHigh: Boolean = True);
    function BinSearch(const Value; CompareProc: TListSortCompare = nil): integer;

    function SaveItem(Stream: TStream; const Index: Integer): Integer; virtual;
    function LoadItem(Stream: TStream; Data : Pointer): Integer; virtual;
    procedure ReadFromStream(Stream: TStream); virtual;
    procedure WriteToStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String);
    procedure LoadFromFile(const Filename: String);
    procedure Save;

    function Item(const Index: Integer): Pointer;

    constructor Create(Size: Integer); virtual;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  published
    property Name: string read FName write FName;
    property ItemSize: Integer read FItemSize write SetItemSize;
    property Tag: Integer read FTag write FTag;
  end;

  TOrderValueList = class(TValueList) { Order value List ,Like integer,int64...}
  public
    procedure Sort(const AscOrder: Boolean = True);
  end;

  TExtendedList = class(TOrderValueList)
  private
    function GetItems(Index: Integer): Extended;
    procedure SetItems(Index: integer; const Value: Extended);
  public
    constructor Create; reintroduce; 
    procedure Add(Value: Extended); reintroduce;
    function ValueExist(Value: Extended): Boolean;
    property Items[Index: integer]: Extended read GetItems write SetItems; default;
  end;

  TIntegerList = class(TOrderValueList)
  private
    function GetItems(Index: integer): integer;
    procedure SetItems(Index: integer; const Value: integer);
  public
    constructor Create; reintroduce; 
    procedure Add(Value: integer); reintroduce;
    function ValueExist(Value: integer): Boolean;
    property Items[Index: integer]: integer read GetItems write SetItems; default;
  end;

  TInt64List = class(TOrderValueList)
  private
    function GetItems(Index: integer): Int64;
    procedure SetItems(Index: integer; const Value: Int64);
  public
    constructor Create; reintroduce;
    property Items[Index: integer]: Int64 read GetItems write SetItems; default;
  end;

  TObjectList = class(TList) { TObjectList,Auto Memeroy Manager,Auto Free }
  private
    FLock: TCriticalSection;
    FClassType: TClass;
    FData: Pointer;
    FName: string;
    FTag: integer;
    function GetItems(Index: Integer): TObject;
    procedure SetItems(Index: Integer; const Value: TObject);
  protected
    procedure ClassTypeError(Message: string);
  public
    procedure Lock;
    procedure UnLock;
    function Expand: TObjectList;
    function Add(AObject: TObject): Integer;
    function IndexOf(AObject: TObject): Integer; overload;
    procedure Delete(Index: Integer); overload;
    procedure Clear; override;
    function Remove(AObject: TObject): Integer;
    procedure Insert(Index: Integer; Item: TObject);
    procedure FreeItem(Index: integer);
    function First: TObject;
    function Last: TObject;
    property ItemClassType: TClass read FClassType;
    property Items[Index: Integer]: TObject read GetItems write SetItems; default;

    constructor Create; overload;
    constructor Create(AClassType: TClass); overload;
    destructor Destroy; override;
    property Data: Pointer read FData write FData;
  published
    property Tag: integer read FTag write FTag;
    property Name: string read FName write FName;
  end;

type
  TThreadProc = procedure(Param: Pointer);
  { TRunThread用来用线程的方式运行一段代码！               }
  { 你可以使用同步或者异步方式进行调用, 默认同步VCL方式    }
  { 如果线程设定了Param参数，并且Param需要进行内存管理     }
  { 则调用者需要自己进行内存管理！                         }
  TRunThread = class(TThread)
  private
    FSync: Boolean;
    FRunProc: TThreadProc;
    FEventProc: TNotifyEvent;
    FObjectProc: TThreadMethod;
    FOnFinished: TNotifyEvent;
    FLoop: Boolean;
    FIdle: Integer;
    FParam : Pointer;
    procedure SetOnFinished(const Value: TNotifyEvent);
  protected
    procedure Execute; override;
    procedure DoRun;
  public
    property OnFinished: TNotifyEvent read FOnFinished write SetOnFinished;
    property RunProc: TThreadProc read FRunProc write FRunProc;
    property EventProc: TNotifyEvent read FEventProc write FEventProc;
    property OjectProc : TThreadMethod read FObjectProc write FObjectProc;
    property Loop: Boolean read FLoop write FLoop; /// 是否循环调用
    property Sync: Boolean read FSync write FSync; /// 是否同步
    property Idle: Integer read FIdle write FIdle; /// 循环间隔时间
    property Terminated;

    constructor Create(const Param: Pointer = nil); overload;
    constructor Create(ARunProc: TThreadProc; ASyncInvoke: Boolean = True; const Param: Pointer = nil); overload;
    constructor Create(AEventProc: TNotifyEvent; ASyncInvoke: Boolean = True); overload;
    constructor Create(AObjectProc: TThreadMethod; ASyncInvoke: Boolean = True); overload;
  end;

  { 提供类似TTimer组件的功能，不过采用线程和事件来完成 }
  { TTimer组件需要消息循环，在没有消息的时候或者异步的 }
  { 情况下，TTimer组件不再适用，用TTimerThread即可     }
  TTimerThread = class(TThread)
  private
    FOnTimer: TNotifyEvent;
    FEvent: TSimpleEvent;
    FInterval: DWORD;
    FSyncInvoke: Boolean;
    FEnabled: Boolean;
    FOnError: TNotifyEvent;
    FReEntry: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetInterval(const Value: DWORD);
    procedure SetReEntry(const Value: Boolean);
  protected
    procedure DoTimer; virtual;
    procedure DoError; virtual;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Free; { Free方法是保证调用者不会错误的释放两次，因为Thread会自动Free }
    procedure Reset; { 重新开始计时，当前这次定时事件不会触发 }
  published
    property Interval: DWORD read FInterval write SetInterval; { 单位是毫秒计算 }
    property SyncInvoke: Boolean read FSyncInvoke write FSyncInvoke; { 同步还是异步调用OnTimer事件 }
    property ReEntry: Boolean read FReEntry write SetReEntry; { 是否可以重入，默认否 }
    property Enabled: Boolean read FEnabled write SetEnabled;

    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    property OnError: TNotifyEvent read FOnError write FOnError;
  end;

  { TLogFile提供简单的日志记录文件功能 }
  { 你可以在此基础之上,对他进行改进    }
type
  TOnLogMessage = procedure(Sender: TObject; const S : string) of object;
  TLogFile = class
  private
    FStream: TFileStream;
    FFileName: string;
    FMaxSize: int64;
    FTimeStamp: Boolean;
    FOnLogMessage: TOnLogMessage;
    procedure SetMaxSize(const Value: int64);
    procedure SetTimeStamp(const Value: Boolean);
  public
    constructor Create(AFileName: string); overload;
    destructor Destroy; override;

    procedure Clear;
    function WriteLog(const Msg: string): Boolean;
  published
    property OnLogMessage: TOnLogMessage read FOnLogMessage write FOnLogMessage;
    property FileName: string read FFileName;
    property MaxSize: Int64 read FMaxSize write SetMaxSize; /// 单位 KB
    property TimeStamp: Boolean read FTimeStamp write SetTimeStamp; //写日志的是否插入时间
  end;

  { TMapFile，内存映射文件类 }
  TMappingFile = class
  private
    FFileName: string;
    FData: Pointer;
    FHandle: THandle;
    FFileSize: Int64;
    FTag: integer;
    FName: string;
  public
    constructor Create(const FileName: string; const FILE_MAP_MODE: DWORD);
    destructor Destroy; override;

    property Data: Pointer read FData; { Mapping Data Pointer }
  published
    property FileSize: Int64 read FFileSize;
    property FileName: string read FFileName;
    property Tag: integer read FTag write FTag;
    property Name: string read FName write FName;
  end;

const
  CIMinPageSize = 64 * 1024;          //最小Page大小
  CIMaxPageSize = 64 * 1024 * 1024;   //最大Page大小；
  CIInvalid = -9999;
  
type
  TMappingFileStream = class(TStream)
  private
    FFileName: String;
    FFileHandle: THandle;
    FMapHandle: THandle;
    FFileMapped: Boolean;      //标示文件是否已经映射
    FDesiredAccess: DWORD;

    FMapFileFactSize: Int64;
    FMapFileTotalSize: Int64;

    //默认的Page的大小，可由用户设定。
    //一般情况下每个Page的大小都是这个值，只有当文件的大小不能被FAllocationGranularity整除时，
    //文件的最后一个Page为其余数的大小。当文件已经写满，但还要往文件里面追加数据时，
    //文件将重新映射，并增加文件的大小（该增加值为DefaultPageSize和最后一次写入数据大小的最大值）
    FDefaultPageSize: Integer;
    FPageFactSize: Integer;    //Page的实际大小
    FPageStartPos: Pointer;    //Page的起始指针
    FPageCurrPos: Pointer;     //Page的当前指针
    FPageStartOffset: Int64;   //当前Page相对于Map文件的起始偏移;
    FFileHeader: Pointer;      //文件头指针；
    FFileHeaderSize: Integer;  //文件头的大小；
    FFileHeaderEnabled: Boolean;

    FAllocationGranularity: DWORD; /// 内存分配必须按此对齐
    FMappingName: string;

    function GetFileMappingMode: DWORD;
    function GetFileMapViewMode: DWORD;

    //获取当前页的最后一个字节在Map文件中的偏移；
    function PageLast: Int64;
    //读取数据，并将当前指针向后移动Count字节；
    procedure ReadAndMovePos(pData: Pointer; Count: Integer);
    //写入数据，并将当前指针向后移动Count字节；
    procedure WriteAndMovePos(pData: Pointer; Count: Integer);

    //导入当前Page数据到内存中;
    procedure ViewPage;
    //根据新的位置切换页面；
    procedure ReviewPage(NewPos: Int64);
    //在写入超过当前文件长度时，重新映射文件；
    procedure ReMappingFile(MoveTo: Int64);

    //计算Page当前位置指针在整个文件的相对偏移
    function GetPageCurrPosTotalOffset: Int64;
    //重新计算Page在整个文件中的起始相对偏移，以确保得出的值一定是FAllocationGranularity的整数倍；
    function ReCalcPageStartOffset(iCurrPos: Int64): Int64;
    //读数据的递归函数，当一次读取的数据量过大导致跨页读取时，实现了自动换页读取数据。
    function ReadData(var pData: Pointer; Count: Longint): Longint;
    //些数据的递归函数，当一次写入的数据量过大而导致跨页时，实现了自动换页写
    //当写入的指针到了文件尾部时，如果数据还没有写完，重新映射文件增大文件大小，继续写完。
    function WriteData(var pData: Pointer; Count: Longint): Longint;
    //判断当前映射文件是否用于共享内存；
    function IsShareMem: Boolean;

    procedure CloseViewPage;
    procedure CloseMapFile;
    procedure CloseFileHeaderPage;

    function GetEOF: Boolean;
  protected
    procedure SetSize(const Value: Int64); override;
  public
    constructor Create(FileName: String; PageSize: Integer; DesiredAccess: DWORD);
    destructor Destroy; override;

    procedure MappingFile;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function MapView(const Offset, Size: Int64): Pointer;
    /// <summary>
    /// 提供一个可供读写的文件头指针
    /// </summary>
    /// <param name="Size">指定的文件头大小</param>
    /// <returns>返回文件头的读写指针</returns>
    function GetFileHeaderEx(Size: Integer): Pointer;
    /// <summary>
    /// 剪裁文件，将文件的实际大小调整为当前读写指针指向的位置的大小；
    /// </summary>
    procedure ClippingFile;

    /// <summary>
    /// 强制将数据写入文件；
    /// </summary>
    procedure Flush;

    property EOF: Boolean read GetEOF;
    property DefaultPageSize: Integer read FDefaultPageSize;
    property Size: Int64 read FMapFileFactSize write SetSize;
    property Data: Pointer read FPageCurrPos;
    property MappingName: string read FMappingName write FMappingName;
    property Position: Int64 read GetPageCurrPosTotalOffset;
    property FullFileName: string read FFileName;
    property FileHandle: THandle read FFileHandle;
  end;

  TSharedStream = class(TStream)
  private
    FMemory: Pointer;
    FSize: Longint;
    FPageSize: Longint;
    FPosition: Longint;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Integer): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SetSize(NewSize: Longint); override;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
  public
    property Memory: Pointer read FMemory;
  end;

  TVirtualMemoryStream = class(TCustomMemoryStream)
  private
    fReserved: Integer;
    fChunkSize: Integer;
  protected
    procedure SetSize(NewSize: Integer); override;
  public
    constructor Create(AReserved, AInitialSize: Integer);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    property Reserved: Integer read fReserved;
    property ChunkSize: Integer read fChunkSize write fChunkSize;
  end;

  EVirtualMemory = class(Exception);
const
  SwapHandle = $FFFFFFFF;

type
  TFileMappingStream = class(TStream)
  private
    FMapHandle: DWORD;
    FFileHandle: DWORD;
    //FFileName: string;
    FName: PChar;
    FExists: Boolean;
    FPointer: Pointer;
    FProtectMode: DWORD;
    FSize: DWORD;
    FResizeable: Boolean;
    FPosition: DWORD;
    /////////
    function getname: string;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;

    function AlreadyExists: Boolean;
    function DataPointer: Pointer;

    ///////////////////////////
    constructor Create; overload;
    constructor Create(AHandle: DWORD; AName: string; ASize: Cardinal); overload;
    constructor Create(AHandle: DWORD; ASize: Cardinal); overload;

    constructor CreateFromMemory(AName: string; ASize: Cardinal); overload;
    constructor CreateFromMemory(ASize: Cardinal); overload;

    constructor Create(AHandle: DWORD; AName: string; ASize: Cardinal; ProtectMode: DWORD); overload;
    constructor Create(AHandle: DWORD; ASize: Cardinal; ProtectMode: DWORD); overload;

    constructor CreateFromMemory(AName: string; ASize: Cardinal; ProtectMode: DWORD); overload;
    constructor CreateFromMemory(ASize: Cardinal; ProtectMode: Integer); overload;
    destructor Destroy; override;
  published
    property MapHandle: DWORD read fmaphandle;
    property FileHandle: DWORD read ffilehandle;
    property Name: string read getname;
    property ProtectMode: DWORD read fprotectmode;
  end;

  { TRemoteMemoryAccess用于存取其他进程的内存空间！ }
  ERemoteMemoryAccessError = Exception;
  TRemoteMemoryAccess = class
  private
    FSize: integer;
    FProcess: THandle; { OpenProcess的返回句柄 }
    FPointer: Pointer; { 保存申请到的内存指针 }
    procedure SetSize(const Value: integer);
    function Valid: Boolean; { 检查是否有效,可以进行存取 }
  public
    constructor Create(APID: THandle; ASize: integer);
    destructor Destroy; override;

    function Read(var Buf; ASize: integer): Cardinal;
    function Write(const Buf; ASize: integer): Cardinal;
  published
    property Size: integer read FSize write SetSize;
  end;

  { 稀疏数组对象，仅仅保存指针对象，不负责数据对象的内存 }
  { 其中Key表示数组元素下标，Index表示所有List的索引     }
  ESparesException = Exception;
  TSparseArrayCompare = (sacBefore, sacExact, sacAfter);
  TSparseArray = class
  private
    FList: TList;
    FLastExact: integer;
    FHigh: integer;
    FLow: integer;
    function Get(Key: LongInt): Pointer;
    procedure Put(Key: LongInt; Item: Pointer);
    function ClosestNdx(Key: LongInt; var Status: TSparseArrayCompare): LongInt;

    function GetCount: integer;
    function GetItems(Index: integer): Pointer;
    procedure SetItems(Index: integer; const Value: Pointer);
    procedure SetHigh(const Value: integer);
    procedure SetLow(const Value: integer);
  protected
    procedure Delete(Index: integer); virtual; { 清除某个Item数据 }
    property Data[Key: LongInt]: Pointer read Get write Put; default;
  public
    constructor Create(ALow: integer = 0; AHigh: integer = MaxInt);
    destructor Destroy; override;

    procedure Clear; virtual;
    { Data就是作为数组一样进行访问数据的 }
    property Low: integer read FLow write SetLow; { 下标 }
    property High: integer read FHigh write SetHigh; { 上标 }
    function First: LongInt; { 返回第一个有数据的下标 }
    function Last: LongInt; { 返回数组中最后一个有数据的下标 }
    function Previous(Key: LongInt): LongInt; { 返回数组元素Key的前一个下标 }
    function Next(Key: LongInt): LongInt; { 返回数组元素Key的下一个下标 }

    { Count配合Items用来遍历所有的数据 }
    property Items[Index: integer]: Pointer read GetItems write SetItems;
    property Count: integer read GetCount;
  end;

  TIntSparseArray = class(TSparseArray)
  private
    function GetIntegers(Index: integer): Integer;
    procedure SetIntegers(Index: integer; const Value: Integer);
    function GetItems(Index: integer): Integer;
    procedure SetItems(Index: integer; const Value: Integer);
  public
    property Integers[Index: integer]: Integer read GetIntegers write SetIntegers; default;
    property Items[Index: integer]: Integer read GetItems write SetItems;
  end;

  { TObject稀疏数组对象，负责对象的内存释放 }
  TObjectSparseArray = class(TSparseArray)
  private
    function GetObjects(Key: Integer): TObject;
    procedure SetObjects(Key: Integer; const Value: TObject);

    function GetItems(Index: integer): TObject;
    procedure SetItems(Index: integer; const Value: TObject);
  protected
    procedure Delete(Index: integer); override;
  public
    property Objects[Key: Integer]: TObject read GetObjects write SetObjects; default;
    property Items[Index: integer]: TObject read GetItems write SetItems;
  end;

  { 稀疏数组对象稀疏数组,主要用于稀疏矩阵 }
  TSparseObjectSparseArray = class(TObjectSparseArray)
  private
    function GetObjects(Key: Integer): TSparseArray;
    procedure SetObjects(Key: Integer; const Value: TSparseArray);

    function GetItems(Index: integer): TSparseArray;
    procedure SetItems(Index: integer; const Value: TSparseArray);
  public
    property Objects[Key: Integer]: TSparseArray read GetObjects write SetObjects; default;
    property Items[Index: integer]: TSparseArray read GetItems write SetItems;
  end;

  { 稀疏矩阵对象基类，保存数据指针 }
  EMatrixException = class(Exception);
  TSparseMatrix = class(TSparseObjectSparseArray)
  private
    FColCount: Integer;
    FRowCount: Integer;

    function GetCells(ARow, ACol: integer): Pointer;
    procedure SetCells(ARow, ACol: integer; const Value: Pointer);
    procedure SetCols(const Value: Integer);
    procedure SetRows(const Value: Integer);
  protected
    property Cells[ARow, ACol: integer]: Pointer read GetCells write SetCells; default;
  public
    constructor Create(ARowCount: integer = MaxInt; AColCount: integer = MaxInt);
  published
    property ColCount: Integer read FColCount write SetCols;
    property RowCount: Integer read FRowCount write SetRows;
  end;

  { 整数稀疏矩阵 }
  TIntSparseMatrix = class(TSparseMatrix)
  private
    function GetCells(ARow, ACol: integer): integer;
    procedure SetCells(ARow, ACol: integer; const Value: integer);
  public
    property Cells[ARow, ACol: integer]: integer read GetCells write SetCells; default;
  end;

  { 对象稀疏矩阵 }
  TObjectSparseMatrix = class(TSparseMatrix)
  private
    function GetObjects(ARow, ACol: integer): TObject;
    procedure SetObjects(ARow, ACol: integer; const Value: TObject);
  public
    procedure Clear; override;
    property Objects[ARow, ACol: integer]: TObject read GetObjects write SetObjects; default;
  end;

  { 全局临界区对象，本临界区对象可以跨进程边界 }
  TGlobalCriticalSection = class(TEvent)
  private
    FTimeOut: DWORD;
    FName: string;
    procedure SetTimeOut(const Value: DWORD);
  published
    property TimeOut: DWORD read FTimeOut write SetTimeOut;
    property Name: string read FName;
  public
    constructor Create(AName: string);
    destructor Destroy; override;

    procedure Acquire; override;
    procedure Release; override;
    procedure Lock;
    procedure Unlock;
    procedure Enter;
    procedure Leave;
  end;

type
  TWalkProc = procedure(const keyName, valueName: string; dataType: DWORD; data: pointer; DataLen: Integer) of object;

  TSearchParam = (rsKeys, rsValues, rsData);
  TSearchParams = set of TSearchParam;

  TSearchNode = class
    fValueNames: TStringList;
    fKeyNames: TStringList;
    fCurrentKey: string;
    fPath: string;
    fValueIDX, fKeyIDX: Integer;
    fRegRoot: HKEY;
    constructor Create(ARegRoot: HKEY; const APath: string);
    destructor Destroy; override;

    procedure LoadKeyNames;
    procedure LoadValueNames;
  end;

  /// 扩展功能的注册表对象，支持Multi string，支持遍历，支持导入导出等 }
  TRegistryEx = class(TRegistry)
  private
    fSaveServer: string;
    fExportStrings: TStrings;
    fExportExcludeKeys: TStrings;
    fLastExportKey: string;
    fSearchParams: TSearchParams;
    fSearchString: string;
    fSearchStack: TList;
    fMatchWholeString: boolean;
    fCancelSearch: boolean;
    fLocalRoot: HKEY;
    fValuesSize: Integer;
    procedure ValuesSizeProc(const keyName, valueName: string; dataType: DWORD; data: pointer; DataLen: Integer);
    procedure ClearSearchStack;
  protected
    procedure StartExport;
    procedure ExportProc(const keyName, valueName: string; dataType: DWORD; data: pointer; DataLen: Integer);
    function EndExport: string;
  public
    function ReadWideString(const Name: string): WideString;
    procedure WriteWideString(const Name: string; Value: WideString);

    function ReadMultiString(const Name: string): string;
    procedure WriteMultiString(const Name, Value: string);

    destructor Destroy; override;
    procedure SetRoot(root: HKey; const server: string);
    procedure CopyValueFromReg(const valueName: string; otherReg: TRegistryEx; deleteSource: boolean);
    procedure CopyKeyFromReg(const keyName: string; otherReg: TRegistryEx; deleteSource: boolean);
    function GetValueType(const valueName: string): DWORD;
    procedure ReadStrings(const valueName: string; strings: TStrings);
    procedure WriteStrings(const valueName: string; strings: TStrings);
    procedure ExportKey(const fileName: string);
    procedure ExportToStream(strm: TStream; ExcludeKeys: TStrings = nil);
    procedure ImportRegFile(const fileName: string);
    procedure ImportFromStream(stream: TStream);
    procedure WriteTypedBinaryData(const valueName: string; tp: Integer; var data; size: Integer);
    procedure Walk(walkProc: TWalkProc; valuesRequired: boolean);
    function FindFirst(const data: string; params: TSearchParams; MatchWholeString: boolean; var retPath, retValue: string): boolean;
    function FindNext(var retPath, retValue: string): boolean;
    procedure CancelSearch;
    procedure GetValuesSize(var size: Integer);

    property LocalRoot: HKEY read fLocalRoot;
    property SearchString: string read fSearchString;
    property Server: string read fSaveServer;
  end;

  ERegistryExException = class(ERegistryException)
  private
    fCode: Integer;
    function GetError: string;
  public
    constructor CreateLastError(const st: string);
    constructor Create(code: DWORD; const st: string);
    property Code: Integer read fCode;
  end;

  { 线程安全的String List }
  TThreadStringList = class(TStringList)
  private
    FCritSect: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure Unlock;

    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function Find(const S: string; var Index: Integer): Boolean; override;
    function IndexOf(const S: string): Integer; override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure InsertObject(Index: Integer; const S: string;
      AObject: TObject); override;
    procedure Sort; override;
    procedure CustomSort(Compare: TStringListSortCompare); override;
  end;

  { BIT管理类，对一串数据提供按数组方式访问BIT的功能 }
  TBitsEx = class
  private
    FDatas: array of Byte;
    FPosition: integer;
    function GetBits(Index: integer): integer;
    procedure SetBits(Index: integer; const Value: integer);
    function GetCount: integer;
  public
    constructor Create(Data: PChar; Len: integer);
    function Fetch(NumOfBits: Byte): integer;
    function Eof: Boolean;
    property Count: integer read GetCount;
    property Bits[Index: integer]: integer read GetBits write SetBits; default;
  end;

  { TMRUManager提供Most Recent Used功能，用于管理打开的文件历史记录和菜单控制 }
  { 使用时请设置OnClick事件和注册表设置即可，其他的可以采取默认值 }
  TMRUItemClick = procedure(Sender: TObject; const ItemText: string) of object;
  TMRUMenuItem = class(TMenuItem)
  private
    FText: string;
    FCaption: string;
  published
    property Text: string read FText write FText;
  end;

  TMRUManager = class(TComponent)
  private
    FMenuItem: TMenuItem;
    FMaxHistory: integer;
    FAddSeparator: boolean;
    FItemCount: integer;
    FBaseKey: string;
    FFirstIndex: integer;
    FOnClick: TMRUItemClick;
    FRootKey: HKEY;
    procedure SetMenuItem(Value: TMenuItem);
    procedure SetMaxHistory(Value: integer);
    procedure SetAddSeparator(Value: boolean);
    procedure InsertSeparator;
    procedure OnItemClick(Sender: TObject);
    function IndexOf(const ItemText: string): Integer;
    function GetItems(Index: Integer): TMRUMenuItem;
  protected
    { Protected declarations }
    procedure RebuildCaption;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent;
      AMenuItem: TMenuItem;
      AOnClick: TMRUItemClick;
      ASubKey: string;
      const ARootKey: HKEY = HKEY_CURRENT_USER; const AMax: integer = 5;
      const ASeperator: Boolean = True); reintroduce; overload;
    destructor Destroy; override;

    /// 菜单项目，使用其Text属性可以访问其原始数据
    property Items[Index: Integer]: TMRUMenuItem read GetItems;
    property Count: integer read FItemCount;
    procedure Add(const ItemText: string; const Tag: Integer = 0; Caption: string = ''); { 添加一个项目 }
    procedure Delete(Index: Integer); { 删除一个项目 }
    procedure Save; /// 保存列表到注册表
    procedure Load; /// 从注册表中读取到菜单中
    procedure Clear; /// 清除所有列表
  published
    { Published declarations }
    /// 需要添加到菜单项目，如果需要使用子菜单项，请在File菜单下添加一个Recent，并
    /// 设置MenuItem为Recent对应的菜单项即可，如果需要在File菜单下的最后一个项目前面
    /// 添加文件列表，则请设置为File菜单即可，根据需要可能需要设置FirstIndex
    property MenuItem: TMenuItem read FMenuItem write SetMenuItem;
    /// MRU菜单项在MenuItem中的起始位置，默认为倒数第二项开始
    property FirstIndex: Integer read FFirstIndex write FFirstIndex;
    { 文件历史记录的最多个数 }
    property MaxHistory: integer read FMaxHistory write SetMaxHistory default 5;
    { 点击MRU菜单项目时的事件 }
    property OnClick: TMRUItemClick read FOnClick write FOnClick;
    { 是否添加一个分隔符 }
    property AddSeparator: boolean read FAddSeparator write SetAddSeparator default False;
    property BaseKey: string read FBaseKey write FBaseKey; { 注册表子键 }
    property RootKey: HKEY read FRootKey write FRootKey; { 注册表的根键 }
  end;

  { 版本信息读取类，支持非标准的版本信息 }
type
  TVersionInfo = class
    fModule: THandle;
    fVersionInfo: PChar;
    fVersionHeader: PChar;
    fChildStrings: TStringList;
    fTranslations: TList;
    fFixedInfo: PVSFixedFileInfo;
    fVersionResHandle: THandle;
    fModuleLoaded: boolean;

  private
    function GetInfo: boolean;
    function GetKeyCount: Integer;
    function GetKeyName(idx: Integer): string;
    function GetKeyValue(const idx: string): string;
    procedure SetKeyValue(const idx, Value: string);
  public
    constructor Create(AModule: THandle); overload;
    constructor Create(AVersionInfo: PChar); overload;
    constructor Create(const AFileName: string); overload;
    destructor Destroy; override;
    procedure SaveToStream(strm: TStream);

    property Count: Integer read GetKeyCount;
    property Name[idx: Integer]: string read GetKeyName;
    property Value[const idx: string]: string read GetKeyValue write SetKeyValue;
  end;

{******************************************************************************}
{  日期：2004-6-25                                                             }
{  作者：Kingron                                                               }
{  说明：提供基本的通信命令基类，包括客户端和服务端                            }
{  版本：1.0                                                                   }
{  历史：1.0
{
{  处理客户/服务的网络连接命令，命令通过Socket进行交流
{  数据传递格式：
{   Command=ACommand
{   Result=Ok | Error
{   Message=Process return message
{   ErrCode= Integer
{   ItemName=ItemValue
{   ItemName=ItemValue
{
{   所有命令以两个回车换行符表示结束，因此数据中不能有两个回车换行！
{
{******************************************************************************}
type
  TServerCmdActionHandle = procedure(ASocketThread: TIdPeerThread; Request, Response: TStrings) of object;
  TClientCmdActionHandle = procedure(ASocket: TIdTCPClient; Request, Response: TStrings) of object;
  ENetCmdError = Exception;

  { 网络命令处理基类                                                        }
  { Request/Response对于客户端和服务端是不一样的                            }
  { 对于Client,Request是用于发送到服务端的,Response是接收服务端返回结果的   }
  { 对于Server,Request是用于接收客户端发送过来的数据，Response用于返回结果  }
  TNetCmdObject = class(TObject)
  private
    FRequest: TStrings;
    FResponse: TStrings;
    function GetCommand: string;
    procedure SetCommand(const Value: string);
  protected
    property Command: string read GetCommand write SetCommand; { 发送/接收的命令 }
    property Request: TStrings read FRequest; { Request }
    property Response: TStrings read FResponse; { Response }
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { Client的Request是用于发送到服务器端的命令请求                            }
  {  Client的Response是用来接收服务器端返回的数据                            }
  {  TNetClietCmd之类继承用法:                                               }
  {    可以重载DoError用于处理命令运行后返回的错误                           }
  {    可以重载DoSuccess用户处理命令成功运行后的处理                         }
  {  必须重载DispatchCommand                                                 }
  {  DispatchCommand用于处理发送给服务段的命令，DispatchCommand的类似下面：  }
  {     DoCommand(['Login','Get','Logout'],[DoLogin,DoGet,DoLogout]);        }
  {     其中DoLogin,DoGet等为对应的处理代码                                  }
  TNetClientCmd = class(TNetCmdObject)
  private
    FSocket: TIdTCPClient;

    function GetHost: string;
    function GetPort: Integer;
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: Integer);
    function GetCmdOK: Boolean;
    function GetErrorCode: integer;
    function GetErrorMessage: string;
  protected
    procedure SetData(const Name: string; const Value: string); overload; { 发送命令时附加数据的处理 }
    procedure SetData(const Name: string; const Value: Integer); overload;
    procedure SetData(const Name: string; const Value: TDateTime); overload;
    procedure SetData(const Name: string; const Value: Boolean); overload;
    procedure SetData(const Name: string; const Value: Float); overload;
    procedure AddData(const Name: string; const Value: string);

    function GetFloat(const Name: string): Float;
    function GetString(const Name: string): string;
    function GetInteger(const Name: string): Integer;
    function GetBoolean(const Name: string): Boolean;
    function GetDateTime(const Name: string): TDateTime;

    procedure DoError(const ErrCode: integer; const ErrMsg: string); virtual; { 服务端返回Error处理 }
    procedure DoSucc(const Msg: string); virtual; { 服务端运行OK后的处理 }
    // procedure DoDispatchCommand(CmdStrings: array of string; CmdHandlers: array of TClientCmdActionHandle); virtual; { 分发命令 }
    procedure SendAndRecv; { 运行命令：仅适合简单的命令 }
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Host: string read GetHost write SetHost;
    property Port: Integer read GetPort write SetPort;

    property ErrorCode: integer read GetErrorCode; { 服务端返回的错误代码 }
    property ErrorMessage: string read GetErrorMessage; { 服务端返回的错误信息 }
    property CmdOK: Boolean read GetCmdOK; { 服务端的命令结果 }
  end;

  { Server的Response是用来发送给客户端的                                      }
  { Server的Request是指客户端发送上来的请求命令                               }
  { 继承用法：                                                                }
  {    必须重载DispathCommand方法，DispatchCommand方法类似下面：              }
  {    DoDispatchCommand(['Login','Get','Delete'],[DoLogin,DoGet,DoDelete])   }
  {    而DoLogin等为继承类的具体动作代码等                                    }
  TNetServerCmd = class(TNetCmdObject)
  private
    FSocketThread: TIdPeerThread;
  protected
    procedure DoSucc(const Msg: string = ''); virtual; { Response：成功 }
    procedure DoFail(Code: integer; Msg: string); virtual; { Response：失败 }

    procedure SetData(const Name: string; const Value: string); overload; virtual; { 发送命令时附加数据的处理 }
    procedure SetData(const Name: string; const Value: Integer); overload; virtual;
    procedure SetData(const Name: string; const Value: TDateTime); overload; virtual;
    procedure SetData(const Name: string; const Value: Boolean); overload; virtual;
    procedure SetData(const Name: string; const Value: Float); overload; virtual;
    procedure AddData(const Name: string; const Value: string); 

    function GetFloat(const Name: string): Float;
    function GetString(const Name: string): string;
    function GetInteger(const Name: string): Integer;
    function GetBoolean(const Name: string): Boolean;
    function GetDateTime(const Name: string): TDateTime;

    procedure DoDispatchCommand(CmdStrings: array of string; CmdHandlers: array of TServerCmdActionHandle); virtual;
  public
    constructor Create(AThread: TIdPeerThread);
    destructor Destroy; override;

    procedure DispatchCommand; virtual; abstract; { 分发命令 }
    procedure SendResult;

    class procedure Go(AThread: TIdPeerThread);
  end;

  { Word OLE对象，支持Word的一些事件，如果要添加自己的事件，可以在Invode的Case中
    添加相应的Code和代码即可 }
type
  TWordObject = class(TInterfacedObject, IUnknown, IDispatch)
  private
    FWordApp : OleVariant;
    FDocDispatch: IDispatch;
    FAppDispIntfIID: TGUID;
    FDocDispIntfIID: TGUID;
    FAppConnection: Integer;
    FDocConnection: Integer;
    FOnQuit : TNotifyEvent;
    FOnDocumentChange : TNotifyEvent;
    FOnNewDocument : TNotifyEvent;
    FOnOpenDocument : TNotifyEvent;
    FOnCloseDocument : TNotifyEvent;
    FOnSaveDocument: TNotifyEvent;

    function GetCaption: String;
    function GetVisible: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetVisible(const Value: Boolean);
  protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HRESULT; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HRESULT; stdcall;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure NewDoc(Template : String);
    procedure CloseDoc;
    procedure InsertText(Text : String);
    procedure Print;
    procedure SaveAs(Filename : String);
    procedure Quit(Save: Boolean);
  published
    property Application: OleVariant read FWordApp;
    property Caption : String read GetCaption write SetCaption;
    property Visible : Boolean read GetVisible write SetVisible;

    property OnQuit : TNotifyEvent read FOnQuit write FOnQuit;
    property OnDocumentChange : TNotifyEvent read FOnDocumentChange write FOnDocumentChange;
    property OnNewDocument : TNotifyEvent read FOnNewDocument write FOnNewDocument;
    property OnOpenDocument : TNotifyEvent read FOnOpenDocument write FOnOpenDocument;
    property OnCloseDocument : TNotifyEvent read FOnCloseDocument write FOnCloseDocument;
    property OnSaveDocument : TNotifyEvent read FOnSaveDocument write FOnSaveDocument;
  end;

  {
    从定向控制台，可以用它调用DOS命令，并进行输入输出控制，需要设置其两个属性：
    OnData，收到控制台输出时调用，会传递受到的数出数据。
    OnRun：在运行过程中调用，可以在这里处理自己的事情
    OnEnd：命令行结束时，程序关闭，可以在这里处理后续工作
    SendData用于向控制台程序输入对应字符串！
    注意：本从定向控制台不支持图形界面！所以请不要用它来调用Edit之类的程序。
  }
  TOnData = procedure(Sender: TObject; Data: String) of object;
  TOnRun = procedure(Sender: TObject) of object;
  TRedirectedConsole = Class(TObject)
  private
    fStdInRead, fStdInWrite: THandle;
    fStdOutRead, fStdOutWrite: THandle;
    fStdErrRead, fStdErrWrite: THandle;
    fSA: TSecurityAttributes;
    fPI: TProcessInformation;
    fSI: TStartupInfo;
    fCmdLine: String;
    fOnStdOut, fOnStdErr: TOnData;
    fOnRun, fOnEnd: TOnRun;
    fIsRunning: Boolean;
    fHidden: boolean;
    fTerminate: boolean;
    function ReadHandle(h: THandle; var s: string): integer;
  protected
  public
    constructor Create(CommandLine: String);
    destructor Destroy; override;
    procedure Run;
    procedure Terminate;
    procedure SendData(s: String);
    property OnStdOut: TOnData read fOnStdOut write fOnStdOut;
    property OnStdErr: TOnData read fOnStdErr write fOnStdErr;
    property OnRun: TOnRun read fOnRun write fOnRun;
    property OnEnd: TOnRun read fOnEnd write fOnEnd;
    property IsRunning: boolean read fIsRunning;
    property HideWindow: boolean read fHidden write fHidden;
  end;


{
/// 结构化文件存储类，使用Windows本身的功能完成！
// (c) Alex Konshin mailto:alexk@msmt.spb.su 02.12.97

按如下方式使用：
var
    stgFile:TStgFile;
    stream:TStgStream;
    storage:TStorage;
begin
try
    stgFile := TStgFile.CreateFile( ... );
    storage := stgFile.CreateStorage( ... );
    ...
    stream := storage.CreateStream( ... );
    ...
except
    ...
end;
end;
}
const
  stgmOpenReadWrite = {STGM_TRANSACTED or} STGM_READWRITE or STGM_SHARE_DENY_WRITE;
  stgmOpenRead = {STGM_TRANSACTED or} STGM_READ or STGM_SHARE_EXCLUSIVE;
  stgmCreate = { STGM_TRANSACTED or} STGM_CREATE or STGM_READWRITE or STGM_SHARE_EXCLUSIVE;
  stgmConvert = {STGM_TRANSACTED or} STGM_READWRITE or STGM_SHARE_EXCLUSIVE or STGM_CONVERT;
  
type
  TStorage = class;
  TStgStream  = class(TStream)
  protected
    FStream : IStream;
    FStorage : TStorage;
    FName, FPath : String;

    procedure SetSize( NewSize : Longint ); override;
    procedure SetName( Value : String); virtual;
    constructor Create( const AName : String; AStorage : TStorage; AStream : IStream);
  public
    function Read( var Buffer; Count : Longint ) : Longint; override;
    function Write( const Buffer; Count : Longint ) : Longint; override;
    function Seek( Offset : Longint; Origin : Word ) : Longint; override;
    destructor Destroy; override;
  published
    property Name : String read FName write SetName;
  end; { TStgStream  }

  TStorage = class
  protected
    FStorage : IStorage;
    FName, FPath : String;
    FParent : TStorage;
    FLockCount : LongInt;
    procedure SetName( Value : String); virtual;
    constructor Create( const AName : String; AParent : TStorage; AStorage : IStorage );
  public
    destructor Destroy; override; // Close !
    procedure Close;
    function CreateStream( const AName : String; const Mode : DWord ) : TStgStream;
    function OpenStream( const AName : String; const Mode : DWord ) : TStgStream;
    function OpenCreateStream( const AName : String; const Mode : DWord ) : TStgStream;
    function CreateStorage( const AName : String; const Mode : DWord ) : TStorage;
    function OpenStorage( const AName : String; const Mode : DWord ) : TStorage;
    function OpenCreateStorage( const AName : String; const Mode : DWord; var bCreate : Boolean ) : TStorage;
    procedure RenameElement( const AOldName, ANewName : String );
    //    STGTY_STORAGE      = 1,
    //    STGTY_STREAM       = 2,
    //    STGTY_LOCKBYTES    = 3,
    //    STGTY_PROPERTY     = 4
    procedure EnumElements( AStrings : TStringList ; dwTypeNeed:DWORD);
    procedure Commit(cFlag:DWORD);
  published
    property Storage : IStorage read FStorage;
    property Name : String read FName write SetName;
    property Path : String read FPath;
  end; { TStorage }

  TStgFile = class(TStorage)
  protected
    FFileName : String;
    constructor Create( const AFileName : String; AStorage : IStorage );
  public
    class function CreateFile( const AFileName : String; const Mode : DWord ) : TStgFile;
    class function OpenFile( const AFileName : String; const Mode : DWord ) : TStgFile;
    //  function Clone( const Mode : DWord ) : TStgFile;
  end; { TStgFile }

  {
    采用链表实现的FIFO队列
    由于无需大量的内存操作，因此效率比TList高很多！！
  }
  PLinkNode = ^TLinkNode;
  TLinkNode = record
    Prior: PLinkNode;
    Data: Pointer;
    Next: PLinkNode;
  end;

  // 删除节点时的调用，可以在这里清除数据
  TOnDeleteItemEvent = procedure(Data: Pointer) of object;

  // 采用链表实现的List,线程安全的
  TListEx = class(TObject)
  private
    FLock : TCriticalSection;
    FOnDeleteItem: TOnDeleteItemEvent;
    FCount: Integer;
    FFirst, FLast: PLinkNode;
  protected
    procedure DoDelete(Node: PLinkNode); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure UnLock;
    function Add(Data: Pointer): Integer;
    function Insert(Index: Integer; Data: Pointer): Integer;
    function Delete(Index: Integer): Boolean; virtual;
    function First: Pointer;
    function Last: Pointer;
    function GetItem(Index: Integer): Pointer;
    function IndexOf(Data: Pointer): Integer;

    procedure Clear; virtual;
  published
    property Count: Integer read FCount;
    property OnDeleteItem: TOnDeleteItemEvent read FOnDeleteItem write FOnDeleteItem;
  end;

  TExtendQueue = class(TObject)
  private
    FLock : TCriticalSection;
    FFirstNode, FLastNode: PLinkNode;
    FCount: Integer;
    //procedure DeleteNode(node: PLinkNode);
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure PushItem(Item: Pointer);
    function PopItem: Pointer;
    function GetItem: Pointer;
    property Count: Integer read FCount;
  end;

  procedure register;

implementation

var
  ByteToCompare: integer;
  SortOrderAsc: Boolean;

  { TValueList }

constructor TValueList.Create(Size: Integer);
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FItemSize := Size;
  FData := nil;
  FTag := 0;
end;

destructor TValueList.Destroy;
begin
  inherited Destroy;
  FLock.Free;
end;

{ Get memory and Make Pointer from the value }

function TValueList.MakePointerFromValue(const Value): Pointer;
var
  pNewItem: Pointer;
begin
  GetMem(pNewItem, FItemSize);
  if Assigned(@Value) then
    System.Move(Value, pNewItem^, FItemSize)
  else
    FillChar(pNewItem^, FItemSize, 0);
  Result := pNewItem;
end;

function TValueList.Add(const Value): Integer;
begin
  Result := AddPointer(MakePointerFromValue(Value));
end;

function TValueList.AddPointer(Item: Pointer): Integer;
begin
  Lock;
  try
    Result := inherited Add(Item);
  finally
    UnLock;
  end;
end;

procedure TValueList.Assign(Source: TValueList);
begin
  Lock;
  try
    if Assigned(Source) then
      Source.DoAssign(Self);
  finally
    UnLock;
  end;
end;

procedure TValueList.DoAssign(Dest: TValueList);
var
  iCount: Integer;
begin
  Dest.Clear;
  Dest.FItemSize := FItemSize;
  Dest.FName := FName;
  Dest.FTag := FTag;
  Dest.FData := FData;
  for iCount := 0 to Count - 1 do
    Dest.Add(Items[iCount]^);
end;

procedure TValueList.RemoveAll(const Item);
begin
  repeat until Remove(Item) < 0;
end;

procedure TValueList.Clear;
begin
  Lock;
  try
    while Count > 0 do
      Delete(Count - 1);
    inherited Clear;
  finally
    UnLock;
  end;
end;

procedure TValueList.Delete(Index: Integer);
begin
  Lock;
  try
    FreeItem(Index);
    inherited Delete(Index);
  finally
    UnLock;
  end;
end;

function TValueList.Remove(const Value): integer;
begin
  Lock;
  try
    Result := IndexOf(Value);
    if Result >= 0 then Delete(Result);
  finally
    UnLock;
  end;
end;

function TValueList.Duplicate: TValueList;
var
  iCount: Integer;
begin
  Lock;
  try
    Result := TValueList.Create(FItemSize);
    for iCount := 0 to Count - 1 do
      Result.Add(Items[iCount]^);
  finally
    UnLock;
  end;
end;

function TValueList.Equal(Item: TValueList): Boolean;
var
  iCount: Integer;
begin
  Lock;
  try
    Result := (FItemSize = Item.FItemSize) and (Count = Item.Count);
    if Result then
      for iCount := 0 to Count - 1 do
      begin
        if Items[iCount] = Item.Items[iCount] then Continue;
        if Assigned(Items[iCount]) and Assigned(Item.Items[iCount]) then
          Result := Result and CompareMem(Items[iCount], Item.Items[iCount],
            FItemSize)
        else
          Result := False;
      end;
  finally
    UnLock;
  end;
end;

function TValueList.IndexOf(const Value): Integer;
var
  pItem: Pointer;
begin
  Lock;
  try
    pItem := @Value;
    if Assigned(pItem) then
      for Result := 0 to Count - 1 do
        if CompareMem(pItem, Items[Result], ItemSize) then Exit;
    Result := -1;
  finally
    UnLock;
  end;
end;

procedure TValueList.Insert(Index: Integer; const Value);
var
  Temp: Pointer;
begin
  Lock;
  try
    Temp := MakePointerFromValue(Value);
    try
      InsertPointer(Index, Temp);
    except
      FreeMem(Temp, FItemSize);
      raise;
    end;
  finally
    UnLock;
  end;
end;

procedure TValueList.ReadFromStream(Stream: TStream);
var
  i, C, R: Integer;
  Temp: Pointer;
begin
  Lock;
  try
    Clear;
    C := 0;
    FItemSize := 0;

    with Stream do
    begin
      R := Read(FItemSize, Sizeof(FItemSize));
      if R <> SizeOf(FItemSize) then
        raise EValueList.CreateFmt(SErrStream, [SRead, SizeOf(FItemSize), R]);

      R := Read(C, SizeOf(C));
      if R <> SizeOf(C) then
        raise EValueList.CreateFmt(SErrStream, [SRead, SizeOf(C), R]);

      GetMem(Temp, FItemSize);
      try
        for i := 1 to C do
        begin
          R := LoadItem(Stream, Temp);
          if R <> FItemSize then
            raise EValueList.CreateFmt(SErrStream, [SRead, FItemSize, R]);
          Add(Temp^);
        end;
      finally
        FreeMem(Temp, FItemSize);
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TValueList.WriteToStream(Stream: TStream);
var
  C, i, R: Integer;
begin
  Lock;
  try
    C := Count;
    with Stream do
    begin
      R := Write(FItemSize, SizeOf(FItemSize));
      if R <> Sizeof(FItemSize) then
        raise EValueList.CreateFmt(SErrStream, [SWrite, SizeOf(FItemSize), R]);

      R := Write(C, SizeOf(C));
      if R <> Sizeof(C) then
        raise EValueList.CreateFmt(SErrStream, [SWrite, SizeOf(C), R]);

      for i := 0 to C - 1 do
      begin
        R := SaveItem(Stream, i);
        if R <> FItemSize then
          raise EValueList.CreateFmt(SErrStream, [SWrite, FItemSize, R]);
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TValueList.SetItemSize(const Value: Integer);
begin
  if Count = 0 then
    FItemSize := Value
  else
    raise EValueList.CreateFmt(SErrSetItemSize, [Count]);
end;

procedure TValueList.DoSetItems(Index: integer; const Value);
begin
  if (Index < 0) or (Index >= Count) then
    raise EObjectList.CreateFmt(SErrOutBounds, [Index, Count - 1]);
  System.Move(Value, Items[Index]^, FItemSize);
end;

function CompareHighToLow(Item1, Item2: Pointer): integer;
var
  P1: PByte;
  P2: PByte;
  Size: integer;
begin
  Size := ByteToCompare;
  if SortOrderAsc then
  begin
    P1 := Item1;
    P2 := Item2;
  end
  else
  begin
    P1 := Item2;
    P2 := Item1;
  end;
  Inc(P1, Size);
  Inc(P2, Size);
  Result := 0;
  while Size > 0 do
  begin
    Dec(Size);
    Dec(P1);
    Dec(P2);
    if P1^ < P2^ then
    begin
      Result := -1;
      Break;
    end
    else if P1^ > P2^ then
    begin
      Result := 1;
      Break;
    end;
  end;
end;

function CompareLowToHigh(Item1, Item2: Pointer): integer;
var
  P1: PByte;
  P2: PByte;
  i: integer;
begin
  Result := 0;

  if SortOrderAsc then
  begin
    P1 := Item1;
    P2 := Item2;
  end
  else
  begin
    P1 := Item2;
    P2 := Item1;
  end;

  i := 1;
  while i <= ByteToCompare do
  begin
    if P1^ < P2^ then
    begin
      Result := -1;
      Break;
    end
    else if P1^ > P2^ then
    begin
      Result := 1;
      Break;
    end;
    Inc(P1);
    Inc(P2);
    Inc(i);
  end;
end;

procedure TValueList.DefaultSort(const Asc: Boolean = True; const LowToHigh: Boolean
  = True);
begin
  Lock;
  try
    ByteToCompare := FItemSize;
    SortOrderAsc := Asc;
    if LowToHigh then
      Sort(@CompareLowToHigh)
    else
      Sort(@CompareHighToLow);
  finally
    UnLock;
  end;
end;

procedure TValueList.FreeItem(Index: integer);
begin
  Lock;
  try
    if (Index < 0) or (Index >= Count) then
      raise EValueList.CreateFmt(SErrOutBounds, [Index, Count - 1]);
    if Assigned(inherited Items[Index]) then
      FreeMem(inherited Items[Index], FItemSize);
    inherited Items[Index] := nil;
  finally
    UnLock;
  end;
end;

procedure TValueList.InsertPointer(Index: integer; Value: Pointer);
begin
  Lock;
  try
    inherited Insert(Index, Value);
  finally
    UnLock;
  end;
end;

function TValueList.BinSearch(const Value; CompareProc: TListSortCompare = nil):
  integer;
var
  L, H, M: integer;
begin
  Lock;
  try
    Result := -1;
    if Count = 0 then exit;
    if @CompareProc = nil then
    begin
      ByteToCompare := FItemSize;
      CompareProc := CompareHighToLow;
    end;
    L := 0;
    H := Count - 1;
    if (CompareProc(@Value, Items[L]) < 0) or (CompareProc(@Value, Items[H]) > 0) then
      exit;
    while L <= H do
    begin
      M := (L + H) div 2;
      if CompareProc(Items[M], @Value) = 0 then
      begin
        Result := M;
        Break;
      end;
      if CompareProc(Items[M], @Value) > 0 then
        H := M - 1
      else
        L := M + 1;
    end;
  finally
    UnLock;
  end;
end;

procedure TValueList.Lock;
begin
  FLock.Enter;
end;

procedure TValueList.UnLock;
begin
  FLock.Leave;
end;

procedure TValueList.LoadFromFile(const Filename: String);
var
  Stream: TFileStream;
begin
  FFileName := Filename;
  if not FileExists(Filename) then Exit;
  Stream := TFileStream.Create(Filename, fmOpenRead);
  try
    ReadFromStream(Stream);
  finally
    FreeAndNilEx(Stream);
  end;
end;

procedure TValueList.SaveToFile(const FileName: String);
var
  Stream: TFileStream;
begin
  CreateFileOnDisk(FileName);
  Stream := TFileStream.Create(FileName, fmOpenWrite);
  try
    WriteToStream(Stream);
  finally
    FreeAndNilEx(Stream);
  end;
end;

function TValueList.LoadItem(Stream: TStream; Data: Pointer): Integer;
begin
  Result := Stream.Read(Data^, FItemSize);
end;

function TValueList.SaveItem(Stream: TStream; const Index: Integer): Integer;
begin
  Result := Stream.Write(Items[Index]^, FItemSize);
end;

function TValueList.Item(const Index: Integer): Pointer;
begin
  Result := inherited Items[Index];
end;

procedure TValueList.Save;
begin
  if FFileName <> '' then
    SaveToFile(FFileName);  
end;

{ TObjectList }

function TObjectList.Add(AObject: TObject): Integer;
begin
  Result := -1;
  Lock;
  try
    if (AObject = nil) or (AObject is FClassType) then
      Result := inherited Add(AObject)
    else
      ClassTypeError(AObject.ClassName);
  finally
    UnLock;
  end;
end;

constructor TObjectList.Create;
begin
  Create(TObject);
end;

constructor TObjectList.Create(AClassType: TClass);
begin
  inherited Create;
  FLock := TCriticalSection.Create;;
  FClassType := AClassType;
end;

procedure TObjectList.Delete(Index: Integer);
begin
  Lock;
  try
    FreeItem(Index);
    inherited Delete(Index);
  finally
    UnLock;
  end;
end;

procedure TObjectList.ClassTypeError(Message: string);
begin
  raise EObjectList.CreateFmt(SErrClassType, [FClassType.ClassName, Message]);
end;

function TObjectList.Expand: TObjectList;
begin
  Lock;
  try
    Result := (inherited Expand) as TObjectList;
  finally
    UnLock;
  end;
end;

function TObjectList.First: TObject;
begin
  Lock;
  try
    Result := TObject(inherited First);
  finally
    UnLock;
  end;
end;

function TObjectList.GetItems(Index: Integer): TObject;
begin
  Lock;
  try
    Result := TObject(inherited Items[Index]);
  finally
    UnLock;
  end;
end;

function TObjectList.IndexOf(AObject: TObject): Integer;
begin
  Lock;
  try
    Result := inherited IndexOf(AObject);
  finally
    UnLock;
  end;
end;

procedure TObjectList.Insert(Index: Integer; Item: TObject);
begin
  Lock;
  try
    if (Item = nil) or (Item is FClassType) then
      inherited Insert(Index, Pointer(Item))
    else
      ClassTypeError(Item.ClassName);
  finally
    UnLock;
  end;
end;

function TObjectList.Last: TObject;
begin
  Lock;
  try
    Result := TObject(inherited Last);
  finally
    UnLock;
  end;
end;

function TObjectList.Remove(AObject: TObject): Integer;
begin
  Lock;
  try
    Result := IndexOf(AObject);
    if Result >= 0 then Delete(Result);
  finally
    UnLock;
  end;
end;

procedure TObjectList.SetItems(Index: Integer; const Value: TObject);
begin
  Lock;
  try
    if Value = nil then
      FreeItem(Index)
    else if Value is FClassType then
      inherited Items[Index] := Value
    else
      ClassTypeError(Value.ClassName);
  finally
    UnLock;
  end;
end;

destructor TObjectList.Destroy;
begin                
  inherited Destroy;
  FLock.Free;
end;

procedure TObjectList.FreeItem(Index: integer);
begin
  Lock;
  try
    if (Index < 0) or (Index >= Count) then
      raise EObjectList.CreateFmt(SErrOutBounds, [Index, Count - 1]);
    if Assigned(inherited Items[Index]) then Items[Index].Free;
    inherited Items[Index] := nil;
  finally
    UnLock;
  end;
end;

procedure TObjectList.Lock;
begin
  FLock.Enter;
end;

procedure TObjectList.UnLock;
begin
  FLock.Leave;
end;

procedure TObjectList.Clear;
var
  i : Integer;
begin
  for i := 0 to Count - 1 do
  if Assigned(Items[i]) then
  begin
    Items[i] := nil;
  end;
  inherited;
end;

{ TIntegerList }

procedure TIntegerList.Add(Value: integer);
begin
  inherited Add(Value);
end;

constructor TIntegerList.Create;
begin
  inherited Create(SizeOf(integer));
end;

function TIntegerList.GetItems(Index: integer): integer;
begin
  Result := integer(inherited Items[Index]^);
end;

procedure TIntegerList.SetItems(Index: integer; const Value: integer);
begin
  DoSetItems(Index, Value);
end;

function TIntegerList.ValueExist(Value: integer): Boolean;
begin
  Result := IndexOf(Value) <> -1;
end;

{ TInt64List }

constructor TInt64List.Create;
begin
  inherited Create(SizeOf(Int64));
end;

function TInt64List.GetItems(Index: integer): Int64;
begin
  Result := int64(inherited Items[index]^);
end;

procedure TInt64List.SetItems(Index: integer; const Value: Int64);
begin
  DoSetItems(Index, Value);
end;

{ TOrderValueList }

procedure TOrderValueList.Sort(const AscOrder: Boolean);
begin
  DefaultSort(AscOrder, False);
end;

{ TTimerThread }

constructor TTimerThread.Create;
begin
  inherited Create(True); { Suspend after create }
  FreeOnTerminate := True; { Free On Terminiate    }
  FInterval := 1000;
  FEnabled := False;
  FSyncInvoke := True;
  FReEntry := False;
  FEvent := TSimpleEvent.Create;
end;

destructor TTimerThread.Destroy;
begin
  FEvent.Free;
  inherited;
end;

procedure TTimerThread.DoError;
begin
  if Assigned(FOnError) then FOnError(Self);
end;

procedure TTimerThread.DoTimer;
begin
  if Assigned(FOnTimer) and not Terminated then
  try { 防止未处理的异常导致线程异常结束 }
    FOnTimer(Self);
  except
    if SyncInvoke then
      Synchronize(DoError)
    else
      DoError;
  end;
end;

procedure TTimerThread.Execute;
begin
  repeat
    if FEvent.WaitFor(FInterval) = wrTimeout then { 必须是等待指定时间才调用 }
    try
      if ReEntry then { 如果可以重入，则创建一个线程运行代码之后，立即返回，保证精确计时 }
        TRunThread.Create(DoTimer, FSyncInvoke)
      else if FSyncInvoke then { 不可以重入，可能在计时上面没有那么精确，同步调用 }
        Synchronize(DoTimer)
      else
        DoTimer;
    except
    end;
  until Terminated;
end;

procedure TTimerThread.Free;
begin
  Terminate;
  FEvent.SetEvent;
end;

procedure TTimerThread.Reset;
begin
  { 复位计时标志 }
  FEvent.SetEvent;
  FEvent.ResetEvent;
end;

procedure TTimerThread.SetEnabled(const Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FEnabled then
      Resume
    else
      Suspend;
  end;
end;

procedure TTimerThread.SetInterval(const Value: DWORD);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    if Enabled then Reset;
  end;
end;

procedure TTimerThread.SetReEntry(const Value: Boolean);
begin
  if Value <> ReEntry then
  begin
    FReEntry := Value;
    if Enabled then Reset;
  end;
end;

{ TLogFile }

function TLogFile.WriteLog(const Msg: string): Boolean;
var
  Buf : string;
  oldFileName:String;
begin
  if TimeStamp then
    Buf := DateTimeToStr(Now) + ';' + Msg
  else
    Buf := Msg;

  if Assigned(FOnLogMessage) then FOnLogMessage(Self, Buf);

  if Assigned(FStream) then
  begin
    if MaxSize > 0 then /// 如果Log大小超过了最大限制，换文件
      if FStream.Position > MaxSize then
      begin
        FreeAndNilEx(FStream);
        oldFileName := ChangeFileExtEx(FileName,'') + '_' + FormatDateTime('yyyy-mm-dd',Now)+'.log';
        if FileExists(oldFileName) then
          DeleteFile(oldFileName);
        RenameFile(FileName,oldFileName);
        CreateFileOnDisk(FileName);
        if IsFileInUse(FileName) then Exit;
        FStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
        FStream.Seek(0, soFromEnd);
      end;

    FStream.Write(PChar(buf)^, Length(buf));
    Result := FStream.Write(Crlf, 2) = 2;
  end
  else
    Result := False;
end;

procedure TLogFile.Clear;
begin
  FStream.Size := 0;
  FStream.Position := 0;
end;

constructor TLogFile.Create(AFileName: string);
var
  APath:String;
begin
  FFileName := AFileName;
  APath := ExtractFilePath(FFileName);
  if not DirectoryExists(APath) then
    ForceDirectories(APath);
  CreateFileOnDisk(FileName);
  if IsFileInUse(FileName) then Exit;

  FStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
  FStream.Seek(0, soFromEnd);
end;

destructor TLogFile.Destroy;
begin
  FreeAndNilEx(FStream);
end;

procedure TLogFile.SetMaxSize(const Value: int64);
begin                  
  if Value <> FMaxSize then
  begin
    FMaxSize := Value;
    if (Value > 0) and Assigned(FStream) and (FStream.Size > Value) then
      FStream.Size := Value;
  end;
end;

procedure TLogFile.SetTimeStamp(const Value: Boolean);
begin
  FTimeStamp := Value;
end;

resourcestring
  CouldNotMapViewOfFile = 'Could not map view of file.';

constructor TSharedStream.Create;
const
  Sz = 1024000;
var
  SHandle: THandle;
begin
  FPosition := 0;
  FSize := 0;
  FPageSize := Sz;

  SHandle := CreateFileMapping(SwapHandle, nil, PAGE_READWRITE, 0, Sz, nil);

  if SHandle = 0 then
    raise Exception.Create(CouldNotMapViewOfFile);

  FMemory := MapViewOfFile(SHandle, FILE_MAP_WRITE, 0, 0, Sz);
  if FMemory = nil then
    raise Exception.Create(CouldNotMapViewOfFile);

  CloseHandle(SHandle);
end;

destructor TSharedStream.Destroy;
begin
  UnmapViewOfFile(FMemory);
  inherited Destroy;
end;

function TSharedStream.Read(var Buffer; Count: Longint): Longint;
begin
  if Count > 0 then
  begin
    Result := FSize - FPosition;
    if Result > 0 then
    begin
      if Result > Count then Result := Count;
      Move((PChar(FMemory) + FPosition)^, Buffer, Result);
      Inc(FPosition, Result);
    end
  end
  else
    Result := 0
end;

function TSharedStream.Write(const Buffer; Count: Integer): Longint;
var
  I: Integer;
begin
  if Count > 0 then
  begin
    I := FPosition + Count;
    if FSize < I then Size := I;
    System.Move(Buffer, (PChar(FMemory) + FPosition)^, Count);
    FPosition := I;
    Result := Count;
  end
  else
    Result := 0
end;

function TSharedStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize - Offset;
  end;
  if FPosition > FSize then
    FPosition := FSize
  else if FPosition < 0 then
    FPosition := 0;
  Result := FPosition;
end;

procedure TSharedStream.SetSize(NewSize: Integer);
const
  Sz = 1024000;
var
  NewSz: Integer;
  SHandle: THandle;
  SMemory: Pointer;
begin
  inherited SetSize(NewSize);

  if NewSize > FPageSize then
  begin
    NewSz := NewSize + Sz;

    SHandle := CreateFileMapping(SwapHandle, nil, PAGE_READWRITE, 0, NewSz, nil);
    if SHandle = 0 then
      raise Exception.Create(CouldNotMapViewOfFile);

    SMemory := MapViewOfFile(SHandle, FILE_MAP_WRITE, 0, 0, NewSz);
    if SMemory = nil then
      raise Exception.Create(CouldNotMapViewOfFile);

    CloseHandle(SHandle);
    Move(FMemory^, SMemory^, FSize);
    UnmapViewOfFile(FMemory);

    FMemory := SMemory;
    FPageSize := NewSz;
  end;

  FSize := NewSize;

  if FPosition > FSize then FPosition := FSize;
end;

procedure TSharedStream.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream)
  finally
    Stream.Free
  end
end;

procedure TSharedStream.LoadFromStream(Stream: TStream);
var
  Count: Longint;
begin
  Stream.Position := 0;
  Count := Stream.Size;
  SetSize(Count);
  if Count > 0 then Stream.Read(FMemory^, Count);
end;

procedure TSharedStream.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream)
  finally
    Stream.Free
  end
end;

procedure TSharedStream.SaveToStream(Stream: TStream);
begin
  Stream.Write(FMemory^, FSize);
end;

{ TSparseArray }

type
  TSparseArrayEntry = packed record
    Key: LongInt; { Array index }
    Data: Pointer; { Save Data }
  end;
  PSparseArrayEntry = ^TSparseArrayEntry;

  { create ourself }

constructor TSparseArray.Create;
begin
  inherited Create;
  Low := ALow;
  High := AHigh;
  FList := TList.Create;
  FLastExact := -1;
end;

destructor TSparseArray.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

{ clear the list and the accumlators }

procedure TSparseArray.Clear;
var
  i: integer;
begin
  for i := Pred(Count) downto 0 do
  begin
    Delete(i);
    Dispose(FList.Items[i]);
  end;
  FList.Clear;
  FLastExact := -1;
end;

{ simple array management }

function TSparseArray.GetCount: integer;
begin
  Result := FList.Count;
end;

function TSparseArray.First: LongInt;
begin
  if FList.Count > 0 then
    Result := PSparseArrayEntry(FList[0]).Key
  else
    Result := System.Low(LongInt);
end;

function TSparseArray.Last: LongInt;
begin
  if FList.Count > 0 then
    Result := PSparseArrayEntry(FList[FList.Count - 1]).Key
  else
    Result := System.High(LongInt);
end;

function TSparseArray.Previous(Key: LongInt): LongInt;
begin
  Result := -1;
end;

function TSparseArray.Next(Key: LongInt): LongInt;
begin
  Result := -1;
end;

{ get an array entry }

function TSparseArray.Get(Key: LongInt): Pointer;
var
  Status: TSparseArrayCompare;
  Ndx: integer;
begin
  { assume we are going to fail }
  Result := nil;

  { are you here? }
  Ndx := ClosestNdx(Key, Status);

  { if we found it then return its data }
  if Status = sacExact then
  begin
    if (Key > High) or (Key < Low) then
      raise ESparesException.CreateFmt(SSparseBoundError, [Key, Low, High]);
    Result := PSparseArrayEntry(FList[Ndx]).Data;
  end;
end;

{ set an array entry }

procedure TSparseArray.Put(Key: LongInt; Item: Pointer);
var
  Status: TSparseArrayCompare;
  Ndx: integer;
  AEntry: PSparseArrayEntry;
begin
  if (Key > FHigh) or (Key < FLow) then
    raise ESparesException.CreateFmt(SSparseBoundError, [Key, Low, High]);

  { were do we add? }
  Ndx := ClosestNdx(Key, Status);

  { did we find a match? }
  if Status = sacExact then
  begin
    if Item = nil then { is the new data actually nil? }
    begin
      FList.Delete(Ndx);
      FLastExact := -1;
    end
    else { otherwise just assign its data then }
      PSparseArrayEntry(FList[Ndx]).Data := Item;
  end
  else { otherwise we need to create a new array entry }
  begin
    New(AEntry);
    if AEntry <> nil then
    begin
      { fill it in }
      AEntry.Key := Key;
      AEntry.Data := Item;

      { ok so where do we put it? }
      case Status of
        sacBefore:
          FList.Insert(Ndx, AEntry);
        sacAfter:
          FList.Add(AEntry);
      end;
    end;
  end;
end;

{ find closest index, depending on the resulting status this may
   return a matching index or something relative to an existing index }

function TSparseArray.ClosestNdx(Key: LongInt; var Status: TSparseArrayCompare): LongInt;
var
  NowAt, StartAt, EndAt: integer;
  Found: boolean;

  { compare two keys, -1 = Key1 is less, 0 = Key1 is Key2, 1 = Key1 is greater }
  function Compare(Key1, Key2: LongInt): TSparseArrayCompare;
  begin
    if Key1 < Key2 then
      Result := sacBefore
    else if Key1 > Key2 then
      Result := sacAfter
    else
      Result := sacExact;
  end;

begin
  { if FLastExact pointing at something valid? }
  if FLastExact > -1 then
  begin
    { yep its still the same }
    if Key = PSparseArrayEntry(FList[FLastExact]).Key then
    begin
      Status := sacExact;
      Result := FLastExact;
      Exit;
    end
    else { otherwise reset data }
      FLastExact := -1;
  end;

  { is there nothing to search thru? }
  if FList.Count = 0 then
  begin
    Status := sacAfter;
    Result := 0;
  end

    { lets set up some variables and search }
  else
  begin
    Found := False;
    StartAt := 0; { start at the beginning }
    EndAt := FList.Count - 1; { go till the end }

    { loopin dude }
    repeat

      { now were are we? }
      NowAt := (StartAt + EndAt) div 2;

      { see if its somewhere around here? }
      Status := Compare(Key, PSparseArrayEntry(FList[NowAt]).Key);

      { calculate the new relative bounds and check for an exact match }
      case Status of
        sacBefore:
          EndAt := NowAt - 1;
        sacExact:
          Found := True;
        sacAfter:
          StartAt := NowAt + 1;
      end;

      { game over man }
    until Found or (StartAt > EndAt);

    { did we find it? }
    if Found then
    begin
      Result := NowAt;
      Status := sacExact;
      FLastExact := NowAt;
    end
    else
    begin
      { leave it where we left off }
      Result := StartAt;

      { are we inserting or adding? }
      if Result > FList.Count - 1 then
        Status := sacAfter
      else
        Status := sacBefore;
    end;
  end;
end;

function TSparseArray.GetItems(Index: integer): Pointer;
begin
  Result := PSparseArrayEntry(FList[Index]).Data;
end;

procedure TSparseArray.SetItems(Index: integer; const Value: Pointer);
begin
  PSparseArrayEntry(FList[Index]).Data := Value;
end;

procedure TSparseArray.Delete(Index: integer);
begin

end;

procedure TSparseArray.SetHigh(const Value: integer);
var
  i: integer;
begin
  if Value < High then
    for i := High downto Value do
      Delete(i);
  FHigh := Value;
end;

procedure TSparseArray.SetLow(const Value: integer);
var
  i: integer;
begin
  if Value > Low then
    for i := High downto Value do
      Delete(i);
  FLow := Value;
end;

{ TObjectSparseArray }

function TObjectSparseArray.GetItems(Index: integer): TObject;
begin
  Result := inherited GetItems(Index);
end;

procedure TObjectSparseArray.SetItems(Index: integer; const Value: TObject);
begin
  inherited SetItems(Index, Value);
end;

function TObjectSparseArray.GetObjects(Key: Integer): TObject;
begin
  Result := inherited Get(Key);
end;

procedure TObjectSparseArray.SetObjects(Key: Integer; const Value: TObject);
begin
  inherited Put(Key, Value);
end;

procedure TObjectSparseArray.Delete(Index: integer);
begin
  Items[Index].Free;
  inherited Delete(Index);
end;

{ TIntSparseArray }

function TIntSparseArray.GetIntegers(Index: integer): Integer;
begin
  Result := Integer(inherited Get(Index));
end;

procedure TIntSparseArray.SetIntegers(Index: integer; const Value: Integer);
begin
  inherited Put(Index, Pointer(Value));
end;

function TIntSparseArray.GetItems(Index: integer): Integer;
begin
  Result := Integer(inherited GetItems(Index));
end;

procedure TIntSparseArray.SetItems(Index: integer; const Value: Integer);
begin
  inherited SetItems(Index, Pointer(Value));
end;

{ TSparseMatrix }

constructor TSparseMatrix.Create(ARowCount, AColCount: integer);
begin
  inherited Create(0, ARowCount);
  RowCount := ARowCount;
  ColCount := AColCount;
end;

function TSparseMatrix.GetCells(ARow, ACol: integer): Pointer;
var
  FItem: TSparseArray;
begin
  Result := nil;

  if (ARow > RowCount) or (ACol > ColCount) then
    raise EMatrixException.CreateFmt(SMatrixBoundError, [ARow, ACol, RowCount, ColCount]);

  FItem := Objects[ARow];
  if Assigned(FItem) then
    Result := FItem.Data[ACol];
end;

procedure TSparseMatrix.SetCells(ARow, ACol: integer; const Value: Pointer);
var
  FRowItem: TSparseArray;
begin
  if (ARow > RowCount) or (ACol > ColCount) then
    raise EMatrixException.CreateFmt(SMatrixBoundError, [ARow, ACol, RowCount, ColCount]);

  FRowItem := Objects[ARow];
  if not Assigned(FRowItem) then
  begin
    FRowItem := TSparseArray.Create;
    FRowItem[ACol] := Value;
    Objects[ARow] := FRowItem;
  end
  else
    FRowItem[ACol] := Value;
end;

procedure TSparseMatrix.SetCols(const Value: Integer);
begin
  FColCount := Value;
end;

procedure TSparseMatrix.SetRows(const Value: Integer);
begin
  FRowCount := Value;
end;

{ TSparseObjectSparseArray }

function TSparseObjectSparseArray.GetItems(Index: integer): TSparseArray;
begin
  Result := TSparseArray(inherited GetItems(Index));
end;

function TSparseObjectSparseArray.GetObjects(Key: Integer): TSparseArray;
begin
  Result := TSparseArray(inherited GetObjects(Key));
end;

procedure TSparseObjectSparseArray.SetItems(Index: integer; const Value: TSparseArray);
begin
  inherited SetItems(Index, Value);
end;

procedure TSparseObjectSparseArray.SetObjects(Key: Integer; const Value: TSparseArray);
begin
  inherited SetObjects(Key, Value);
end;

{ TIntSparseMatrix }

function TIntSparseMatrix.GetCells(ARow, ACol: integer): integer;
begin
  Result := integer(inherited GetCells(ARow, ACol));
end;

procedure TIntSparseMatrix.SetCells(ARow, ACol: integer; const Value: integer);
begin
  inherited SetCells(ARow, ACol, Pointer(Value));
end;

{ TObjectSparseMatrix }

procedure TObjectSparseMatrix.Clear;
var
  iRow, iCol: integer;
begin
  for iRow := 0 to Pred(Count) do
    for iCol := 0 to Pred(Items[iRow].Count) do
      if Assigned(Items[iRow].Items[iCol]) then
      begin
        TObject(Items[iRow].Items[iCol]).Free;
      end;
  inherited Clear;
end;

function TObjectSparseMatrix.GetObjects(ARow, ACol: integer): TObject;
begin
  Result := inherited GetCells(ARow, ACol);
end;

procedure TObjectSparseMatrix.SetObjects(ARow, ACol: integer; const Value: TObject);
begin
  inherited SetCells(ARow, ACol, Value);
end;

{ TRemoteMemoryAccess }

function GetRemoteMem(PID: THandle; Size: integer): PByte;
{
  在远程进程里面申请一块内存块，PID为被申请进程的进程ID，Size为申请的内存大小
  注意，函数返回申请到的内存的指针，必须用FreeRemoteMem进行释放！否则有内存泄露
  若函数不成功，返回nil
}
var
  hProcess: THandle;
begin
  Result := nil;
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, FALSE, Pid);
  if (hProcess = 0) then Exit;
  Result := VirtualAllocEx(hProcess, nil, Size, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  CloseHandle(hProcess);
end;

function FreeRemoteMem(PID: THandle; Ptr: PByte; Size: integer): Boolean;
{
  释放远程进程的内存块,PID为需要释放内存的进程ID，Ptr为指针，必须用GetRemoteMem
  申请，Size为大小，成功返回True，否则返回False
}
var
  hProcess: THandle;
begin
  Result := False;
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, FALSE, Pid);
  if (hProcess = 0) then Exit;
  Result := Boolean(VirtualFreeEx(hProcess, Ptr, Size, MEM_RELEASE));
  CloseHandle(hProcess);
end;

constructor TRemoteMemoryAccess.Create(APID: THandle; ASize: integer);
begin
  FProcess := OpenProcess(PROCESS_ALL_ACCESS, FALSE, APID);
  Size := ASize;
end;

destructor TRemoteMemoryAccess.Destroy;
begin
  VirtualFreeEx(FProcess, FPointer, Size, MEM_RELEASE);
  CloseHandle(FProcess);
  inherited;
end;

function TRemoteMemoryAccess.Read(var Buf; ASize: integer): Cardinal;
begin
  if ASize > FSize then raise ERemoteMemoryAccessError.CreateFmt(SSizeError, [ASize, Size]);
  if Valid then
    ReadProcessMemory(FProcess, FPointer, @Buf, ASize, Result);
end;

procedure TRemoteMemoryAccess.SetSize(const Value: integer);
begin
  if (Size <> Value) and (Value > 0) then
  begin
    FSize := Value;
    FPointer := VirtualAllocEx(FProcess, nil, Size, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  end;
end;

function TRemoteMemoryAccess.Valid: Boolean;
begin
  Result := (FProcess <> 0) and (FPointer <> nil);
end;

function TRemoteMemoryAccess.Write(const Buf; ASize: integer): Cardinal;
begin
  if ASize > FSize then raise ERemoteMemoryAccessError.CreateFmt(SSizeError, [ASize, Size]);
  if Valid then
    WriteProcessMemory(FProcess, FPointer, @Buf, ASize, Result);
end;

{ TRunThread }

constructor TRunThread.Create(ARunProc: TThreadProc; ASyncInvoke: Boolean = True; const Param: Pointer = nil);
begin
  FSync := ASyncInvoke;
  FRunProc := ARunProc;
  FParam := Param;
  inherited Create(False);
  FreeOnTerminate := True;
end;

constructor TRunThread.Create(AEventProc: TNotifyEvent; ASyncInvoke: Boolean = True);
begin
  FSync := ASyncInvoke;
  FEventProc := AEventProc;
  inherited Create(False);
  FreeOnTerminate := True;
end;

constructor TRunThread.Create(AObjectProc: TThreadMethod; ASyncInvoke: Boolean = True);
begin
  FSync := ASyncInvoke;
  FObjectProc := AObjectProc;
  inherited Create(False);
  FreeOnTerminate := True;
end;

constructor TRunThread.Create(const Param: Pointer = nil);
begin
  FreeOnTerminate := True;
  FLoop := True;
  FIdle := 50;
  FParam := Param;
  inherited Create(True);
end;

procedure TRunThread.DoRun;
begin
  try
    if Assigned(FRunProc) then FRunProc(FParam);
    if Assigned(FEventProc) then FEventProc(Self);
    if Assigned(FObjectProc) then FObjectProc;
  except
  end;
end;

procedure TRunThread.Execute;
begin
  CoInitialize(nil);
  repeat
    if FSync then
      Synchronize(DoRun)
    else
      DoRun;
    if Idle > 0 then Sleep(Idle);
  until not Loop or Terminated;
  if Assigned(FOnFinished) then FOnFinished(Self);
  CoUninitialize;
end;

procedure TRunThread.SetOnFinished(const Value: TNotifyEvent);
begin
  FOnFinished := Value;
end;

{ TGlobalCriticalSection }

procedure TGlobalCriticalSection.Acquire;
begin
  inherited;
  WaitForSingleObject(Handle, TimeOut);
  ResetEvent;
end;

constructor TGlobalCriticalSection.Create(AName: string);
begin
  TimeOut := INFINITE;
  FName := AName;
  inherited Create(nil, True, True, Name);
end;

destructor TGlobalCriticalSection.Destroy;
begin
  Unlock;
  inherited;
end;

procedure TGlobalCriticalSection.Enter;
begin
  Acquire;
end;

procedure TGlobalCriticalSection.Leave;
begin
  Release;
end;

procedure TGlobalCriticalSection.Lock;
begin
  Acquire;
end;

procedure TGlobalCriticalSection.Release;
begin
  inherited;
  SetEvent;
end;

procedure TGlobalCriticalSection.SetTimeOut(const Value: DWORD);
begin
  FTimeOut := Value;
end;

procedure TGlobalCriticalSection.Unlock;
begin
  Release;
end;

{ TRegistryEx }

function TRegistryEx.ReadMultiString(const Name: string): string;
var
  L: integer;
begin
  L := GetDataSize(Name);
  SetLength(Result, L);
  RegQueryValueEx(CurrentKey, pchar(Name), nil, nil, PByte(Result), @L);
end;

procedure TRegistryEx.WriteMultiString(const Name, Value: string);
const
  REG_MULTI_SZ = 7;
begin
  RegSetValueEx(CurrentKey, pchar(Name), 0, REG_MULTI_SZ, pchar(Value), Length(Value));
end;

function TRegistryEx.ReadWideString(const Name: string): WideString;
var
  L: integer;
begin
  L := GetDataSize(Name);
  SetLength(Result, L div 2);
  if L > 0 then ReadBinaryData(Name, Result[1], L);
end;

procedure TRegistryEx.WriteWideString(const Name: string; Value: WideString);
var
  L: integer;
begin
  L := Length(value);
  if L > 0 then WriteBinaryData(Name, Value[1], L * 2);
end;

procedure TRegistryEx.CancelSearch;
begin
  fCancelSearch := True;
end;

procedure TRegistryEx.ClearSearchStack;
var
  i: Integer;
begin
  if Assigned(fSearchStack) then
  begin
    for i := 0 to fSearchStack.Count - 1 do
      TSearchNode(fSearchStack[i]).Free;
    fSearchStack.Free;
    fSearchStack := nil
  end
end;

procedure TRegistryEx.CopyKeyFromReg(const keyName: string;
  otherReg: TRegistryEx; deleteSource: boolean);
var
  i: Integer;
  values: TStringList;
  sourceReg: TRegistryEx;
  destReg: TRegistryEx;
begin
  sourceReg := TRegistryEx.Create;
  destReg := TRegistryEx.Create;
  values := TStringList.Create;
  try
    sourceReg.RootKey := otherReg.CurrentKey;
    if deleteSource then
      sourceReg.OpenKey(keyName, False)
    else
      sourceReg.OpenKeyReadOnly(keyName);
    sourceReg.GetValueNames(values);

    destReg.RootKey := CurrentKey;
    if destReg.OpenKey(keyName, True) then
    begin
      for i := 0 to values.Count - 1 do
        destReg.CopyValueFromReg(values[i], sourceReg, deleteSource);

      sourceReg.GetKeyNames(values);
      for i := 0 to values.Count - 1 do
        destReg.CopyKeyFromReg(values[i], sourceReg, deleteSource);

      if DeleteSource then
        if not otherReg.DeleteKey(keyName) then
          raise ERegistryException.Create('Unable to delete moved key')
    end
    else
      raise ERegistryException.Create('Unable to open destination');
  finally
    values.Free;
    destReg.Free;
    sourceReg.Free
  end
end;

procedure TRegistryEx.CopyValueFromReg(const valueName: string;
  otherReg: TRegistryEx; deleteSource: boolean);
var
  buffer: PByte;
  BufSize: DWORD;
  DataType: DWORD;
begin
  BufSize := 65536;
  GetMem(buffer, BufSize);
  try
    DataType := REG_NONE;

    SetLastError(RegQueryValueEx(otherReg.CurrentKey, PChar(valueName), nil, @DataType, Buffer,
      @BufSize));

    if GetLastError <> ERROR_SUCCESS then
      raise ERegistryExException.CreateLastError('Unable to copy value');

    SetLastError(RegSetValueEx(CurrentKey, PChar(valueName), 0, DataType, buffer, BufSize));
    if GetLastError <> ERROR_SUCCESS then
      raise ERegistryExException.CreateLastError('Unable to copy value');

    if deleteSource then
      if not otherReg.DeleteValue(valueName) then
        raise ERegistryException.Create('Unable to delete moved value')
  finally
    FreeMem(buffer)
  end
end;

destructor TRegistryEx.Destroy;
begin
  ClearSearchStack;
  inherited Destroy;
end;

function TRegistryEx.EndExport: string;
begin
  if Assigned(fExportStrings) then
  begin
    result := fExportStrings.Text;
    freeandNil(fExportStrings)
  end
  else
    result := '';
end;

procedure TRegistryEx.ExportKey(const fileName: string);
begin
  fExportStrings := TStringList.Create;
  fExportStrings.Add('REGEDIT4');
  try
    fLastExportKey := '';
    Walk(ExportProc, True);
    fExportStrings.Add('');
  finally
    fExportStrings.SaveToFile(fileName);
    fExportStrings.Free;
  end
end;

procedure TRegistryEx.ExportProc(const keyName, valueName: string;
  dataType: DWORD; data: pointer; DataLen: Integer);

  function MakeCStringConst(const s: string; Len : Integer = -1): string;
  var
    i: Integer;
  begin
    result := '';
    if len = -1 then
      len := Length(s);
    for i := 1 to len do
    begin
      if s[i] in ['\', '"'] then
        result := result + '\';
      result := result + s[i]
    end;
    result := PChar(result)
  end;
  
var
  st: string;
  st1: string;
  j: Integer;
  localRoot: HKey;

begin
  localRoot := fLocalRoot;
  if localRoot = 0 then
    localRoot := RootKey;

  if fLastExportKey <> keyName then
  begin
    fExportStrings.Add('');
    fExportStrings.Add(Format('[%s\%s]', [HKEYToStr(localRoot), keyName]));

    fLastExportKey := keyName;
  end;

  if dataLen <> 0 then
  begin
    if valueName = '' then
      st := '@='
    else
      st := Format('"%s"=', [MakeCStringConst(valueName)]);

    case dataType of
      REG_DWORD:
        begin
          st1 := LowerCase(Format('%8.8x', [PDWORD(data)^]));
          st := st + format('dword:%s', [st1])
        end;

      REG_SZ:
        st := st + format('"%s"', [MakeCStringConst(PChar(data), dataLen - 1)]);

    else
      begin
        if dataType = REG_BINARY then
          st := st + 'hex:'
        else
          st := st + format('hex(%d):', [dataType]);
        for j := 0 to dataLen - 1 do
        begin
          st1 := LowerCase(format('%02.2x', [Byte(PChar(data)[j])]));
          if j < dataLen - 1 then
            st1 := st1 + ',';

          if Length(st) + Length(st1) >= 77 then
          begin
            fExportStrings.Add(st + st1 + '\');
            st := '  ';
          end
          else
            st := st + st1;
        end
      end
    end;
    fExportStrings.Add(st);
  end
end;

procedure TRegistryEx.ExportToStream(strm: TStream; ExcludeKeys: TStrings);
begin
  fExportExcludeKeys := ExcludeKeys;
  fExportStrings := TStringList.Create;
  fExportStrings.Add('REGEDIT4');
  try
    fLastExportKey := '';
    Walk(ExportProc, True);
    fExportStrings.Add('');
  finally
    fExportStrings.SaveToStream(strm);
    fExportStrings.Free;
    fExportExcludeKeys := nil;
  end;
end;

function TRegistryEx.FindFirst(const data: string; params: TSearchParams;
  MatchWholeString: boolean; var retPath, retValue: string): boolean;
var
  path, nPath, keyName: string;
  p: Integer;
  n: TSearchNode;
begin
  ClearSearchStack;

  fSearchStack := TList.Create;
  path := currentPath;

  nPath := '';
  repeat
    p := Pos('\', path);
    if p > 0 then
    begin
      nPath := nPath + '\' + Copy(path, 1, p - 1);
      path := Copy(path, p + 1, MaxInt);
      n := TSearchNode.Create(RootKey, nPath);
      n.LoadKeyNames;
      p := Pos('\', path);
      if p > 0 then
        keyName := Copy(path, 1, p - 1)
      else
        keyName := path;

      n.fKeyIDX := n.fKeyNames.IndexOf(keyName);

      fSearchStack.Add(n);
    end
  until p = 0;

  n := TSearchNode.Create(RootKey, nPath + '\' + path);
  fSearchStack.Add(n);

  fSearchString := UpperCase(data);
  fSearchParams := params;
  fMatchWholeString := MatchWholeString;
  result := FindNext(retPath, retValue);
end;

function TRegistryEx.FindNext(var retPath, retValue: string): boolean;
var
  n: TSearchNode;
  found: boolean;
  k: string;
  msg: TMsg;
begin
  found := False;
  fCancelSearch := False;
  while (not found) and (not fCancelSearch) and (fSearchStack.Count > 0) do
  begin
    while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do
    begin
      TranslateMessage(msg);
      DispatchMessage(msg)
    end;

    n := TSearchNode(fSearchStack[fSearchStack.Count - 1]);
    if rsValues in fSearchParams then
    begin
      n.LoadValueNames;
      with n do
        if fValueIdx < fValueNames.Count then
          repeat
            Inc(fValueIdx);
            if fValueIdx < fValueNames.Count then
            begin
              if fMatchWholeString then
                found := fSearchString = fValueNames[fValueIdx]
              else
                found := Pos(fSearchString, fValueNames[fValueIdx]) > 0
            end
          until fCancelSearch or found or (fValueIdx = fValueNames.Count)
    end;

    if not fCancelSearch and not found then
    begin
      n.LoadKeyNames;
      with n do
        if fKeyIdx < fKeyNames.Count then
        begin
          Inc(fKeyIdx);
          if fKeyIdx < fKeyNames.Count then
          begin

            if rsKeys in fSearchParams then
              if fMatchWholeString then
                found := fSearchString = fKeyNames[fKeyIdx]
              else
                found := Pos(fSearchString, fKeyNames[fKeyIdx]) > 0;

            if not found then
            begin
              if n.fPath = '\' then
                k := '\' + fKeyNames[fKeyIdx]
              else
                k := n.fPath + '\' + fKeyNames[fKeyIdx];

              fSearchStack.Add(TSearchNode.Create(RootKey, k));

              continue
            end
          end
        end
    end;

    if fCancelSearch then
      Break;

    if not found then
    begin
      n.Free;
      fSearchStack.Delete(fSearchStack.Count - 1)
    end
    else
    begin
      retPath := n.fPath;
      if n.fKeyIdx > -1 then
        retPath := retPath + '\' + n.fKeyNames[n.fKeyIdx];

      if rsValues in fSearchParams then
        if (n.fValueIdx > -1) and (n.fValueIdx < n.fValueNames.Count) then
          retValue := n.fValueNames[n.fValueIdx]
        else
          retValue := '';
    end
  end;
  result := found
end;

procedure TRegistryEx.GetValuesSize(var size: Integer);
begin
  fValuesSize := 0;
  Walk(ValuesSizeProc, False);
  if fValuesSize = 0 then
    fValuesSize := -1;
  size := fValuesSize
end;

function TRegistryEx.GetValueType(const valueName: string): DWORD;
var
  valueType: DWORD;
begin
  SetLastError(RegQueryValueEx(CurrentKey, PChar(valueName), nil, @valueType, nil, nil));
  if GetLastError = ERROR_SUCCESS then
    result := valueType
  else
    raise ERegistryExException.CreateLastError('Unable to get value type');
end;

procedure TRegistryEx.ImportFromStream(stream: TStream);
var
  strings: TStrings;
  st: string;
  i: Integer;

  procedure SyntaxError;
  begin
    raise Exception.CreateFmt('Syntax error in reg stream at line %d', [i])
  end;

  procedure CreateNewKey;
  var
    s: string;
    p: Integer;
    r: HKEY;
  begin
    Delete(st, 1, 1);
    if st[Length(st)] <> ']' then
      SyntaxError;

    Delete(st, Length(st), 1);

    p := pos('\', st);
    if p = 0 then
      SyntaxError;
    s := Copy(st, 1, p - 1);
    st := Copy(st, p + 1, MaxInt);

    if st = '' then
      SyntaxError;

    r := StrToHKEY(s);
    if r = $FFFFFFFF then
      SyntaxError;

    SetRoot(r, fSaveServer);
    OpenKey('\' + st, True)
  end;

  function GetCString(st: string; var n: Integer): string;
  var
    i: Integer;
    eos: boolean;
  begin
    result := '';
    i := 2;
    repeat
      eos := False;
      while i <= Length(st) do
      begin
        if st[i] = '"' then
        begin
          eos := True;
          break
        end;

        if st[i] = '\' then
          Inc(i);

        if i <= Length(st) then
          result := result + st[i];

        Inc(i)
      end;

      if not eos then
      begin
        result := result + #13#10;
        Inc(n);
        st := strings[n];
        i := 1
      end
    until eos
  end;

  function GetBinaryBuffer(const st: string): string;
  var
    i: Integer;
    val: string;
  begin
    i := 1;
    result := '';
    while i <= Length(st) do
    begin
      if st[i] in ['0'..'9', 'a'..'f', 'A'..'F'] then
        val := val + st[i]
      else
      begin
        if val <> '' then
        begin
          result := result + chr(StrToInt('$' + val));
          val := ''
        end
      end;

      Inc(i)
    end
  end;

  procedure CreateNewValue(var i: Integer);
  var
    s: string;
    fn: string;
    p: Integer;
    tp: Integer;
    buf: string;
  begin
    if st[1] = '"' then
    begin
      Delete(st, 1, 1);
      p := Pos('"', st);
      if p = 0 then
        SyntaxError;

      s := Copy(st, 1, p - 1);
      st := Copy(st, p + 1, MaxInt)
    end
    else
    begin
      Delete(st, 1, 1);
      s := ''
    end;

    st := TrimLeft(st);

    if st = '' then
      SyntaxError;

    if st[1] <> '=' then
      SyntaxError;

    Delete(st, 1, 1);

    st := TrimLeft(st);

    if st[1] = '"' then
      WriteString(s, GetCString(st, i))
    else
    begin
      p := 1;
      while (p <= Length(st)) and not (st[p] in [':', '(', ' ']) do
        Inc(p);

      fn := Copy(st, 1, p - 1);

      st := TrimLeft(Copy(st, p, MaxInt));

      if CompareText(fn, 'hex') = 0 then
      begin
        tp := 3;
        if st[1] = '(' then
        begin
          Delete(st, 1, 1);
          fn := '';
          p := 1;
          while (p <= Length(st)) and (st[p] <> ')') do
          begin
            fn := fn + st[p];
            Inc(p)
          end;

          tp := StrToInt(fn);
          st := Trim(Copy(st, p + 1, MaxInt));
        end;

        if st[1] <> ':' then
          SyntaxError;

        Delete(st, 1, 1);

        buf := GetBinaryBuffer(st);

        WriteTypedBinaryData(s, tp, PChar(buf)^, Length(buf));
      end
      else if CompareText(fn, 'dword') = 0 then
      begin
        if st[1] <> ':' then
          SyntaxError;

        Delete(st, 1, 1);
        WriteInteger(s, StrToInt('$' + TrimLeft(st)))
      end
      else
        SyntaxError
    end
  end;

begin
  strings := TStringList.Create;
  try
    strings.LoadFromStream(stream);

    while (strings.Count > 0) do
    begin
      st := Trim(strings[0]);
      if (st = '') or (st[1] = ';') then
        strings.Delete(0)
      else
        break
    end;

    if strings[0] <> 'REGEDIT4' then
      raise Exception.Create('Bad file format.  Missing REGEDIT4 in first line.');

    i := 1;
    while i < strings.Count do
    begin
      st := Trim(strings[i]);

      if st <> '' then
        while st[Length(st)] = '\' do
        begin
          Inc(i);
          Delete(st, Length(st), 1);
          if i < strings.Count then
            st := st + strings[i]
          else
            break
        end;

      if (Length(st) > 0) and (st[1] <> ';') then
      begin
        case st[1] of
          '[': CreateNewKey;
          '"': CreateNewValue(i);
          '@': CreateNewValue(i);
        else
          SyntaxError
        end
      end;

      Inc(i)
    end
  finally
    strings.Free
  end
end;

procedure TRegistryEx.ImportRegFile(const fileName: string);
var
  f: TFileStream;
begin
  f := TFileStream.Create(fileName, fmOpenRead or fmShareDenyNone);
  try
    ImportFromStream(f)
  finally
    f.Free
  end
end;

procedure TRegistryEx.ReadStrings(const valueName: string;
  strings: TStrings);
var
  valueType: DWORD;
  valueLen: DWORD;
  p, buffer: PChar;
begin
  strings.Clear;
  SetLastError(RegQueryValueEx(CurrentKey, PChar(valueName), nil, @valueType, nil, @valueLen));
  if GetLastError = ERROR_SUCCESS then
    if valueType = REG_MULTI_SZ then
    begin
      GetMem(buffer, valueLen);
      try
        RegQueryValueEx(CurrentKey, PChar(valueName), nil, nil, PBYTE(buffer), @valueLen);
        p := buffer;
        while p^ <> #0 do
        begin
          strings.Add(p);
          Inc(p, lstrlen(p) + 1)
        end
      finally
        FreeMem(buffer)
      end
    end
    else
      raise ERegistryException.Create('String list expected')
  else
    raise ERegistryExException.CreateLastError('Unable read MULTI_SZ value')
end;

procedure TRegistryEx.SetRoot(root: HKey; const server: string);
begin
  fSaveServer := server;
  RootKey := root;
  fLocalRoot := root;
  if server <> '' then
    if not RegistryConnect('\\' + server) then
      raise Exception.CreateFmt(SUnableToConnect, [server, GetLastError])
end;

procedure TRegistryEx.StartExport;
begin
  fLastExportKey := '';
  fExportStrings := TStringList.Create
end;

procedure TRegistryEx.ValuesSizeProc(const keyName, valueName: string;
  dataType: DWORD; data: pointer; DataLen: Integer);
begin
  Inc(fValuesSize, DataLen);
end;

procedure TRegistryEx.Walk(walkProc: TWalkProc; valuesRequired: boolean);
var
  defaultValue: array[0..256] of char;
  defaultValueLen: DWORD;

  valueName: array[0..256] of char;
  valueNameLen: DWORD;

  keyName: array[0..256] of char;

  cValues: DWORD;
  tp: DWORD;

  buffer: PChar;
  bufSize: DWORD;

  valueLen, maxValueLen: DWORD;
  keyLen: DWORD;
  level: DWORD;

  procedure DoWalk(const pathName: string);
  var
    k: HKEY;
    err: Integer;
    i: Integer;
    cSubKeys: DWORD;
  begin
    err := RegOpenKeyEx(RootKey, PChar(pathName), 0, KEY_READ, k);
    if err = ERROR_SUCCESS then
    try
      Inc(level);
      defaultValueLen := sizeof(defaultValue);

      err := RegQueryInfoKey(k, defaultValue, @defaultValueLen, nil, @cSubkeys, nil, nil, @cValues, nil, @maxValueLen, nil, nil);
      if (err <> ERROR_SUCCESS) and (err <> ERROR_ACCESS_DENIED) then
        raise ERegistryExException.Create(err, 'Unable to query key info');

      if err = ERROR_SUCCESS then
      begin
        if cValues > 0 then
        begin
          if maxValueLen > bufSize then
          begin
            bufSize := 65536 * ((maxValueLen + 65536) div 65536);
            ReallocMem(buffer, bufSize)
          end;

          for i := 0 to cValues - 1 do
          begin
            valueNameLen := sizeof(valueName);
            valueLen := maxValueLen;
            if valuesRequired then
              err := RegEnumValue(k, i, valueName, valueNameLen, nil, @tp, PByte(buffer), @valueLen)
            else
              err := RegEnumValue(k, i, valueName, valueNameLen, nil, @tp, nil, @valueLen);
            if err <> ERROR_SUCCESS then
              raise ERegistryExException.Create(err, 'Unable to get value info');

            walkProc(pathName, valueName, tp, buffer, valueLen);
          end
        end
        else
          walkProc(pathName, '', 0, nil, 0);

        for i := 0 to cSubkeys - 1 do
        begin
          keyLen := sizeof(keyName);
          RegEnumKey(k, i, keyName, keyLen);

          if not ((level = 1) and Assigned(fExportExcludeKeys) and (fExportExcludeKeys.IndexOf(keyName) >= 0)) then
            if pathName = '' then
              DoWalk(keyName)
            else
              DoWalk(pathName + '\' + keyName)
        end
      end
    finally
      RegCloseKey(k);
      Dec(level);
    end
  end;

begin
  bufSize := 65536;
  level := 0;
  GetMem(buffer, bufSize);

  try
    if Assigned(walkProc) then
      DoWalk(CurrentPath);
  finally
    FreeMem(buffer)
  end
end;

procedure TRegistryEx.WriteStrings(const valueName: string;
  strings: TStrings);
var
  p, buffer: PChar;
  i: Integer;
  size: DWORD;
begin
  size := 0;
  for i := 0 to strings.Count - 1 do
    Inc(size, Length(strings[i]) + 1);
  Inc(size);
  GetMem(buffer, size);
  try
    p := buffer;
    for i := 0 to strings.count - 1 do
    begin
      lstrcpy(p, PChar(strings[i]));
      Inc(p, lstrlen(p) + 1)
    end;
    p^ := #0;
    SetLastError(RegSetValueEx(CurrentKey, PChar(valueName), 0, REG_MULTI_SZ, buffer, size));
    if GetLastError <> ERROR_SUCCESS then
      raise ERegistryExException.CreateLastError('Unable to write MULTI_SZ value');
  finally
    FreeMem(buffer)
  end
end;

procedure TRegistryEx.WriteTypedBinaryData(const valueName: string;
  tp: Integer; var data; size: Integer);
begin
  if RegSetValueEx(CurrentKey, PChar(valueName), 0, tp, @data, size) <> ERROR_SUCCESS then
    raise ERegistryException.CreateFmt('Unable to set registry data for %s', [valueName]);
end;

{ TThreadStringList }

function TThreadStringList.Add(const S: string): integer;
begin
  Lock;
  try
    Result := inherited Add(S);
  finally
    Unlock;
  end;
end;

function TThreadStringList.AddObject(const S: string;
  AObject: TObject): Integer;
begin
  Lock;
  try
    Result := inherited AddObject(S, AObject);
  finally
    Unlock;
  end;
end;

procedure TThreadStringList.Clear;
begin
  Lock;
  try
    inherited Clear;
  finally
    Unlock;
  end;
end;

constructor TThreadStringList.Create;
begin
  FCritSect := TCriticalSection.Create;
end;

procedure TThreadStringList.CustomSort(Compare: TStringListSortCompare);
begin
  Lock;
  try
    inherited CustomSort(Compare);
  finally
    Unlock;
  end;
end;

procedure TThreadStringList.Delete(Index: Integer);
begin
  Lock;
  try
    inherited Delete(Index);
  finally
    Unlock;
  end;
end;

destructor TThreadStringList.Destroy;
begin
  FCritSect.Free;
  inherited;
end;

procedure TThreadStringList.Exchange(Index1, Index2: Integer);
begin
  Lock;
  try
    inherited Exchange(Index1, Index2);
  finally
    Unlock;
  end;
end;

function TThreadStringList.Find(const S: string;
  var Index: Integer): Boolean;
begin
  Lock;
  try
    Result := inherited Find(S, Index);
  finally
    Unlock;
  end;
end;

function TThreadStringList.IndexOf(const S: string): Integer;
begin
  Lock;
  try
    Result := inherited IndexOf(S);
  finally
    Unlock;
  end;
end;

procedure TThreadStringList.Insert(Index: Integer; const S: string);
begin
  Lock;
  try
    inherited Insert(Index, S);
  finally
    Unlock;
  end;
end;

procedure TThreadStringList.InsertObject(Index: Integer; const S: string;
  AObject: TObject);
begin
  Lock;
  try
    inherited InsertObject(Index, S, AObject);
  finally
    Unlock;
  end;
end;

procedure TThreadStringList.Lock;
begin
  FCritSect.Enter;
end;

procedure TThreadStringList.Sort;
begin
  Lock;
  try
    inherited Sort;
  finally
    Unlock;
  end;
end;

procedure TThreadStringList.Unlock;
begin
  FCritSect.Leave;
end;

{ TBitsEx }

constructor TBitsEx.Create(Data: PChar; Len: integer);
begin
  SetLength(FDatas, Len);
  Move(Data^, FDatas[0], Len);
end;

function TBitsEx.Eof: Boolean;
begin
  Result := FPosition = Count;
end;

function TBitsEx.Fetch(NumOfBits: Byte): integer;
var
  i: integer;
begin
  Result := 0;
  if NumOfBits in [1..32] then
  begin
    for i := 1 to NumOfBits do
    begin
      Result := (Result shl 1) or Bits[FPosition];
      if Eof then Break;
      Inc(FPosition, NumOfBits);
    end;
  end
  else
  begin
    raise Exception.CreateFmt('Out of band[1..32]: %d', [NumOfBits]);
  end;
end;

function TBitsEx.GetBits(Index: integer): integer;
begin
  Result := (FDatas[Index div 8] shr (Index mod 8)) and 1;
end;

function TBitsEx.GetCount: integer;
begin
  Result := Length(FDatas) * 8;
end;

procedure TBitsEx.SetBits(Index: integer; const Value: integer);
var
  PB: PByte;
begin
  if Value in [0, 1] then
  begin
    PB := @FDatas[Index div 8];
    PB^ := PB^ xor (Value shl (Index mod 8));
  end;
end;

{ TMRUManager }

procedure TMRUManager.Add(const ItemText: string; const Tag: Integer = 0; Caption: string = '');
var
  Itm: TMRUMenuItem;
begin
  if not Assigned(FMenuItem) or (IndexOf(ItemText) <> -1) then Exit;
  if (FItemCount = 0) and (FAddSeparator) then InsertSeparator;

  if FItemCount >= FMaxHistory then { 删除最老（下面）的一个项目 }
  begin /// 释放老的菜单
    FMenuItem[FFirstIndex + FItemCount - 1].Free;
  end
  else
    Inc(FItemCount);

  /// 生成新的菜单项目
  /// 保存原始数据，如果直接使用菜单Caption，由于Delphi的菜单会自动设置快捷键，
  /// 从而导致以后取用不正常，并且不能分别设置Caption和数据
  Itm := TMRUMenuItem.Create(FMenuItem);
  Itm.Text := ItemText;
  Itm.Tag := Tag;
  Itm.OnClick := OnItemClick;
  Itm.FCaption := Caption;
  if Caption = '' then
  begin
    Itm.Hint := ItemText;
    Itm.Caption := PackFileName(ItemText);
  end
  else
  begin
    Itm.Caption := Caption;
    Itm.Hint := Caption;
  end;
  FMenuItem.Insert(FFirstIndex, Itm);

  RebuildCaption;
end;

constructor TMRUManager.Create(AOwner: TComponent);
begin
  inherited;
  FItemCount := 0;
  FMaxHistory := 5;
end;

procedure TMRUManager.InsertSeparator;
var
  Sep: TMenuItem;
begin
  Sep := TMenuItem.Create(FMenuItem);
  Sep.Caption := '-';
  FMenuItem.Insert(FFirstIndex, Sep);
  Inc(FFirstIndex);
end;

procedure TMRUManager.OnItemClick(Sender: TObject);
begin
  /// 改变位置，点击的提高到最上面
  FMenuItem.Remove(Sender as TMenuItem);
  FMenuItem.Insert(FFirstIndex, Sender as TMenuItem);
  RebuildCaption;

  /// 调用Click事件
  if Assigned(FOnClick) then
    FOnClick(Sender, (Sender as TMRUMenuItem).Text);
end;

procedure TMRUManager.Load;
var
  C: integer;
begin
  if BaseKey <> '' then
    with TRegistry.Create do
    try
      RootKey := FRootKey;
      if OpenKey(BaseKey, False) then
      begin
        if ValueExists('') then
          C := ReadInteger('')
        else
          C := 0;
        for C := 0 to C - 1 do
        begin
          if C >= MaxHistory then Break;
          if ValueExists(IntToStr(C)) then
          begin
            Add(ReadString(IntToStr(C)),
              ReadInteger('T' + IntToStr(C)));
          end;
          //Dec(C);
        end;
      end;
    finally
      Free;
    end;
end;

procedure TMRUManager.Save;
var
  i: integer;
begin
  if BaseKey = '' then Exit;

  with TRegistry.Create do
  try
    RootKey := FRootKey;
    if OpenKey(BaseKey, True) then
    begin
      WriteInteger('', Count);
      for i := 0 to Count - 1 do
      begin
        WriteString(IntToStr(i), Items[i].Text);
        WriteInteger('T' + IntToStr(i), Items[i].Tag);
      end;
    end;
  finally
    Free;
  end;
end;

procedure TMRUManager.SetAddSeparator(Value: boolean);
begin
  if Value <> FAddSeparator then
  begin
    FAddSeparator := Value;
    if Assigned(FMenuItem) and (FItemCount > 0) then
    begin
      if FAddSeparator then
      begin
        InsertSeparator;
      end
      else
      begin
        Dec(FFirstIndex);
        FMenuItem.Delete(FFirstIndex);
      end;
    end;
  end;
end;

procedure TMRUManager.SetMaxHistory(Value: integer);
begin
  if (Value >= 0) and (Value <> FMaxHistory) then
  begin
    FMaxHistory := Value;
  end;
end;

procedure TMRUManager.SetMenuItem(Value: TMenuItem);
begin
  if Assigned(FMenuItem) then
    while FItemCount > 0 do
    begin
      FMenuItem[FFirstIndex + FItemCount - 1].Free;
      Dec(FItemCount);
    end;
  FMenuItem := Value;
  if FMenuItem.Count > 2 then
    FFirstIndex := FMenuItem.Count - 2
  else
    FFirstIndex := FMenuItem.Count;
end;

constructor TMRUManager.Create(AOwner: TComponent;
  AMenuItem: TMenuItem;
  AOnClick: TMRUItemClick;
  ASubKey: string;
  const ARootKey: HKEY = HKEY_CURRENT_USER; const AMax: integer = 5;
  const ASeperator: Boolean = True);
begin
  Create(AOwner);
  MenuItem := AMenuItem;
  RootKey := ARootKey;
  BaseKey := ASubKey;
  MaxHistory := AMax;
  OnClick := AOnClick;
  AddSeparator := ASeperator;
  Load;
end;

destructor TMRUManager.Destroy;
begin
  Save;
  inherited;
end;

function TMRUManager.IndexOf(const ItemText: string): Integer;
begin
  for Result := 0 to FItemCount - 1 do
    if SameText(TMRUMenuItem(FMenuItem[FFirstIndex + Result]).Text, ItemText) then
      Exit;
  Result := -1;
end;

function TMRUManager.GetItems(Index: Integer): TMRUMenuItem;
begin
  Result := TMRUMenuItem(FMenuItem[FFirstIndex + Index]);
end;

procedure TMRUManager.Clear;
var
  RegOpen: Boolean;
begin
  if Count = 0 then Exit;
  with TRegistry.Create do
  try
    RootKey := FRootKey;
    RegOpen := OpenKey(FBaseKey, False);
    while FItemCount > 0 do
    begin
      if RegOpen then /// 如果注册表中存在对应项目，则删除注册表中对应数据
      begin
        DeleteValue(IntToStr(FItemCount - 1));
        DeleteValue('T' + IntToStr(FItemCount - 1));
      end;
      FMenuItem[FFirstIndex + FItemCount - 1].Free;
      Dec(FItemCount);
    end;
    if FAddSeparator then
    begin
      Dec(FFirstIndex);
      FMenuItem[FFirstIndex].Free;
    end;
  finally
    Free;
  end;
end;

procedure TMRUManager.Delete(Index: Integer);
begin
  if Count = 0 then raise Exception.Create('List is empty');
  if (Index > Count - 1) or (Index < 0) then
    raise EListError.CreateFmt(SErrOutBounds, [Index, Count - 1]);

  with TRegistry.Create do
  try
    RootKey := FRootKey;
    if OpenKey(FBaseKey, False) then
    begin
      DeleteValue(IntToStr(Index));
      DeleteValue('T' + IntToStr(Index));
      Items[Index].Free;
      Dec(FItemCount);
    end;
  finally
    Free;
  end;
  if (Count = 0) and FAddSeparator then
  begin
    Dec(FFirstIndex);
    FMenuItem[FFirstIndex].Free;
  end;

  RebuildCaption;
end;

{ TFileMapping_San }

constructor TFileMappingStream.Create(AHandle: DWORD; AName: string;
  ASize: Cardinal);
begin
  Create(ahandle, aname, asize, PAGE_READWRITE);
end;

constructor TFileMappingStream.Create(AHandle: DWORD; AName: string;
  ASize: Cardinal; ProtectMode: DWORD);
var
  i: DWORD;
begin
  fresizeable := asize = 0;
  fmaphandle := createfilemapping(ahandle, nil, protectmode, 0, asize, PChar(aname));
  if fmaphandle = 0 then
  begin
    i := GetLastError;
    case i of
      ERROR_DISK_FULL:
        begin
          raise Exception.Create(Format(c_emdiskfull, [fname]));
        end;
      ERROR_INVALID_HANDLE:
        begin
          raise Exception.Create(Format(c_emsamename, [fname]));
        end;
      0: ;
    else

      begin
        raise Exception.Create(Format(c_emprotect, [protectmode, aname]));
      end;
    end;
  end
  else
  begin
    fname := nil;
    ffilehandle := ahandle;
    fprotectmode := protectmode;
    fsize := asize;
    fexists := GetLastError = ERROR_ALREADY_EXISTS;
    i := $FFFFFFFF;
    if protectmode and PAGE_READONLY = PAGE_READONLY then
      i := i and FILE_MAP_READ;
    if protectmode and PAGE_READWRITE = PAGE_READWRITE then
      i := i and FILE_MAP_ALL_ACCESS;
    if protectmode and PAGE_WRITECOPY = PAGE_WRITECOPY then
      i := i and FILE_MAP_COPY;

    fpointer := mapviewoffile(fmaphandle, i, 0, 0, 0);
  end;
end;

constructor TFileMappingStream.Create(AHandle: DWORD; ASize: Cardinal;
  ProtectMode: DWORD);
var
  i: DWORD;
begin
  fresizeable := asize = 0;
  fmaphandle := createfilemapping(ahandle, nil, protectmode, 0, asize, nil);
  if fmaphandle = 0 then
  begin
    i := GetLastError;
    case i of
      ERROR_DISK_FULL:
        begin
          raise Exception.Create(Format(c_emdiskfull, [asize, '']));
        end;
      ERROR_INVALID_HANDLE:
        begin
          raise Exception.Create(Format(c_emsamename, [fname]));
        end;
      0: ;
    else
      begin
        raise Exception.Create(Format(c_emprotect, [protectmode, '']));
      end;
    end;
  end
  else
  begin
    fname := nil;
    ffilehandle := ahandle;
    fprotectmode := protectmode;
    fsize := asize;
    fexists := GetLastError = ERROR_ALREADY_EXISTS;
    i := $FFFFFFFF;
    if protectmode and PAGE_READONLY = PAGE_READONLY then
      i := i and FILE_MAP_READ;
    if protectmode and PAGE_READWRITE = PAGE_READWRITE then
      i := i and FILE_MAP_ALL_ACCESS;
    if protectmode and PAGE_WRITECOPY = PAGE_WRITECOPY then
      i := i and FILE_MAP_COPY;

    fpointer := mapviewoffile(fmaphandle, i, 0, 0, 0);
  end;
end;

function TFileMappingStream.AlreadyExists: Boolean;
begin
  Result := fexists;
end;

constructor TFileMappingStream.Create(AHandle: DWORD; ASize: Cardinal);
begin
  Create(ahandle, asize, PAGE_READWRITE);
end;

destructor TFileMappingStream.Destroy;
begin
  unmapviewoffile(fpointer);
  closehandle(fmaphandle);
  inherited;
end;

function TFileMappingStream.Seek(Offset: Integer;
  Origin: Word): Longint;
begin
  case origin of
    0:
      begin
        Result := offset;
      end;
    1:
      begin
        Result := fposition + offset;
      end;
  else
    begin
      Result := fsize + offset;
    end;
  end;
  if Result < 0 then
    Result := 0
  else if Result > fsize then
  begin
    Result := fsize;
  end;
  fposition := Result;
end;

function TFileMappingStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  Result := seek(Integer(offset), Ord(origin));
end;

function TFileMappingStream.Read(var Buffer; Count: Integer): Longint;
var
  p: Pointer;
begin
  p := Pointer(Cardinal(fpointer) + fposition);
  if (not fresizeable) and (Count > Size - fposition) then
    Count := Size - fposition;

  copymemory(@buffer, p, Count);
  Result := Count;
  Inc(fposition, Count);
end;

function TFileMappingStream.Write(const Buffer;
  Count: Integer): Longint;
var
  p: Pointer;
begin
  p := Pointer(Cardinal(fpointer) + fposition);
  if (not fresizeable) and (Count > Size - fposition) then
    Count := Size - fposition;

  copymemory(p, @buffer, Count);

  Result := Count;
  Inc(fposition, Count);
  if fresizeable then
    Inc(fsize, Count);
end;

constructor TFileMappingStream.CreateFromMemory(ASize: Cardinal);
begin
  createfrommemory(asize, PAGE_READWRITE);
end;

constructor TFileMappingStream.CreateFromMemory(AName: string;
  ASize: Cardinal);
begin
  createfrommemory(aname, asize, PAGE_READWRITE);
end;

constructor TFileMappingStream.CreateFromMemory(ASize: Cardinal;
  ProtectMode: Integer);
begin
  Create($FFFFFFFF, aSize, protectmode);
end;

constructor TFileMappingStream.CreateFromMemory(AName: string;
  ASize: Cardinal; ProtectMode: DWORD);
begin
  Create($FFFFFFFF, aName, asize, protectmode);
end;

function TFileMappingStream.DataPointer: Pointer;
begin
  Result := fpointer;
end;

function TFileMappingStream.getname: string;
begin
  Result := fname;
end;

constructor TFileMappingStream.Create;
begin
  Create(INVALID_HANDLE_VALUE, 0);
end;

procedure register;
begin
  RegisterComponents('Samples', [TMRUManager]);
end;

procedure TMRUManager.RebuildCaption;
var
  iCount: integer;
  s: string;
begin
  for iCount := 0 to Pred(Count) do
  begin
    s := Items[iCount].FCaption;
    if s = '' then s := Items[iCount].Text;
    if iCount < 9 then
      Items[iCount].Caption := Format('&%d. %s', [iCount + 1, s])
    else
      Items[iCount].Caption := '    ' + s;
  end;
end;

{ TVersionInfo }

type
  TVersionStringValue = class
    fValue: string;
    fLangID, fCodePage: Integer;

    constructor Create(const AValue: string; ALangID, ACodePage: Integer);
  end;

constructor TVersionInfo.Create(AModule: THandle);
var
  resHandle: THandle;
begin
  fModule := AModule;
  fChildStrings := TStringList.Create;
  fTranslations := TList.Create;
  resHandle := FindResource(fModule, pointer(1), RT_VERSION);
  if resHandle <> 0 then
  begin
    fVersionResHandle := LoadResource(fModule, resHandle);
    if fVersionResHandle <> 0 then
      fVersionInfo := LockResource(fVersionResHandle)
  end;

  if not Assigned(fVersionInfo) then
    raise Exception.Create('Unable to load version info resource');
end;

constructor TVersionInfo.Create(AVersionInfo: PChar);
begin
  fChildStrings := TStringList.Create;
  fTranslations := TList.Create;
  fVersionInfo := AVersionInfo;
end;

constructor TVersionInfo.Create(const AFileName: string);
var
  handle: THandle;
begin
  handle := LoadLibraryEx(PChar(AFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
  if handle <> 0 then
  begin
    Create(handle);
    fModuleLoaded := True
  end
  else
    raiseLastOSError;
end;

destructor TVersionInfo.Destroy;
var
  i: Integer;
begin
  for i := 0 to fChildStrings.Count - 1 do
    fChildStrings.Objects[i].Free;

  fChildStrings.Free;
  fTranslations.Free;
  if fVersionResHandle <> 0 then
    FreeResource(fVersionResHandle);
  if fModuleLoaded then
    FreeLibrary(fModule);
  inherited;
end;

function TVersionInfo.GetInfo: boolean;
var
  p: PChar;
  t, wLength, wValueLength, wType: word;
  key: string;

  varwLength, varwValueLength, varwType: word;
  varKey: string;

  function GetVersionHeader(var p: PChar; var wLength, wValueLength, wType: word; var key: string): Integer;
  var
    szKey: PWideChar;
    baseP: PChar;
  begin
    baseP := p;
    wLength := PWord(p)^;
    Inc(p, sizeof(word));
    wValueLength := PWord(p)^;
    Inc(p, sizeof(word));
    wType := PWord(p)^;
    Inc(p, sizeof(word));
    szKey := PWideChar(p);
    Inc(p, (lstrlenw(szKey) + 1) * sizeof(WideChar));
    while Integer(p) mod 4 <> 0 do
      Inc(p);
    result := p - baseP;
    key := szKey;
  end;

  procedure GetStringChildren(var base: PChar; len: word);
  var
    p, strBase: PChar;
    t, wLength, wValueLength, wType, wStrLength, wStrValueLength, wStrType: word;
    key, value: string;
    i, langID, codePage: Integer;

  begin
    p := base;
    while (p - base) < len do
    begin
      t := GetVersionHeader(p, wLength, wValueLength, wType, key);
      Dec(wLength, t);

      langID := StrToInt('$' + Copy(key, 1, 4));
      codePage := StrToInt('$' + Copy(key, 5, 4));

      strBase := p;
      for i := 0 to fChildStrings.Count - 1 do
        fChildStrings.Objects[i].Free;
      fChildStrings.Clear;

      while (p - strBase) < wLength do
      begin
        t := GetVersionHeader(p, wStrLength, wStrValueLength, wStrType, key);
        Dec(wStrLength, t);

        if wStrValueLength = 0 then
          value := ''
        else
          value := PWideChar(p);
        Inc(p, wStrLength);
        while Integer(p) mod 4 <> 0 do
          Inc(p);

        fChildStrings.AddObject(key, TVersionStringValue.Create(value, langID, codePage))
      end
    end;
    base := p
  end;

  procedure GetVarChildren(var base: PChar; len: word);
  var
    p, strBase: PChar;
    t, wLength, wValueLength, wType: word;
    key: string;
    v: DWORD;

  begin
    p := base;
    while (p - base) < len do
    begin
      t := GetVersionHeader(p, wLength, wValueLength, wType, key);
      Dec(wLength, t);

      strBase := p;
      fTranslations.Clear;

      while (p - strBase) < wLength do
      begin
        v := PDWORD(p)^;
        Inc(p, sizeof(DWORD));
        fTranslations.Add(pointer(v));
      end
    end;
    base := p
  end;

begin
  result := False;
  if not Assigned(fFixedInfo) then
  try
    p := fVersionInfo;
    GetVersionHeader(p, wLength, wValueLength, wType, key);

    if wValueLength <> 0 then
    begin
      fFixedInfo := PVSFixedFileInfo(p);
      if fFixedInfo^.dwSignature <> $FEEF04BD then
        raise Exception.Create('Invalid version resource');

      Inc(p, wValueLength);
      while Integer(p) mod 4 <> 0 do
        Inc(p);
    end
    else
      fFixedInfo := nil;

    while wLength > (p - fVersionInfo) do
    begin
      t := GetVersionHeader(p, varwLength, varwValueLength, varwType, varKey);
      Dec(varwLength, t);

      if varKey = 'StringFileInfo' then
        GetStringChildren(p, varwLength)
      else if varKey = 'VarFileInfo' then
        GetVarChildren(p, varwLength)
      else
        break;
    end;

    result := True;
  except
  end
  else
    result := True
end;

function TVersionInfo.GetKeyCount: Integer;
begin
  if GetInfo then
    result := fChildStrings.Count
  else
    result := 0;
end;

function TVersionInfo.GetKeyName(idx: Integer): string;
begin
  if idx >= Count then
    raise ERangeError.Create('Index out of range')
  else
    result := fChildStrings[idx];
end;

function TVersionInfo.GetKeyValue(const idx: string): string;
var
  i: Integer;
begin
  if GetInfo then
  begin
    i := fChildStrings.IndexOf(idx);
    if i <> -1 then
      result := TVersionStringValue(fChildStrings.Objects[i]).fValue
    else
      raise Exception.Create('Key not found')
  end
  else
    raise Exception.Create('Key not found')
end;

procedure TVersionInfo.SaveToStream(strm: TStream);
var
  zeros, v: DWORD;
  wSize: WORD;
  stringInfoStream: TMemoryStream;
  strg: TVersionStringValue;
  i, p, p1: Integer;
  wValue: WideString;

  procedure PadStream(strm: TStream);
  begin
    if strm.Position mod 4 <> 0 then
      strm.Write(zeros, 4 - (strm.Position mod 4))
  end;

  procedure SaveVersionHeader(strm: TStream; wLength, wValueLength, wType: word; const key: string; const value);
  var
    wKey: WideString;
    valueLen: word;
    keyLen: word;
  begin
    wKey := key;
    strm.Write(wLength, sizeof(wLength));

    strm.Write(wValueLength, sizeof(wValueLength));
    strm.Write(wType, sizeof(wType));
    keyLen := (Length(wKey) + 1) * sizeof(WideChar);
    strm.Write(wKey[1], keyLen);

    PadStream(strm);

    if wValueLength > 0 then
    begin
      valueLen := wValueLength;
      if wType = 1 then
        valueLen := valueLen * sizeof(WideChar);
      strm.Write(value, valueLen)
    end;
  end;

begin { SaveToStream }
  if GetInfo then
  begin
    zeros := 0;

    SaveVersionHeader(strm, 0, sizeof(fFixedInfo^), 0, 'VS_VERSION_INFO', fFixedInfo^);

    if fChildStrings.Count > 0 then
    begin
      stringInfoStream := TMemoryStream.Create;
      try
        strg := TVersionStringValue(fChildStrings.Objects[0]);

        SaveVersionHeader(stringInfoStream, 0, 0, 0, IntToHex(strg.fLangID, 4) + IntToHex(strg.fCodePage, 4), zeros);

        for i := 0 to fChildStrings.Count - 1 do
        begin
          PadStream(stringInfoStream);

          p := stringInfoStream.Position;
          strg := TVersionStringValue(fChildStrings.Objects[i]);
          wValue := strg.fValue;
          SaveVersionHeader(stringInfoStream, 0, Length(strg.fValue) + 1, 1, fChildStrings[i], wValue[1]);
          wSize := stringInfoStream.Size - p;
          stringInfoStream.Seek(p, soFromBeginning);
          stringInfoStream.Write(wSize, sizeof(wSize));
          stringInfoStream.Seek(0, soFromEnd);

        end;

        stringInfoStream.Seek(0, soFromBeginning);
        wSize := stringInfoStream.Size;
        stringInfoStream.Write(wSize, sizeof(wSize));

        PadStream(strm);
        p := strm.Position;
        SaveVersionHeader(strm, 0, 0, 0, 'StringFileInfo', zeros);
        strm.Write(stringInfoStream.Memory^, stringInfoStream.size);
        wSize := strm.Size - p;
      finally
        stringInfoStream.Free
      end;
      strm.Seek(p, soFromBeginning);
      strm.Write(wSize, sizeof(wSize));
      strm.Seek(0, soFromEnd)
    end;

    if fTranslations.Count > 0 then
    begin
      PadStream(strm);
      p := strm.Position;
      SaveVersionHeader(strm, 0, 0, 0, 'VarFileInfo', zeros);
      PadStream(strm);

      p1 := strm.Position;
      SaveVersionHeader(strm, 0, 0, 0, 'Translation', zeros);

      for i := 0 to fTranslations.Count - 1 do
      begin
        v := Integer(fTranslations[i]);
        strm.Write(v, sizeof(v))
      end;

      wSize := strm.Size - p1;
      strm.Seek(p1, soFromBeginning);
      strm.Write(wSize, sizeof(wSize));
      wSize := sizeof(Integer) * fTranslations.Count;
      strm.Write(wSize, sizeof(wSize));

      wSize := strm.Size - p;
      strm.Seek(p, soFromBeginning);
      strm.Write(wSize, sizeof(wSize));
    end;

    strm.Seek(0, soFromBeginning);
    wSize := strm.Size;
    strm.Write(wSize, sizeof(wSize));
    strm.Seek(0, soFromEnd);
  end
  else
    raise Exception.Create('Invalid version resource');
end;

procedure TVersionInfo.SetKeyValue(const idx, Value: string);
var
  i: Integer;
begin
  if GetInfo then
  begin
    i := fChildStrings.IndexOf(idx);
    if i = -1 then
      i := fChildStrings.AddObject(idx, TVersionStringValue.Create(idx, 0, 0));

    TVersionStringValue(fChildStrings.Objects[i]).fValue := Value
  end
  else
    raise Exception.Create('Invalid version resource');
end;

{ TVersionStringValue }

constructor TVersionStringValue.Create(const AValue: string; ALangID,
  ACodePage: Integer);
begin
  fValue := AValue;
  fCodePage := ACodePage;
  fLangID := ALangID;
end;

{ EExRegistryException }

constructor ERegistryExException.Create(code: DWORD; const st: string);
begin
  fCode := code;
  inherited Create(GetError + ':' + st);
end;

constructor ERegistryExException.CreateLastError(const st: string);
begin
  fCode := GetLastError;
  inherited Create(GetError + ':' + st);
end;

function ERegistryExException.GetError: string;
var
  msg: string;

  function GetErrorMessage(code: Integer): string;
  var
    hErrLib: THandle;
    msg: PChar;
    flags: Integer;

    function MAKELANGID(p, s: word): Integer;
    begin
      result := (s shl 10) or p
    end;

  begin
    hErrLib := LoadLibraryEx('netmsg.dll', 0, LOAD_LIBRARY_AS_DATAFILE);

    try

      flags := FORMAT_MESSAGE_ALLOCATE_BUFFER or
        FORMAT_MESSAGE_IGNORE_INSERTS or
        FORMAT_MESSAGE_FROM_SYSTEM;

      if hErrLib <> 0 then
        flags := flags or FORMAT_MESSAGE_FROM_HMODULE;

      if FormatMessage(flags, pointer(hErrLib), code,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        PChar(@msg), 0, nil) <> 0 then
      try
        result := msg;

      finally
        LocalFree(Integer(msg));
      end

    finally
      if hErrLib <> 0 then
        FreeLibrary(hErrLib)
    end
  end;

begin
  msg := GetErrorMessage(fCode);
  if msg = '' then
    result := Format('Error %d', [fCode])
  else
    result := Format('Error %d : %s', [fCode, msg])
end;

{ TSearchNode }

constructor TSearchNode.Create(ARegRoot: HKEY; const APath: string);
begin
  fRegRoot := ARegRoot;
  fValueIDX := -1;
  fKeyIdx := -1;
  fPath := APath
end;

destructor TSearchNode.Destroy;
begin
  fValueNames.Free;
  fKeyNames.Free;
  inherited Destroy
end;

procedure TSearchNode.LoadKeyNames;
var
  r: TRegistryEx;
  i: Integer;
begin
  if not Assigned(fKeyNames) then
  begin
    fKeyNames := TStringList.Create;
    r := TRegistryEx.Create;
    try
      r.RootKey := fRegRoot;
      r.OpenKey(fPath, False);
      r.GetKeyNames(fKeyNames);
    finally
      r.Free
    end;

    for i := 0 to fKeyNames.Count - 1 do
      fKeyNames[i] := UpperCase(fKeyNames[i]);
  end
end;

procedure TSearchNode.LoadValueNames;
var
  r: TRegistryEx;
  i: Integer;
begin
  if not Assigned(fValueNames) then
  begin
    fValueNames := TStringList.Create;
    r := TRegistryEx.Create;
    try
      r.RootKey := fRegRoot;
      r.OpenKey(fPath, False);
      r.GetValueNames(fValueNames);
    finally
      r.Free
    end;

    for i := 0 to fValueNames.Count - 1 do
      fValueNames[i] := UpperCase(fValueNames[i]);
  end
end;

constructor TVirtualMemoryStream.Create(AReserved, AInitialSize: Integer);
begin
  fReserved := AReserved;
  fChunkSize := 1024;
  SetPointer(VirtualAlloc(nil, AReserved, MEM_RESERVE, PAGE_READWRITE), AInitialSize);
  if AInitialSize > 0 then
    VirtualAlloc(Memory, AInitialSize, MEM_COMMIT, PAGE_READWRITE);
end;

destructor TVirtualMemoryStream.Destroy;
begin
  VirtualFree(Memory, 0, MEM_RELEASE);
  inherited;
end;

procedure TVirtualMemoryStream.SetSize(NewSize: Integer);
var
  oldSize: Integer;
  commitSize: Integer;
begin
  oldSize := Size;
  if NewSize <> oldSize then
    if NewSize <= Reserved then
    begin
      if NewSize > oldSize then // Grow the buffer
      begin
        commitSize := NewSize - oldSize;
        if commitSize < ChunkSize then
          commitSize := ChunkSize;
        if commitSize + oldSize > Reserved then
          commitSize := Reserved - oldSize;
        NewSize := oldSize + commitSize;

        VirtualAlloc(PChar(memory) + oldSize, commitSize, MEM_COMMIT, PAGE_READWRITE)
      end
      else // Shrink the buffer (lop off the end)
        VirtualFree(PChar(Memory) + NewSize, oldSize - NewSize, MEM_DECOMMIT);
      SetPointer(Memory, NewSize);
    end
    else
      raise EVirtualMemory.Create('Size exceeds capacity');
end;

function TVirtualMemoryStream.Write(const Buffer; Count: Longint): Longint;
var
  pos: Integer;
begin
  pos := Seek(0, soFromCurrent);
  if pos + count > Size then
    Size := pos + count;
  Move(buffer, PChar(Integer(memory) + pos)^, count);
  Seek(count, soFromCurrent);
  result := Count
end;

{ TMappingFileObj }

constructor TMappingFile.Create(const FileName: string; const FILE_MAP_MODE: DWORD);
var
  hFile: THandle;
  FM, PM : Cardinal;
begin
  FData := nil;
  FM := 0;
  if FILE_MAP_ALL_ACCESS = FILE_MAP_MODE then
  begin
    FM := GENERIC_ALL;
    PM := PAGE_READWRITE;
  end
  else
  begin
    if FILE_MAP_READ and FILE_MAP_MODE = FILE_MAP_READ then FM := FM or GENERIC_READ;
    if FILE_MAP_WRITE and FILE_MAP_MODE = FILE_MAP_WRITE then
    begin
      FM := FM or GENERIC_WRITE;
      PM := PAGE_READWRITE;
    end
    else
      PM := PAGE_READONLY;
  end;

  FFileName := FileName;
  if not FileExists(FFileName) and (FILE_MAP_MODE = FILE_MAP_READ) then
    raise Exception.Create(Format(SFileNotExist, [FFileName]));

  FFileSize := FileSizeEx(FFileName);
  hFile := CreateFile(pchar(FFileName), FM, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN or FILE_FLAG_RANDOM_ACCESS, 0);
  if hFile = 0 then RaiseLastOSError;

  FHandle := CreateFileMapping(hFile, nil, PM, 0, 0, nil);
  if FHandle = 0 then
  begin
    CloseHandle(hFile);
    Raise Exception.Create(SErrFileMap);
  end;
  CloseHandle(hFile);
  FData := MapViewOfFile(FHandle, FILE_MAP_MODE, 0, 0, 0);
end;

destructor TMappingFile.Destroy;
begin
  if FHandle <> 0 then
  begin
    UnmapViewOfFile(Data);
    CloseHandle(FHandle);
    FHandle := 0;
    FData := nil;
  end;
  inherited;
end;

{ TClientCommand }

resourcestring
  CSError = 'Error';
  CSOk = 'Ok';
  CSCommand = 'Command';
  CSResult = 'Result';
  CSErrCode = 'ErrCode';
  CSMessage = 'Message';

  CSErrCmdHandlerCount = 'Error: Command and Handler not equal';

resourcestring
  CSErrCmd = 'Error command: %s';
  CSErrServerExec = '%s (Error Code: %d)';

const
  CIErrCmd = $FFFF;

  { TNetCmdObject }

constructor TNetCmdObject.Create;
begin
  FRequest := TStringList.Create;
  FResponse := TStringList.Create;
end;

destructor TNetCmdObject.Destroy;
begin
  FreeAndNil(FResponse);
  FreeAndNil(FRequest);
  inherited;
end;

function TNetCmdObject.GetCommand: string;
begin
  Result := FRequest.Values[CSCommand];
end;

procedure TNetCmdObject.SetCommand(const Value: string);
begin
  FRequest.Values[CSCommand] := Value;
end;

{ TNetClientCmd }

constructor TNetClientCmd.Create;
begin
  inherited Create;
  FSocket := TIdTCPClient.Create(nil);
  Host := '127.0.0.1';
end;

destructor TNetClientCmd.Destroy;
begin
  FreeAndNil(FSocket);
  inherited;
end;

function TNetClientCmd.GetCmdOK: Boolean;
begin
  Result := SameText(FResponse.Values[CSResult], CSOk);
end;

function TNetClientCmd.GetErrorCode: integer;
begin
  Result := StrToIntDef(FResponse.Values[CSErrCode], 0);
end;

function TNetClientCmd.GetErrorMessage: string;
begin
  Result := FResponse.Values[CSMessage];
end;

{
procedure TNetClientCmd.DoDispatchCommand;
var
  i: integer;
begin
  if Length(CmdStrings) <> Length(CmdHandlers) then
    raise ENetCmdError.Create(CSErrCmdHandlerCount);

  for i := Low(CmdStrings) to High(CmdStrings) do
    if SameText(Command, CmdStrings[i]) then
    begin
      CmdHandlers[i](FSocket, FRequest, FRequest);
      Exit;
    end;

  raise ENetCmdError.CreateFmt(CSErrCmd, [Command]);
end;
}

procedure TNetClientCmd.DoError(const ErrCode: integer; const ErrMsg: string);
begin
  DlgErrorEx(CSErrServerExec, [ErrMsg, ErrCode]);
end;

procedure TNetClientCmd.DoSucc(const Msg: string);
begin
  DlgInfo(Msg);
end;

procedure TNetClientCmd.SetData(const Name, Value: string);
begin
  FRequest.Values[Name] := Value;
end;

function TNetClientCmd.GetHost: string;
begin
  Result := FSocket.Host;
end;

function TNetClientCmd.GetPort: Integer;
begin
  Result := FSocket.Port;
end;

procedure TNetClientCmd.SendAndRecv;
begin
  if not FSocket.Connected then FSocket.Connect;
  FSocket.Write(FRequest.Text);
  FSocket.Write(DblCrLf);
  FResponse.Text := FSocket.ReadLn(DblCrLf);
  FSocket.Disconnect;

  if CmdOk then
  begin
    DoSucc(ErrorMessage);
    FRequest.Clear;
  end
  else
    DoError(ErrorCode, ErrorMessage);
end;

procedure TNetClientCmd.SetHost(const Value: string);
begin
  FSocket.Host := Value;
end;

procedure TNetClientCmd.SetPort(const Value: Integer);
begin
  FSocket.Port := Value;
end;

procedure TNetClientCmd.SetData(const Name: string; const Value: TDateTime);
begin
  SetData(Name, DateTimeToStr(Value));
end;

procedure TNetClientCmd.SetData(const Name: string; const Value: Integer);
begin
  SetData(Name, IntToStr(Value));
end;

procedure TNetClientCmd.SetData(const Name: string; const Value: Float);
begin
  SetData(Name, FloatToStr(Value));
end;

procedure TNetClientCmd.SetData(const Name: string; const Value: Boolean);
begin
  SetData(Name, BoolToString(Value));
end;

function TNetClientCmd.GetBoolean(const Name: string): Boolean;
begin
  Result := StrToBoolDef(GetString(Name), False);
end;

function TNetClientCmd.GetDateTime(const Name: string): TDateTime;
begin
  Result := StrToDateTimeDef(GetString(Name), 0);
end;

function TNetClientCmd.GetFloat(const Name: string): Float;
begin
  Result := StrToFloatDef(GetString(Name), 0);
end;

function TNetClientCmd.GetInteger(const Name: string): Integer;
begin
  Result := StrToIntDef(GetString(Name), 0);
end;

function TNetClientCmd.GetString(const Name: string): string;
begin
  Result := FResponse.Values[Name];
end;

procedure TNetClientCmd.AddData(const Name, Value: string);
begin
  FResponse.Add(Name + '=' + Value);
end;

{ TNetServerCmd }

procedure TNetServerCmd.SetData(const Name, Value: string);
begin
  FResponse.Values[Name] := Value;
end;

constructor TNetServerCmd.Create(AThread: TIdPeerThread);
begin
  inherited Create;
  FSocketThread := AThread;
  FRequest.Text := AThread.Connection.ReadLn(DblCrLf);
end;

destructor TNetServerCmd.Destroy;
begin
  inherited;
end;

procedure TNetServerCmd.DoDispatchCommand;
var
  i: integer;
begin
  if Length(CmdStrings) <> Length(CmdHandlers) then
    raise ENetCmdError.Create(CSErrCmdHandlerCount);

  for i := Low(CmdStrings) to High(CmdStrings) do
    if SameText(Command, CmdStrings[i]) then
    begin
      try
        CmdHandlers[i](FSocketThread, FRequest, FResponse);
      except
        on E: Exception do
          DoFail(1, E.Message);
      end;
      Exit;
    end;

  DoFail(CIErrCmd, CSErrCmd);
end;

class procedure TNetServerCmd.Go(AThread: TIdPeerThread);
begin
  with Create(AThread) do
  try
    DispatchCommand;
    SendResult;
  finally
    Free;
  end;
end;

procedure TNetServerCmd.DoFail(Code: integer; Msg: string);
begin
  FResponse.Values[CSResult] := CSError;
  FResponse.Values[CSErrCode] := IntToStr(Code);
  FResponse.Values[CSMessage] := Msg;
end;

procedure TNetServerCmd.DoSucc(const Msg: string);
begin
  FResponse.Values[CSResult] := CSOk;
  if not IsEmptyStr(Msg) then FResponse.Values[CSMessage] := Msg;
end;

procedure TNetServerCmd.SetData(const Name: string; const Value: TDateTime);
begin
  SetData(Name, DateTimeToStr(Value));
end;

procedure TNetServerCmd.SetData(const Name: string; const Value: Integer);
begin
  SetData(Name, IntToStr(Value));
end;

procedure TNetServerCmd.SetData(const Name: string; const Value: Float);
begin
  SetData(Name, FloatToStr(Value));
end;

procedure TNetServerCmd.SetData(const Name: string; const Value: Boolean);
begin
  SetData(Name, BoolToString(Value));
end;

function TNetServerCmd.GetBoolean(const Name: string): Boolean;
begin
  Result := StringToBoolDef(GetString(Name), False);
end;

function TNetServerCmd.GetDateTime(const Name: string): TDateTime;
begin
  Result := StrToDateTimeDef(GetString(Name), 0);
end;

function TNetServerCmd.GetFloat(const Name: string): Float;
begin
  Result := StrToFloatDef(GetString(Name), 0);
end;

function TNetServerCmd.GetInteger(const Name: string): Integer;
begin
  Result := StrToIntDef(GetString(Name), 0);
end;

function TNetServerCmd.GetString(const Name: string): string;
begin
  Result := FRequest.Values[Name];
end;

procedure TNetServerCmd.SendResult;
begin
  FSocketThread.Connection.Write(FResponse.Text);
  FSocketThread.Connection.Write(DblCrLf);
end;

procedure TNetServerCmd.AddData(const Name, Value: string);
begin
  FResponse.Add(Name + '=' + Value);
end;

{ TWordObject }

destructor TWordObject.Destroy;
begin
  // Unhook the sink from the automation server (Word97)
  InterfaceDisconnect(FWordApp,FAppDispIntfIID,FAppConnection);
  
  inherited Destroy;
end;

function TWordObject.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  // We need to return the two event interfaces when they're asked for
  Result := E_NOINTERFACE;
  if GetInterface(IID,Obj) then
    Result := S_OK;
  if IsEqualGUID(IID,FAppDispIntfIID) and GetInterface(IDispatch,Obj) then
    Result := S_OK;
  if IsEqualGUID(IID,FDocDispIntfIID) and GetInterface(IDispatch,Obj) then
    Result := S_OK;
end;

function TWordObject._AddRef: Integer;
begin
// Skeleton implementation
  Result := 2;
end;

function TWordObject._Release: Integer;
begin
// Skeleton implementation
  Result := 1;
end;

function TWordObject.GetTypeInfoCount(out Count: Integer): HRESULT;
begin
// Skeleton implementation
  Count  := 0;
  Result := S_OK;
end;

function TWordObject.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HRESULT;
begin
// Skeleton implementation
  Result := E_NOTIMPL;
end;

function TWordObject.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
// Skeleton implementation
  Result := E_NOTIMPL;
end;

function TWordObject.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HRESULT;
begin
  // Fire the different event handlers when
  // the different event methods are invoked
  case DispID of
    2 : if Assigned(FOnQuit) then FOnQuit(Self);
    3 : begin
          if Assigned(FOnDocumentChange) then
            FOnDocumentChange(Self);
          // When we see a document change, we also need to disconnect the
          // sink from the old document, and hook it up to the new document
          InterfaceDisconnect(FDocDispatch,FDocDispIntfIID,FDocConnection);
          try
            FDocDispatch := FWordApp.ActiveDocument;
            InterfaceConnect(FDocDispatch,FDocDispIntfIID,Self,FDocConnection);
          except;
          end;
        end;
    4 : if Assigned(FOnNewDocument) then FOnNewDocument(Self);
    5 : if Assigned(FOnOpenDocument) then FOnOpenDocument(Self);
    6 : if Assigned(FOnCloseDocument) then FOnCloseDocument(Self);
    8 : if Assigned(FOnSaveDocument) then FOnSaveDocument(Self);
  end;

  Result := S_OK;
end;

constructor TWordObject.Create;
begin
  inherited Create;

  try
    FWordApp := GetActiveOleObject('Word.Application');
  except
    FWordApp := CreateOleObject('Word.Application');
  end;

  FAppDispIntfIID := Word2000.ApplicationEvents;
  FDocDispIntfIID := Word2000.DocumentEvents;
  //FAppDispatch := AnAppDispatch;

  // Hook the sink up to the automation server (Word)
  InterfaceConnect(FWordApp ,FAppDispIntfIID, Self, FAppConnection);
end;

procedure TWordObject.CloseDoc;
var
  SaveChanges : OleVariant;
begin
  SaveChanges := WdDoNotSaveChanges;
  FWordApp.ActiveDocument.Close(SaveChanges);
end;

procedure TWordObject.InsertText(Text: String);
begin
  FWordApp.Selection.TypeText(Text);
end;

procedure TWordObject.NewDoc(Template: String);
var
  DocTemplate,
  NewTemplate : OleVariant;
begin
  DocTemplate := Template;
  NewTemplate := False;
  FWordApp.Documents.Add(DocTemplate,NewTemplate, EmptyParam, EmptyParam);
end;

procedure TWordObject.Print;
begin
  FWordApp.PrintOut;
end;

procedure TWordObject.Quit(Save: Boolean);
begin
  FWordApp.Quit(Save);
end;

procedure TWordObject.SaveAs(Filename: String);
begin
  FWordApp.ActiveDocument.SaveAs(FileName);
end;

function TWordObject.GetVisible : Boolean;
begin
  Result := FWordApp.Visible;
end;

procedure TWordObject.SetCaption(const Value : String);
begin
  FWordApp.Caption := Value;
end;

function TWordObject.GetCaption : String;
begin
  Result := FWordApp.Caption;
end;

procedure TWordObject.SetVisible(const Value : Boolean);
begin
  FWordApp.Visible := Value;
end;

const BufSize = 1024;

constructor TRedirectedConsole.Create(CommandLine: String);
begin
  inherited Create;
  fCmdLine := CommandLine;
  fIsRunning := False;
  fHidden := True;
  FillChar(fSA, SizeOf(fSA), 0);
  fSA.nLength := SizeOf(fSA);
  fSA.lpSecurityDescriptor := nil;
  fSA.bInheritHandle := True;
  CreatePipe(fStdInRead, fStdInWrite, @fSA, BufSize);
  CreatePipe(fStdOutRead, fStdOutWrite, @fSA, BufSize);
  CreatePipe(fStdErrRead, fStdErrWrite, @fSA, BufSize);
end;

destructor TRedirectedConsole.Destroy;
begin
  if fIsRunning then
  begin
    fTerminate := True;
  end;
  CloseHandle(fStdInWrite);
  CloseHandle(fStdOutRead);
  CloseHandle(fStdErrRead);
  inherited;
end;

function TRedirectedConsole.ReadHandle(h: THandle; var s: String): integer;
var
  BytesWaiting: Cardinal;
  Buf: Array[1..BufSize] of char;
{$IFDEF VER100}
  BytesRead: Integer;
{$ELSE}
  BytesRead: Cardinal;
{$ENDIF}
begin
  Result := 0;
  PeekNamedPipe(h, nil, 0, nil, @BytesWaiting, nil);
  if BytesWaiting > 0 then
  begin
    if BytesWaiting > BufSize then
      BytesWaiting := BufSize;
    ReadFile(h, Buf[1], BytesWaiting, BytesRead, nil);
    s := Copy(Buf, 1, BytesRead);
    Result := BytesRead;
  end;
end;

procedure TRedirectedConsole.SendData(s: String);
var
{$IFDEF VER100}
  BytesWritten: Integer;
{$ELSE}
  BytesWritten: Cardinal;
{$ENDIF}
begin
  if fIsRunning then
  begin
    WriteFile(fStdInWrite, s[1], Length(s), BytesWritten, nil);
  end;
end;

procedure TRedirectedConsole.Terminate;
begin
  TerminateProcess(fPI.hProcess, 1);
end;

procedure TRedirectedConsole.Run;
var
  s: String;
begin
  fTerminate := False;
  FillChar(fSI, SizeOf(fSI), 0);
  fSI.cb := SizeOf(fSI);
  if fHidden then
    fSI.wShowWindow := SW_HIDE
  else
    fSI.wShowWindow := SW_SHOWDEFAULT;
  fSI.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  fSI.hStdInput := fStdInRead;
  fSI.hStdOutput := fStdOutWrite;
  fSI.hStdError := fStdErrWrite;
  if CreateProcess(nil, PChar(fCmdLine), nil, nil, True, NORMAL_PRIORITY_CLASS, nil, nil, fSI, fPI) then
  begin
    fIsRunning := True;
    CloseHandle(fStdOutWrite);
    CloseHandle(fStdErrWrite);
    CloseHandle(fStdInRead);
    CloseHandle(fPI.hThread);
    While WaitForSingleObject(fPI.hProcess, 10) = WAIT_TIMEOUT do
    begin
      if fTerminate then
      begin
        TerminateProcess(fPi.hProcess, 0);
      end;
      if ReadHandle(fStdOutRead, s) > 0 then
        if Assigned(fOnStdOut) then
          fOnStdOut(Self, s);
      if ReadHandle(fStdErrRead, s) > 0 then
        if Assigned(fOnStdErr) then
          fOnStdErr(Self, s);
      if Assigned(fOnRun) then
        fOnRun(Self);
    end;
    if ReadHandle(fStdOutRead, s) > 0 then
      if Assigned(fOnStdOut) then
        fOnStdOut(Self, s);
    if ReadHandle(fStdErrRead, s) > 0 then
      if Assigned(fOnStdErr) then
        fOnStdErr(Self, s);
    CloseHandle(fPI.hProcess);
    fIsRunning := False;
    if Assigned(fOnEnd) then
      fOnEnd(Self);
  end;
end;

{ TMappingFileManager }

function TMappingFileStream.GetPageCurrPosTotalOffset: Int64;
begin
  result := 0;
  if (not Assigned(FPageStartPos)) or (not Assigned(FPageCurrPos)) then exit;
  result := FPageStartOffset + Int64(FPageCurrPos) - Int64(FPageStartPos);
end;

constructor TMappingFileStream.Create(FileName: String; PageSize: Integer;
  DesiredAccess: DWORD);
var
  ASystemInfo: _SYSTEM_INFO;
begin
  FDesiredAccess := DesiredAccess;
  FMappingName := '';
  FFileName := FileName;
  FFileMapped := False;
  FFileHeader := nil;
  FFileHeaderSize := 512;
  FFileHeaderEnabled := False;
  FillChar(ASystemInfo, SizeOf(ASystemInfo), 0);
  GetSystemInfo(ASystemInfo);
  FAllocationGranularity := ASystemInfo.dwAllocationGranularity;
  if FAllocationGranularity <= 0 then
    FAllocationGranularity := 64 * 1024;   //Windows default value is 64K;

  FFileHandle := 0;
  FMapHandle := 0;
  FMapFileFactSize := 0;
  //限制PageSize的大小；
  if PageSize < CIMinPageSize then
    FDefaultPageSize := CIMinPageSize
  else if PageSize > CIMaxPageSize then
    FDefaultPageSize := CIMaxPageSize
  else
    FDefaultPageSize := PageSize;
  FPageFactSize := FDefaultPageSize;         //一般情况下，两者相等；
  FPageStartPos := nil;
  FPageCurrPos := nil;
  FPageStartOffset := 0;
  
  FMapFileTotalSize := 10 * FDefaultPageSize;  //新建文件按照Page的10倍大小映射；
  if FileExists(FileName) then
  begin
    FMapFileFactSize := FileSizeEx(FileName); //映射已存在的文件使用文件实际大小；
    //如果以只读方式打开文件，则必须将映射总文件大小置为文件实际大小，否则将映射文件失败；
    if DesiredAccess = GENERIC_READ then
      FMapFileTotalSize := FMapFileFactSize
    else
      if (FMapFileFactSize > 0) and (FMapFileFactSize > FMapFileTotalSize) then
        FMapFileTotalSize := FMapFileFactSize;
    if FMapFileTotalSize < FPageFactSize then  //修正FPageFactSize值；
      FPageFactSize := FMapFileTotalSize;
  end
  else
  begin
    if DesiredAccess = GENERIC_READ then         //不能只读一个并不存在的文件；
      raise Exception.Create(Format(SFileNotExist, [FileName]));
  end;

  FFileHandle := CreateFile(PChar(FileName), DesiredAccess, FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil, OPEN_ALWAYS, FILE_FLAG_SEQUENTIAL_SCAN or FILE_FLAG_RANDOM_ACCESS, 0);
end;

destructor TMappingFileStream.Destroy;
begin
  CloseMapFile;
  if FFileHandle <> 0 then
  begin
    CloseHandle(FFileHandle);
    FFileHandle := 0;
  end;
  inherited;
end;

function TMappingFileStream.GetEOF: Boolean;
begin
  result := FMapFileFactSize <= GetPageCurrPosTotalOffset;
end;

procedure TMappingFileStream.MappingFile;
var
  pName: PChar;
begin
  if FFileHandle = 0 then exit;   //文件句柄为空，退出；

  //创建映射文件；
  if IsShareMem then
  begin
    pName := PChar(FMappingName);
    FMapHandle := CreateFileMapping(FFileHandle, nil, GetFileMappingMode,
      Int64Rec(FMapFileTotalSize).Hi, Int64Rec(FMapFileTotalSize).Lo, pName);
    if (FMapHandle <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then
    begin
      CloseHandle(FMapHandle);
      FMapHandle := 0;
      FMapHandle := OpenFileMapping(GetFileMapViewMode, False, pName);
    end;
  end
  else
    FMapHandle := CreateFileMapping(FFileHandle, nil, GetFileMappingMode,
      Int64Rec(FMapFileTotalSize).Hi, Int64Rec(FMapFileTotalSize).Lo, nil);

  ViewPage;
end;

function TMappingFileStream.Read(var Buffer; Count: Integer): Longint;
var
  iPageLast, iCurrPos: Int64;
  pBuffer: Pointer;
begin
  result := 0;
  if FPageCurrPos = nil then exit;

  iPageLast := PageLast;
  iCurrPos := GetPageCurrPosTotalOffset;

  if iPageLast < iCurrPos then   //当当前指针超出了当前页，切换当前页；
  begin
    ReviewPage(iCurrPos);
    iPageLast := PageLast;
  end;

  pBuffer := @Buffer;
  if Count <= (iPageLast - iCurrPos) then   //读取数据没有超出当前页范围，直接读取；
  begin
    ReadAndMovePos(pBuffer, Count);
    result := Count;
  end
  else
    Result := ReadData(pBuffer, Count);   //超出当前页范围，调用递归函数读取；
end;

function TMappingFileStream.ReCalcPageStartOffset(iCurrPos: Int64): Int64;
begin
  //总是从距离iCurPos的FAllocationGraunlarity的整数倍的地址开始映射
  //由于限制了Page的大小总是会大于或等于FAllocationGraunlarity，所以不用出现iCurrPos不在当前Page中的问题；
  result := iCurrPos - (iCurrPos mod FAllocationGranularity);   //文件的地址从0开始
end;

function TMappingFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
var
  iPos, iCurrPos: Int64;
begin
  iPos := 0;
  case Origin of
    soBeginning: iPos := Offset;    //偏移地址从0开始；
    soCurrent: iPos := GetPageCurrPosTotalOffset + Offset;
    soEnd: iPos := FMapFileFactSize - Offset;  //偏移地址从0开始；
  end;
  if iPos < 0 then
    iPos := 0
  else if iPos >= FMapFileTotalSize then
    iPos := FMapFileTotalSize;

  if (iPos < FPageStartOffset) or (iPos >= FPageStartOffset + FPageFactSize) then
    //超出当前Page，需要重新映射；
    ReviewPage(iPos)
  else
  begin
    iCurrPos := GetPageCurrPosTotalOffset;
    Inc(PChar(FPageCurrPos), (iPos - iCurrPos));
  end;

  Result := iPos;
end;

procedure TMappingFileStream.ViewPage;
begin
  if FMapHandle = 0 then exit;
  FPageStartPos := MapViewOfFile(FMapHandle, GetFileMapViewMode,
    Int64Rec(FPageStartOffset).Hi, Int64Rec(FPageStartOffset).Lo, FPageFactSize);
  FPageCurrPos := FPageStartPos;
  if FFileHeaderEnabled then
    FFileHeader := MapViewOfFile(FMapHandle, GetFileMapViewMode, 0, 0, FFileHeaderSize);
end;

function TMappingFileStream.Write(const Buffer; Count: Integer): Longint;
var
  iPageLast, iCurrPos: Int64;
  pBuffer: Pointer;
begin
  result := 0;
  if FPageCurrPos = nil then exit;

  iPageLast := PageLast;
  iCurrPos := GetPageCurrPosTotalOffset;

  if iPageLast < iCurrPos then   //当当前指针超出了当前页，切换当前页；
  begin
    ReviewPage(iCurrPos);
    iPageLast := PageLast;
  end;

  pBuffer := @Buffer;
  if Count <= (iPageLast - iCurrPos) then   //写入数据没有超出当前页范围，直接写入；
  begin
    WriteAndMovePos(pBuffer, Count);
    result := Count;
  end
  else
    Result := WriteData(pBuffer, Count);   //超出当前页范围，调用递归函数写入；
end;

procedure TMappingFileStream.CloseMapFile;
var
  pHigh32: PDWord;
begin
  CloseViewPage;
  CloseFileHeaderPage;
  if FMapHandle <> 0 then
  begin
    CloseHandle(FMapHandle);
    FMapHandle := 0;
  end;

  if (FFileHandle <> 0) and ((FDesiredAccess and GENERIC_WRITE = GENERIC_WRITE)
    or (FDesiredAccess = GENERIC_ALL)) then
  begin
    New(pHigh32);
    pHigh32^ := Int64Rec(FMapFileFactSize).Hi;
    SetFilePointer(FFileHandle, Int64Rec(FMapFileFactSize).Lo, pHigh32, soFromBeginning);
    SetEndOfFile(FFileHandle);
    Dispose(pHigh32);
  end;
end;

procedure TMappingFileStream.CloseViewPage;
begin
  if FPageStartPos <> nil then
  begin
    UnmapViewOfFile(FPageStartPos);
    FPageStartPos := nil;
    FPageCurrPos := nil;
  end;
end;

//参数说明：
//pData: 读取的数据指针，由函数外部分配足够内存空间, 该指针是动态移动的；
//Count: 要读取的数据大小(剩余需要读取数据的大小)
//返回值：一次调用实际读取的数据大小；
function TMappingFileStream.ReadData(var pData: Pointer; Count: Integer): Longint;
var
  iCurrPos, iPageLast: Int64;
  iReadCount: Integer;
begin
  iCurrPos := GetPageCurrPosTotalOffset;
  iPageLast := PageLast;
  if iPageLast >= FMapFileFactSize then  //到了文件实际大小的尾部；
  begin
    result := Min(Count, FMapFileFactSize - iCurrPos);
    ReadAndMovePos(pData, result);
  end
  else
    if Count <= (iPageLast - iCurrPos) then
    begin  //读取的数据全部在当前页内；
      ReadAndMovePos(pData, Count);
      result := Count;
    end
    else
    begin    //读取的数据跨过了当前页；
      //先将本页中的数据读取；
      iReadCount := iPageLast - iCurrPos;
      Move(FPageCurrPos^, pData^, iReadCount);

      Inc(PChar(pData), iReadCount); //将数据指针后移，准备下一次读取；
      iCurrPos := iCurrPos + iReadCount;             //计算下一个页的起始读取位置；
      ReviewPage(iCurrPos);                          //切换新的页面；
      result := iReadCount + ReadData(pData, Count - iReadCount);   //递归调用读取剩余数据；
    end;
end;

function TMappingFileStream.PageLast: Int64;
begin
  result := FPageStartOffset + FPageFactSize;
  if result < FPageStartOffset then result := FPageStartOffset;
end;

procedure TMappingFileStream.ReadAndMovePos(pData: Pointer;
  Count: Integer);
begin
  if pData = nil then exit;
  Move(FPageCurrPos^, pData^, Count);
  Inc(PChar(FPageCurrPos), Count);
end;

procedure TMappingFileStream.ReviewPage(NewPos: Int64);
begin
  CloseViewPage;
  if NewPos >= FMapFileTotalSize then exit;

  FPageStartOffset := ReCalcPageStartOffset(NewPos);
  if (FMapFileTotalSize - FPageStartOffset) < FDefaultPageSize then
    FPageFactSize := FMapFileTotalSize  - FPageStartOffset
  else
    FPageFactSize := FDefaultPageSize;
  ViewPage;
  FPageCurrPos := Pointer(Int64(FPageStartPos) + (NewPos - FPageStartOffset));   //将当前指针移到指定位置；
end;

procedure TMappingFileStream.ReMappingFile(MoveTo: Int64);
begin
  if FFileHandle = 0 then exit;   //文件句柄为空，退出；
  CloseMapFile;

  FPageStartOffset := ReCalcPageStartOffset(MoveTo);
  //创建映射文件；
  MappingFile;
  FPageCurrPos := Pointer(Int64(FPageStartPos) + (MoveTo - FPageStartOffset));
end;

//参数说明：
//pData: 写入的源数据指针，该指针是随着写入过程动态移动的；
//Count: 要写入的数据大小(剩余需要写入数据的大小)
//返回值：一次调用实际写入的数据大小；
function TMappingFileStream.WriteData(var pData: Pointer;
  Count: Integer): Longint;
var
  iCurrPos, iPageLast: Int64;
  iWriteCount: Integer;
begin
  iCurrPos := GetPageCurrPosTotalOffset;
  iPageLast := PageLast;
  if iPageLast >= FMapFileTotalSize then  //到了文件尾部；
  begin
    if Count <= (FMapFileTotalSize - iCurrPos) then  //没有超出文件范围，直接写入；
    begin
      WriteAndMovePos(pData, Count);
      result := Count;
    end
    else
    begin   //超出了文件范围，先写入前面部分，重新映射文件，增大文件大小后写入剩余部分；
      iWriteCount := FMapFileTotalSize - iCurrPos;
      WriteAndMovePos(pData, iWriteCount);               //写入前面部分；
      Inc(PChar(pData), iWriteCount);     //指针后移；

      //增加映射文件大小后重新映射；
      FMapFileTotalSize := FMapFileTotalSize + Max(FDefaultPageSize, Count - iWriteCount);
      iCurrPos := iCurrPos + iWriteCount;
      ReMappingFile(iCurrPos);
      result := iWriteCount + WriteData(pData, Count - iWriteCount); //递归调用；
    end
  end
  else
    if Count <= (iPageLast - iCurrPos) then
    begin  //写入的数据全部在当前页内；
      WriteAndMovePos(pData, Count);
      result := Count;
    end
    else
    begin    //写入的数据跨过了当前页；
      //先将本页中的数据写入；
      iWriteCount := iPageLast - iCurrPos;
      WriteAndMovePos(pData, iWriteCount);

      Inc(PChar(pData), iWriteCount); //将数据指针后移，准备下一次写入；
      iCurrPos := iCurrPos + iWriteCount;             //计算下一个页的起始读取位置；
      ReviewPage(iCurrPos);                          //切换新的页面；
      result := iWriteCount + WriteData(pData, Count - iWriteCount);   //递归调用写入剩余数据；
    end;
end;

procedure TMappingFileStream.WriteAndMovePos(pData: Pointer;
  Count: Integer);
var
  iNewSize: Int64;
begin
  if pData = nil then exit;
  Move(pData^, FPageCurrPos^, Count);
  Inc(PChar(FPageCurrPos), Count);
  iNewSize := GetPageCurrPosTotalOffset;
  FMapFileFactSize := Max(iNewSize, FMapFileFactSize);   //更改文件大小；
end;

function TMappingFileStream.GetFileMappingMode: DWORD;
begin
  result := 0;
  if FDesiredAccess = GENERIC_ALL then
    result := PAGE_READWRITE
  else
  begin
    if FDesiredAccess = GENERIC_READ then
      result := PAGE_READONLY
    else  if (FDesiredAccess and GENERIC_WRITE) = GENERIC_WRITE then
      result := PAGE_READWRITE;
  end;
end;

function TMappingFileStream.GetFileMapViewMode: DWORD;
begin
  result := 0;
  if FDesiredAccess = GENERIC_ALL then
    result := FILE_MAP_ALL_ACCESS
  else
  begin
    if FDesiredAccess = GENERIC_READ then
      result := FILE_MAP_READ
    else if (FDesiredAccess and GENERIC_WRITE) = GENERIC_WRITE then
      result := FILE_MAP_WRITE or FILE_MAP_READ;
  end;
end;

function TMappingFileStream.IsShareMem: Boolean;
begin
  result := Trim(FMappingName) <> '';
end;

function TMappingFileStream.MapView(const Offset, Size: Int64): Pointer;
begin
  Result := MapViewOfFile(FMapHandle, GetFileMapViewMode, Hi(Offset), Lo(Offset), Size);
end;

procedure TMappingFileStream.SetSize(const Value: Int64);
begin
  if Value <> FMapFileFactSize then
  begin
    FMapFileFactSize := Value;
    if Value <= GetPageCurrPosTotalOffset then
    begin
      ReviewPage(Value);
    end
    else
    begin
      ReMappingFile(GetPageCurrPosTotalOffset);
    end;
  end;
end;

function TMappingFileStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Result := Seek(Offset, TSeekOrigin(Origin));
end;

//=============================================================
//  fmCreate         = $ffff;
//  fmOpenRead       = $0000;
//  fmOpenWrite      = $0001;
//  fmOpenReadWrite  = $0002;
//  fmShareCompat    = $0000;
//  fmShareExclusive = $0010;
//  fmShareDenyWrite = $0020;
//  fmShareDenyRead  = $0030;
//  fmShareDenyNone  = $0040;
function ModeToStgMode( const Mode : Word ) : DWORD;
const
		RWModes : Array [0..3] of DWord = (STGM_READ,STGM_WRITE,STGM_READWRITE,0);
		ShareModes : Array [0..7] of DWord =
		(	STGM_SHARE_EXCLUSIVE,STGM_SHARE_EXCLUSIVE,STGM_SHARE_DENY_WRITE,STGM_SHARE_DENY_READ,
			STGM_SHARE_DENY_NONE,STGM_SHARE_EXCLUSIVE,STGM_SHARE_EXCLUSIVE,STGM_SHARE_EXCLUSIVE);
begin
	if Mode=fmCreate then Result := stgmCreate
	else Result := RWModes[Mode and 3] or ShareModes[Mode shr 4];
end;
//-------------------------------------------------------------
{function GetName( var ptr : PChar; var len : Integer ) : String;
const Delimitors : String = '/\'#0;
var	i : Integer;
begin
	Result := '';
	i := QScanChars( ptr, len, Delimitors );
 	if i>0 then
		begin
 			Dec(i);
 			if i=0 then Exit;
			Result := Copy(ptr,1,i);
 			Inc(ptr,i);
 			Dec(len,i)
		end
 	else
  	begin
  		Result := Copy(ptr,1,len);
  		ptr := nil;
  		len := 0;
		end;
end;}
//==TStgStream===========================================================
constructor TStgStream.Create( const AName : String; AStorage : TStorage; AStream : IStream );
begin
	inherited Create;
	FStream := AStream;
	FStorage := AStorage;
	if AStorage<>nil then
	begin
		FPath := AStorage.FPath+AStorage.FName+'\';
		Inc(AStorage.FLockCount);
	end;
	FName := AName;
end; {TStgStream.Create}
//-------------------------------------------------------------
destructor TStgStream.Destroy;
begin
{	if FStream<>nil then
	begin
		FStream._Release;
		FStream := nil;
	end;}
	if FStorage<>nil then FStorage.Close;
	inherited Destroy;
end; {TStgStream.Destroy}
//-------------------------------------------------------------
function TStgStream.Read( var Buffer; Count : Longint ) : Longint;
begin
	Result := 0;
	if FStream<>nil then OleCheck( FStream.Read( @Buffer, Count, @Result ) );
end; {TStgStream.Read}
//-------------------------------------------------------------
function TStgStream.Write( const Buffer; Count : Longint ) : Longint;
begin
	Result := 0;
	if FStream<>nil then OleCheck( FStream.Write( @Buffer, Count, @Result ) );
end; {TStgStream.Write}
//-------------------------------------------------------------
function TStgStream.Seek( Offset : Longint; Origin : Word ) : Longint;
var	NewPos : LargeInt;
begin
	Result := 0;
	if FStream=nil then Exit;
	OleCheck( FStream.Seek( Offset, Origin, NewPos ) );
	Result := LongInt(NewPos);
end; {TStgStream.Seek}
//-------------------------------------------------------------
procedure TStgStream.SetSize( NewSize : Longint );
begin
	if FStream=nil then Exit;
	OleCheck( FStream.SetSize(NewSize) );
end; {TStgStream.SetSize}
//-------------------------------------------------------------
procedure TStgStream.SetName( Value : String );
begin
	if FName=Value then Exit;
	if FStorage<>nil then FStorage.RenameElement(FName,Value);
	FName := Value;
end; {TStgStream.SetName}

//==TStorage===========================================================
constructor TStorage.Create( const AName : String; AParent : TStorage; AStorage : IStorage );
begin
	inherited Create;
	FStorage := AStorage;
	FName := AName;
	FParent := AParent;
	if AParent<>nil then
	begin
		FPath := AParent.FPath+AParent.FName+'\';
		Inc(AParent.FLockCount);
	end;
end; {TStorage.Create}
//-------------------------------------------------------------
destructor TStorage.Destroy;
begin
{	if FStorage<>nil then
	begin
		FStorage._Release;
		FStorage := nil;
	end;}
	if FParent<>nil then FParent.Close;
	inherited Destroy;
end; {TStorage.Destroy}
//-------------------------------------------------------------
procedure TStorage.Close;
begin
	if FLockCount>0 then Dec(FLockCount) else Destroy;
end; {TStorage.Destroy}
//-------------------------------------------------------------
function TStorage.CreateStream( const AName : String; const Mode : DWord ) : TStgStream;
var	pw : PWideChar;
		rc : HResult;
		newStream : IStream;
begin
	Result := nil;
	if (FStorage=nil)or(AName='') then Exit;
	pw := StringToOleStr(AName);
	try
		rc := FStorage.CreateStream( pw, Mode, 0, 0, newStream );
		if rc<>S_OK then OleError(rc);
	finally
		SysFreeString(pw);
	end;
	if newStream=nil then Exit;
	Result := TStgStream.Create( AName, Self, newStream );
end; {TStorage.CreateStream}
//-------------------------------------------------------------
function TStorage.OpenStream( const AName : String; const Mode : DWord ) : TStgStream;
var	pw : PWideChar;
		rc : HResult;
		newStream : IStream;
begin
	Result := nil;
	if (FStorage=nil)or(AName='') then Exit;
	pw := StringToOleStr(AName);
	try
		rc := FStorage.OpenStream( pw, nil, Mode, 0, newStream );
		if rc<>S_OK then OleError(rc);
	finally
		SysFreeString(pw);
	end;
	if newStream=nil then Exit;
	Result := TStgStream.Create( AName, Self, newStream );
end; {TStorage.CreateStream}
//-------------------------------------------------------------
function TStorage.OpenCreateStream( const AName : String; const Mode : DWord ) : TStgStream;
var	pw : PWideChar;
		rc : HResult;
		newStream : IStream;
begin
	Result := nil;
	if (FStorage=nil)or(AName='') then Exit;
	pw := StringToOleStr(AName);
	try
		rc := FStorage.OpenStream( pw, nil, Mode and ($ffffffff xor STGM_CREATE xor STGM_CONVERT), 0, newStream );
		if rc=STG_E_FILENOTFOUND then rc := FStorage.CreateStream( pw, Mode, 0, 0, newStream );
		if rc<>S_OK then OleError(rc);
	finally
		SysFreeString(pw);
	end;
	if newStream=nil then Exit;
	Result := TStgStream.Create( AName, Self, newStream );
end; {TStorage.CreateStream}
//-------------------------------------------------------------
function TStorage.CreateStorage( const AName : String; const Mode : DWord ) : TStorage;
var	pw : PWideChar;
		rc : HResult;
		newStg : IStorage;
begin
	Result := nil;
	if AName='' then Exit;
	pw := StringToOleStr(AName);
	try
		rc := FStorage.CreateStorage( pw, Mode, 0, 0, newStg );
		if rc<>S_OK then OleError(rc);
	finally
		SysFreeString(pw);
	end;
	if newStg=nil then Exit;
	Result := TStorage.Create( AName, Self, newStg );
end; {TStorage.CreateStorage}
//-------------------------------------------------------------
function TStorage.OpenStorage( const AName : String; const Mode : DWord ) : TStorage;
var	pw : PWideChar;
		rc : HResult;
		newStg : IStorage;
begin
	Result := nil;
	if AName='' then Exit;
	pw := StringToOleStr(AName);
//  newStg := nil;
	rc := FStorage.OpenStorage( pw, nil, Mode, nil, 0, newStg );
	SysFreeString(pw);
	if rc<>S_OK then OleError(rc);
	if newStg=nil then Exit;
	Result := TStorage.Create( AName, Self, newStg );
end; {TStorage.OpenStorage}
//-------------------------------------------------------------
function TStorage.OpenCreateStorage( const AName : String; const Mode : DWord; var bCreate : Boolean ) : TStorage;
var	pw : PWideChar;
		rc : HResult;
		newStg : IStorage;
begin
	Result := nil;
	if AName='' then Exit;
	pw := StringToOleStr(AName);
	if bCreate then rc := FStorage.CreateStorage( pw, Mode, 0, 0, newStg )
	else
		begin
			rc := FStorage.OpenStorage( pw, nil, Mode and ($ffffffff xor STGM_CREATE xor STGM_CONVERT), nil, 0, newStg );
			if rc=STG_E_FILENOTFOUND then
			begin
				rc := FStorage.CreateStorage( pw, Mode, 0, 0, newStg );
				bCreate := True;
			end;
		end;
	SysFreeString(pw);
	if rc<>S_OK then OleError(rc);
	if newStg=nil then Exit;
	Result := TStorage.Create( AName, Self, newStg );
end; {TStorage.CreateStorage}
//-------------------------------------------------------------
procedure TStorage.EnumElements( AStrings : TStringList ; dwTypeNeed:DWORD);
const	MaxElem = 100;
var	rc : HResult;
		n,i : LongInt;
		oEnum : IEnumSTATSTG;
		aElem : Array [0..MaxElem-1] of TSTATSTG;
    sName : String;
begin
	if AStrings=nil then Exit;
	rc := FStorage.EnumElements(0,nil,0,oEnum);
	if rc<>S_OK then OleCheck(rc);
	n := MaxElem;
//	try
		repeat
			oEnum.Next(MaxElem,aElem,@n);
			if n>0 then
				for i := 0 to n-1 do with aElem[i] do
				begin
                	if ( dwType and dwTypeNeed ) <> 0 then
                    begin
				        WideCharToStrVar(pwcsName,sName);
						AStrings.AddObject(sName,Pointer(dwType));
						CoTaskMemFree(pwcsName);
                    end;
				end;
		until n<>MaxElem;
//	finally
//		oEnum._Release;
//    oEnum := nil;
//	end;
end; {TStorage.EnumElements}
//-------------------------------------------------------------
procedure TStorage.RenameElement( const AOldName, ANewName : String );
var	wcOld,wcNew : PWideChar;
		rc : HResult;
begin
	if (AOldName='')or(ANewName='')or(AOldName=ANewName)  then Exit;
	wcOld := StringToOleStr(AOldName);
	wcNew := StringToOleStr(ANewName);
	try
		rc := FStorage.RenameElement(wcOld,wcNew);
	finally
		SysFreeString(wcOld);
		SysFreeString(wcNew);
	end;
	OleCheck(rc);
end; {TStorage.RenameElement}
//-------------------------------------------------------------
procedure TStorage.SetName( Value : String );
begin
	if FName=Value then Exit;
	if (FStorage<>nil)and(FParent<>nil) then FParent.RenameElement(FName,Value);
	FName := Value;
end; {TStorage.SetName}

//==TStgFile===========================================================
constructor TStgFile.Create( const AFileName : String; AStorage : IStorage );
begin
	inherited Create('',nil,AStorage);
	if AFileName='' then Exit;
	FFileName := ExpandFileName(AFileName);
	FPath := FFileName+':';
end; {TStgFile.Create}
//-------------------------------------------------------------
class function TStgFile.CreateFile( const AFileName : String; const Mode : DWord ) : TStgFile;
var	pw : PWideChar;
		newStg : IStorage;
begin
	Result := nil;
	if AFileName='' then Exit;
	pw := StringToOleStr(AFileName);
	try
		newStg := nil;
		OleCheck( StgCreateDocFile(pw,Mode,0,newStg) );
	finally
		SysFreeString(pw);
	end;
	if newStg<>nil then Result := TStgFile.Create(AFileName,newStg);
end; {TStgFile.CreateFile}
//-------------------------------------------------------------
class function TStgFile.OpenFile( const AFileName : String; const Mode : DWord ) : TStgFile;
var	pw : PWideChar;
		newStg : IStorage;
begin
	Result := nil;
	if AFileName='' then Exit;
	pw := StringToOleStr(AFileName);
	newStg := nil;
	try
		OleCheck( StgOpenStorage(pw,nil,Mode,nil,0,newStg) );
	finally
		SysFreeString(pw);
	end;
	if newStg<>nil then Result := TStgFile.Create(AFileName,newStg);
end; {TStgFile.OpenFile}
//-------------------------------------------------------------
{function TStgFile.Clone( const Mode : DWord ) : TStgFile;
var	newStg : IStorage;
begin
	Result := nil;
	newStg := nil;
	if FStorage=nil then Exit;
	StgOpenStorage(nil,FStorage,Mode,nil,0,newStg);
	if newStg<>nil then Result := TStgFile.Create(Self.FFileName,newStg);
end; {TStgFile.Clone}

procedure TStorage.Commit( cflag:DWORD );
var
	rc:HRESULT;
begin
	if FStorage <> nil then
		rc := FStorage.Commit( cFlag );
    if rc <> S_OK then OleError( rc );
end;

{ TExtendQueue }

procedure TExtendQueue.Clear;
var
  tmp, node: PLinkNode;
begin
  node := FFirstNode;
  while Assigned(node) do
  begin
    tmp := node;
    node := node^.Next;
    Dispose(tmp);
  end;
end;

constructor TExtendQueue.Create;
begin
  FCount := 0;
  FFirstNode := nil;
  FLock := TCriticalSection.Create;
end;

destructor TExtendQueue.Destroy;
begin
  Clear;
  FLock.Free;
  inherited;
end;

function TExtendQueue.GetItem: Pointer;
begin
  FLock.Enter;
  if FCount = 0 then
    Result := nil
  else
    Result := FFirstNode^.Data;
  FLock.Leave;
end;

{procedure TExtendQueue.DeleteNode(node: PLinkNode);
begin
  if Assigned(node^.Prior) then
    node^.Prior^.Next := node^.Next;
  if Assigned(node^.Next) then
    node^.Next^.Prior := node^.Prior;
  if FCount = 1 then
  begin
    FFirstNode := nil;
    FLastNode := nil;
  end
  else
  begin
    if node = FFirstNode then
      FFirstNode := node^.Next;
    if node = FLastNode then
      FLastNode := node^.Prior;
  end;
  Dispose(node);
end;   }

function TExtendQueue.PopItem: Pointer;
var
  node: PLinkNode;
begin
  FLock.Enter;
  if FCount = 0 then
    Result := nil
  else
  begin
    node := FFirstNode;
    Result := node^.Data;
    if FCount = 1 then
    begin
      FLastNode := nil;
      FFirstNode := nil;
    end
    else
    begin
      FFirstNode := node^.Next;
      FFirstNode.Prior := nil;
    end;
    Dec(FCount);
    Dispose(node);
  end;
  FLock.Leave;
end;

procedure TExtendQueue.PushItem(Item: Pointer);
var
  node: PLinkNode;
begin
  FLock.Enter;
  if FCount = 0 then
  begin
    New(FFirstNode);
    FFirstNode^.Data := Item;
    FFirstNode^.Next := nil;
    FFirstNode^.Prior := nil;
    FLastNode := FFirstNode;
  end
  else
  begin
    New(node);
    node^.Data := Item;
    node^.Next := nil;
    node^.Prior := FLastNode;
    FLastNode^.Next := node;
    FLastNode := node;
  end;
  Inc(FCount);
  FLock.Leave;
end;

{ TExtendedList }

procedure TExtendedList.Add(Value: Extended);
begin
  inherited Add(Value);
end;

constructor TExtendedList.Create;
begin
  inherited Create(SizeOf(Extended));
end;

function TExtendedList.GetItems(Index: Integer): Extended;
begin
  Result := Extended(inherited Items[Index]^);
end;

procedure TExtendedList.SetItems(Index: integer; const Value: Extended);
begin
  DoSetItems(Index, Value);
end;

function TExtendedList.ValueExist(Value: Extended): Boolean;
begin
  Result := IndexOf(Value) <> -1;
end;
procedure TMappingFileStream.ClippingFile;
begin
  FMapFileFactSize := GetPageCurrPosTotalOffset;
end;

{ TListEx }

function TListEx.Add(Data: Pointer): Integer;
var
  Node: PLinkNode;
begin
  // [2007-7-12]Kingron: 在最后添加一个节点，返回添加后的Index
  Lock;
  try
    if FCount = 0 then
    begin
      New(FFirst);
      FFirst.Data := Data;
      FFirst.Next := nil;
      FFirst.Prior := nil;
      FLast := FFirst;
    end
    else
    begin
      New(node);
      node^.Data := Data;
      node^.Next := nil;
      node^.Prior := FLast;
      FLast^.Next := node;
      FLast := node;
    end;
    Inc(FCount);
    Result := FCount - 1;
  finally
    UnLock;
  end;
end;

procedure TListEx.Clear;
var
  Node, Node2: PLinkNode;
begin
  Node := FFirst;
  while Node <> nil do
  begin
    DoDelete(Node);
    Node2 := Node;
    Node := Node.Next;
    Dispose(Node2);
  end;
  FCount := 0;
  FFirst := nil;
  FLast := nil;
end;

constructor TListEx.Create;
begin
  FCount := 0;
  FFirst := nil;
  FLast := nil;
  FLock := TCriticalSection.Create;
end;

function TListEx.Delete(Index: Integer): Boolean;
var
  i : Integer;
  Node: PLinkNode;
begin
  Result := False;
  if (index < 0) or (index > FCount - 1) then Exit;

  Node := FFirst;
  i := 0;
  while i < index do
  begin
    Node := Node.Next;
    Inc(i);
  end;
  if Node.Prior = nil then // 第一个节点的Prior为空
    FFirst := Node.Next
  else if Node.Next = nil then // 最后一个节点的Next为空
  begin
    FLast := Node.Prior;
    FLast.Next := nil;
  end
  else
    Node.Prior.Next := Node.Next;
  DoDelete(Node);
  Dispose(Node);
  Dec(FCount);
  Result := True;
end;

destructor TListEx.Destroy;
begin
  Clear;
  FLock.Free;
  inherited;
end;

procedure TListEx.DoDelete(Node: PLinkNode);
begin
  if Assigned(FOnDeleteItem) then FOnDeleteItem(Node.Data);
end;

function TListEx.First: Pointer;
begin
  if FFirst <> nil then
    Result := FFirst.Data
  else
    Result := nil;
end;

function TListEx.GetItem(Index: Integer): Pointer;
var
  i : Integer;
  Node: PLinkNode;
begin
  Result := nil;
  if (index < 0) or (index > FCount - 1) then Exit;
  
  Node := FFirst;
  i := 0;
  while i < index do
  begin
    Node := Node.Next;
    Inc(i);
  end;
  Result := Node.Data;
end;

function TListEx.IndexOf(Data: Pointer): Integer;
var
  Node: PLinkNode;
begin
  // [2007-7-12]Kingron: 查找指定的数据，找不到，返回-1
  Result := 0;
  Node := FFirst;
  while (Node <> nil) do
  begin
    if Node.Data = Data then Exit;
    Inc(Result);
    Node := Node.Next;
  end;
  Result := -1;
end;

function TListEx.Insert(Index: Integer; Data: Pointer): Integer;
var
  Node, pNew : PLinkNode;
begin
  // [2007-7-12]Kingron: 在指定位置之后插入数据，返回插入后的Index
  Lock;
  try
    if index < 0 then // 在最前面插入
    begin
      New(Node);
      Node.Data := Data;
      Node.Next := FFirst;
      Node.Prior := nil;
      FFirst := Node;
      Inc(FCount);
      Result := 0;
    end
    else if Index >= FCount - 1 then  // 超过末尾了，在最后添加
    begin
      Result := Add(Data);
    end
    else    // 需要查找到第Index个，然后在其后插入
    begin
      Result := 0;
      Node := FFirst;
      while Result < Index do
      begin
        Node := Node.Next;
        Inc(Result);
      end;
      New(pNew);
      pNew.Data := Data;
      pNew.Prior := Node;
      pNew.Next := Node.Next;
      Node.Next := pNew;
      Inc(Result);
      Inc(FCount);
    end;
  finally
    UnLock;
  end;
end;

function TListEx.Last: Pointer;
begin
  if FLast <> nil then
    Result := FLast.Data
  else
    Result := nil;  
end;

procedure TListEx.Lock;
begin
  FLock.Enter;
end;

procedure TListEx.UnLock;
begin
  FLock.Leave;
end;

function TMappingFileStream.GetFileHeaderEx(Size: Integer): Pointer;
begin
  FFileHeaderEnabled := True;
  if FFileHeader = nil then
  begin
    FFileHeaderSize := Size;
    if FMapHandle > 0 then
      FFileHeader := MapViewOfFile(FMapHandle, GetFileMapViewMode, 0, 0, FFileHeaderSize);
  end
  else if Size <> FFileHeaderSize then
  begin
    CloseFileHeaderPage;
    FFileHeaderSize := Size;
    if FMapHandle > 0 then
      FFileHeader := MapViewOfFile(FMapHandle, GetFileMapViewMode, 0, 0, FFileHeaderSize);
  end;
  Result := FFileHeader;
end;

procedure TMappingFileStream.CloseFileHeaderPage;
begin
  if FFileHeader <> nil then
  begin
    UnmapViewOfFile(FFileHeader);
    FFileHeader := nil;
  end;
end;

procedure TMappingFileStream.Flush;
begin
  if (FFileHandle <> 0) then
    FlushFileBuffers(FFileHandle);
end;

end.

