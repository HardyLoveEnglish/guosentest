object AddDevicesForm: TAddDevicesForm
  Left = 421
  Top = 250
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #28155#21152#35774#22791
  ClientHeight = 362
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 338
    Height = 362
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblBrand: TLabel
      Left = 48
      Top = 54
      Width = 60
      Height = 13
      Caption = #35774#22791#21697#29260#65306
    end
    object lblModel: TLabel
      Left = 48
      Top = 85
      Width = 60
      Height = 13
      Caption = #35774#22791#22411#21495#65306
    end
    object lblCount: TLabel
      Left = 48
      Top = 180
      Width = 42
      Height = 13
      Caption = #25968'  '#37327#65306
    end
    object lblMemo: TLabel
      Left = 48
      Top = 249
      Width = 63
      Height = 13
      Caption = #22791'         '#27880#65306
    end
    object lblDeviceType: TLabel
      Left = 48
      Top = 24
      Width = 60
      Height = 13
      Caption = #35774#22791#31867#22411#65306
    end
    object lblDeviceMAC: TLabel
      Left = 48
      Top = 211
      Width = 59
      Height = 13
      Caption = #35774#22791'MAC'#65306
    end
    object lblSeqID: TLabel
      Left = 48
      Top = 117
      Width = 60
      Height = 13
      Caption = #20986#21378#32534#21495#65306
    end
    object lblBirDate: TLabel
      Left = 48
      Top = 149
      Width = 60
      Height = 13
      Caption = #29983#20135#26085#26399#65306
    end
    object cbbDeviceType: TRzComboBox
      Left = 120
      Top = 20
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      FocusColor = clYellow
      ItemHeight = 16
      TabOnEnter = True
      TabOrder = 0
    end
    object cbBrand: TRzComboBox
      Left = 120
      Top = 51
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      FocusColor = clYellow
      ItemHeight = 16
      TabOnEnter = True
      TabOrder = 1
    end
    object edtModel: TRzEdit
      Left = 120
      Top = 82
      Width = 145
      Height = 21
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 2
    end
    object edtSeqID: TRzEdit
      Left = 120
      Top = 113
      Width = 145
      Height = 21
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 3
    end
    object mmoDeviceInfo: TRzMemo
      Left = 120
      Top = 241
      Width = 145
      Height = 49
      TabOrder = 7
      FocusColor = clYellow
      TabOnEnter = True
    end
    object btnOK: TRzBitBtn
      Left = 32
      Top = 313
      Caption = #30830'   '#23450
      HotTrack = True
      TabOrder = 8
      OnClick = btnOKClick
    end
    object btnReset: TRzBitBtn
      Left = 136
      Top = 313
      Caption = #37325'   '#32622
      HotTrack = True
      TabOrder = 9
      OnClick = btnResetClick
    end
    object btnCancel: TRzBitBtn
      Left = 240
      Top = 313
      Caption = #36820'   '#22238
      HotTrack = True
      TabOrder = 10
      OnClick = btnCancelClick
    end
    object edtDeviceMAC: TRzEdit
      Left = 120
      Top = 207
      Width = 145
      Height = 21
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 6
    end
    object edtBirDate: TRzDateTimeEdit
      Left = 120
      Top = 144
      Width = 145
      Height = 21
      EditType = etDate
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 4
    end
    object edtCount: TRzSpinEdit
      Left = 120
      Top = 175
      Width = 145
      Height = 21
      Min = 1.000000000000000000
      Value = 1.000000000000000000
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 5
    end
  end
end
