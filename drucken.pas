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
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Printers,
  Menus,
  Spin,
  types;

type
  TDruckmode  = (none,
                 Bankenliste,
                 BeitragslisteSK,
                 EinAus,
                 Finanzbericht,
                 Haushaltsplan,
                 Journal,
                 JournalGefiltert,
                 JournalKompaktGefiltert,
                 JournalNachBankenGruppiert,
                 JournalNachSachkontenGruppiert,
                 Personenliste,
                 PersonenlisteKompakt,
                 Sachkontenliste,
                 Summenliste,
                 Zahlungsliste,
                 Zuwendung);

  TColType    = (header,
                 header2,
                 blank,
                 footer,
                 footer2,
                 footer3,
                 line);

  T2ColReport =  record
    Name : string;
    Col1 : string;
    Col2 : String;
    typ  : TColType;
  end;

  { TfrmDrucken }

  TfrmDrucken = class(TForm)
    btnBankenliste: TButton;
    btnBeitragsliste: TButton;
    btnDurchgang: TButton;
    btnEinAus: TButton;
    btnHaushaltsplan: TButton;
    btnEinAusCSV: TButton;
    btnHaushaltsplanCSV: TButton;
    btnFinanzbericht: TButton;
    btnJournaldruck: TButton;
    btnJournalNachSachkontenGruppiertCSV: TButton;
    btnZahlerMonatlicheZahlungen: TButton;
    btnJournalFiltered: TButton;
    btnJournalKompaktFiltered: TButton;
    btnJournalNachBankenGruppiertCSV: TButton;
    btnJournalNachBankenGruppiertdruck: TButton;
    btnJournalNachSachkontenGruppiertdruck: TButton;
    btnPersonenliste: TButton;
    btnPersonenlisteKompakt: TButton;
    btnSachkontenliste: TButton;
    btnSchliessen: TButton;
    btnSummenlistCSV: TButton;
    btnBeitragslisteCSV: TButton;
    btnZahlerlisteCSV: TButton;
    btnSummenliste: TButton;
    btnZahlerliste: TButton;
    btnMonatlicheZahlungen: TButton;
    btnZuwendungsbescheinigungen: TButton;
    btnZuwendungsbescheinigungenMail: TButton;
    btnZuwendungsbescheinigungenEinzeln: TButton;
    cbDatum: TCheckBox;
    cbDruckeDirekt: TCheckBox;
    cbDrucker: TComboBox;
    DateTimePickerBis: TDateTimePicker;
    DateTimePickerVon: TDateTimePicker;
    ediBuchungsjahr: TSpinEdit;
    ediFilter: TLabeledEdit;
    frDBDataSet: TfrDBDataSet;
    frDBDataSetDetail: TfrDBDataSet;
    frDBDataSetDetail1: TfrDBDataSet;
    frDesigner: TfrDesigner;
    frReport: TfrReport;
    Label2: TLabel;
    Label4: TLabel;
    rgFilter: TRadioGroup;
    Shape1: TShape;
    Shape3: TShape;
    procedure btnBankenlisteClick(Sender: TObject);
    procedure btnBankenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnBeitragslisteClick(Sender: TObject);
    procedure btnBeitragslisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnBeitragslisteCSVClick(Sender: TObject);
    procedure btnDurchgangClick(Sender: TObject);
    procedure btnEinAusClick(Sender: TObject);
    procedure btnEinAusCSVClick(Sender: TObject);
    procedure btnFinanzberichtClick(Sender: TObject);
    procedure btnFinanzberichtContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnHaushaltsplanClick(Sender: TObject);
    procedure btnHaushaltsplanCSVClick(Sender: TObject);
    procedure btnJournaldruckClick(Sender: TObject);
    procedure btnJournaldruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalFilteredClick(Sender: TObject);
    procedure btnJournalFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalKompaktFilteredClick(Sender: TObject);
    procedure btnJournalKompaktFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalNachBankenGruppiertCSVClick(Sender: TObject);
    procedure btnJournalNachBankenGruppiertdruckClick(Sender: TObject);
    procedure btnJournalNachBankenGruppiertdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnJournalNachSachkontenGruppiertCSVClick(Sender: TObject);
    procedure btnJournalNachSachkontenGruppiertdruckClick(Sender: TObject);
    procedure btnJournalNachSachkontenGruppiertdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnMonatlicheZahlungenClick(Sender: TObject);
    procedure btnPersonenlisteClick(Sender: TObject);
    procedure btnPersonenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnPersonenlisteKompaktClick(Sender: TObject);
    procedure btnPersonenlisteKompaktContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnSachkontenlisteClick(Sender: TObject);
    procedure btnSachkontenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnSchliessenClick(Sender: TObject);
    procedure btnSummenlisteClick(Sender: TObject);
    procedure btnSummenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnZahlerlisteClick(Sender: TObject);
    procedure btnZahlerlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnZahlerlisteCSVClick(Sender: TObject);
    procedure btnZahlerMonatlicheZahlungenClick(Sender: TObject);
    procedure btnZuwendungsbescheinigungenClick(Sender: TObject);
    procedure btnZuwendungsbescheinigungenContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnZuwendungsbescheinigungenEinzelnClick(Sender: TObject);
    procedure btnZuwendungsbescheinigungenMailClick(Sender: TObject);
    procedure btnZuwendungsbescheinigungenMailContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
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
    procedure mnuSummenlisteCSVExportClick(Sender: TObject);
    procedure rgFilterSelectionChanged(Sender: TObject);
  private
    { private declarations }
    Druckmode : TDruckmode;
    TwoColReportData : array[0..49999] of T2ColReport;
    FCol      : Integer;
    FRow      : Integer;
    FRowPart1 : Integer;
    nEinnahmen: longint;
    nAusgaben : longint;
    nBestand  : longint;
    slHelp    : TStringList;
    Procedure PreparePrint(CallDesigner : boolean = false; CSV_Export : boolean = false; Einzeln: boolean = false);
    Procedure AddLine(sName, Col1, Col2: String; Typ: TColType);
    Procedure AddFilterToReport;
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
  LCLIntf,  //Opendocument
  LazUTF8,  //UTF8ToSys
  sevenzip7,
  help,
  freelist,
  progress,
  ausgabe,
  main,
  mailsend,
  dm;

Var
  Seite       : integer;

Procedure TfrmDrucken.AddLine(sName, Col1, Col2: String;  Typ: TColType);

begin
  inc(FRow);
  TwoColReportData[FRow].Name := sName;
  TwoColReportData[FRow].Col1 := Col1;
  TwoColReportData[FRow].Col2 := Col2;
  TwoColReportData[FRow].typ  := Typ;
end;

Procedure TfrmDrucken.AddFilterToReport;

var
  sHelp : String;

begin
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
        AddLine('', '', '', blank); //Leerzeile
        AddLine('Filter: '+sHelp, '', '', header);
      end;

if cbDatum.Checked
  then
    begin
      if sHelp = '' then AddLine('', '', '', blank); //Leerzeile
      AddLine('Filter von '+formatdatetime('dd.mm.yyyy', DateTimePickerVon.Date)+' bis '+formatdatetime('dd.mm.yyyy', DateTimePickerBis.Date), '', '', header);
    end;
end;

Procedure TfrmDrucken.PreparePrint(CallDesigner: boolean = false; CSV_Export: boolean = false; Einzeln: boolean = false);

var
  sSachkontoNr           : string;
  sLastSachkontoNr       : string;
  sKontoNr               : string;
  sLastKontoNr           : string;
  sName                  : string;
  sLastName              : string;
  sFilterWhere           : string;
  sHelp                  : string;
  sBereich               : string;
  sFileName              : string;
  Col1Summe              : longint;
  Col2Summe              : longint;
  Col1SummePart1         : longint;
  Col2SummePart1         : longint;
  Col1SummePart2         : longint;
  Col2SummePart2         : longint;
  Col1ZwischenSummePart1 : longint;
  Col2ZwischenSummePart1 : longint;
  Col1ZwischenSummePart2 : longint;
  Col2ZwischenSummePart2 : longint;
  Col1SummePart3         : longint;
  Col2SummePart3         : longint;
  Col1SummePart3b        : longint;
  Col2SummePart3b        : longint;
  Col1LineSummePart3     : longint;
  Col2LineSummePart3     : longint;
  Col1LineSummePart3b    : longint;
  Col2LineSummePart3b    : longint;
  Col1SummePart4         : longint;
  Col2SummePart4         : longint;
  Betrag                 : longint;
  speicher               : longint;
  i                      : integer;
  nSaveRow               : integer;

