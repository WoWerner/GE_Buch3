select
   LaufendeNr,
   Belegnummer,
   strftime('%d.%m.%Y',Datum)                                      as Datum,
   journal.BankNr as BankNr,
   (select name from konten where journal.BankNr = konten.KontoNr) as Bank,
   journal.konto_nach                                              as konto_nach,
   (select '('||ifnull(journal.konto_nach,'')||') '||ifnull(konten.Name,'') from konten where journal.konto_nach = konten.KontoNr) as Sachkonto,
   ifnull(Betrag,'')                                               as Betrag,
   Buchungstext,
   ifnull(Personen.Vorname,'')||' '||ifnull(Personen.Nachname,'')  as Name,
   Bemerkung,
   CAST((select Anfangssaldo from Bankenabschluss where journal.BankNr = Bankenabschluss.KontoNr) as text) as Saldo, 
   (select Steuer from konten where journal.konto_nach = konten.KontoNr) as Steuer
from journal

left join Personen on journal.PersonenID   = Personen.PersonenID

where (journal.Buchungsjahr=:BJAHR) :AddWhere

order by journal.BankNr, journal.LaufendeNr