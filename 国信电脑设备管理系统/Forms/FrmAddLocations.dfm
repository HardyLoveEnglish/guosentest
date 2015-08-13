object AddLocationsForm: TAddLocationsForm
  Left = 421
  Top = 250
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #28155#21152#25918#32622#28857
  ClientHeight = 254
  ClientWidth = 276
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
    Width = 276
    Height = 254
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblAddress: TLabel
      Left = 28
      Top = 108
      Width = 63
      Height = 13
      Caption = #22320'         '#22336#65306
    end
    object lblLocationType: TLabel
      Left = 28
      Top = 34
      Width = 63
      Height = 13
      Caption = #31867'         '#22411#65306
    end
    object lblLocationName: TLabel
      Left = 28
      Top = 70
      Width = 63
      Height = 13
      Caption = #21517'         '#31216#65306
    end
    object cbbLocationType: TRzComboBox
      Left = 100
      Top = 30
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      FocusColor = clYellow
      ItemHeight = 16
      TabOnEnter = True
      TabOrder = 0
    end
    object mmoAddress: TRzMemo
      Left = 100
      Top = 100
      Width = 145
      Height = 72
      TabOrder = 2
      FocusColor = clYellow
      TabOnEnter = True
    end
    object btnOK: TRzBitBtn
      Left = 41
      Top = 203
      Caption = #30830'   '#23450
      HotTrack = True
      TabOrder = 3
      OnClick = btnOKClick
    end
    object btnCancel: TRzBitBtn
      Left = 154
      Top = 203
      Caption = #36820'   '#22238
      HotTrack = True
      TabOrder = 4
      OnClick = btnCancelClick
    end
    object edtLocationName: TRzEdit
      Left = 100
      Top = 66
      Width = 145
      Height = 21
      FocusColor = clYellow
      TabOnEnter = True
      TabOrder = 1
    end
  end
end
