unit FrmBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDefine;

type
  TBaseForm = class(TForm)
  private
    { Private declarations }
  protected
    FParHandle: THandle;
    {* ÌáÊ¾¿ò *}
    procedure InfoBox(AText: string);
    procedure ErrorBox(AText: string);
    function AskBox(AText: string): Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AHandle: THandle = 0); reintroduce;
  end;

var
  BaseForm: TBaseForm;

implementation

{$R *.dfm}

{ TBaseForm }

function TBaseForm.AskBox(AText: string): Boolean;
begin
  if MessageBox(Handle, PChar(AText), CAsk, MB_ICONQUESTION + MB_YESNO) = mrYes then
    Result := True
  else
    Result := False;
end;

constructor TBaseForm.Create(AOwner: TComponent; AHandle: THandle);
begin
  FParHandle := AHandle;
  inherited Create(AOwner);
end;

procedure TBaseForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := FParHandle;
end;

procedure TBaseForm.ErrorBox(AText: string);
begin
  MessageBox(Handle, PChar(AText), CError, MB_ICONERROR);
end;

procedure TBaseForm.InfoBox(AText: string);
begin
  MessageBox(Handle, PChar(AText), CHint, MB_ICONINFORMATION);
end;

end.
