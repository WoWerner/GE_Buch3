unit Journal_CSV_Import;

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
  ExtCtrls,
  Grids,
  StdCtrls,
  Spin,
  INIFiles,
  Types;

type

  { TfrmJournal_CSV_Import }

  TfrmJournal_CSV_Import = class(TForm)
    btnAbbrechen: TButton;
    btnOK: TButton;
    cbBank: TComboBox;
    DelFrom1: TRadioButton;
    DelFrom2: TRadioButton;
    DelFrom3: TRadioButton;
    DelUntil2: TRadioButton;
    DelUntil3: TRadioButton;
    ediDatumsformat: TEdit;
    ediDelStr2: TEdit;
    ediDelStr3: TEdit;
    ediSollString: TEdit;
    ediSpaltenbegrenzung: TEdit;
    ediDelStr1: TEdit;
    ediTextbegrenzung: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    nBetrag: TSpinEdit;
    nBuchungstext: TSpinEdit;
    nBuchungstextBis: TSpinEdit;
    nKeyPers: TSpinEdit;
    nKeySkBis: TSpinEdit;
    nDatum: TSpinEdit;
    nDEnd: TSpinEdit;
    nDStart: TSpinEdit;
    nHeader: TSpinEdit;
    nKeySK: TSpinEdit;
    nKeyPersBis: TSpinEdit;
    nSollHaben: TSpinEdit;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    DelUntil1: TRadioButton;
    rgFormat: TRadioGroup;
    rgRichtung: TRadioGroup;
    rgSpaltenbegrenzung: TRadioGroup;
    rgTextbegrenzung: TRadioGroup;
    rgZeilenende: TRadioGroup;
    StringGridDaten: TStringGrid;
    procedure btnOKClick(Sender: TObject);
    procedure DeltaDataClick(Sender: TObject);
    procedure ediDatumsformatContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ediDatumsformatExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
    procedure StringGridDatenDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure StringGridDatenSelection(Sender: TObject; aCol, aRow: Integer);
    function GetRowBuchungstext(R: Integer): String;
    function GetRowKeySK(R: Integer): String;
    function GetRowKeyPers(R: Integer): String;
  private
    { private declarations }
    INI: TINIFile;
    ffilename : string;
    bStartup  : boolean;

    function GetRichtung: Integer;
    function GetColDatum: Integer;
    function GetColBetrag: Integer;
    function GetColSollHaben: Integer;
    function GetStrSollHaben: String;
    function GetDatumsformat: String;
    function GetRowStart: Integer;
    function GetRowEnde: Integer;
  public
    { public declarations }
    Property filename           : string      read ffilename write ffilename;
    Property DatenGrid          : TStringGrid read StringGridDaten;
    Property Richtung           : integer     read GetRichtung;
    Property ColDatum           : integer     read GetColDatum;
    Property Datumsformat       : string      read GetDatumsformat;
    Property ColBetrag          : integer     read GetColBetrag;
    Property ColSollHaben       : integer     read GetColSollHaben;
    Property StrSollHaben       : string      read GetStrSollHaben;
    Property RowStart           : integer     read GetRowStart;
    Property RowEnde            : integer     read GetRowEnde;
  end;

var
  frmJournal_CSV_Import: TfrmJournal_CSV_Import;

implementation

uses
  csCSV,
  dm,
  LConvEncoding,
  global,
  math,
  help;

const
  sDefDate : String = 'D.MM.YYYY,DD.M.YYYY,D.M.YYYY,DD.MM.YYYY,'+
                      'D.MM.YY,  DD.M.YY,  D.M.YY,  DD.MM.YY';

{$R *.lfm}

{ TfrmJournal_CSV_Import }

function TfrmJournal_CSV_Import.GetRowBuchungstext(R: Integer): String;

var i : integer;

begin
  result := '';
  if nBuchungstextbis.Value > nBuchungstext.Value then
    begin
      //Bereich definiert: Alle Felder lesen und verknüpfen
      for i := nBuchungstext.Value  to nBuchungstextbis.Value
        do result := result + ' ' + StringGridDaten.Cells[i, R];
      result := trim(result);
    end
  else if (nBuchungstextbis.Value < nBuchungstext.Value) and (nBuchungstextbis.Value <> 0) then
    begin
      //Zweispaltenmodus
      result := StringGridDaten.Cells[nBuchungstextbis.Value, R] + ' ' + StringGridDaten.Cells[nBuchungstext.Value, R];
    end
  else
    begin
      //Nur eine Zelle
      result := StringGridDaten.Cells[nBuchungstext.Value, R];
    end;