begin
  //Zwischenspeicher leeren
  for i := 0 to 49999 do
    begin
      TwoColReportData[i].Name := '';
      TwoColReportData[i].Col1 := '';
      TwoColReportData[i].Col2 := '';
      TwoColReportData[i].typ  := blank;
    end;

  Col1LineSummePart3 := 0;
  Col1LineSummePart3b:= 0;
  Col1Summe          := 0;
  Col1SummePart1     := 0;
  Col1SummePart2     := 0;
  Col1SummePart3     := 0;
  Col1SummePart3b    := 0;
  Col1SummePart4     := 0;
  Col2LineSummePart3 := 0;
  Col2LineSummePart3b:= 0;
  Col2Summe          := 0;
  Col2SummePart1     := 0;
  Col2SummePart2     := 0;
  Col2SummePart3     := 0;
  Col2SummePart3b    := 0;
  Col2SummePart4     := 0;
  FRow               := 0;
  FRowPart1          := 0;
  nAusgaben          := 0;
  nBestand           := 0;
  nEinnahmen         := 0;
  sBereich           := '';
  sFilterWhere       := '';
  sHelp              := '';
  sKontoNr           := '';
  sLastKontoNr       := '';
  sLastName          := '';
  sLastSachkontoNr   := '';
  sName              := '';
  sSachkontoNr       := '';

  //Filter
  if cbDatum.Checked
    then sFilterWhere := ' and (journal.Datum >='+SQLiteDateFormat(DateTimePickerVon.Date)+')'+
                         ' and (journal.Datum <='+SQLiteDateFormat(DateTimePickerBis.Date)+')';

  case rgFilter.ItemIndex of
    1: sFilterWhere += ' and (journal.BankNr ='+ediFilter.Text+')';
    2: sFilterWhere += ' and (journal.Konto_nach ='+ediFilter.Text+')';
    3: sFilterWhere += ' and (journal.PersonenID ='+ediFilter.Text+')';
    4: sFilterWhere += ' and (journal.bemerkung like ''%'+ediFilter.Text+'%'')';
  end;

  try
    case Druckmode of
      Finanzbericht:
        begin
          frReport.LoadFromFile(sAppDir+'module\Reporte\Finanzbericht.lrf');
          frReport.Dataset := nil;
        end;
      BeitragslisteSK:
        begin
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\BeitragslisteDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
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
                    sLastSachkontoNr := sSachkontoNr;
                    if FRow > 0
                      then
                        begin
                          AddLine('Summe', IntToCurrency(Col1SummePart1), IntToCurrency(Col2SummePart1), footer); //Zusammenfassung
                          AddLine('', '', '', blank); //Leerzeile
                        end;
                    AddLine(sSachkontoNr, inttostr(ediBuchungsjahr.value), inttostr(ediBuchungsjahr.value-1), header); //Neues Sachkonto, neue Rubrik
                    Col1SummePart1 := 0;
                    Col2SummePart1 := 0;
                    sLastName      := '';
                  end;
              if sName <> sLastName
                then
                  begin
                    AddLine(sName, IntToCurrency(0), IntToCurrency(0), line);  //Neuer Name, neue Zeile
                    sLastName := sName;
                  end;
              if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = ediBuchungsjahr.value
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
            if FRow > 0 then AddLine('Summe', IntToCurrency(Col1SummePart1), IntToCurrency(Col2SummePart1), header);  //Zusammenfassung

          frmDM.ZQueryDrucken.close;

          AddFilterToReport;

          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\Reporte\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow :=  0;
          FCol :=  0;
          frReport.Dataset := nil;
        end;
      Zahlungsliste:
        begin
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\ZahlerlisteDrucken.sql');
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
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
                          AddLine('Summe', IntToCurrency(Col1SummePart1), IntToCurrency(Col2SummePart1), footer);  //Zusammenfassung
                          AddLine('', '', '', blank); //Leerzeile
                        end;
                    AddLine(sName, inttostr(ediBuchungsjahr.value), inttostr(ediBuchungsjahr.value-1), header); //Neues Sachkonto, neue Rubrik
                    sLastName        := sName;
                    Col1SummePart1   := 0;
                    Col2SummePart1   := 0;
                    sLastSachkontoNr := '';
                  end;
              if sSachkontoNr <> sLastSachkontoNr
                then
                  begin
                    AddLine(sSachkontoNr, IntToCurrency(0), IntToCurrency(0), line);  //Neuer Name, neue Zeile
                    sLastSachkontoNr := sSachkontoNr;
                  end;
              if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = ediBuchungsjahr.value
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
            if FRow > 0 then AddLine('Summe', IntToCurrency(Col1SummePart1), IntToCurrency(Col2SummePart1), header);  //Zusammenfassung
          frmDM.ZQueryDrucken.close;

          AddFilterToReport;

          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\Reporte\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1        := FRow;
          FRow             := 0;
          FCol             := 0;
          frReport.Dataset := nil;
        end;
      Zuwendung:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\ZuwendungDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':ADDWHERE', '', [rfReplaceAll]);

          frmDM.ZQueryDruckenDetail.SQL.LoadFromFile(sAppDir+'module\SQL\ZuwendungDruckenDetail.sql');
          frmDM.ZQueryDruckenDetail.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDruckenDetail.MasterFields := 'PersonenID';
          frmDM.ZQueryDruckenDetail.LinkedFields := 'PersonenID';

          frmDM.ZQueryDruckenDetail1.SQL.LoadFromFile(sAppDir+'module\SQL\ZuwendungDruckenDetail1.sql');
          frmDM.ZQueryDruckenDetail1.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDruckenDetail1.MasterFields := 'PersonenID';
          frmDM.ZQueryDruckenDetail1.LinkedFields := 'PersonenID';

          frReport.LoadFromFile(sAppDir+'module\Reporte\ZuwendungDrucken.lrf');
          frmDM.ZQueryDrucken.Open;
          frmDM.ZQueryDruckenDetail.Open;
          frmDM.ZQueryDruckenDetail1.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Bankenliste:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\BankenDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(ediBuchungsjahr.value);
          frReport.LoadFromFile(sAppDir+'module\Reporte\BankenDrucken.lrf');
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Sachkontenliste:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SachkontenlisteDrucken.sql');
          frReport.LoadFromFile(sAppDir+'module\Reporte\SachkontenlisteDrucken.lrf');
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      Personenliste,
      PersonenlisteKompakt:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\PersonenDrucken.sql');
          case Druckmode of
            Personenliste       : frReport.LoadFromFile(sAppDir+'module\Reporte\PersonenDrucken.lrf');
            PersonenlisteKompakt: frReport.LoadFromFile(sAppDir+'module\Reporte\PersonenDruckenKompakt.lrf');
          end;
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      JournalNachBankenGruppiert:
        begin
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\BankenDrucken.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDrucken.Open;

          frmDM.ZQueryDruckenDetail.SQL.LoadFromFile(sAppDir+'module\SQL\JournalDruckenBK.sql');
          frmDM.ZQueryDruckenDetail.SQL.Text := StringReplace(frmDM.ZQueryDruckenDetail.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
          frmDM.ZQueryDruckenDetail.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDruckenDetail.Open;

          while not frmDM.ZQueryDrucken.EOF do
            begin
              if CSV_Export then sHelp := ';;;' else sHelp := '';
              //Kontobereich überprüfen
              sKontoNr := frmDM.ZQueryDrucken.FieldByName('BankNr').AsString;
              if sKontoNr <> sLastKontoNr
                then
                  begin
                    if FRow > 0
                      then
                        begin
                          AddLine(sHelp, IntToCurrency(Col1SummePart1), 'Kontostand', footer);  //Zusammenfassung
                          AddLine('', '', '', blank); //Leerzeile
                        end;
                    sLastKontoNr   := sKontoNr;
                    Col1SummePart1 := frmDM.ZQueryDrucken.FieldByName('Startsaldo').AsInteger;
                    //Überschrift
                    AddLine('('+sKontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString+sHelp, IntToCurrency(Col1SummePart1), 'Startsaldo', header); //Neues Sachkonto, neue Zeile
                    frmDM.ZQueryDruckenDetail.First;
                    while not frmDM.ZQueryDruckenDetail.EOF do
                      begin
                        if (sKontoNr = frmDM.ZQueryDruckenDetail.FieldByName('BankNr').AsString) or
                           (sKontoNr = frmDM.ZQueryDruckenDetail.FieldByName('konto_nach').AsString) then
                          begin
                            //Umbuchungen
                            if (sKontoNr = frmDM.ZQueryDruckenDetail.FieldByName('konto_nach').AsString)
                              then Betrag := frmDM.ZQueryDruckenDetail.FieldByName('Betrag').AsInteger * -1
                              else Betrag := frmDM.ZQueryDruckenDetail.FieldByName('Betrag').AsInteger;
                            Col1SummePart1 := Col1SummePart1 + Betrag;
                            sHelp := frmDM.ZQueryDruckenDetail.FieldByName('Sachkonto').AsString;
                            if length(sHelp) >= 23
                              then sHelp := copy(sHelp,                             0, 20)+'...'
                              else sHelp := copy(sHelp+'                         ', 0, 23);
                            AddLine(frmDM.ZQueryDruckenDetail.FieldByName('LaufendeNr').AsString+';'+
                                    sHelp+';'+
                                    frmDM.ZQueryDruckenDetail.FieldByName('Buchungstext').AsString+';'+
                                    frmDM.ZQueryDruckenDetail.FieldByName('Name').AsString,
                                    IntToCurrency(Betrag),
                                    frmDM.ZQueryDruckenDetail.FieldByName('Datum').AsString,
                                    line);
                          end;
                        frmDM.ZQueryDruckenDetail.Next;
                      end;
                  end;
              frmDM.ZQueryDrucken.Next;
            end;
            //Schlußsumme
            if CSV_Export then sHelp := ';;;' else sHelp := '';
            if FRow > 0 then AddLine(sHelp, IntToCurrency(Col1SummePart1), 'Kontostand', header);

          frmDM.ZQueryDrucken.close;
          frmDM.ZQueryDruckenDetail.close;

          AddFilterToReport;

          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\Reporte\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow      := 0;
          FCol      := 0;
          frReport.Dataset := nil;
        end;
      JournalNachSachkontenGruppiert:
        begin
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\JournalDruckenSK.sql');
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDrucken.Open;

          frmDM.ZQueryDruckenDetail.SQL.LoadFromFile(sAppDir+'module\SQL\JournalDruckenBK.sql');
          frmDM.ZQueryDruckenDetail.SQL.Text := StringReplace(frmDM.ZQueryDruckenDetail.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
          frmDM.ZQueryDruckenDetail.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
          frmDM.ZQueryDruckenDetail.Open;

          while not frmDM.ZQueryDrucken.EOF do
            begin
              if CSV_Export then sHelp := ';;' else sHelp := '';
              //Überschrift
              AddLine(frmDM.ZQueryDrucken.FieldByName('Name').AsString+sHelp, '', '', header);
              sKontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').asString;
              frmDM.ZQueryDruckenDetail.First;
              while not frmDM.ZQueryDruckenDetail.EOF do
                begin
                  if (sKontoNr = frmDM.ZQueryDruckenDetail.FieldByName('konto_nach').AsString) then
                    begin
                      AddLine(frmDM.ZQueryDruckenDetail.FieldByName('LaufendeNr').AsString+';'+
                              frmDM.ZQueryDruckenDetail.FieldByName('Buchungstext').AsString+';'+
                              frmDM.ZQueryDruckenDetail.FieldByName('Name').AsString,
                              IntToCurrency(frmDM.ZQueryDruckenDetail.FieldByName('Betrag').aslongint),
                              frmDM.ZQueryDruckenDetail.FieldByName('Datum').AsString,
                              line);
                    end;
                  frmDM.ZQueryDruckenDetail.Next;
                end;
              AddLine(sHelp, IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint), '', footer);  //Zusammenfassung
              AddLine('', '', '', blank); //Leerzeile
              frmDM.ZQueryDrucken.Next;
            end;
          frmDM.ZQueryDrucken.close;
          frmDM.ZQueryDruckenDetail.close;

          AddFilterToReport;

          //Debug
          //for i := 1 to FRow do myDebugLN(TwoColReportData[i].Name+';'+TwoColReportData[i].Col1+';'+TwoColReportData[i].Col2);

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\Reporte\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow      := 0;
          FCol      := 0;
          frReport.Dataset := nil;
        end;
      Journal,
      JournalGefiltert,
      JournalKompaktGefiltert:
        begin
          frDBDataSet.DataSource := frmDM.dsDrucken;
          frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\JournalDrucken.sql');

          if Druckmode = Journal   //Filter zurücksetzen
            then
              begin
                rgFilter.ItemIndex := 0;
                cbDatum.Checked    := false;
                sFilterWhere       := '';
              end;

          frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
          frmDM.ZQueryDrucken.ParamByName('BJahr').AsString := inttostr(ediBuchungsjahr.value);

          case Druckmode of
            Journal                 : frReport.LoadFromFile(sAppDir+'module\Reporte\JournalDrucken.lrf');
            JournalGefiltert        : frReport.LoadFromFile(sAppDir+'module\Reporte\JournalDruckenBemerkung.lrf');
            JournalKompaktGefiltert : frReport.LoadFromFile(sAppDir+'module\Reporte\JournalDruckenKompakt.lrf');
          end;
          frmDM.ZQueryDrucken.Open;
          frReport.Dataset := frDBDataSet;
        end;
      EinAus,
      Haushaltsplan,
      Summenliste:
        begin
          //Der "Summenliste" und "Haushaltsplan" Report enthalten 5 Teile.
          //Part 1 Einnahmen
          //Part 2 Ausgaben
          //Part 3 Durchgang Eingang
          //Part 3b Durchgang Ausgang
          //Part 4 Kassenstände
          //Part 5 Ergebnis
          //Die "Summenliste" enthält zusätzlich.
          //Part 6 Umbuchungen

          //Der "EinAus"-Report enthält 2 Teile.
          //Part 1 Einnahmen
          //Part 2 Ausgaben
          //
          //Die Daten werden über frReportGetValue abgefragt
          //Vorher müssen in frReportBeginDoc die Zeilen und Spalten angegeben werden.
          //Dazu werden die Daten vorher alle aus den Datenbanken gesammelt
          //und zwischengespeichert in TwoColReportData

          //Part 1 Einnahmen und
          //Part 2 Ausgaben
          //werden noch in die "Steuer" - Bereiche aufgeteilt

          //Überschrift Part 1
          AddLine('Einnahmen', '', '', header);
          AddLine('', '', '', blank); //Leerzeile

          slHelp.Text:=sSteuer;
          for i := 0 to slHelp.count-1 do
            begin
              //Part 1 Einnahmen
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenJournalEinAus.sql');
              //Diese SQL Abfrage enthält 5 Variablen
              //BJahr        Buchungsjahr
              //Type         E oder A für Kontotype
              //AddWhereAnd1 Filter (Bereiche und Datum)
              //AddWhereAnd2 Steuer
              //AddWhereOr   Plansumme <> 0 mit ausgeben
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
              frmDM.ZQueryDrucken.ParamByName('TYP').AsString    := 'E';
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereAnd1', sFilterWhere, [rfReplaceAll]);
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereAnd2', ' and (konten.Steuer="'+slHelp.Strings[i]+'")', [rfReplaceAll]);
              if Druckmode = Haushaltsplan
                then frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereOr', ' or (konten.PlanSumme<>0)', [rfReplaceAll])
                else frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereOr', '', [rfReplaceAll]);
              frmDM.ZQueryDrucken.Open;

              if frmDM.ZQueryDrucken.RecordCount > 0 then
                begin
                  //Überschrift Part 1
                  sBereich := 'Einnahmen';
                  if slHelp.Strings[i] <> '' then sBereich := sBereich + ' ('+slHelp.Strings[i]+')';
                  if Druckmode = Haushaltsplan
                    then AddLine(sBereich,  inttostr(ediBuchungsjahr.value),  'Haushaltsplan'          , header2)
                    else AddLine(sBereich,  inttostr(ediBuchungsjahr.value),  inttostr(ediBuchungsjahr.value-1), header2);
                  Col1ZwischenSummePart1 := 0;
                  Col2ZwischenSummePart1 := 0;

                  //Daten Part 1
                  while not frmDM.ZQueryDrucken.EOF do
                    begin
                      sSachkontoNr := frmDM.ZQueryDrucken.FieldByName('KontoNr').AsString;
                      if Druckmode = Haushaltsplan
                        then speicher := frmDM.ZQueryDrucken.FieldByName('PlanSumme').aslongint
                        else speicher := frmDM.ZQueryDrucken.FieldByName('Summe_letztes_Jahr').aslongint;
                      // Zeilen mit 0 Ausblenden
                      if (frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint <> 0) or
                         (speicher <> 0)
                        then
                          begin
                            AddLine('('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(0), IntToCurrency(0), line);

                            TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint);
                            Col1SummePart1              := Col1SummePart1         + frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint;
                            Col1ZwischenSummePart1      := Col1ZwischenSummePart1 + frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint;

                            TwoColReportData[FRow].Col2 := IntToCurrency(speicher);
                            Col2SummePart1              := Col2SummePart1         + speicher;
                            Col2ZwischenSummePart1      := Col2ZwischenSummePart1 + speicher;
                          end;
                      frmDM.ZQueryDrucken.Next;
                    end;

                  //ZwischenAbschluss Part 1
                  AddLine(sBereich, IntToCurrency(Col1ZwischenSummePart1), IntToCurrency(Col2ZwischenSummePart1), footer2);
                  AddLine('', '', '', blank); //Leerzeile

                  frmDM.ZQueryDrucken.Close;
                end;
            end;
          //Abschluss Part 1
          AddLine('Einnahmen gesamt', IntToCurrency(Col1SummePart1), IntToCurrency(Col2SummePart1), footer);
          AddLine('', '', '', blank); //Leerzeile
          AddLine('', '', '', blank); //Leerzeile

          frmDM.ZQueryDrucken.Close;
          sLastSachkontoNr := '';

          //Überschrift Part 2
          AddLine('Ausgaben', '', '', header);
          AddLine('', '', '', blank); //Leerzeile

          for i := 0 to slHelp.count-1 do
            begin
              //Part 2 Ausgaben
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenJournalEinAus.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
              frmDM.ZQueryDrucken.ParamByName('TYP').AsString    := 'A';
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereAnd1', sFilterWhere, [rfReplaceAll]);
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereAnd2', ' and (konten.Steuer="'+slHelp.Strings[i]+'")', [rfReplaceAll]);
              if Druckmode = Haushaltsplan
                then frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereOr', ' or (konten.PlanSumme<>0)', [rfReplaceAll])
                else frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhereOr', '', [rfReplaceAll]);
              frmDM.ZQueryDrucken.Open;

              if frmDM.ZQueryDrucken.RecordCount > 0 then
                begin
                  sBereich := 'Ausgaben';
                  if slHelp.Strings[i] <> '' then sBereich := sBereich + ' ('+slHelp.Strings[i]+')';
                  if Druckmode = Haushaltsplan
                    then AddLine(sBereich,  inttostr(ediBuchungsjahr.value),  'Haushaltsplan', header2)  //Überschrift Part 2
                    else AddLine(sBereich,  inttostr(ediBuchungsjahr.value),  inttostr(ediBuchungsjahr.value-1), header2);
                  Col1ZwischenSummePart2 := 0;
                  Col2ZwischenSummePart2 := 0;

                  //Daten Part 2
                  while not frmDM.ZQueryDrucken.EOF do
                    begin
                      sSachkontoNr     := frmDM.ZQueryDrucken.FieldByName('KontoNr').AsString;

                      if Druckmode = Haushaltsplan
                        then speicher := frmDM.ZQueryDrucken.FieldByName('PlanSumme').aslongint
                        else speicher := frmDM.ZQueryDrucken.FieldByName('Summe_letztes_Jahr').aslongint;
                      // Zeilen mit 0 Ausblenden
                      if (frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint <> 0) or
                         (speicher <> 0)
                        then
                          begin
                            AddLine('('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(0), IntToCurrency(0), line);

                            TwoColReportData[FRow].Col1 := IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint);
                            Col1SummePart2              := Col1SummePart2         + frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint;
                            Col1ZwischenSummePart2      := Col1ZwischenSummePart2 + frmDM.ZQueryDrucken.FieldByName('Summe_dieses_Jahr').aslongint;

                            TwoColReportData[FRow].Col2 := IntToCurrency(speicher);
                            Col2SummePart2              := Col2SummePart2         + speicher;
                            Col2ZwischenSummePart2      := Col2ZwischenSummePart2 + speicher;
                          end;
                      frmDM.ZQueryDrucken.Next;
                    end;

                  AddLine(sBereich, IntToCurrency(Col1ZwischenSummePart2), IntToCurrency(Col2ZwischenSummePart2), footer2); //ZwischenAbschluss Part 2
                  AddLine('', '', '', blank); //Leerzeile

                  frmDM.ZQueryDrucken.Close;
                end;
            end;

          AddLine('Ausgaben gesamt', IntToCurrency(Col1SummePart2), IntToCurrency(Col2SummePart2), footer);  //Abschluss Part 2
          AddLine('', '', '', blank); //Leerzeile
          AddLine('Differenz Einnahmen-Ausgaben', IntToCurrency(Col1SummePart1+Col1SummePart2), '', footer3);  //Differenz Einnahmen-Ausgaben
          AddLine('', '', '', blank); //Leerzeile


          frmDM.ZQueryDrucken.Close;
          sLastSachkontoNr := '';

          if Druckmode in [Summenliste, Haushaltsplan] then
            begin
              AddLine('', '', '', blank); //Leerzeile
              AddLine('Durchgang Einzahlungen', inttostr(ediBuchungsjahr.value), inttostr(ediBuchungsjahr.value-1), header); //Überschrift Part 3

              //Part 3 Durchgang Einzahlungen
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenJournalDurchgang.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', '' + sFilterWhere, [rfReplaceAll]);
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
                              AddLine('('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(0), IntToCurrency(0), line);  //Neues Sachkonto, neue Zeile
                              sLastSachkontoNr   := sSachkontoNr;
                              Col1LineSummePart3 := 0;
                              Col2LineSummePart3 := 0;
                            end;
                        if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = ediBuchungsjahr.value
                          then
                            begin
                              Col1SummePart3     := Col1SummePart3     + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              Col1LineSummePart3 := Col1LineSummePart3 + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              TwoColReportData[FRow].Col1 := IntToCurrency(Col1LineSummePart3);
                            end
                          else
                            begin
                              Col2SummePart3     := Col2SummePart3     + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              Col2LineSummePart3 := Col2LineSummePart3 + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              TwoColReportData[FRow].Col2 := IntToCurrency(Col2LineSummePart3);
                            end;
                      end;
                  frmDM.ZQueryDrucken.Next;
                end;

              AddLine('Durchgang Einzahlungen gesamt', IntToCurrency(Col1SummePart3), IntToCurrency(Col2SummePart3), footer);  //Abschluss Part 3
              AddLine('', '', '', blank); //Leerzeile

              frmDM.ZQueryDrucken.First;
              sLastSachkontoNr := '';

              //Part 3b Durchgang Weiterleitungen
              AddLine('Durchgang Weiterleitungen', inttostr(ediBuchungsjahr.value), inttostr(ediBuchungsjahr.value-1), header); //Überschrift Part 3b

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
                              AddLine('('+sSachkontoNr+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(0), IntToCurrency(0), line); //Neues Sachkonto, neue Zeile
                              sLastSachkontoNr    := sSachkontoNr;
                              Col1LineSummePart3b := 0;
                              Col2LineSummePart3b := 0;
                            end;
                        if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = ediBuchungsjahr.value
                          then
                            begin
                              Col1SummePart3b     := Col1SummePart3b     + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              Col1LineSummePart3b := Col1LineSummePart3b + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              TwoColReportData[FRow].Col1 := IntToCurrency(Col1LineSummePart3b);
                            end
                          else
                            begin
                              Col2SummePart3b     := Col2SummePart3b + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              Col2LineSummePart3b := Col2LineSummePart3b + frmDM.ZQueryDrucken.FieldByName('Betrag').aslongint;
                              TwoColReportData[FRow].Col2 := IntToCurrency(Col2LineSummePart3b);
                            end;
                      end;
                  frmDM.ZQueryDrucken.Next;
                end;

              AddLine('Durchgang Weiterleitungen gesamt', IntToCurrency(Col1SummePart3b), IntToCurrency(Col2SummePart3b), footer);  //Abschluss Part 3b
              AddLine('', '', '', blank); //Leerzeile
              if (Col1SummePart3+Col1SummePart3b <> 0) then
                begin
                  AddLine('Offene Weiterleitungen', IntToCurrency(Col1SummePart3+Col1SummePart3b), '', footer3);  //Abschluss Part 3b
                  AddLine('', '', '', blank); //Leerzeile
                end;
              AddLine('', '', '', blank); //Leerzeile

              frmDM.ZQueryDrucken.Close;
              sLastSachkontoNr := '';

              //Part 4 Kassenstände
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenBanken.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
              frmDM.ZQueryDrucken.Open;
              AddLine('Kassenstände', '', '', header);  //Überschrift Part 4

              if cbDatum.Checked
                then
                  begin
                    //Daten Part 4 1. Durchgang "Normale Buchungen"
                    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenBankenUmsatz.sql');
                    frmDM.ZQueryHelp.ParamByName('BJAHR').AsInteger := ediBuchungsjahr.value;
                    frmDM.ZQueryHelp.ParamByName('DAT').AsString    := FormatDateTime('yyyy-mm-dd',DateTimePickerVon.Date-1);
                    frmDM.ZQueryHelp.Open;

                    frmDM.ZQueryHelp1.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenBankenUmsatz.sql');
                    frmDM.ZQueryHelp1.ParamByName('BJAHR').AsInteger := ediBuchungsjahr.value;
                    frmDM.ZQueryHelp1.ParamByName('DAT').AsString    := FormatDateTime('yyyy-mm-dd',DateTimePickerBis.Date);
                    frmDM.ZQueryHelp1.Open;

                    TwoColReportData[FRow].Col1 := DatetoStr(DateTimePickerBis.Date);
                    TwoColReportData[FRow].Col2 := DatetoStr(DateTimePickerVon.Date-1);

                    nSaveRow := FRow;
                    while not frmDM.ZQueryDrucken.EOF do
                      begin
                        AddLine('('+inttostr(frmDM.ZQueryDrucken.FieldByName('KontoNr').AsLongint)+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString, '', '', line);

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
                        //Daten nur zwischenspeichern
                        TwoColReportData[FRow].Col1 := IntToStr(Col1Summe);
                        TwoColReportData[FRow].Col2 := IntToStr(Col2Summe);
                        Col1SummePart4 := Col1SummePart4 + Col1Summe;
                        Col2SummePart4 := Col2SummePart4 + Col2Summe;
                        frmDM.ZQueryDrucken.Next;
                      end;

                    frmDM.ZQueryHelp.close;
                    frmDM.ZQueryHelp1.close;

                    //Daten Part 4 2. Durchgang "Umbuchungen"
                    frmDM.ZQueryHelp.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenBankenUmsatz2.sql');
                    frmDM.ZQueryHelp.ParamByName('BJAHR').AsInteger := ediBuchungsjahr.value;
                    frmDM.ZQueryHelp.ParamByName('DAT').AsString    := FormatDateTime('yyyy-mm-dd',DateTimePickerVon.Date-1);
                    frmDM.ZQueryHelp.Open;

                    frmDM.ZQueryHelp1.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenBankenUmsatz2.sql');
                    frmDM.ZQueryHelp1.ParamByName('BJAHR').AsInteger := ediBuchungsjahr.value;
                    frmDM.ZQueryHelp1.ParamByName('DAT').AsString    := FormatDateTime('yyyy-mm-dd',DateTimePickerBis.Date);
                    frmDM.ZQueryHelp1.Open;

                    FRow := nSaveRow;
                    frmDM.ZQueryDrucken.First;
                    while not frmDM.ZQueryDrucken.EOF do
                      begin
                        inc(FRow);
                        Col1Summe := 0;
                        Col2Summe := 0;
                        if frmDM.ZQueryDrucken.FieldByName('KontoNr').AsLongint = frmDM.ZQueryHelp1.FieldByName('Konto_nach').AsLongint
                          then
                            begin
                              Col1Summe := frmDM.ZQueryHelp1.FieldByName('Summe').AsLongint;
                              frmDM.ZQueryHelp1.Next;
                            end;
                        if frmDM.ZQueryDrucken.FieldByName('KontoNr').AsLongint = frmDM.ZQueryHelp.FieldByName('Konto_nach').AsLongint
                          then
                            begin
                              Col2Summe := frmDM.ZQueryHelp.FieldByName('Summe').AsLongint;
                              frmDM.ZQueryHelp.Next;
                            end;

                        //Endgültige Werte speichern
                        TwoColReportData[FRow].Col1 := IntToCurrency(Col1Summe+Strtoint(TwoColReportData[FRow].Col1));
                        TwoColReportData[FRow].Col2 := IntToCurrency(Col2Summe+Strtoint(TwoColReportData[FRow].Col2));

                        Col1SummePart4 := Col1SummePart4 + Col1Summe;
                        Col2SummePart4 := Col2SummePart4 + Col2Summe;
                        frmDM.ZQueryDrucken.Next;
                      end;

                    frmDM.ZQueryHelp.close;
                    frmDM.ZQueryHelp1.close;
                  end
                else
                  begin
                    TwoColReportData[FRow].Col1 := inttostr(ediBuchungsjahr.value);
                    TwoColReportData[FRow].Col2 := '31.12.'+inttostr(ediBuchungsjahr.value-1);
                    //Daten Part 4
                    while not frmDM.ZQueryDrucken.EOF do
                      begin
                        AddLine('('+inttostr(frmDM.ZQueryDrucken.FieldByName('KontoNr').AsLongint)+') '+frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Kontostand').AsLongint), IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint), line);
                        Col1SummePart4 := Col1SummePart4 + frmDM.ZQueryDrucken.FieldByName('Kontostand').AsLongint;
                        Col2SummePart4 := Col2SummePart4 + frmDM.ZQueryDrucken.FieldByName('Anfangssaldo').AsLongint;
                        frmDM.ZQueryDrucken.Next;
                      end;
                  end;

              frmDM.ZQueryDrucken.Close;

              AddLine('Summe Kassenstände', IntToCurrency(Col1SummePart4), IntToCurrency(Col2SummePart4), footer);  //Abschluss Part 4
              AddLine('Differenz zum Vorjahr', IntToCurrency(Col1SummePart4 - Col2SummePart4), '', footer3);
              AddLine('', '', '', blank); //Leerzeile

              //Part 5 Ergebniss
              AddLine('Ergebnis', inttostr(ediBuchungsjahr.value), '', header);   //Überschrift Part 5
              AddLine('Anfangsbestand',             IntToCurrency(Col2SummePart4), '', line); //Daten Part 5
              AddLine('Einnahmen',                  IntToCurrency(Col1SummePart1), '', line);
              AddLine('Ausgaben',                   IntToCurrency(Col1SummePart2), '', line);
              AddLine('Delta bei Durchgangskonten', IntToCurrency(Col1SummePart3+Col1SummePart3b), '', line);
              AddLine('Endbestand',                 IntToCurrency(Col2SummePart4+Col1SummePart1+Col1SummePart2+Col1SummePart3+Col1SummePart3b), '', footer);
              AddLine('Differenz zum Vorjahr',      IntToCurrency(Col1SummePart1+Col1SummePart2+Col1SummePart3+Col1SummePart3b), '', footer3);
              AddLine('', '', '', blank); //Leerzeile
            end;

          if Druckmode in [Summenliste] then
            begin
              //Part 6 Umbuchungen
              AddLine('Umbuchungen', '', '', header);  //Überschrift Part 6
              AddLine('nach "Banknr"', '', '', header2);
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenUmbuchungen.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
              frmDM.ZQueryDrucken.Open;
                //Daten Part 6 BankNr
              while not frmDM.ZQueryDrucken.EOF do
                begin
                  AddLine(frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint), '', line);
                  frmDM.ZQueryDrucken.Next;
                end;
              frmDM.ZQueryDrucken.Close;
              AddLine('nach "Konto nach"', '', '', header2);
              frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenUmbuchungen2.sql');
              frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
              frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', sFilterWhere, [rfReplaceAll]);
              frmDM.ZQueryDrucken.Open;
                //Daten Part 6 Konto_Nach
              while not frmDM.ZQueryDrucken.EOF do
                begin
                  AddLine(frmDM.ZQueryDrucken.FieldByName('Name').AsString, IntToCurrency(frmDM.ZQueryDrucken.FieldByName('Summe').aslongint), '', line);
                  frmDM.ZQueryDrucken.Next;
                end;
              frmDM.ZQueryDrucken.Close;
            end;

          AddFilterToReport;

          if Druckmode = Haushaltsplan
            then
              begin
                AddLine('', '', '', blank); //Leerzeile
                AddLine('Legende:', '', '', header);
                AddLine('Positiv', IntToCurrency(200), IntToCurrency(100), line);
                AddLine('Neutral', IntToCurrency(100), IntToCurrency(100), line);
                AddLine('Negativ', IntToCurrency(100), IntToCurrency(200), line);
                AddLine('Unerwartet', IntToCurrency(100), IntToCurrency(0), line);
                AddLine('Ergebnis des Bereiches', '', '', footer3);
              end;

          //Init für Report
          frReport.LoadFromFile(sAppDir+'module\Reporte\SummenlisteDrucken1Part2Cols.lrf');
          FRowPart1 := FRow;
          FRow := 0;
          FCol := 0;
          frReport.Dataset := nil;
        end;
    end;

    if CallDesigner
      then frReport.DesignReport
      else if CSV_Export
        then
          begin
            //CSV Export
            frmMain.slHelp.Clear;
            for i := 0 to FRowPart1 do
              frmMain.slHelp.Add(UTF8toCP1252(TwoColReportData[i].Name)+';'+
                                 TwoColReportData[i].Col1+';'+
                                 TwoColReportData[i].Col2);
            case Druckmode of
              BeitragslisteSK:                sFileName := 'BeitragslisteSK.csv';
              EinAus:                         sFileName := 'EinAus.csv';
              Haushaltsplan:                  sFileName := 'Haushaltsplan.csv';
              JournalNachBankenGruppiert:     sFileName := 'JournalNachBankenGruppiert.csv';
              JournalNachSachkontenGruppiert: sFileName := 'JournalNachSachkontenGruppiert.csv';
              Summenliste:                    sFileName := 'Summenliste.csv';
              Zahlungsliste:                  sFileName := 'Zahlungsliste.csv';
              else                            sFileName := 'Ausgabe.csv';
            end;
            sFileName := sPrintPath+sFileName;
            try
              frmMain.slHelp.SaveToFile(sFileName);
              frmMain.slHelp.Clear;
               if MessageDlg(Inttostr(FRowPart1)+' Zeilen exportiert in Datei '+sFileName+#13+
                          'Sollen Sie angezeigt werden?', mtConfirmation, [mbYes, mbNo],0)= mrYes
                 then opendocument(sFileName);
            except
              on E : Exception do
                begin
                  Screen.Cursor := crDefault;
                  LogAndShowError('Fehler beim Schreiben der Datei: '+sFileName+#13#13+E.ClassName+ ': '+ E.Message);
                end;
            end;
          end
        else
          begin
            if Printer.PrinterIndex <> cbDrucker.ItemIndex
              then
                begin
                  frReport.ChangePrinter(Printer.PrinterIndex, cbDrucker.ItemIndex);
                  Printer.PrinterIndex := cbDrucker.ItemIndex;
                end;
            if cbDruckeDirekt.Checked
              then
                begin
                  case Druckmode of
                    Bankenliste:                    Printer.FileName:='Bankenliste.pdf';
                    BeitragslisteSK:                Printer.FileName:='Beitragsliste.pdf';
                    EinAus:                         Printer.FileName:='EinAus.pdf';
                    Haushaltsplan:                  Printer.FileName:='Haushaltsplan.pdf';
                    Finanzbericht:                  Printer.FileName:='Finanzbericht.pdf';
                    Journal:                        Printer.FileName:='Journal.pdf';
                    JournalGefiltert:               Printer.FileName:='JournalGefiltert.pdf';
                    JournalKompaktGefiltert:        Printer.FileName:='JournalKompaktGefiltert.pdf';
                    JournalNachBankenGruppiert:     Printer.FileName:='JournalNachBankenGruppiert.pdf';
                    JournalNachSachkontenGruppiert: Printer.FileName:='JournalNachSachkontenGruppiert.pdf';
                    Personenliste:                  Printer.FileName:='Personenliste.pdf';
                    PersonenlisteKompakt:           Printer.FileName:='PersonenlisteKompakt.pdf';
                    Sachkontenliste:                Printer.FileName:='Sachkontenliste.pdf';
                    Summenliste:                    Printer.FileName:='Summenliste.pdf';
                    Zahlungsliste:                  Printer.FileName:='Zahlungsliste.pdf';
                    Zuwendung:                      Printer.FileName:='Zuwendung'+inttostr(ediBuchungsjahr.value)+'.pdf';
                    else                            Printer.FileName:='Ausgabe.pdf';
                  end;
                  Printer.Title    := Printer.FileName;
                  Printer.FileName := sPrintPath+Printer.FileName;
                  if einzeln
                    then
                      begin
                        if Druckmode = Zuwendung
                          then
                            begin
                              frmDM.ZQueryHelp.SQL.Text:='Select * from Personen where PersonenID IN (select PersonenID from Journal where (BuchungsJahr = :BJahr) and (PersonenID <> 0) and (not (PersonenID isnull)) group by PersonenID Order by PersonenID) Order by PersonenID';
                              frmDM.ZQueryHelp.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
                              frmDM.ZQueryHelp.Open;
                              frmDM.ZQueryHelp.last; //für RecordCount
                              frmProgress.ProgressBar.Max:=frmDM.ZQueryHelp.RecordCount;
                              frmProgress.ProgressBar.Position:=0;
                              frmProgress.labMessage.Caption:='Bescheinigungen';
                              frmProgress.Show;
                              frmProgress.Top:=frmDrucken.Top;
                              frmDM.ZQueryHelp.first;
                              while not frmDM.ZQueryHelp.EOF do
                                begin
                                  frmProgress.ProgressBar.Position := frmDM.ZQueryHelp.RecNo;
                                  Printer.FileName:=sPrintPath+'Zuwendung_'+ediBuchungsjahr.Text+'_'+
                                                   frmDM.ZQueryHelp.FieldByName('Nachname').AsString+'_'+
                                                   frmDM.ZQueryHelp.FieldByName('Vorname').AsString+'_'+
                                                   frmDM.ZQueryHelp.FieldByName('PersonenID').AsString+'.pdf';
                                  frmDM.ZQueryDrucken.Close;

                                  frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\ZuwendungDrucken.sql');
                                  frmDM.ZQueryDrucken.ParamByName('BJAHR').AsString := inttostr(ediBuchungsjahr.value);
                                  frmDM.ZQueryDrucken.SQL.Text:=StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':ADDWHERE', 'and journal.PersonenID = '+frmDM.ZQueryHelp.FieldByName('PersonenID').AsString, [rfReplaceAll]);
                                  frmDM.ZQueryDrucken.Open;
                                  frReport.ShowProgress:=false;
                                  if frReport.PrepareReport
                                    then
                                      begin
                                        if frReport.EMFPages.Count > 1
                                          then
                                            begin
                                              frReport.ShowProgress:=true;
                                              frReport.PrintPreparedReport('1-'+IntToStr(frReport.EMFPages.Count),1);
                                            end;
                                      end;
                                  frmDM.ZQueryHelp.Next;
                                end;

                              frmDM.ZQueryHelp.Close;
                              frReport.ShowProgress:=true;
                              frmProgress.Close;
                              MessageDlg('Alle Bescheinigungen wurden erzeugt'#13+'Ausgabe in: '+sPrintPath, mtInformation, [mbOK],0);
                            end
                          else
                            begin
                              MessageDlg('Druckmodus nicht implementiert', mtError, [mbOK],0);
                            end;
                      end
                    else
                      begin
                        if frReport.PrepareReport then
                          frReport.PrintPreparedReport('1-'+IntToStr(frReport.EMFPages.Count),1);
                      end;
                end
              else
                begin
                  frReport.ShowReport;
                end;
          end;
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
  PreparePrint();
end;

procedure TfrmDrucken.btnFinanzberichtClick(Sender: TObject);
begin
  Druckmode := Finanzbericht;
  PreparePrint();
end;

procedure TfrmDrucken.btnBankenlisteClick(Sender: TObject);
begin
  Druckmode := BankenListe;
  PreparePrint();
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
  PreparePrint();
end;

procedure TfrmDrucken.btnEinAusCSVClick(Sender: TObject);
begin
  Druckmode := EinAus;
  PreparePrint(false, true, false);
end;

procedure TfrmDrucken.btnJournalNachBankenGruppiertCSVClick(Sender: TObject);
begin
  Druckmode := JournalNachBankenGruppiert;
  PreparePrint(false, true, false);
end;

procedure TfrmDrucken.btnJournalNachBankenGruppiertdruckClick(Sender: TObject);
begin
  Druckmode := JournalNachBankenGruppiert;
  PreparePrint();
end;

procedure TfrmDrucken.btnJournalNachBankenGruppiertdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalNachBankenGruppiert;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournalNachSachkontenGruppiertCSVClick(Sender: TObject);
begin
  Druckmode := JournalNachSachkontenGruppiert;
  PreparePrint(false, true, false);
end;

procedure TfrmDrucken.btnJournalFilteredClick(Sender: TObject);
begin
  Druckmode := JournalGefiltert;
  PreparePrint();
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
  PreparePrint();
end;

procedure TfrmDrucken.btnJournalKompaktFilteredContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalKompaktGefiltert;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnJournalNachSachkontenGruppiertdruckClick(Sender: TObject);
begin
  Druckmode := JournalNachSachkontenGruppiert;
  PreparePrint();
end;

procedure TfrmDrucken.btnJournalNachSachkontenGruppiertdruckContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := JournalNachSachkontenGruppiert;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnMonatlicheZahlungenClick(Sender: TObject);
begin
  frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\MonatlicheZahlungenSK.sql');
  frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
  frmDM.ZQueryDrucken.Open;
  ExportQueToCSVFile(frmDM.ZQueryDrucken, sPrintPath+'MonatlicheZahlungenSK.csv', ';', '"', true, false, false);
  frmDM.ZQueryDrucken.Close;
end;

procedure TfrmDrucken.btnZahlerlisteClick(Sender: TObject);
begin
  Druckmode := Zahlungsliste;
  PreparePrint();
end;

procedure TfrmDrucken.btnBeitragslisteClick(Sender: TObject);
begin
  Druckmode := BeitragslisteSK;
  PreparePrint();
end;

procedure TfrmDrucken.btnBeitragslisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := BeitragslisteSK;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnBeitragslisteCSVClick(Sender: TObject);
begin
  Druckmode := BeitragslisteSK;
  PreparePrint(false, true, false);
end;

procedure TfrmDrucken.btnDurchgangClick(Sender: TObject);

type
  T3ColReport =  record
    Name      : string;
    KontoNr   : integer;
    EinBetrag : Longint;
    AusBetrag : Longint;
  end;

var
  FileName : String;
  Daten    : array[0..9999] of T3ColReport;
  sHelp    : String;
  nHelp    : integer;
  error    : boolean;

begin
  Error := false;
  FileName := sPrintPath+'DurchgangUebersicht.csv';

  for nHelp := 0 to 9999 do
    begin
      Daten[nHelp].EinBetrag := 0;
      Daten[nHelp].AusBetrag := 0;
      Daten[nHelp].KontoNr   := 0;
      Daten[nHelp].Name      := '';
    end;

  frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\SummenlisteDruckenJournalDurchgang.sql');
  frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
  frmDM.ZQueryDrucken.SQL.Text := StringReplace(frmDM.ZQueryDrucken.SQL.Text, ':AddWhere', '', [rfReplaceAll]);
  frmDM.ZQueryDrucken.Open;
  while not frmDM.ZQueryDrucken.EOF do
    begin
      //Zwichenspeichern
      if frmDM.ZQueryDrucken.FieldByName('BuchungsJahr').AsInteger = ediBuchungsjahr.value
        then
          begin
            nHelp := frmDM.ZQueryDrucken.FieldByName('Sortpos').AsInteger;
            Daten[nHelp].Name    := frmDM.ZQueryDrucken.FieldByName('Name').AsString;
            Daten[nHelp].KontoNr := frmDM.ZQueryDrucken.FieldByName('konto_nach').AsInteger;
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
    frmMain.slHelp.Clear;
    //Header
    frmMain.slHelp.Add('"Konto";"KontoNr";"Einnahme";"Weiterleitung";"Differenz"');
    //Daten
    for nHelp := 0 to 9999 do
      begin
        if Daten[nHelp].Name <> ''
          then
            begin
              frmMain.slHelp.Add('"'+UTF8toCP1252(DeleteChar(Daten[nHelp].Name, '"'))+'";"'+
                                 inttostr(Daten[nHelp].KontoNr)+'";'+
                                 IntToCurrency(Daten[nHelp].EinBetrag)+';'+
                                 IntToCurrency(Daten[nHelp].AusBetrag)+';'+
                                 IntToCurrency(Daten[nHelp].EinBetrag+Daten[nHelp].AusBetrag));
            end;
      end;
    frmMain.slHelp.SaveToFile(Filename);
  except
    on E : Exception do
      begin
        Showmessage('Fehler beim Schreiben der Datei: '+Filename+#13#13+E.ClassName+ ': '+ E.Message);
        Error := true;
      end;
  end;

  if not Error
    then
      begin
        showmessage('Datei "'+FileName+'" erstellt');
        opendocument(FileName);
      end;
end;

procedure TfrmDrucken.btnFinanzberichtContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Finanzbericht;
  PreparePrint(true);
  Handled := true;
end;

procedure TfrmDrucken.btnHaushaltsplanClick(Sender: TObject);
begin
  Druckmode := Haushaltsplan;
  PreparePrint();
end;

procedure TfrmDrucken.btnHaushaltsplanCSVClick(Sender: TObject);
begin
  Druckmode := Haushaltsplan;
  PreparePrint(false, true, false);
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
  PreparePrint();
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
  PreparePrint();
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
  PreparePrint();
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

procedure TfrmDrucken.btnZahlerlisteCSVClick(Sender: TObject);
begin
  Druckmode := Zahlungsliste;
  PreparePrint(false, true, false);
end;

procedure TfrmDrucken.btnZahlerMonatlicheZahlungenClick(Sender: TObject);
begin
  frmDM.ZQueryDrucken.SQL.LoadFromFile(sAppDir+'module\SQL\MonatlicheZahlungen.sql');
  frmDM.ZQueryDrucken.ParamByName('BJahr').AsInteger := ediBuchungsjahr.value;
  frmDM.ZQueryDrucken.Open;
  ExportQueToCSVFile(frmDM.ZQueryDrucken, sPrintPath+'Zahler_Monatliche_Zahlungen.csv', ';', '"', true, false, false);
  frmDM.ZQueryDrucken.Close;
end;

procedure TfrmDrucken.btnZuwendungsbescheinigungenClick(Sender: TObject);
begin
  Druckmode := Zuwendung;
  PreparePrint();
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
  PreparePrint();
end;

procedure TfrmDrucken.btnSummenlisteContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Druckmode := Summenliste;
  PreparePrint(true);
  Handled   := true;
end;

procedure TfrmDrucken.btnZuwendungsbescheinigungenEinzelnClick(Sender: TObject);
begin
  Druckmode := Zuwendung;
  cbDruckeDirekt.Checked:=true;
  PreparePrint(false, false, true);
end;

procedure TfrmDrucken.btnZuwendungsbescheinigungenMailClick(Sender: TObject);
var
  slNamen,
  slMail,
  slPasswort,
  Content,
  Attach      : TStringList;
  sName,
  sMessage,
  sErgebnis,
  sHelp,
  sFileNameHelp,
  sfileName   : String;
  i,j         : integer;
  SMTP        : TMySMTPSend;

begin
  try
    slNamen   := TStringlist.Create;
    slMail    := TStringlist.Create;
    slPasswort:= TStringlist.Create;
    Content   := TStringList.Create;
    Attach    := TStringList.Create;
    SMTP      := TMySMTPSend.Create;
    sErgebnis := '';

    Content.Add('Hallo, '#13#13+
                'hier kommt Ihre Zuwendungsbescheinigung!'#13#13+
                'Aus Datenschutzgründen ist die Bescheinigung in einer passwortgeschützen Datei. Das Passwort ist ihr Geburtsdatum in der Form TT.MM.JJJJ oder ihre PLZ. Falls wir ihre Daten nicht kennen, können sie das alternative Passwort bei mir erfragen.'#13#13+
                'Mit freundlichen Grüßen'#13+
                frmMain.LabRendant1.Caption);

    SMTP.TargetHost       := sEMailServer;
    SMTP.TargetPort       := sEMailPort;
    SMTP.Username         := sEMailUsername;
    SMTP.Password         := sEMailServerPassWort;
    SMTP.FullSSL          := True;
    SMTP.Sock.RaiseExcept := True;

    //ermitteln für welche Personen gibt es eine EMail Adresse
    frmDM.ZQueryHelp.SQL.Text:='Select * from Personen where eMail <> "" Order by Nachname, Vorname, PersonenID';
    frmDM.ZQueryHelp.Open;
    frmDM.ZQueryHelp.First;
    while not frmDM.ZQueryHelp.EOF do
      begin
        sName := frmDM.ZQueryHelp.FieldByName('Nachname').AsString+'_'+
                 frmDM.ZQueryHelp.FieldByName('Vorname').AsString+'_'+
                 frmDM.ZQueryHelp.FieldByName('PersonenID').AsString;
        sfileName      := sPrintPath+'Zuwendung_'+ediBuchungsjahr.Text+'_'+sName+'.pdf';
        sfileNameHelp  := 'Zuwendung_'+ediBuchungsjahr.Text+'_'+sName;
        //und gibt es eine Zuwendungsbescheinigung?
        if FileExists(sfileName)
          then
            begin
              //Zip Datei aus PDF erstellen
              with CreateOutArchive(CLSID_CFormatZip) do
                begin
                  AddFile(sfileName, sFileNameHelp+'.pdf');
                  if frmDM.ZQueryHelp.FieldByName('Geburtstag').AsString <> ''
                    then sHelp := frmDM.ZQueryHelp.FieldByName('Geburtstag').AsString
                    else if frmDM.ZQueryHelp.FieldByName('PLZ').AsString <> ''
                      then sHelp := frmDM.ZQueryHelp.FieldByName('PLZ').AsString
                      else sHelp := 'Bescheinigung';
                  SetPassword(sHelp);
                  SaveToFile(sPrintPath+sFileNameHelp+'.zip');
                end;
              slNamen.Add(sName);
              slMail.Add(frmDM.ZQueryHelp.FieldByName('eMail').AsString);
              slPasswort.Add(sHelp);
            end;
        frmDM.ZQueryHelp.Next;
      end;
    frmDM.ZQueryHelp.Close;
    //MessageDlg('Namen', slNamen.Text, mtInformation, [mbOK], 0);
    //MessageDlg('eMail', slMail.Text, mtInformation, [mbOK], 0);
    //MessageDlg('Passwort', slMail.Text, mtInformation, [mbOK], 0);
    if slNamen.Count > 0
      then
        begin
          frmFreieListe.SrcList.Items.Text := slNamen.Text;
          frmFreieListe.DstList.Items.Clear;
          frmFreieListe.Caption          := 'Personen auswählen.';
          frmFreieListe.SrcLabel.Caption :='Namen';
          frmFreieListe.DstLabel.Caption :='zu versenden';
          frmFreieListe.rbCSV.Visible    := false;
          frmFreieListe.rbFix.Visible    := false;
          if frmFreieListe.ShowModal = mrOK
            then
              begin
                if frmFreieListe.DstList.Items.Count = 0
                  then Showmessage('Keine Namen gewählt')
                  else
                    begin
                      screen.cursor := crhourglass;
                      //MessageDlg('Namen', frmFreieListe.DstList.Items.Text, mtInformation, [mbOK], 0);
                      frmProgress.ProgressBar.Max:=frmFreieListe.DstList.Items.Count-1;
                      frmProgress.ProgressBar.Position:=0;
                      frmProgress.labMessage.Caption:='Bescheinigungen';
                      frmProgress.Show;
                      frmProgress.Top:=frmDrucken.Top;
                      for i := 0 to frmFreieListe.DstList.Items.Count-1 do
                        begin
                          frmProgress.ProgressBar.Position:=i;
                          j := slNamen.IndexOf(frmFreieListe.DstList.Items[i]);
                          //MessageDlg('Mail', slMail.Strings[j], mtInformation, [mbOK], 0);
                          Attach.Clear;
                          Attach.Add(sPrintPath+'Zuwendung_'+ediBuchungsjahr.Text+'_'+frmFreieListe.DstList.Items[i]+'.zip');
                          try
                            if SMTP.SendMessage( frmMain.LabRendant1.Caption+' <'+sRendantEMail+'>',     // AFrom
                                                 slMail.Strings[j], // ATo
                                                 'Zuwendungsbescheinigung der '+sGemeindeName+' für das Jahr '+ediBuchungsjahr.Text, // ASubject
                                                 Content,
                                                 Attach)
                              then
                                begin
                                  sMessage  := 'Erfolgreich: Sende Mail zu '+slMail.Strings[j]+' mit der Datei: '+RemoveLastCRLF(Attach.Text)+
                                               '. Passwort: '+slPasswort.Strings[j];
                                  sErgebnis := sErgebnis + sMessage + #13#10;
                                  myDebugLN(sMessage);
                                  RenameFile(sPrintPath+'Zuwendung_'+ediBuchungsjahr.Text+'_'+frmFreieListe.DstList.Items[i]+'.pdf',
                                             sPrintPath+'Versendet\Zuwendung_'+ediBuchungsjahr.Text+'_'+frmFreieListe.DstList.Items[i]+'.pdf');
                                  RenameFile(sPrintPath+'Zuwendung_'+ediBuchungsjahr.Text+'_'+frmFreieListe.DstList.Items[i]+'.zip',
                                             sPrintPath+'Versendet\Zuwendung_'+ediBuchungsjahr.Text+'_'+frmFreieListe.DstList.Items[i]+'.zip');
                                end
                              else
                                begin
                                  sMessage  := 'Fehler: Sende Mail zu '+slMail.Strings[j]+' mit der Datei: '+Attach.Text;
                                  sErgebnis := sErgebnis + sMessage + #13#10 + SMTP.FullResult.Text + #13#10;
                                  myDebugLN(sMessage);
                                  myDebugLN(SMTP.FullResult.Text);
                                end;
                          except
                            on E: Exception do
                              begin
                                sMessage := 'EXCEPTION: '+ E.Message;
                                //MessageDlg('Fehler', sMessage, mtError, [mbOK], 0);
                                sErgebnis := sErgebnis + sMessage + #13#10;
                              end;
                          end;
                          application.ProcessMessages;
                        end;
                      frmProgress.Close;
                      screen.cursor := crDefault;
                      frmAusgabe.SetDefaults('Ergebnisse des EMailversandes',
                                             frmFreieListe.DstList.Items.Count.ToString+' Bescheinigungen versucht zu versenden'#13+sErgebnis,
                                             '', '', 'Schliessen', false);
                      frmAusgabe.ShowModal;
                    end;
              end;
        end
      else
        begin
          MessageDlg('Fehler', 'Keine EMail - Zuwendungsbescheinigungs Paare gefunden', mtError, [mbOK], 0);
        end;
  finally
    slNamen.Free;
    slMail.Free;
    slPasswort.Free;
    Content.Free;
    Attach.free;
    SMTP.Free;
  end;
end;

procedure TfrmDrucken.btnZuwendungsbescheinigungenMailContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  slNamen     : TStringList;
  sName,
  sfileName   : String;

begin
  try
    slNamen   := TStringlist.Create;

    //ermitteln für welche Personen gibt es keine EMail Adresse
    frmDM.ZQueryHelp.SQL.Text:='Select * from Personen where eMail = "" Order by Nachname, Vorname, PersonenID';
    frmDM.ZQueryHelp.Open;
    frmDM.ZQueryHelp.First;
    while not frmDM.ZQueryHelp.EOF do
      begin
        sName := frmDM.ZQueryHelp.FieldByName('Nachname').AsString+'_'+
                 frmDM.ZQueryHelp.FieldByName('Vorname').AsString+'_'+
                 frmDM.ZQueryHelp.FieldByName('PersonenID').AsString;
        sfileName := sPrintPath+'Zuwendung_'+ediBuchungsjahr.Text+'_'+sName+'.pdf';
        //und gibt es eine Zuwendungsbescheinigung?
        if FileExists(sfileName) then slNamen.Add(sName);
        frmDM.ZQueryHelp.Next;
      end;
    frmDM.ZQueryHelp.Close;
    //MessageDlg('Namen', slNamen.Text, mtInformation, [mbOK], 0);
    if slNamen.Count > 0
      then
        begin
          frmAusgabe.SetDefaults('Bescheinigungen ohne EMail', slNamen.Text, '', '', 'Schliessen', false);
          frmAusgabe.ShowModal;
        end
      else
        begin
          MessageDlg('Fehler', 'Keine Zuwendungsbescheinigungen gefunden', mtError, [mbOK], 0);
        end;
  finally
    slNamen.Free;
  end;

  Handled := true;
end;

procedure TfrmDrucken.cbDatumChange(Sender: TObject);
begin
  DateTimePickerVon.Enabled := false;
  DateTimePickerBis.Enabled := false;
  shape1.Visible            := (rgFilter.ItemIndex <> 0) or  cbDatum.Checked;
  shape3.Visible            := shape1.Visible;
  if cbDatum.Checked then
    begin
      DateTimePickerVon.Enabled := true;
      DateTimePickerBis.Enabled := true;
      //Zuerst die Grenzen
      DateTimePickerVon.MinDate := StrToDate('01.01.'+inttostr(ediBuchungsjahr.value));
      DateTimePickerVon.MaxDate := StrToDate('31.12.'+inttostr(ediBuchungsjahr.value));
      DateTimePickerBis.MinDate := DateTimePickerVon.MinDate;
      DateTimePickerBis.MaxDate := DateTimePickerVon.MaxDate;
      //dann der Wert
      DateTimePickerVon.Date    := DateTimePickerVon.MinDate;
      DateTimePickerBis.Date    := DateTimePickerVon.MaxDate;
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
  slHelp := TStringlist.Create;
  cbDrucker.Items := Printer.Printers;
  if cbDrucker.Items.Count > 0 then
    cbDrucker.ItemIndex := 0;
end;

procedure TfrmDrucken.FormShow(Sender: TObject);
begin
  Druckmode             := none;
  Seite                 := 1;
  ediBuchungsjahr.Value := nBuchungsjahr;
end;


procedure TfrmDrucken.frReportBeginBand(Band: TfrBand);
begin
  case Druckmode of
    Summenliste,
    JournalNachBankenGruppiert,
    JournalNachSachkontenGruppiert,
    EinAus,
    Haushaltsplan,
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
    JournalNachBankenGruppiert,
    JournalNachSachkontenGruppiert,
    EinAus,
    Haushaltsplan,
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
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Titel', '"Sammelbestätigung über Geldzuwendungen"', true);

          MemoView := frReport.FindObject('memSubTitel') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'SubTitel', '"im Sinne des § 10b des Einkommensteuergesetzes an inländische juristische Personen des öffentlichen Rechts oder inländische öffentliche Dienststellen:"', true);

          MemoView := frReport.FindObject('memFoerderung') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Foerderung', '"Es wird bestätigt, dass die Zuwendung nur zur Förderung kirchlicher Zwecke verwendet wird."', true);
          // 15 pro Zeile
          // Zeilen = Textlänge / 80
          MemoView.Height:=(MemoView.Memo.Text.Length div 80)*15;
          // Zusätzliche Höhe für Zeilenumbruch
          MemoView.Height:=MemoView.Height+15*CountChar(MemoView.Memo.Text, #13);
          BandView := frReport.FindObject('bandMaster') as TfrBandView;
          BandView.Height:=378+MemoView.Height;

          MemoView := frReport.FindObject('memEigene') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Eigene', '"von uns unmittelbar für den angegebenen Zweck verwendet. (Empfänger = [Empfaenger])"' , true);

          MemoView := frReport.FindObject('memEigeneFinanzamt') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'EigeneFinanzamt', '"Finanzamt [EigenesFinanzamt] vom [EigenesFinanzamtVom], StNr.: [EigenesFinanzamtNr]"', true);

          MemoView := frReport.FindObject('memWeiter') as TfrMemoView;
          MemoView.Memo.Text := help.ReadIniVal(sIniFile, 'Zuwendungsbescheinigung', 'Weitergeleitete', '"entsprechend den Angaben des Zuwendenden an [Empfaenger] weitergeleitet, die/der vom Finanzamt [Finanzamt], StNr.: [FinanzamtNr] mit Freistellungsbescheid bzw. nach der Anlage zum Körperschaftsteuerbescheid vom [FinanzamtVom] von der Körperschaftssteuer und Gewerbesteuer befreit ist."', true);
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
    JournalNachBankenGruppiert,
    JournalNachSachkontenGruppiert,
    EinAus,
    Haushaltsplan,
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
                             View.FillColor:=TColor($C0C0C0); //helles Grau
                           end;
                    footer2,
                    header2:begin
                              Font.Style:=[fsbold];
                              View.FillColor:=TColor($E0E0E0); //helleres Grau
                           end;
                    footer3:begin
                              Font.Style:=[fsbold];
                              if Druckmode = Haushaltsplan
                                then View.FillColor:=TColor($F28FA6) //helles Lila
                                else View.FillColor:=clWhite;
                           end;
                    line:  begin
                             Font.Style:=[];
                             if Druckmode = Haushaltsplan then
                               if TwoColReportData[FRow].Col2 = '' then
                                 View.FillColor := clWhite
                               else if (CurrencyToInt(TwoColReportData[FRow].Col1, false) = CurrencyToInt(TwoColReportData[FRow].Col2, false)) then
                                 View.FillColor := clWhite           //Gleich
                               else if CurrencyToInt(TwoColReportData[FRow].Col2, false) = 0 then
                                 View.FillColor := clYellow          //Unerwartet
                               else if ((CurrencyToInt(TwoColReportData[FRow].Col2, false) > 0) and (CurrencyToInt(TwoColReportData[FRow].Col1, false) >= CurrencyToInt(TwoColReportData[FRow].Col2, false))) or
                                       ((CurrencyToInt(TwoColReportData[FRow].Col2, false) < 0) and (CurrencyToInt(TwoColReportData[FRow].Col1, false) >= CurrencyToInt(TwoColReportData[FRow].Col2, false))) then
                                 View.FillColor := clLime            //Besser
                               else if ((CurrencyToInt(TwoColReportData[FRow].Col2, false) > 0) and (CurrencyToInt(TwoColReportData[FRow].Col1, false) < CurrencyToInt(TwoColReportData[FRow].Col2, false))) or
                                       ((CurrencyToInt(TwoColReportData[FRow].Col2, false) < 0) and (CurrencyToInt(TwoColReportData[FRow].Col1, false) < CurrencyToInt(TwoColReportData[FRow].Col2, false))) then
                                 View.FillColor := TColor($008080FF) //Schlechter = leichtes Rot
                               else
                                 View.FillColor:=clWhite
                             else
                               View.FillColor:=clWhite;
                           end;
                    blank: begin
                             Visible:= false;
                           end;
                    end;
                  end;
      end;
    Zuwendung,
    Finanzbericht:
      begin
        if (View.Name='picUnterschrift') then
          begin
            if FileExists(sAppDir+'module\Bilder\unterschrift.png')
              then TFrPictureView(View).Picture.LoadFromFile(sAppDir+'module\Bilder\unterschrift.png')
              else TFrPictureView(View).Picture.Clear;
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
  if      ParName = 'Buchungsjahr' then ParValue := inttostr(ediBuchungsjahr.value)
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
    Finanzbericht:
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
                (t = 'E') or    //Gesamteinnahmen + Positive Werte
                (t = 'A') or    //Gesamtausgaben + Negative Werte
                (t = 'K') or    //Kontosumme   Format: K;81;82....
                (t = 'P') or    //Positive Werte Kontosumme   Format: P;23;24....
                (t = 'N') then  //Negative Werte Kontosumme   Format: N;23;24....
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
                i := GetDBSum(frmDM.ZQueryHelp, 'BankenAbschluss', 'Anfangssaldo', 'left join konten on konten.KontoNr=BankenAbschluss.KontoNr', sWhere+' and BuchungsJahr='+inttostr(ediBuchungsjahr.value));
                nBestand := i;
              end
            else if (t = 'S') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'konten', 'Kontostand', '', sWhere);
              end
            else if (t = 'P') or (t = 'E') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'Journal left join konten on konten.KontoNr=journal.Konto_Nach', 'Betrag', '', sWhere+' and BuchungsJahr='+inttostr(ediBuchungsjahr.value) + ' and (((journal.Betrag > 0) and (konten.Kontotype = "D")) or (konten.Kontotype = "E")) ');
                if (t = 'E') then nEinnahmen := i;
              end
            else if (t = 'N') or (t = 'A') then
              begin
                i := GetDBSum(frmDM.ZQueryHelp, 'Journal left join konten on konten.KontoNr=journal.Konto_Nach', 'Betrag', '', sWhere+' and BuchungsJahr='+inttostr(ediBuchungsjahr.value) + ' and (((journal.Betrag < 0) and (konten.Kontotype = "D")) or (konten.Kontotype = "A")) ');
                if (t = 'A') then nAusgaben := i;
              end
            else
              // K
              i := GetDBSum(frmDM.ZQueryHelp, 'Journal left join konten on konten.KontoNr=journal.Konto_Nach', 'Betrag', '', sWhere+' and BuchungsJahr='+inttostr(ediBuchungsjahr.value));
            ParValue := IntToCurrency(i)+' €'; ;
          end
      end;
    Summenliste,
    JournalNachBankenGruppiert,
    JournalNachSachkontenGruppiert,
    EinAus,
    Haushaltsplan,
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
              Summenliste:                    ParValue := 'Summenliste';
              EinAus:                         ParValue := 'Ein/Ausgaben';
              Haushaltsplan:                  ParValue := 'Haushaltsplan';
              BeitragslisteSK:                ParValue := 'Zahler- / Empfängerliste nach Sachkonto';
              Zahlungsliste:                  ParValue := 'Zahlungsliste';
              JournalNachBankenGruppiert:     ParValue := 'Journal nach Banken gruppiert';
              JournalNachSachkontenGruppiert: ParValue := 'Journal nach Banken gruppiert';
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

procedure TfrmDrucken.mnuSummenlisteCSVExportClick(Sender: TObject);
begin
  Druckmode := Summenliste;
  PreparePrint(false, true);
end;

procedure TfrmDrucken.rgFilterSelectionChanged(Sender: TObject);
begin
  ediFilter.Enabled := false;
  shape3.Visible    := cbDatum.Checked or (rgFilter.ItemIndex <> 0);
  shape1.Visible    := shape3.Visible;
  case rgFilter.ItemIndex of
    1,
    2,
    3,
    4  : begin
           ediFilter.Enabled := true;
           ediFilter.Text    := '';
         end;
  end;
end;

end.

