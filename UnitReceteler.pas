unit UnitReceteler;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormReceteler = class(TForm)
    PnlUst: TPanel;
    cmdYukle: TButton;
    cmdSil: TButton;
    cmdKaydet: TButton;
    BtnKapat: TButton;
    ListViewReceteler: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmdYukleClick(Sender: TObject);
    procedure cmdSilClick(Sender: TObject);
    procedure cmdKaydetClick(Sender: TObject);
    procedure ListViewRecetelerDblClick(Sender: TObject);
    procedure BtnKapatClick(Sender: TObject);
  private
    procedure ListeAyarla;
    procedure ProjeleriVeTumListeyiGoster;
  end;

var
  FormReceteler: TFormReceteler;

implementation

{$R *.dfm}

procedure TFormReceteler.FormCreate(Sender: TObject);
begin
  ListeAyarla;
end;

procedure TFormReceteler.FormShow(Sender: TObject);
begin
  ProjeleriVeTumListeyiGoster;
end;

procedure TFormReceteler.ListeAyarla;
begin
  with ListViewReceteler do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    CheckBoxes := True;
    
    with Columns.Add do begin Caption := 'Sira No'; Width := 45; end;
    with Columns.Add do begin Caption := 'Proje No'; Width := 100; end;
    with Columns.Add do begin Caption := 'Proje Adi'; Width := 200; end;
    with Columns.Add do begin Caption := 'Malzeme Sayisi'; Width := 110; end;
    with Columns.Add do begin Caption := 'Mamul'; Width := 90; end;
    with Columns.Add do begin Caption := 'Adet'; Width := 60; end;
  end;
end;

procedure TFormReceteler.ProjeleriVeTumListeyiGoster;
var
  Q, QSay: TFDQuery;
  Item: TListItem;
  Sira: Integer;
begin
  ListViewReceteler.Items.Clear;
  Sira := 0;

  try
    Q := DB.SQLSorgu('SELECT PROJE_NO, PROJE_ADI FROM PROJELER ORDER BY PROJE_NO');
    try
      while not Q.Eof do
      begin
        Inc(Sira);
        Item := ListViewReceteler.Items.Add;
        Item.Caption := IntToStr(Sira);
        Item.SubItems.Add(Q.FieldByName('PROJE_NO').AsString);
        Item.SubItems.Add(Q.FieldByName('PROJE_ADI').AsString);

        QSay := DB.SQLSorgu(
          'SELECT COUNT(*) AS CNT FROM RECETELER WHERE PROJE_NO = ' +
          QuotedStr(Q.FieldByName('PROJE_NO').AsString)
        );
        try
          Item.SubItems.Add(IntToStr(QSay.FieldByName('CNT').AsInteger));
        finally
          QSay.Free;
        end;

        Item.SubItems.Add(Q.FieldByName('PROJE_NO').AsString);
        Item.SubItems.Add('1');
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

procedure TFormReceteler.cmdYukleClick(Sender: TObject);
var
  OpenDlg: TOpenDialog;
  Dosyalar: TStringList;
  Satir, Parcalar: TStringList;
  i, Eklenen: Integer;
  J: Integer;
  ProjeNo, StokKodu, MalzemeAdi, ProjeAdi: string;
  Miktar: Double;
begin
  OpenDlg := TOpenDialog.Create(nil);
  Dosyalar := TStringList.Create;
  try
    OpenDlg.Title := 'Recete CSV Dosyalarini Sec';
    OpenDlg.Filter := 'CSV Dosyalari (*.csv)|*.csv|Tum Dosyalar (*.*)|*.*';
    OpenDlg.Options := [ofAllowMultiSelect, ofFileMustExist];

    if not OpenDlg.Execute then Exit;

    Eklenen := 0;

    for i := 0 to OpenDlg.Files.Count - 1 do
    begin
      Satir := TStringList.Create;
      try
        Satir.LoadFromFile(OpenDlg.Files[i], TEncoding.UTF8);
        Parcalar := TStringList.Create;
        Parcalar.Delimiter := ';';
        Parcalar.StrictDelimiter := True;

        for J := 1 to Satir.Count - 1 do
        begin
          Parcalar.DelimitedText := Satir[J];
          if Parcalar.Count >= 3 then
          begin
            ProjeNo := Trim(Parcalar[0]);
            StokKodu := Trim(Parcalar[1]);
            MalzemeAdi := Trim(Parcalar[2]);
            Miktar := StrToDoubleSafe(Parcalar[3]);

            if (ProjeNo <> '') and (StokKodu <> '') then
            begin
              if not ProjeVarMi(ProjeNo) then
              begin
                ProjeAdi := MalzemeAdi;
                if Parcalar.Count > 4 then ProjeAdi := Trim(Parcalar[4]);
                DB.SQLCalistir(
                  'INSERT OR IGNORE INTO PROJELER (PROJE_NO, PROJE_ADI, KAYIT_TARIHI) VALUES (' +
                  QuotedStr(ProjeNo) + ',' + QuotedStr(ProjeAdi) + ',' +
                  QuotedStr(FormatDateTime('dd.mm.yyyy', Now)) + ')'
                );
              end;
              if MalzemeProjeyeEkle(ProjeNo, StokKodu, Miktar) then
                Inc(Eklenen);
            end;
          end;
        end;
        Parcalar.Free;
      finally
        Satir.Free;
      end;
    end;

    ShowMessage(IntToStr(Eklenen) + ' recete satiri yuklendi.');
    ProjeleriVeTumListeyiGoster;
  finally
    OpenDlg.Free;
    Dosyalar.Free;
  end;
