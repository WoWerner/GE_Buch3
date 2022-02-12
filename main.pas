unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  fileutil,
  LazUTF8,
  LR_Class,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  appsettings,
  LCLIntf,      //Openurl
  Menus,
  ExtCtrls,
  ComCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBankkonten: TButton;
    btnClose: TButton;
    btnJournal: TButton;
    btnDrucken: TButton;
    btnSachkonten: TButton;
    btnPersonen: TButton;
    btnAktuelles: TButton;
    imgSELK: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    labDatensicherung: TLabel;
    labBJahr: TLabel;
    labProgress: TLabel;
    LabGemeinde1: TLabel;
    LabGemeinde2: TLabel;
    LabRendant1: TLabel;
    LabRendant2: TLabel;
    labMyMail: TLabel;
    LabMyName: TLabel;
    labMyStreet: TLabel;
    labMyWeb: TLabel;
    labVersion: TLabel;
    labVersionNeu: TLabel;
    lb_Name: TLabel;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    mnuJournalLast: TMenuItem;
    mnuJournalJump: TMenuItem;
    mnuShowDebug: TMenuItem;
    mnuEuroModus: TMenuItem;
    mnuFehlerSuchen: TMenuItem;
    mnuTausender: TMenuItem;
    mnuExecSQLBatch: TMenuItem;
    mnuExportZuwendung: TMenuItem;
    mnuSuchtexteImport: TMenuItem;
    mnuLimitsZahlerverteilungAlter: TMenuItem;
    mnuLimitsZahlerBetrag: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnuHilfe: TMenuItem;
    mnuSQLDebug: TMenuItem;
    mnuDebug: TMenuItem;
    mnuEinstellungen: TMenuItem;
    mnuDelOldPersonen: TMenuItem;
    mnuZahlerverteilungAlter: TMenuItem;
    mnuZahlerBetrag: TMenuItem;
    mnuCleanAutoBuchen: TMenuItem;
    mnuExecSQLSingle: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem6: TMenuItem;
    mnuDelOld: TMenuItem;
    mnuExpJournal: TMenuItem;
    nmuDatensicherung: TMenuItem;
    mnuExpJournalRAW: TMenuItem;
    mnuExportPersonen: TMenuItem;
    mnuWB_Imp_Pers: TMenuItem;
    mnuExport: TMenuItem;
    mnuImport: TMenuItem;
    mnuAbgleich: TMenuItem;
    mnuJahresabschluss: TMenuItem;
    mnuEinstellungenMain: TMenuItem;
    OpenDialog: TOpenDialog;
    ProgressBar: TProgressBar;
    SaveDialog: TSaveDialog;
    procedure btnAktuellesClick(Sender: TObject);
    procedure btnBankkontenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDruckenClick(Sender: TObject);
    procedure btnJournalClick(Sender: TObject);
    procedure btnPersonenClick(Sender: TObject);
    procedure btnSachkontenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgSELKClick(Sender: TObject);
    procedure labMyMailClick(Sender: TObject);
    procedure labMyWebClick(Sender: TObject);
    procedure labVersionNeuClick(Sender: TObject);
    procedure mnuDebugClick(Sender: TObject);
    procedure mnuEinstellungenClick(Sender: TObject);
    procedure mnuAbgleichClick(Sender: TObject);
    procedure mnuCleanAutoBuchenClick(Sender: TObject);
    procedure mnuDelOldClick(Sender: TObject);
    procedure mnuDelOldPersonenClick(Sender: TObject);
    procedure mnuEuroModusClick(Sender: TObject);
    procedure mnuExecSQLBatchClick(Sender: TObject);
    procedure mnuExecSQLSingleClick(Sender: TObject);
    procedure mnuExpJournalClick(Sender: TObject);
    procedure mnuExpJournalRAWClick(Sender: TObject);
    procedure mnuExportPersonenClick(Sender: TObject);
    procedure mnuExportZuwendungClick(Sender: TObject);
    procedure mnuFehlerSuchenClick(Sender: TObject);
    procedure mnuHilfeClick(Sender: TObject);
    procedure mnuJahresabschlussClick(Sender: TObject);
    procedure mnuJournalJumpClick(Sender: TObject);
    procedure mnuJournalLastClick(Sender: TObject);
    procedure mnuLimitsZahlerBetragClick(Sender: TObject);
    procedure mnuLimitsZahlerverteilungAlterClick(Sender: TObject);
    procedure mnuShowDebugClick(Sender: TObject);
    procedure mnuSQLDebugClick(Sender: TObject);
    procedure mnuSuchtexteImportClick(Sender: TObject);
    procedure mnuTausenderClick(Sender: TObject);
    procedure mnuWB_Imp_PersClick(Sender: TObject);
    procedure mnuZahlerBetragClick(Sender: TObject);
    procedure mnuZahlerverteilungAlterClick(Sender: TObject);
    procedure nmuDatensicherungClick(Sender: TObject);
  private
    { private declarations }
    procedure FillStringsAusInit;
    procedure HandleException(Sender: TObject; E: Exception);
  public
    { public declarations }
    slHelp: TStringList;
    procedure Datensicherung(Auto, Reconnect: boolean; FileExtension : String = '');
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

//{$define entwicklung}

{ TfrmMain }

uses
  help,
  dm,
  db,
  LConvEncoding,    //CP1252ToUTF8
  Translations,
  inifiles,
  banken,
  drucken,
  einstellungen,
  httpsend,
  ssl_openssl,
  personen,
  ausgabe,
  PgmUpdate,
  sachkonten,
  journal,
  input,
  global;

var
  sNewVers   : String;

procedure TfrmMain.HandleException(Sender: TObject; E: Exception);

begin
  LogAndShowError('Unbehandelter Fehler.'+#13+
                  'Nachricht: '+e.Message+#13#13+
                  'Das Programm wird beendet ');

  if frmDM.ZQueryBanken.Active           then  frmDM.ZQueryBanken.Close;
  if frmDM.ZQueryBankenAbschluss.Active  then  frmDM.ZQueryBankenAbschluss.Close;
  if frmDM.ZQueryDrucken.Active          then  frmDM.ZQueryDrucken.Close;
  if frmDM.ZQueryDruckenDetail.Active    then  frmDM.ZQueryDruckenDetail.Close;
  if frmDM.ZQueryDruckenDetail1.Active   then  frmDM.ZQueryDruckenDetail1.Close;
  if frmDM.ZQueryPersonen.Active         then  frmDM.ZQueryPersonen.Close;
  if frmDM.ZQueryInit.Active             then  frmDM.ZQueryInit.Close;
  if frmDM.ZQueryHelp.Active             then  frmDM.ZQueryHelp.Close;
  if frmDM.ZQueryHelp1.Active            then  frmDM.ZQueryHelp1.Close;
  if frmDM.ZQueryGE_Kart_Personen.Active then  frmDM.ZQueryGE_Kart_Personen.Close;
  if frmDM.ZQuerySachkonten.Active       then  frmDM.ZQuerySachkonten.Close;
  if frmDM.ZQueryJournal.Active          then  frmDM.ZQueryJournal.Close;

  if frmDM.ZConnectionBuch.Connected     then frmDM.ZConnectionBuch.Disconnect;

  FlushDebug;

  Halt; // End of program execution
end;

procedure TfrmMain.FillStringsAusInit;

