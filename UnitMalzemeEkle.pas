unit UnitMalzemeEkle;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormMalzemeEkle = class(TForm)
    PnlUst: TPanel;
    CommandButtonMalzemeEkle: TButton;
    BtnKapat: TButton;
    TxtEklenecekMalzeme: TEdit;
    LblMalzeme: TLabel;
    TextProjeler: TEdit;
    LblProje: TLabel;
    PnlSol: TPanel;
    ListViewMalzemeEklenecek: TListView;
    PnlSag: TPanel;
    ListViewProjeListesi: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CommandButtonMalzemeEkleClick(Sender: TObject);
    procedure TxtEklenecekMalzemeChange(Sender: TObject);
    procedure TextProjelerChange(Sender: TObject);
    procedure ListViewMalzemeEklenecekClick(Sender: TObject);
    procedure BtnKapatClick(Sender: TObject);
  private
    procedure ListeleriAyarla;
    procedure MalzemeListesiYukle(const Arama: string);
    procedure ProjeListesiYukle(const Arama: string);
  end;

var
  FormMalzemeEkle: TFormMalzemeEkle;

implementation

{$R *.dfm}

procedure TFormMalzemeEkle.FormCreate(Sender: TObject);
begin
  ListeleriAyarla;
end;

procedure TFormMalzemeEkle.FormShow(Sender: TObject);
begin
  TxtEklenecekMalzeme.Clear;
  TextProjeler.Clear;
  MalzemeListesiYukle('');
  ProjeListesiYukle('');
  TxtEklenecekMalzeme.SetFocus;
end;

procedure TFormMalzemeEkle.ListeleriAyarla;
begin
  with ListViewMalzemeEklenecek do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00CCFFCC;
    
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 80; end;
    with Columns.Add do begin Caption := 'Malzeme Adi'; Width := 260; end;
    with Columns.Add do begin Caption := 'Fiyat'; Width := 110; end;
  end;

  with ListViewProjeListesi do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    CheckBoxes := True;
    Color := $00E0FFFF;
    
    with Columns.Add do begin Caption := 'Proje No'; Width := 100; end;
    with Columns.Add do begin Caption := 'Proje Adi'; Width := 220; end;
  end;
end;

procedure TFormMalzemeEkle.MalzemeListesiYukle(const Arama: string);
var
  Q: TFDQuery;
  Item: TListItem;
  SQL, AramaL: string;
begin
  ListViewMalzemeEklenecek.Items.Clear;
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
        Item := ListViewMalzemeEklenecek.Items.Add;
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

procedure TFormMalzemeEkle.ProjeListesiYukle(const Arama: string);
var
  Q: TFDQuery;
  Item: TListItem;
  SQL, AramaL: string;
begin
  ListViewProjeListesi.Items.Clear;
  AramaL := LowerCase(Trim(Arama));

  SQL := 'SELECT PROJE_NO, PROJE_ADI FROM PROJELER';
  if AramaL <> '' then
    SQL := SQL + ' WHERE (LOWER(PROJE_NO) LIKE ' + QuotedStr('%' + AramaL + '%') +
           ' OR LOWER(PROJE_ADI) LIKE ' + QuotedStr('%' + AramaL + '%') + ')';
  SQL := SQL + ' ORDER BY PROJE_NO';

  try
    Q := DB.SQLSorgu(SQL);
    try
      while not Q.Eof do
      begin
        Item := ListViewProjeListesi.Items.Add;
        Item.Caption := Q.FieldByName('PROJE_NO').AsString;
        Item.SubItems.Add(Q.FieldByName('PROJE_ADI').AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormMalzemeEkle.TxtEklenecekMalzemeChange(Sender: TObject);
begin
  MalzemeListesiYukle(TxtEklenecekMalzeme.Text);
end;

procedure TFormMalzemeEkle.TextProjelerChange(Sender: TObject);
begin
  ProjeListesiYukle(TextProjeler.Text);
end;

procedure TFormMalzemeEkle.ListViewMalzemeEklenecekClick(Sender: TObject);
begin
  if ListViewMalzemeEklenecek.Selected = nil then Exit;
  TxtEklenecekMalzeme.Text := ListViewMalzemeEklenecek.Selected.Caption;
end;

procedure TFormMalzemeEkle.CommandButtonMalzemeEkleClick(Sender: TObject);
var
  StokKodu: string;
  Item: TListItem;
  MiktarStr: string;
  Miktar: Double;
  Eklendi: Integer;
begin
  StokKodu := Trim(TxtEklenecekMalzeme.Text);
  if StokKodu = '' then
  begin
    ShowMessage('Malzeme secin!');
    Exit;
  end;

  Eklendi := 0;
  
  for Item in ListViewProjeListesi.Items do
  begin
    if Item.Checked then
    begin
      MiktarStr := InputBox('Malzeme Ekle',
        'Proje: ' + Item.Caption + #13#10 +
        'Malzeme: ' + StokKodu + #13#10 +
        'Miktari girin:', '1');

      if MiktarStr <> '' then
      begin
        Miktar := StrToDoubleSafe(MiktarStr);
        if Miktar > 0 then
        begin
          if MalzemeProjeyeEkle(Item.Caption, StokKodu, Miktar) then
            Inc(Eklendi)
          else
            ShowMessage('Malzeme ' + Item.Caption + ' projesinde zaten var!');
        end;
      end;
    end;
  end;
  
  ShowMessage(IntToStr(Eklendi) + ' projeye malzeme eklendi.');
end;

procedure TFormMalzemeEkle.BtnKapatClick(Sender: TObject);
begin
  Close;
end;

end.
