unit UnitAnaliz;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormAnaliz = class(TForm)
    PnlUst: TPanel;
    LblStokKodu: TLabel;
    txtStokKodu: TEdit;
    LblStokAdi: TLabel;
    txtSokAdi: TEdit;
    LblTarih: TLabel;
    txtTarih: TEdit;
    btnKayit: TButton;
    btnCikis: TButton;
    CmBProjeler: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GrpAnaliz: TGroupBox;
    LblMalzeme: TLabel;
    txtMalzemeTekinToplam: TEdit;
    LblMgg: TLabel;
    txtMggYuzde: TEdit;
    txtMggHesap: TEdit;
    LblNakliye: TLabel;
    txtNakliye: TEdit;
    LblIscilik: TLabel;
    txtIscilikDakika: TEdit;
    txtIscilikUcret: TEdit;
    txtIscilik: TEdit;
    LblKar: TLabel;
    txtKarYuzde: TEdit;
    txtKar: TEdit;
    LblToplam: TLabel;
    txtToplam: TEdit;
    Lbl485: TLabel;
    txt485Toplam: TEdit;
    LblToplamSatis: TLabel;
    txtToplamSatis: TEdit;
    LblEskiFiyat: TLabel;
    txtEskiFiyat: TEdit;
    LblHedefFiyat: TLabel;
    txtHedefFiyat: TEdit;
    LblUretimMik: TLabel;
    TxtUretimMik: TEdit;
    LblNot: TLabel;
    TxtNot: TEdit;
    TxtNot1: TMemo;
    lst1: TListView;
    lstprojeler: TListView;
    ListViewUretimMiktar: TListView;
    ListViewFiyatListesi: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtStokKoduChange(Sender: TObject);
    procedure txtMggYuzdeChange(Sender: TObject);
    procedure txtNakliyeChange(Sender: TObject);
    procedure txtIscilikDakikaChange(Sender: TObject);
    procedure txtIscilikUcretChange(Sender: TObject);
    procedure txtKarYuzdeChange(Sender: TObject);
    procedure btnKayitClick(Sender: TObject);
    procedure btnCikisClick(Sender: TObject);
    procedure CmBProjelerClick(Sender: TObject);
    procedure lst1DblClick(Sender: TObject);
    procedure ListViewFiyatListesiClick(Sender: TObject);
    procedure ListViewUretimMiktarDblClick(Sender: TObject);
  private
    FSeciliFiyatListesi: string;
    procedure FiyatListeleriniYukle;
    procedure UretimMiktarYukle;
    procedure Temizle;
    procedure FiyatHesapla;
    procedure MggHesapla;
    procedure IscilikHesapla;
    procedure KarHesapla;
    procedure SatisFiyatiBul;
    procedure HedefFiyatAra;
    procedure NotlarıGoster;
    procedure AnalizKayitlariniYukle;
    procedure ReceteListesiDoldur;
    procedure ListViewAyarla;
    procedure LstProJelerAyarla;
  public
    procedure ProjeKoduAta(const ProjeNo: string);
  end;

var
  FormAnaliz: TFormAnaliz;

implementation

{$R *.dfm}

uses UnitProjeler;

procedure TFormAnaliz.FormCreate(Sender: TObject);
begin
  FSeciliFiyatListesi := 'TFIYAT';
  ListViewAyarla;
  LstProJelerAyarla;
  FiyatListeleriniYukle;
  UretimMiktarYukle;

  with ListViewFiyatListesi do
  begin
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Columns.Clear;
    with Columns.Add do begin Caption := 'Sira'; Width := 40; end;
    with Columns.Add do begin Caption := 'Sayfa Adi'; Width := 130; end;
  end;
end;

procedure TFormAnaliz.FormShow(Sender: TObject);
begin
  txtStokKodu.SetFocus;
end;

