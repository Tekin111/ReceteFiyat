unit UnitMiktarDegistirme;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormMiktarDegistirme = class(TForm)
    PnlUst: TPanel;
    CommandButtonMalzemeCikar: TButton;
    CommandButtonMiktarDegistir: TButton;
    BtnKapat: TButton;
    TxtMalzemeAra: TEdit;
    LblArama: TLabel;
    PnlSol: TPanel;
    ListViewMalzemeAra: TListView;
    PnlSag: TPanel;
    ListViewMalzemeGoster: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TxtMalzemeAraChange(Sender: TObject);
    procedure ListViewMalzemeAraClick(Sender: TObject);
    procedure CommandButtonMalzemeCikarClick(Sender: TObject);
    procedure CommandButtonMiktarDegistirClick(Sender: TObject);
    procedure BtnKapatClick(Sender: TObject);
  private
    procedure ListeleriAyarla;
    procedure MalzemeAraListesiYukle(const Arama: string);
    procedure MalzemeGosterListesiYukle(const StokKodu: string);
  end;

var
  FormMiktarDegistirme: TFormMiktarDegistirme;

implementation

{$R *.dfm}

procedure TFormMiktarDegistirme.FormCreate(Sender: TObject);
begin
  ListeleriAyarla;
end;

procedure TFormMiktarDegistirme.FormShow(Sender: TObject);
begin
  TxtMalzemeAra.Clear;
  MalzemeAraListesiYukle('');
  ListViewMalzemeGoster.Items.Clear;
  TxtMalzemeAra.SetFocus;
end;

procedure TFormMiktarDegistirme.ListeleriAyarla;
begin
  with ListViewMalzemeAra do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00CCFFCC;
    
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 80; end;
    with Columns.Add do begin Caption := 'Malzeme Adi'; Width := 260; end;
    with Columns.Add do begin Caption := 'Fiyat'; Width := 100; end;
  end;

  with ListViewMalzemeGoster do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    CheckBoxes := True;
    Color := $00FFFFCC;
    
    with Columns.Add do begin Caption := 'Stok Kodu'; Width := 100; end;
    with Columns.Add do begin Caption := 'TGT No'; Width := 90; end;
    with Columns.Add do begin Caption := 'Mamul Adi'; Width := 280; end;
    with Columns.Add do begin Caption := 'C Miktar'; Width := 80; end;
    with Columns.Add do begin Caption := 'Sayfa Adi'; Width := 100; end;
    with Columns.Add do begin Caption := 'ID'; Width := 60; end;
  end;
end;

procedure TFormMiktarDegistirme.MalzemeAraListesiYukle(const Arama: string);
var
  Q: TFDQuery;
  Item: TListItem;
  SQL, AramaL: string;
begin
  ListViewMalzemeAra.Items.Clear;
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
        Item := ListViewMalzemeAra.Items.Add;
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

procedure TFormMiktarDegistirme.MalzemeGosterListesiYukle(const StokKodu: string);
var
  Q: TFDQuery;
  Item: TListItem;
  ProjeAdi: string;
  QP: TFDQuery;
begin
  ListViewMalzemeGoster.Items.Clear;
  if StokKodu = '' then Exit;

  try
    Q := DB.SQLSorgu(
      'SELECT R.ID, R.PROJE_NO, R.STOK_KODU, R.MALZEME_ADI, R.MIKTAR ' +
      'FROM RECETELER R ' +
      'WHERE R.STOK_KODU = ' + QuotedStr(StokKodu) +
      ' ORDER BY R.PROJE_NO'
    );
    try
      while not Q.Eof do
      begin
        ProjeAdi := '';
        try
          QP := DB.SQLSorgu('SELECT PROJE_ADI FROM PROJELER WHERE PROJE_NO = ' +
                             QuotedStr(Q.FieldByName('PROJE_NO').AsString));
          try
            if not QP.IsEmpty then
              ProjeAdi := QP.FieldByName('PROJE_ADI').AsString;
          finally
            QP.Free;
          end;
        except end;

        Item := ListViewMalzemeGoster.Items.Add;
        Item.Caption := Q.FieldByName('STOK_KODU').AsString;
        Item.SubItems.Add(Q.FieldByName('PROJE_NO').AsString);
        Item.SubItems.Add(ProjeAdi);
        Item.SubItems.Add(FormatFloat('#,##0.00', Q.FieldByName('MIKTAR').AsFloat));
        Item.SubItems.Add(Q.FieldByName('PROJE_NO').AsString);
        Item.SubItems.Add(IntToStr(Q.FieldByName('ID').AsInteger));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormMiktarDegistirme.TxtMalzemeAraChange(Sender: TObject);
begin
  MalzemeAraListesiYukle(TxtMalzemeAra.Text);
  if Trim(TxtMalzemeAra.Text) <> '' then
    MalzemeGosterListesiYukle(Trim(TxtMalzemeAra.Text));
end;

procedure TFormMiktarDegistirme.ListViewMalzemeAraClick(Sender: TObject);
begin
  if ListViewMalzemeAra.Selected = nil then Exit;
  TxtMalzemeAra.Text := ListViewMalzemeAra.Selected.Caption;
  MalzemeGosterListesiYukle(TxtMalzemeAra.Text);
end;

procedure TFormMiktarDegistirme.CommandButtonMalzemeCikarClick(Sender: TObject);
var
  Item: TListItem;
  Silinen: Integer;
  ID: Integer;
  StokKodu, ProjeNo: string;
begin
  Silinen := 0;
  StokKodu := Trim(TxtMalzemeAra.Text);

  for Item in ListViewMalzemeGoster.Items do
  begin
    if Item.Checked then
    begin
      ID := StrToIntDef(Item.SubItems[4], 0);
      ProjeNo := Item.SubItems[0];

      if MessageDlg('Silinsin mi? Malzeme: ' + Item.Caption +
        ' Proje: ' + ProjeNo, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        if MalzemeProjedeSil(ProjeNo, StokKodu, ID) then
          Inc(Silinen);
      end;
    end;
  end;

  ShowMessage(IntToStr(Silinen) + ' satir silindi.');
  MalzemeGosterListesiYukle(StokKodu);
end;

procedure TFormMiktarDegistirme.CommandButtonMiktarDegistirClick(Sender: TObject);
var
  Item: TListItem;
  Degisen: Integer;
  ID: Integer;
  StokKodu, ProjeNo, YeniMiktarStr: string;
  YeniMiktar: Double;
begin
  Degisen := 0;
  StokKodu := Trim(TxtMalzemeAra.Text);

  for Item in ListViewMalzemeGoster.Items do
  begin
    if Item.Checked then
    begin
      ID := StrToIntDef(Item.SubItems[4], 0);
      ProjeNo := Item.SubItems[0];

      YeniMiktarStr := InputBox('Miktar Degistir',
        'Malzeme: ' + Item.Caption + #13#10 + 'Proje: ' + ProjeNo +
        #13#10 + 'Yeni miktar:', Item.SubItems[2]);

      if YeniMiktarStr <> '' then
      begin
        YeniMiktar := StrToDoubleSafe(YeniMiktarStr);
        if YeniMiktar > 0 then
          if MalzemeMiktarGuncelle(ProjeNo, StokKodu, ID, YeniMiktar) then
            Inc(Degisen);
      end;
    end;
  end;

  ShowMessage(IntToStr(Degisen) + ' satirin miktari degistirildi.');
  MalzemeGosterListesiYukle(StokKodu);
end;

procedure TFormMiktarDegistirme.BtnKapatClick(Sender: TObject);
begin
  Close;
end;

end.
