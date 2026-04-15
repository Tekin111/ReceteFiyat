object FormProjeler: TFormProjeler
  Left = 0
  Top = 0
  Caption = 'Projeler'
  ClientHeight = 550
  ClientWidth = 750
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
    Width = 750
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblArama: TLabel
      Left = 16
      Top = 18
      Width = 74
      Height = 13
      Caption = 'Proje Ara/Filtre:'
    end
    object TextBox1: TEdit
      Left = 96
      Top = 15
      Width = 300
      Height = 21
      TabOrder = 0
      OnChange = TextBox1Change
    end
    object BtnKapat: TButton
      Left = 640
      Top = 10
      Width = 90
      Height = 35
      Caption = 'Kapat'
      TabOrder = 1
      OnClick = BtnKapatClick
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 60
    Width = 750
    Height = 490
    Align = alClient
    Columns = <>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
  end
end
