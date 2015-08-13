object DisplayLocationForm: TDisplayLocationForm
  Left = 255
  Top = 180
  Width = 909
  Height = 640
  Caption = #35774#22791#24402#23646#26597#35810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 893
    Height = 602
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl1'
    TabOrder = 0
    object dbgrdh1: TDBGridEh
      Left = 0
      Top = 57
      Width = 893
      Height = 440
      Align = alTop
      DataGrouping.GroupLevels = <>
      Flat = False
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      OddRowColor = clSkyBlue
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      RowDetailPanel.Color = clBtnFace
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #24207#21495
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #35774#22791#31867#22411
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #35774#22791#24207#21015#21495
          Width = 72
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #21697#29260
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #22411#21495
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #20986#21378#32534#21495
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #20986#21378#26085#26399
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = 'MAC'#22320#22336
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #32593#28857#21517#31216
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #32593#28857#22320#22336
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #35774#22791#31649#29702#20154
          Width = 80
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #22791#27880
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Caption = #20837#24211#26102#38388
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object pnl2: TPanel
      Left = 0
      Top = 0
      Width = 893
      Height = 57
      Align = alTop
      Caption = 'pnl2'
      TabOrder = 1
      object lbl1: TLabel
        Left = 352
        Top = 8
        Width = 169
        Height = 32
        AutoSize = False
        Caption = #20301#32622#28857#26597#35810
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
