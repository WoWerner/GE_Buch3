unit uStrToDateFmt;

{
Code von Sir Rufo www.delphipraxis.net

 StrToDateFmt( '20100621', 'YYYYMMDD') => 21.06.2010
 StrToDateFmt( '21.06.2010', 'DD.MM.YYYY') => 21.06.2010
 StrToDateFmt( '21/06/2010', 'DD/MM/YYYY') => 21.06.2010
 
Als besonderes Schmankerl kannst du auch eine Format-Liste mitgeben.
 StrToDateFmt( '20100621', [ 'DD.MM.YYYY', 'DD/MM/YYYY', 'YYYYMMDD' ] ) => 21.06.2010
 StrToDateFmt( '21.06.2010', [ 'DD.MM.YYYY', 'DD/MM/YYYY', 'YYYYMMDD' ] ) => 21.06.2010
 StrToDateFmt( '21/06/2010', [ 'DD.MM.YYYY', 'DD/MM/YYYY', 'YYYYMMDD' ] ) => 21.06.2010

 StrToDateFmt( DatumStr,     [ 'DD.MM.YYYY', 'D.MM.YYYY', 'DD.M.YYYY', 'D.M.YYYY', 'DD.MM.YY', 'D.MM.YY', 'DD.M.YY', 'D.M.YY', 'DDMMYY', 'DDMMYYYY','YY-MM-DD', 'YYYY-MM-DD'])
Das Datum 01.06.2010 wird jetzt aus folgenden Eingaben korrekt erkannt:
                                01.06.2010,   1.06.2010,   01.6.2010,   1.6.2010,   01.06.10,   1.06.10,   01.6.10,   1.6.10,   010610,   01062010,  10-06-01,   2010-06-01
}

interface
 
 function TryStrToDateFmt( const AStr, AFmt : string; var AResult : TDateTime ) : Boolean; overload;
 function TryStrToDateFmt( const AStr : string; const AFmt : array of string; var AResult : TDateTime ) : Boolean;  overload;
 function StrToDateFmt( const AStr, AFmt : string ) : TDateTime; overload;
 function StrToDateFmt( const AStr : string; const AFmt : array of string ) : TDateTime; overload;
 function StrToDateFmtDef( const AStr, AFmt : string; const default : TDateTime ) : TDateTime; overload;
 function StrToDateFmtDef( const AStr : string; const AFmt : array of string; const default : TDateTime ) : TDateTime; overload;
 
implementation
 
uses
   SysUtils;

function StrToDateFmtDef( const AStr, AFmt : string; const default : TDateTime ) : TDateTime;
   begin
     if not TryStrToDateFmt( AStr, AFmt, Result ) then
       Result := default;
   end;
 
function StrToDateFmtDef( const AStr : string; const AFmt : array of string; const default : TDateTime ) : TDateTime;
   begin
     if not TryStrToDateFmt( AStr, AFmt, Result ) then
       Result := default;
   end;
 
function StrToDateFmt( const AStr, AFmt : string ) : TDateTime;
   begin
     if not TryStrToDateFmt( AStr, AFmt, Result ) then
       raise Exception.Create('Ungültiges Datumsformat in '+AStr);
   end;
 
function StrToDateFmt( const AStr : string; const AFmt : array of string ) : TDateTime;
   begin
     if not TryStrToDateFmt( AStr, AFmt, Result ) then
       raise Exception.Create('Ungültiges Datumsformat in '+AStr);
   end;
 
function TryStrToDateFmt( const AStr : string; const AFmt : array of string; var AResult : TDateTime ) : Boolean;
   var
     idx : Integer;
   begin
     Result := False;
     idx := low( AFmt );
     while not Result and ( idx <= high( AFmt ) ) do
       begin
         Result := Result or TryStrToDateFmt( AStr, AFmt[ idx ], AResult );
         Inc( idx );
       end;
   end;
 
function TryStrToDateFmt( const AStr, AFmt : string; var AResult : TDateTime ) : Boolean;
   var
     dps      : string;
     dpi, fpi : Integer;
     d, m, y : Word;
     idx, yl : Integer;
     shelp : string;
   begin
     Result := Length( AFmt ) = Length( AStr );
     d := 0;
     m := 0;
     y := 0;
     yl := 0;
     idx := 1;
     while Result and ( idx <= Length( AFmt ) ) do
       begin
         dps := Copy( AStr, idx, 1 );
         dpi := StrToIntDef( dps, -1 );

         sHelp := Copy( AFmt, idx, 1 );
         if (sHelp='D') then
           fpi := 0
         else if (sHelp='M') then
           fpi := 1
         else if (sHelp='Y') then
           fpi := 2
         else fpi := -1;
 
        // Wenn wir einen Platzhalter erwischt haben, dann müssen wir dazu auch eine Ziffer haben
         Result := not( ( fpi >= 0 ) and ( dpi < 0 ) );
 
        case fpi of
           0 : // Tag
             d := d * 10 + dpi;
           1 : // Monat
             m := m * 10 + dpi;
           2 : // Jahr
             begin
               y := y * 10 + dpi;
               Inc( yl );
             end;
         else // Format-Zeichen prüfen
           Result := ( dps = Copy( AFmt, idx, 1 ) );
         end;
         Inc( idx );
       end;
 
    if Result then
       begin
         // kurze Jahreszahl mit dem aktuellen Jahr erweitern
         case yl of
           0 : // kein Jahr übergeben
             y := CurrentYear;
           1 : // Jahr einstellig übergeben
             if Abs( y - CurrentYear mod 10 ) > 2 then
               y := ( CurrentYear div 10 - 1 ) * 10 + y
             else
               y := CurrentYear div 10 * 10 + y;
           2 : // Jahr zweistellig übergeben
             if Abs( y - CurrentYear mod 100 ) > 10 then
               y := ( CurrentYear div 100 - 1 ) * 100 + y
             else
               y := CurrentYear div 100 * 100 + y;
           3 : // Jahr dreistellig übergeben
             if Abs( y - CurrentYear mod 1000 ) > 10 then
               y := ( CurrentYear div 1000 - 1 ) * 1000 + y
             else
               y := CurrentYear div 1000 * 1000 + y;
         end;
       end;
 
    if Result then
       Result := TryEncodeDate( y, m, d, AResult );
   end;
 
end. 
