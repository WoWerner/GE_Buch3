unit drucken;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  FileUtil,
  DateTimePicker,
  LR_Class,
  LR_DBSet,
  LR_Desgn,
  LR_E_HTM,
  LR_E_CSV,
  LR_E_TXT,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  types;

type
  TDruckmode  = (none,
                 Journal,
                 JournalBK,
                 JournalSK,
                 JournalGefiltert,
                 JournalKompaktGefiltert,
                 Summenliste,
                 EinAus,
                 Personenliste,
                 PersonenlisteKompakt,
                 Jahresabschluss,
                 Sachkontenliste,
                 Bankenliste,
                 BeitragslisteSK,
                 Zahlungsliste,
                 Zuwendung);
  TColType    = (header,
                 blank,
                 footer,
                 line);
  T2ColReport =  record
    Name : string;
    Col1 : string;
    Col2 : String;
    typ  : TColType;
  end;

  { TfrmDrucken }

  TfrmDrucken = class(TForm)
    btnJournalBKdruck: TButton;
    btnJournalSKdruck: TButton;
    btnJournalFiltered: TButton;
    btnJournalKompaktFiltered: TButton;
    btnEinAus: TButton;
    btnZahlerliste: TButton;
    btnPersonenlisteKompakt: TButton;
    btnSachkontenliste: TButton;
    btnJournaldruck: TButton;
    btnBankenliste: TButton;
    btnSummenliste: TButton;
    btnSchliessen: TButton;
    btnPersonenliste: TButton;
    btnJahresabschluss: TButton;
    btnBeitragsliste: TButton;
    btnDurchgang: TButton;
    btnZuwendungsbescheinigungen: TButton;
    cbDatum: TCheckBox;
    DateTimePickerVon: TDateTimePicker;
    DateTimePickerBis: TDateTimePicker;
    frCSVExport: TfrCSVExport;
    frDBDataSet: TfrDBDataSet;
    frDBDataSetDetail: TfrDBDataSet;
    frDBDataSetDetail1: TfrDBDataSet;
    frDesigner: TfrDesigner;
    frHTMExport: TfrHTMExport;
    frReport: TfrReport;
    frTextExport: TfrTextExport;
    Label2: TLabel;
    rgFilter: TRadioGroup;
    ediFilter: TLabeledEdit;
    Shape1: TShape;
    Shape2: TShape;
    procedure btnBankenlisteClick(Sender: TObject);
    procedure btnBankenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnEinAusClick(Sender: TObject);
    procedure btnEinAusContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalBKdruckClick(Sender: TObject);
    procedure btnJournalBKdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalFilteredClick(Sender: TObject);
    procedure btnJournalFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalKompaktFilteredClick(Sender: TObject);
    procedure btnJournalKompaktFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalSKdruckClick(Sender: TObject);
    procedure btnJournalSKdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnZahlerlisteClick(Sender: TObject);
    procedure btnBeitragslisteClick(Sender: TObject);
    procedure btnBeitragslisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnDurchgangClick(Sender: TObject);
    procedure btnJahresabschlussClick(Sender: TObject);
    procedure btnJahresabschlussContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournaldruckClick(Sender: TObject);
    procedure btnJournaldruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnPersonenlisteClick(Sender: TObject);
    procedure btnPersonenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnPersonenlisteKompaktClick(Sender: TObject);
    procedure btnPersonenlisteKompaktContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnSachkontenlisteClick(Sender: TObject);
    procedure btnSachkontenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnSchliessenClick(Sender: TObject);
    procedure btnZahlerlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnZuwendungsbescheinigungenClick(Sender: TObject);
    procedure btnZuwendungsbescheinigungenContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnSummenlisteClick(Sender: TObject);
    procedure btnSummenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure cbDatumChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReportBeginBand(Band: TfrBand);
    procedure frReportBeginDoc;
    procedure frReportBeginPage(pgNo: Integer);
    procedure frReportEnterRect(Memo: TStringList; View: TfrView);
    procedure frReportGetValue(const ParName: String; var ParValue: Variant);
    procedure frReportPrintColumn(ColNo: Integer; var ColWidth: Integer);
    procedure rgFilterSelectionChanged(Sender: TObject);
  private
    { private declarations }
    Druckmode : TDruckmode;
    TwoColReportData : array[1..9999] of T2ColReport;
    FCol      : Integer;
    FRow      : Integer;
    FRowPart1 : Integer;
    nEinnahmen: longint;
    nAusgaben : longint;
    nBestand  : longint;
    Procedure PreparePrint(CallDesigner : boolean);
  public
    { public declarations }
  end;



var
  frmDrucken: TfrmDrucken;

implementation

{$R *.lfm}

{ TfrmDrucken }

uses
  windows,  //Shellexecute
  global,
  LConvEncoding,
  help,
  dm;

Var
  Seite       : integer;

Procedure TfrmDrucken.PreparePrint(CallDesigner : boolean);

var
  sSachkontoNr     : string;
  sLastSachkontoNr : string;
  sName            : string;
  sLastName        : string;
  sHelp            : string;
  Col1Summe        : longint;
  Col2Summe        : longint;
  Col1SummePart1   : longint;
  Col2SummePart1   : longint;
  Col1SummePart2   : longint;
  Col2SummePart2   : longint;
  Col1SummePart3   : longint;
  Col2SummePart3   : longint;
  Col1SummePart3b  : longint;
  Col2SummePart3b  : longint;
  Col1SummePart4   : longint;
  Col2SummePart4   : longint;
  Betrag           : longint;

