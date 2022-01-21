select
   LaufendeNr,
   strftime('%d.%m.%Y',Datum)                                     as Datum,
   ifnull(Betrag,'')                                              as Betrag,
   ifnull(Personen.Vorname,'')||' '||ifnull(Personen.Nachname,'') as Name,
   Buchungstext,
   Bemerkung,
   Belegnummer,
   (select '('||ifnull(journal.konto_nach,'')||') '||ifnull(konten.Name,'') from konten where journal.konto_nach = konten.KontoNr) as Sachkonto,
   (select name from konten where journal.BankNr = konten.KontoNr) as Bank,
   CAST((select Anfangssaldo from Bankenabschluss where journal.BankNr = Bankenabschluss.KontoNr) as text) as Saldo, 
   journal.BankNr as BankNr,
   journal.konto_nach as konto_nach
from journal

left join Personen        on  journal.PersonenID   = Personen.PersonenID

where (journal.Buchungsjahr=:BJAHR) :AddWhere

order by journal.BankNr, journal.LaufendeNr