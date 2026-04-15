object FormAnaliz: TFormAnaliz
  Left = 0
  Top = 0
  Caption = 'Analiz'
  ClientHeight = 700
  ClientWidth = 1200
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
    Width = 1200
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblStokKodu: TLabel
      Left = 16
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Stok Kodu:'
    end
    object LblStokAdi: TLabel
      Left = 16
      Top = 42
      Width = 48
      Height = 13
      Caption = 'Stok Adi:'
    end
    object LblTarih: TLabel
      Left = 400
      Top = 12
      Width = 28
      Height = 13
      Caption = 'Tarih:'
    end
    object txtStokKodu: TEdit
      Left = 80
      Top = 9
      Width = 150
      Height = 21
      TabOrder = 0
      OnChange = txtStokKoduChange
    end
    object txtSokAdi: TEdit
      Left = 80
      Top = 39
      Width = 300
      Height = 21
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 1
    end
    object txtTarih: TEdit
      Left = 440
      Top = 9
      Width = 120
      Height = 21
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 2
    end
    object btnKayit: TButton
      Left = 900
      Top = 8
      Width = 100
      Height = 60
      Caption = 'KAYDET'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnKayitClick
    end
    object btnCikis: TButton
      Left = 1010
      Top = 8
      Width = 100
      Height = 60
      Caption = 'KAPAT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btnCikisClick
    end
    object CmBProjeler: TButton
      Left = 250
      Top = 8
      Width = 130
      Height = 25
      Caption = 'Projeler'
      TabOrder = 5
      OnClick = CmBProjelerClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 80
    Width = 1200
    Height = 620
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Analiz'
      object GrpAnaliz: TGroupBox
        Left = 3
        Top = 3
        Width = 450
        Height = 580
        Caption = 'Maliyet Hesaplama'
        TabOrder = 0
        object LblMalzeme: TLabel
          Left = 16
          Top = 24
          Width = 85
          Height = 13
          Caption = 'Malzeme Toplam:'
        end
        object LblMgg: TLabel
          Left = 16
          Top = 54
          Width = 26
          Height = 13
          Caption = 'MGG:'
        end
        object LblNakliye: TLabel
          Left = 16
          Top = 84
          Width = 41
          Height = 13
          Caption = 'Nakliye:'
        end
        object LblIscilik: TLabel
          Left = 16
          Top = 114
          Width = 32
          Height = 13
          Caption = 'Iscilik:'
        end
        object LblKar: TLabel
          Left = 16
          Top = 144
          Width = 19
          Height = 13
          Caption = 'Kar:'
        end
        object LblToplam: TLabel
          Left = 16
          Top = 174
          Width = 39
          Height = 13
          Caption = 'Toplam:'
        end
        object Lbl485: TLabel
          Left = 16
          Top = 204
          Width = 64
          Height = 13
          Caption = '485 Toplam:'
        end
        object LblToplamSatis: TLabel
          Left = 16
          Top = 234
          Width = 87
          Height = 13
          Caption = 'Toplam Satis (€):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LblEskiFiyat: TLabel
          Left = 16
          Top = 264
          Width = 56
          Height = 13
          Caption = 'Eski Fiyat:'
        end
        object LblHedefFiyat: TLabel
          Left = 16
          Top = 294
          Width = 65
          Height = 13
          Caption = 'Hedef Fiyat:'
        end
        object LblUretimMik: TLabel
          Left = 16
          Top = 324
          Width = 73
          Height = 13
          Caption = 'Uretim Miktar:'
        end
        object LblNot: TLabel
          Left = 16
          Top = 354
          Width = 21
          Height = 13
          Caption = 'Not:'
        end
        object txtMalzemeTekinToplam: TEdit
          Left = 120
          Top = 21
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 0
        end
        object txtMggYuzde: TEdit
          Left = 120
          Top = 51
          Width = 60
          Height = 21
          TabOrder = 1
          Text = '0'
          OnChange = txtMggYuzdeChange
        end
        object txtMggHesap: TEdit
          Left = 200
          Top = 51
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 2
        end
        object txtNakliye: TEdit
          Left = 120
          Top = 81
          Width = 100
          Height = 21
          TabOrder = 3
          Text = '0'
          OnChange = txtNakliyeChange
        end
        object txtIscilikUcret: TEdit
          Left = 120
          Top = 111
          Width = 60
          Height = 21
          TabOrder = 4
          Text = '0'
          OnChange = txtIscilikUcretChange
        end
        object txtIscilikDakika: TEdit
          Left = 200
          Top = 111
          Width = 60
          Height = 21
          TabOrder = 5
          Text = '0'
          OnChange = txtIscilikDakikaChange
        end
        object txtIscilik: TEdit
          Left = 280
          Top = 111
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 6
        end
        object txtKarYuzde: TEdit
          Left = 120
          Top = 141
          Width = 60
          Height = 21
          TabOrder = 7
          Text = '0'
          OnChange = txtKarYuzdeChange
        end
        object txtKar: TEdit
          Left = 200
          Top = 141
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 8
        end
        object txtToplam: TEdit
          Left = 120
          Top = 171
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 9
        end
        object txt485Toplam: TEdit
          Left = 120
          Top = 201
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 10
        end
        object txtToplamSatis: TEdit
          Left = 120
          Top = 231
          Width = 120
          Height = 21
          Color = clYellow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 11
        end
        object txtEskiFiyat: TEdit
          Left = 120
          Top = 261
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 12
        end
        object txtHedefFiyat: TEdit
          Left = 120
          Top = 291
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 13
        end
        object TxtUretimMik: TEdit
          Left = 120
          Top = 321
          Width = 100
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 14
        end
        object TxtNot: TEdit
          Left = 120
          Top = 351
          Width = 300
          Height = 21
          TabOrder = 15
        end
        object TxtNot1: TMemo
          Left = 16
          Top = 385
          Width = 404
          Height = 180
          Color = clInfoBk
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 16
        end
      end
      object lstprojeler: TListView
        Left = 459
        Top = 3
        Width = 520
        Height = 290
        Columns = <>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
      end
      object ListViewFiyatListesi: TListView
        Left = 459
        Top = 299
        Width = 200
        Height = 284
        Columns = <>
        GridLines = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
        OnClick = ListViewFiyatListesiClick
      end
      object ListViewUretimMiktar: TListView
        Left = 665
        Top = 299
        Width = 314
        Height = 284
        Columns = <>
        GridLines = True
        RowSelect = True
        TabOrder = 3
        ViewStyle = vsReport
        OnDblClick = ListViewUretimMiktarDblClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Kayitlar'
      ImageIndex = 1
      object lst1: TListView
        Left = 0
        Top = 0
        Width = 1192
        Height = 592
        Align = alClient
        Columns = <>
        GridLines = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lst1DblClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Notlar'
      ImageIndex = 2
    end
  end
end
