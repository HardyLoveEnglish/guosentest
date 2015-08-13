unit FrmDisplayDetails;

{显示归属信息}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBGridEhGrouping, GridsEh, DBGridEh, FrmBase, Grids,
  StdCtrls, ActiveX;

type
  TDisplayDetailsForm = class(TBaseForm)
    pnl1: TPanel;
    pnl2: TPanel;
    strngrdHistory: TStringGrid;
    pnl3: TPanel;
    lblDeviceName: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lblStatus: TLabel;
    lbl3: TLabel;
    lblUserName: TLabel;
    lbl4: TLabel;
    lblLocation: TLabel;
    lbl5: TLabel;
    lblOutDateTime: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDeviceGrid: TStringGrid;
    procedure RefreshStringGridFromDB;
    procedure InitUIContent;
  public
    { Public declarations }
    class function DisplayOutForm(AHandle: THandle; ADeviceGrid: TStringGrid): Boolean;
    property DeviceGrid: TStringGrid write FDeviceGrid;
  end;

implementation

uses
  uControlInf, uDBFieldData, uDefine, uTransform;

{$R *.dfm}

{ TDisplayDetailsForm }

class function TDisplayDetailsForm.DisplayOutForm(
  AHandle: THandle; ADeviceGrid: TStringGrid): Boolean;
var
  DisplayDetailsForm: TDisplayDetailsForm;
begin
  DisplayDetailsForm := TDisplayDetailsForm.Create(Application, AHandle);
  try
    DisplayDetailsForm.DeviceGrid := ADeviceGrid;
    if DisplayDetailsForm.ShowModal = mrOk then
    begin
      Result := True;
    end
    else
      Result := False;
  finally
    if Assigned(DisplayDetailsForm) then
      FreeAndNil(DisplayDetailsForm);
  end;
end;

procedure TDisplayDetailsForm.FormShow(Sender: TObject);
begin
  SetStringGridStyle(strngrdHistory);
  strngrdHistory.ColWidths[0] := 20;
  strngrdHistory.ColWidths[1] := 50;
  strngrdHistory.ColWidths[2] := 200;
  strngrdHistory.ColWidths[3] := 200;
  strngrdHistory.ColWidths[4] := 100;
  strngrdHistory.ColWidths[6] := 300;

  //界面显示内容初始化
  InitUIContent;

  //加载此设备的历史借用情况
  RefreshStringGridFromDB;
end;

procedure TDisplayDetailsForm.InitUIContent;
var
  iDeviceId: Integer;
begin
  iDeviceId := StrToInt(FDeviceGrid.Cells[1, FDeviceGrid.Row]);
  lblDeviceName.Caption := FDeviceGrid.Cells[3, FDeviceGrid.Row];
  //判断选中的设备是否为在库设备，未借用的设备不能执行下面的归还函数
  if gDatabaseControl.IsExistInDeviceLocationDB(iDeviceId) then
  begin
    lblStatus.Caption := '借出';
    lblStatus.Font.Color := clRed;
    lblOutDateTime.Caption := gDatabaseControl.GetOutTimeByDeviceId(iDeviceId);
  end
  else
  begin
    lblStatus.Caption := '在库';
    lblStatus.Font.Color := clLime;
    lblOutDateTime.Caption := EmptyStr;
  end;

  lblUserName.Caption := FDeviceGrid.Cells[12, FDeviceGrid.Row];
  lblLocation.Caption := FDeviceGrid.Cells[11, FDeviceGrid.Row];
end;

procedure TDisplayDetailsForm.RefreshStringGridFromDB;
var
  IXMLDBData: IXMLGuoSenDeviceSystemType;
  iDeviceId: Integer;
begin
  iDeviceId := StrToInt(FDeviceGrid.Cells[1, FDeviceGrid.Row]);
  CoInitialize(nil);
  IXMLDBData := NewGuoSenDeviceSystem;
  try
    IXMLDBData.DBData.OperaterType := 'Read';
    IXMLDBData.DBData.DBTable := CSUserDBName;
    IXMLDBData.DBData.SQL := Format('Select a.Id, a.StartDateTime, a.EndDateTime, a.Memo, b.Name as LocationName, c.UserName ' +
                                    ' From (DeviceHistoryInfo a left join LocationInfo b on (a.LocationId = b.Id)) left join UserInfo c on (a.UserId = c.Id) ' +
                                    ' where (a.DeviceId = %d) ', [iDeviceId]);

    //装载ColData的内容
    AddDeviceHistoryInfoColData(IXMLDBData);

    //从数据库中加载数据到RowData中
    gDatabaseControl.QueryDataByXMLData(IXMLDBData);

    //显示到StringGrid
    DisXMLDataToStringGrid(IXMLDBData, strngrdHistory);
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
end;

end.