procedure TFormAnaliz.ListViewAyarla;
begin
  with lst1 do
  begin
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Columns.Clear;
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 80; end;
    with Columns.Add do begin Caption := 'Stok Adi'; Width := 180; end;
    with Columns.Add do begin Caption := 'Malzeme.T'; Width := 70; end;
    with Columns.Add do begin Caption := 'MGG %'; Width := 55; end;
    with Columns.Add do begin Caption := 'MGG Tutar'; Width := 70; end;
    with Columns.Add do begin Caption := 'Nakliye'; Width := 60; end;
    with Columns.Add do begin Caption := 'Iscilik U.'; Width := 65; end;
    with Columns.Add do begin Caption := 'Iscilik D.'; Width := 65; end;
    with Columns.Add do begin Caption := 'Iscilik Tu.'; Width := 70; end;
    with Columns.Add do begin Caption := 'Kar %'; Width := 50; end;
    with Columns.Add do begin Caption := 'Kar Tutar'; Width := 70; end;
    with Columns.Add do begin Caption := 'Toplam'; Width := 80; end;
    with Columns.Add do begin Caption := '485 Toplam'; Width := 85; end;
    with Columns.Add do begin Caption := 'Satis Fiyati'; Width := 80; end;
    with Columns.Add do begin Caption := 'Tarih'; Width := 75; end;
    with Columns.Add do begin Caption := 'Eski Fiyat'; Width := 70; end;
    with Columns.Add do begin Caption := 'Not'; Width := 120; end;
    with Columns.Add do begin Caption := 'Fiyat Listesi'; Width := 90; end;
  end;
end;

procedure TFormAnaliz.LstProJelerAyarla;
begin
  with lstprojeler do
  begin
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Columns.Clear;
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 100; end;
    with Columns.Add do begin Caption := 'Stok Adi'; Width := 220; end;
    with Columns.Add do begin Caption := 'Miktar'; Width := 55; end;
    with Columns.Add do begin Caption := 'TFiyat'; Width := 65; end;
    with Columns.Add do begin Caption := '485Fiyat'; Width := 65; end;
  end;
end;

procedure TFormAnaliz.FiyatListeleriniYukle;
var
  Q: TFDQuery;
  Item: TListItem;
  Sira: Integer;
