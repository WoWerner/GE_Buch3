select banken.BankNr as BankNr,
       banken.Bank as Bank,
       journal.BuchungsJahr as BuchungsJahr,
       sum(journal.Betrag) as Summe
from banken
left join journal on journal.BankNr=banken.BankNr
where (journal.BuchungsJahr=:BJAHR or journal.BuchungsJahr=:BJAHR-1) and 
      (journal.SachkontoNr = 1) :AddWhere
Group by journal.BankNr, journal.BuchungsJahr