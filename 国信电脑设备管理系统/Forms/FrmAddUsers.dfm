object AddUsersForm: TAddUsersForm
  Left = 421
  Top = 270
  Width = 290
  Height = 270
  Caption = 'AddUsersForm'
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
    Width = 274
    Height = 232
    Align = alClient
    TabOrder = 0
    object lblLocation: TLabel
      Left = 29
      Top = 24
      Width = 60
      Height = 13
      Caption = #22330#20869#37096#38376#65306
    end
    object lblUserID: TLabel
      Left = 29
      Top = 72
      Width = 59
      Height = 13
      Caption = #21592#24037'ID'#21495#65306
    end
    object lblUserName: TLabel
      Left = 29
      Top = 120
      Width = 60
      Height = 13
      Caption = #21592#24037#22995#21517#65306
    end
    object rzbtbtnOK: TRzBitBtn
      Left = 48
      Top = 184
      Width = 65
      Caption = #30830#23450
      HotTrack = True
      TabOrder = 3
      OnClick = rzbtbtnOKClick
    end
    object rzbtbtnCancel: TRzBitBtn
      Left = 160
      Top = 184
      Width = 65
      Caption = #36820#22238
      HotTrack = True
      TabOrder = 4
      OnClick = rzbtbtnCancelClick
    end
    object cbbLocation: TRzComboBox
      Left = 101
      Top = 24
      Width = 145
      Height = 21
      FocusColor = clYellow
      ItemHeight = 13
      TabOrder = 0
    end
    object edtUserID: TRzEdit
      Left = 101
      Top = 72
      Width = 145
      Height = 21
      FocusColor = clYellow
      TabOrder = 1
    end
    object edtUserName: TRzEdit
      Left = 101
      Top = 120
      Width = 145
      Height = 21
      FocusColor = clYellow
      TabOrder = 2
    end
  end
end
