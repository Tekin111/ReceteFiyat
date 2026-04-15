unit UnitVeritabani;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  Data.DB;

type
  TVeritabani = class
  private
    FConn: TFDConnection;
    FDBPath: string;
    procedure TabloOlustur;
  public
    constructor Create;
    destructor Destroy; override;
    function Baglanti: TFDConnection;
    procedure SQLCalistir(const ASQL: string);
    function SQLSorgu(const ASQL: string): TFDQuery;
    property DBPath: string read FDBPath;
  end;

var
  DB: TVeritabani;

implementation

constructor TVeritabani.Create;
var
  ExePath: string;
begin
  inherited;
  ExePath := ExtractFilePath(ParamStr(0));
  FDBPath := ExePath + 'ReceteFiyat.db';

  FConn := TFDConnection.Create(nil);
  FConn.DriverName := 'SQLite';
  FConn.Params.Values['Database'] := FDBPath;
  FConn.Params.Values['OpenMode'] := 'CreateUTF8';
  FConn.LoginPrompt := False;

  try
    FConn.Open;
    TabloOlustur;
  except
    on E: Exception do
      raise Exception.Create('Veritabani baglanti hatasi: ' + E.Message);
  end;
end;

destructor TVeritabani.Destroy;
begin
  if Assigned(FConn) then
  begin
    FConn.Close;
    FConn.Free;
  end;
  inherited;
end;

function TVeritabani.Baglanti: TFDConnection;
begin
  Result := FConn;
end;

procedure TVeritabani.SQLCalistir(const ASQL: string);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TVeritabani.SQLSorgu(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConn;
  Result.SQL.Text := ASQL;
  Result.Open;
end;

procedure TVeritabani.TabloOlustur;
begin
  // MALZEMELER tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS MALZEMELER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  STOK_KODU TEXT NOT NULL,' +
    '  MALZEME_ADI TEXT,' +
    '  FIYAT REAL DEFAULT 0,' +
    '  FIYAT_TIPI TEXT DEFAULT ''TFIYAT'',' +
    '  KAYIT_TARIHI TEXT' +
    ');'
  );

  // MALZEME_485 tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS MALZEME_485 (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  STOK_KODU TEXT NOT NULL,' +
    '  MALZEME_ADI TEXT,' +
    '  FIYAT REAL DEFAULT 0,' +
    '  KAYIT_TARIHI TEXT' +
    ');'
  );

  // PROJELER tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS PROJELER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  PROJE_NO TEXT NOT NULL UNIQUE,' +
    '  PROJE_ADI TEXT,' +
    '  SATIS_FIYATI REAL DEFAULT 0,' +
    '  KAYIT_TARIHI TEXT' +
    ');'
  );

  // RECETELER tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS RECETELER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  PROJE_NO TEXT NOT NULL,' +
    '  STOK_KODU TEXT NOT NULL,' +
    '  MALZEME_ADI TEXT,' +
    '  MIKTAR REAL DEFAULT 0,' +
    '  KAYIT_TARIHI TEXT' +
    ');'
  );

  // ANALIZLER tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS ANALIZLER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  STOK_KODU TEXT,' +
    '  STOK_ADI TEXT,' +
    '  MALZEME_TOPLAM REAL DEFAULT 0,' +
    '  MGG_YUZDE REAL DEFAULT 0,' +
    '  MGG_HESAP REAL DEFAULT 0,' +
    '  NAKLIYE REAL DEFAULT 0,' +
    '  ISCILIK_UCRET REAL DEFAULT 0,' +
    '  ISCILIK_DAKIKA REAL DEFAULT 0,' +
    '  ISCILIK REAL DEFAULT 0,' +
    '  KAR_YUZDE REAL DEFAULT 0,' +
    '  KAR REAL DEFAULT 0,' +
    '  TOPLAM REAL DEFAULT 0,' +
    '  TOPLAM_485 REAL DEFAULT 0,' +
    '  TOPLAM_SATIS REAL DEFAULT 0,' +
    '  ESKI_FIYAT REAL DEFAULT 0,' +
    '  HEDEF_FIYAT REAL DEFAULT 0,' +
    '  NOT_METNI TEXT,' +
    '  FIYAT_LISTESI TEXT,' +
    '  TARIH TEXT,' +
    '  URETIM_MIKTAR REAL DEFAULT 0' +
    ');'
  );

  // HEDEF_FIYAT tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS HEDEF_FIYAT (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  STOK_KODU TEXT NOT NULL UNIQUE,' +
    '  ACIKLAMA TEXT,' +
    '  HEDEF_FIYAT REAL DEFAULT 0' +
    ');'
  );

  // URETIM tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS URETIM (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  STOK_KODU TEXT NOT NULL,' +
    '  STOK_ADI TEXT,' +
    '  URETIM_MIKTAR REAL DEFAULT 0' +
    ');'
  );

  // FIYAT_LISTELERI tablosu
  SQLCalistir(
    'CREATE TABLE IF NOT EXISTS FIYAT_LISTELERI (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  LISTE_ADI TEXT NOT NULL UNIQUE,' +
    '  SIRA_NO INTEGER DEFAULT 0,' +
    '  AKTIF INTEGER DEFAULT 1' +
    ');'
  );

  // Varsayılan fiyat listesi ekle
  SQLCalistir(
    'INSERT OR IGNORE INTO FIYAT_LISTELERI (LISTE_ADI, SIRA_NO, AKTIF) ' +
    'VALUES (''TFIYAT'', 1, 1);'
  );

  // Index'ler
  SQLCalistir('CREATE INDEX IF NOT EXISTS IDX_MAL_STOK ON MALZEMELER(STOK_KODU);');
  SQLCalistir('CREATE INDEX IF NOT EXISTS IDX_485_STOK ON MALZEME_485(STOK_KODU);');
  SQLCalistir('CREATE INDEX IF NOT EXISTS IDX_REC_PROJE ON RECETELER(PROJE_NO);');
  SQLCalistir('CREATE INDEX IF NOT EXISTS IDX_REC_STOK ON RECETELER(STOK_KODU);');
  SQLCalistir('CREATE INDEX IF NOT EXISTS IDX_ANL_STOK ON ANALIZLER(STOK_KODU);');
end;

end.