end;

function TfrmJournal_CSV_Import.GetRowKeySK(R: Integer): String;

var i : integer;

begin
  result := '';
  if nKeySKBis.Value > nKeySK.Value then
    begin
      //Bereich definiert: Alle Felder lesen und verknüpfen
      for i := nKeySK.Value  to nKeySKBis.Value
        do result := result + ' ' + StringGridDaten.Cells[i, R];
      result := trim(result);
    end
  else if (nKeySKBis.Value < nKeySK.Value) and (nKeySKBis.Value <> 0) then
    begin
      //Zweispaltenmodus
      result := StringGridDaten.Cells[nKeySKBis.Value, R] + ' ' + StringGridDaten.Cells[nKeySK.Value, R];
    end
  else
    begin
      //Nur eine Zelle
      result := StringGridDaten.Cells[nKeySK.Value, R];
    end;
end;

function TfrmJournal_CSV_Import.GetRowKeyPers(R: Integer): String;

var i : integer;

begin
  result := '';
  if nKeyPersBis.Value > nKeyPers.Value then
    begin
      //Bereich definiert: Alle Felder lesen und verknüpfen
      for i := nKeyPers.Value  to nKeyPersBis.Value
        do result := result + ' ' + StringGridDaten.Cells[i, R];
      result := trim(result);
    end
  else if (nKeyPersBis.Value < nKeyPers.Value) and (nKeyPersBis.Value <> 0) then
    begin
      //Zweispaltenmodus
      result := StringGridDaten.Cells[nKeyPersBis.Value, R] + ' ' + StringGridDaten.Cells[nKeyPers.Value, R];
    end
  else
    begin
      //Nur eine Zelle
      result := StringGridDaten.Cells[nKeyPers.Value, R];
    end;
end;

function TfrmJournal_CSV_Import.GetDatumsformat: String;
begin
  Result := ediDatumsformat.text;
end;

function TfrmJournal_CSV_Import.GetRichtung: Integer;
begin
  Result := rgRichtung.ItemIndex;
end;

function TfrmJournal_CSV_Import.GetColDatum: Integer;
begin
  Result := nDatum.Value;
end;

function TfrmJournal_CSV_Import.GetColBetrag: Integer;
begin
  Result := nBetrag.Value;
end;

function TfrmJournal_CSV_Import.GetColSollHaben: Integer;
begin
  Result := nSollHaben.Value;
end;

function TfrmJournal_CSV_Import.GetStrSollHaben: String;
begin
  Result := ediSollString.Text;
end;

function TfrmJournal_CSV_Import.GetRowStart: Integer;
begin
  Result := nDStart.Value;
end;

function TfrmJournal_CSV_Import.GetRowEnde: Integer;
begin
  Result := nDEnd.Value;
end;

procedure TfrmJournal_CSV_Import.DeltaDataClick(Sender: TObject);

Var
  csvReader : TCSVReader;
  sData     : TFileStream;
  i         : integer;
  row       : integer;
  sHelp     : string;

