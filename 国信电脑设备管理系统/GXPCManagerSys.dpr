program GXPCManagerSys;

uses
  Forms,
  FrmMain in 'Forms\FrmMain.pas' {Form1},
  uDBInf in 'DBInf\uDBInf.pas',
  uControlInf in 'ControlInf\uControlInf.pas',
  FrmAddDevices in 'Forms\FrmAddDevices.pas' {Form2},
  FrmQueryDevices in 'Forms\FrmQueryDevices.pas' {QueryDevicesForm},
  FrmDisplayDetails in 'Forms\FrmDisplayDetails.pas' {DisplayDetailsForm},
  FrmBase in 'Forms\FrmBase.pas' {BaseForm},
  FrmModifyLocation in 'Forms\FrmModifyLocation.pas' {ModifyLocationForm},
  uDefine in 'uDefine.pas',
  uDBFieldData in 'uDBFieldData.pas',
  uTransform in 'uTransform.pas',
  FrmDBConfig in 'Forms\FrmDBConfig.pas' {DBConfigForm},
  FrmAddLocations in 'Forms\FrmAddLocations.pas' {AddLocationsForm},
  FrmLocationConfig in 'Forms\FrmLocationConfig.pas' {LocationConfigForm},
  FrmUserConfig in 'Forms\FrmUserConfig.pas' {UserConfigForm},
  FrmAddUsers in 'Forms\FrmAddUsers.pas' {AddUsersForm};

{$R *.res}

begin
  Application.Initialize;
  //Application.CreateForm(TGXZHPCSysForm, GXZHPCSysForm);
  Application.CreateForm(TQueryDevicesForm, QueryDevicesForm);
  Application.Run;
end.
