unit UnitArama;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormArama = class(TForm)
    PnlUst: TPanel;
    TxtMalzeme: TEdit;
    LblArama: TLabel;
    PnlSol: TPanel;
    ListViewFiyat: TListView;
    PnlSag: TPanel;
    ListView2: TListView;
    BtnKapat: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TxtMalzemeChange(Sender: TObject);
    procedure ListViewFiyatClick(Sender: TObject);
    procedure BtnKapatClick(Sender: TObject);
  private
    procedure ListView2Ayarla;
    procedure ListViewFiyatAyarla;
    procedure FiyatListesiniYukle(const Arama: string);
    procedure MalzemeAra;
  end;

var
  FormArama: TFormArama;

implementation

{$R *.dfm}

procedure TFormArama.FormCreate(Sender: TObject);
begin
  ListView2Ayarla;
  ListViewFiyatAyarla;
end;

procedure TFormArama.FormShow(Sender: TObject);
begin
  TxtMalzeme.Clear;
  FiyatListesiniYukle('');
  ListView2Ayarla;
  TxtMalzeme.SetFocus;
end;

procedure TFormArama.ListView2Ayarla;
begin
  with ListView2 do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00FFFFCC;
    
    with Columns.Add do
    begin
      Caption := 'Stok Kodu';
      Width := 90;
    end;
    
    with Columns.Add do
    begin
      Caption := 'TGT No';
      Width := 90;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Mamul Adi';
      Width := 280;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Ad./Mt.';
      Width := 70;
    end;
  end;
end;

procedure TFormArama.ListViewFiyatAyarla;
begin
  with ListViewFiyat do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00CCFFCC;
    
    with Columns.Add do
    begin
      Caption := 'Stok Kodu';
      Width := 80;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Malzeme Adi';
      Width := 270;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Fiyat';
      Width := 110;
    end;
  end;
end;

procedure TFormArama.FiyatListesiniYukle(const Arama: string);
var
  Q: TFDQuery;
  Item: TListItem;
  SQL: string;
  AramaL: string;
begin
  ListViewFiyat.Items.Clear;
  AramaL := LowerCase(Trim(Arama));

  // TFIYAT malzemeleri
  SQL := 'SELECT STOK_KODU, MALZEME_ADI, FIYAT FROM MALZEMELER ' +
         'WHERE FIYAT_TIPI = ''TFIYAT''';
  if AramaL <> '' then
    SQL := SQL + ' AND (LOWER(STOK_KODU) LIKE ' + QuotedStr('%' + AramaL + '%') +
           ' OR LOWER(MALZEME_ADI) LIKE ' + QuotedStr('%' + AramaL + '%') + ')';
  SQL := SQL + ' ORDER BY STOK_KODU';

  try
    Q := DB.SQLSorgu(SQL);
    try
      while not Q.Eof do
      begin
        Item := ListViewFiyat.Items.Add;
        Item.Caption := Q.FieldByName('STOK_KODU').AsString;
        Item.SubItems.Add(Q.FieldByName('MALZEME_ADI').AsString);
        Item.SubItems.Add(Format('€ %s', [FormatFloat('#,##0.00', Q.FieldByName('FIYAT').AsFloat)]));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;

  // 485 malzemeleri
  SQL := 'SELECT STOK_KODU, MALZEME_ADI, FIYAT FROM MALZEME_485';
  if AramaL <> '' then
    SQL := SQL + ' WHERE (LOWER(STOK_KODU) LIKE ' + QuotedStr('%' + AramaL + '%') +
           ' OR LOWER(MALZEME_ADI) LIKE ' + QuotedStr('%' + AramaL + '%') + ')';
  SQL := SQL + ' ORDER BY STOK_KODU';

  try
    Q := DB.SQLSorgu(SQL);
    try
      while not Q.Eof do
      begin
        Item := ListViewFiyat.Items.Add;
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

procedure TFormArama.MalzemeAra;
var
  Kalemler: TArray<TReceteKalem>;
  Kalem: TReceteKalem;
  Item: TListItem;
  Q: TFDQuery;
  ProjeAdi: string;
begin
  ListView2Ayarla;
  if Trim(TxtMalzeme.Text) = '' then Exit;

  Kalemler := MalzemeProjelerdeAra(Trim(TxtMalzeme.Text));
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

    Item := ListView2.Items.Add;
    Item.Caption := Kalem.StokKodu;
    Item.SubItems.Add(Kalem.ProjeNo);
    Item.SubItems.Add(ProjeAdi);
    Item.SubItems.Add(FormatFloat('#,##0.00', Kalem.Miktar));
  end;
end;

procedure TFormArama.TxtMalzemeChange(Sender: TObject);
begin
  FiyatListesiniYukle(TxtMalzeme.Text);
  MalzemeAra;
end;

procedure TFormArama.ListViewFiyatClick(Sender: TObject);
begin
  if ListViewFiyat.Selected = nil then Exit;
  TxtMalzeme.Text := ListViewFiyat.Selected.Caption;
  MalzemeAra;
end;

procedure TFormArama.BtnKapatClick(Sender: TObject);
begin
  Close;
end;

end.
