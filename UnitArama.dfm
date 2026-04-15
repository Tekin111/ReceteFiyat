object FormArama: TFormArama
  Left = 0
  Top = 0
  Caption = 'Arama'
  ClientHeight = 600
  ClientWidth = 900
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
    Width = 900
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblArama: TLabel
      Left = 16
      Top = 18
      Width = 67
      Height = 13
      Caption = 'Malzeme Ara:'
    end
    object TxtMalzeme: TEdit
      Left = 96
      Top = 15
      Width = 300
      Height = 21
      TabOrder = 0
      OnChange = TxtMalzemeChange
    end
    object BtnKapat: TButton
      Left = 790
      Top = 10
      Width = 90
      Height = 35
      Caption = 'Kapat'
      TabOrder = 1
      OnClick = BtnKapatClick
    end
  end
  object PnlSol: TPanel
    Left = 0
    Top = 60
    Width = 470
    Height = 540
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'PnlSol'
    TabOrder = 1
    object ListViewFiyat: TListView
      Left = 0
      Top = 0
      Width = 470
      Height = 540
      Align = alClient
      Columns = <>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewFiyatClick
    end
  end
  object PnlSag: TPanel
    Left = 470
    Top = 60
    Width = 430
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PnlSag'
    TabOrder = 2
    object ListView2: TListView
      Left = 0
      Top = 0
      Width = 430
      Height = 540
      Align = alClient
      Columns = <>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
