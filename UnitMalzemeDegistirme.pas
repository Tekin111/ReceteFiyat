unit UnitMalzemeDegistirme;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormMalzemeDegistirme = class(TForm)
    PnlUst: TPanel;
    TxtDegisecekMalzeme: TEdit;
    LblDegisecek: TLabel;
    TxtYeniMalzeme: TEdit;
    LblYeni: TLabel;
    BtnDegistir: TButton;
    BtnKapat: TButton;
    PnlSol: TPanel;
    ListViewDegisecekMalzeme: TListView;
    PnlOrta: TPanel;
    ListViewYeniMalzeme: TListView;
    PnlSag: TPanel;
    ListView4: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TxtDegisecekMalzemeChange(Sender: TObject);
    procedure TxtYeniMalzemeChange(Sender: TObject);
    procedure BtnDegistirClick(Sender: TObject);
    procedure ListViewDegisecekMalzemeClick(Sender: TObject);
    procedure ListViewYeniMalzemeClick(Sender: TObject);
    procedure BtnKapatClick(Sender: TObject);
  private
    procedure ListeleriAyarla;
    procedure MalzemeListesiYukle(LV: TListView; const Arama: string);
    procedure ProjelerdeAra(const StokKodu: string; LV: TListView);
  end;

var
  FormMalzemeDegistirme: TFormMalzemeDegistirme;

implementation

{$R *.dfm}

procedure TFormMalzemeDegistirme.FormCreate(Sender: TObject);
begin
  ListeleriAyarla;
end;

procedure TFormMalzemeDegistirme.FormShow(Sender: TObject);
begin
  TxtDegisecekMalzeme.Clear;
  TxtYeniMalzeme.Clear;
  MalzemeListesiYukle(ListViewDegisecekMalzeme, '');
  MalzemeListesiYukle(ListViewYeniMalzeme, '');
  ListView4.Items.Clear;
  TxtDegisecekMalzeme.SetFocus;
end;

procedure TFormMalzemeDegistirme.ListeleriAyarla;
begin
  with ListViewDegisecekMalzeme do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00CCFFCC;
    
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 80; end;
    with Columns.Add do begin Caption := 'Malzeme Adi'; Width := 200; end;
    with Columns.Add do begin Caption := 'Fiyat'; Width := 100; end;
  end;

  with ListViewYeniMalzeme do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00FFD0A0;
    
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 80; end;
    with Columns.Add do begin Caption := 'Malzeme Adi'; Width := 200; end;
    with Columns.Add do begin Caption := 'Fiyat'; Width := 100; end;
  end;

  with ListView4 do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00FFFFCC;
    
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 100; end;
    with Columns.Add do begin Caption := 'TGT No'; Width := 100; end;
    with Columns.Add do begin Caption := 'Mamul Adi'; Width := 280; end;
    with Columns.Add do begin Caption := 'Ad./Mt.'; Width := 70; end;
  end;
end;

procedure TFormMalzemeDegistirme.MalzemeListesiYukle(LV: TListView; const Arama: string);
var
  Q: TFDQuery;
  Item: TListItem;
  SQL, AramaL: string;
begin
  LV.Items.Clear;
  AramaL := LowerCase(Trim(Arama));

  SQL := 'SELECT STOK_KODU, MALZEME_ADI, FIYAT FROM MALZEMELER WHERE FIYAT_TIPI = ''TFIYAT''';
  if AramaL <> '' then
    SQL := SQL + ' AND (LOWER(STOK_KODU) LIKE ' + QuotedStr('%' + AramaL + '%') +
           ' OR LOWER(MALZEME_ADI) LIKE ' + QuotedStr('%' + AramaL + '%') + ')';
  SQL := SQL + ' ORDER BY STOK_KODU';

  try
    Q := DB.SQLSorgu(SQL);
    try
      while not Q.Eof do
      begin
        Item := LV.Items.Add;
        Item.Caption := Q.FieldByName('STOK_KODU').AsString;
        Item.SubItems.Add(Q.FieldByName('MALZEME_ADI').AsString);
        Item.SubItems.Add(Format('€ %s', [FormatFloat('#,##0.00', Q.FieldByName('FIYAT').AsFloat)]));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormMalzemeDegistirme.ProjelerdeAra(const StokKodu: string; LV: TListView);
