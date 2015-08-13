unit FrmDisplayLocation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, StdCtrls, GridsEh, DBGridEh, ExtCtrls, FrmBase;

type
  TDisplayLocationForm = class(TBaseForm)
    pnl1: TPanel;
    dbgrdh1: TDBGridEh;
    pnl2: TPanel;
    lbl1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DisplayLocationForm: TDisplayLocationForm;

implementation

{$R *.dfm}

end.