begin
  try
    case Druckmode of
      Jahresabschluss:
        begin
           nEinnahmen      := 0;
           nAusgaben       := 0;
           nBestand        := 0;
          frReport.LoadFromFile(sAppDir+'module\Jahresabschluss.lrf');
          frReport.Dataset := nil;
        end;
      BeitragslisteSK:
        begin
          FRow             := 0;
          Col1SummePart1   := 0;
          Col2SummePart1   := 0;
          sLastSachkontoNr := '';
          sSachkontoNr     := '';
          sName            := '';
          sLastName        := '';
          sHelp            := '';

          if cbDatum.Checked
            then sHelp := shelp + ' and (journal.Datum >='+SQLiteDateFormat(DateTimePickerVon.Date)+')'+
                                  ' and (journal.Datum <='+SQLiteDateFormat(DateTimePickerBis.Date)+')';

          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\BeitragslisteDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sHelp, [rfReplaceAll]);
          frmDM.ZQueryDrucken.Open;

          while not frmDM.ZQueryDrucken.EOF do
            begin
              //Kontobereich überprüfen
              sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').AsString;
              sName        := frmDM.ZQueryDrucken.FieldByName('Name').AsString;
              Betrag       := frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
              if sSachkontoNr <> sLastSachkontoNr
                then
                  begin
                    if FRow > 0
                      then
                        begin
                          inc(FRow); //Zusammenfassung
                          TwoColReportData[FRow].Name := 'Summe';
                          TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart1);
                          TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart1);
                          TwoColReportData[FRow].typ  := footer;
                          inc(FRow); //Leerzeile
                          TwoColReportData[FRow].Name := '';
                          TwoColReportData[FRow].Col1 := '';
                          TwoColReportData[FRow].Col2 := '';
                          TwoColReportData[FRow].typ  := blank;
                        end;
                    inc(FRow); //Neues Sachkonto, neue Rubrik
                    sLastSachkontoNr            := sSachkontoNr;
                    TwoColReportData[FRow].Name := sSachkontoNr;
                    TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
                    TwoColReportData[FRow].Col2 := inttostr(nBuchungsjahr-1);
                    TwoColReportData[FRow].typ  := header;
                    Col1SummePart1   := 0;
                    Col2SummePart1   := 0;
                    sLastName        := '';
                  end;
              if sName <> sLastName
                then
                  begin
                    inc(FRow); //Neuer Name, neue Zeile
                    sLastName := sName;
                    TwoColReportData[FRow].Name := sName;
                    TwoColReportData[FRow].Col1 := IntToCurrency(0);
                    TwoColReportData[FRow].Col2 := IntToCurrency(0);
                    TwoColReportData[FRow].typ  := line;
                  end;
              if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
                then
                  begin
                    TwoColReportData[FRow].Col1 := IntToCurrency(Betrag);
                    Col1SummePart1 := Col1SummePart1 + Betrag;
                  end
                else
                  begin
                    TwoColReportData[FRow].Col2 := IntToCurrency(Betrag);
                    Col2SummePart1 := Col2SummePart1 + Betrag;
                  end;
              frmDM.ZQueryDrucken.Next;
            end;
            if FRow > 0
              then
                begin
                  inc(FRow); //Zusammenfassung
                  TwoColReportData[FRow].Name := 'Summe';
                  TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart1);
                  TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart1);
                  TwoColReportData[FRow].typ  := header;
                end;
          frmDM.ZQueryDrucken.close;

          if cbDatum.Checked
            then
              begin
                inc(FRow); //Leerzeile
                TwoColReportData[FRow].Name := '';
                TwoColReportData[FRow].Col1 := '';
                TwoColReportData[FRow].Col2 := '';
                TwoColReportData[FRow].typ  := blank;

                inc(FRow);
                TwoColReportData[FRow].Name := 'Filter von '+formatdatetime('dd.mm.yyyy', DateTimePickerVon.Date)+' bis '+formatdatetime('dd.mm.yyyy', DateTimePickerBis.Date);
                TwoColReportData[FRow].Col1 := '';
                TwoColReportData[FRow].Col2 := '';
                TwoColReportData[FRow].typ  := header;
              end;

          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow :=  0;
          FCol :=  0;
          frReport.Dataset := nil;
        end;
      Zahlungsliste:
        begin
          FRow             := 0;
          Col1SummePart1   := 0;
          Col2SummePart1   := 0;
          sLastSachkontoNr := '';
          sSachkontoNr     := '';
          sName            := '';
          sLastName        := '';
          sHelp            := '';

          if cbDatum.Checked
            then sHelp := shelp + ' and (journal.Datum >='+SQLiteDateFormat(DateTimePickerVon.Date)+')'+
                                  ' and (journal.Datum <='+SQLiteDateFormat(DateTimePickerBis.Date)+')';

          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\ZahlerlisteDrucken.sql');
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sHelp, [rfReplaceAll]);
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
          frmDM.ZQueryDrucken.Open;

          while not frmDM.ZQueryDrucken.EOF do
            begin
              //Kontobereich überprüfen
              sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('Sachkonto').AsString;
              sName        := frmDM.ZQueryDrucken.FieldByName('Name').AsString;
              Betrag       := frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
              if sName <> sLastName
                then
                  begin
                    if FRow > 0
                      then
                        begin
                          inc(FRow); //Zusammenfassung
                          TwoColReportData[FRow].Name := 'Summe';
                          TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart1);
                          TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart1);
                          TwoColReportData[FRow].typ  := footer;
                          inc(FRow); //Leerzeile
                          TwoColReportData[FRow].Name := '';
                          TwoColReportData[FRow].Col1 := '';
                          TwoColReportData[FRow].Col2 := '';
                          TwoColReportData[FRow].typ  := blank;
                        end;
                    inc(FRow); //Neues Sachkonto, neue Rubrik
                    sLastName                   := sName;
                    TwoColReportData[FRow].Name := sName;
                    TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
                    TwoColReportData[FRow].Col2 := inttostr(nBuchungsjahr-1);
                    TwoColReportData[FRow].typ  := header;
                    Col1SummePart1   := 0;
                    Col2SummePart1   := 0;
                    sLastSachkontoNr := '';
                  end;
              if sSachkontoNr <> sLastSachkontoNr
                then
                  begin
                    inc(FRow); //Neuer Name, neue Zeile
                    sLastSachkontoNr            := sSachkontoNr;
                    TwoColReportData[FRow].Name := sSachkontoNr;
                    TwoColReportData[FRow].Col1 := IntToCurrency(0);
                    TwoColReportData[FRow].Col2 := IntToCurrency(0);
                    TwoColReportData[FRow].typ  := line;
                  end;
              if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
                then
                  begin
                    TwoColReportData[FRow].Col1 := IntToCurrency(Betrag);
                    Col1SummePart1 := Col1SummePart1 + Betrag;
                  end
                else
                  begin
                    TwoColReportData[FRow].Col2 := IntToCurrency(Betrag);
                    Col2SummePart1 := Col2SummePart1 + Betrag;
                  end;
              frmDM.ZQueryDrucken.Next;
            end;
            if FRow > 0
              then
                begin
                  inc(FRow); //Zusammenfassung
                  TwoColReportData[FRow].Name := 'Summe';
                  TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart1);
                  TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart1);
                  TwoColReportData[FRow].typ  := header;
                end;
          frmDM.ZQueryDrucken.close;

          if cbDatum.Checked
            then
              begin
                inc(FRow); //Leerzeile
                TwoColReportData[FRow].Name := '';
                TwoColReportData[FRow].Col1 := '';
                TwoColReportData[FRow].Col2 := '';
                TwoColReportData[FRow].typ  := blank;

                inc(FRow);
                TwoColReportData[FRow].Name := 'Filter von '+formatdatetime('dd.mm.yyyy', DateTimePickerVon.Date)+' bis '+formatdatetime('dd.mm.yyyy', DateTimePickerBis.Date);
                TwoColReportData[FRow].Col1 := '';
                TwoColReportData[FRow].Col2 := '';
                TwoColReportData[FRow].typ  := header;
              end;

          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow      := 0;
          FCol      := 0;
          frReport.Dataset := nil;
        end;
      Zuwendung:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\ZuwendungDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);

          frmDM.ZQueryDruckenDetail.SQL.LoadFromFile(sAppDir+'module\ZuwendungDruckenDetail.sql');
          frmDM.ZQueryDruckenDetail.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);
          frmDM.ZQueryDruckenDetail.MasterFields := 'PersonenID';
          frmDM.ZQueryDruckenDetail.LinkedFields := 'PersonenID';

          frmDM.ZQueryDruckenDetail1.SQL.LoadFromFile(sAppDir+'module\ZuwendungDruckenDetail1.sql');
          frmDM.ZQueryDruckenDetail1.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);
          frmDM.ZQueryDruckenDetail1.MasterFields := 'PersonenID';
          frmDM.ZQueryDruckenDetail1.LinkedFields := 'PersonenID';

          frReport.LoadFromFile(sAppDir+'module\ZuwendungDrucken.lrf');
          frmDM.ZQueryDrucken.Open;
          frmDM.ZQueryDruckenDetail.Open;
          frmDM.ZQueryDruckenDetail1.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Bankenliste:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\BankenDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);
          frReport.LoadFromFile(sAppDir+'module\BankenDrucken.lrf');
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Sachkontenliste:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SachkontenlisteDrucken.sql');
          frReport.LoadFromFile(sAppDir+'module\SachkontenlisteDrucken.lrf');
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Personenliste,
      PersonenlisteKompakt:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\PersonenDrucken.sql');
          case Druckmode of
            Personenliste       : frReport.LoadFromFile(sAppDir+'module\PersonenDrucken.lrf');
            PersonenlisteKompakt: frReport.LoadFromFile(sAppDir+'module\PersonenDruckenKompakt.lrf');
          end;
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      JournalBK:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\BankenDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);

          frmDM.ZQueryDruckenDetail.SQL.LoadFromFile(sAppDir+'module\JournalDrucken.sql');
          frmDM.ZQueryDruckenDetail.SQL.Text := StringReplace(frmDM.ZQueryDruckenDetail.SQL.Text, ':AddWhere', '', [rfReplaceAll]);
          frmDM.ZQueryDruckenDetail.ParamByName('BJAHR').AsString := inttostr(nBuchungsjahr);

          frmDM.ZQueryDruckenDetail.MasterFields := 'BankNr';
          frmDM.ZQueryDruckenDetail.LinkedFields := 'BankNr';

          frReport.LoadFromFile(sAppDir+'module\JournalDruckenBK.lrf');
          frmDM.ZQueryDrucken.Open;
          frmDM.ZQueryDruckenDetail.Open;
          frReport.Dataset := frDBDataSet;
        end;
      JournalSK:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\JournalDruckenSK.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);

          frmDM.ZQueryDruckenDetail.SQL.LoadFromFile(sAppDir+'module\JournalDrucken.sql');
          frmDM.ZQueryDruckenDetail.SQL.Text := StringReplace(frmDM.ZQueryDruckenDetail.SQL.Text, ':AddWhere', '', [rfReplaceAll]);
          frmDM.ZQueryDruckenDetail.ParamByName('BJAHR').AsString := inttostr(nBuchungsjahr);

          frmDM.ZQueryDruckenDetail.MasterFields := 'konto_nach';
          frmDM.ZQueryDruckenDetail.LinkedFields := 'konto_nach';

          frReport.LoadFromFile(sAppDir+'module\JournalDruckenSK.lrf');
          frmDM.ZQueryDrucken.Open;
          frmDM.ZQueryDruckenDetail.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Journal,
      JournalGefiltert,
      JournalKompaktGefiltert:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\JournalDrucken.sql');

          if Druckmode = Journal
            then
              begin
                rgFilter.ItemIndex := 0;
                cbDatum.Checked    := false;
                sHelp := '';
              end
            else
              begin
                case rgFilter.ItemIndex of
                  0: sHelp := '';
                  1: sHelp := 'and (journal.BankNr ='+ediFilter.Text+')';
                  2: sHelp := 'and (journal.Konto_nach ='+ediFilter.Text+')';
                  3: sHelp := 'and (journal.PersonenID ='+ediFilter.Text+')';
                  4: sHelp := 'and (journal.bemerkung like ''%'+ediFilter.Text+'%'')';
                end;

                if cbDatum.Checked
                  then sHelp := shelp + ' and (journal.Datum >='+SQLiteDateFormat(DateTimePickerVon.Date)+')'+
                                        ' and (journal.Datum <='+SQLiteDateFormat(DateTimePickerBis.Date)+')';
              end;


          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sHelp, [rfReplaceAll]);
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(nBuchungsjahr);

          case Druckmode of
            Journal                 : frReport.LoadFromFile(sAppDir+'module\JournalDrucken.lrf');
            JournalGefiltert        : frReport.LoadFromFile(sAppDir+'module\JournalDruckenBemerkung.lrf');
            JournalKompaktGefiltert : frReport.LoadFromFile(sAppDir+'module\JournalDruckenKompakt.lrf');
          end;
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Summenliste,
      EinAus:
        begin
          FRowPart1        := 0;
          FRow             := 1;
          Col1SummePart1   := 0;
          Col2SummePart1   := 0;
          Col1SummePart2   := 0;
          Col2SummePart2   := 0;
          Col1SummePart3   := 0;
          Col2SummePart3   := 0;
          Col1SummePart3b  := 0;
          Col2SummePart3b  := 0;
          Col1SummePart4   := 0;
          Col2SummePart4   := 0;
          Col1Summe        := 0;
          Col2Summe        := 0;
          sLastSachkontoNr := '';
          sSachkontoNr     := '';

          if Druckmode = Summenliste then rgFilter.ItemIndex := 0;

          case rgFilter.ItemIndex of
            0: sHelp := '';
            1: sHelp := 'and (journal.BankNr ='+ediFilter.Text+')';
            2: sHelp := 'and (journal.konto_nach ='+ediFilter.Text+')';
            3: sHelp := 'and (journal.PersonenID ='+ediFilter.Text+')';
            4: sHelp := 'and (journal.bemerkung like ''%'+ediFilter.Text+'%'')';
          end;

          if cbDatum.Checked
            then sHelp := shelp + ' and (journal.Datum >='+SQLiteDateFormat(DateTimePickerVon.Date)+')'+
                                  ' and (journal.Datum <='+SQLiteDateFormat(DateTimePickerBis.Date)+')';

          //Der "Summenliste" Report enthält 6 Teile.
          //Part 1 Einnahmen
          //Part 2 Ausgaben
          //Part 3 Durchgang Eingang
          //Part 3b Durchgang Ausgang
          //Part 4 Kassenstände
          //Part 5 Ergebnis
          //Part 6 Umbuchungen

          //Der "EinAus" Report enthält 2 Teile.
          //Part 1 Einnahmen
          //Part 2 Ausgaben
          //
          //Die Daten werden über frReportGetValue abgefragt
          //Vorher müssen in frReportBeginDoc die Zeilen und Spalten angegeben werden.
          //Dazu werden die Daten vorher alle aus den Datenbanken gesammelt
          //und zwischengespeichert in TwoColReportData

          //Part 1 Einnahmen
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenJournalEinAus.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
          frmDM.ZQueryDrucken.ParamByName('TYP').AsString    := 'E';
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sHelp, [rfReplaceAll]);
          frmDM.ZQueryDrucken.Open;
            //Überschrift Part 1
          TwoColReportData[FRow].Name := 'Einnahmen';
          TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
          TwoColReportData[FRow].Col2 := inttostr(nBuchungsjahr-1);
          TwoColReportData[FRow].typ  := header;
            //Daten Part 1
          while not frmDM.ZQueryDrucken.EOF do
            begin
              //Kontobereich überprüfen
              sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').AsString;
              if sSachkontoNr <> sLastSachkontoNr
                then
                  begin
                    inc(FRow); //Neues Sachkonto, neue Zeile
                    sLastSachkontoNr            := sSachkontoNr;
                    TwoColReportData[FRow].Name := '('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString;
                    TwoColReportData[FRow].Col1 := IntToCurrency(0);
                    TwoColReportData[FRow].Col2 := IntToCurrency(0);
                    TwoColReportData[FRow].typ  := line;
                  end;
              if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
                then
                  begin
                    TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint);
                    Col1SummePart1 := Col1SummePart1 + frmDM.ZQueryDrucken.FieldByName('Summe').aslongint;
                  end
                else
                  begin
                    TwoColReportData[FRow].Col2 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint);
                    Col2SummePart1 := Col2SummePart1 + frmDM.ZQueryDrucken.FieldByName('Summe').aslongint;
                  end;
              frmDM.ZQueryDrucken.Next;
            end;
            //Abschluss Part 1
          inc(FRow);
          TwoColReportData[FRow].Name := 'Einnahmen gesamt';
          TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart1);
          TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart1);
          TwoColReportData[FRow].typ  := footer;
          frmDM.ZQueryDrucken.Close;
          sLastSachkontoNr := '';

          inc(FRow); //Leerzeile
          TwoColReportData[FRow].Name := '';
          TwoColReportData[FRow].Col1 := '';
          TwoColReportData[FRow].Col2 := '';
          TwoColReportData[FRow].typ  := blank;

          //Part 2 Ausgaben
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenJournalEinAus.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
          frmDM.ZQueryDrucken.ParamByName('TYP').AsString    := 'A';
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sHelp, [rfReplaceAll]);
          frmDM.ZQueryDrucken.Open;
          //Überschrift Part 2
          inc(FRow);
          TwoColReportData[FRow].Name := 'Ausgaben';
          TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
          TwoColReportData[FRow].Col2 := inttostr(nBuchungsjahr-1);
          TwoColReportData[FRow].typ  := header;

          //Daten Part 2
          while not frmDM.ZQueryDrucken.EOF do
            begin
              sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').AsString;
              if sSachkontoNr <> sLastSachkontoNr
                then
                  begin
                    inc(FRow); //Neues Sachkonto, neue Zeile
                    sLastSachkontoNr            := sSachkontoNr;
                    TwoColReportData[FRow].Name := '('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString;
                    TwoColReportData[FRow].Col1 := IntToCurrency(0);
                    TwoColReportData[FRow].Col2 := IntToCurrency(0);
                    TwoColReportData[FRow].typ  := line;
                  end;
              if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
                then
                  begin
                    TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint);
                    Col1SummePart2 := Col1SummePart2 + frmDM.ZQueryDrucken.FieldByName('Summe').aslongint;
                  end
                else
                  begin
                    TwoColReportData[FRow].Col2 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint);
                    Col2SummePart2 := Col2SummePart2 + frmDM.ZQueryDrucken.FieldByName('Summe').aslongint;
                  end;
              frmDM.ZQueryDrucken.Next;
            end;

            //Abschluss Part 2
          inc(FRow);
          TwoColReportData[FRow].Name := 'Ausgaben gesamt';
          TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart2);
          TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart2);
          TwoColReportData[FRow].typ  := footer;
          frmDM.ZQueryDrucken.Close;
          sLastSachkontoNr := '';

          if Druckmode = Summenliste then
            begin
              inc(FRow); //Leerzeile
              TwoColReportData[FRow].Name := '';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := blank;

              //Überschrift Part 3
              inc(FRow);
              TwoColReportData[FRow].Name := 'Durchgang Einzahlungen';
              TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
              TwoColReportData[FRow].Col2 := inttostr(nBuchungsjahr-1);
              TwoColReportData[FRow].typ  := header;

              //Part 3 Durchgang Einzahlungen
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenJournalDurchgang.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', '' + sHelp, [rfReplaceAll]);
              frmDM.ZQueryDrucken.Open;
                //Daten Part 3
              while not frmDM.ZQueryDrucken.EOF do
                begin
                  if frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint > 0
                    then
                      begin
                        sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').AsString;
                        if sSachkontoNr <> sLastSachkontoNr
                          then
                            begin
                              inc(FRow); //Neues Sachkonto, neue Zeile
                              sLastSachkontoNr            := sSachkontoNr;
                              TwoColReportData[FRow].Name := '('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString;
                              TwoColReportData[FRow].Col1 := IntToCurrency(0);
                              TwoColReportData[FRow].Col2 := IntToCurrency(0);
                              TwoColReportData[FRow].typ  := line;
                            end;
                        if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
                          then
                            begin
                              TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint);
                              Col1SummePart3 := Col1SummePart3 + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                            end
                          else
                            begin
                              TwoColReportData[FRow].Col2 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint);
                              Col2SummePart3 := Col2SummePart3 + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                            end;
                      end;
                  frmDM.ZQueryDrucken.Next;
                end;

                //Abschluss Part 3
              inc(FRow);
              TwoColReportData[FRow].Name := 'Durchgang Einzahlungen gesamt';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart3);
              TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart3);
              TwoColReportData[FRow].typ  := footer;
              frmDM.ZQueryDrucken.First;
              sLastSachkontoNr := '';

              inc(FRow); //Leerzeile
              TwoColReportData[FRow].Name := '';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := blank;

              //Part 3b Durchgang Weiterleitungen
              //Überschrift Part 3b
              inc(FRow);
              TwoColReportData[FRow].Name := 'Durchgang Weiterleitungen';
              TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
              TwoColReportData[FRow].Col2 := inttostr(nBuchungsjahr-1);
              TwoColReportData[FRow].typ  := header;

                //Daten Part 3b
              while not frmDM.ZQueryDrucken.EOF do
                begin
                  if frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint < 0
                    then
                      begin
                        sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').AsString;
                        if sSachkontoNr <> sLastSachkontoNr
                          then
                            begin
                              inc(FRow); //Neues Sachkonto, neue Zeile
                              sLastSachkontoNr            := sSachkontoNr;
                              TwoColReportData[FRow].Name := '('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString;
                              TwoColReportData[FRow].Col1 := IntToCurrency(0);
                              TwoColReportData[FRow].Col2 := IntToCurrency(0);
                              TwoColReportData[FRow].typ  := line;
                            end;
                        if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
                          then
                            begin
                              TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint);
                              Col1SummePart3b := Col1SummePart3b + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                            end
                          else
                            begin
                              TwoColReportData[FRow].Col2 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint);
                              Col2SummePart3b := Col2SummePart3b + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                            end;

                      end;
                  frmDM.ZQueryDrucken.Next;
                end;

                //Abschluss Part 3b
              inc(FRow);
              TwoColReportData[FRow].Name := 'Durchgang Weiterleitungen gesamt';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart3b);
              TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart3b);
              TwoColReportData[FRow].typ  := footer;
              frmDM.ZQueryDrucken.Close;
              sLastSachkontoNr := '';

              inc(FRow); //Leerzeile
              TwoColReportData[FRow].Name := '';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := blank;

              //Part 4 Kassenstände
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenBanken.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
              frmDM.ZQueryDrucken.Open;
                //Überschrift Part 4
              inc(FRow);
              TwoColReportData[FRow].Name := 'Kassenstände';
              TwoColReportData[FRow].typ  := header;

              if cbDatum.Checked
                then
                  begin
                    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenBankenUmsatz.sql');
                    frmDM.ZQueryHelp.ParamByName('BJAHR').AsInteger := nBuchungsjahr;
                    frmDM.ZQueryHelp.ParamByName('DAT').AsString    := FormatDateTime('yyyy-mm-dd',DateTimePickerVon.Date-1);
                    frmDM.ZQueryHelp.Open;

                    frmDM.ZQueryHelp1.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenBankenUmsatz.sql');
                    frmDM.ZQueryHelp1.ParamByName('BJAHR').AsInteger := nBuchungsjahr;
                    frmDM.ZQueryHelp1.ParamByName('DAT').AsString    := FormatDateTime('yyyy-mm-dd',DateTimePickerBis.Date);
                    frmDM.ZQueryHelp1.Open;

                    TwoColReportData[FRow].Col1 := DatetoStr(DateTimePickerBis.Date);
                    TwoColReportData[FRow].Col2 := DatetoStr(DateTimePickerVon.Date-1);

                      //Daten Part 4
                    while not frmDM.ZQueryDrucken.EOF do
                      begin
                        inc(FRow);
                        TwoColReportData[FRow].Name := frmDM.ZQueryDrucken.FieldByName('Name').AsString;

                        if frmDM.ZQueryDrucken.FieldByName('KontoNr').AsLongint = frmDM.ZQueryHelp1.FieldByName('BankNr').AsLongint
                          then
                            begin
                              Col1Summe := frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint + frmDM.ZQueryHelp1.FieldByName('Summe').AsLongint;
                              frmDM.ZQueryHelp1.Next;
                            end
                          else
                            begin
                              Col1Summe := frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint;
                            end;
                        if frmDM.ZQueryDrucken.FieldByName('KontoNr').AsLongint = frmDM.ZQueryHelp.FieldByName('BankNr').AsLongint
                          then
                            begin
                              Col2Summe := frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint + frmDM.ZQueryHelp.FieldByName('Summe').AsLongint;
                              frmDM.ZQueryHelp.Next;
                            end
                          else
                            begin
                              Col2Summe := frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint;
                            end;

                        TwoColReportData[FRow].Col1 := IntToCurrency(Col1Summe);
                        TwoColReportData[FRow].Col2 := IntToCurrency(Col2Summe);
                        TwoColReportData[FRow].typ  := line;
                        Col1SummePart4 := Col1SummePart4 + Col1Summe;
                        Col2SummePart4 := Col2SummePart4 + Col2Summe;
                        frmDM.ZQueryDrucken.Next;
                      end;

                    frmDM.ZQueryHelp.close;
                    frmDM.ZQueryHelp1.close;
                  end
                else
                  begin
                    TwoColReportData[FRow].Col1 := inttostr(nBuchungsjahr);
                    TwoColReportData[FRow].Col2 := '31.12.'+inttostr(nBuchungsjahr-1);
                      //Daten Part 4
                    while not frmDM.ZQueryDrucken.EOF do
                      begin
                        inc(FRow);
                        TwoColReportData[FRow].Name := frmDM.ZQueryDrucken.FieldByName('Name').AsString;
                        TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Kontostand').AsLongint);
                        TwoColReportData[FRow].Col2 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint);
                        TwoColReportData[FRow].typ  := line;
                        Col1SummePart4 := Col1SummePart4 + frmDM.ZQueryDrucken.FieldByName('Kontostand').AsLongint;
                        Col2SummePart4 := Col2SummePart4 + frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint;
                        frmDM.ZQueryDrucken.Next;
                      end;
                  end;

              frmDM.ZQueryDrucken.Close;

                //Abschluss Part 4
              inc(FRow);
              TwoColReportData[FRow].Name := 'Summe Kassenstände';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart4);
              TwoColReportData[FRow].Col2 := IntToCurrency(Col2SummePart4);
              TwoColReportData[FRow].typ  := footer;

              inc(FRow); //Leerzeile
              TwoColReportData[FRow].Name := '';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := blank;

              //Part 5 Ergebniss
                //Überschrift Part 5
              inc(FRow);
              TwoColReportData[FRow].Name := 'Ergebnis';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := header;

                //Daten Part 5
              inc(FRow);
              TwoColReportData[FRow].Name := 'Anfangsbestand';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col2SummePart4);
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := line;
              inc(FRow);
              TwoColReportData[FRow].Name := 'Einnahmen';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart1);
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := line;
              inc(FRow);
              TwoColReportData[FRow].Name := 'Ausgaben';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart2);
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := line;
              inc(FRow);
              TwoColReportData[FRow].Name := 'Delta bei Durchgangskonten';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col1SummePart3+Col1SummePart3b);
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := line;

                //Abschluss Part 5
              inc(FRow);
              TwoColReportData[FRow].Name := 'Endbestand';
              TwoColReportData[FRow].Col1 := IntToCurrency(Col2SummePart4+Col1SummePart1+Col1SummePart2+Col1SummePart3+Col1SummePart3b);
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := footer;

              inc(FRow); //Leerzeile
              TwoColReportData[FRow].Name := '';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := blank;

              //Part 6 Umbuchungen
                //Überschrift Part 6
              inc(FRow);
              TwoColReportData[FRow].Name := 'Umbuchungen';
              TwoColReportData[FRow].Col1 := '';
              TwoColReportData[FRow].Col2 := '';
              TwoColReportData[FRow].typ  := header;

              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenUmbuchungen.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sHelp, [rfReplaceAll]);
              frmDM.ZQueryDrucken.Open;
                //Daten Part 6
              while not frmDM.ZQueryDrucken.EOF do
                begin
                  inc(FRow);
                  TwoColReportData[FRow].Name := frmDM.ZQueryDrucken.FieldByName('Name').AsString;
                  TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint);
                  TwoColReportData[FRow].Col2 := '';
                  TwoColReportData[FRow].typ  := line;
                  frmDM.ZQueryDrucken.Next;
                end;
              frmDM.ZQueryDrucken.Close;
            end;

            //Ausgabe der Filter
            case rgFilter.ItemIndex of
              0: sHelp := '';
              1: sHelp := 'BankNr='+ediFilter.Text;
              2: sHelp := 'Konto_nach='+ediFilter.Text;
              3: sHelp := 'PersonenID='+ediFilter.Text;
              4: sHelp := 'Bemerkung enthält '+ediFilter.Text;
            end;
            if sHelp <> ''
              then
                begin
                  inc(FRow); //Leerzeile
                  TwoColReportData[FRow].Name := '';
                  TwoColReportData[FRow].Col1 := '';
                  TwoColReportData[FRow].Col2 := '';
                  TwoColReportData[FRow].typ  := blank;

                  inc(FRow);
                  TwoColReportData[FRow].Name := 'Filter: '+sHelp;
                  TwoColReportData[FRow].Col1 := '';
                  TwoColReportData[FRow].Col2 := '';
                  TwoColReportData[FRow].typ  := header;
                end;

          if cbDatum.Checked
            then
              begin
                if sHelp = ''
                  then
                    begin
                      inc(FRow); //Leerzeile
                      TwoColReportData[FRow].Name := '';
                      TwoColReportData[FRow].Col1 := '';
                      TwoColReportData[FRow].Col2 := '';
                      TwoColReportData[FRow].typ  := blank;
                    end;
                inc(FRow);
                TwoColReportData[FRow].Name := 'Filter von '+formatdatetime('dd.mm.yyyy', DateTimePickerVon.Date)+' bis '+formatdatetime('dd.mm.yyyy', DateTimePickerBis.Date);
                TwoColReportData[FRow].Col1 := '';
                TwoColReportData[FRow].Col2 := '';
                TwoColReportData[FRow].typ  := header;
              end;


          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow := 0;
          FCol := 0;
          frReport.Dataset := nil;
        end;
      end;
    if CallDesigner
      then frReport.DesignReport
      else frReport.ShowReport;
  except
    on E: Exception do LogAndShowError(E.Message);
  end;

  if frmDM.ZQueryDruckenDetail.Active  then frmDM.ZQueryDruckenDetail.Close;
  if frmDM.ZQueryDruckenDetail1.Active then frmDM.ZQueryDruckenDetail1.Close;
  if frmDM.ZQueryDrucken.Active        then frmDM.ZQueryDrucken.Close;
  frmDM.ZQueryDruckenDetail.MasterFields  := '';
  frmDM.ZQueryDruckenDetail.LinkedFields  := '';
  frmDM.ZQueryDruckenDetail1.MasterFields := '';
  frmDM.ZQueryDruckenDetail1.LinkedFields := '';
  frReport.Clear;
  Druckmode := none;
