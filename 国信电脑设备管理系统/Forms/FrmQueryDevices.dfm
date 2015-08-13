object QueryDevicesForm: TQueryDevicesForm
  Left = 204
  Top = 162
  Width = 1027
  Height = 694
  Caption = #35774#22791#26597#35810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 1019
    Height = 667
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnl2: TPanel
      Left = 0
      Top = 0
      Width = 1019
      Height = 57
      Align = alTop
      TabOrder = 0
      object lbl1: TLabel
        Left = 454
        Top = 12
        Width = 153
        Height = 32
        AutoSize = False
        Caption = #35774#22791#26597#35810
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object strngrdDeviceQry: TStringGrid
      Left = 0
      Top = 57
      Width = 1019
      Height = 434
      Align = alClient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 1
      OnMouseDown = strngrdDeviceQryMouseDown
    end
    object pnl3: TPanel
      Left = 0
      Top = 491
      Width = 1019
      Height = 176
      Align = alBottom
      TabOrder = 2
      object grpAdd: TGroupBox
        Left = 16
        Top = 9
        Width = 106
        Height = 57
        Caption = #28155#21152#35774#22791
        TabOrder = 0
        object btnAdd: TButton
          Left = 21
          Top = 19
          Width = 75
          Height = 27
          Caption = #35774#22791#20837#24211
          TabOrder = 0
          OnClick = btnAddClick
        end
      end
      object grpDel: TGroupBox
        Left = 16
        Top = 72
        Width = 105
        Height = 64
        Caption = #21024#38500#35774#22791
        TabOrder = 1
        object btnDel: TButton
          Left = 21
          Top = 24
          Width = 75
          Height = 27
          Caption = #35774#22791#25253#24223
          TabOrder = 0
          OnClick = btnDelClick
        end
      end
      object grpModify: TGroupBox
        Left = 128
        Top = 9
        Width = 137
        Height = 57
        Caption = #20462#25913#35774#22791
        TabOrder = 2
        object btnModify: TButton
          Left = 17
          Top = 19
          Width = 104
          Height = 28
          Caption = #35774#22791#20449#24687#20462#25913
          TabOrder = 0
        end
      end
      object grpDisDetail: TGroupBox
        Left = 128
        Top = 72
        Width = 137
        Height = 65
        Caption = #35774#22791#24402#23646#35814#32454#20449#24687
        TabOrder = 3
        object btnDisDetail: TButton
          Left = 17
          Top = 24
          Width = 104
          Height = 28
          Caption = #26174#31034#24402#23646#20449#24687
          TabOrder = 0
          OnClick = btnDisDetailClick
        end
      end
      object grpQuery: TGroupBox
        Left = 392
        Top = 8
        Width = 609
        Height = 128
        Caption = #35774#22791#26597#35810
        TabOrder = 4
      end
      object statDevice: TStatusBar
        Left = 1
        Top = 142
        Width = 1017
        Height = 33
        Panels = <
          item
            Width = 75
          end
          item
            Width = 800
          end
          item
            Width = 50
          end>
      end
      object btnSetting: TBitBtn
        Left = 3
        Top = 148
        Width = 70
        Height = 24
        Caption = #31995#32479#35774#32622
        TabOrder = 6
        OnClick = btnSettingClick
      end
      object grpIO: TGroupBox
        Left = 271
        Top = 9
        Width = 114
        Height = 128
        Caption = #35774#22791#20511#29992#21644#24402#36824
        TabOrder = 7
        object btnOutput: TButton
          Left = 12
          Top = 32
          Width = 89
          Height = 25
          Caption = #35774#22791#20511#29992
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnOutputClick
        end
        object btnInput: TButton
          Left = 11
          Top = 80
          Width = 90
          Height = 25
          Caption = #35774#22791#24402#36824
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnInputClick
        end
      end
    end
  end
  object tmrDateTime: TTimer
    OnTimer = tmrDateTimeTimer
    Left = 256
    Top = 625
  end
  object pmSys: TPopupMenu
    Left = 160
    Top = 626
    object mniDBConfig: TMenuItem
      Caption = #25968#25454#24211#35774#32622
      OnClick = mniDBConfigClick
    end
    object mniLocationConfig: TMenuItem
      Caption = #25918#32622#28857#35774#32622
      OnClick = mniLocationConfigClick
    end
    object mniUserConfig: TMenuItem
      Caption = #20351#29992#20154#35774#32622
      OnClick = mniUserConfigClick
    end
  end
end
