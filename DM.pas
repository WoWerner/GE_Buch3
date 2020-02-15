unit dm;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  db,
  LazUTF8,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ZSqlMonitor,
  ZDataset,
  ZConnection;

type

  { TfrmDM }

  TfrmDM = class(TForm)
    dsBanken: TDatasource;
    dsDrucken: TDatasource;
    dsDruckenDetail: TDatasource;
    dsDruckenDetail1: TDatasource;
    dsPersonen: TDatasource;
    dsInit: TDatasource;
    dsHelp: TDatasource;
    dsSachkonten: TDatasource;
    dsJournal: TDatasource;
    ZConnectionBuch: TZConnection;
    ZConnectionGE_Kart: TZConnection;
    ZQueryBanken: TZQuery;
    ZQueryBankenAbschluss: TZQuery;
    ZQueryDrucken: TZQuery;
    ZQueryDruckenDetail: TZQuery;
    ZQueryDruckenDetail1: TZQuery;
    ZQueryHelp1: TZQuery;
    ZQueryPersonen: TZQuery;
    ZQueryInit: TZQuery;
    ZQueryHelp: TZQuery;
    ZQueryGE_Kart_Personen: TZQuery;
    ZQuerySachkonten: TZQuery;
    ZQueryJournal: TZQuery;
    ZSQLMonitor: TZSQLMonitor;
    procedure FormCreate(Sender: TObject);
    procedure ZQueryBankenAfterScroll(DataSet: TDataSet);
    procedure ZQueryJournalAfterScroll(DataSet: TDataSet);
    procedure ZQuerySachkontenAfterScroll(DataSet: TDataSet);
    procedure ZSQLMonitorLogTrace(Sender: TObject; Event: TZLoggingEvent);
  private
    { private declarations }
  public
    { public declarations }
    function CheckDB : boolean;
    Procedure CloseOpenQuerys;
    Procedure ExecuteTransactionSQL(sSQL: String);
    function ExecSQL(SQL: string; ExternProtected: boolean = false; Finalmessage: boolean = false): integer;
  end;

var
  frmDM: TfrmDM;

implementation

{$R *.lfm}

{ TfrmDM }

uses
  banken,
  sachkonten,
  journal,
  main,
  help,
  ZDbcLogging,
  ZDbcIntfs,        //ZConnection.TransactIsolationLevel
  global;


Function TfrmDM.ExecSQL(SQL: string; ExternProtected: boolean = false; Finalmessage: boolean = false): integer;

begin
  result := 0;
  if ExternProtected
    then ZConnectionBuch.ExecuteDirect(SQL, result)
    else
      begin
        screen.Cursor:=crSQLWait;
        try
          ZConnectionBuch.ExecuteDirect(SQL, result);
        except
          // Log Exception..
          on E: Exception do
            begin
              LogAndShowError(E.Message);
              raise;
            end;
        end;
        screen.Cursor:=crdefault;
      end;
  if Finalmessage
    then LogAndShow(format('%d Zeile(n) aktualsiert',[result]))
    else myDebugLN (format('%d Zeile(n) aktualsiert',[result]));
end;

Procedure TfrmDM.ExecuteTransactionSQL(sSQL: String);

var
  nHelp : integer;
  slHelp : TStringlist;

begin
  slHelp := TStringlist.Create;

  //Datenbank schliessen
  CloseOpenQuerys;
  ZConnectionBuch.Disconnect;

  //Vorbereiten für transaction
  ZConnectionBuch.AutoCommit             := false;
  ZConnectionBuch.TransactIsolationLevel := tiReadCommitted;
  ZConnectionBuch.Connect;

  slHelp.Text:=sSQL;
  //Alle Befehle absetzen
  for nHelp := 0 to slHelp.Count-1 do ZConnectionBuch.ExecuteDirect(slHelp.Strings[nHelp]);
  //und ausführen
  ZConnectionBuch.Commit;

  ZConnectionBuch.Disconnect;
  slHelp.Free;

  //Datenbank wieder mit Standardparametern öffnen
  ZConnectionBuch.AutoCommit             := true;
  ZConnectionBuch.TransactIsolationLevel := tiNone;
  ZConnectionBuch.Connect;
  ZQueryInit.Open;
end;

Procedure TfrmDM.CloseOpenQuerys;

begin
  if ZQueryInit.Active             then ZQueryInit.close;
  if ZQueryBanken.Active           then ZQueryBanken.Close;
  if ZQueryPersonen.Active         then ZQueryPersonen.Close;
  if ZQuerySachkonten.Active       then ZQuerySachkonten.Close;
  if ZQueryJournal.Active          then ZQueryJournal.Close;
  if ZQueryBankenAbschluss.Active  then ZQueryBankenAbschluss.Close;
  if ZQueryDrucken.Active          then ZQueryDrucken.Close;
  if ZQueryDruckenDetail.Active    then ZQueryDruckenDetail.Close;
  if ZQueryDruckenDetail1.Active   then ZQueryDruckenDetail1.Close;
  if ZQueryHelp1.Active            then ZQueryHelp1.Close;
  if ZQueryHelp.Active             then ZQueryHelp.Close;
  if ZQueryGE_Kart_Personen.Active then ZQueryGE_Kart_Personen.Close;

