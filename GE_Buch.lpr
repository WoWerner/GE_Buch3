program GE_Buch;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  appsettings,
  Ausgabe,
  Freelist,
  help,
  input,
  PgmUpdate,
  uhttpdownloader,
  vinfo,
  printer4lazarus,
  datetimectrls,
  zcomponent,
  zcore,
  global,
  csCSV,
  Main,
  dm,
  sachkonten,
  einstellungen,
  personen,
  banken,
  journal,
  db_liste,
  drucken,
  Journal_CSV_Import,
  uStrToDateFmt,
  mailsend,
  Progress;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDM, frmDM);
  Application.CreateForm(TfrmSachkonten, frmSachkonten);
  Application.CreateForm(TfrmBanken, frmBanken);
  Application.CreateForm(TfrmEinstellungen, frmEinstellungen);
  Application.CreateForm(TfrmPersonen, frmPersonen);
  Application.CreateForm(TfrmJournal, frmJournal);
  Application.CreateForm(TfrmListe, frmListe);
  Application.CreateForm(TfrmInput, frmInput);
  Application.CreateForm(TfrmDrucken, frmDrucken);
  Application.CreateForm(TfrmJournal_CSV_Import, frmJournal_CSV_Import);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmPgmUpdate, frmPgmUpdate);
  Application.CreateForm(TfrmAusgabe, frmAusgabe);
  Application.CreateForm(TfrmFreieListe, frmFreieListe);
  if ParamCount = 1 then sPW := ParamStr(1) else sPW := '';
  Application.Run;
end.