var
  Kalemler: TArray<TReceteKalem>;
  Kalem: TReceteKalem;
  Item: TListItem;
  Q: TFDQuery;
  ProjeAdi: string;
begin
  LV.Items.Clear;
  if StokKodu = '' then Exit;

  Kalemler := MalzemeProjelerdeAra(StokKodu);
  for Kalem in Kalemler do
  begin
    ProjeAdi := '';
    try
      Q := DB.SQLSorgu('SELECT PROJE_ADI FROM PROJELER WHERE PROJE_NO = ' +
                        QuotedStr(Kalem.ProjeNo));
      try
        if not Q.IsEmpty then
          ProjeAdi := Q.FieldByName('PROJE_ADI').AsString;
      finally
        Q.Free;
      end;
    except end;

    Item := LV.Items.Add;
    Item.Caption := Kalem.StokKodu;
    Item.SubItems.Add(Kalem.ProjeNo);
    Item.SubItems.Add(ProjeAdi);
    Item.SubItems.Add(FormatFloat('#,##0.00', Kalem.Miktar));
  end;
end;

procedure TFormMalzemeDegistirme.TxtDegisecekMalzemeChange(Sender: TObject);
begin
  MalzemeListesiYukle(ListViewDegisecekMalzeme, TxtDegisecekMalzeme.Text);
  ProjelerdeAra(Trim(TxtDegisecekMalzeme.Text), ListView4);
end;

procedure TFormMalzemeDegistirme.TxtYeniMalzemeChange(Sender: TObject);
begin
  MalzemeListesiYukle(ListViewYeniMalzeme, TxtYeniMalzeme.Text);
end;

procedure TFormMalzemeDegistirme.ListViewDegisecekMalzemeClick(Sender: TObject);
begin
  if ListViewDegisecekMalzeme.Selected = nil then Exit;
  TxtDegisecekMalzeme.Text := ListViewDegisecekMalzeme.Selected.Caption;
  ProjelerdeAra(TxtDegisecekMalzeme.Text, ListView4);
end;

procedure TFormMalzemeDegistirme.ListViewYeniMalzemeClick(Sender: TObject);
begin
  if ListViewYeniMalzeme.Selected = nil then Exit;
  TxtYeniMalzeme.Text := ListViewYeniMalzeme.Selected.Caption;
end;

procedure TFormMalzemeDegistirme.BtnDegistirClick(Sender: TObject);
var
  EskiKod, YeniKod, YeniAdi: string;
  Degisen: Integer;
  Q: TFDQuery;
  ProjeNo: string;
begin
  EskiKod := Trim(TxtDegisecekMalzeme.Text);
  YeniKod := Trim(TxtYeniMalzeme.Text);

  if EskiKod = '' then
  begin
    ShowMessage('Degisecek malzemeyi secin!');
    Exit;
  end;
  
  if YeniKod = '' then
  begin
    ShowMessage('Yeni malzemeyi secin!');
    Exit;
  end;
  
  if EskiKod = YeniKod then
  begin
    ShowMessage('Malzemeler ayni!');
    Exit;
  end;

  if MessageDlg('TUM PROJELERDE ' + EskiKod + ' -> ' + YeniKod + ' degistirilsin mi?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  YeniAdi := MalzemeAdiBul(YeniKod);
  Degisen := 0;

  try
    Q := DB.SQLSorgu(
      'SELECT DISTINCT PROJE_NO FROM RECETELER WHERE STOK_KODU = ' +
      QuotedStr(EskiKod)
    );
    try
      while not Q.Eof do
      begin
        ProjeNo := Q.FieldByName('PROJE_NO').AsString;
        DB.SQLCalistir(
          'UPDATE RECETELER SET STOK_KODU = ' + QuotedStr(YeniKod) +
          ', MALZEME_ADI = ' + QuotedStr(YeniAdi) +
          ' WHERE PROJE_NO = ' + QuotedStr(ProjeNo) +
          ' AND STOK_KODU = ' + QuotedStr(EskiKod)
        );
        Inc(Degisen);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Hata: ' + E.Message);
      Exit;
    end;
  end;

  ShowMessage(IntToStr(Degisen) + ' projede malzeme degistirildi.');
  ProjelerdeAra(EskiKod, ListView4);
end;

procedure TFormMalzemeDegistirme.BtnKapatClick(Sender: TObject);
begin
  Close;
end;

end.