begin
  sGemeindeName        := frmDM.ZQueryInit.FieldByName('GemeindeName').AsString;
  sGemeindeOrt         := frmDM.ZQueryInit.FieldByName('GemeindeOrt').AsString;
  sGemeindeAdr2        := frmDM.ZQueryInit.FieldByName('GemeindeStrasse').AsString + ', ' +
                          frmDM.ZQueryInit.FieldByName('GemeindePLZ').AsString + ' ' + sGemeindeOrt;
  LabRendant1.Caption  := frmDM.ZQueryInit.FieldByName('RendantName').AsString;
  LabRendant2.Caption  := frmDM.ZQueryInit.FieldByName('RendantStrasse').AsString + ', ' +
                          frmDM.ZQueryInit.FieldByName('RendantPLZ').AsString + ' ' +
                          frmDM.ZQueryInit.FieldByName('RendantOrt').AsString;
  sRendantAdr          := frmDM.ZQueryInit.FieldByName('RendantName').AsString+#13#10+
                          frmDM.ZQueryInit.FieldByName('RendantStrasse').AsString+#13#10+
                          frmDM.ZQueryInit.FieldByName('RendantPLZ').AsString+' '+
                          frmDM.ZQueryInit.FieldByName('RendantOrt').AsString+#13#10+
                          frmDM.ZQueryInit.FieldByName('RendantTel').AsString+#13#10+
                          frmDM.ZQueryInit.FieldByName('RendantEMail').AsString;
  sRendantOrt          := frmDM.ZQueryInit.FieldByName('RendantOrt').AsString;
  nBuchungsjahr        := frmDM.ZQueryInit.FieldByName('Buchungsjahr').asinteger;
  sFinanzamt           := frmDM.ZQueryInit.FieldByName('Finanzamt').AsString;
  sFinanzamtVom        := frmDM.ZQueryInit.FieldByName('FinanzamtVom').AsString;
  sFinanzamtNr         := frmDM.ZQueryInit.FieldByName('FinanzamtNr').AsString;

  sGemeindeAdr         := sGemeindeName+#13#10+sGemeindeAdr2;
  LabGemeinde1.Caption := sGemeindeName;
  LabGemeinde2.Caption := sGemeindeAdr2;
end;

procedure TfrmMain.FormCreate(Sender: TObject);

var
  sRelease              : String;
  HTTP                  : THTTPSend;

