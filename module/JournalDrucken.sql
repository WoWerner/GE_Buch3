select
   LaufendeNr,
   strftime('%d.%m.%Y',Datum)                                     as Datum,
   journal.PersonenID                                             as PersonenNr, 
   ifnull(Personen.Vorname,'')||' '||ifnull(Personen.Nachname,'') as Name,
   journal.BankNr                                                 as BankNr,
   ifnull(Banken.Bank,'')     ||' '||ifnull(Banken.Konto,'')      as Bank,
   journal.SachkontoNr                                            as SachkontoNr,
   Sachkonten.Sachkonto,
   ifnull(Betrag,'')                                              as Betrag,
   ifnull(bankenabschluss.Anfangssaldo,'')                        as Saldo,
   Buchungstext,
   Belegnummer,
   Bemerkung
from journal

left join Personen        on  journal.PersonenID   = Personen.PersonenID
left join Banken          on  journal.BankNr       = Banken.BankNr
left join Sachkonten      on  journal.SachkontoNr  = Sachkonten.SachkontoNr
left join bankenabschluss on (journal.BankNr       = bankenabschluss.BankNr) and
                             (journal.BuchungsJahr = bankenabschluss.Buchungsjahr)

where (journal.Buchungsjahr=:BJAHR) :AddWhere

order by journal.BankNr, journal.LaufendeNr