begin
  if not bStartup
    then
      begin
        try
          sData := TFileStream.Create(ffilename,fmOpenRead);
          csvReader := TCSVReader.Create (sData, ';');

          case rgTextbegrenzung.ItemIndex of
            0 : csvReader.Quote := '"';
            1 : csvReader.Quote := '''';
            2 :
              begin
                try
                  csvReader.Quote := ediTextbegrenzung.Text[1];
                Except
                  csvReader.Quote := '?';
                end;
                ediTextbegrenzung.Text := csvReader.Quote;  //Längeren String kürzen und zurückspeichern
              end;
          end;

          Case rgSpaltenbegrenzung.ItemIndex of
            0 : csvReader.Delimiter := ';';
            1 : csvReader.Delimiter := ',';
            2 : csvReader.Delimiter := #9; //Tab
            3 :
              begin
                try
                  csvReader.Delimiter := ediSpaltenbegrenzung.Text[1];
                Except
                  csvReader.Delimiter := '?';
                end;
                ediSpaltenbegrenzung.Text := csvReader.Delimiter;  //Längeren String kürzen und zurückspeichern
              end;
          end;

          Case rgZeilenende.ItemIndex of
            0: begin
                 csvReader.EOLChar   := #13;
                 csvReader.EOLLength := 2;
               end;
            1: begin
                 csvReader.EOLChar   := #10;
                 csvReader.EOLLength := 1;
               end;
            2: begin
                 csvReader.EOLChar   := #13;
                 csvReader.EOLLength := 1;
               end;
          end;

          csvReader.First;
          row                      := 0;
          StringGridDaten.ColCount := 1;
          StringGridDaten.RowCount := 2;

          Try
            While not csvReader.Eof Do
              Begin
                inc(row);
                StringGridDaten.RowCount:=row+1;
                StringGridDaten.Cells[0, row] := inttostr(row);
                if StringGridDaten.ColCount-1 < csvReader.ColumnCount then StringGridDaten.ColCount := csvReader.ColumnCount+1;
                For i:=0 to csvReader.ColumnCount - 1 Do
                  begin
                    sHelp := csvReader.Columns[i];
                    if rgFormat.ItemIndex = 0 then sHelp := CP1252ToUTF8(sHelp); //Ansiformat

                    //z.B. VB Mittelhessen: CRLF als Zeilenende, aber in dem Verwendungszweck nur LF
                    //Wird hier korrigiert
                    sHelp := DeleteChars(shelp, [#10,#13]);
                    StringGridDaten.Cells[i+1, row] := sHelp;
                  end;
                csvReader.Next;
              End;
          Finally
            csvReader.Free;
            sData.Free;
          End;

          For i:=1 to StringGridDaten.ColCount - 1
            do
              begin
                if (i = nDatum.Value) or (i = nBetrag.Value)
                  then StringGridDaten.ColWidths[i] := 100
                  else StringGridDaten.ColWidths[i] := (StringGridDaten.Width-300) div (StringGridDaten.ColCount-3);
              end;

        except
          on E : Exception do
            begin
              LogAndShowError('Fehler beim Öffnen der Datei: '+ffilename+#13#13+E.ClassName+ ': '+ E.Message);
              Self.ModalResult := mrCancel;
            end;
        end;
      end;
end;

procedure TfrmJournal_CSV_Import.ediDatumsformatContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  ediDatumsformat.Text := sDefDate;
  Handled := true;
end;

procedure TfrmJournal_CSV_Import.ediDatumsformatExit(Sender: TObject);
begin
  ediDatumsformat.Hint := ediDatumsformat.Text;
end;


procedure TfrmJournal_CSV_Import.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  WindowState := wsNormal;
end;

procedure TfrmJournal_CSV_Import.btnOKClick(Sender: TObject);
begin
  try
    INI := TINIFile.Create(sJournalCSVImportINI);
    ini.CacheUpdates:=true;  // Erst am Ende alles zusammen schreiben
    // Einstellungen sichern
    INI.WriteInteger('Format','Format',                   rgFormat.ItemIndex);
    INI.WriteInteger('Format','Textbegrenzung',           rgTextbegrenzung.ItemIndex);
    INI.WriteInteger('Format','Spaltenbegrenzung',        rgSpaltenbegrenzung.ItemIndex);
    INI.WriteInteger('Format','Zeilenende',               rgZeilenende.ItemIndex);
    INI.WriteString ('Format','Textbegrenzungsstring',    ediTextbegrenzung.Text);
    INI.WriteString ('Format','Spaltenbegrenzungsstring', ediSpaltenbegrenzung.Text);
    INI.WriteString ('Format','SollHabenString',          ediSollString.Text);
    INI.WriteString ('Format','Datumsformat',             ediDatumsformat.Text);

    INI.WriteInteger('Daten','Header',          nHeader.Value);
    INI.WriteInteger('Daten','Datum',           nDatum.Value);
    INI.WriteInteger('Daten','Buchungstext',    nBuchungstext.Value);
    INI.WriteInteger('Daten','BuchungstextBis', nBuchungstextBis.Value);
    INI.WriteInteger('Daten','KeySK',           nKeySK.Value);
    INI.WriteInteger('Daten','KeySKBis',        nKeySKBis.Value);
    INI.WriteInteger('Daten','KeyPers',         nKeyPers.Value);
    INI.WriteInteger('Daten','KeyPersBis',      nKeyPersBis.Value);
    INI.WriteInteger('Daten','Betrag',          nBetrag.Value);
    INI.WriteInteger('Daten','SollHaben',       nSollHaben.Value);
    INI.WriteInteger('Daten','Richtung',        rgRichtung.ItemIndex);
    INI.WriteBool   ('Daten','LoescheBis1',     DelUntil1.Checked);
    INI.WriteString ('Daten','LoeschStr1',      ediDelStr1.Text);
    INI.WriteBool   ('Daten','LoescheVon1',     DelFrom1.Checked);
    INI.WriteBool   ('Daten','LoescheBis2',     DelUntil2.Checked);
    INI.WriteString ('Daten','LoeschStr2',      ediDelStr2.Text);
    INI.WriteBool   ('Daten','LoescheVon2',     DelFrom2.Checked);
    INI.WriteBool   ('Daten','LoescheBis3',     DelUntil3.Checked);
    INI.WriteString ('Daten','LoeschStr3',      ediDelStr3.Text);
    INI.WriteBool   ('Daten','LoescheVon3',     DelFrom3.Checked);
    INI.WriteInteger('Daten','BankNr',          NativeInt(cbBank.Items.Objects[cbBank.ItemIndex]));
    try
      ini.CacheUpdates:=false; //Damit werden die Änderungen geschrieben
    except
      on e: Exception do
        begin
          LogAndShowError('Fehler beim Speichern'#13+e.Message);
        end;
    end;
  finally
    INI.Free;
  end;
end;

procedure TfrmJournal_CSV_Import.FormShow(Sender: TObject);

var
  i, nHelp : integer;

begin
  // Create the object, specifying the place where it can find the ini file:
  INI := TINIFile.Create(sJournalCSVImportINI);
  // Einstellungen laden
  bStartUp                      := true;
  rgFormat.ItemIndex            := INI.ReadInteger('Format','Format',0);            //Ansi
  rgTextbegrenzung.ItemIndex    := INI.ReadInteger('Format','Textbegrenzung',0);    //Quote "
  rgSpaltenbegrenzung.ItemIndex := INI.ReadInteger('Format','Spaltenbegrenzung',0); //Delimiter ;
  rgZeilenende.ItemIndex        := INI.ReadInteger('Format','Zeilenende',0);        //Windows
  nHeader.Value                 := INI.ReadInteger('Daten' ,'Header',0);            //Kopfzeile
  nDStart.Value                 := nHeader.Value+1;
  nDEnd.Value                   := nHeader.Value+1;
  nDatum.Value                  := INI.ReadInteger('Daten','Datum',0);
  nBetrag.Value                 := INI.ReadInteger('Daten','Betrag',0);
  nSollHaben.Value              := INI.ReadInteger('Daten','SollHaben',0);
  rgRichtung.ItemIndex          := INI.ReadInteger('Daten','Richtung',0);
  ediTextbegrenzung.Text        := INI.ReadString('Format','Textbegrenzungsstring', '?');
  ediSpaltenbegrenzung.Text     := INI.ReadString('Format','Spaltenbegrenzungsstring', '?');
  ediDatumsformat.Text          := UpperCase(INI.ReadString('Format','Datumsformat', sDefDate));
  ediDatumsformat.Hint          := ediDatumsformat.Text;
  ediSollString.Text            := INI.ReadString('Format','SollHabenString', 'S');
  DelUntil1.Checked             := INI.ReadBool  ('Daten','LoescheBis1',true);
  ediDelStr1.Text               := INI.ReadString('Daten','LoeschStr1', 'SVWZ');
  DelFrom1.Checked              := INI.ReadBool  ('Daten','LoescheVon1',false);
  DelUntil2.Checked             := INI.ReadBool  ('Daten','LoescheBis2',false);
  ediDelStr2.Text               := INI.ReadString('Daten','LoeschStr2', 'ZV');
  DelFrom2.Checked              := INI.ReadBool  ('Daten','LoescheVon2',true);
  DelUntil3.Checked             := INI.ReadBool  ('Daten','LoescheBis3',true);
  ediDelStr3.Text               := INI.ReadString('Daten','LoeschStr3', '');
  DelFrom3.Checked              := INI.ReadBool  ('Daten','LoescheVon3',false);
  nBuchungstext.Value           := INI.ReadInteger('Daten','Buchungstext',0);
  nBuchungstextBis.Value        := INI.ReadInteger('Daten','BuchungstextBis',0);

  //Konvertierung notwendig?
  if INI.ValueExists('Daten','KeySK')
    then
      begin
        nKeySK.Value      := INI.ReadInteger('Daten','KeySK',0);
        nKeySKBis.Value   := INI.ReadInteger('Daten','KeySKBis',0);
        nKeyPers.Value    := INI.ReadInteger('Daten','KeyPers',0);
        nKeyPersBis.Value := INI.ReadInteger('Daten','KeyPersBis',0);
      end
    else
      begin
        //Konvertierung altes Format
        //alter Schlüssel war: Key + Buchungstext
        nKeySK.Value      := INI.ReadInteger('Daten','Key',0);       //altes Schlüsselfeld lesen
        nKeySK.Value      := min(nKeySK.Value, nBuchungstext.Value);
        nKeySKBis.Value   := nBuchungstextBis.Value;
        nKeyPers.Value    := nKeySK.Value;
        nKeyPersBis.Value := nKeySKBis.Value;
      end;

  cbBank.Items.Clear;
  frmDM.ZQueryHelp.SQL.Text := 'select * from Konten where Kontotype = "B" order by SortPos ';
  frmDM.ZQueryHelp.Open;
  while not frmDM.ZQueryHelp.EOF do
    begin
      cbBank.AddItem(frmDM.ZQueryHelp.FieldByName('Name').AsString, TObject(NativeInt(frmDM.ZQueryHelp.FieldByName('KontoNr').asinteger)));
      frmDM.ZQueryHelp.Next;
    end;
  frmDM.ZQueryHelp.Close;

  //Bank Nr suchen und CB richtig einstellen
  nHelp := INI.ReadInteger('Daten','BankNr', 0);
  if nHelp <> 0
    then
      begin
        for i := 0 to cbBank.Items.Count-1
          do
            begin
              if nHelp = NativeInt(cbBank.Items.Objects[i])
                then
                  begin
                    cbBank.ItemIndex:=i;
                    break;
                  end;
            end;
      end;
  INI.Free;

  WindowState                   := wsMaximized;
  bStartUp                      := false;
  DeltaDataClick(self);   //Liest die Datei ein
  SelectionChange(self);  //Zeigt den Header an
end;

procedure TfrmJournal_CSV_Import.SelectionChange(Sender: TObject);

var
  i : integer;
  s : string;

  Function S_Add(s, sAdd: string): string;

  begin
    result := '';
    if s <> '' then result := s +'; ';
    result := result + sAdd;
  end;

begin
  //Werte nur korrigiren, wenn sie nicht gerade bearbeitet werden
  if not (Sender = nDStart)
    then if nDStart.Value<=nHeader.Value
      then nDStart.Value := nHeader.Value+1;
  if not (Sender = nDEnd)
    then if nDEnd.Value < nDStart.Value
      then nDEnd.Value := nDStart.Value;

  //Header
  if not bStartup
    then
      if StringGridDaten.ColCount >= 1
        then
          for i := 1 to StringGridDaten.ColCount-1 do
            begin
              s := '';
              if (i = nDatum.Value)
                then s := S_Add(s, 'Datum');
              if (i = nBetrag.Value)
                then s := S_Add(s, 'Betrag');
              if (i = nSollHaben.Value)
                then s := S_Add(s, 'Soll_Haben');
              if (i = nKeySK.Value) or
                 ((nKeySKBis.Value > nKeySK.Value) and (i >= nKeySK.Value) and (i <= nKeySKBis.Value)) or
                 ((nKeySKBis.Value < nKeySK.Value) and ((i =  nKeySK.Value) or (i =  nKeySKBis.Value)) and (nKeySKBis.Value <> 0))
                then s := S_Add(s, 'Schlüssel(SK)');
              if (i = nKeyPers.Value) or
                 ((nKeyPersBis.Value > nKeyPers.Value) and (i >= nKeyPers.Value) and (i <= nKeyPersBis.Value)) or
                 ((nKeyPersBis.Value < nKeyPers.Value) and ((i =  nKeyPers.Value) or (i =  nKeyPersBis.Value)) and (nKeyPersBis.Value <> 0))
                then s := S_Add(s, 'Schlüssel(Pers)');
              if (i = nBuchungstext.Value) or
                 ((nBuchungstextBis.Value > nBuchungstext.Value) and (i >= nBuchungstext.Value) and (i <= nBuchungstextBis.Value) )or
                 ((nBuchungstextBis.Value < nBuchungstext.Value) and ((i =  nBuchungstext.Value) or (i =  nBuchungstextBis.Value)) and (nBuchungstextBis.Value <> 0))
                then s := S_Add(s, 'Buchungstext');
              StringGridDaten.Cells[i, 0] := trim(s);
            end;
  StringGridDaten.Refresh;
end;

procedure TfrmJournal_CSV_Import.StringGridDatenDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  with (Sender as TStringGrid) do
    begin
      if (ACol = 0)  // Don't change color for first Column
        then
          begin
            Canvas.Brush.Color := clBtnFace;
          end
        else
          begin
            if (gdSelected in aState)
              then
                begin
                  Canvas.Brush.Color := clHighlight;
                end
              else
                begin
                  Canvas.Brush.Color := clWindow;

                  if ARow = nHeader.Value                              then Canvas.Brush.Color := clGray;   //Kopf
                  if (ARow >= nDStart.Value) and (ARow <= nDEnd.Value) then Canvas.Brush.Color := clSilver; //Daten
                  //SK
                  if (ACol = nKeySK.Value) or
                     ((nKeySKBis.Value > nKeySK.Value) and (ACol >= nKeySK.Value) and (ACol <= nKeySKBis.Value)) or
                     ((nKeySKBis.Value < nKeySK.Value) and ((ACol =  nKeySK.Value) or (ACol =  nKeySKBis.Value)) and (nKeySKBis.Value <> 0))
                    then Canvas.Brush.Color := clAqua;
                  //Person
                  if (ACol = nKeyPers.Value) or
                     ((nKeyPersBis.Value > nKeyPers.Value) and (ACol >= nKeyPers.Value) and (ACol <= nKeyPersBis.Value)) or
                     ((nKeyPersBis.Value < nKeyPers.Value) and ((ACol =  nKeyPers.Value) or (ACol =  nKeyPersBis.Value)) and (nKeyPersBis.Value <> 0))
                    then Canvas.Brush.Color := clFuchsia;
                  //Buchungstext
                  if (ACol = nBuchungstext.Value) or
                     ((nBuchungstextBis.Value > nBuchungstext.Value) and (ACol >= nBuchungstext.Value) and (ACol <= nBuchungstextBis.Value) )or
                     ((nBuchungstextBis.Value < nBuchungstext.Value) and ((ACol =  nBuchungstext.Value) or (ACol =  nBuchungstextBis.Value)) and (nBuchungstextBis.Value <> 0))
                    then Canvas.Brush.Color := clYellow;
                  if (ACol = nDatum.Value)     then Canvas.Brush.Color := clLime;                  //Datum
                  if (ACol = nBetrag.Value)    then Canvas.Brush.Color := clSkyBlue;               //Betrag
                  if (ACol = nSollHaben.Value) then Canvas.Brush.Color := clMoneyGreen;            //Soll_Haben

                  Canvas.FillRect(aRect);
                  Canvas.TextRect(aRect, aRect.Left+4, aRect.Top, cells[acol, arow]);
                end;
          end;
    end;
end;

procedure TfrmJournal_CSV_Import.StringGridDatenSelection(Sender: TObject; aCol, aRow: Integer);
begin
  if StringGridDaten.Selection.Top > nHeader.Value
    then
      begin
        nDStart.Value := StringGridDaten.Selection.Top;
        nDEnd.Value   := StringGridDaten.Selection.Bottom;
      end;
end;


end.

