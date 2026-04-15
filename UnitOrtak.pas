unit UnitOrtak;

interface

uses
  System.SysUtils, System.Classes, System.Math,
  FireDAC.Comp.Client,
  UnitVeritabani;

type
  TMalzeme = record
    StokKodu: string;
    MalzemeAdi: string;
    Fiyat: Double;
    FiyatTipi: string;
  end;

  TProje = record
    ProjeNo: string;
    ProjeAdi: string;
    SatisFiyati: Double;
  end;

  TReceteKalem = record
    ProjeNo: string;
    StokKodu: string;
    MalzemeAdi: string;
    Miktar: Double;
    TFiyat: Double;
    Fiyat485: Double;
  end;

// Yardimci fonksiyonlar
function FormatPara(Value: Double): string;
function StrToDoubleSafe(const S: string): Double;
function MalzemeAdiBul(const StokKodu: string): string;
function MalzemeFiyatBul(const StokKodu, FiyatListesi: string): Double;
function Malzeme485FiyatBul(const StokKodu: string): Double;
function ProjeVarMi(const ProjeNo: string): Boolean;
function MalzemeProjeyeEkle(const ProjeNo, StokKodu: string; Miktar: Double): Boolean;
function MalzemeProjedeSil(const ProjeNo, StokKodu: string; SatirNo: Integer): Boolean;
function MalzemeMiktarGuncelle(const ProjeNo, StokKodu: string; SatirNo: Integer; YeniMiktar: Double): Boolean;
function ProjeMalzemeToplami(const ProjeNo, FiyatListesi: string): Double;
function ProjeToplamı485(const ProjeNo: string): Double;
function MalzemeProjelerdeAra(const StokKodu: string): TArray<TReceteKalem>;

implementation

function FormatPara(Value: Double): string;
begin
  Result := FormatFloat('#,##0.00', Value);
end;

function StrToDoubleSafe(const S: string): Double;
var
  TempS: string;
begin
  Result := 0;
  TempS := Trim(S);
  TempS := StringReplace(TempS, ',', '.', [rfReplaceAll]);
  if TempS = '' then Exit;
  try
    Result := StrToFloat(TempS);
  except
    Result := 0;
  end;
end;

function MalzemeAdiBul(const StokKodu: string): string;
var
  Q: TFDQuery;
begin
  Result := '';
  try
    Q := DB.SQLSorgu(
      'SELECT MALZEME_ADI FROM MALZEMELER WHERE STOK_KODU = ' +
      QuotedStr(Trim(StokKodu)) + ' LIMIT 1'
    );
    try
      if not Q.IsEmpty then
        Result := Q.FieldByName('MALZEME_ADI').AsString;
    finally
      Q.Free;
    end;
  except end;

  if Result = '' then
  try
    Q := DB.SQLSorgu(
      'SELECT MALZEME_ADI FROM MALZEME_485 WHERE STOK_KODU = ' +
      QuotedStr(Trim(StokKodu)) + ' LIMIT 1'
    );
    try
      if not Q.IsEmpty then
        Result := Q.FieldByName('MALZEME_ADI').AsString;
    finally
      Q.Free;
    end;
  except end;
end;

function MalzemeFiyatBul(const StokKodu, FiyatListesi: string): Double;
var
  Q: TFDQuery;
  Liste: string;
begin
  Result := 0;
  Liste := FiyatListesi;
  if Liste = '' then Liste := 'TFIYAT';
  try
    Q := DB.SQLSorgu(
      'SELECT FIYAT FROM MALZEMELER WHERE STOK_KODU = ' +
      QuotedStr(Trim(StokKodu)) +
      ' AND FIYAT_TIPI = ' + QuotedStr(Liste) + ' LIMIT 1'
    );
    try
      if not Q.IsEmpty then
        Result := Q.FieldByName('FIYAT').AsFloat;
    finally
      Q.Free;
    end;
  except end;
end;

function Malzeme485FiyatBul(const StokKodu: string): Double;
var
  Q: TFDQuery;
begin
  Result := 0;
  try
    Q := DB.SQLSorgu(
      'SELECT FIYAT FROM MALZEME_485 WHERE STOK_KODU = ' +
      QuotedStr(Trim(StokKodu)) + ' LIMIT 1'
    );
    try
      if not Q.IsEmpty then
        Result := Q.FieldByName('FIYAT').AsFloat;
    finally
      Q.Free;
    end;
  except end;
end;

function ProjeVarMi(const ProjeNo: string): Boolean;
var
  Q: TFDQuery;
begin
  Result := False;
  try
    Q := DB.SQLSorgu(
      'SELECT COUNT(*) AS CNT FROM PROJELER WHERE PROJE_NO = ' +
      QuotedStr(Trim(ProjeNo))
    );
    try
      Result := Q.FieldByName('CNT').AsInteger > 0;
    finally
      Q.Free;
    end;
  except end;
end;

function MalzemeProjeyeEkle(const ProjeNo, StokKodu: string; Miktar: Double): Boolean;
var
  Q: TFDQuery;
  Sayac: Integer;
  MalAdi: string;
