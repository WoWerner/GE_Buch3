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
    btnSendTestMail: TButton;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    dbEdiRendantMail: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    dbEdiServer: TDBEdit;
    dbEdiPort: TDBEdit;
    dbEdiEMailUserName: TDBEdit;
    dbEdiServerPasswort: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    dbEdiRendantName: TDBEdit;
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
    procedure btnSendTestMailClick(Sender: TObject);
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

uses
  dm,
  mailsend,
  db;

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

procedure TfrmEinstellungen.btnSendTestMailClick(Sender: TObject);

var
  Content,
  Attach      : TStringList;
  SMTP        : TMySMTPSend;

begin
  try
    Content   := TStringList.Create;
    Attach    := TStringList.Create;
    SMTP      := TMySMTPSend.Create;

    Content.Add('Hallo,'#13#13'hier kommt Ihre Test Email!'#13#13'Mit freundlichen Grüßen'#13+dbEdiRendantName.Text);
    Attach.Clear;

    SMTP.TargetHost       := dbEdiServer.Text;
    SMTP.TargetPort       := dbEdiPort.Text;
    SMTP.Username         := dbEdiEMailUserName.Text;
    SMTP.Password         := dbEdiServerPasswort.Text;
    SMTP.FullSSL          := True;
    SMTP.Sock.RaiseExcept := True;

    try
      if SMTP.SendMessage( dbEdiRendantName.Text+' <'+dbEdiRendantMail.Text+'>',     // AFrom
                           dbEdiRendantMail.Text, // ATo
                           'TestMail', // ASubject
                           Content,
                           Attach)
        then
          begin
            MessageDlg('EMail', 'Erfolgreich: Sende Mail zu '+dbEdiRendantMail.Text, mtInformation, [mbOK], 0);
          end
        else
          begin
            MessageDlg('EMail', 'Fehler: Sende Mail zu '+dbEdiRendantMail.Text+ #13#10 + SMTP.FullResult.Text, mtInformation, [mbOK], 0);
          end;
    except
      on E: Exception do
        begin
          MessageDlg('Fehler', 'EXCEPTION: '+ E.Message, mtError, [mbOK], 0);
        end;
    end;
  finally
    Content.Free;
    Attach.free;
    SMTP.Free;
  end
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

