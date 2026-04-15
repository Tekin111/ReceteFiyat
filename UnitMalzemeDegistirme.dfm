object FormMalzemeDegistirme: TFormMalzemeDegistirme
  Left = 0
  Top = 0
  Caption = 'Malzeme Degistirme'
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
    object LblDegisecek: TLabel
      Left = 16
      Top = 12
      Width = 98
      Height = 13
      Caption = 'Degisecek Malzeme:'
    end
    object LblYeni: TLabel
      Left = 16
      Top = 42
      Width = 71
      Height = 13
      Caption = 'Yeni Malzeme:'
    end
    object TxtDegisecekMalzeme: TEdit
      Left = 120
      Top = 9
      Width = 300
      Height = 21
      TabOrder = 0
      OnChange = TxtDegisecekMalzemeChange
    end
    object TxtYeniMalzeme: TEdit
      Left = 120
      Top = 39
      Width = 300
      Height = 21
      TabOrder = 1
      OnChange = TxtYeniMalzemeChange
    end
    object BtnDegistir: TButton
      Left = 880
      Top = 8
      Width = 100
      Height = 60
      Caption = 'DEGISTIR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = BtnDegistirClick
    end
    object BtnKapat: TButton
      Left = 990
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
    Width = 380
    Height = 520
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'PnlSol'
    TabOrder = 1
    object ListViewDegisecekMalzeme: TListView
      Left = 0
      Top = 0
      Width = 380
      Height = 520
      Align = alClient
      Columns = <>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewDegisecekMalzemeClick
    end
  end
  object PnlOrta: TPanel
    Left = 380
    Top = 80
    Width = 380
    Height = 520
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'PnlOrta'
    TabOrder = 2
    object ListViewYeniMalzeme: TListView
      Left = 0
      Top = 0
      Width = 380
      Height = 520
      Align = alClient
      Columns = <>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewYeniMalzemeClick
    end
  end
  object PnlSag: TPanel
    Left = 760
    Top = 80
    Width = 340
    Height = 520
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PnlSag'
    TabOrder = 3
    object ListView4: TListView
      Left = 0
      Top = 0
      Width = 340
      Height = 520
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
