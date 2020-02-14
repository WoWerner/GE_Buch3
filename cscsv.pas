Unit csCSV;
(******************************************************************************
 * CSV Reader Klasse                                                          *
 * Liest eine CSV-Datei ein und ermöglicht Zugriff auf die einzelnen Elemente *
 * jeder Zeile.                                                               *
 * Eine CSV ('Comma Separated Values' oder 'Character Separated Values' ist   *
 * ein Format, um Tabellen in einer Text-Datei zu speichern.                  *
 * Dabei werden die einzelnen Elemente einer Tabellenzeile durch ein frei     *
 * wählbares Zeichen getrennt. In Deutschland ist dies üblicherweise das      *
 * Semikolon, im englischsprachigen Raum das Komma (daher der Name).          *
 * Strings werden druch Quotes '"' eingeschlossen, ein Quote innerhalb eines  *
 * Strings wird verdoppelt.                                                   *
 * Beispiel (Trennzeichen';'):                                                *
 * "Text";123;"Text mit ""Quotes"" und Semikolon;";;Auch ein Text;345.657     *
 *                                                                            *
 * Der Code ist so trivial, das ein Copyright nicht lohnt.                    *
 *                                                                            *
 * Verwendung                                                                 *
 *   -- Bereitstellen eines Streams, z.B. TFileStream                         *
 *                                                                            *
 * csvReader := TCSVReader.Create (CSVDAtaStream, ';');                       *
 * While not csvReader.Eof Do Begin                                           *
 *   For i:=0 to csvReader.ColumnCount - 1 Do                                 *
 *     Memo.Lines.Add (csvReader.Columns[i]);                                 *
 *   csvReader.Next;                                                          *
 * End;                                                                       *
 ******************************************************************************)
Interface

Uses
  Classes,
  SysUtils;

Type
  TStringPos = Record
    spFirst: PChar;
    spLen: Integer;
  End;

  TCSVReader = Class
  private
    fBuffer, fPos, fEnd: PChar;
    fSize: Integer;
    fStream: TStream;
    fQuote, fDelimiter: Char;
    fAtEOF, fIsEOF: Boolean;
    fColumns: Array Of TStringPos;
    fColumnCount: Integer;
    fEOLChar: Char;
    fEOLLength: Integer;
    Function GetColumnByIndex(Index: Integer): String;
    Procedure SetEOLChar(Const Value: Char);
    Procedure Initialize;
  public
// Wenn kein Delimiter angegeben wird, wird das Listentrennzeichen aus den
// internationalen Einstellungen von Windows verwendet.
    Constructor Create(aStream: TStream; aDelimiter: Char = #0);
    Destructor Destroy; override;
// Bewegt den internen Positionszeiger auf die erste Zeile der Datei
    Procedure First;
// Bewegt den internen Positionszeiger auf die nächste Zeile der Datei
    Procedure Next;
// Liefert TRUE, wenn keine Daten mehr abgerufen werden können.
    Function Eof: Boolean;
// Liefert oder setzt das Trennzeichen
    Property Delimiter: Char read fDelimiter write fDelimiter;
// Liefert oder setzt das Quote-Zeichen
    Property Quote: Char read fQuote write fQuote;
// Liefert oder setzt das EOL-Zeichen (Windows #13, UNIX #10)
    Property EOLChar: Char read fEOLChar write SetEOLChar;
// Liefert oder setzt die Länge der EOL-Zeichen (Windows : 2 [CR+LF], UNIX: 1 [LF])
    Property EOLLength: Integer read fEOLLength write fEOLLength;
// Liefert die Anzahl der Elemente der aktuellen Zeile
    Property ColumnCount: Integer read fColumnCount;
// Liefert die einzelnen Elemente der aktuellen Zeile
    Property Columns[Index: Integer]: String read GetColumnByIndex; default;
  End;
Implementation

{ TCSVReader }

Constructor TCSVReader.Create(aStream: TStream; aDelimiter: Char);
Begin
  fStream := aStream;
  fSize := fStream.Size - fStream.Position + 2;
  fBuffer := GetMemory(fSize);
  fPos := fBuffer;
  aStream.Read(fBuffer^, fSize);
  fEOLChar := #13;
  fEOLLength := 2;
  fBuffer[fSize - 2] := fEOLChar;
  fBuffer[fSize - 1] := #0;
  fEnd := fBuffer + fSize - 1;
  If aDelimiter = #0
    then fDelimiter := DefaultFormatSettings.ListSeparator
    else fDelimiter := aDelimiter;
  fQuote := '"';
  setLength(fColumns, 100);
  Initialize;
End;

Destructor TCSVReader.Destroy;
Begin
  FreeMemory(fBuffer);
  Inherited;
End;

Function TCSVReader.Eof: Boolean;
Begin
  Result := fIsEOF;
End;

Procedure TCSVReader.First;
Begin
  Initialize;
  Next;
End;

Function TCSVReader.GetColumnByIndex(Index: Integer): String;
Var
  p: PChar;
  i, l: Integer;

Begin
  With fColumns[Index] Do
    If spLen = 0 Then
      Result := ''
    Else If spFirst^ = fQuote Then Begin
      setLength(Result, spLen - 2);
      p := spFirst + 1;
      l := spLen - 2;
      For i := 1 To spLen - 2 Do Begin
        Result[i] := p^;
        If (p^ = fQuote) And (p[1] = fQuote) Then Begin
          dec(l);
          inc(p, 2)
        End
        Else
          inc(p);
      End;
      SetLength(Result, l);
    End
    Else
      SetString(Result, spFirst, spLen);
End;

Procedure TCSVReader.Initialize;
Begin
  fPos := fBuffer;
  fIsEOF := False;
  fAtEOF := False;
  fColumnCount := 0;
End;

Procedure TCSVReader.Next;
Var
  p: PChar;
  pPrev: PChar;

  Procedure _GetString;
  Begin
    Repeat
      inc(p);
      If p^ = fQuote Then
        If p[1] = fQuote Then
          inc(p)
        Else
          break;
    Until False;
    inc(p);
  End;

Begin
  pPrev := fPos;
  p := fPos;
  fColumnCount := 0;
  If fAtEOF Then
    If Eof
      Then
        Raise exception.Create('Try to read past eof')
      Else
        Begin
          fIsEOF := True;
          Exit;
        End;
  If p^ = fQuote Then _GetString;
  While p^ <> fEOLChar Do
    Begin
      If p^ = fDelimiter
        Then
          Begin
            If fColumnCount = Length(fColumns) Then SetLength(fColumns, 2 * Length(fColumns));
            fColumns[fColumnCount].spFirst := pPrev;
            fColumns[fColumnCount].spLen := p - pPrev;
            inc(fColumnCount);
            inc(p);
            pPrev := p;
            If p^ = fQuote Then _GetString;
          End
        Else inc(p);
    End;
  If p <> fPos Then
    Begin
      If fColumnCount = Length(fColumns) Then SetLength(fColumns, Length(fColumns) + 1);
      fColumns[fColumnCount].spFirst := pPrev;
      fColumns[fColumnCount].spLen := p - pPrev;
      inc(fColumnCount);
    End;
  fPos := p;
  If (fPos[1] = #0)
    Then fAtEOF := True
    Else inc(fPos, fEOLLength);
End;

Procedure TCSVReader.SetEOLChar(Const Value: Char);
Begin
  If fEOLChar <> Value Then
    Begin
      fEOLChar := Value;
      fBuffer[fSize - 2] := fEOLChar;
    End;
End;

End.

