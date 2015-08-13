unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Menus, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TGXZHPCSysForm = class(TForm)
    Panel1: TPanel;
    btnBook: TBitBtn;
    btnQuery: TBitBtn;
    statFirst: TStatusBar;
    btnStatus: TBitBtn;
    tmr1: TTimer;
    pmSys: TPopupMenu;
    ChangePWD: TMenuItem;
    Exit: TMenuItem;
    SysSettings: TMenuItem;
    btnOperQuery: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBookClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure SysSettingsClick(Sender: TObject);
    procedure ChangePWDClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure btnOperQueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GXZHPCSysForm: TGXZHPCSysForm;

implementation

//uses BookOperationFrm, DMFrm, BookQueryFrm, ChangePWDFrm, SettingFrm, ViewHistoryFrm, ViewPersonalHistoryFrm, LoginFrm;

{$R *.dfm}

procedure TGXZHPCSysForm.FormShow(Sender: TObject);
begin
  btnStatus.Parent  := statFirst;
  btnStatus.Top     := 4;
  btnStatus.Visible := True;
  //statFirst.Panels[3].Text := DMForm.gblUserName;
  //if DMForm.gblUserRight <> 9 then pmSys.Items[0].Visible := False;
//  if LoginForm.gblUserRight < 3 then btnOperQuery.Enabled := False;
end;

procedure TGXZHPCSysForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  application.Terminate;
end;

procedure TGXZHPCSysForm.tmr1Timer(Sender: TObject);
begin
  statFirst.Panels[4].Text := DateTimeToStr(Now);
end;

procedure TGXZHPCSysForm.btnBookClick(Sender: TObject);
begin
  //BookOperationForm.ShowModal;
end;

procedure TGXZHPCSysForm.btnQueryClick(Sender: TObject);
begin
  //BookQueryForm.ShowModal;
end;

procedure TGXZHPCSysForm.btnStatusClick(Sender: TObject);
begin
  pmSys.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TGXZHPCSysForm.SysSettingsClick(Sender: TObject);
begin
  //SettingForm.ShowModal;
end;

procedure TGXZHPCSysForm.ChangePWDClick(Sender: TObject);
begin
  //ChangePWDForm.ShowModal;
end;

procedure TGXZHPCSysForm.ExitClick(Sender: TObject);
begin
  application.Terminate;
end;

procedure TGXZHPCSysForm.btnOperQueryClick(Sender: TObject);
begin
  //if DMForm.gblUserRight = 0 then ViewPersonalHistoryForm.ShowModal
  //else ViewHistoryForm.ShowModal;
end;

end.
