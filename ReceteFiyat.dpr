program ReceteFiyat;

uses
  Vcl.Forms,
  UnitAnaForm in 'UnitAnaForm.pas' {AnaForm},
  UnitAnaliz in 'UnitAnaliz.pas' {FormAnaliz},
  UnitArama in 'UnitArama.pas' {FormArama},
  UnitMalzemeDegistirme in 'UnitMalzemeDegistirme.pas' {FormMalzemeDegistirme},
  UnitMalzemeEkle in 'UnitMalzemeEkle.pas' {FormMalzemeEkle},
  UnitMiktarDegistirme in 'UnitMiktarDegistirme.pas' {FormMiktarDegistirme},
  UnitProjeler in 'UnitProjeler.pas' {FormProjeler},
  UnitReceteler in 'UnitReceteler.pas' {FormReceteler},
  UnitVeritabani in 'UnitVeritabani.pas',
  UnitOrtak in 'UnitOrtak.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Recete ve Fiyatlandirma';
  Application.CreateForm(TAnaForm, AnaForm);
  Application.CreateForm(TFormAnaliz, FormAnaliz);
  Application.CreateForm(TFormArama, FormArama);
  Application.CreateForm(TFormMalzemeDegistirme, FormMalzemeDegistirme);
  Application.CreateForm(TFormMalzemeEkle, FormMalzemeEkle);
  Application.CreateForm(TFormMiktarDegistirme, FormMiktarDegistirme);
  Application.CreateForm(TFormProjeler, FormProjeler);
  Application.CreateForm(TFormReceteler, FormReceteler);
  Application.Run;
end.