end;

function TfrmDM.CheckDB: boolean;

var
  sHelp : string;
  f     : TextFile;
  s     : String;
  Fehler: boolean;

  function DoDBUpdate(sNeuVersion, sFilename: String):string;

  begin
    sHelp  := '';
    Fehler := false;
    try
      frmMain.Datensicherung(true, true);
    except
      on E: Exception do
        begin
          sHelp := sHelp +#13#10+ e.Message+#13#10;
          Fehler := true;
        end;
    end;
    try
      AssignFile(F, sFilename);
      Reset(f);
      try
        while (not Eof(F)) and (not fehler) do
          begin
            ReadLn(F, s);
            Fehler := (ExecSQL(s , true, false) = -1);
          end;
      except
        on E: Exception do
          begin
            sHelp := sHelp +#13#10+ e.Message+#13#10;
            Fehler := true;
          end;
      end;
    except
      on E: Exception do
        begin
          sHelp := sHelp +#13#10+ e.Message+#13#10;
          Fehler := true;
        end;
    end;
    try
      CloseFile(f); //Ausgabedatei schliesen
    except
      //Tritt auf, wenn die Datei nicht offen war
    end;

    if not fehler then sHelp := 'Datenbankstruktur auf Version '+sNeuVersion+' angepasst.';
    LogAndShow(sHelp);
    result := sNeuVersion;
  end;

begin
  result := true;
  myDebugLN('Prüfe DB');

  //SQLite Version auslesen
  ZQueryHelp.SQL.Text := 'select sqlite_version() as version';
  ZQueryHelp.Open;
  myDebugLN('Aktuelle SQLite Version ist: '+ZQueryHelp.FieldByName('Version').asstring);
  ZQueryHelp.Close;
  myDebugLN('Aktuelle Zeos   Version ist: '+ZConnectionBuch.Version);

  //Version auslesen
  ZQueryHelp.SQL.Text := 'select Version from Version';
  ZQueryHelp.Open;
  sHelp := ZQueryHelp.FieldByName('Version').asstring;
  ZQueryHelp.Close;

  myDebugLN('Aktuelle Datenbank Version ist: '+sHelp);

  if sHelp = '1.0' then sHelp := DoDBUpdate('1.1',sAppDir+'module\update11.sql');
  if sHelp = '1.1' then sHelp := DoDBUpdate('1.4',sAppDir+'module\update14.sql');
  if sHelp = '1.4' then sHelp := DoDBUpdate('1.6',sAppDir+'module\update16.sql');
  if sHelp = '1.6' then sHelp := DoDBUpdate('1.7',sAppDir+'module\update17.sql');
  if sHelp = '1.7' then sHelp := DoDBUpdate('1.8',sAppDir+'module\update18.sql');
  if sHelp = '1.8' then sHelp := DoDBUpdate('1.9',sAppDir+'module\update19.sql');
  if sHelp = '1.9' then sHelp := DoDBUpdate('2.0',sAppDir+'module\update20.sql');

  //ResS1 = Aufwandsspende  (Value Ja oder Nein)
  ExecSQL('Update journal set ResS1='''+sNein+''' where ((ResS1='''') or (ResS1 is Null))' , false, false);

  //Prüfung auf zu neue DB Version
  result := not (strtoint(XCharsOnly(sHelp, ['0'..'9']))*100 > strtoint(XCharsOnly(sProductVersionString, ['0'..'9'])));       //Im Fehlerfall result auf false
end;

procedure TfrmDM.ZQueryBankenAfterScroll(DataSet: TDataSet);

begin
  if frmBanken.Visible then frmBanken.AfterScroll;
end;

procedure TfrmDM.FormCreate(Sender: TObject);

begin
  ZConnectionBuch.Database := UTF8ToSys(sDatabase);
  ZSQLMonitor.Active       := bSQLDebug;
end;


procedure TfrmDM.ZQueryJournalAfterScroll(DataSet: TDataSet);
begin
  if frmJournal.Visible then frmJournal.AfterScroll;
end;

procedure TfrmDM.ZQuerySachkontenAfterScroll(DataSet: TDataSet);
begin
  if frmSachkonten.Visible then frmSachkonten.AfterScroll;
end;

procedure TfrmDM.ZSQLMonitorLogTrace(Sender: TObject; Event: TZLoggingEvent);

var
  sMes: String;

begin
  if bSQLDebug
    then
      begin
        sMes := '';
        case Event.Category of
          lcConnect:      sMes := sMes + 'Connect           ';
          lcDisconnect:   sMes := sMes + 'Disconnect        ';
          lcTransaction:  sMes := sMes + 'Transaction       ';
          lcExecute:      sMes := sMes + 'Execute           ';
          lcPrepStmt:     sMes := sMes + 'Prepare           ';
          lcBindPrepStmt: sMes := sMes + 'Bind prepared     ';
          lcExecPrepStmt: sMes := sMes + 'Execute prepared  ';
          lcUnprepStmt:   sMes := sMes + 'Unprepare prepared';
        else
                          sMes := sMes + 'Other             ';
        end;

        sMes := sMes +' ' + Event.Message;

        if Event.Error <> '' then sMes := sMes +', Err: ' + Event.error;

         myDebugLN(sMes);
      end;
end;


end.

