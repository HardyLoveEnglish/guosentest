object GXZHPCSysForm: TGXZHPCSysForm
  Left = 335
  Top = 335
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22269#20449#29664#28023#35774#22791#31649#29702#31995#32479
  ClientHeight = 190
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 459
    Height = 190
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      459
      190)
    object btnBook: TBitBtn
      Left = 8
      Top = 16
      Width = 137
      Height = 137
      Caption = #28155#21152#35774#22791
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnBookClick
    end
    object btnQuery: TBitBtn
      Left = 160
      Top = 16
      Width = 137
      Height = 137
      Caption = #35774#22791#24402#23646#26356#25913
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnQueryClick
    end
    object statFirst: TStatusBar
      Left = 0
      Top = 167
      Width = 459
      Height = 23
      Panels = <
        item
          Width = 50
        end
        item
          Width = 110
        end
        item
          Alignment = taCenter
          Text = #25805#20316#21592
          Width = 50
        end
        item
          Width = 75
        end
        item
          Alignment = taRightJustify
          Width = 30
        end>
    end
    object btnStatus: TBitBtn
      Left = 2
      Top = 172
      Width = 46
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #31995#32479
      Default = True
      PopupMenu = pmSys
      TabOrder = 4
      OnClick = btnStatusClick
    end
    object btnOperQuery: TBitBtn
      Left = 312
      Top = 16
      Width = 137
      Height = 137
      Caption = #35774#22791#26597#35810
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnOperQueryClick
    end
  end
  object tmr1: TTimer
    OnTimer = tmr1Timer
    Top = 112
  end
  object pmSys: TPopupMenu
    AutoPopup = False
    Top = 144
    object SysSettings: TMenuItem
      Caption = #31995#32479#35774#32622
      OnClick = SysSettingsClick
    end
    object ChangePWD: TMenuItem
      Caption = #23494#30721#20462#25913
      OnClick = ChangePWDClick
    end
    object Exit: TMenuItem
      Caption = #36864'    '#20986
      OnClick = ExitClick
    end
  end
end