begin
  Application.OnException := @HandleException;
  slHelp      := TStringlist.Create;
  sAppDir     := vConfigurations.MyDirectory;
  sIniFile    := vConfigurations.ConfigFile;
  sDebugFile  := help.ReadIniVal(sIniFile, 'Debug'     , 'Name', sAppDir+'debug.txt', true);
  sSavePath   := help.ReadIniVal(sIniFile, 'Sicherung' , 'Verzeichnis', sAppDir+'Sicherung', true);
  sImportPath := help.ReadIniVal(sIniFile, 'CSV-Import', 'Verzeichnis', sAppDir, true);
  sDatabase   := help.ReadIniVal(sIniFile, 'Datenbank' , 'Name', sAppDir+'ge_buch3.db', true);
  sProductVersionString := GetProductVersionString;

  bSQLDebug              := 'TRUE' = Uppercase(help.ReadIniVal(sIniFile, 'Debug', 'SQLDebug', 'true', true));
  bDebug                 := 'TRUE' = Uppercase(help.ReadIniVal(sIniFile, 'Debug', 'Debug'   , 'true', true));
  bTausendertrennung     := 'TRUE' = Uppercase(help.ReadIniVal(sIniFile, 'Programm', 'Tausendertrennzeichen', 'true', true));
  bEuroModus             := 'TRUE' = Uppercase(help.ReadIniVal(sIniFile, 'Programm', 'EuroModus', 'false', true));
  bJournalJump           := 'TRUE' = Uppercase(help.ReadIniVal(sIniFile, 'Programm', 'JournalJump', 'true', true));
  bJournalLast           := 'TRUE' = Uppercase(help.ReadIniVal(sIniFile, 'Programm', 'JournalLast', 'true', true));
  mnuSQLDebug.Checked    := bSQLDebug;
  mnuDebug.Checked       := bDebug;
  mnuTausender.Checked   := bTausendertrennung;
  mnuEuroModus.Checked   := bEuroModus;
  mnuJournalJump.Checked := bJournalJump;
  mnuJournalLast.Checked := bJournalLast;

  frmMain.caption        := 'GE_Buch '+sProductVersionString;
  labVersion.Caption     := labVersion.Caption + ' ' + frmMain.caption;
  labMyMail.Caption      := global.sEMailAdr;
  labMyWeb.Caption       := global.sHomePage;

  try
    imgSELK.Picture.LoadFromFile(sAppDir+'module\selk_ohne.png');
  except

  end;

  myDebugLN('Starte '    +frmMain.caption);
  myDebugLN('AppDir   : '+sAppDir);
  myDebugLN('sIniFile : '+sIniFile);
  myDebugLN('sSavePath: '+sSavePath);
  myDebugLN('sDatabase: '+sDatabase);

  WorkArea          := GetWorkArea;
  MaxWindowsSize    := GetMaxWindowsSize;
  GetMonitorCount;
  VirtualScreenSize := GetVirtualScreenSize;

  //Dialoge übersetzen
  TranslateUnitResourceStrings('LCLStrConsts','lclstrconsts.%s.po','de','en');

  //Prüfung auf neue Version
  HTTP := THTTPSend.Create;
  try                                                                 //ab hier Spionage
    if not HTTP.HTTPMethod('GET', 'https://'+sHomePage+'/GE_BUCH/version.txt?;V'+sProductVersionString+';'+replacechar(GetComputerName, ' ', '_')+';'+replacechar(GetUserName, ' ', '_'))
      then
        begin
	  myDebugLN('ERROR HTTPGET, Resultcode: '+inttostr(Http.Resultcode)+' '+Http.Resultstring);
          labVersionNeu.Font.Size := -10;
          labVersionNeu.Caption   := 'Keine Verbindung zum Updateserver';
          labVersionNeu.Color     := clNone;
          labVersionNeu.OnClick   := nil;
        end
      else
        begin
          slHelp.loadfromstream(Http.Document);
          slHelp.Text := CP1252ToUTF8(slHelp.Text);
          myDebugLN('HTTPGET, Resultcode: '+inttostr(Http.Resultcode)+' '+Http.Resultstring);
          myDebugLN('Http.headers.text  : '+#13#10+Http.headers.text);
          myDebugLN('Http.Document      : '+#13#10+slHelp.Text);

          if Http.Resultcode = 200
            then
              begin
                sNewVers := slHelp.Strings[0];
                if GetProductVersionString < sNewVers
                  then
                    begin
                      slHelp.Delete(0);
                      labVersionNeu.Caption := labVersionNeu.Caption+sNewVers;
                      labVersionNeu.Hint    := slHelp.Text;
                      labVersionNeu.Cursor  := crHandPoint;
                    end
                  else
                    begin
                      labVersionNeu.Font.Size := -10;
                      labVersionNeu.OnClick   := nil;
                      if GetProductVersionString = sNewVers
                        then
                          begin
                            labVersionNeu.Caption   := 'Das Programm ist aktuell';
                            labVersionNeu.Color     := clNone;
                          end
                        else labVersionNeu.Caption   := 'Das Programm ist neuer. Aktuelle Version im Internet: '+sNewVers;
                    end;
              end
            else
              begin
                labVersionNeu.Caption := 'Fehler bei der Abfrage';
              end;
        end;
  finally
    HTTP.Free;
    slHelp.Clear;
  end;

  HTTP := THTTPSend.Create;
  try
    if HTTP.HTTPMethod('GET', 'https://'+sHomePage+'/GE_BUCH/aktuelles.txt')
      then
        begin
          slHelp.loadfromstream(Http.Document);
          //sAktuelles := CP1252ToUTF8(slHelp.Text);
          sAktuelles := slHelp.Text;
          myDebugLN('HTTPGET, Resultcode: '+inttostr(Http.Resultcode)+' '+Http.Resultstring);
          myDebugLN('Http.headers.text  : '+#13#10+Http.headers.text);
          myDebugLN('Http.Document      : '+#13#10+sAktuelles);

          if (Http.Resultcode = 200) and (sAktuelles <> '')
            then
              begin
                btnAktuelles.Visible := true;
                btnAktuelles.Caption := 'Aktuelles vom '+slHelp.Strings[0];
              end;
        end;
  finally
    HTTP.Free;
    slHelp.Clear;
  end;

  //Releasenote anzeigen
  sRelease := help.ReadIniVal(sIniFile, 'Programm', 'Version', '0', true);
  if sProductVersionString <> sRelease
    then
      begin
        //slAusgabe wird zweckentfremdet
        try
          slHelp.LoadFromFile('releasenote_'+sProductVersionString+'.txt');
        except

        end;
        if slHelp.Text <> ''
          then
            if MessageDlg(slHelp.Text, mtConfirmation, [mbYes, mbNo],0) = mrNo
              then help.WriteIniVal(sIniFile, 'Programm', 'Version', sProductVersionString)
      end;
end;


procedure TfrmMain.FormShow(Sender: TObject);

var
{$ifdef entwicklung}

{$else}
  dtLastSave         : TDateTime;
{$endif}
  jahr_, monat_, tag_: word;

begin
  DecodeDate(now(), jahr_, monat_, tag_);
  try
    if not frmDM.ZConnectionBuch.Connected then frmDM.ZConnectionBuch.Connect;
    //Überprüfen der Datenbank
    if not frmDM.CheckDB
      then
        begin
          LogAndShowError('Die Datenbankstruktur passt nicht zum Programm.'+#13+'Das Programm wird beendet');
          flushdebug;
          close;
          exit;
        end;
    if not frmDM.ZQueryInit.Active then frmDM.ZQueryInit.Open;
    FillStringsAusInit;
  except
    on E: Exception do
      begin
        LogAndShowError(e.Message+#13+'Das Programm wird beendet');
        flushdebug;
        close;
        exit;
      end;
  end;

  labBJahr.Caption           := 'Buchungsjahr: '+inttostr(nBuchungsjahr);
  mnuJahresabschluss.Enabled := nBuchungsjahr<>jahr_;
  mnuDelOld.Caption          := 'Lösche Einträge im Journal bis '+inttostr(nBuchungsjahr-3);
  mnuJahresabschluss.Caption := 'Jahresabschluss für '+inttostr(nBuchungsjahr);

{$ifdef entwicklung}
  labDatensicherung.Caption := '!!! Entwicklerversion !!!';
  labDatensicherung.Color   := clred;
{$else}
  //Passwort
  if sPW = ''
    then
      begin
        frmInput.SetDefaults('Passwort','Passwort','','','',true);
        if frmInput.ShowModal = mrOK
          then
            begin
              if frmInput.Edit1.Text <> frmDM.ZQueryInit.FieldByName('Passwort').AsString
                then
                  begin
                    Showmessage('Kein oder falsches Passwort eingegeben');
                    close;
                    exit;
                  end;
            end
          else
            begin
              close;
              exit;
            end;
        frmInput.Edit1.Text := ''; //Für spätere Eingaben leeren
      end
    else
      begin
        if sPW <> frmDM.ZQueryInit.FieldByName('Passwort').AsString
          then
            begin
              Showmessage('Falsches Passwort als Parameter übergeben');
              close;
              exit;
            end;
      end;
{$endif}
  //Datensicherung
  try
    dtLastSave := StrToDate(help.ReadIniVal(sIniFile, 'Sicherung', 'Datum', '01.01.1980', true));
  except
    dtLastSave := StrToDate('01.01.1980');
  end;

  if dtLastSave = StrToDate('01.01.1980')
    then
      begin
        labDatensicherung.Caption := 'Noch keine Datensicherung gemacht';
        labDatensicherung.Color   := clred;
      end
    else labDatensicherung.Caption := 'Letzte Datensicherung: '+DateToStr(dtLastSave);

  randomize;
  if (dtLastSave = StrToDate('01.01.1980')) or
     (dtLastSave+30 < now)
    then
      begin
        //Automatische Datensicherung
        Datensicherung(true, true);
      end
    else
      if (trunc(random(12)) = 1)
        then Showmessage('Denken Sie an eine regelmäßige Datensicherung'+#13+labDatensicherung.Caption);
end;

procedure TfrmMain.imgSELKClick(Sender: TObject);
begin
  Openurl('www.selk.de');
end;

procedure TfrmMain.labMyMailClick(Sender: TObject);
begin
  Openurl('MailTo:'+sEMailAdr+'?subject=GE_BUCH');
end;

procedure TfrmMain.labMyWebClick(Sender: TObject);
begin
  Openurl('https://'+sHomePage+'/GE_Buch');
end;

procedure TfrmMain.labVersionNeuClick(Sender: TObject);

begin
  frmPgmUpdate.URL      := 'https://'+sHomePage+'/GE_BUCH/v'+sNewVers+'.zip';
  frmPgmUpdate.FileName := sAppDir+'v'+sNewVers+'.zip';
  frmPgmUpdate.showmodal;
end;

procedure TfrmMain.mnuDebugClick(Sender: TObject);
begin
  bDebug           := not bDebug;
  mnuDebug.Checked := bDebug;
  if bDebug
    then help.WriteIniVal(sIniFile, 'Debug', 'Debug', 'true')
    else help.WriteIniVal(sIniFile, 'Debug', 'Debug', 'false');
end;

procedure TfrmMain.mnuEinstellungenClick(Sender: TObject);
begin
  frmEinstellungen.Showmodal;
  FillStringsAusInit;
end;

procedure TfrmMain.mnuExecSQLSingleClick(Sender: TObject);

var
  rows : integer;

begin
  frmAusgabe.SetDefaults('SQL Kommando ausführen', '--Hier SQL Kommando eingeben'+#10#13, '', 'SQL ausführen', 'Abbrechen', true);
  if frmAusgabe.ShowModal = mrOK
    then
      begin
        rows := ExecSQL(frmAusgabe.Memo.Text, frmDM.ZQueryHelp, false);
        if rows > 0 then Showmessage(inttostr(rows)+' Zeile(n) bearbeitet');
      end;
end;

procedure TfrmMain.mnuExpJournalClick(Sender: TObject);

var
  BankNr     : integer;
  Saldo      : longint;
  Betrag     : longint;
  LaufendeNr : Longint;
  sSQL       : String;

begin
  frmInput.SetDefaults('Buchungsjahr für Export ','Buchungsjahr',inttostr(nBuchungsjahr),'','',false);
  if frmInput.ShowModal = mrOK
    then
      begin
        //Aufräumen
        frmDM.ExecSQL('DROP TABLE IF EXISTS TEMP', false, false);
        //Formatiertes Journal in TEMP Tabelle speichern
        frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\JournalDrucken.sql');
        frmDM.ZQueryHelp.SQL.Text := StringReplace(frmDM.ZQueryHelp.SQL.Text, ':AddWhere', '', [rfReplaceAll]);
        //Dieser Befehl speichert das Ergebniss des selects in der Tabelle Temp
        frmDM.ZQueryHelp.SQL.Text := 'Create Table TEMP as '+frmDM.ZQueryHelp.SQL.Text;
        frmDM.ZQueryHelp.ParamByName('BJahr').AsString := frmInput.Edit1.Text;
        frmDM.ZQueryHelp.ExecSQL;

        BankNr := -1;
        sSQL   := '';
        //TEMP Tabelle öffnen
        frmDM.ZQueryHelp.SQL.Text:='Select * from Temp';
        frmDM.ZQueryHelp.Open;
        frmDM.ZQueryHelp.First;

        //Saldo berechnen;
        while not frmDM.ZQueryHelp.EOF do
          begin
            if frmDM.ZQueryHelp.FieldByName('BankNr').AsInteger <> BankNr
              then
                begin
                  //In Saldo ist das Bankenabschluss.Anfangssaldo gepeichert,
                  //wird zwischengespeichert und dann überschrieben
                  Saldo  := strtoint(frmDM.ZQueryHelp.FieldByName('Saldo').AsString);
                  BankNr := frmDM.ZQueryHelp.FieldByName('BankNr').AsInteger;
                end;
            Betrag     := frmDM.ZQueryHelp.FieldByName('Betrag').AsLongint;
            LaufendeNr := frmDM.ZQueryHelp.FieldByName('LaufendeNr').AsLongint;
            Saldo      := Saldo + Betrag;

            //Beträge formatieren
            sSQL := sSQL + 'UPDATE Temp SET Saldo="'+IntToCurrency(Saldo)+'", Betrag="'+IntToCurrency(Betrag)+'" WHERE LaufendeNr="'+IntToStr(LaufendeNr)+'";'+#13#10;

            frmDM.ZQueryHelp.Next;
          end;
        frmDM.ZQueryHelp.Close; //Schliessen und ....

        frmDM.ExecuteTransactionSQL(sSQL);

        //Query wieder öffnen damit die Updates gelesen werden
        frmDM.ZQueryHelp.Open;
        //Exportieren
        ExportQueToCSVFile(frmDM.ZQueryHelp, sAppDir+'Journal.csv', ';', '"', true, false);
        frmDM.ZQueryHelp.Close;

        //Aufräumen
        frmDM.ExecSQL('DROP TABLE IF EXISTS TEMP', false, false);
      end;
end;

procedure TfrmMain.mnuExpJournalRAWClick(Sender: TObject);
begin
  frmInput.SetDefaults('Buchungsjahr für Export ','Buchungsjahr',inttostr(nBuchungsjahr),'','',false);
  if frmInput.ShowModal = mrOK
    then
      begin
        frmDM.ZQueryHelp.SQL.Text := 'select * from journal where BuchungsJahr = '+frmInput.Edit1.Text+' order by LaufendeNr';
        frmDM.ZQueryHelp.Open;
        ExportQueToCSVFile(frmDM.ZQueryHelp, sAppDir+'Journal_RohDaten.csv', ';', '"', true, false);
        frmDM.ZQueryHelp.Close;
      end;
end;

procedure TfrmMain.mnuExportPersonenClick(Sender: TObject);
begin
  frmDM.ZQueryHelp.SQL.Text := sSelectPersonenSort;
  frmDM.ZQueryHelp.Open;
  ExportQueToCSVFile(frmDM.ZQueryHelp, sAppDir+'Personen.csv', ';', '"', true, true);
  frmDM.ZQueryHelp.Close;
end;

procedure TfrmMain.mnuExportZuwendungClick(Sender: TObject);

begin
  //V1.9.5.0
  frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\ZuwendungDrucken.sql');
  frmDM.ZQueryHelp.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);
  ExecSQL('', frmDM.ZQueryHelp, false);
end;

procedure TfrmMain.mnuFehlerSuchenClick(Sender: TObject);
begin
  if MessageDlg('Es wird nach fehlerhaften'#13+
                '  - Personennummern,'#13+
                '  - Banknummern und '#13+
                '  - Sachkontennummern'#13+
                'gesucht.', mtConfirmation, [mbOK],0) = mrOK
    then
      begin
        frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\FehlerhafteBuchungenSuchen.sql');
        frmDM.ZQueryHelp.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);
        ExecSQL('', frmDM.ZQueryHelp, false);
      end;
end;

procedure TfrmMain.mnuHilfeClick(Sender: TObject);
begin
  OpenDocument(sAppDir+'Dokumentation\Handbuch GE_Buch.pdf');
end;

procedure TfrmMain.mnuJahresabschlussClick(Sender: TObject);

begin
  if MessageDlg('Nach dem Jahresabschluss für das Jahr '+inttostr(nBuchungsjahr)+' ist keine weitere Bearbeitung für diese Jahr möglich.'#13#13+
                '- Haben Sie das Journal gedruckt?'#13+
                '- Die Zuwendungsbescheinigungen erstellt?'#13+
                '- Den statistischen Bericht (Jahresabschluss) gedruckt?'#13+
                '- Ggf. die Summenliste gedruckt?'#13+
                '- Ggf. die Beitragsliste gedruckt?'#13#13+
                'Eine Datensicherung gemacht?'#13#13+
                'Möchten Sie das jetzt noch nachholen?'#13#13+
                'Sicherheitsfunktion: Zum Fortfahren "Wiederholen" drücken!', mtConfirmation, [mbYes, mbRetry, mbNo],0) = mrRetry
    then
      begin
        Datensicherung(true, true, '_vor_Jahresabschuss_');
        if frmDM.ZQueryBanken.Active then frmDM.ZQueryBanken.Close;

        // BankenAbschluss / Abschlusssaldo schreiben für aktuelles Jahr
        frmDM.ZQueryHelp.SQL.Text:='update Bankenabschluss set Abschlusssaldo=(select konten.Kontostand from konten where Bankenabschluss.KontoNr=konten.KontoNr) where Bankenabschluss.Buchungsjahr = :BJahr';
        frmDM.ZQueryHelp.ParamByName('BJahr').AsInteger := nBuchungsjahr;
        frmDM.ZQueryHelp.ExecSQL;

        // BankenAbschluss / Anfangssaldo erstellen für aktuelles Jahr
        frmDM.ZQueryHelp.SQL.Text:='insert into Bankenabschluss select kontonr, :BJahr+1, Abschlusssaldo, 0 from Bankenabschluss where Buchungsjahr = :BJahr';
        frmDM.ZQueryHelp.ParamByName('BJahr').AsInteger := nBuchungsjahr;
        frmDM.ZQueryHelp.ExecSQL;

        // Buchungsjahr erhöhen
        inc(nBuchungsjahr);

        // Buchungsjahr nach init schreiben
        ExecSQL('update Init set Buchungsjahr='+inttostr(nBuchungsjahr), frmDM.ZQueryHelp, false);

        // Erfolgsmeldung
        labBJahr.Caption := 'Buchungsjahr: '+inttostr(nBuchungsjahr);
        Showmessage('Das Buchungsjahr ist jetzt '+inttostr(nBuchungsjahr));
      end
    else
      begin
        btnDruckenClick(self);
      end;
end;

procedure TfrmMain.mnuJournalJumpClick(Sender: TObject);
begin
  bJournalJump           := not bJournalJump;
  mnuJournalJump.Checked := bJournalJump;
  if bJournalJump
    then help.WriteIniVal(sIniFile, 'Programm', 'JournalJump', 'true')
    else help.WriteIniVal(sIniFile, 'Programm', 'JournalJump', 'false');
end;

procedure TfrmMain.mnuJournalLastClick(Sender: TObject);
begin
  bJournalLast           := not bJournalLast;
  mnuJournalLast.Checked := bJournalLast;
  if bJournalLast
    then help.WriteIniVal(sIniFile, 'Programm', 'JournalLast', 'true')
    else help.WriteIniVal(sIniFile, 'Programm', 'JournalLast', 'false');
end;

procedure TfrmMain.mnuLimitsZahlerBetragClick(Sender: TObject);

var
  sFileName  : String;

begin
  sFileName  := sAppDir+'module\Zahlerstatistik.txt';
  slHelp.Clear;
  try
    slHelp.LoadFromFile(sFileName);
  except
    on E: Exception do LogAndShowError(E.Message);
  end;
  frmAusgabe.SetDefaults('Grenzen bearbeiten ('+sFileName+')', slHelp.text, sFileName, '', 'Schliessen', false);
  frmAusgabe.ShowModal;
end;

procedure TfrmMain.mnuLimitsZahlerverteilungAlterClick(Sender: TObject);

var
  sFileName  : String;

begin
  sFileName  := sAppDir+'module\ZahlerstatistikAlter.txt';
  slHelp.Clear;
  try
    slHelp.LoadFromFile(sFileName);
  except
    on E: Exception do LogAndShowError(E.Message);
  end;
  frmAusgabe.SetDefaults('Grenzen bearbeiten ('+sFileName+')', slHelp.text, sFileName, '', 'Schliessen', false);
  frmAusgabe.ShowModal;
end;

procedure TfrmMain.mnuShowDebugClick(Sender: TObject);
begin
  Opendocument(sDebugFile);
end;

procedure TfrmMain.mnuSQLDebugClick(Sender: TObject);

begin
  bSQLDebug                := not bSQLDebug;
  mnuSQLDebug.Checked      := bSQLDebug;
  frmDM.ZSQLMonitor.Active := bSQLDebug;
  if bSQLDebug
    then help.WriteIniVal(sIniFile, 'Debug', 'SQLDebug', 'true')
    else help.WriteIniVal(sIniFile, 'Debug', 'SQLDebug', 'false');
end;

procedure TfrmMain.mnuSuchtexteImportClick(Sender: TObject);

var
  sFileName  : String;

begin
  sFileName  := sAppDir+'module\SuchTexteImport.txt';
  slHelp.Clear;
  try
    slHelp.LoadFromFile(sFileName);
  except
    on E: Exception do LogAndShowError(E.Message);
  end;
  frmAusgabe.SetDefaults('Suchtexte für Sachkonten bearbeiten ('+sFileName+')', slHelp.text, sFileName, '', 'Schliessen', false);
  frmAusgabe.ShowModal;
end;

procedure TfrmMain.mnuTausenderClick(Sender: TObject);
begin
  bTausendertrennung   := not bTausendertrennung;
  mnuTausender.Checked := bTausendertrennung;
  if bTausendertrennung
    then help.WriteIniVal(sIniFile, 'Programm', 'Tausendertrennzeichen', 'true')
    else help.WriteIniVal(sIniFile, 'Programm', 'Tausendertrennzeichen', 'false');
end;

procedure TfrmMain.mnuWB_Imp_PersClick(Sender: TObject);

var Line       : String;
    ErrorText  : string;
    FeldNamen  : String;
    sSQL       : string;
    i          : integer;
    ActLine    : Integer;
    Lines      : integer;

begin
  if MessageDlg('Sie müssen jetzt eine CSV (comma separated value) oder eine Textdatei auswählen.'#13+
             'Sie muss von Winbuch exportiert worden sein.'#13+
             'Es werden folgende Felder importiert: PersonenID, BriefAnrede, Vorname, Nachname, Strasse, PLZ, Ort.'#13+
             'Als Trennzeichen sind "'+CSV_Delimiter+'" und TAB erlaubt'#13+
             'Format der Datei:'#13#13+
             '1.Zeile: Feldnamen.'#13+
             'Folgende Zeilen: Daten. Die Daten dürfen kein "'+CSV_Delimiter+'" und TAB enthalten'#13#13+
             'Alle " als Feldbegrenzer werden gelöscht'#13#13+
             'Vor dem Import weden alle Personen gelöscht'#13#13+
             'Sicherheitsfunktion: Zum Fortfahren "Wiederholen" drücken!', mtConfirmation, [mbYes, mbRetry, mbNo],0) = mrRetry
    then
      begin
        Lines     := 0;
        ErrorText := '';
        try
          openDialog.InitialDir := UTF8ToSys(sAppDir);   // Set up the starting directory to be the current one
          openDialog.Options := [ofFileMustExist];       // Only allow existing files to be selected
          openDialog.Filter := 'Alle|*.*|TXT-Datei |*.txt|CSV-Datei |*.csv';
          openDialog.FilterIndex := 2;                   // Select report files as the starting filter type

          if openDialog.Execute then                     // Display the open file dialog
            begin
              frmDM.ZQueryHelp.SQL.Text:='delete from personen';
              frmDM.ZQueryHelp.ExecSQL;

              myDebugLN('Import: '+ OpenDialog.Filename);

              slHelp.loadfromfile(UTF8ToSys(OpenDialog.Filename));
              slHelp.text := RemoveBOM(slHelp.text);
              FeldNamen := 'INSERT INTO Personen (PersonenID, BriefAnrede, Vorname, Nachname, Strasse, PLZ, Ort) VALUES (';

              //Daten einfügen
              if slHelp.count > 1 then
                for ActLine := 1 to slHelp.count-1 do
                  begin
                    Line := slHelp.strings[ActLine];
                    Line := Trim(Line);
                    if Line <> ''
                      then
                        begin
                          sSQL := FeldNamen;
                          for i := 1 to 7 do
                            begin
                              if i in [2..7] then sSQL := sSQL + ', ';
                              sSQL := sSQL + '''' + CP1252ToUTF8(GetCSVRecordItem(i, Line, [CSV_Delimiter, #9], '"')) + '''';
                            end;
                           sSQL := sSQL + ')';
                          try
                            frmDM.ZQueryHelp.SQL.Text:=sSQL;
                            frmDM.ZQueryHelp.ExecSQL;
                            inc(Lines);
                          except
                            on E: Exception
                              do
                                begin
                                  ErrorText := ErrorText +
					                                     'In Zeile: '+inttostr(ActLine)+
                                               ' ist folgender Fehler aufgetreten: '+e.Message+
                                               '. Die Zeile wird NICHT importiert!'#13;
                                  break;
                                end;
                          end;
                        end;
                  end;
              if ErrorText <> '' then MessageDlg(ErrorText, mtError, [mbOK], 0);
              MessageDlg(Inttostr(Lines)+' Zeilen importiert', mtInformation, [mbOK],0);
            end;
        except
          on E: Exception do LogAndShowError(E.Message);
        end;
      end;
end;

procedure TfrmMain.mnuZahlerBetragClick(Sender: TObject);
var
  sMessage      : string;
  sMessage2     : string;
  border        : longint;
  borderLine    : integer;
  ZahlerSumme   : longint;
  ZahlerWert    : longint;
  Bereichssumme : longint;
begin
  try
    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\Zahlerstatistik.sql');
    frmDM.ZQueryHelp.ParamByName('BJahr').AsInteger := nBuchungsjahr;
    frmDM.ZQueryHelp.Open;
    sMessage    := 'Grenzwerte werden in '+sAppDir+'module\Zahlerstatistik.txt definiert'+#13+
                   'Angaben für das Jahr '+inttostr(nBuchungsjahr)+#13#13;
    sMessage2   := '';
    border      := 0;
    borderLine  := 0;
    ZahlerSumme := 0;
    Bereichssumme := 0;
    slHelp.LoadFromFile(sAppDir+'module\Zahlerstatistik.txt');

    if slHelp.Count > borderLine then border := strtoint(slHelp.Strings[borderLine])*100;
    sMessage2 := sMessage2 + 'bis  '+Format('%5d Euro',[border div 100]);
    inc(borderLine);
    while not frmDM.ZQueryHelp.EOF do
      begin
        ZahlerWert := frmDM.ZQueryHelp.FieldByName('Summe').AsInteger;
        if ZahlerWert <= border
          then
            begin
              inc(ZahlerSumme);
              Bereichssumme := Bereichssumme + ZahlerWert;
              frmDM.ZQueryHelp.Next;
            end
          else
            begin
              //Grenze überschritten
              sMessage    := sMessage + Format('%4d Zahler ',[ZahlerSumme]) + sMessage2+ ', Summe: ' + Format('%7d Euro',[Bereichssumme div 100])+#13;
              ZahlerSumme := 0;
              if borderLine <= slHelp.Count-1
                then
                  begin
                    border := strtoint(slHelp.Strings[borderLine])*100;
                    sMessage2 := 'bis  '+Format('%5d Euro',[border div 100]);
                    inc(borderLine);
                  end
                else
                 begin
                   sMessage2 := 'über '+Format('%5d Euro',[border div 100]);
                   border := 999999999;
                 end;
              Bereichssumme := 0;
            end;
      end;
    frmDM.ZQueryHelp.Close;
    sMessage    := sMessage + Format('%4d Zahler ',[ZahlerSumme]) + sMessage2+ ', Summe: ' + Format('%7d Euro',[Bereichssumme div 100])+#13#13;

    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\Nichtzahler.sql');
    frmDM.ZQueryHelp.ParamByName('BJahr').AsInteger := nBuchungsjahr;
    frmDM.ZQueryHelp.Open;
    while not frmDM.ZQueryHelp.EOF do
      begin
        sMessage := sMessage + 'Nichtzahler: '+frmDM.ZQueryHelp.FieldByName('Name').Asstring+#13;
        frmDM.ZQueryHelp.Next;
      end;
    frmDM.ZQueryHelp.Close;

    frmAusgabe.SetDefaults('Zahlerstatistik', sMessage, '', '', 'Schliessen', false);
    frmAusgabe.ShowModal;
  except
    on E: Exception
      do
        begin
          if frmDM.ZQueryHelp.Active then frmDM.ZQueryHelp.Close;
          LogAndShowError(e.Message);
        end;
  end;
end;

procedure TfrmMain.mnuZahlerverteilungAlterClick(Sender: TObject);
var
  sMessage     : string;
  sMessage2    : string;
  border       : longint;
  Bereichssumme: Double;
  borderLine   : integer;
  Alter        : integer;
begin
  try
    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\ZahlerstatistikAlter.sql');
    frmDM.ZQueryHelp.ParamByName('BJahr').AsInteger := nBuchungsjahr;
    frmDM.ZQueryHelp.Open;
    sMessage      := 'Grenzwerte werden in '+sAppDir+'module\ZahlerstatistikAlter.txt definiert'+#13+
                     'Angaben für das Jahr '+inttostr(nBuchungsjahr)+#13#13;
    sMessage2     := '';
    border        := 0;
    borderLine    := 0;
    Bereichssumme := 0;
    slHelp.LoadFromFile(sAppDir+'module\ZahlerstatistikAlter.txt');

    if slHelp.Count > borderLine then border := strtoint(slHelp.Strings[borderLine]);
    sMessage2 := sMessage2 + 'unbekanntes Alter (wahrscheinlich kein Geburtsdatum)';
    inc(borderLine);
    while not frmDM.ZQueryHelp.EOF do
      begin
        Alter := frmDM.ZQueryHelp.FieldByName('Age').AsInteger;
        if Alter <= border
          then
            begin
              Bereichssumme := Bereichssumme + frmDM.ZQueryHelp.FieldByName('Betrag').Aslongint/100;
              frmDM.ZQueryHelp.Next;
            end
          else
            begin
              //Grenze überschritten
              sMessage      := sMessage + Format('%8.2f Euro ',[Bereichssumme]) + sMessage2+#13;
              Bereichssumme := 0;
              if borderLine <= slHelp.Count-1
                then
                  begin
                    border := strtoint(slHelp.Strings[borderLine]);
                    sMessage2 := 'bis  '+Format('%2d Jahre',[border]);
                    inc(borderLine);
                  end
                else
                 begin
                   sMessage2 := 'über '+Format('%2d Jahre',[border]);
                   border := 999;
                 end;
            end;
      end;
    frmDM.ZQueryHelp.Close;
    sMessage    := sMessage + Format('%10.2f Euro ',[Bereichssumme]) + sMessage2+#13#13+'Achten Sie auf die Zuordnung des Feldes "Gemeindeglied"'#13'Anzahl Personen'+#13;

    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\ZahlerstatistikAltersStruktur.sql');
    frmDM.ZQueryHelp.Open;
    sMessage2     := '';
    border        := 0;
    borderLine    := 0;
    Bereichssumme := 0;
    slHelp.LoadFromFile(sAppDir+'module\ZahlerstatistikAlter.txt');

    if slHelp.Count > borderLine then border := strtoint(slHelp.Strings[borderLine]);
    sMessage2 := sMessage2 + 'unbekanntes Alter (wahrscheinlich kein Geburtsdatum)';
    inc(borderLine);
    while not frmDM.ZQueryHelp.EOF do
      begin
        Alter := frmDM.ZQueryHelp.FieldByName('Age').AsInteger;
        if Alter <= border
          then
            begin
              Bereichssumme := Bereichssumme + 1;
              frmDM.ZQueryHelp.Next;
            end
          else
            begin
              //Grenze überschritten
              sMessage      := sMessage + Format('%4.0f ',[Bereichssumme]) + sMessage2+#13;
              Bereichssumme := 0;
              if borderLine <= slHelp.Count-1
                then
                  begin
                    border := strtoint(slHelp.Strings[borderLine]);
                    sMessage2 := 'bis  '+Format('%2d Jahre',[border]);
                    inc(borderLine);
                  end
                else
                 begin
                   sMessage2 := 'über '+Format('%2d Jahre',[border]);
                   border := 999;
                 end;
            end;
      end;
    frmDM.ZQueryHelp.Close;

    frmAusgabe.SetDefaults('Zahlerstatistik Alter', sMessage, '', '', 'Schliessen', false);
    frmAusgabe.ShowModal;
  except
    on E: Exception
      do
        begin
          if frmDM.ZQueryHelp.Active then frmDM.ZQueryHelp.Close;
          LogAndShowError(e.Message);
        end;
  end;
end;

procedure TfrmMain.nmuDatensicherungClick(Sender: TObject);

begin
  Datensicherung(false, true);
end;

procedure TfrmMain.Datensicherung(Auto, Reconnect: boolean; Fileextension: String = '');

var
  shelp,
  sDest      : String;
  dtLastSave : TDateTime;

begin
  if frmDM.ZQueryInit.Active         then frmDM.ZQueryInit.close;
  if frmDM.ZConnectionBuch.Connected then frmDM.ZConnectionBuch.Disconnect;

  ForceDirectories(UTF8ToSys(sSavePath));
  shelp                 := 'ge_buch_'+FormatDateTime('yyyymmdd_hhnnss', now())+Fileextension+'.db';
  SaveDialog.InitialDir := sSavePath;
  SaveDialog.FileName   := shelp;

  if Auto
    then
      begin
        sDest := sAppDir+'Sicherung\'+shelp;
      end
    else
      begin
        if SaveDialog.Execute
          then sDest := SaveDialog.FileName
          else sDest := '';
      end;

  if sDest <> ''
    then
      begin
        myDebugLN('Savesrc:  '+sDatabase);
        myDebugLN('Savedest: '+sDest);

        sSavePath := ExtractFilePath(sDest);
        ForceDirectories(UTF8ToSys(sSavePath));

        if not fileutil.CopyFile(sDatabase,sDest, true)
          then
            begin
              LogAndShow(SysToUTF8(SysErrorMessage(GetLastOSError())));
            end
          else
            begin
              dtLastSave := now;
              help.WriteIniVal(sIniFile, 'Sicherung', 'Datum', DateToStr(dtLastSave));
              labDatensicherung.Caption := 'Letzte Datensicherung: '+DateToStr(dtLastSave);
              labDatensicherung.Color   := clNone;
              help.WriteIniVal(sIniFile, 'Sicherung', 'Verzeichnis', sSavePath);
            end;
      end;

  if Reconnect then
    begin
      frmDM.ZConnectionBuch.Connect;
      frmDM.ZQueryInit.Open;
    end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);

begin
  frmDM.CloseOpenQuerys;
  if frmDM.ZConnectionBuch.Connected then frmDM.ZConnectionBuch.Disconnect;
  slHelp.Free;
  myDebugLN('Beende '+frmMain.caption);
  myDebugLN('************************************************************************************');
  FlushDebug;
end;

procedure TfrmMain.btnBankkontenClick(Sender: TObject);

begin
  frmDM.ZQueryBanken.SQL.LoadFromFile(sAppDir+'module\BankenDrucken.sql');
  frmDM.ZQueryBanken.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);
  frmDM.ZQueryBanken.Open;
  frmBanken.showmodal;
end;

procedure TfrmMain.btnAktuellesClick(Sender: TObject);
begin
  frmAusgabe.SetDefaults(btnAktuelles.Caption, sAktuelles, '', '', 'Schliessen', false);
  frmAusgabe.ShowModal;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnDruckenClick(Sender: TObject);
begin
  frmDrucken.showmodal;
end;

procedure TfrmMain.mnuAbgleichClick(Sender: TObject);

const
  maxGemeinden = 6;

var
  i,
  nGemeinden,
  nSelectedGemeinde,
  checked,
  progress,
  up,
  down,
  insert : integer;
  Delta  : boolean;
  slSQL  : Tstringlist;
  sCheckFeld,
  sSQL   : string;
  sWhere : String = '';
  sData  : String;
  aGemeinden: array [0..maxGemeinden-1] of String = ('Reserve','Reserve','Reserve','Reserve','Reserve','Reserve');

begin
  slSQL       := Tstringlist.Create;
  slHelp.Text := sUpdatePersonenCheck;
  up          := 0;
  down        := 0;
  insert      := 0;
  checked     := 0;
  progress    := 0;
  nGemeinden  := 0;
  slSQL.Text  := 'Update Personen set Abgang="False";';


  OpenDialog.InitialDir := GetCurrentDir;          // Set up the starting directory to be the current one
  OpenDialog.Options := [ofFileMustExist];         // Only allow existing files to be selected
  OpenDialog.Filter := 'Datenbanken|*.db';         // Allow only .db files to be selected
  if OpenDialog.Execute                            // Display the open file dialog
  then
    begin
      try
        frmDM.ZConnectionGE_Kart.Database := OpenDialog.FileName;
        frmDM.ZConnectionGE_Kart.Connect;
        frmDM.ZQueryGE_Kart_Personen.SQL.Text := 'Select Gemeinde from Personen Group by Gemeinde order by Gemeinde';
        frmDM.ZQueryGE_Kart_Personen.Open;
        while (not frmDM.ZQueryGE_Kart_Personen.EOF) and (nGemeinden<maxGemeinden) do
          begin
            aGemeinden[nGemeinden] := frmDM.ZQueryGE_Kart_Personen.FieldByName('Gemeinde').AsString;
            if aGemeinden[nGemeinden] = '' then aGemeinden[nGemeinden] := 'leer';
            inc(nGemeinden);
            frmDM.ZQueryGE_Kart_Personen.Next;
          end;
        frmDM.ZQueryGE_Kart_Personen.Close;

        if (nGemeinden > 1) then
          begin
            nSelectedGemeinde := QuestionDlg('Personenabgleich',
                                             'Es wurden in der Gemeindekartei '+inttostr(nGemeinden)+' Gemeinden gefunden'+#13+
                                             'Für welche Gemeinde soll der Abgleich gemacht werden?',
                                             mtConfirmation,
                                             [0, aGemeinden[0], 1, aGemeinden[1], 2, aGemeinden[2], 3, aGemeinden[3], 4, aGemeinden[4], 5, aGemeinden[5], maxGemeinden, 'Alle', 11, 'Abbrechen', 'IsDefault'],
                                             '');
            if nSelectedGemeinde <= nGemeinden-1 then
              if aGemeinden[nSelectedGemeinde] <> 'leer' then
                sWhere := 'where Gemeinde = "'+aGemeinden[nSelectedGemeinde]+'"';
          end;

        //  Nur eine Gemeinde            gültiger Bereich                               Alle
        if (nGemeinden = 1) or (nSelectedGemeinde <= nGemeinden-1) or (nSelectedGemeinde = maxGemeinden) then
          begin
            Datensicherung(true, true, '_vor_Personenabgleich_');

            screen.Cursor:=crHourglass;

            frmDM.ZQueryGE_Kart_Personen.SQL.Text := 'Select * from Personen '+sWhere+' order by PersonenID';
            frmDM.ZQueryGE_Kart_Personen.Open;

            frmDM.ZQueryPersonen.SQL.Text:='Select * from Personen order by GE_KartID';
            frmDM.ZQueryPersonen.Open;

            //Der eigentliche Abgleich
            //  - bei nicht vorhandener ID einfügen
            //  - bei vorhandener ID Felder überschreiben
            //  - bei nur hier vorhandener Person Feld Abgang setzten

            frmDM.ZQueryGE_Kart_Personen.First;
            ProgressBar.Max := frmDM.ZQueryGE_Kart_Personen.RecordCount;
            ProgressBar.Visible := true;
            labProgress.Visible := true;
            labProgress.Caption := 'Schritt 1/3: Check 1';
            //Schleife durch GE_Kart Tabelle
            while not frmDM.ZQueryGE_Kart_Personen.EOF do
              begin
                if (frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger > frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger)
                  then frmDM.ZQueryPersonen.First;
                while ((not frmDM.ZQueryPersonen.EOF) and
                       (frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger <> frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger) and
                       (frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger <  frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger))
                  do frmDM.ZQueryPersonen.Next;
                inc(checked);
                inc(progress);
                ProgressBar.Position := progress;
                Application.ProcessMessages;
                myDebugStart('Prüfe GE_KartID: '+frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsString+' ');
                if frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger = frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger
                  then
                    begin
                      //Person gefunden
                      //Prüfen ob es Unterschiede gibt
                      delta := false;
                      sSQL  := '';
                      for i := 0 to slHelp.Count-1 do
                        begin
                          sCheckFeld := slHelp.Strings[i];
                          if frmDM.ZQueryGE_Kart_Personen.FieldByName(sCheckFeld).AsString <> frmDM.ZQueryPersonen.FieldByName(sCheckFeld).AsString
                            then
                              begin
                               if frmDM.ZQueryGE_Kart_Personen.FieldByName(sCheckFeld).DataType = ftDate
                                 then sData := SQLiteDateFormat(frmDM.ZQueryGE_Kart_Personen.FieldByName(sCheckFeld).AsDateTime)
                                 else sData := '"'+SQL_QuotedStr(frmDM.ZQueryGE_Kart_Personen.FieldByName(sCheckFeld).AsString)+'"';

                                if not delta
                                  then sSQL := 'Update personen set '+sCheckFeld+'='+sData
                                  else sSQL := sSQL + ', '+sCheckFeld+'='+sData;

                                delta := true
                              end;
                        end;
                      if delta
                        then
                          begin
                            sSQL := sSQL + ' where GE_KartID='+frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsString+';';
                            myDebugFinish(sSQL);
                            slSQL.Add(sSQL);
                            inc(up);
                          end
                        else myDebugFinish('Kein Unterschied gefunden');
                    end
                  else
                    begin
                      if frmDM.ZQueryGE_Kart_Personen.FieldByName('Abgang').AsString = 'True'
                        then myDebugFinish('Abgang in GE_Kart gesetzt. Wird nicht übernommen')
                        else
                          begin
                            sSQL := Format(sInsertPersonen, [
                                                 frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger, //Geht nach GE_KartID, PersonenID wird automatisch vergeben
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('BriefAnrede').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Titel').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Vorname').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Vorname2').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Nachname').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Strasse').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Land').AsString),
                                                 frmDM.ZQueryGE_Kart_Personen.FieldByName('PLZ').AsString,
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Ort').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('Ortsteil').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('TelPrivat').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('TelDienst').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('TelMobil').AsString),
                                SQL_QuotedStr(   frmDM.ZQueryGE_Kart_Personen.FieldByName('eMail').AsString),
                                SQLiteDateFormat(frmDM.ZQueryGE_Kart_Personen.FieldByName('Geburtstag').AsDateTime),
                                                 frmDM.ZQueryGE_Kart_Personen.FieldByName('Abgang').AsString]);
                            myDebugFinish(sSQL);
                            slSQL.Add(sSQL);
                            inc(insert);
                          end;
                    end;
                frmDM.ZQueryGE_Kart_Personen.Next;
              end;

            //Gegencheck, welche Person gibt es nur hier -- Abgang setzen
            ProgressBar.Max := frmDM.ZQueryPersonen.RecordCount;
            progress := 0;
            labProgress.Caption := 'Schritt 2/3: Check 2';
            frmDM.ZQueryPersonen.First;
            frmDM.ZQueryGE_Kart_Personen.First;
            while not frmDM.ZQueryPersonen.EOF do
              begin
                inc(progress);
                ProgressBar.Position := progress;
                Application.ProcessMessages;

                if (frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger < frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger)
                  then frmDM.ZQueryGE_Kart_Personen.First;
                while ((not frmDM.ZQueryGE_Kart_Personen.EOF) and
                       (frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger <> frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger) and
                       (frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger >  frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger))
                  do frmDM.ZQueryGE_Kart_Personen.Next;

                if frmDM.ZQueryPersonen.FieldByName('GE_KartID').AsInteger <> frmDM.ZQueryGE_Kart_Personen.FieldByName('PersonenID').AsInteger
                  then
                    begin
                      sSQL := 'Update Personen set Abgang="True" where PersonenID='+frmDM.ZQueryPersonen.FieldByName('PersonenID').AsString+';';
                      myDebugLN(sSQL);
                      slSQL.Add(sSQL);
                      inc(down);
                    end;
                frmDM.ZQueryPersonen.Next;
              end;

            frmDM.ZQueryPersonen.Close;
            frmDM.ZQueryGE_Kart_Personen.Close;
            frmDM.ZConnectionGE_Kart.Disconnect;

            labProgress.Caption := 'Schritt 3/3: Schreibe Datenbank';
            progress := 0;
            ProgressBar.Max      := slSQL.Count;
            ProgressBar.Position := progress;
            Application.ProcessMessages;

            while slSQL.Count > 0 do
              begin
                slHelp.Clear;
                while (slSQL.Count > 0) and (slHelp.Count<50) do
                  begin
                    slHelp.Add(slSQL.Strings[0]);
                    slSQL.Delete(0);
                    inc(progress);
                  end;
                ProgressBar.Position := progress;
                Application.ProcessMessages;
                frmDM.ExecuteTransactionSQL(slHelp.Text);
              end;
          end;

      except
        on E: Exception
          do
            begin
              screen.cursor := crdefault;
              ProgressBar.Visible := false;
              labProgress.Visible := false;
              if frmDM.ZQueryPersonen.Active then frmDM.ZQueryPersonen.Close;
              if frmDM.ZQueryGE_Kart_Personen.Active then frmDM.ZQueryGE_Kart_Personen.Close;
              frmDM.ZConnectionGE_Kart.Disconnect;
              LogAndShowError(e.Message);
            end;
      end;
      ProgressBar.Visible := false;
      labProgress.Visible := false;
      screen.Cursor:=crDefault;
      ShowMessage(IntToStr(checked)+' Personen geprüft, '+#13+
                  IntToStr(up)+' Personen aktualisiert, '+#13+
                  IntToStr(down)+' Personen als Abgang markiert, '+#13+
                  IntToStr(insert)+' Personen eingefügt. Bei diesen Personen ist das Feld "Gemeindeglied" gesetzt. Bitte ggf. korrigieren.');
    end
  else
    ShowMessage('Funktion abgebrochen');

  slSQL.Free;
