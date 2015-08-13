object ModifyLocationForm: TModifyLocationForm
  Left = 388
  Top = 164
  Width = 340
  Height = 436
  Caption = #35774#22791#20511#29992
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
    Width = 324
    Height = 398
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblDeviceBrand: TLabel
      Left = 53
      Top = 65
      Width = 60
      Height = 13
      Caption = #35774#22791#21697#29260#65306
    end
    object lblDeviceModel: TLabel
      Left = 53
      Top = 105
      Width = 60
      Height = 13
      Caption = #35774#22791#22411#21495#65306
    end
    object lblLocation: TLabel
      Left = 53
      Top = 185
      Width = 60
      Height = 13
      Caption = #35774#22791#20301#32622#65306
    end
    object lblMemo: TLabel
      Left = 53
      Top = 265
      Width = 63
      Height = 13
      Caption = #22791'         '#27880#65306
    end
    object lblDeviceType: TLabel
      Left = 53
      Top = 25
      Width = 60
      Height = 13
      Caption = #35774#22791#31867#22411#65306
    end
    object lblFundCode: TLabel
      Left = 53
      Top = 225
      Width = 72
      Height = 13
      AutoSize = False
      Caption = #35774#22791#39046#29992#20154#65306
    end
    object lblSeqID: TLabel
      Left = 53
      Top = 145
      Width = 65
      Height = 13
      AutoSize = False
      Caption = #20986#21378#32534#21495#65306
    end
    object edtDeviceBrand: TRzEdit
      Left = 128
      Top = 65
      Width = 145
      Height = 21
      Text = #32852#24819
      Enabled = False
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 0
    end
    object edtDeviceModel: TRzEdit
      Left = 128
      Top = 105
      Width = 145
      Height = 21
      Enabled = False
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 1
    end
    object mmoOperation: TRzMemo
      Left = 128
      Top = 265
      Width = 145
      Height = 49
      TabOrder = 2
      FocusColor = clYellow
    end
    object rzbtbtnOK: TRzBitBtn
      Left = 57
      Top = 342
      Caption = #30830'   '#23450
      HotTrack = True
      TabOrder = 3
      OnClick = rzbtbtnOKClick
    end
    object rzbtbtnCancel: TRzBitBtn
      Left = 185
      Top = 342
      Caption = #36820'   '#22238
      HotTrack = True
      TabOrder = 4
      OnClick = rzbtbtnCancelClick
    end
    object edtDeviceType: TRzEdit
      Left = 128
      Top = 24
      Width = 145
      Height = 21
      Text = #26174#31034#22120
      Enabled = False
      FocusColor = clYellow
      TabOrder = 5
    end
    object edtSeqID: TRzEdit
      Left = 128
      Top = 144
      Width = 145
      Height = 21
      Enabled = False
      FocusColor = clYellow
      TabOrder = 6
    end
    object cbbLocation: TRzComboBox
      Left = 128
      Top = 184
      Width = 145
      Height = 21
      FocusColor = clYellow
      ItemHeight = 13
      TabOrder = 7
    end
    object cbbDeviceUser: TRzComboBox
      Left = 128
      Top = 224
      Width = 145
      Height = 21
      FocusColor = clYellow
      ItemHeight = 13
      TabOrder = 8
    end
  end
end
