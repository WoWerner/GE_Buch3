unit global;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

const
  sEMailAdr            = 'mail@w-werner.de';
  sHomePage            = 'www.w-werner.de';
  sFehltNoch           = 'Diese Funktion fehlt noch.'+#13#10+
                         'Wenn Sie sie brauchen, melden Sie sich.';
  sUpdatePersonenCheck = 'BriefAnrede'+#13#10+
                         'Titel'+#13#10+
                         'Vorname'+#13#10+
                         'Vorname2'+#13#10+
                         'Nachname'+#13#10+
                         'Strasse'+#13#10+
                         'Land'+#13#10+
                         'PLZ'+#13#10+
                         'Ort'+#13#10+
                         'Ortsteil'+#13#10+
                         'TelPrivat'+#13#10+
                         'TelDienst'+#13#10+
                         'TelMobil'+#13#10+
                         'Geburtstag'+#13#10+
                         'Abgang'+#13#10+
                         'eMail';
  sInsertPersonen      = 'insert into personen (GE_KartID, BriefAnrede, Titel, Vorname, Vorname2, Nachname, Strasse, Land, PLZ, Ort, Ortsteil, TelPrivat, TelDienst, TelMobil, eMail, Geburtstag, Abgang, Notiz, Gemeindeglied) values '+
                                               '(%d,       "%s",        "%s",  "%s",    "%s",     "%s",     "%s",    "%s", "%s","%s","%s",     "%s",      "%s",      "%s",     "%s",  %s,         "%s",   "",    "true");';
  sInsertJournal       = 'insert into journal (Datum, konto_nach, BankNr, PersonenID, Betrag, Buchungstext, Belegnummer, BuchungsJahr, Bemerkung, Aufwandsspende) values '+
                                           '(%s, %s, %s, %s, %d, "%s", "%s", %d, "%s", "%s")';
  sSelectPersonenSort  = 'select * from Personen order by Nachname COLLATE NOCASE, Vorname COLLATE NOCASE, Ort COLLATE NOCASE, Strasse COLLATE NOCASE';
  sSelectJournal       = 'select journal.*, ' +
                         'ifnull(Personen.Vorname,'''')||'' ''||ifnull(Personen.Nachname,'''') as Name, '+
                         'strftime(''%%Y%%m%%d'',journal.Datum) as SortDate '+
                         'from journal '+
                         'left join Personen on journal.PersonenID = Personen.PersonenID '+
                         'where BuchungsJahr = %s '+
                         'order by ';
  sGetLastBelegNr      = 'SELECT Belegnummer '+
                         'FROM journal '+
                         'where Buchungsjahr=%s '+
                         'ORDER BY laufendenr DESC '+
                         'LIMIT 1;';
  sSteuerDef           = ',Umsatzsteuerfrei,Nicht umsatzsteuerbar,Umsatzsteuerpflichtig 7%,Umsatzsteuerpflichtig 19%';
  nDefDPI              = 96;
  CSV_Delimiter        = ';';
  sJa                  = 'Ja';
  sNein                = 'Nein';
  KeyDelChars          = [' ', ',', '.', ':', '_', '-', '+', '*'];

var
  sAktuelles           : String;
  sAppDir              : String;
  sDatabase            : String;
  sDebugFile           : String;
  sFinanzamt           : String;
  sFinanzamtNr         : String;
  sFinanzamtVom        : String;
  sGemeindeAdr         : string;
  sGemeindeAdr2        : string;
  sGemeindeName        : string;
  sGemeindeOrt         : string;
  sImportPath          : String;
  sIniFile             : String;
  sJournalCSVImportINI : string = 'JournalCSVImport.ini';
  sPW                  : String;
  sProductVersionString: String;
  sRendantAdr          : String;
  sRendantOrt          : String;
  sRendantEMail        : String;
  sEMailServer         : String;
  sEMailPort           : String;
  sEMailUsername       : String;
  sEMailServerPassWort : String;
  sSavePath            : String;
  sPrintPath           : String;
  sSteuer              : String;
  nBuchungsjahr        : integer;
  bSQLDebug            : boolean;
  bCleanUpRequired     : boolean;
  bJournalJump         : boolean;
  bJournalLast         : boolean;
  WorkArea             : TRect;
  MaxWindowsSize       : TRect;
  VirtualScreenSize    : TRect;

implementation

end.

