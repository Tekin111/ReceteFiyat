# 🏭 REÇETE VE FİYATLANDIRMA PROGRAMI

Delphi 13 ile yazılmış profesyonel malzeme reçete yönetimi ve fiyatlandırma programı.

## 📋 Özellikler

✅ **Proje Yönetimi**
- Proje bazlı reçete yönetimi
- Malzeme ekleme/çıkarma/değiştirme
- Miktar güncelleme

✅ **Fiyatlandırma**
- Malzeme fiyat listeleri (TFIYAT, 485)
- Analiz ve maliyet hesaplama
- MGG, İşçilik, Kar hesaplamaları
- Hedef fiyat karşılaştırma

✅ **Veritabanı**
- SQLite veritabanı (hafif ve hızlı)
- FireDAC kullanımı
- Otomatik tablo oluşturma

✅ **Raporlama**
- CSV import/export
- Analiz kayıtları
- Not sistemi

## 🚀 Kurulum

### Gereksinimler
- **Delphi 13 Community Edition** (veya üstü)
- **Windows 10/11**
- **FireDAC** (Delphi ile birlikte gelir)

### Adımlar

1. **Delphi 13 Community** indirin ve kurun
2. Projeyi indirin veya klonlayın
3. `ReceteFiyat.dpr` dosyasını Delphi'de açın
4. **Build** > **Compile ReceteFiyat**
5. **Run** (F9)

## 📖 Kullanım

### İlk Çalıştırma

Program ilk açıldığında:
- `ReceteFiyat.db` otomatik oluşturulur
- Tüm tablolar hazırlanır
- Varsayılan fiyat listesi (TFIYAT) eklenir

### Test Verisi Ekleme

SQLite veritabanına örnek veri eklemek için:

```sql
-- Malzeme ekle
INSERT INTO MALZEMELER (STOK_KODU, MALZEME_ADI, FIYAT, FIYAT_TIPI) 
VALUES ('124.001.002', 'OLFLEX 191 3G1,5', 1.21, 'TFIYAT');

-- 485 Malzeme
INSERT INTO MALZEME_485 (STOK_KODU, MALZEME_ADI, FIYAT) 
VALUES ('485.001.001', 'Örnek 485 Malzeme', 0.50);

-- Proje ekle
INSERT INTO PROJELER (PROJE_NO, PROJE_ADI, SATIS_FIYATI) 
VALUES ('800.MIP.031', '1022470100 VT-130 KTK', 0);

-- Reçete ekle
INSERT INTO RECETELER (PROJE_NO, STOK_KODU, MALZEME_ADI, MIKTAR) 
VALUES ('800.MIP.031', '124.001.002', 'OLFLEX 191 3G1,5', 2.5);
