object FormMiktarDegistirme: TFormMiktarDegistirme
  Left = 0
  Top = 0
  Caption = 'Miktar Degistirme'
  ClientHeight = 600
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlUst: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblArama: TLabel
      Left = 16
      Top = 12
      Width = 67
      Height = 13
      Caption = 'Malzeme Ara:'
    end
    object TxtMalzemeAra: TEdit
      Left = 96
      Top = 9
      Width = 300
      Height = 21
      TabOrder = 0
      OnChange = TxtMalzemeAraChange
    end
    object CommandButtonMalzemeCikar: TButton
      Left = 680
      Top = 8
      Width = 120
      Height = 60
      Caption = 'CIKAR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = CommandButtonMalzemeCikarClick
    end
    object CommandButtonMiktarDegistir: TButton
      Left = 810
      Top = 8
      Width = 120
      Height = 60
      Caption = 'MIKTAR DEGISTIR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = CommandButtonMiktarDegistirClick
    end
    object BtnKapat: TButton
      Left = 940
      Top = 8
      Width = 120
      Height = 60
      Caption = 'KAPAT'
      TabOrder = 3
      OnClick = BtnKapatClick
    end
  end
  object PnlSol: TPanel
    Left = 0
    Top = 80
    Width = 450
    Height = 520
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'PnlSol'
    TabOrder = 1
    object ListViewMalzemeAra: TListView
      Left = 0
      Top = 0
      Width = 450
      Height = 520
      Align = alClient
      Columns = <>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewMalzemeAraClick
    end
  end
  object PnlSag: TPanel
    Left = 450
    Top = 80
    Width = 650
    Height = 520
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PnlSag'
    TabOrder = 2
    object ListViewMalzemeGoster: TListView
      Left = 0
      Top = 0
      Width = 650
      Height = 520
      Align = alClient
      Checkboxes = True
      Columns = <>
      GridLines = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
