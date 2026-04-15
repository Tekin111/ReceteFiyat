object FormMalzemeEkle: TFormMalzemeEkle
  Left = 0
  Top = 0
  Caption = 'Malzeme Ekle'
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
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblMalzeme: TLabel
      Left = 16
      Top = 12
      Width = 95
      Height = 13
      Caption = 'Eklenecek Malzeme:'
    end
    object LblProje: TLabel
      Left = 16
      Top = 42
      Width = 55
      Height = 13
      Caption = 'Proje Ara:'
    end
    object TxtEklenecekMalzeme: TEdit
      Left = 120
      Top = 9
      Width = 300
      Height = 21
      TabOrder = 0
      OnChange = TxtEklenecekMalzemeChange
    end
    object TextProjeler: TEdit
      Left = 120
      Top = 39
      Width = 300
      Height = 21
      TabOrder = 1
      OnChange = TextProjelerChange
    end
    object CommandButtonMalzemeEkle: TButton
      Left = 680
      Top = 8
      Width = 100
      Height = 60
      Caption = 'EKLE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = CommandButtonMalzemeEkleClick
    end
    object BtnKapat: TButton
      Left = 790
      Top = 8
      Width = 100
      Height = 60
      Caption = 'KAPAT'
      TabOrder = 3
      OnClick = BtnKapatClick
    end
  end
  object PnlSol: TPanel
    Left = 0
    Top = 80
    Width = 470
    Height = 520
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'PnlSol'
    TabOrder = 1
    object ListViewMalzemeEklenecek: TListView
      Left = 0
      Top = 0
      Width = 470
      Height = 520
      Align = alClient
      Columns = <>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewMalzemeEklenecekClick
    end
  end
  object PnlSag: TPanel
    Left = 470
    Top = 80
    Width = 430
    Height = 520
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PnlSag'
    TabOrder = 2
    object ListViewProjeListesi: TListView
      Left = 0
      Top = 0
      Width = 430
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
