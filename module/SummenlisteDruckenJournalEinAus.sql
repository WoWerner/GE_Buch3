select sachkonten.SachkontoNr as SachkontoNr,
       sachkonten.Sachkonto as Sachkonto,
       journal.BuchungsJahr as BuchungsJahr,
       sum(journal.Betrag) as Summe
from sachkonten
cross join journal on sachkonten.SachkontoNr=journal.SachkontoNr
where (journal.BuchungsJahr=:BJAHR or journal.BuchungsJahr=:BJAHR-1) and (sachkonten.kontotype = :TYP) :AddWhere 
Group by journal.BuchungsJahr, journal.SachkontoNr
order by sachkonten.SortPos