end;

procedure TfrmMain.mnuCleanAutoBuchenClick(Sender: TObject);

Var
 ini   : TINIFile;
 i,n,m : integer;
 s,
 sMess,
 sLog,
 OrgKey,
 NewKey: String;

begin
  // Set up the starting directory to be the current one
  OpenDialog.InitialDir  := UTF8ToSys(sAppDir);
  Opendialog.FileName    := sJournalCSVImportINI;
  OpenDialog.Filter      := 'INI - Dateien|*.INI|Alle|*.*';
  openDialog.FilterIndex := 1;
  OpenDialog.Options     := [];

  if OpenDialog.Execute
    then
      begin
        sMess := '';
        sLog  := '';
        n     := 0;
        m     := 0;
        try
          screen.Cursor:=crHourglass;
          ini := TINIFile.Create(UTF8ToSys(Opendialog.FileName));
          ini.CacheUpdates:=true;  // Erst am Ende alles zusammen schreiben

          ini.ReadSection('Key', slHelp);
          try
            for i := 0 to slHelp.Count-1
              do
                begin
                  OrgKey := slHelp.Strings[i];
                  NewKey := DeleteChars(OrgKey, KeyDelChars); //Behn 30.12.15
                  s := ini.ReadString('Key', OrgKey, '0');
                  if (s = '0') or (s = '')
                    then
                      begin
                        sLog := sLog + 'Lösche Eintrag: "'+OrgKey+'" in Section KEY'+#13;
                        ini.DeleteKey('Key', OrgKey);
                        inc(n);
                      end
                    else
                      begin
                        if OrgKey <> NewKey                            //Behn 30.12.15
                          then
                            begin
                              sLog := sLog + 'Lösche Eintrag: "'+OrgKey+'" in Section KEY.'+#13;
                              ini.DeleteKey('Key', OrgKey);
                              sLog := sLog + 'Lege Eintrag: "'+NewKey+'='+s+'" in Section KEY neu an.'+#13;
                              ini.WriteString('Key', NewKey, s);
                              inc(m);
                            end;
                      end;
                end;
              myDebugLN(sLog);
              ini.CacheUpdates:=false; //Damit werden die Änderungen geschrieben
            except
              on e: Exception do
                begin
                  sMess := 'Problem beim Ausführen.'+#13+
                           'Bitte noch einmal starten'+#13+
                           e.Message+#13#13;
                end;
            end;
        finally
          ini.Free;
          screen.Cursor:=crDefault;
        end;

        showmessage(sMess+
                    inttostr(n)+' Einträge gelöscht'+#13+
                    inttostr(m)+' Einträge überarbeitet');
      end;