begin
  ListViewFiyatListesi.Items.Clear;
  Sira := 0;
  try
    Q := DB.SQLSorgu(
      'SELECT LISTE_ADI FROM FIYAT_LISTELERI WHERE AKTIF = 1 ORDER BY SIRA_NO'
    );
    try
      while not Q.Eof do
      begin
        Inc(Sira);
        Item := ListViewFiyatListesi.Items.Add;
        Item.Caption := IntToStr(Sira);
        Item.SubItems.Add(Q.FieldByName('LISTE_ADI').AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;

  if ListViewFiyatListesi.Items.Count > 0 then
  begin
    ListViewFiyatListesi.Items[0].Selected := True;
    FSeciliFiyatListesi := ListViewFiyatListesi.Items[0].SubItems[0];
  end;
end;

procedure TFormAnaliz.UretimMiktarYukle;
var
  Q: TFDQuery;
  Item: TListItem;
begin
  with ListViewUretimMiktar do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    with Columns.Add do begin Caption := 'Proje Kodu'; Width := 90; end;
    with Columns.Add do begin Caption := 'Adi'; Width := 200; end;
    with Columns.Add do begin Caption := 'U.Miktar'; Width := 70; end;
  end;

  try
    Q := DB.SQLSorgu(
      'SELECT STOK_KODU, STOK_ADI, URETIM_MIKTAR FROM URETIM ' +
      'ORDER BY URETIM_MIKTAR DESC'
    );
    try
      while not Q.Eof do
      begin
        Item := ListViewUretimMiktar.Items.Add;
        Item.Caption := Q.FieldByName('STOK_KODU').AsString;
        Item.SubItems.Add(Q.FieldByName('STOK_ADI').AsString);
        Item.SubItems.Add(FormatFloat('#,##0', Q.FieldByName('URETIM_MIKTAR').AsFloat));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormAnaliz.txtStokKoduChange(Sender: TObject);
var
  StokKodu: string;
  Q: TFDQuery;
begin
  StokKodu := Trim(txtStokKodu.Text);
  Temizle;

  if StokKodu = '' then Exit;

  // Uretim miktari
  try
    Q := DB.SQLSorgu(
      'SELECT URETIM_MIKTAR FROM URETIM WHERE STOK_KODU = ' +
      QuotedStr(StokKodu) + ' LIMIT 1'
    );
    try
      if not Q.IsEmpty then
        TxtUretimMik.Text := FormatFloat('#,##0', Q.FieldByName('URETIM_MIKTAR').AsFloat);
    finally
      Q.Free;
    end;
  except end;

  NotlarıGoster;

  if not ProjeVarMi(StokKodu) then
  begin
    txtSokAdi.Text := '';
    Exit;
  end;

  try
    Q := DB.SQLSorgu(
      'SELECT PROJE_ADI FROM PROJELER WHERE PROJE_NO = ' +
      QuotedStr(StokKodu) + ' LIMIT 1'
    );
    try
      if not Q.IsEmpty then
        txtSokAdi.Text := Q.FieldByName('PROJE_ADI').AsString;
    finally
      Q.Free;
    end;
  except end;

  txtTarih.Text := FormatDateTime('dd.mm.yyyy', Now);
  FiyatHesapla;
  ReceteListesiDoldur;
  SatisFiyatiBul;
  HedefFiyatAra;
  AnalizKayitlariniYukle;
end;

procedure TFormAnaliz.FiyatHesapla;
var
  Toplam, Toplam485: Double;
begin
  Toplam := ProjeMalzemeToplami(Trim(txtStokKodu.Text), FSeciliFiyatListesi);
  Toplam485 := ProjeToplamı485(Trim(txtStokKodu.Text));

  txtMalzemeTekinToplam.Text := FormatPara(Toplam);
  txt485Toplam.Text := FormatPara(Toplam485);

  MggHesapla;
  IscilikHesapla;
  KarHesapla;
end;

procedure TFormAnaliz.MggHesapla;
var
  MggYuzde, MalzemeToplam: Double;
begin
  MggYuzde := StrToDoubleSafe(txtMggYuzde.Text);
  MalzemeToplam := StrToDoubleSafe(txtMalzemeTekinToplam.Text);
  txtMggHesap.Text := FormatPara((MggYuzde / 100) * MalzemeToplam);
end;

procedure TFormAnaliz.IscilikHesapla;
var
  Ucret, Dakika: Double;
begin
  Ucret := StrToDoubleSafe(txtIscilikUcret.Text);
  Dakika := StrToDoubleSafe(txtIscilikDakika.Text);
  txtIscilik.Text := FormatPara(Ucret * Dakika);
end;

procedure TFormAnaliz.KarHesapla;
var
  Kar1, Toplam, ToplamSatis: Double;
begin
  Kar1 := 0;
  Kar1 := Kar1 + StrToDoubleSafe(txtMalzemeTekinToplam.Text);
  Kar1 := Kar1 + StrToDoubleSafe(txtIscilik.Text);
  Kar1 := Kar1 + StrToDoubleSafe(txtMggHesap.Text);
  Kar1 := Kar1 + StrToDoubleSafe(txtNakliye.Text);

  txtKar.Text := FormatPara(Kar1 * StrToDoubleSafe(txtKarYuzde.Text) / 100);

  Toplam := 0;
  Toplam := Toplam + StrToDoubleSafe(txtKar.Text);
  Toplam := Toplam + StrToDoubleSafe(txtMggHesap.Text);
  Toplam := Toplam + StrToDoubleSafe(txtIscilik.Text);
  Toplam := Toplam + StrToDoubleSafe(txtMalzemeTekinToplam.Text);
  Toplam := Toplam + StrToDoubleSafe(txtNakliye.Text);
  txtToplam.Text := FormatPara(Toplam);

  ToplamSatis := 0;
  ToplamSatis := ToplamSatis + StrToDoubleSafe(txt485Toplam.Text);
  ToplamSatis := ToplamSatis + StrToDoubleSafe(txtToplam.Text);
  txtToplamSatis.Text := FormatPara(ToplamSatis);
end;

procedure TFormAnaliz.SatisFiyatiBul;
var
  Q: TFDQuery;
begin
  txtEskiFiyat.Text := '';
  try
    Q := DB.SQLSorgu(
      'SELECT SATIS_FIYATI FROM PROJELER WHERE PROJE_NO = ' +
      QuotedStr(Trim(txtStokKodu.Text))
    );
    try
      if not Q.IsEmpty then
        txtEskiFiyat.Text := FormatPara(Q.FieldByName('SATIS_FIYATI').AsFloat);
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormAnaliz.HedefFiyatAra;
var
  Q: TFDQuery;
begin
  txtHedefFiyat.Text := '';
  try
    Q := DB.SQLSorgu(
      'SELECT HEDEF_FIYAT FROM HEDEF_FIYAT WHERE STOK_KODU = ' +
      QuotedStr(Trim(txtStokKodu.Text))
    );
    try
      if not Q.IsEmpty then
        txtHedefFiyat.Text := FormatFloat('#,##0', Q.FieldByName('HEDEF_FIYAT').AsFloat);
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormAnaliz.NotlarıGoster;
var
  Q: TFDQuery;
  Notlar: string;
  Sira: Integer;
begin
  TxtNot1.Clear;
  TxtNot.Text := '';
  Notlar := '';
  Sira := 0;
  try
    Q := DB.SQLSorgu(
      'SELECT NOT_METNI, TARIH FROM ANALIZLER ' +
      'WHERE STOK_KODU = ' + QuotedStr(Trim(txtStokKodu.Text)) +
      ' AND NOT_METNI <> '''' ' +
      'ORDER BY TARIH DESC'
    );
    try
      while not Q.Eof do
      begin
        Inc(Sira);
        Notlar := Notlar + IntToStr(Sira) + '. ' +
                  Q.FieldByName('NOT_METNI').AsString + #13#10;
        if Sira = 1 then
          TxtNot.Text := Q.FieldByName('NOT_METNI').AsString;
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
  TxtNot1.Text := Trim(Notlar);
end;

procedure TFormAnaliz.AnalizKayitlariniYukle;
var
  Q: TFDQuery;
  Item: TListItem;
begin
  lst1.Items.Clear;
  try
    Q := DB.SQLSorgu(
      'SELECT * FROM ANALIZLER WHERE STOK_KODU = ' +
      QuotedStr(Trim(txtStokKodu.Text)) +
      ' ORDER BY TARIH DESC'
    );
    try
      while not Q.Eof do
      begin
        Item := lst1.Items.Add;
        Item.Caption := Q.FieldByName('STOK_KODU').AsString;
        Item.SubItems.Add(Q.FieldByName('STOK_ADI').AsString);
        Item.SubItems.Add(FormatPara(Q.FieldByName('MALZEME_TOPLAM').AsFloat));
        Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('MGG_YUZDE').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('MGG_HESAP').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('NAKLIYE').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('ISCILIK_UCRET').AsFloat));
        Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('ISCILIK_DAKIKA').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('ISCILIK').AsFloat));
        Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('KAR_YUZDE').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('KAR').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('TOPLAM').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('TOPLAM_485').AsFloat));
        Item.SubItems.Add(FormatPara(Q.FieldByName('TOPLAM_SATIS').AsFloat));
        Item.SubItems.Add(Q.FieldByName('TARIH').AsString);
        Item.SubItems.Add(FormatPara(Q.FieldByName('ESKI_FIYAT').AsFloat));
        Item.SubItems.Add(Q.FieldByName('NOT_METNI').AsString);
        Item.SubItems.Add(Q.FieldByName('FIYAT_LISTESI').AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormAnaliz.ReceteListesiDoldur;
var
  Q: TFDQuery;
  Item: TListItem;
  StokKodu, Ilk3: string;
  TFiyat, Fiyat485: Double;
  TFiyatBos, Fiyat485Bos, Is485, IsMamul: Boolean;
begin
  lstprojeler.Items.Clear;
  try
    Q := DB.SQLSorgu(
      'SELECT ID, STOK_KODU, MALZEME_ADI, MIKTAR FROM RECETELER ' +
      'WHERE PROJE_NO = ' + QuotedStr(Trim(txtStokKodu.Text)) +
      ' ORDER BY ID'
    );
    try
      while not Q.Eof do
      begin
        StokKodu := Q.FieldByName('STOK_KODU').AsString;
        Ilk3 := Copy(StokKodu, 1, 3);
        IsMamul := (Ilk3 = '800') or (Ilk3 = '803');

        if not IsMamul then
        begin
          Is485 := (Ilk3 = '485');
          TFiyat := MalzemeFiyatBul(StokKodu, FSeciliFiyatListesi) *
                    Q.FieldByName('MIKTAR').AsFloat;
          Fiyat485 := Malzeme485FiyatBul(StokKodu) *
                      Q.FieldByName('MIKTAR').AsFloat;
          TFiyatBos := TFiyat = 0;
          Fiyat485Bos := Fiyat485 = 0;

          Item := lstprojeler.Items.Add;

          if Is485 then
          begin
            if Fiyat485Bos then
            begin
              Item.Caption := '?' + StokKodu;
              Item.SubItems.Add(Q.FieldByName('MALZEME_ADI').AsString);
              Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('MIKTAR').AsFloat));
              Item.SubItems.Add(FormatPara(TFiyat));
              Item.SubItems.Add('***');
            end else
            begin
              Item.Caption := StokKodu;
              Item.SubItems.Add(Q.FieldByName('MALZEME_ADI').AsString);
              Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('MIKTAR').AsFloat));
              Item.SubItems.Add(FormatPara(TFiyat));
              Item.SubItems.Add(FormatPara(Fiyat485));
            end;
          end else
          begin
            if TFiyatBos then
            begin
              Item.Caption := '?' + StokKodu;
              Item.SubItems.Add(Q.FieldByName('MALZEME_ADI').AsString);
              Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('MIKTAR').AsFloat));
              Item.SubItems.Add('***');
              Item.SubItems.Add(FormatPara(Fiyat485));
            end else
            begin
              Item.Caption := StokKodu;
              Item.SubItems.Add(Q.FieldByName('MALZEME_ADI').AsString);
              Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('MIKTAR').AsFloat));
              Item.SubItems.Add(FormatPara(TFiyat));
              Item.SubItems.Add(FormatPara(Fiyat485));
            end;
          end;
        end;
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormAnaliz.Temizle;
begin
  txtMalzemeTekinToplam.Text := '';
  txtMggYuzde.Text := '';
  txtMggHesap.Text := '';
  txtNakliye.Text := '';
  txtIscilikDakika.Text := '';
  txtIscilik.Text := '';
  txtKarYuzde.Text := '';
  txtKar.Text := '';
  txtToplam.Text := '';
  txtToplamSatis.Text := '';
  txtEskiFiyat.Text := '';
  TxtNot.Text := '';
  TxtUretimMik.Text := '';
  TxtNot1.Clear;
  txt485Toplam.Text := '';
  txtHedefFiyat.Text := '';
  lst1.Items.Clear;
  lstprojeler.Items.Clear;
end;

procedure TFormAnaliz.txtMggYuzdeChange(Sender: TObject);
begin
  MggHesapla;
  KarHesapla;
end;

procedure TFormAnaliz.txtNakliyeChange(Sender: TObject);
begin
  KarHesapla;
end;

procedure TFormAnaliz.txtIscilikDakikaChange(Sender: TObject);
begin
  IscilikHesapla;
  KarHesapla;
end;

procedure TFormAnaliz.txtIscilikUcretChange(Sender: TObject);
begin
  IscilikHesapla;
  KarHesapla;
end;

procedure TFormAnaliz.txtKarYuzdeChange(Sender: TObject);
begin
  KarHesapla;
end;

procedure TFormAnaliz.btnKayitClick(Sender: TObject);
var
  FiyatSayfasi: string;
begin
  if MessageDlg('ANALIZ KAYDEDILSIN MI?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  FiyatSayfasi := FSeciliFiyatListesi;
  if FiyatSayfasi = '' then FiyatSayfasi := 'TFIYAT';

  try
    DB.SQLCalistir(
      'INSERT INTO ANALIZLER ' +
      '(STOK_KODU, STOK_ADI, MALZEME_TOPLAM, MGG_YUZDE, MGG_HESAP, ' +
      'NAKLIYE, ISCILIK_UCRET, ISCILIK_DAKIKA, ISCILIK, KAR_YUZDE, KAR, ' +
      'TOPLAM, TOPLAM_485, TOPLAM_SATIS, ESKI_FIYAT, NOT_METNI, ' +
      'FIYAT_LISTESI, TARIH, URETIM_MIKTAR) VALUES (' +
      QuotedStr(Trim(txtStokKodu.Text)) + ',' +
      QuotedStr(txtSokAdi.Text) + ',' +
      FloatToStr(StrToDoubleSafe(txtMalzemeTekinToplam.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtMggYuzde.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtMggHesap.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtNakliye.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtIscilikUcret.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtIscilikDakika.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtIscilik.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtKarYuzde.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtKar.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtToplam.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txt485Toplam.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtToplamSatis.Text)) + ',' +
      FloatToStr(StrToDoubleSafe(txtEskiFiyat.Text)) + ',' +
      QuotedStr(TxtNot.Text) + ',' +
      QuotedStr(FiyatSayfasi) + ',' +
      QuotedStr(FormatDateTime('dd.mm.yyyy hh:nn', Now)) + ',' +
      FloatToStr(StrToDoubleSafe(TxtUretimMik.Text)) +
      ')'
    );
    ShowMessage('Kayit basariyla tamamlandi!');
    Temizle;
    txtStokKoduChange(nil);
  except
    on E: Exception do
      ShowMessage('Kayit hatasi: ' + E.Message);
  end;
end;

procedure TFormAnaliz.btnCikisClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAnaliz.CmBProjelerClick(Sender: TObject);
begin
  FormProjeler.ShowModal;
  if FormProjeler.SeciliProjeNo <> '' then
    ProjeKoduAta(FormProjeler.SeciliProjeNo);
end;

procedure TFormAnaliz.ProjeKoduAta(const ProjeNo: string);
begin
  txtStokKodu.Text := ProjeNo;
  txtStokKoduChange(nil);
end;

procedure TFormAnaliz.lst1DblClick(Sender: TObject);
var
  Item: TListItem;
  StokKodu, Tarih: string;
begin
  Item := lst1.Selected;
  if Item = nil then Exit;

  StokKodu := Item.Caption;
  Tarih := Item.SubItems[14];

  if MessageDlg('Bu kaydi silmek istediginizden emin misiniz?' + #13#10 +
    'Stok Kodu: ' + StokKodu + #13#10 +
    'Tarih: ' + Tarih,
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  try
    DB.SQLCalistir(
      'DELETE FROM ANALIZLER WHERE STOK_KODU = ' +
      QuotedStr(StokKodu) + ' AND TARIH = ' + QuotedStr(Tarih)
    );
    lst1.Items.Delete(Item.Index);
    ShowMessage('Kayit silindi.');
  except
    on E: Exception do
      ShowMessage('Silme hatasi: ' + E.Message);
  end;
end;

procedure TFormAnaliz.ListViewFiyatListesiClick(Sender: TObject);
begin
  if ListViewFiyatListesi.Selected = nil then Exit;
  FSeciliFiyatListesi := ListViewFiyatListesi.Selected.SubItems[0];
  if Trim(txtStokKodu.Text) <> '' then
    FiyatHesapla;
end;

procedure TFormAnaliz.ListViewUretimMiktarDblClick(Sender: TObject);
begin
  if ListViewUretimMiktar.Selected = nil then Exit;
  txtStokKodu.Text := ListViewUretimMiktar.Selected.Caption;
  txtStokKoduChange(nil);
end;

end.
