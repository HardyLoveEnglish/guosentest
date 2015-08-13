unit FrmDisplayDetails;

{��ʾ������Ϣ}

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

  //������ʾ���ݳ�ʼ��
  InitUIContent;

  //���ش��豸����ʷ�������
  RefreshStringGridFromDB;
end;

procedure TDisplayDetailsForm.InitUIContent;
var
  iDeviceId: Integer;
begin
  iDeviceId := StrToInt(FDeviceGrid.Cells[1, FDeviceGrid.Row]);
  lblDeviceName.Caption := FDeviceGrid.Cells[3, FDeviceGrid.Row];
  //�ж�ѡ�е��豸�Ƿ�Ϊ�ڿ��豸��δ���õ��豸����ִ������Ĺ黹����
  if gDatabaseControl.IsExistInDeviceLocationDB(iDeviceId) then
  begin
    lblStatus.Caption := '���';
    lblStatus.Font.Color := clRed;
    lblOutDateTime.Caption := gDatabaseControl.GetOutTimeByDeviceId(iDeviceId);
  end
  else
  begin
    lblStatus.Caption := '�ڿ�';
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

    //װ��ColData������
    AddDeviceHistoryInfoColData(IXMLDBData);

    //�����ݿ��м������ݵ�RowData��
    gDatabaseControl.QueryDataByXMLData(IXMLDBData);

    //��ʾ��StringGrid
    DisXMLDataToStringGrid(IXMLDBData, strngrdHistory);
  finally
    IXMLDBData := nil;
    CoUninitialize;
  end;   
end;

end.