end;

procedure TfrmMain.mnuDelOldClick(Sender: TObject);
begin
  Datensicherung(true, true);
  if MessageDlg('Sollen die Daten aus dem Journal, die älter als '+inttostr(nBuchungsjahr-3)+' gelöscht werden?'#13#13+
                'Sicherheitsfunktion: Zum Fortfahren "Wiederholen" drücken!', mtConfirmation, [mbYes, mbRetry, mbNo],0) = mrRetry
    then
      showmessage(inttostr(ExecSQL('delete from journal where BuchungsJahr<'+inttostr(nBuchungsjahr-3), frmDM.ZQueryHelp, false))+' Buchungen gelöscht');
end;

procedure TfrmMain.mnuDelOldPersonenClick(Sender: TObject);
begin
  Datensicherung(true, true);
  if MessageDlg('Sollen die Personen, die als Abgang markiert sind gelöscht werden?'#13#13+
                'Sicherheitsfunktion: Zum Fortfahren "Wiederholen" drücken!', mtConfirmation, [mbYes, mbRetry, mbNo],0) = mrRetry
    then
      begin
        ExecSQL('Update journal set PersonenID = 0 where PersonenID in (Select PersonenID from Personen where (Abgang = 1) or (Abgang = ''true'') or (Abgang = ''True'') or (Abgang = ''Y''))', frmDM.ZQueryHelp, false);
        LogAndShow(inttostr(ExecSQL('Delete from Personen where (Abgang = 1) or (Abgang = ''true'') or (Abgang = ''True'') or (Abgang = ''Y'')', frmDM.ZQueryHelp, false))+' Personen gelöscht');
      end;