end;

procedure TfrmDrucken.btnJournaldruckClick(Sender: TObject);
begin
  Druckmode := Journal;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnJahresabschlussClick(Sender: TObject);
begin
  Druckmode := Jahresabschluss;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnBankenlisteClick(Sender: TObject);
begin
  Druckmode := BankenListe;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnBankenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := BankenListe;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnEinAusClick(Sender: TObject);
begin
  Druckmode := EinAus;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnEinAusContextPopup(Sender: TObject; MousePos: TPoint;  var Handled: Boolean);
begin
  Druckmode := EinAus;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournalBKdruckClick(Sender: TObject);
begin
  Druckmode := JournalBK;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnJournalBKdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalBK;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournalFilteredClick(Sender: TObject);
begin
  Druckmode := JournalGefiltert;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnJournalFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalGefiltert;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournalKompaktFilteredClick(Sender: TObject);
begin
  Druckmode := JournalKompaktGefiltert;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnJournalKompaktFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalKompaktGefiltert;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournalSKdruckClick(Sender: TObject);
begin
  Druckmode := JournalSK;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnJournalSKdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalSK;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnZahlerlisteClick(Sender: TObject);
begin
  Druckmode := Zahlungsliste;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnBeitragslisteClick(Sender: TObject);
