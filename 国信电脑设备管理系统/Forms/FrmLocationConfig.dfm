object LocationConfigForm: TLocationConfigForm
  Left = 319
  Top = 169
  Width = 718
  Height = 556
  Caption = #25918#32622#28857#26597#35810
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
    Width = 702
    Height = 73
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 217
      Top = 16
      Width = 281
      Height = 37
      AutoSize = False
      Caption = #35774#32622#25918#32622#28857#26597#35810
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -33
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 73
    Width = 702
    Height = 311
    Align = alClient
    TabOrder = 1
    object strngrdLocation: TStringGrid
      Left = 1
      Top = 1
      Width = 700
      Height = 309
      Align = alClient
      TabOrder = 0
    end
  end
  object pnl3: TPanel
    Left = 0
    Top = 384
    Width = 702
    Height = 134
    Align = alBottom
    TabOrder = 2
    object grpAdd: TGroupBox
      Left = 8
      Top = 8
      Width = 120
      Height = 55
      Caption = #28155#21152#37096#38376#21644#32593#28857
      TabOrder = 0
      object btnAdd: TButton
        Left = 32
        Top = 20
        Width = 75
        Height = 25
        Caption = #28155#21152
        TabOrder = 0
        OnClick = btnAddClick
      end
    end
    object grpDel: TGroupBox
      Left = 8
      Top = 70
      Width = 121
      Height = 57
      Caption = #21024#38500#37096#38376#21644#32593#28857
      TabOrder = 1
      object btnDel: TButton
        Left = 32
        Top = 23
        Width = 75
        Height = 25
        Caption = #21024#38500
        TabOrder = 0
        OnClick = btnDelClick
      end
    end
    object grpQuery: TGroupBox
      Left = 139
      Top = 5
      Width = 553
      Height = 122
      Caption = #26597#35810#37096#38376#21644#32593#28857
      TabOrder = 2
    end
  end
end