end;

procedure TfrmMain.mnuEuroModusClick(Sender: TObject);
begin
  bEuroModus           := not bEuroModus;
  mnuEuroModus.Checked := bEuroModus;
  if bEuroModus
    then help.WriteIniVal(sIniFile, 'Programm', 'EuroModus', 'true')
    else help.WriteIniVal(sIniFile, 'Programm', 'EuroModus', 'false');
end;

procedure TfrmMain.mnuExecSQLBatchClick(Sender: TObject);

var
  i    : integer;
  rows : longint;
  sHelp: String;

begin
  frmAusgabe.SetDefaults('SQL Kommandos ausführen', '--Hier SQL Kommandos eingeben'+#10#13+
                                                    '--Je Zeile ein Kommando', '', 'SQL ausführen', 'Abbrechen', true);
  if frmAusgabe.ShowModal = mrOK
    then
      begin
        rows := 0;
        for i := 0 to frmAusgabe.Memo.Lines.count-1 do
          begin
            sHelp := frmAusgabe.Memo.Lines[i];
            sHelp := SQL_DeleteComment(sHelp);
            if sHelp <> '' then rows := rows + ExecSQL(sHelp, frmDM.ZQueryHelp, false);
          end;
        if rows > 0 then Showmessage(inttostr(rows)+' Zeile(n) bearbeitet');
      end;