end;

procedure TFormReceteler.cmdSilClick(Sender: TObject);
var
  Item: TListItem;
  Silinen: Integer;
begin
  if ListViewReceteler.Items.Count = 0 then
  begin
    ShowMessage('Silinecek kayit yok.');
    Exit;
  end;

  Silinen := 0;
  for Item in ListViewReceteler.Items do
  begin
    if Item.Checked then
    begin
      if MessageDlg('Proje silinsin mi? ' + Item.SubItems[0],
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        DB.SQLCalistir('DELETE FROM RECETELER WHERE PROJE_NO = ' +
                        QuotedStr(Item.SubItems[0]));
        DB.SQLCalistir('DELETE FROM PROJELER WHERE PROJE_NO = ' +
                        QuotedStr(Item.SubItems[0]));
        Inc(Silinen);
      end;
    end;
  end;

  ShowMessage(IntToStr(Silinen) + ' proje silindi.');
  ProjeleriVeTumListeyiGoster;
end;

procedure TFormReceteler.cmdKaydetClick(Sender: TObject);
var
  SaveDlg: TSaveDialog;
  Dosya: TStringList;
  Q: TFDQuery;
  QR: TFDQuery;
begin
  SaveDlg := TSaveDialog.Create(nil);
  Dosya := TStringList.Create;
  try
    SaveDlg.Title := 'Recetleri Kaydet';
    SaveDlg.Filter := 'CSV Dosyasi (*.csv)|*.csv';
    SaveDlg.DefaultExt := 'csv';
    SaveDlg.FileName := 'Receteler_' + FormatDateTime('dd_mm_yyyy', Now);

    if not SaveDlg.Execute then Exit;

    Dosya.Add('PROJE_NO;STOK_KODU;MALZEME_ADI;MIKTAR;PROJE_ADI');

    Q := DB.SQLSorgu('SELECT * FROM PROJELER ORDER BY PROJE_NO');
    try
      while not Q.Eof do
      begin
        QR := DB.SQLSorgu(
          'SELECT * FROM RECETELER WHERE PROJE_NO = ' +
          QuotedStr(Q.FieldByName('PROJE_NO').AsString)
        );
        try
          while not QR.Eof do
          begin
            Dosya.Add(
              Q.FieldByName('PROJE_NO').AsString + ';' +
              QR.FieldByName('STOK_KODU').AsString + ';' +
              QR.FieldByName('MALZEME_ADI').AsString + ';' +
              FloatToStr(QR.FieldByName('MIKTAR').AsFloat) + ';' +
              Q.FieldByName('PROJE_ADI').AsString
            );
            QR.Next;
          end;
        finally
          QR.Free;
        end;
        Q.Next;
      end;
    finally
      Q.Free;
    end;

    Dosya.SaveToFile(SaveDlg.FileName, TEncoding.UTF8);
    ShowMessage('Receteler kaydedildi: ' + SaveDlg.FileName);
  finally
    SaveDlg.Free;
    Dosya.Free;
  end;
end;

procedure TFormReceteler.ListViewRecetelerDblClick(Sender: TObject);
begin
  if ListViewReceteler.Selected = nil then Exit;
  ListViewReceteler.Selected.Checked := not ListViewReceteler.Selected.Checked;
end;

procedure TFormReceteler.BtnKapatClick(Sender: TObject);
begin
  Close;
end;

end.