begin
  Result := False;
  try
    // Zaten var mı?
    Q := DB.SQLSorgu(
      'SELECT COUNT(*) AS CNT FROM RECETELER WHERE PROJE_NO = ' +
      QuotedStr(ProjeNo) + ' AND STOK_KODU = ' + QuotedStr(StokKodu)
    );
    Sayac := Q.FieldByName('CNT').AsInteger;
    Q.Free;

    if Sayac > 0 then Exit;

    MalAdi := MalzemeAdiBul(StokKodu);

    DB.SQLCalistir(
      'INSERT INTO RECETELER (PROJE_NO, STOK_KODU, MALZEME_ADI, MIKTAR, KAYIT_TARIHI) ' +
      'VALUES (' +
      QuotedStr(ProjeNo) + ',' +
      QuotedStr(StokKodu) + ',' +
      QuotedStr(MalAdi) + ',' +
      FloatToStr(Miktar) + ',' +
      QuotedStr(FormatDateTime('dd.mm.yyyy', Now)) +
      ')'
    );
    Result := True;
  except
    on E: Exception do
      Result := False;
  end;
end;

function MalzemeProjedeSil(const ProjeNo, StokKodu: string; SatirNo: Integer): Boolean;
begin
  Result := False;
  try
    DB.SQLCalistir(
      'DELETE FROM RECETELER WHERE ID = ' + IntToStr(SatirNo) +
      ' AND PROJE_NO = ' + QuotedStr(ProjeNo) +
      ' AND STOK_KODU = ' + QuotedStr(StokKodu)
    );
    Result := True;
  except
    Result := False;
  end;
end;

function MalzemeMiktarGuncelle(const ProjeNo, StokKodu: string; SatirNo: Integer; YeniMiktar: Double): Boolean;
begin
  Result := False;
  try
    DB.SQLCalistir(
      'UPDATE RECETELER SET MIKTAR = ' + FloatToStr(YeniMiktar) +
      ' WHERE ID = ' + IntToStr(SatirNo) +
      ' AND PROJE_NO = ' + QuotedStr(ProjeNo) +
      ' AND STOK_KODU = ' + QuotedStr(StokKodu)
    );
    Result := True;
  except
    Result := False;
  end;
end;

function ProjeMalzemeToplami(const ProjeNo, FiyatListesi: string): Double;
var
  Q: TFDQuery;
  Fiyat: Double;
  Liste: string;
begin
  Result := 0;
  Liste := FiyatListesi;
  if Liste = '' then Liste := 'TFIYAT';
  try
    Q := DB.SQLSorgu(
      'SELECT R.STOK_KODU, R.MIKTAR, M.FIYAT ' +
      'FROM RECETELER R ' +
      'LEFT JOIN MALZEMELER M ON R.STOK_KODU = M.STOK_KODU AND M.FIYAT_TIPI = ' +
      QuotedStr(Liste) +
      ' WHERE R.PROJE_NO = ' + QuotedStr(ProjeNo)
    );
    try
      while not Q.Eof do
      begin
        Fiyat := Q.FieldByName('FIYAT').AsFloat;
        Result := Result + (Fiyat * Q.FieldByName('MIKTAR').AsFloat);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

function ProjeToplamı485(const ProjeNo: string): Double;
var
  Q: TFDQuery;
begin
  Result := 0;
  try
    Q := DB.SQLSorgu(
      'SELECT R.MIKTAR, M.FIYAT ' +
      'FROM RECETELER R ' +
      'LEFT JOIN MALZEME_485 M ON R.STOK_KODU = M.STOK_KODU ' +
      'WHERE R.PROJE_NO = ' + QuotedStr(ProjeNo) +
      ' AND R.STOK_KODU LIKE ''485%'''
    );
    try
      while not Q.Eof do
      begin
        Result := Result + (Q.FieldByName('FIYAT').AsFloat * Q.FieldByName('MIKTAR').AsFloat);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
end;

function MalzemeProjelerdeAra(const StokKodu: string): TArray<TReceteKalem>;
var
  Q: TFDQuery;
  Kalem: TReceteKalem;
  Liste: TArray<TReceteKalem>;
  Sayac: Integer;
begin
  SetLength(Liste, 0);
  Sayac := 0;
  try
    Q := DB.SQLSorgu(
      'SELECT R.ID, R.PROJE_NO, R.STOK_KODU, R.MALZEME_ADI, R.MIKTAR, ' +
      'P.PROJE_ADI ' +
      'FROM RECETELER R ' +
      'LEFT JOIN PROJELER P ON R.PROJE_NO = P.PROJE_NO ' +
      'WHERE R.STOK_KODU = ' + QuotedStr(StokKodu)
    );
    try
      while not Q.Eof do
      begin
        Kalem.ProjeNo := Q.FieldByName('PROJE_NO').AsString;
        Kalem.StokKodu := Q.FieldByName('STOK_KODU').AsString;
        Kalem.MalzemeAdi := Q.FieldByName('PROJE_ADI').AsString;
        Kalem.Miktar := Q.FieldByName('MIKTAR').AsFloat;
        Kalem.TFiyat := MalzemeFiyatBul(StokKodu, 'TFIYAT');
        Kalem.Fiyat485 := Malzeme485FiyatBul(StokKodu);
        SetLength(Liste, Sayac + 1);
        Liste[Sayac] := Kalem;
        Inc(Sayac);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except end;
  Result := Liste;
end;

end.