end;

procedure TfrmMain.btnJournalClick(Sender: TObject);
begin
  frmJournal.rgSort.ItemIndex     := 0;
  frmDM.ZQueryJournal.SQL.Text    := Format(sSelectJournal, [inttostr(nBuchungsjahr)]) + frmJournal.GetSortOrder;
  frmDM.ZQueryJournal.Open;
  frmDM.ZQueryBanken.SQL.Text     := 'select konten.* ,bankenabschluss.* from konten left join bankenabschluss on konten.kontonr=bankenabschluss.kontonr where bankenabschluss.Buchungsjahr='+inttostr(nBuchungsjahr)+' order by konten.kontonr';
  frmDM.ZQueryBanken.Open;
  frmDM.ZQueryPersonen.SQL.Text   := sSelectPersonenSort;
  frmDM.ZQueryPersonen.Open;
  frmDM.ZQuerySachkonten.SQL.Text := 'select * from Konten order by SortPos, kontoNr';
  frmDM.ZQuerySachkonten.Open;
  frmJournal.Showmodal;
end;

procedure TfrmMain.btnPersonenClick(Sender: TObject);
begin
  frmDM.ZQueryPersonen.SQL.Text := sSelectPersonenSort;
  frmDM.ZQueryPersonen.Open;
  frmPersonen.ShowModal;
end;

procedure TfrmMain.btnSachkontenClick(Sender: TObject);
begin
  frmDM.ZQuerySachkonten.SQL.Text := 'select * from konten Where kontotype <> "B" order by sortpos, kontoNr';
  frmDM.ZQuerySachkonten.Open;
  frmSachkonten.showModal;
end;

end.

