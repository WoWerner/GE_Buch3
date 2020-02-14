program GE_Buch;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, datetimectrls,
  Main,
  dm,
  zcomponent,
  sachkonten,
  global,
  vinfo,
  uscaledpi,
  appsettings,
  einstellungen,
  personen,
  banken,
  journal,
  ausgabe,
  db_liste,
  drucken,
  csCSV,
  Journal_CSV_Import,
  uStrToDateFmt,
  PgmUpdate,
  input,
  help, journal_import_data;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDM, frmDM);
  Application.CreateForm(TfrmInput, frmInput);
  Application.CreateForm(TfrmSachkonten, frmSachkonten);
  Application.CreateForm(TfrmBanken, frmBanken);
  Application.CreateForm(TfrmEinstellungen, frmEinstellungen);
  Application.CreateForm(TfrmPersonen, frmPersonen);
  Application.CreateForm(TfrmJournal, frmJournal);
  Application.CreateForm(TfrmListe, frmListe);
  Application.CreateForm(TfrmDrucken, frmDrucken);
  Application.CreateForm(TfrmAusgabe, frmAusgabe);
  Application.CreateForm(TfrmPgmUpdate,frmPgmUpdate);
  Application.CreateForm(TfrmJournal_CSV_Import, frmJournal_CSV_Import);
  HighDPI(nDefDPI);  //Scaliert alle Formulare bei anderen Schriftarten
  if ParamCount = 1 then sPW := ParamStr(1) else sPW := '';
  Application.CreateForm(TfrmImportData, frmImportData);
  Application.Run;
end.

