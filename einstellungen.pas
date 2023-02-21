unit einstellungen;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  FileUtil,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  DbCtrls;

type

  { TfrmEinstellungen }

  TfrmEinstellungen = class(TForm)
    btnAbbrechen: TButton;
    btnClose: TButton;
    btnSpeichern: TButton;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btnAbbrechenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmEinstellungen: TfrmEinstellungen;

implementation

{$R *.lfm}

{ TfrmEinstellungen }

uses dm, db;

procedure TfrmEinstellungen.btnCloseClick(Sender: TObject);

var
  mrResult: TModalresult;

begin
  mrResult := mrYes;
  if frmDM.ZQueryInit.State = dsEdit
    then
      begin
        mrResult := MessageDlg('Sollen die Änderungen wirklich nicht gespeichert werden?', mtConfirmation, [mbYes, mbNo],0);
        if mrResult = mrYes
          then
            begin
              frmDM.ZQueryInit.Cancel;
              frmDM.ZQueryInit.Refresh;
            end;
      end;
  if mrResult = mrYes then close;
end;

procedure TfrmEinstellungen.btnAbbrechenClick(Sender: TObject);
begin
  if frmDM.ZQueryInit.State = dsEdit then frmDM.ZQueryInit.Cancel;
  frmDM.ZQueryInit.Refresh;
  close;
end;

procedure TfrmEinstellungen.btnSpeichernClick(Sender: TObject);
begin
  if frmDM.ZQueryInit.State = dsEdit
    then
      begin
        frmDM.ZQueryInit.Post;
        showmessage('Gepeichert. Zum übernehmen der Daten muß das Programm beendet und neu gestartet werden.');
      end
    else
      showmessage('Nichts zum speichern!');
  frmDM.ZQueryInit.Refresh;
end;

end.

