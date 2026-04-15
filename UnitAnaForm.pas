unit UnitAnaForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  UnitVeritabani;

type
  TAnaForm = class(TForm)
    PnlBaslik: TPanel;
    LblBaslik: TLabel;
    CmdProjeler: TButton;
    CmdAnaliz1: TButton;
    CmdArama: TButton;
    CmdMalzemeDegistirme: TButton;
    CmdMalzemeEkle: TButton;
    CmdReceteler: TButton;
    CmdMalzemeMiktarDegistirme: TButton;
    CmbTreceteler: TButton;
    CmbBilgiler: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CmdProJelerClick(Sender: TObject);
    procedure CmdAnaliz1Click(Sender: TObject);
    procedure CmdAramaClick(Sender: TObject);
    procedure CmdMalzemeDegistirmeClick(Sender: TObject);
    procedure CmdMalzemeEkleClick(Sender: TObject);
    procedure CmdRecetelerClick(Sender: TObject);
    procedure CmdMalzemeMiktarDegistirmeClick(Sender: TObject);
    procedure CmbTrecetelerClick(Sender: TObject);
    procedure CmbBilgilerClick(Sender: TObject);
  private
  public
  end;

var
  AnaForm: TAnaForm;

implementation

{$R *.dfm}

uses
  UnitProjeler, UnitAnaliz, UnitArama,
  UnitMalzemeDegistirme, UnitMalzemeEkle,
  UnitMiktarDegistirme, UnitReceteler;

procedure TAnaForm.FormCreate(Sender: TObject);
begin
  try
    DB := TVeritabani.Create;
  except
    on E: Exception do
    begin
      ShowMessage('Veritabani hatasi: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TAnaForm.FormDestroy(Sender: TObject);
begin
  if Assigned(DB) then
    FreeAndNil(DB);
end;

procedure TAnaForm.CmdProJelerClick(Sender: TObject);
begin
  FormProjeler.ShowModal;
end;

procedure TAnaForm.CmdAnaliz1Click(Sender: TObject);
begin
  FormAnaliz.ShowModal;
end;

procedure TAnaForm.CmdAramaClick(Sender: TObject);
begin
  FormArama.ShowModal;
end;

procedure TAnaForm.CmdMalzemeDegistirmeClick(Sender: TObject);
begin
  FormMalzemeDegistirme.ShowModal;
end;

procedure TAnaForm.CmdMalzemeEkleClick(Sender: TObject);
begin
  FormMalzemeEkle.ShowModal;
end;

procedure TAnaForm.CmdRecetelerClick(Sender: TObject);
begin
  FormReceteler.ShowModal;
end;

procedure TAnaForm.CmdMalzemeMiktarDegistirmeClick(Sender: TObject);
begin
  FormMiktarDegistirme.ShowModal;
end;

procedure TAnaForm.CmbTrecetelerClick(Sender: TObject);
begin
  ShowMessage('Receteler veritabani aktif.');
end;

procedure TAnaForm.CmbBilgilerClick(Sender: TObject);
begin
  ShowMessage('Bilgiler veritabani: ' + DB.DBPath);
end;

end.
