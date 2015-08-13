object DisplayDetailsForm: TDisplayDetailsForm
  Left = 207
  Top = 137
  Width = 1014
  Height = 737
  Caption = 'DisplayDetailsForm'
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
    Width = 1006
    Height = 710
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl1'
    TabOrder = 0
    object pnl2: TPanel
      Left = 0
      Top = 0
      Width = 1006
      Height = 121
      Align = alTop
      TabOrder = 0
      object lblDeviceName: TLabel
        Left = 184
        Top = 16
        Width = 105
        Height = 32
        AutoSize = False
        Caption = #36335#30001#22120
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl1: TLabel
        Left = 32
        Top = 16
        Width = 145
        Height = 32
        AutoSize = False
        Caption = #35774#22791#31867#22411#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lbl2: TLabel
        Left = 387
        Top = 16
        Width = 145
        Height = 32
        AutoSize = False
        Caption = #35774#22791#29366#24577#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblStatus: TLabel
        Left = 531
        Top = 15
        Width = 81
        Height = 32
        AutoSize = False
        Caption = #20511#20986
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl3: TLabel
        Left = 677
        Top = 16
        Width = 177
        Height = 32
        AutoSize = False
        Caption = #24403#21069#20351#29992#20154#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblUserName: TLabel
        Left = 853
        Top = 16
        Width = 132
        Height = 32
        AutoSize = False
        Caption = #35874#20255
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl4: TLabel
        Left = 547
        Top = 72
        Width = 144
        Height = 32
        AutoSize = False
        Caption = #35774#22791#20301#32622#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblLocation: TLabel
        Left = 695
        Top = 72
        Width = 290
        Height = 32
        AutoSize = False
        Caption = #30005#33041#31185
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl5: TLabel
        Left = 32
        Top = 72
        Width = 145
        Height = 32
        AutoSize = False
        Caption = #39046#20986#26102#38388#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblOutDateTime: TLabel
        Left = 179
        Top = 71
        Width = 262
        Height = 32
        AutoSize = False
        Caption = '2015-04-26 17:43:48'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object strngrdHistory: TStringGrid
      Left = 0
      Top = 121
      Width = 1006
      Height = 442
      Align = alClient
      ColCount = 7
      TabOrder = 1
      RowHeights = (
        24
        24
        24
        24
        24)
    end
    object pnl3: TPanel
      Left = 0
      Top = 563
      Width = 1006
      Height = 147
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 2
    end
  end
end
