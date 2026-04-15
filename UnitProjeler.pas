unit UnitProjeler;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  UnitVeritabani, UnitOrtak;

type
  TFormProjeler = class(TForm)
    PnlUst: TPanel;
    TextBox1: TEdit;
    LblArama: TLabel;
    ListView1: TListView;
    BtnKapat: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TextBox1Change(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure BtnKapatClick(Sender: TObject);
  private
    FSeciliProjeNo: string;
    procedure ListeAyarla;
    procedure ProjeleriYukle(const Arama: string);
  public
    property SeciliProjeNo: string read FSeciliProjeNo;
  end;

var
  FormProjeler: TFormProjeler;

implementation

{$R *.dfm}

procedure TFormProjeler.FormCreate(Sender: TObject);
begin
  FSeciliProjeNo := '';
  ListeAyarla;
end;

procedure TFormProjeler.FormShow(Sender: TObject);
begin
  FSeciliProjeNo := '';
  TextBox1.Clear;
  ProjeleriYukle('');
  TextBox1.SetFocus;
end;

procedure TFormProjeler.ListeAyarla;
begin
  with ListView1 do
  begin
    Items.Clear;
    Columns.Clear;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines := True;
    Color := $00E0FFFF;
    
    with Columns.Add do
    begin
      Caption := 'Proje Numarasi';
      Width := 110;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Proje Ismi';
      Width := 250;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Malzeme Toplami';
      Width := 120;
    end;
    
    with Columns.Add do
    begin
      Caption := '485 Toplami';
      Width := 110;
    end;
    
    with Columns.Add do
    begin
      Caption := 'Satis Fiyati';
      Width := 110;
    end;
  end;
end;

procedure TFormProjeler.ProjeleriYukle(const Arama: string);
var
  Q: TFDQuery;
  Item: TListItem;
  SQL: string;
  AramaL: string;
  MalToplam, Toplam485: Double;
begin
  ListView1.Items.Clear;
  AramaL := LowerCase(Trim(Arama));

  SQL := 'SELECT PROJE_NO, PROJE_ADI, SATIS_FIYATI FROM PROJELER';
  if AramaL <> '' then
    SQL := SQL + ' WHERE (LOWER(PROJE_NO) LIKE ' + QuotedStr('%' + AramaL + '%') +
           ' OR LOWER(PROJE_ADI) LIKE ' + QuotedStr('%' + AramaL + '%') + ')';
  SQL := SQL + ' ORDER BY PROJE_NO';

  try
    Q := DB.SQLSorgu(SQL);
    try
      while not Q.Eof do
      begin
        MalToplam := ProjeMalzemeToplami(Q.FieldByName('PROJE_NO').AsString, 'TFIYAT');
        Toplam485 := ProjeToplamı485(Q.FieldByName('PROJE_NO').AsString);

        Item := ListView1.Items.Add;
        Item.Caption := Q.FieldByName('PROJE_NO').AsString;
        Item.SubItems.Add(Q.FieldByName('PROJE_ADI').AsString);
        
        if MalToplam > 0 then
          Item.SubItems.Add(FormatPara(MalToplam))
        else
          Item.SubItems.Add('');
          
        if Toplam485 > 0 then
          Item.SubItems.Add(FormatPara(Toplam485))
        else
          Item.SubItems.Add('');
          
        if Q.FieldByName('SATIS_FIYATI').AsFloat > 0 then
          Item.SubItems.Add(FormatPara(Q.FieldByName('SATIS_FIYATI').AsFloat))
        else
          Item.SubItems.Add('');
          
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Veri yukleme hatasi: ' + E.Message);
  end;
end;

procedure TFormProjeler.TextBox1Change(Sender: TObject);
begin
  ProjeleriYukle(TextBox1.Text);
end;

procedure TFormProjeler.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected = nil then Exit;
  FSeciliProjeNo := ListView1.Selected.Caption;
  ModalResult := mrOk;
end;

procedure TFormProjeler.BtnKapatClick(Sender: TObject);
begin
  Close;
end;

end.
