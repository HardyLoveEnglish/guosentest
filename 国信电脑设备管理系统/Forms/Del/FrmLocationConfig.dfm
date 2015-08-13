object LocationConfigForm: TLocationConfigForm
  Left = 196
  Top = 152
  Width = 880
  Height = 640
  Caption = 'LocationConfigForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 73
    Align = alTop
    TabOrder = 0
    object lbl1: TLabel
      Left = 296
      Top = 16
      Width = 241
      Height = 32
      AutoSize = False
      Caption = #35774#22791#25918#32622#28857#26597#35810
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
    Top = 73
    Width = 864
    Height = 375
    Align = alClient
    Caption = 'pnl2'
    TabOrder = 1
    object strngrdLocation: TStringGrid
      Left = 1
      Top = 1
      Width = 862
      Height = 373
      Align = alClient
      TabOrder = 0
    end
  end
  object pnl3: TPanel
    Left = 0
    Top = 448
    Width = 864
    Height = 154
    Align = alBottom
    TabOrder = 2
    object grpQuery: TGroupBox
      Left = 152
      Top = 10
      Width = 697
      Height = 128
      Caption = #37096#38376#21644#32593#28857#26597#35810
      TabOrder = 0
    end
    object grpDel: TGroupBox
      Left = 16
      Top = 74
      Width = 121
      Height = 64
      Caption = #21024#38500#37096#38376#21644#32593#28857
      TabOrder = 1
      object btnDel: TButton
        Left = 35
        Top = 24
        Width = 75
        Height = 27
        Caption = #21024#38500
        TabOrder = 0
      end
    end
    object grpAdd: TGroupBox
      Left = 16
      Top = 9
      Width = 121
      Height = 57
      Caption = #28155#21152#37096#38376#21644#32593#28857
      TabOrder = 2
      object btnAdd: TButton
        Left = 32
        Top = 24
        Width = 75
        Height = 25
        Caption = 'btnAdd'
        TabOrder = 0
        OnClick = btnAddClick
      end
    end
  end
end
