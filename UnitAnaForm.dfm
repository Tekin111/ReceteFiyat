object AnaForm: TAnaForm
  Left = 0
  Top = 0
  Caption = 'ANA FORM'
  ClientHeight = 480
  ClientWidth = 680
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PnlBaslik: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = 6316128
    ParentBackground = False
    TabOrder = 0
    object LblBaslik: TLabel
      Left = 0
      Top = 0
      Width = 680
      Height = 70
      Align = alClient
      Alignment = taCenter
      Caption = 'RECETE VE FIYATLANDIRMA PROGRAMI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 65408
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object CmdProjeler: TButton
    Left = 40
    Top = 100
    Width = 160
    Height = 60
    Caption = 'PROJELER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = CmdProJelerClick
  end
  object CmdAnaliz1: TButton
    Left = 250
    Top = 100
    Width = 160
    Height = 60
    Caption = 'ANALIZ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = CmdAnaliz1Click
  end
  object CmdArama: TButton
    Left = 460
    Top = 100
    Width = 160
    Height = 60
    Caption = 'ARAMA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = CmdAramaClick
  end
  object CmdMalzemeDegistirme: TButton
    Left = 40
    Top = 180
    Width = 200
    Height = 60
    Caption = 'MALZEME DEGISTIRME'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = CmdMalzemeDegistirmeClick
  end
  object CmdMalzemeEkle: TButton
    Left = 270
    Top = 180
    Width = 160
    Height = 60
    Caption = 'MALZEME EKLE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = CmdMalzemeEkleClick
  end
  object CmdReceteler: TButton
    Left = 460
    Top = 180
    Width = 160
    Height = 60
    Caption = 'RECETELERI EKLE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = CmdRecetelerClick
  end
  object CmdMalzemeMiktarDegistirme: TButton
    Left = 40
    Top = 260
    Width = 200
    Height = 60
    Caption = 'MIKTAR DEGISTIRME'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = CmdMalzemeMiktarDegistirmeClick
  end
  object CmbTreceteler: TButton
    Left = 280
    Top = 360
    Width = 160
    Height = 50
    Caption = 'TUM RECETELER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = CmbTrecetelerClick
  end
  object CmbBilgiler: TButton
    Left = 460
    Top = 360
    Width = 160
    Height = 50
    Caption = 'BILGILER SAYFASI'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = CmbBilgilerClick
  end
end
