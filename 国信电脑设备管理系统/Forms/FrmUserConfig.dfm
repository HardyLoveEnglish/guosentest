object UserConfigForm: TUserConfigForm
  Left = 276
  Top = 249
  Width = 666
  Height = 482
  Caption = 'UserConfigForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 650
    Height = 65
    Align = alTop
    TabOrder = 0
    object lbl1: TLabel
      Left = 264
      Top = 16
      Width = 105
      Height = 32
      AutoSize = False
      Caption = #20351#29992#20154
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 65
    Width = 650
    Height = 271
    Align = alClient
    Caption = 'pnl2'
    TabOrder = 1
    object strngrdUser: TStringGrid
      Left = 1
      Top = 1
      Width = 648
      Height = 269
      Align = alClient
      TabOrder = 0
    end
  end
  object pnl3: TPanel
    Left = 0
    Top = 336
    Width = 650
    Height = 108
    Align = alBottom
    TabOrder = 2
    object grpAddOrDel: TGroupBox
      Left = 16
      Top = 8
      Width = 113
      Height = 89
      Caption = #22686#21024
      TabOrder = 0
      object btnAdd: TButton
        Left = 32
        Top = 20
        Width = 65
        Height = 25
        Caption = #28155#21152
        TabOrder = 0
        OnClick = btnAddClick
      end
      object btnDel: TButton
        Left = 32
        Top = 54
        Width = 65
        Height = 25
        Caption = #21024#38500
        TabOrder = 1
      end
    end
    object grpQuery: TGroupBox
      Left = 144
      Top = 8
      Width = 497
      Height = 89
      Caption = #26597#35810
      TabOrder = 1
    end
  end
end
