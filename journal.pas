unit journal;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  LazUTF8,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  DBGrids,
  DbCtrls,
  Grids,
  Menus,
  EditBtn,
  Spin,
  ExtCtrls,
  types;

type
  TMode = (readonly, filtered, append_Empty, append_TakeOver, edit, browse, import);

  { TfrmJournal }

  TfrmJournal = class(TForm)
    btnAbbrechen: TButton;
    btnAendern: TButton;
    btnClose: TButton;
    btnImport: TButton;
    btnLoeschen: TButton;
    btnNeueBuchung: TButton;
    btnNeueBuchungLeer: TButton;
    btnSpeichern: TButton;
    btnSkip: TButton;
    btnSpeichernAuto: TButton;
    cbCSVAutomatik: TCheckBox;
    cbKonto: TComboBox;
    cbPersonenname: TComboBox;
    cbSachkonto: TComboBox;
    cbBuchungstext: TComboBox;
    cbAufwendungen: TCheckBox;
    DateEditBuchungsdatum: TDateEdit;
    DBGridJournal: TDBGrid;
    ediBankNr: TEdit;
    ediBankNummerFilter: TEdit;
    ediTextFilter: TEdit;
    ediBelegnummer: TEdit;
    ediBemerkung: TEdit;
    ediBetrag: TEdit;
    ediBuchungsjahr: TSpinEdit;
    ediPersonenID: TEdit;
    ediPersonenNummerFilter: TEdit;
    ediSachKontoNummer: TEdit;
    ediSachKontoNummerFilter: TEdit;
    Label1: TLabel;
    labHinweis: TLabel;
    labImportMode: TLabel;
    labModus: TLabel;
    labFilter: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    labVZ: TLabel;
    lab_A_Konto: TLabel;
    lab_A_Pers: TLabel;
    lab_A_SK: TLabel;
    lab_KontoStart: TLabel;
    lab_N_Konto: TLabel;
    lab_N_Pers: TLabel;
    lab_N_SK: TLabel;
    MenuItem1: TMenuItem;
    mnuKorrDatum: TMenuItem;
    mnuInternBank: TMenuItem;
    mnuBankenliste_Nr: TMenuItem;
    mnuBankenliste: TMenuItem;
    mnuSachkontenliste: TMenuItem;
    mnuShowPersonenID: TMenuItem;
    mnuShowPersonenName: TMenuItem;
    mnuPopup: TPopupMenu;
    OpenDialog: TOpenDialog;
    panCSVImportData: TPanel;
    panDaten: TPanel;
    panHinweise: TPanel;
    panImportData: TPanel;
    panSteuerung: TPanel;
    panFilter: TPanel;
    panFilter1: TPanel;
    panSummen: TPanel;
    PopupMenuDatum: TPopupMenu;
    rgSort: TRadioGroup;
    sgImportData: TStringGrid;
    TimCheckSettingsForSave: TTimer;
    procedure btnAbbrechenClick(Sender: TObject);
    procedure btnAendernClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnLoeschenClick(Sender: TObject);
    procedure btnNeueBuchungClick(Sender: TObject);
    procedure btnNeueBuchungLeerClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
    procedure btnSpeichernAutoClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure cbBuchungstextExit(Sender: TObject);
    procedure cbKontoChange(Sender: TObject);
    procedure cbPersonennameChange(Sender: TObject);
    procedure cbSachkontoChange(Sender: TObject);
    procedure TimCheckSettingsForSaveTimer(Sender: TObject);
    procedure DateEditBuchungsdatumExit(Sender: TObject);
    procedure DateEditBuchungsdatumKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridJournalColumnSized(Sender: TObject);
    procedure DBGridJournalDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ediBankNrExit(Sender: TObject);
    procedure ediBelegnummerExit(Sender: TObject);
    procedure ediBetragExit(Sender: TObject);
    procedure ediBuchungsjahrChange(Sender: TObject);
    procedure ediPersonenIDExit(Sender: TObject);
    procedure ediSachKontoNummerExit(Sender: TObject);
    procedure ediFilterExit(Sender: TObject);
    procedure FilterPopUp(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure mnuBankenlisteClick(Sender: TObject);
    procedure mnuBankenliste_NrClick(Sender: TObject);
    procedure mnuInternBankClick(Sender: TObject);
    procedure mnuKorrDatumClick(Sender: TObject);
    procedure mnuSachkontenlisteClick(Sender: TObject);
    procedure mnuShowPersonenIDClick(Sender: TObject);
    procedure mnuShowPersonenNameClick(Sender: TObject);
    procedure rgSortClick(Sender: TObject);
  private
    { private declarations }
    Modus                : TMode;
    slBankenStartSaldo   : TStringList;
    slSuchTexteImport    : TStringList;
    CSVImportRow         : integer;
    CSVKeySK             : String;
    CSVKeyPers           : String;
    Save_BankNr          : String;
    Save_Startkontostand : integer;
    bStartFinished       : boolean;
    procedure ZeigeListe(SQL: String);
    procedure SetMode(aModus : TMode; RecNo: integer = 0);
    procedure SetFormular;
    procedure GetImportRec;
    procedure GetNextImportRec;
    procedure CheckSettingsForSave;
    procedure CheckSettingsForSave2;
    procedure FilterClear;
    Function  Str2Bool(s: string):boolean;
    Function  Bool2Str(b: boolean):String;
  public
    { public declarations }
    procedure AfterScroll;
    function  GetSortOrder: String;
  end;

var
  frmJournal: TfrmJournal;

implementation

{$R *.lfm}

//{$define DebugCallStack}

{ TfrmJournal }

uses
  dm,
  Journal_CSV_Import,
  uStrToDateFmt,
  db_liste,
  help,
  global,
  LCLType,
  DateUtils;

var
  ImpCol0Width,
  ImpCol1Width,
  ImpCol2Width,
  ImpCol3Width,
  ImpCol4Width,
  ImpCol5Width,
  ImpCol6Width,
  Col0Width,
  Col1Width,
  Col2Width,
  Col3Width,
  Col4Width,
  Col5Width,
  Col6Width,
  Col7Width,
  Col8Width,
  Winleft,
  WinTop,
  WinWidth,
  WinHeight : integer;

const
  ImpColZeile   = 0;
  ImpColDatum   = 1;
  ImpColBuTxt   = 2;
  ImpColBetrag  = 3;
  ImpColSoll_H  = 4;
  ImpColKeySK   = 5;
  ImpColKeyPers = 6;

Function TfrmJournal.Str2Bool(s: string):boolean;
begin
  result := (s = sJa);
end;

Function TfrmJournal.Bool2Str(b: boolean):String;
begin
  if b
    then result := sJa
    else result := sNein;
end;

function TfrmJournal.GetSortOrder: String;

begin
  if rgSort.ItemIndex = 0
    then result := ' LaufendeNr'
    else result := ' SortDate, LaufendeNr';
end;

procedure TfrmJournal.CheckSettingsForSave;

begin
  if Modus in [append_TakeOver, append_Empty, edit, import]
     then
       begin
         TimCheckSettingsForSave.Enabled := true;
         //Jetzt kan z.B. der Abbruchbutton ausgewertet werden. Ansonsten hängt man duch das SetFocus fest
         {$ifdef DebugCallStack} myDebugLN('TimCheckSettingsForSave.Enabled := true'); {$endif}
       end;
end;

procedure TfrmJournal.CheckSettingsForSave2;

Var
  bAllesOK : Boolean;

begin
  {$ifdef DebugCallStack} myDebugLN('CheckSettingsForSave2'); {$endif}
  bAllesOK := true;
  try
    if btnSpeichern.Visible
      then
        begin
          //Taborder beachten
          if FormatDateTime('yyyy',DateEditBuchungsdatum.Date) = inttostr(nBuchungsjahr)
            then DateEditBuchungsdatum.Color := clDefault
            else
              begin
                DateEditBuchungsdatum.Color := $8080FF;
                if bAllesOK and bJournalJump then DateEditBuchungsdatum.SetFocus;
                bAllesOK := false;
              end;
          if (ediSachKontoNummer.Text <> '0') and (ediSachKontoNummer.Text <> '')
            then ediSachKontoNummer.Color := clDefault
            else
              begin
                ediSachKontoNummer.Color := $8080FF;
                if bAllesOK and bJournalJump then ediSachKontoNummer.SetFocus;
                bAllesOK := false;
              end;
          if (ediBankNr.Text <> '0') and (ediBankNr.Text <> '')
            then ediBankNr.Color := clDefault
            else
              begin
                ediBankNr.Color := $8080FF;
                if bAllesOK and bJournalJump then ediBankNr.SetFocus;
                bAllesOK := false;
              end;
          if CurrencyToInt(ediBetrag.Text, bEuroModus) <> 0
            then ediBetrag.Color := clDefault
            else
              begin
                ediBetrag.Color := $8080FF;
                if bAllesOK and bJournalJump then ediBetrag.SetFocus;
                bAllesOK := false;
              end;
          if cbBuchungstext.Text <> ''
            then cbBuchungstext.Color := clDefault
            else
              begin
                cbBuchungstext.Color := $8080FF;
                if bAllesOK and bJournalJump then cbBuchungstext.SetFocus;
                bAllesOK := false;
              end;
          if ediBelegnummer.Text <> ''
            then ediBelegnummer.Color := clDefault
            else
              begin
                ediBelegnummer.Color := $8080FF;
                if bAllesOK and bJournalJump then ediBelegnummer.SetFocus;
                bAllesOK := false;
              end;
        end;
  except
    on e: Exception do
      begin
        LogAndShowError(e.Message);
        bAllesOK := false;
      end;
  end;

  btnSpeichern.Enabled := bAllesOK;

  labVZ.Visible := ((pos('A', cbSachKonto.Text) = 1) and (CurrencyToInt(ediBetrag.Text, bEuroModus) > 0)) or
                   ((pos('E', cbSachKonto.Text) = 1) and (CurrencyToInt(ediBetrag.Text, bEuroModus) < 0));

  if btnSpeichernAuto.Visible
    then
      begin
        btnSpeichernAuto.Enabled := btnSpeichern.Enabled;
        //btnSkip.Enabled          := btnSpeichern.Enabled;
      end;
  {$ifdef DebugCallStack} myDebugLN('CheckSettingsForSave2 finished'); {$endif}
end;

procedure TfrmJournal.AfterScroll;

begin
  {$ifdef DebugCallStack} myDebugLN('AfterScroll'); {$endif}
  //Wird aus DM aufgerufen
  if bStartFinished then
    case Modus of
      readonly,
      filtered,
      browse   : begin
                   SetFormular;
                 end;
      append_TakeOver,
      append_Empty,
      import   : begin
                 end;
      edit     : begin
                   SetMode(browse); //Funktion abbrechen
                 end;
    end;
  {$ifdef DebugCallStack} myDebugLN('AfterScroll finished'); {$endif}
end;

procedure TfrmJournal.SetFormular;

var
  StartKontostand,
  SummeBuchungen,
  SummeBuchungen2 : longint;
  i               : integer;

begin
  {$ifdef DebugCallStack} myDebugLN('SetFormular'); {$endif}
  if bStartFinished
    then
      begin
        case Modus of
          readonly,
          filtered,
          append_TakeOver,
          edit,
          browse,
          import           : begin
                               DateEditBuchungsdatum.Date := frmDM.ZQueryJournal.FieldByName('Datum').AsDateTime;
                               ediSachKontoNummer.Text    := frmDM.ZQueryJournal.FieldByName('Konto_nach').Asstring;
                               ediPersonenID.Text         := frmDM.ZQueryJournal.FieldByName('PersonenID').Asstring;
                               ediBankNr.Text             := frmDM.ZQueryJournal.FieldByName('BankNr').Asstring;
                               ediBetrag.Text             := IntToCurrency(frmDM.ZQueryJournal.FieldByName('Betrag').AsLongint);
                               cbBuchungstext.Text        := frmDM.ZQueryJournal.FieldByName('Buchungstext').Asstring;
                               ediBemerkung.Text          := frmDM.ZQueryJournal.FieldByName('Bemerkung').Asstring;
                               ediBelegnummer.Text        := frmDM.ZQueryJournal.FieldByName('Belegnummer').Asstring;
                               cbAufwendungen.Checked     := str2Bool(frmDM.ZQueryJournal.FieldByName('Aufwandsspende').AsString);
                             end;
          append_Empty     : begin
                               //DateEditBuchungsdatum.Date := now();
                               ediSachKontoNummer.Text    := '';
                               ediPersonenID.Text         := '';
                               //ediBankNr.Text             := '';
                               ediBetrag.Text             := '0,00';
                               cbBuchungstext.Text        := '';
                               ediBemerkung.Text          := '';
                               ediBelegnummer.Text        := frmDM.ZQueryJournal.FieldByName('Belegnummer').Asstring;
                               cbAufwendungen.Checked     := false;
                             end;
        end;

        cbBuchungstext.Hint := cbBuchungstext.Text;

        ediSachKontoNummerExit(self);
        ediPersonenIDExit(self);
        ediBankNrExit(self);

        case Modus of
          //import,
          append_Empty,
          append_TakeOver: begin
                             //Inc Belegnummer                       nur bei Sortorder LaufendeNr
                             if OnlyDigits(ediBelegnummer.Text) and (rgSort.ItemIndex = 0) and (frmDM.ZQueryJournal.EOF)
                               then ediBelegnummer.Text := inttostr(strtoint(ediBelegnummer.Text)+1);
                           end;
        end;

        case Modus of
          edit,
          append_TakeOver,
          append_Empty   : begin
                              //Vorschäge für Buchungstexte laden
                              frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\JournalGetBuchungstext.sql');
                              cbBuchungstext.Items.Text  := GetFirstDBFieldAsStringList(frmDM.ZQueryHelp);
                            end;
        end;

        if panSummen.Visible
          then
            begin
              if (ediSachKontoNummer.Text <> '0')  and (ediSachKontoNummer.Text <> '') and (pos('B', cbSachKonto.Text) <> 1)
                then
                  begin
                    lab_A_SK.Caption := IntToCurrency(GetDBSum(frmDM.ZQueryHelp, 'Journal', 'Betrag', '', 'Konto_nach='+ediSachKontoNummer.Text+
                                                                                 ' and BuchungsJahr='+inttostr(ediBuchungsjahr.Value-1)+
                                                                                 ' and LaufendeNr <='+frmDM.ZQueryJournal.FieldByName('LaufendeNr').Asstring));
                    lab_N_SK.Caption := IntToCurrency(GetDBSum(frmDM.ZQueryHelp, 'Journal', 'Betrag', '', 'Konto_nach='+ediSachKontoNummer.Text+
                                                                                 ' and BuchungsJahr='+inttostr(ediBuchungsjahr.Value)+
                                                                                 ' and LaufendeNr<='+frmDM.ZQueryJournal.FieldByName('LaufendeNr').Asstring));
                  end
                else
                  begin
                    lab_A_SK.Caption := '';
                    lab_N_SK.Caption := '';
                  end;

              if (ediPersonenID.Text <> '0') and (ediPersonenID.Text <> '')
                then
                  begin
                    lab_A_Pers.Caption := IntToCurrency(GetDBSum(frmDM.ZQueryHelp, 'Journal', 'Betrag', '', 'PersonenID='+ediPersonenID.Text+
                                                                            ' and BuchungsJahr='+inttostr(ediBuchungsjahr.Value-1)+
                                                                            ' and LaufendeNr<='+frmDM.ZQueryJournal.FieldByName('LaufendeNr').Asstring));
                    lab_N_Pers.Caption := IntToCurrency(GetDBSum(frmDM.ZQueryHelp, 'Journal', 'Betrag', '', 'PersonenID='+ediPersonenID.Text+
                                                                            ' and BuchungsJahr='+inttostr(ediBuchungsjahr.Value)+
                                                                            ' and LaufendeNr<='+frmDM.ZQueryJournal.FieldByName('LaufendeNr').Asstring));
                  end
                else
                  begin
                    lab_A_Pers.Caption := '';
                    lab_N_Pers.Caption := '';
                  end;

              //Bank Kontostand
              try
                StartKontostand := strtoint(slBankenStartSaldo.Strings[cbKonto.ItemIndex]);
              except
                //Tritt bei Start auf
                StartKontostand := 0;
              end;
              lab_KontoStart.Caption := IntToCurrency(StartKontostand);
              SummeBuchungen  := GetDBSum(frmDM.ZQueryHelp, 'Journal', 'Betrag', '', 'BankNr='+ediBankNr.Text+
                                                               ' and BuchungsJahr='+inttostr(ediBuchungsjahr.Value)+
                                                               ' and LaufendeNr<='+frmDM.ZQueryJournal.FieldByName('LaufendeNr').Asstring);
              SummeBuchungen2 := GetDBSum(frmDM.ZQueryHelp, 'Journal', 'Betrag', '', 'Konto_nach='+ediBankNr.Text+
                                                               ' and BuchungsJahr='+inttostr(ediBuchungsjahr.Value)+
                                                               ' and LaufendeNr<='+frmDM.ZQueryJournal.FieldByName('LaufendeNr').Asstring);
              lab_N_Konto.Caption := IntToCurrency(StartKontostand+SummeBuchungen-SummeBuchungen2);
              if cbKonto.ItemIndex > 0
                then lab_A_Konto.Caption := IntToCurrency(StartKontostand+SummeBuchungen-SummeBuchungen2-frmDM.ZQueryJournal.FieldByName('Betrag').AsLongint)
                else lab_A_Konto.Caption := '0,00';
            end;

        //Hier wegen refresh auf Query
        DBGridJournal.Columns.Items[0].Width := Col0Width;
        DBGridJournal.Columns.Items[1].Width := Col1Width;
        DBGridJournal.Columns.Items[2].Width := Col2Width;
        DBGridJournal.Columns.Items[3].Width := Col3Width;
        DBGridJournal.Columns.Items[4].Width := Col4Width;
        DBGridJournal.Columns.Items[5].Width := Col5Width;
        DBGridJournal.Columns.Items[6].Width := Col6Width;
        DBGridJournal.Columns.Items[7].Width := Col7Width;
        DBGridJournal.Columns.Items[8].Width := Col8Width;
        for i := 9 to DBGridJournal.Columns.Count-1
          do DBGridJournal.Columns.Items[i].Visible  := false;
      end;
  {$ifdef DebugCallStack} myDebugLN('SetFormular finished');  {$endif}
end;

procedure TfrmJournal.SetMode(aModus : TMode; RecNo: integer = 0);

begin
  {$ifdef DebugCallStack} myDebugLN('SetMode'); {$endif}
  btnImport.Visible          := false;
  panFilter.Visible          := false;
  panFilter1.Visible         := false;
  rgSort.Visible             := false;
  cbCSVAutomatik.Visible     := false;
  btnSpeichern.Visible       := false;
  btnSpeichernAuto.Visible   := false;
  btnNeueBuchung.Visible     := false;
  btnNeueBuchungLeer.Visible := false;
  btnAendern.Visible         := false;
  btnLoeschen.Visible        := false;
  panImportData.Visible      := false;
  btnClose.Visible           := false;
  btnSkip.Visible            := false;
  btnAbbrechen.Visible       := false;
  panSummen.Visible          := true;
  Modus                      := aModus;
  case Modus of
    readonly : begin
                 btnClose.Visible           := true;
                 panFilter.Visible          := true;
                 panFilter1.Visible         := true;
                 rgSort.Visible             := true;
                 frmJournal.Caption         := 'Journalmodus: alte Daten ansehen';
               end;
    filtered : begin
                 btnClose.Visible           := true;
                 panFilter.Visible          := true;
                 panFilter1.Visible         := true;
                 rgSort.Visible             := true;
                 btnAendern.Visible         := (nBuchungsjahr = ediBuchungsjahr.Value);
                 btnLoeschen.Visible        := (nBuchungsjahr = ediBuchungsjahr.Value);
                 frmJournal.Caption         := 'Journalmodus: gefilterte Daten ansehen';
               end;
    append_TakeOver,
    append_Empty
             : begin
                 btnSpeichern.Visible       := true;
                 btnAbbrechen.Visible       := true;
                 frmJournal.Caption         := 'Journalmodus: neu erfassen';
               end;
    edit     : begin
                 btnSpeichern.Visible       := true;
                 btnAbbrechen.Visible       := true;
                 frmJournal.Caption         := 'Journalmodus: bearbeiten';
               end;
    browse   : begin
                 btnClose.Visible           := true;
                 btnNeueBuchung.Visible     := true;
                 btnNeueBuchungLeer.Visible := true;
                 btnAendern.Visible         := true;
                 btnLoeschen.Visible        := true;
                 btnImport.Visible          := true;
                 cbCSVAutomatik.Visible     := true;
                 panFilter.Visible          := true;
                 panFilter1.Visible         := true;
                 rgSort.Visible             := true;
                 ediSachKontoNummer.Color   := clDefault;
                 ediBankNr.Color            := clDefault;
                 ediBetrag.Color            := clDefault;
                 cbBuchungstext.Color       := clDefault;
                 ediBelegnummer.Color       := clDefault;
                 DateEditBuchungsdatum.Color:= clDefault;
                 frmJournal.Caption         := 'Journalmodus: aktuelles Jahr ansehen';
               end;
    import   : begin
                 btnSpeichern.Visible       := true;
                 btnSpeichernAuto.Visible   := true;
                 btnAbbrechen.Visible       := true;
                 btnSkip.Visible            := true;

                 panImportData.visible      := true;

                 panSummen.Visible          := false;
                 frmJournal.Caption         := 'Journalmodus: importieren';
               end;
  end;

  labModus.Caption := frmJournal.Caption;

  case Modus of
    readonly,
    filtered,
    browse   : begin
                 DateEditBuchungsdatum.Enabled  := false;
                 ediSachKontoNummer.Enabled     := false;
                 cbSachkonto.Enabled            := false;
                 ediPersonenID.Enabled          := false;
                 cbPersonenname.Enabled         := false;
                 ediBankNr.Enabled              := false;
                 cbKonto.Enabled                := false;
                 ediBetrag.Enabled              := false;
                 cbBuchungstext.Enabled         := false;
                 ediBelegnummer.Enabled         := false;
                 ediBemerkung.Enabled           := false;
                 cbAufwendungen.Enabled         := false;
                 DBGridJournal.Enabled          := true; //DS-Wechsel erlaubt
                 ediBuchungsjahr.Enabled        := true;
                 application.ProcessMessages;
                 try
                   DBGridJournal.SetFocus;
                 except
                   on E: Exception do LogAndShowError(e.Message+' (internal code 1)');
                 end;
               end;
    import,
    append_TakeOver,
    append_Empty,
    edit     : begin
                 DateEditBuchungsdatum.Enabled  :=  true;
                 ediSachKontoNummer.Enabled     :=  true;
                 cbSachkonto.Enabled            :=  true;
                 ediPersonenID.Enabled          :=  true;
                 cbPersonenname.Enabled         :=  true;
                 ediBankNr.Enabled              :=  true;
                 cbKonto.Enabled                :=  true;
                 ediBetrag.Enabled              :=  true;
                 cbBuchungstext.Enabled         :=  true;
                 ediBelegnummer.Enabled         :=  true;
                 ediBemerkung.Enabled           :=  true;
                 cbAufwendungen.Enabled         :=  true;
                 DBGridJournal.Enabled          := false; //DS-Wechsel nicht erlaubt
                 ediBuchungsjahr.Enabled        := false; //Buchungsjahr darf nicht geändert werden
                 application.ProcessMessages;
                 try
                   DateEditBuchungsdatum.Refresh;
                   DateEditBuchungsdatum.SetFocus;
                 except
                   on E: Exception do  LogAndShowError(e.Message+' (internal code 2)');
                 end;
               end;
  end;

  if RecNo <> 0 then frmDM.ZQueryJournal.RecNo := RecNo;

  application.ProcessMessages;

  SetFormular;

  {$ifdef DebugCallStack} myDebugLN('SetMode finished'); {$endif}
end;

procedure TfrmJournal.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmJournal.btnImportClick(Sender: TObject);

begin
  {$ifdef DebugCallStack} myDebugLN('btnImportClick'); {$endif}

  frmJournal_CSV_Import.filename := '';
  OpenDialog.Title       := 'Daten-Import CSV Datei auswählen';
  OpenDialog.InitialDir  := UTF8ToSys(sImportPath);         // Set up the starting directory to be the current one
  OpenDialog.Options     := [ofFileMustExist];              // Only allow existing files to be selected
  OpenDialog.Filter      := 'CSV - Dateien|*.CSV|Alle|*.*'; // Allow only .csv files to be selected
  openDialog.FilterIndex := 1;                              // Select CSV files as the starting filter type

  // Display the open file dialog
  if OpenDialog.Execute
    then
      begin
        frmJournal_CSV_Import.filename := UTF8ToSys(OpenDialog.FileName);
        sImportPath := ExtractFilePath(SysToUTF8(OpenDialog.FileName));
      end;

  if frmJournal_CSV_Import.filename <> ''
    then
      begin
        // Set up the starting directory to be the current one
        OpenDialog.Title       := 'Daten-Import Steuerdatei (INI) auswählen';
        OpenDialog.InitialDir  := UTF8ToSys(sAppDir);
        Opendialog.FileName    := sJournalCSVImportINI;
        OpenDialog.Filter      := 'INI - Dateien|*.INI|Alle|*.*';
        openDialog.FilterIndex := 1;
        OpenDialog.Options     := [];

        if OpenDialog.Execute then sJournalCSVImportINI := OpenDialog.FileName;

        if frmJournal_CSV_Import.Showmodal = mrOK
          then
            begin
              help.WriteIniVal(sIniFile, 'CSV-Import', 'Verzeichnis', sImportPath);
              if frmJournal_CSV_Import.Richtung = 0
                then CSVImportRow := frmJournal_CSV_Import.RowEnde //Von unten
                else CSVImportRow := frmJournal_CSV_Import.RowStart;
              SetMode(import);
              if frmJournal_CSV_Import.cbBank.Text <> ''
                then ediBankNr.Text := inttostr(integer(frmJournal_CSV_Import.cbBank.Items.Objects[frmJournal_CSV_Import.cbBank.ItemIndex]))
                else ediBankNr.Text := '0';
              ediBankNrExit(self);
              //Inc Belegnummer  beim 1. Aufruf
              //                                      nur bei Sortorder LaufendeNr
              if OnlyDigits(ediBelegnummer.Text) and (rgSort.ItemIndex = 0) and (frmDM.ZQueryJournal.EOF)
                then ediBelegnummer.Text := inttostr(strtoint(ediBelegnummer.Text)+1);
              GetImportRec;
            end;
      end;
  {$ifdef DebugCallStack} myDebugLN('btnImportClick finished'); {$endif}
end;

procedure TfrmJournal.btnLoeschenClick(Sender: TObject);

var
  BankNr : longint;
  Betrag : longint;

begin
  {$ifdef DebugCallStack} myDebugLN('btnLoeschenClick'); {$endif}
  if MessageDlg('Buchung Nr. '+frmDM.ZQueryJournal.FieldByName('LaufendeNr').AsString+' löschen?'#13#13+
                'Sicherheitsfunktion: Zum Fortfahren "Wiederholen" drücken!', mtConfirmation, [mbYes, mbRetry, mbNo],0) = mrRetry
    then
      begin
        BankNr := frmDM.ZQueryJournal.FieldByName('BankNr').AsLongint;
        Betrag := frmDM.ZQueryJournal.FieldByName('Betrag').AsLongint;
        frmDM.ZQueryHelp.SQL.Text := 'delete from journal where LaufendeNr=' + frmDM.ZQueryJournal.FieldByName('LaufendeNr').AsString;
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryHelp.SQL.Text := 'update konten set Kontostand=Kontostand - '+inttostr(Betrag)+' where KontoNr='+inttostr(BankNr);
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryJournal.Refresh;
        frmDM.ZQueryJournal.Last;
        frmDM.ZQueryBanken.Refresh;
        FilterClear;
        SetFormular;
      end
    else
      begin
        LogAndShow('Löschen abgebrochen');
      end;
  {$ifdef DebugCallStack} myDebugLN('btnLoeschenClick finished'); {$endif}
end;

procedure TfrmJournal.GetImportRec;

var
  DateFormat   : Array of String;
  i, myPos     : integer;
  sLine,
  sWord,
  CSVKeyPersII : string;
  bFoundSK     : boolean;
  bFoundPers   : boolean;

  Procedure CutBuchungstextInGrid(Suchtext: String; Richtung: boolean);

  begin
    if Suchtext <> ''
      then
        begin
          sLine := sgImportData.Cells[ImpColBuTxt ,1]; //Buchungstext holen
          myPos := pos(Suchtext, sLine);               //Schlüsselwort suchen
          if myPos <> 0                                //Schlüsselwort vorhanden
            then
              begin
                if Richtung
                  then delete(sLine,1,myPos-1)
                  else delete(sLine,myPos,999);
                  sgImportData.Cells[ImpColBuTxt ,1] := sLine;
              end;
        end;
  end;

begin
  {$ifdef DebugCallStack} myDebugLN('GetImportRec'); {$endif}
  try
    frmJournal.Caption := 'Journalmodus: importieren, bearbeite Reihe: '+inttostr(CSVImportRow);

    //Übernahme in lokales Grid
      //Zeile
    sgImportData.Cells[ImpColZeile,1]   := inttostr(CSVImportRow);
      //Datum
    sgImportData.Cells[ImpColDatum,1]   := frmJournal_CSV_Import.StringGridDaten.Cells[frmJournal_CSV_Import.ColDatum, CSVImportRow];
      //Buchungstext
    sgImportData.Cells[ImpColBuTxt ,1]  := frmJournal_CSV_Import.GetRowBuchungstext(CSVImportRow);
      //Schlüsselfelder
    sgImportData.Cells[ImpColKeySK,1]   := frmJournal_CSV_Import.GetRowKeySK(CSVImportRow);
    sgImportData.Cells[ImpColKeyPers,1] := frmJournal_CSV_Import.GetRowKeyPers(CSVImportRow);
      //Betrag
    sgImportData.Cells[ImpColBetrag,1]  := frmJournal_CSV_Import.StringGridDaten.Cells[frmJournal_CSV_Import.ColBetrag, CSVImportRow];
      //Soll/Haben
    if frmJournal_CSV_Import.ColSollHaben > 0
      then sgImportData.Cells[ImpColSoll_H,1] := frmJournal_CSV_Import.StringGridDaten.Cells[frmJournal_CSV_Import.ColSollHaben, CSVImportRow]
      else sgImportData.Cells[ImpColSoll_H,1] := '';

//Nachbearbeitung

    //Buchungstext bei Sepa beschneiden
    //Damit kann z.B.
    // - alles vor dem Schlüsselwort(Vorschlag SVWZ) löschen    SVWZ steht für “SEPA-VerWendungsZweck”
    // - die ständig wechselnde EREF ausgeblendet werden.       EREF steht für “Ende-zu-Ende-Referenz”
    // - Oder die Zahl hinter ZV.                               ZV   steht für "Zahlungsverkehr"
    CutBuchungstextInGrid(frmJournal_CSV_Import.ediDelStr1.Text, frmJournal_CSV_Import.DelUntil1.Checked);
    CutBuchungstextInGrid(frmJournal_CSV_Import.ediDelStr2.Text, frmJournal_CSV_Import.DelUntil2.Checked);
    CutBuchungstextInGrid(frmJournal_CSV_Import.ediDelStr3.Text, frmJournal_CSV_Import.DelUntil3.Checked);

    //Lange Texte als Hint lesbar machen
    sgImportData.Hint := 'Buchungstext: '  +sgImportData.Cells[ImpColBuTxt ,1]+#13+
                         'Schlüssel-SK: '  +sgImportData.Cells[ImpColKeySK,1]+#13+
                         'Schlüssel-Pers: '+sgImportData.Cells[ImpColKeyPers,1];

    //Manche Banken liefern ganze Eurobeträge ohne ",00"
    if (pos(DefaultFormatSettings.DecimalSeparator , sgImportData.Cells[ImpColBetrag,1]) = 0) and
       (pos(DefaultFormatSettings.ThousandSeparator, sgImportData.Cells[ImpColBetrag,1]) = 0)
      then sgImportData.Cells[ImpColBetrag,1] := sgImportData.Cells[ImpColBetrag,1]+',00';

    //Keys ohne Spezialzeichen erstellen.
    //Aus dem Key das Buchungsjahr ausfiltern.
    CSVKeySK     := DeleteChars(Uppercase(sgImportData.Cells[ImpColKeySK,1]), KeyDelChars);
    CSVKeySK     := StringReplace(CSVKeySK, ediBuchungsjahr.Text, '', [rfReplaceAll]);
    CSVKeyPers   := DeleteChars(Uppercase(sgImportData.Cells[ImpColKeyPers,1]), KeyDelChars);
    CSVKeyPers   := StringReplace(CSVKeyPers, ediBuchungsjahr.Text, '', [rfReplaceAll]);
    CSVKeyPersII := CSVKeyPers + DeleteChars(Uppercase(sgImportData.Cells[ImpColBuTxt ,1]), KeyDelChars);

//Füllen der Eingabefelder

    //Suchen SK in sAppDir+'module\SuchTexteImport.txt'
    bFoundSK := false;
    i := 0;
    while (slSuchTexteImport.Count-1 >= i) and not bFoundSK do
      begin
        sLine    := slSuchTexteImport.Strings[i];
        sWord    := Uppercase(ExtractWord(2, sLine, [';']));
        bFoundSK := pos(sWord, CSVKeySK) <> 0;
        if bFoundSK
           then
             begin
               ediSachKontoNummer.Text := ExtractWord(1, sLine, [';']);
               myDebugLN('Sachkonto: '+ediSachKontoNummer.Text+' gefunden über globales Steuerwort '+sWord+' in '+CSVKeySK);
             end;
        inc(i);
      end;
    //Wenn SK nicht gefunden
    if not bFoundSK // dann in INI-Datei nachsehen
      then
        begin
          ediSachKontoNummer.Text := help.ReadIniVal(sJournalCSVImportINI, 'Key', CSVKeySK+'_SK', '0', false);
          if ediSachKontoNummer.Text <> '0'
            then myDebugLN('Sachkonto: '+ediSachKontoNummer.Text+' gefunden über '+CSVKeySK+' in der INI-Datei');
        end;
    ediSachKontoNummerExit(self); //Comboboxen richtig einstellen

    //Suche Person
    ediPersonenID.Text := help.ReadIniVal(sJournalCSVImportINI, 'Key', CSVKeyPers+'_PersID', '0', false);
    if ediPersonenID.Text <> '0'
      then myDebugLN('Person: '+ediPersonenID.Text+' gefunden über '+CSVKeyPers+' in der INI-Datei');
    ediPersonenIDExit(self);  //Comboboxen richtig einstellen

    sLine := '';
    if ediPersonenID.Text = '0'
      then  //Kandidatensuche über DB
        begin
          frmDM.ZQueryPersonen.First;
          while not frmDM.ZQueryPersonen.EOF do
            begin
              if (pos(DeleteChars(Uppercase(frmDM.ZQueryPersonen.FieldByName('Nachname').AsString+frmDM.ZQueryPersonen.FieldByName('Vorname').AsString), KeyDelChars), CSVKeyPersII) <> 0) or
                 (pos(DeleteChars(Uppercase(frmDM.ZQueryPersonen.FieldByName('Vorname').AsString+frmDM.ZQueryPersonen.FieldByName('Nachname').AsString), KeyDelChars), CSVKeyPersII) <> 0)
                 then
                   sLine := sLine + frmDM.ZQueryPersonen.FieldByName('Nachname').AsString+', '+frmDM.ZQueryPersonen.FieldByName('Vorname').AsString+', '+frmDM.ZQueryPersonen.FieldByName('Strasse').AsString+', ID: '+frmDM.ZQueryPersonen.FieldByName('PersonenID').AsString+#13;
              frmDM.ZQueryPersonen.Next;
            end;
        end;
    if sLine <> ''
       then labHinweis.Caption := 'Kandidatensuche anhand der Datenbank in Buchungstext und Schlüssel(Pers):'+#13#13+sLine
       else labHinweis.Caption := '';
    if labHinweis.Height > 1
    then panImportData.Height := panCSVImportData.Height + labHinweis.Height + 10
    else panImportData.Height := panCSVImportData.Height;

    //Für Einnahmekonten soll es ein Zahler geben
    if (pos('E', cbSachkonto.Text) = 1)
      then bFoundPers := (ediPersonenID.Text <> '0')
      else bFoundPers := true;

    //Datum
    i := 1;
    sWord := GetCSVRecordItem(i, frmJournal_CSV_Import.Datumsformat, [','], ' ');
    while sWord <> '' do
      begin
        setlength(DateFormat,i);
        DateFormat[i-1]:= sWord;
        inc(i);
        sWord := GetCSVRecordItem(i, frmJournal_CSV_Import.Datumsformat, [','], ' ');
      end;

    DateEditBuchungsdatum.Date := StrToDateFmt(sgImportData.Cells[ImpColDatum,1], DateFormat);
    DateEditBuchungsdatumExit(self);

    //Buchngstext
    cbBuchungstext.Text := sgImportData.Cells[ImpColBuTxt ,1];
    cbBuchungstext.Hint := cbBuchungstext.Text;

    //Betrag
    ediBetrag.Text := IntToCurrency(CurrencyToInt(sgImportData.Cells[ImpColBetrag,1], bEuroModus)); // Damit die Zahl 1.0 in 1,0 gewandelt wird
    //Sonderbehandlung negative Zahlen
    if (frmJournal_CSV_Import.ColSollHaben > 0) and (frmJournal_CSV_Import.StrSollHaben = sgImportData.Cells[ImpColSoll_H,1])
      then ediBetrag.Text := '-'+ediBetrag.Text;

    ediBemerkung.Text := ''; //Damit nicht überall die gleiche Bemerkung steht....

    //Automatisch buchen
    if  cbCSVAutomatik.Checked          and
       (ediSachKontoNummer.Text <> '0') and (ediSachKontoNummer.Text <> '') and
       (ediBankNr.Text <> '0')          and (ediBankNr.Text <> '')          and
        bFoundPers                      and
       (FormatDateTime('yyyy',DateEditBuchungsdatum.Date) = inttostr(nBuchungsjahr))
      then btnSpeichernClick(self)
      else CheckSettingsForSave;

  except
    on e: Exception do
      begin
        LogAndShowError(e.Message+#13#13+'Der Import wird abgebrochen');
        btnAbbrechenClick(self);
      end;
  end;

  {$ifdef DebugCallStack} myDebugLN('GetImportRec finished'); {$endif}
end;

procedure TfrmJournal.btnAendernClick(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('btnAendernClick'); {$endif}
  Save_BankNr          := ediBankNr.Text;
  Save_Startkontostand := CurrencyToInt(lab_KontoStart.Caption, bEuroModus);
  SetMode(edit);
  {$ifdef DebugCallStack} myDebugLN('btnAendernClick finished'); {$endif}
end;

procedure TfrmJournal.btnAbbrechenClick(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('btnAbbrechenClick'); {$endif}
  SetMode(browse);
  {$ifdef DebugCallStack} myDebugLN('btnAbbrechenClick finished'); {$endif}
end;

procedure TfrmJournal.btnNeueBuchungClick(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('btnNeueBuchungClick'); {$endif}
  SetMode(append_TakeOver);
  {$ifdef DebugCallStack} myDebugLN('btnNeueBuchungClick finished'); {$endif}
end;

procedure TfrmJournal.btnNeueBuchungLeerClick(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('btnNeueBuchungLeerClick'); {$endif}
  frmDM.ZQueryJournal.Last;
  SetMode(append_empty);
  {$ifdef DebugCallStack} myDebugLN('btnNeueBuchungLeerClick finished'); {$endif}
end;

procedure TfrmJournal.btnSkipClick(Sender: TObject);
begin
  GetNextImportRec;
end;

procedure TfrmJournal.btnSpeichernAutoClick(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('btnSpeichernAutoClick');  {$endif}
  if ((ediSachKontoNummer.Text <> '0') and (ediSachKontoNummer.Text <> ''))
    then help.WriteIniVal(sJournalCSVImportINI,'Key',CSVKeySK+'_SK', ediSachKontoNummer.Text);
  btnSpeichernClick(self);
  {$ifdef DebugCallStack} myDebugLN('btnSpeichernAutoClick finished');  {$endif}
end;

procedure TfrmJournal.btnSpeichernClick(Sender: TObject);

var
  nHelp,
  Betrag,
  Sollbetrag: longint;

begin
  {$ifdef DebugCallStack} myDebugLN('btnSpeichernClick'); {$endif}
  betrag := CurrencyToInt(ediBetrag.Text, bEuroModus);
  case Modus of
    append_TakeOver,
    append_Empty,
    import : begin
               frmDM.ZQueryHelp.SQL.Text := Format(sInsertJournal, [
                                                   SQLiteDateFormat(DateEditBuchungsdatum.Date),
                                                   ediSachKontoNummer.Text,
                                                   ediBankNr.Text,
                                                   ediPersonenID.Text,
                                                   betrag,
                                                   SQL_QuotedStr(cbBuchungstext.Text),
                                                   SQL_QuotedStr(ediBelegnummer.Text),
                                                   nBuchungsjahr,
                                                   SQL_QuotedStr(ediBemerkung.Text),
                                                   bool2str(cbAufwendungen.Checked)]); // Aufwandsspende
               frmDM.ZQueryHelp.ExecSQL;
             end;
    edit   : begin
               frmDM.ZQueryHelp.SQL.Text := 'update journal set ';
               frmDM.ZQueryHelp.SQL.add('Datum='        + SQLiteDateFormat(DateEditBuchungsdatum.Date)+',');
               frmDM.ZQueryHelp.SQL.add('Konto_nach='   + ediSachKontoNummer.Text+',');
               frmDM.ZQueryHelp.SQL.add('BankNr='       + ediBankNr.Text+',');
               frmDM.ZQueryHelp.SQL.add('PersonenID='   + ediPersonenID.Text+',');
               frmDM.ZQueryHelp.SQL.add('Betrag='       + inttostr(CurrencyToInt(ediBetrag.Text, bEuroModus))+',');
               frmDM.ZQueryHelp.SQL.add('Buchungstext="'+ SQL_QuotedStr(cbBuchungstext.Text)+'",');
               frmDM.ZQueryHelp.SQL.add('Belegnummer="' + SQL_QuotedStr(ediBelegnummer.Text)+'",');
               frmDM.ZQueryHelp.SQL.add('Bemerkung="'   + SQL_QuotedStr(ediBemerkung.Text)+'",');
               frmDM.ZQueryHelp.SQL.add('Aufwandsspende="'  + bool2str(cbAufwendungen.Checked)+'"');
               frmDM.ZQueryHelp.SQL.add('where LaufendeNr=' + frmDM.ZQueryJournal.FieldByName('LaufendeNr').AsString);
               frmDM.ZQueryHelp.ExecSQL;
             end;
  end;

  //Kontostand Bank
  frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\updateKontostand.sql');
  frmDM.ZQueryHelp.ParamByName('BJahr').AsInteger := ediBuchungsjahr.Value;
  frmDM.ZQueryHelp.ExecSQL;

  case Modus of
    append_TakeOver,
    append_Empty:begin
               bStartFinished := false;
               frmDM.ZQueryJournal.Refresh;
               frmDM.ZQueryJournal.Last;
               bStartFinished := true;
               SetFormular;
               application.ProcessMessages;
               try
                 DateEditBuchungsdatum.SetFocus; //Weiter mit der Eingabe
               except
                 on E: Exception do LogAndShowError(e.Message+' (internal code 3)');
               end;
             end;
    edit   : begin
               bStartFinished := false;
               nHelp := frmDM.ZQueryJournal.RecNo;
               frmDM.ZQueryJournal.Refresh;
               frmDM.ZQueryJournal.Last;
               bStartFinished := true;
               if labFilter.Visible
                  then FilterClear
                  else SetMode(browse, nHelp);
             end;
    import : begin
               //Daten nach Ini schreiben
               if ((ediPersonenID.Text <> '0') and (ediPersonenID.Text <> '')) then help.WriteIniVal(sJournalCSVImportINI, 'Key', CSVKeyPers+'_PersID', ediPersonenID.Text);

               bStartFinished := false;
               frmDM.ZQueryJournal.Refresh;
               frmDM.ZQueryJournal.Last;
               bStartFinished := true;

               //Sonderbehandlung negative Zahlen
               if frmJournal_CSV_Import.StrSollHaben = sgImportData.Cells[ImpColSoll_H,1]
                 then Sollbetrag := CurrencyToInt('-'+sgImportData.Cells[ImpColBetrag,1], bEuroModus)
                 else Sollbetrag := CurrencyToInt(sgImportData.Cells[ImpColBetrag,1], bEuroModus);

               //Splittbuchung?
               if Betrag <> Sollbetrag
                 then
                   begin
                     labImportMode.Color                := clYellow;
                     Sollbetrag                         := Sollbetrag-Betrag;
                     ediBetrag.Text                     := IntToCurrency(Sollbetrag);
                     sgImportData.Cells[ImpColBetrag,1] := ediBetrag.Text;
                     labImportMode.Caption              := 'Splitbuchung. Restbetrag: '+ediBetrag.Text;
                     btnSkip.Enabled                    := false;
                   end
                 else
                   begin
                     //Nächster Datensatz
                     GetNextImportRec;
                   end;
             end;
  end;

  case Modus of
    import : begin
               //Inc Belegnummer                       bei Splitbuchung nicht erhöhen        nur bei Sortorder LaufendeNr
               if OnlyDigits(ediBelegnummer.Text) and (labImportMode.Color = clSkyBlue) and (rgSort.ItemIndex = 0)
                 then ediBelegnummer.Text := inttostr(strtoint(ediBelegnummer.Text)+1);
             end;
  end;
  {$ifdef DebugCallStack} myDebugLN('btnSpeichernClick finish'); {$endif}
end;

procedure TfrmJournal.cbBuchungstextExit(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('cbBuchungstextExit'); {$endif}
  CheckSettingsForSave;
  {$ifdef DebugCallStack} myDebugLN('cbBuchungstextExit finish'); {$endif}
end;

procedure TfrmJournal.GetNextImportRec;

var
  aModus: TMode;

begin
  {$ifdef DebugCallStack} myDebugLN('GetNextImportRec'); {$endif}
  aModus := Modus;
  labImportMode.Caption := 'Zu importierende Daten';
  labImportMode.Color   := clSkyBlue; // hebt die Splitbucheung auf

  //Nächster Datensatz
  if frmJournal_CSV_Import.Richtung = 0
    then //Von unten
      begin
        dec(CSVImportRow);
        if CSVImportRow < frmJournal_CSV_Import.RowStart then aModus := browse;
      end
    else
      begin
        inc(CSVImportRow);
        if CSVImportRow > frmJournal_CSV_Import.RowEnde  then aModus := browse;
      end;
  if aModus = import
    then
      begin
        btnSkip.Enabled := true;
        GetImportRec;
      end
    else
      begin
        ShowMessage('Alle Daten importiert');
        bStartFinished := false;
        frmDM.ZQueryJournal.Refresh;
        frmDM.ZQueryJournal.Last;
        bStartFinished := true;
        SetMode(aModus);
      end;
  {$ifdef DebugCallStack} myDebugLN('GetNextImportRec finish'); {$endif}
end;

procedure TfrmJournal.cbKontoChange(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('cbKontoChange'); {$endif}
  if bStartFinished
    then
      begin
        ediBankNr.Text := inttostr(integer(cbKonto.Items.Objects[cbKonto.ItemIndex]));
        CheckSettingsForSave;
      end;
  {$ifdef DebugCallStack} myDebugLN('cbKontoChange finished'); {$endif}
end;

procedure TfrmJournal.cbPersonennameChange(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('cbPersonennameChange'); {$endif}
  if bStartFinished
    then
      begin
        ediPersonenID.Text := inttostr(integer(cbPersonenname.Items.Objects[cbPersonenname.ItemIndex]));
        CheckSettingsForSave;
      end;
  {$ifdef DebugCallStack} myDebugLN('cbPersonennameChange finished'); {$endif}
end;

procedure TfrmJournal.cbSachkontoChange(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('cbSachkontoChange'); {$endif}
  if bStartFinished
    then
      begin
        ediSachKontoNummer.Text := inttostr(integer(cbSachkonto.Items.Objects[cbSachkonto.ItemIndex]));
        CheckSettingsForSave;
      end;
   {$ifdef DebugCallStack} myDebugLN('cbSachkontoChange finished'); {$endif}
end;

procedure TfrmJournal.TimCheckSettingsForSaveTimer(Sender: TObject);
begin
  TimCheckSettingsForSave.Enabled := false;
  CheckSettingsForSave2;
end;

procedure TfrmJournal.DateEditBuchungsdatumExit(Sender: TObject);

begin
  {$ifdef DebugCallStack} myDebugLN('DateEditBuchungsdatumExit'); {$endif}
  if bStartFinished
    then
      begin
        //Eingabe von 14-3-11 erlauben --> 14.3.11
        //Eingabe von 14-3    erlauben --> 14.3.(aktuelles Jahr)
        //Eingabe von 14/3/11 erlauben --> 14.3.11
        //Eingabe von 14/3    erlauben --> 14.3.(aktuelles Jahr)
        //Eingabe von 14,3,11 erlauben --> 14.3.11
        //Eingabe von 14,3    erlauben --> 14.3.(aktuelles Jahr)
        DateEditBuchungsdatum.Text := ReplaceChars(DateEditBuchungsdatum.Text, ['-', '/', ','], '.');
        DateEditBuchungsdatum.Text := DateToStr(DateEditBuchungsdatum.Date);

        case Modus of
          append_TakeOver,
          append_Empty,
          edit,
          import   : begin
                       if year(DateEditBuchungsdatum.Text) <> inttostr(nBuchungsjahr)
                         then DateEditBuchungsdatum.Color := $8080FF
                         else DateEditBuchungsdatum.Color := clDefault;
                       CheckSettingsForSave;
                     end;
        end;
      end;
  {$ifdef DebugCallStack} myDebugLN('DateEditBuchungsdatumExit finished'); {$endif}
end;

procedure TfrmJournal.DateEditBuchungsdatumKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {$ifdef DebugCallStack} myDebugLN('DateEditBuchungsdatumKeyDown'); {$endif}
  Case Key of
    VK_UP     : DateEditBuchungsdatum.date := IncDay(DateEditBuchungsdatum.date, 1);
    VK_DOWN   : DateEditBuchungsdatum.date := IncDay(DateEditBuchungsdatum.date, -1);
    VK_RETURN : DateEditBuchungsdatumExit(self);
  end;
  if bStartFinished and (Key in [VK_UP, VK_DOWN, VK_RETURN])
    then CheckSettingsForSave;
  {$ifdef DebugCallStack} myDebugLN('DateEditBuchungsdatumKeyDown finished'); {$endif}
end;

procedure TfrmJournal.DBGridJournalColumnSized(Sender: TObject);
begin
  Col0Width := DBGridJournal.Columns.Items[0].Width;
  Col1Width := DBGridJournal.Columns.Items[1].Width;
  Col2Width := DBGridJournal.Columns.Items[2].Width;
  Col3Width := DBGridJournal.Columns.Items[3].Width;
  Col4Width := DBGridJournal.Columns.Items[4].Width;
  Col5Width := DBGridJournal.Columns.Items[5].Width;
  Col6Width := DBGridJournal.Columns.Items[6].Width;
  Col7Width := DBGridJournal.Columns.Items[7].Width;
  Col8Width := DBGridJournal.Columns.Items[8].Width;
end;

procedure TfrmJournal.DBGridJournalDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.FieldName = 'Betrag'
    then
      begin
        //den, vom System gezeichneten, Inhalt löschen
        DBGridJournal.Canvas.FillRect(Rect);
        //eigenen Text reinschreiben
        DBGridJournal.Canvas.TextRect(Rect,Rect.Left+4,Rect.Top+2, Format('%m',[Column.Field.AsLongint/100]));
      end;
end;

procedure TfrmJournal.ediBankNrExit(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('ediBankNrExit'); {$endif}
  if bStartFinished
    then
      begin
        if frmDM.ZQueryBanken.Locate('KontoNr', ediBankNr.Text, [])
          then
            begin
              cbKonto.Text := frmDM.ZQueryBanken.FieldByName('Name').AsString;
            end
          else
            begin
              cbKonto.ItemIndex := 0;
            end;
        cbKonto.Hint := cbKonto.Text;
        CheckSettingsForSave;
      end;
  {$ifdef DebugCallStack} myDebugLN('ediBankNrExit finished'); {$endif}
end;

procedure TfrmJournal.ediBelegnummerExit(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('ediBelegnummerExit'); {$endif}
  CheckSettingsForSave;
  {$ifdef DebugCallStack} myDebugLN('ediBelegnummerExit finished'); {$endif}
end;

procedure TfrmJournal.ediBetragExit(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('ediBetragExit'); {$endif}
  if bStartFinished
    then
      begin
        ediBetrag.Text:=IntToCurrency(CurrencyToInt(ediBetrag.Text, bEuroModus)); //Richtig auf 2 Dezimalstellen formatieren
        CheckSettingsForSave;
      end;
  {$ifdef DebugCallStack} myDebugLN('ediBetragExit finished'); {$endif}
end;

procedure TfrmJournal.ediBuchungsjahrChange(Sender: TObject);

var
  aModus : TMode;
  
begin
  {$ifdef DebugCallStack} myDebugLN('ediBuchungsjahrChange'); {$endif}
  if bStartFinished and ediBuchungsjahr.Enabled
    then
      begin
        FilterClear;
        frmDM.ZQueryJournal.Close;
        frmDM.ZQueryJournal.SQL.Text := Format(sSelectJournal, [inttostr(ediBuchungsjahr.Value)]) + GetSortOrder;
        frmDM.ZQueryJournal.Open;
        frmDM.ZQueryJournal.Last;
        if nBuchungsjahr = ediBuchungsjahr.Value
          then aModus := browse
          else aModus := readonly;
        SetMode(aModus);  //Ruft dann SetFormular auf
      end;
  {$ifdef DebugCallStack} myDebugLN('ediBuchungsjahrChange finished'); {$endif}
end;

procedure TfrmJournal.ediPersonenIDExit(Sender: TObject);

begin
  {$ifdef DebugCallStack} myDebugLN('ediPersonenIDExit'); {$endif}
  if bStartFinished
    then
      begin
        if trim(ediPersonenID.Text) = '' then ediPersonenID.Text := '0';
        if ediPersonenID.Text <> '0'
          then
            begin
              frmDM.ZQueryPersonen.Refresh;
              if frmDM.ZQueryPersonen.Locate('PersonenID', ediPersonenID.Text, [])
                then
                  begin
                    cbPersonenname.Text:= frmDM.ZQueryPersonen.FieldByName('Nachname').AsString+', '+frmDM.ZQueryPersonen.FieldByName('Vorname').AsString;
                  end
                else
                  begin
                    cbPersonenname.ItemIndex := 0;
                  end;
            end
          else
            begin
              cbPersonenname.ItemIndex := 0;
            end;
        cbPersonenname.Hint := cbPersonenname.Text;
      end;
  {$ifdef DebugCallStack} myDebugLN('ediPersonenIDExit finished'); {$endif}
end;

procedure TfrmJournal.ediSachKontoNummerExit(Sender: TObject);
begin
  {$ifdef DebugCallStack} myDebugLN('ediSachKontoNummerExit'); {$endif}
  if bStartFinished
    then
      begin
        if frmDM.ZQuerySachkonten.Locate('KontoNr', ediSachKontoNummer.Text, [])
          then
            begin
              cbSachkonto.ItemIndex := cbSachkonto.Items.IndexOf(frmDM.ZQuerySachkonten.FieldByName('Kontotype').AsString+' '+
                                                                 frmDM.ZQuerySachkonten.FieldByName('KontoNr').AsString+' '+
                                                                 frmDM.ZQuerySachkonten.FieldByName('Name').AsString);
            end
          else
            begin
              cbSachkonto.ItemIndex := 0;
            end;
        cbSachkonto.Hint := cbSachkonto.Text;
        CheckSettingsForSave;
      end;
  {$ifdef DebugCallStack} myDebugLN('ediSachKontoNummerExit finished'); {$endif}
end;

procedure TfrmJournal.ediFilterExit(Sender: TObject);

var
  sFilter : String;

begin
  sFilter := '';
  if ediSachKontoNummerFilter.Text <> '' then sFilter := sFilter + ' and Konto_nach = '        + ediSachKontoNummerFilter.Text+ ' ';
  if ediBankNummerFilter.Text      <> '' then sFilter := sFilter + ' and BankNr = '             + ediBankNummerFilter.Text+ ' ';
  if ediPersonenNummerFilter.Text  <> '' then sFilter := sFilter + ' and journal.PersonenID = ' + ediPersonenNummerFilter.Text+ ' ';
  if ediTextFilter.Text            <> '' then sFilter := sFilter + ' and ((Buchungstext like ''%'+ediTextFilter.Text+'%'') or '+
                                                                         '(Belegnummer  like ''%'+ediTextFilter.Text+'%'') or '+
                                                                         '(Bemerkung    like ''%'+ediTextFilter.Text+'%'') or '+
                                                                         '(Name         like ''%'+ediTextFilter.Text+'%'')) ';

  frmDM.ZQueryJournal.Close;
  frmDM.ZQueryJournal.SQL.Text := Format(sSelectJournal, [inttostr(ediBuchungsjahr.Value)+sFilter]) + GetSortOrder;
  try
    frmDM.ZQueryJournal.Open;
  except
    sFilter                       := '';
    ediSachKontoNummerFilter.Text := '';
    ediBankNummerFilter.Text      := '';
    ediPersonenNummerFilter.Text  := '';
    ediTextFilter.Text            := '';
    Showmessage('Fehler beim Öffnen der Datenbank'+#13+frmDM.ZQueryJournal.SQL.Text);
    frmDM.ZQueryJournal.SQL.Text := Format(sSelectJournal, [inttostr(ediBuchungsjahr.Value)]) + GetSortOrder;
    frmDM.ZQueryJournal.Open;
  end;
  frmDM.ZQueryJournal.Last;
  if sFilter = ''
    then
      begin
        SetMode(browse);
        labFilter.Visible:=false;
      end
    else
      begin
        SetMode(filtered);
        labFilter.Visible:=true;
      end;
end;

procedure TfrmJournal.FilterPopUp(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  FilterClear;
  Handled := true;
end;

procedure TfrmJournal.FilterClear;
begin
  ediSachKontoNummerFilter.Text := '';
  ediBankNummerFilter.Text      := '';
  ediPersonenNummerFilter.Text  := '';
  ediTextFilter.Text            := '';
  ediFilterExit(self);
end;

procedure TfrmJournal.FormClose(Sender: TObject; var CloseAction: TCloseAction);

begin
  {$ifdef DebugCallStack} myDebugLN('FormClose'); {$endif}

  help.WriteIniInt(sIniFile, 'Journal', 'Col0Width'   , DBGridJournal.Columns.Items[0].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col1Width'   , DBGridJournal.Columns.Items[1].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col2Width'   , DBGridJournal.Columns.Items[2].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col3Width'   , DBGridJournal.Columns.Items[3].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col4Width'   , DBGridJournal.Columns.Items[4].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col5Width'   , DBGridJournal.Columns.Items[5].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col6Width'   , DBGridJournal.Columns.Items[6].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col7Width'   , DBGridJournal.Columns.Items[7].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Col8Width'   , DBGridJournal.Columns.Items[8].Width);
  help.WriteIniInt(sIniFile, 'Journal', 'Winleft'     , self.Left);
  help.WriteIniInt(sIniFile, 'Journal', 'WinTop'      , self.Top);
  help.WriteIniInt(sIniFile, 'Journal', 'WinWidth'    , self.Width);
  help.WriteIniInt(sIniFile, 'Journal', 'WinHeight'   , self.Height);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol0Width', sgImportData.ColWidths[0]);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol1Width', sgImportData.ColWidths[1]);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol2Width', sgImportData.ColWidths[2]);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol3Width', sgImportData.ColWidths[3]);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol4Width', sgImportData.ColWidths[4]);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol5Width', sgImportData.ColWidths[5]);
  help.WriteIniInt(sIniFile, 'Journal', 'ImpCol6Width', sgImportData.ColWidths[6]);

  frmDM.ZQueryJournal.Close;
  frmDM.ZQueryBanken.Close;
  frmDM.ZQueryPersonen.Close;
  frmDM.ZQuerySachkonten.Close;
  if frmDM.ZQueryHelp.Active then frmDM.ZQueryHelp.Close;
  bStartFinished := false;

  if cbCSVAutomatik.Checked
    then help.WriteIniVal(sJournalCSVImportINI, 'Daten', 'Automatik', '1')
    else help.WriteIniVal(sJournalCSVImportINI, 'Daten', 'Automatik', '0');
end;

procedure TfrmJournal.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := Modus in [readonly, browse, filtered];
end;

procedure TfrmJournal.FormCreate(Sender: TObject);

begin
  {$ifdef DebugCallStack} myDebugLN('FormCreate'); {$endif}
  bStartFinished     := false;
  slBankenStartSaldo := TStringList.Create;
  slSuchTexteImport  := TStringList.Create;
  {$ifdef DebugCallStack} myDebugLN('FormCreate finished'); {$endif}
end;


procedure TfrmJournal.FormKeyPress(Sender: TObject; var Key: char);
begin
  {$ifdef DebugCallStack} myDebugLN('FormKeyPress'); {$endif}
  if (key = #13) and not (activeControl is TButton)
    then
      begin
        key := #0;
        SelectNext(activeControl, True, True);
      end;
  {$ifdef DebugCallStack} myDebugLN('FormKeyPress End'); {$endif}
end;

procedure TfrmJournal.FormShow(Sender: TObject);

begin
  {$ifdef DebugCallStack} myDebugLN('FormShow'); {$endif}

  Col0Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col0Width'   ,  50);
  Col1Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col1Width'   , 100);
  Col2Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col2Width'   ,  70);
  Col3Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col3Width'   ,  50);
  Col4Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col4Width'   ,  70);
  Col5Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col5Width'   ,  70);
  Col6Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col6Width'   ,  80);
  Col7Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col7Width'   , 280);
  Col8Width    := help.ReadIniInt(sIniFile, 'Journal', 'Col8Width'   , 280);
  Winleft      := help.ReadIniInt(sIniFile, 'Journal', 'Winleft'     , self.Left);
  WinTop       := help.ReadIniInt(sIniFile, 'Journal', 'WinTop'      , self.Top);
  WinWidth     := help.ReadIniInt(sIniFile, 'Journal', 'WinWidth'    , self.Width);
  WinHeight    := help.ReadIniInt(sIniFile, 'Journal', 'WinHeight'   , self.Height);
  ImpCol0Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol0Width',  40);
  ImpCol1Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol1Width',  70);
  ImpCol2Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol2Width', 230);
  ImpCol3Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol3Width',  70);
  ImpCol4Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol4Width',  75);
  ImpCol5Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol5Width', 230);
  ImpCol6Width := help.ReadIniInt(sIniFile, 'Journal', 'ImpCol6Width', 230);

  if (Winleft < VirtualScreenSize.Left) or (Winleft > (VirtualScreenSize.Left + VirtualScreenSize.Right)) then Winleft := 0;
  if (WinTop < VirtualScreenSize.Top) or (WinTop > (VirtualScreenSize.Top + VirtualScreenSize.Bottom)) then WinTop := 0;

  self.Left    := Winleft;
  self.Top     := WinTop;
  self.Width   := WinWidth;
  self.Height  := WinHeight;

  sgImportData.Cells[ImpColZeile  ,0] := 'Zeile';
  sgImportData.Cells[ImpColDatum  ,0] := 'Datum';
  sgImportData.Cells[ImpColBuTxt  ,0] := 'Buchungstext';
  sgImportData.Cells[ImpColBetrag ,0] := 'Betrag';
  sgImportData.Cells[ImpColSoll_H ,0] := 'Soll / Haben';
  sgImportData.Cells[ImpColKeySK  ,0] := 'Schlüsselfeld SK';
  sgImportData.Cells[ImpColKeyPers,0] := 'Schlüsselfeld Pers';
  sgImportData.ColWidths[0] := ImpCol0Width;
  sgImportData.ColWidths[1] := ImpCol1Width;
  sgImportData.ColWidths[2] := ImpCol2Width;
  sgImportData.ColWidths[3] := ImpCol3Width;
  sgImportData.ColWidths[4] := ImpCol4Width;
  sgImportData.ColWidths[5] := ImpCol5Width;
  sgImportData.ColWidths[6] := ImpCol6Width;

  ediBuchungsjahr.Value    := nBuchungsjahr;
  ediBuchungsjahr.MaxValue := nBuchungsjahr;

  frmDM.ZQueryHelp.SQL.Text := 'select min(buchungsjahr) as minBJ from Journal';
  frmDM.ZQueryHelp.Open;
  try
    ediBuchungsjahr.MinValue := frmDM.ZQueryHelp.FieldByName('minBJ').asinteger;
  Except
    ediBuchungsjahr.MinValue := ediBuchungsjahr.MaxValue;
  end;
  frmDM.ZQueryHelp.Close;

  //Sachkonten
  ediSachKontoNummer.Text := '';
  cbSachkonto.Items.Clear;
  cbSachkonto.AddItem('', TObject(0));    //Leeres Sachkonto
  frmDM.ZQuerySachkonten.First;
  while not frmDM.ZQuerySachkonten.EOF do
    begin
      cbSachkonto.AddItem(frmDM.ZQuerySachkonten.FieldByName('Kontotype').AsString+' '+
                          frmDM.ZQuerySachkonten.FieldByName('KontoNr').AsString+' '+
                          frmDM.ZQuerySachkonten.FieldByName('Name').AsString,
                          TObject(frmDM.ZQuerySachkonten.FieldByName('KontoNr').AsInteger));
      frmDM.ZQuerySachkonten.Next;
    end;
  cbSachkonto.ItemIndex:=0;

  try
    slSuchTexteImport.LoadFromFile(sAppDir+'module\SuchTexteImport.txt');
  except
    on E: Exception do LogAndShowError(E.Message);
  end;

  //Personen
  ediPersonenID.Text:='0';
  cbPersonenname.Items.Clear;
  cbPersonenname.AddItem('', TObject(0));    //Leere Person
  frmDM.ZQueryPersonen.First;
  while not frmDM.ZQueryPersonen.EOF do
    begin
      cbPersonenname.AddItem(frmDM.ZQueryPersonen.FieldByName('Nachname').AsString+', '+
                             frmDM.ZQueryPersonen.FieldByName('Vorname').AsString,
                             TObject(frmDM.ZQueryPersonen.FieldByName('PersonenID').AsInteger));
      frmDM.ZQueryPersonen.Next;
    end;
  cbPersonenname.ItemIndex := 0;
  cbPersonenname.Hint      := cbPersonenname.Text;

  //Banken
  ediBankNr.Text:='';
  cbKonto.Items.Clear;
  slBankenStartSaldo.Clear;
  cbKonto.AddItem('', TObject(0));    //Leere Bank
  slBankenStartSaldo.Add('0');
  frmDM.ZQueryBanken.First;
  while not frmDM.ZQueryBanken.EOF do
    begin
      cbKonto.AddItem(frmDM.ZQueryBanken.FieldByName('Name').AsString,
                      TObject(frmDM.ZQueryBanken.FieldByName('KontoNr').AsInteger));
      slBankenStartSaldo.Add(frmDM.ZQueryBanken.FieldByName('Anfangssaldo').AsString);
      frmDM.ZQueryBanken.Next;
    end;
  cbKonto.ItemIndex := 0;
  cbKonto.Hint      := cbKonto.Text;

  cbCSVAutomatik.Checked := ('1' = help.ReadIniVal(sJournalCSVImportINI, 'Daten','Automatik', '0', true));

  ediSachKontoNummerFilter.Text := '';
  ediPersonenNummerFilter.Text  := '';
  ediBankNummerFilter.Text      := '';
  ediTextFilter.Text            := '';
  labFilter.Visible             := false;

  frmDM.ZQueryJournal.Last;
  bStartFinished := true;
  SetMode(browse);
  {$ifdef DebugCallStack} myDebugLN('FormShowFinished'); {$endif}
end;

procedure TfrmJournal.mnuBankenlisteClick(Sender: TObject);
begin
  ZeigeListe('select * from konten where kontotype = "B" order by Sortpos');
end;

procedure TfrmJournal.mnuBankenliste_NrClick(Sender: TObject);
begin
  ZeigeListe('select * from konten where kontotype = "B" order by KontoNr');
end;

procedure TfrmJournal.mnuInternBankClick(Sender: TObject);
begin
  ZeigeListe(frmDM.ZQueryBanken.SQL.Text);
end;

procedure TfrmJournal.mnuKorrDatumClick(Sender: TObject);

Var YY,MM,DD : Word;

begin
  if year(DateEditBuchungsdatum.Text) <> inttostr(nBuchungsjahr)
    then
      begin
        DecodeDate(DateEditBuchungsdatum.Date,YY,MM,DD);
        DateEditBuchungsdatum.Date := encodedate(nBuchungsjahr,MM,DD);
        DateEditBuchungsdatumExit(Sender);
      end;
end;

procedure TfrmJournal.mnuSachkontenlisteClick(Sender: TObject);
begin
  ZeigeListe('select * from konten where kontotype <> "B" order by Sortpos');
end;

procedure TfrmJournal.ZeigeListe(SQL: String);
begin
  frmDM.ZQueryHelp.SQL.Text := SQL;
  frmDM.ZQueryHelp.Open;
  frmListe.Showmodal;
  frmDM.ZQueryHelp.Close;
end;

procedure TfrmJournal.mnuShowPersonenIDClick(Sender: TObject);
begin
  ZeigeListe('select PersonenID, Nachname, Vorname, Ort, Strasse from Personen order by PersonenID');
end;

procedure TfrmJournal.mnuShowPersonenNameClick(Sender: TObject);
begin
  ZeigeListe('select PersonenID, Nachname, Vorname, Ort, Strasse from Personen order by Nachname COLLATE NOCASE, Vorname COLLATE NOCASE, Ort COLLATE NOCASE, Strasse COLLATE NOCASE');
end;

procedure TfrmJournal.rgSortClick(Sender: TObject);
begin
  if self.Visible then ediFilterExit(Sender);
end;


end.

