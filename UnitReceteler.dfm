object FormReceteler: TFormReceteler
  Left = 0
  Top = 0
  Caption = 'Receteler'
  ClientHeight = 600
  ClientWidth = 800
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
    Width = 800
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object cmdYukle: TButton
      Left = 16
      Top = 10
      Width = 120
      Height = 60
      Caption = 'CSV YUKLE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = cmdYukleClick
    end
    object cmdSil: TButton
      Left = 150
      Top = 10
      Width = 120
      Height = 60
      Caption = 'SIL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = cmdSilClick
    end
    object cmdKaydet: TButton
      Left = 284
      Top = 10
      Width = 120
      Height = 60
      Caption = 'CSV KAYDET'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = cmdKaydetClick
    end
    object BtnKapat: TButton
      Left = 670
      Top = 10
      Width = 120
      Height = 60
      Caption = 'KAPAT'
      TabOrder = 3
      OnClick = BtnKapatClick
    end
  end
  object ListViewReceteler: TListView
    Left = 0
    Top = 80
    Width = 800
    Height = 520
    Align = alClient
    Checkboxes = True
    Columns = <>
    GridLines = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = ListViewRecetelerDblClick
  end
end