begin
  Druckmode := BeitragslisteSK;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnBeitragslisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := BeitragslisteSK;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnDurchgangClick(Sender: TObject);

type
  T3ColReport =  record
    Name      : string;
    EinBetrag : Longint;
    AusBetrag : Longint;
  end;

var
  FileName : String;
  Daten    : array[0..9999] of T3ColReport;
  sHelp    : String;
  nHelp    : integer;
  f        : TextFile;
  error    : boolean;

begin
  Error := false;
  FileName := sAppDir+'DurchgangUebersicht.csv';

  for nHelp := 0 to 9999 do
    begin
      Daten[nHelp].EinBetrag := 0;
      Daten[nHelp].AusBetrag := 0;
      Daten[nHelp].Name   := '';
    end;

  frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SummenlisteDruckenJournalDurchgang.sql');
  frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := nBuchungsjahr;
  frmDM.ZQueryDrucken.SQL.Text := StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', '', [rfReplaceAll]);
  frmDM.ZQueryDrucken.Open;
  while not frmDM.ZQueryDrucken.EOF do
    begin
      //Zwichenspeichern
      if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = nBuchungsjahr
        then
          begin
            nHelp := frmDM.ZQueryDrucken.FieldByName('Konto_nach').AsInteger;
            Daten[nHelp].Name := frmDM.ZQueryDrucken.FieldByName('Name').AsString;
            if frmDM.ZQueryDrucken.FieldByName('Betrag').AsInteger > 0
              then
                begin
                  Daten[nHelp].EinBetrag := Daten[nHelp].EinBetrag + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                end
            else
                begin
                  Daten[nHelp].AusBetrag := Daten[nHelp].AusBetrag + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                end;
          end;
      frmDM.ZQueryDrucken.Next;
    end;
  frmDM.ZQueryDrucken.Close;

  try
    try
      //Datei anlegen
      AssignFile(F, Filename);
      Rewrite(f);

      //Ausgeben

      //Header
      WriteLn(F, '"Konto";"KontoNr";"Einnahme";"Weiterleitung";"Differenz"');

      //Daten
      for nHelp := 0 to 9999 do
        begin
          if Daten[nHelp].Name <> ''
            then
              begin
                WriteLn(F, '"'+UTF8toCP1252(DeleteChar(Daten[nHelp].Name, '"'))+'";"'+
                           inttostr(nHelp)+'";'+
                           IntToCurrency(Daten[nHelp].EinBetrag)+';'+
                           IntToCurrency(Daten[nHelp].AusBetrag)+';'+
                           IntToCurrency(Daten[nHelp].EinBetrag+Daten[nHelp].AusBetrag));
              end;
        end;
    except
      on E : Exception do
        begin
          Showmessage('Fehler beim Schreiben der Datei: '+Filename+#13#13+E.ClassName+ ': '+ E.Message);
          Error := true;
        end;
    end;
  finally
    try
      CloseFile(f); //Ausgabedatei schliesen
    except
      //Tritt auf, wenn die Datei nicht offen war
    end;
  end;

  if not Error
    then
      begin
        showmessage('Datei "'+FileName+'" erstellt');
        //Aufrufen
        ShellExecute(Self.Handle, 'Open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
      end;
end;

procedure TfrmDrucken.btnJahresabschlussContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Jahresabschluss;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournaldruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Journal;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnPersonenlisteClick(Sender: TObject);
begin
  Druckmode := Personenliste;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnPersonenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Personenliste;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnPersonenlisteKompaktClick(Sender: TObject);
begin
  Druckmode := PersonenlisteKompakt;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnPersonenlisteKompaktContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := PersonenlisteKompakt;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnSachkontenlisteClick(Sender: TObject);
begin
  Druckmode := Sachkontenliste;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnSachkontenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Sachkontenliste;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnSchliessenClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDrucken.btnZahlerlisteContextPopup(Sender: TObject;  MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Zahlungsliste;
  PreparePrint(true);
  Handled   := true;
end;

procedure TfrmDrucken.btnZuwendungsbescheinigungenClick(Sender: TObject);
begin
  Druckmode := Zuwendung;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnZuwendungsbescheinigungenContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Zuwendung;
  PreparePrint(true);
  Handled   := true;
end;

procedure TfrmDrucken.btnSummenlisteClick(Sender: TObject);
begin
  Druckmode := Summenliste;
  PreparePrint(false);
end;

procedure TfrmDrucken.btnSummenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Summenliste;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.cbDatumChange(Sender: TObject);
begin
  DateTimePickerVon.Enabled := false;
  DateTimePickerBis.Enabled := false;
  shape1.Visible            := (rgFilter.ItemIndex <> 0) or  cbDatum.Checked;
  shape2.Visible            := (rgFilter.ItemIndex = 0 ) and cbDatum.Checked;
  if cbDatum.Checked
    then
      begin
        DateTimePickerVon.Enabled := true;
        DateTimePickerBis.Enabled := true;
        DateTimePickerVon.Date    := StrToDate('01.01.'+inttostr(nBuchungsjahr));
        DateTimePickerBis.Date    := StrToDate('31.12.'+inttostr(nBuchungsjahr));
        DateTimePickerVon.MinDate := DateTimePickerVon.Date;
        DateTimePickerVon.MaxDate := DateTimePickerBis.Date;
        DateTimePickerBis.MinDate := DateTimePickerVon.Date;
        DateTimePickerBis.MaxDate := DateTimePickerBis.Date;
      end;
end;

procedure TfrmDrucken.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if frmDM.ZQueryDruckenDetail.Active  then frmDM.ZQueryDruckenDetail.Close;
  if frmDM.ZQueryDruckenDetail1.Active then frmDM.ZQueryDruckenDetail1.Close;
  if frmDM.ZQueryDrucken.Active        then frmDM.ZQueryDrucken.Close;
end;

procedure TfrmDrucken.FormCreate(Sender: TObject);

var
  jahr_, monat_, tag_: word;

begin
  DecodeDate(now(), jahr_, monat_, tag_);
  DateTimePickerVon.Date := EncodeDate(jahr_, 1, 1);
  DateTimePickerBis.Date := EncodeDate(jahr_, 12, 31);
end;


procedure TfrmDrucken.FormShow(Sender: TObject);
begin
  Druckmode := none;
  Seite     := 1;
end;

procedure TfrmDrucken.frReportBeginBand(Band: TfrBand);
begin
  case Druckmode of
    Summenliste,
    EinAus,
    BeitragslisteSK,
    Zahlungsliste:
      begin
        if (Band.Typ = btMasterData) then Inc(FRow);     // Neue Zeile
      end;
    Zuwendung:
      begin
        if (Band.Typ = btMasterData)
          then
            begin
              Seite := 1;
            end;
        if (band.Name = 'bandEmpfaenger')
          then
            begin
              if (frmDM.ZQueryDruckenDetail1.FieldByName('FinanzamtNr').AsString = '')
                then band.Height:=31
                else band.Height:=62;
            end;
      end;
  end;
end;

procedure TfrmDrucken.frReportBeginDoc;

var
  BandView: TfrBandView;
  MemoView: TfrMemoView;

begin
  case Druckmode of
    Summenliste,
    EinAus,
    BeitragslisteSK,
    Zahlungsliste:
      begin
        BandView := frReport.FindObject('MasterData1') as TfrBandView;
        BandView.DataSet := inttostr(FRowPart1);       // Anzahl Reihen definieren
        BandView := frReport.FindObject('CrossData1') as TfrBandView;
        BandView.DataSet := '2';                       // 2 Datenspalten
      end;
    Zuwendung:
      begin
        try
          MemoView := frReport.FindObject('memTitel') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Titel', 'Sammelbestätigung über Geldzuwendungen', true);

          MemoView := frReport.FindObject('memSubTitel') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'SubTitel', 'im Sinne des § 10b des Einkommensteuergesetzes an inländische juristische Personen des öffentlichen Rechts oder inländische öffentliche Dienststellen:', true);

          MemoView := frReport.FindObject('memFoerderung') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Foerderung', 'Es wird bestätigt, dass die Zuwendung nur zur Förderung kirchlicher Zwecke verwendet wird.', true);
          // 15 pro Zeile
          // Zeilen = Textlänge / 90
          MemoView.Height:=(MemoView.Memo.Text.Length div 90)*15;
          BandView := frReport.FindObject('bandMaster') as TfrBandView;
          BandView.Height:=378+MemoView.Height;

          MemoView := frReport.FindObject('memEigene') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Eigene', 'von uns unmittelbar für den angegebenen Zweck verwendet. (Empfänger = [Empfaenger])' , true);

          MemoView := frReport.FindObject('memEigeneFinanzamt') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'EigeneFinanzamt', 'Finanzamt [EigenesFinanzamt] vom [EigenesFinanzamtVom], StNr.: [EigenesFinanzamtNr]', true);

          MemoView := frReport.FindObject('memWeiter') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Weitergeleitete', 'entsprechend den Angaben des Zuwendenden an [Empfaenger] weitergeleitet, die/der vom Finanzamt "[Finanzamt]", StNr.: "[FinanzamtNr]" mit Freistellungsbescheid bzw. nach der Anlage zum Körperschaftsteuerbescheid vom "[FinanzamtVom]" von der Körperschaftssteuer und Gewerbesteuer befreit ist.', true);
        except
          on E: Exception do LogAndShowError(E.Message);
        end;
      end;
  end;
end;

procedure TfrmDrucken.frReportBeginPage(pgNo: Integer);
begin
  inc(Seite);
end;

procedure TfrmDrucken.frReportEnterRect(Memo: TStringList; View: TfrView);
begin
  case Druckmode of
    Summenliste,
    EinAus,
    BeitragslisteSK,
    Zahlungsliste:
      begin
        //Kopf und Fußzeilen markiern
        if (view.parent.typ=btCrossData) or
           (view.parent.typ=btCrossHeader)
          then
            if view is TfrMemoView then
              with TfrMemoView(view) do
                begin
                  Visible:= true;
                  case TwoColReportData[FRow].typ of
                    footer,
                    header:begin
                             Font.Style:=[fsbold];
                             View.FillColor:=TColor($D0D0D0); //helles Grau
                           end;
                    line:  begin
                             Font.Style:=[];
                             View.FillColor:=clWhite;
                           end;
                    blank: begin
                             Visible:= false;
                           end;
                    end;
                  end;
      end;
  end;
end;

procedure TfrmDrucken.frReportGetValue(const ParName: String; var ParValue: Variant);

var
  i      : longint;
  s      : string;
  t      : String;
  sWhere : string;
  sWord  : string;

begin
  if      ParName = 'Buchungsjahr' then ParValue := inttostr(nBuchungsjahr)
  else if ParName = 'GemName'      then ParValue := sGemeindeName
  else if ParName = 'GemOrt'       then ParValue := sGemeindeOrt
  else if ParName = 'GemStrOrt'    then ParValue := sGemeindeAdr2
  else if ParName = 'Seite'        then ParValue := inttostr(Seite)
  else if ParName = 'Rendant'      then ParValue := sRendantAdr
  else if ParName = 'RendantOrt'   then ParValue := sRendantOrt
  else if ParName = 'EigenesFinanzamt'    then ParValue := sFinanzamt
  else if ParName = 'EigenesFinanzamtNr'  then ParValue := sFinanzamtNr
  else if ParName = 'EigenesFinanzamtVom' then ParValue := sFinanzamtVom
  else if ParName = 'ue_links'            then ParValue := sGemeindeAdr
  else if ParName = 'ue_rechts'           then ParValue := formatdatetime('dd.mm.yyyy', now())
  else
  case Druckmode of
    Jahresabschluss:
      begin
        t := ParName[1];
        if ParName = 'Einnahmen' then
          ParValue := IntToCurrency(nEinnahmen)+' €'
        else if ParName = 'Ausgaben' then
          ParValue := IntToCurrency(nAusgaben)+' €'
        else if ParName = 'Ergebnis' then
          ParValue := IntToCurrency(nEinnahmen+nAusgaben)+' €'
        else if ParName = 'BankErgebnis' then
          ParValue := IntToCurrency(nBestand+nEinnahmen+nAusgaben)+' €'
        else if (t = 'B') or    //Banken
                (t = 'S') or    //BankenkontoStand
                (t = 'E') or    //Gesamteinnahmen
                (t = 'A') or    //Gesamtausgaben
                (t = 'K') or    //Kontosumme   Format: K;81;82....
                (t = 'P') or    //Positive Werte Kontosumme   Format: P;81;82....
                (t = 'N') then  //Negative Werte Kontosumme   Format: N;81;82....
          begin
            s      := ParName;
            sWhere := '((';
            i      := 2;
            sWord  := ExtractWord(i, s, [';']);
            while sWord <> '' do
              begin
                if i > 2 then sWhere := sWhere + ' or (';
                sWhere := sWhere + 'substr(Statistik,1,'+inttostr(length(sWord))+')='''+sWord+''')';
                inc(i);
                sWord  := ExtractWord(i, s, [';']);
              end;
            sWhere := sWhere + ')';
            if (t = 'B') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'BankenAbschluss', 'Anfangssaldo', 'left join konten on konten.KontoNr=BankenAbschluss.KontoNr', sWhere+' and BuchungsJahr='+inttostr(nBuchungsjahr));
                nBestand := i;
              end
            else if (t = 'S') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'konten', 'Kontostand', '', sWhere);
              end
            else if (t = 'P') or (t = 'E') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'Journal left join konten on konten.KontoNr=journal.Konto_Nach', 'Betrag', '', sWhere+' and BuchungsJahr='+inttostr(nBuchungsjahr) + ' and (journal.Betrag > 0) ');
                if (t = 'E') then nEinnahmen := i;
              end
            else if (t = 'N') or (t = 'A') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'Journal left join konten on konten.KontoNr=journal.Konto_Nach', 'Betrag', '', sWhere+' and BuchungsJahr='+inttostr(nBuchungsjahr) + ' and (journal.Betrag < 0) ');
                if (t = 'A') then nAusgaben  := i;
              end
            else
              // K
              i := GetDBSum(frmDM.ZQueryHelp, 'Journal left join konten on konten.KontoNr=journal.Konto_Nach', 'Betrag', '', sWhere+' and BuchungsJahr='+inttostr(nBuchungsjahr));
            ParValue := IntToCurrency(i)+' €'; ;
          end
      end;
    Summenliste,
    EinAus,
    BeitragslisteSK,
    Zahlungsliste:
      begin
        if ParName = 'value' then                      // Daten
          begin
            if FCol = 1
              then ParValue := TwoColReportData[FRow].Col1
              else ParValue := TwoColReportData[FRow].Col2
          end
        else if ParName = 'Line' then                  // Zeilenbeschriftung
          ParValue := TwoColReportData[FRow].Name
        else if ParName = 'ueberschrift' then
          begin
            case Druckmode of
              Summenliste:     ParValue := 'Summenliste';
              EinAus:          ParValue := 'Ein/Ausgaben';
              BeitragslisteSK: ParValue := 'Zahler- / Empfängerliste nach Sachkonto';
              Zahlungsliste:   ParValue := 'Zahlungsliste';
            end;
          end;
      end;
    Zuwendung:
      begin
        if ParName = 'BetragIW' then
          begin
            i := frmDM.ZQueryDrucken.FieldByName('Betrag').AsLongint;
            s := ZahlInString(i div 100)+' EURO';
            if (i mod 100) <> 0 then s := s + ' und '+ZahlInString(i mod 100)+' CENT';
            ParValue := s;
          end
        else if ParName = 'Betrag'       then ParValue := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Betrag').AsLongint)+' €'
        else if ParName = 'Empfaenger'   then ParValue := frmDM.ZQueryDruckenDetail1.FieldByName('Empfaenger').AsString
        else if ParName = 'Finanzamt'    then ParValue := frmDM.ZQueryDruckenDetail1.FieldByName('Finanzamt').AsString
        else if ParName = 'FinanzamtVom' then ParValue := frmDM.ZQueryDruckenDetail1.FieldByName('FinanzamtVom').AsString
        else if ParName = 'FinanzamtNr'  then ParValue := frmDM.ZQueryDruckenDetail1.FieldByName('FinanzamtNr').AsString;
      end;
  end;
  //s := ParValue;
  //if s <> '' then
  //myDebugLN('Report ask for: "'+ParName+'". Answere: "'+s+'"');
end;

procedure TfrmDrucken.frReportPrintColumn(ColNo: Integer; var ColWidth: Integer);
begin
  FCol := ColNo;                                 // Welche Spalte wird gedruckt
end;

procedure TfrmDrucken.rgFilterSelectionChanged(Sender: TObject);
begin
  ediFilter.Enabled := false;
  shape1.Visible    := cbDatum.Checked;
  shape2.Visible    := cbDatum.Checked and (rgFilter.ItemIndex = 0);
  case rgFilter.ItemIndex of
    1,
    2,
    3,
    4  : begin
           ediFilter.Enabled := true;
           shape1.Visible    := true;
           ediFilter.Text    := '';
         end;
  end;
end;

end.

